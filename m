From: Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH] BUG: nr_phys_segments cannot be less than nr_hw_segments
Date: Thu, 2 Oct 2008 20:35:10 +0530
Message-ID: <200810022035.10996.knikanth@suse.de>
References: <200810021959.33616.knikanth@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:52194 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbYJBPGE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2008 11:06:04 -0400
In-Reply-To: <200810021959.33616.knikanth@suse.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Thursday 02 October 2008 19:59:33 Nikanth Karthikesan wrote:
> This is a follow-up to my earlier mail http://lkml.org/lkml/2008/9/23/294
> ([PATCH] BUG: ll_merge_requests_fn() updates req->nr_phys_segments wrongly)
>
> It is possible for the merging code to create lesser no of phys segments
> than hw segments, but every hw segment needs atleast one new phys segment.
> This triggers the BUG() on scsi_init_sgtable() as blk_rq_map_sg() returns
> more no of segments than rq->nr_phys_segments
>
> The following blktrace shows a sequence of bio's to trigger such condition
> on my machine with max_sectors_kb=512 & max_hw_sectors_kb=32767.
>
>   8,0    0       12     1.943680621  2261  Q   R 6184075 + 55 [bash]
>   8,0    0       13     1.943684671  2261  G   R 6184075 + 55 [bash]
>   8,0    0       14     1.943690189  2261  P   N [bash]
>   8,0    0       15     1.943692075  2261  I   R 6184075 + 55 [bash]
>   8,0    0       16     1.943712119  2261  D   R 6184075 + 55 [bash]
>   8,0    0       17     1.943718684  2261  Q   R 6184130 + 55 [bash]
>   8,0    0       18     1.943721897  2261  G   R 6184130 + 55 [bash]
>   8,0    0       19     1.943726576  2261  P   N [bash]
>   8,0    0       20     1.943727763  2261  I   R 6184130 + 55 [bash]
>   8,0    0       21     1.943731675  2261  Q   R 6184241 + 56 [bash]
>   8,0    0       22     1.943735167  2261  G   R 6184241 + 56 [bash]
>   8,0    0       23     1.943739497  2261  I   R 6184241 + 56 [bash]
>   8,0    0       24     1.943742081  2261  Q   R 6184185 + 56 [bash]
>   8,0    0       25     1.943744875  2261  M   R 6184185 + 56 [bash]
>   8,0    0       26     1.943753535  2261  Q   R 6184352 + 55 [bash]
>   8,0    0       27     1.943756538  2261  G   R 6184352 + 55 [bash]
>   8,0    0       28     1.943760868  2261  I   R 6184352 + 55 [bash]
>   8,0    0       29     1.943763522  2261  Q   R 6184407 + 55 [bash]
>   8,0    0       30     1.943766316  2261  M   R 6184407 + 55 [bash]
>   8,0    0       31     1.943770506  2261  Q   R 6184297 + 55 [bash]
>   8,0    0       32     1.943772951  2261  F   R 6184297 + 55 [bash]
>   8,0    0       33     1.943780843  2261  Q   R 6184462 + 55 [bash]
>   8,0    0       34     1.943783776  2261  M   R 6184462 + 55 [bash]
>   8,0    0       35     1.944444684     0 UT   N [swapper] 2
>   8,0    0       36     1.944453624    10  U   N [kblockd/0] 2
>   8,0    0       37     1.944470595    10  D   R 6184130 + 387 [kblockd/0]
>   8,0    0       38     1.970340853     0  C   R 6184075 + 55 [0]
>   8,0    0       39     1.973576739     0  C   R 6184130 + 387 [0]
>
> 
Oops, that was incomplete information to reproduce the issue.

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

		
// Allocate Memory.
char *Mem0 = kmalloc(dbMemList[0].IoSize, GFP_KERNEL);
char *Mem1 = kmalloc(dbMemList[1].IoSize, GFP_KERNEL);
char *Mem2 = kmalloc((dbMemList[2].IoSize + dbMemList[3].IoSize + 
dbMemList[4].IoSize), GFP_KERNEL);
char *Mem5 = kmalloc(dbMemList[5].IoSize, GFP_KERNEL);
char *Mem6 = kmalloc(dbMemList[6].IoSize, GFP_KERNEL);
char *Mem7 = kmalloc(dbMemList[7].IoSize, GFP_KERNEL);

dbMemList[0].Mem = Mem0;
dbMemList[1].Mem = Mem1;
dbMemList[2].Mem = Mem2;
dbMemList[3].Mem = dbMemList[2].Mem + dbMemList[2].IoSize;
dbMemList[4].Mem = dbMemList[3].Mem + dbMemList[3].IoSize;
dbMemList[5].Mem = Mem5;
dbMemList[6].Mem = Mem6;
dbMemList[7].Mem = Mem7;


int			Loop;
struct bio		*BioList[NUM_BIO]	= { NULL };
struct bio		*Bio			= NULL;
long			Sector;


/*
** Allocate BIOs.
*/
for(Loop = 0; Loop < NUM_BIO; Loop++)
	BioList[Loop] = bio_alloc(GFP_KERNEL, NUMBER_OF_VECS);

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
			printk("NIK: bio add page failed- %dA\n", Loop);
		}
		if (!bio_add_page(BioList[Loop],
				virt_to_page(dbMemList[7].Mem),
				0x3e00,
				offset_in_page(dbMemList[7].Mem))) {
			printk("NIK: bio add page failed- %dB\n", Loop);
		}
	} else if (Loop == 7) {
		if (!bio_add_page(BioList[Loop],
				virt_to_page(dbMemList[Loop].Mem),
				0x2000,
				offset_in_page(dbMemList[Loop].Mem))) {
			printk("NIK: bio add page failed- %dA\n", Loop);
		}
		if (!bio_add_page(BioList[Loop],
				virt_to_page(dbMemList[7].Mem),
				0x4e00,
				offset_in_page(dbMemList[7].Mem))) {
			printk("NIK: bio add page failed- %dB\n", Loop);
		}
	} else if (!bio_add_page(BioList[Loop],
				virt_to_page(dbMemList[Loop].Mem),
				dbMemList[Loop].IoSize,
				offset_in_page(dbMemList[Loop].Mem))) {
		printk("NIK: bio add page failed %d\n", Loop);
	}
	Sector += (Bio->bi_size / 512);
}

submit_bio(READ, BioList[0]);	// 1
submit_bio(READ, BioList[1]);	// 2
submit_bio(READ, BioList[3]);	// 4
submit_bio(READ, BioList[2]);	// 3
submit_bio(READ, BioList[5]);	// 6
submit_bio(READ, BioList[6]);	// 7
submit_bio(READ, BioList[4]);	// 5
submit_bio(READ, BioList[7]);	// 8

Thanks
Nikanth Karthikesan
