From: Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH] BUG: nr_phys_segments cannot be less than nr_hw_segments
Date: Fri, 3 Oct 2008 10:58:33 +0530
Message-ID: <200810031058.34368.knikanth@suse.de>
References: <200810021959.33616.knikanth@suse.de> <1222967563.3222.30.camel@localhost.localdomain> <20081002171356.GO19428@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:54672 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbYJCF3t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Oct 2008 01:29:49 -0400
In-Reply-To: <20081002171356.GO19428@kernel.dk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Thursday 02 October 2008 22:43:57 Jens Axboe wrote:
> On Thu, Oct 02 2008, James Bottomley wrote:
> > On Thu, 2008-10-02 at 18:58 +0200, Jens Axboe wrote:
> > > On Thu, Oct 02 2008, James Bottomley wrote:
> > > > The bug would appear to be that we sometimes only look at
> > > > q->max_sectors when deciding on mergability.  Either we have to
> > > > insist on max_sectors <= hw_max_sectors, or we have to start using
> > > > min(q->max_sectors, q->max_hw_sectors) for this.
> > >
> > > q->max_sectors MUST always be <= q->max_hw_sectors, otherwise we could
> > > be sending down requests that are too large for the device to handle.
> > > So that condition would be a big bug. The sysfs interface checks for
> > > this, and blk_queue_max_sectors() makes sure that is true as well.
> >
> > Yes, that seems always to be enforced.  Perhaps there are other ways of
> > tripping this problem ... I'm still sure if it occurs it's because we do
> > a physical merge where a virtual merge is forbidden.
> >
> > > The fixes proposed still look weird. There is no phys vs hw segment
> > > constraints, the request must adhere to the limits set by both. It's
> > > mostly a moot point anyway, as 2.6.28 will get rid of the hw accounting
> > > anyway.
> >
> > Agree all three proposed fixes look wrong.  However, if it's what I
> > think, just getting rid of hw accounting won't fix the problem because
> > we'll still have the case where a physical merge is forbidden by iommu
> > constraints ... this still needs to be accounted for.
> >

Yes. This patch fixes it.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
---
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 5efc9e7..9c2fe49 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -392,7 +392,11 @@ static int ll_merge_requests_fn(struct request_queue *q, 
struct request *req,
 		return 0;
 
 	total_phys_segments = req->nr_phys_segments + next->nr_phys_segments;
-	if (blk_phys_contig_segment(q, req->biotail, next->bio))
+	if (blk_phys_contig_segment(q, req->biotail, next->bio) &&
+	    BIOVEC_VIRT_MERGEABLE(__BVEC_END(req->biotail),
+					__BVEC_START(next->bio)) &&
+	    !BIOVEC_VIRT_OVERSIZE(req->biotail->bi_hw_back_size
+					+ next->bio->bi_hw_front_size))
 		total_phys_segments--;
 
 	if (total_phys_segments > q->max_phys_segments)


> > What we really need is a demonstration of what actually is going
> > wrong ...
>
> Yep, IIRC we both asked for that the last time as well... Nikanth?

Sorry, I had already sent the blktrace and some code snippet that would 
reproduce the condition. Here is the module and user-space program that can 
trigger this condition.

diskbiomod.c
---

#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/blkdev.h>
#include <linux/miscdevice.h>
/*
** Shared between the driver module and application.
*/
#define MOD_NODE        "/dev/DiskBio"
#define MOD_NAME        "DiskBio"

/*
** IOCTLs
*/
#define DB_IOCTL_DISK           0x00000001
#define DB_IOCTL_GENDISK        0x00000002

/*
** MODULE Defines.
*/
MODULE_DESCRIPTION("DiskBio - Initiate Disk I/O Traffic");
MODULE_LICENSE("GPL");


/*
** Module Defines.
*/
#define MOD_VERSION	"09-11-2008-1"
#define NUM_BIO		8
#define NUMBER_OF_VECS	16
#define START_LBA	0x5e5c8b


/*
** Module Globals.
*/
static struct gendisk	*(*get_GenDisk)(dev_t, int *)	= NULL;
static int		ErrorsOccurred			= 0;


typedef struct {
	int	IoSize;
	char	*Mem;
} DB_MEM_LIST, *pDB_MEM_LIST;

DB_MEM_LIST	dbMemList[NUM_BIO] = {
	{ 0x6e00,	NULL },
	{ 0x6e00,	NULL },
	{ 0x7000,	NULL },
	{ 0x7000,	NULL },
	{ 0x6e00,	NULL },
	{ 0x6e00,	NULL },
	{ 0x6e00,	NULL },
	{ 0x6e00,	NULL },
};


/*
** Wait Queue.
*/
DECLARE_WAIT_QUEUE_HEAD(db_wait_queue);


/*
** db_end_io()
*/
static void/*int*/
db_end_io(struct bio *Bio,/* unsigned int Bytes_Done,*/ int Error)
{
	static int Completions = 0;

	if(Error) {
		++ErrorsOccurred;
		printk("%s: End_Io Error=0x%x\n", MOD_NAME, Error);
	}
	if(Bio->bi_size) {
		++ErrorsOccurred;
		printk("%s: End_Io bi_size=0x%x\n", MOD_NAME, Bio->bi_size);
	}

	if(++Completions < NUM_BIO) {
		return;//(0);
	}
	Completions = 0;

	wake_up(&db_wait_queue);
	return;//(0);
} /* end - db_end_io() */


/*
** db_do_io()
*/
static int
db_do_io(struct gendisk *GD)
{
	int			Loop;
	int			RC			= 0;
	struct bio		*BioList[NUM_BIO]	= { NULL };
	struct bio		*Bio			= NULL;
	struct block_device	*Bdev;
	long			Sector;

	/*
	** Get block device structure.
	*/
	Bdev = bdget_disk(GD, 0);
	if(!Bdev) {
		RC = -ENOMEM;
		goto OutOfHere;
	}

	/*
	** Allocate BIOs.
	*/
	for(Loop = 0; Loop < NUM_BIO; Loop++) {
		BioList[Loop] = bio_alloc(GFP_KERNEL, NUMBER_OF_VECS);
		if(!BioList[Loop]) {
			RC = -ENOMEM;
			goto OutOfHere;
		}
	}

	/*
	** Initialize the I/O.
	*/
	Sector = START_LBA;
	for(Loop = 0; Loop < NUM_BIO; Loop++) {
		Bio = BioList[Loop];
		Bio->bi_sector			= Sector;
		Bio->bi_bdev			= Bdev;
		Bio->bi_end_io			= db_end_io;
		if (Loop == 0) {
			if (!bio_add_page(BioList[Loop],
					virt_to_page(dbMemList[Loop].Mem),
					0x3000,
					offset_in_page(dbMemList[Loop].Mem))) {
				printk("bio add page failed- %dA\n", Loop);
			}
			if (!bio_add_page(BioList[Loop],
					virt_to_page(dbMemList[7].Mem),
					0x3e00,
					offset_in_page(dbMemList[7].Mem))) {
				printk("bio add page failed- %dB\n", Loop);
			}
		} else if (Loop == 7) {
			if (!bio_add_page(BioList[Loop],
					virt_to_page(dbMemList[Loop].Mem),
					0x2000,
					offset_in_page(dbMemList[Loop].Mem))) {
				printk("bio add page failed- %dA\n", Loop);
			}
			if (!bio_add_page(BioList[Loop],
					virt_to_page(dbMemList[7].Mem),
					0x4e00,
					offset_in_page(dbMemList[7].Mem))) {
				printk("bio add page failed- %dB\n", Loop);
			}
		} else if (!bio_add_page(BioList[Loop],
					virt_to_page(dbMemList[Loop].Mem),
					dbMemList[Loop].IoSize,
					offset_in_page(dbMemList[Loop].Mem))) {
			printk("bio add page failed %d\n", Loop);
		}
		Sector += (Bio->bi_size / 512);
	}
	ErrorsOccurred = 0;

	/*
	** Issue the I/Os.
	*/
	submit_bio(READ, BioList[0]);	// 1
	submit_bio(READ, BioList[1]);	// 2
	submit_bio(READ, BioList[3]);	// 4
	submit_bio(READ, BioList[2]);	// 3
	submit_bio(READ, BioList[5]);	// 6
	submit_bio(READ, BioList[6]);	// 7
	submit_bio(READ, BioList[4]);	// 5
	submit_bio(READ, BioList[7]);	// 8

	/*
	** Wait for the completion.
	*/
	sleep_on(&db_wait_queue);

	/*
	** Release the resources.
	*/
OutOfHere:
	for(Loop = 0; Loop < NUM_BIO; Loop++) {
		if(BioList[Loop]) bio_put(BioList[Loop]);
	}
	if(ErrorsOccurred)
		RC = -EIO;
	
	return(RC);
} /* end - db_do_io() */


/*
** db_ioctl
*/
static int
db_ioctl(struct inode *inode, struct file *file, uint Command, ulong Arg)
{
	int		Status	= 0;
	struct gendisk	*GenDisk;
	int		Part;
	char		*Mem0	= NULL;
	char		*Mem1	= NULL;
	char		*Mem2	= NULL;
	char		*Mem5	= NULL;
	char		*Mem6	= NULL;
	char		*Mem7	= NULL;

	switch(Command) {
	case DB_IOCTL_GENDISK:
		get_GenDisk = (void *)Arg;
		break;

	case DB_IOCTL_DISK:
		Arg = new_decode_dev(Arg);
		if(!get_GenDisk) {
			Status = -EADDRNOTAVAIL;
			break;
		}
		GenDisk = get_GenDisk(Arg, &Part);
		if(!GenDisk) {
			Status = -ENODEV;
			break;
		}

		/*
		** Allocate Memory.
		*/
		Mem0 = kmalloc(dbMemList[0].IoSize, GFP_KERNEL);
		Mem1 = kmalloc(dbMemList[1].IoSize, GFP_KERNEL);
		Mem2 = kmalloc((dbMemList[2].IoSize + dbMemList[3].IoSize + 
dbMemList[4].IoSize), GFP_KERNEL);
		Mem5 = kmalloc(dbMemList[5].IoSize, GFP_KERNEL);
		Mem6 = kmalloc(dbMemList[6].IoSize, GFP_KERNEL);
		Mem7 = kmalloc(dbMemList[7].IoSize, GFP_KERNEL);

		if(!Mem0 || !Mem1 || !Mem2 || !Mem5 || !Mem6 || !Mem7) {
			Status = -ENOMEM;
			goto OutOfHere2;
		}

		dbMemList[0].Mem = Mem0;
		dbMemList[1].Mem = Mem1;
		dbMemList[2].Mem = Mem2;
		dbMemList[3].Mem = dbMemList[2].Mem + dbMemList[2].IoSize;
		dbMemList[4].Mem = dbMemList[3].Mem + dbMemList[3].IoSize;
		dbMemList[5].Mem = Mem5;
		dbMemList[6].Mem = Mem6;
		dbMemList[7].Mem = Mem7;

		Status = db_do_io(GenDisk);

OutOfHere2:
		if(Mem0) kfree(Mem0);
		if(Mem1) kfree(Mem1);
		if(Mem2) kfree(Mem2);
		if(Mem5) kfree(Mem5);
		if(Mem6) kfree(Mem6);
		if(Mem7) kfree(Mem7);
		break;

	default:
		printk("%s: Unknown Ioctl Command (0x%x)\n.", MOD_NAME, Command);
		Status = -EINVAL;
		break;
	}

	return(Status);
} /* end db_ioctl() */


/*
** File operations structure.
*/
static struct file_operations	db_fops = {
	.owner		= THIS_MODULE,
	.ioctl		= db_ioctl,
};


/*
** Misc Device structure.
*/
static struct miscdevice db_miscdev = {
	MISC_DYNAMIC_MINOR,
	MOD_NAME,
	&db_fops,
};


/*
** db_init()
*/
int __init
db_init(void)
{
	int	Error = 0;

	printk("%s: Init: ENTER.\n", MOD_NAME);
	printk("%s: Version %s.\n", MOD_NAME, MOD_VERSION);

	Error = misc_register(&db_miscdev);
	if(Error)
		printk("%s: Misc Register Failure!\n", MOD_NAME);
	
	printk("%s: Init: DONE.\n", MOD_NAME);
	return(Error);
} /* end - db_init() */


/*
** db_exit()
*/
void __exit
db_exit(void)
{
	printk("%s: Exit: ENTER.\n", MOD_NAME);

	misc_deregister(&db_miscdev);
		
	printk("%s: Exit: DONE.\n", MOD_NAME);
} /* end - db_exit() */


/*
** Module Entry Points.
*/
module_init(db_init);
module_exit(db_exit);

---
The Userspace utility to send ioctl to the module.
diskbio.c
---

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <libgen.h>
/*
** Shared between the driver module and application.
*/
#define MOD_NODE        "/dev/DiskBio"
#define MOD_NAME        "DiskBio"

/*
** IOCTLs
*/
#define DB_IOCTL_DISK           0x00000001
#define DB_IOCTL_GENDISK        0x00000002

#define	DEVICE_BUF_SIZE	100
#define GET_GENDISK	"get_gendisk"

int
OpenNode(void)
{
	int		IoPtr;
	FILE		*Fd;
	char		Buf[DEVICE_BUF_SIZE];
	unsigned long	Symbol_get_gendisk	= 0;

	/*
	** Get the symbols we need so they can be sent to the driver.
	*/
	if((Fd = fopen("/proc/kallsyms", "r")) == NULL) {
		perror("open");
		fprintf(stderr, "Can Not Get Symbol Values!\n");
		return(-1);
	}

	/*
	** Scan the /proc/kallsyms file for the symbols and addresses.
	*/
	while(fgets(Buf, DEVICE_BUF_SIZE, Fd)) {
		unsigned long	SymbolAddress;
		char		Tag[DEVICE_BUF_SIZE];
		char		Name[DEVICE_BUF_SIZE];

		if(sscanf(Buf, "%lx %s %s", &SymbolAddress, Tag, Name) != 3)
			continue;

		/*
		** Check for a symbol match.
		*/
		if(!strcmp(Name, GET_GENDISK)) {
			Symbol_get_gendisk = SymbolAddress;
			break;
		}
	}

	/*
	** Done with this file.
	*/
	fclose(Fd);

	/*
	** Make sure we found all of the symbols.
	*/
	if(!Symbol_get_gendisk) {
		fprintf(stderr, "%s Symbol NOT Found!\n", GET_GENDISK);
		return(-1);
	}

	/*
	** Device node should be present. Try and open.
	*/
	if((IoPtr = open(MOD_NODE, O_RDWR)) == -1) {
		perror("open");
		fprintf(stderr, "Can Not Open Module Device '%s'!\n", MOD_NODE);
		fprintf(stderr, "Unload and Reload the Module.\n");
		return(-1);
	}

	/*
	** Send the symbol addresses to the module.
	*/
	if(ioctl(IoPtr, DB_IOCTL_GENDISK, Symbol_get_gendisk)) {
		perror("ioctl");
		fprintf(stderr, "Unable to Send GENDISK Symbol to Module!\n");
		close(IoPtr);
		return(-1);
	}

	return(IoPtr);
}

int
main(int argc, char *argv[])
{
	int		RC		= 0;
	int		IoPtr		= 0;
	int		DevPtr		= 0;
	unsigned long	DeviceNumber;
	struct stat	StatBuf;

	/*
	** Check Arguments.
	*/
	if(argc < 2) {
		fprintf(stderr, "Usage: %s /dev/sdX\n", basename(argv[0]));
		exit(1);
	}

	/*
	** Open the device node to the driver interface.
	*/
	if((IoPtr = OpenNode()) == -1) {
		exit(2);
	}

	/*
	** Open the device.
	*/
	DevPtr = open(argv[1], O_RDWR);
	if(DevPtr == -1) {
		perror("open");
		fprintf(stderr, "Open Failed for Device '%s'\n", argv[1]);
		RC = 3;
		goto out;
	}

	/*
	** Make sure the device is a block device.
	*/
	if(fstat(DevPtr, &StatBuf)) {
		perror("fstat");
		fprintf(stderr, "Unable to stat device '%s'.\n", argv[1]);
		RC=4;
		goto out;
	}
	if(!S_ISBLK(StatBuf.st_mode)) {
		fprintf(stderr, "Device '%s' not a block device.\n", argv[1]);
		RC = 5;
		goto out;
	}

	/*
	** Get Device Number.
	*/
	DeviceNumber = StatBuf.st_rdev;

	/*
	** Send the device number to the driver
	** so it can do an I/O for us.
	*/
	RC = ioctl(IoPtr, DB_IOCTL_DISK, DeviceNumber);
	if(RC) {
		perror("ioctl");
		fprintf(stderr, "Ioctl Failed (%d).\n", RC);
	}

out:
	if(DevPtr > -1)	close(DevPtr);
	if(IoPtr > -1)	close(IoPtr);
	exit(RC);
}


Thanks
Nikanth Karthikesan






