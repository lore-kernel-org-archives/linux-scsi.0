From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Patch] SCSI: Retrieve Cache Mode Using SG_ATA_16 if normal
 routine fails
Date: Tue, 11 Oct 2011 10:19:57 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1110111010210.2177-100000@iolanthe.rowland.org>
References: <CADDb1s2=Ykh711grVjHV542pVJwpf1K+zzTRVEY2KH3T=wB_xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADDb1s2=Ykh711grVjHV542pVJwpf1K+zzTRVEY2KH3T=wB_xg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NamJae Jeon <linkinjeon@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 11 Oct 2011, Amit Sahrawat wrote:

> SCSI: Retrieve Cache Mode Using SG_ATA_16 if normal routine fails
> 
> It has been observed that a number of USB HDD's do not respond correctly
> to SCSI mode sense command(retrieve caching pages) which results in their
> Write Cache being discarded by queue requests i.e., WCE if left set to
> '0'(disabled). So, in order to identify the devices correctly - give it
> a last try using SG_ATA_16 after failure from normal routine.
> 
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> 
> diff -Nurp linux-Orig/drivers/scsi/sd.c linux-Updated/drivers/scsi/sd.c
> --- linux-Orig/drivers/scsi/sd.c	2011-10-11 11:02:48.000000000 +0530
> +++ linux-Updated/drivers/scsi/sd.c	2011-10-11 11:10:09.000000000 +0530
> @@ -56,6 +56,7 @@
>  #include <asm/uaccess.h>
>  #include <asm/unaligned.h>
> 
> +#include <scsi/sg.h>
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_dbg.h>
> @@ -134,6 +135,58 @@ static const char *sd_cache_types[] = {
>  	"write back, no read (daft)"
>  };
> 
> +/* Relevant Structure and Function to be used to Retrieve
> + * Caching Information from USB HDD - this is picked from
> + * source code of 'hdparm'
> + *
> + *
> + * Definitions and structures for use with SG_IO + ATA_16:
> + * */
> +#define SG_ATA_16               0x85
> +#define SG_ATA_16_LEN           16
> +
> +#define ATA_OP_IDENTIFY		0xec
> +
> +/*
> + * Some useful ATA register bits
> + */
> +enum {
> +        ATA_USING_LBA           = (1 << 6),
> +        ATA_STAT_DRQ            = (1 << 3),
> +        ATA_STAT_ERR            = (1 << 0),
> +};
> +
> +struct ata_lba_regs {
> +        __u8    feat;
> +        __u8    nsect;
> +        __u8    lbal;
> +        __u8    lbam;
> +        __u8    lbah;
> +};
> +struct ata_tf {
> +        __u8                    dev;
> +        __u8                    command;
> +        __u8                    error;
> +        __u8                    status;
> +        __u8                    is_lba48;
> +        struct ata_lba_regs     lob;
> +        struct ata_lba_regs     hob;
> +};

Don't these things already exist in some standard header file?  If not, 
shouldn't they be added in a more central location?

> +__u64 tf_to_lba (struct ata_tf *tf)
> +{
> +        __u32 lba24, lbah;
> +        __u64 lba64;
> +
> +        lba24 = (tf->lob.lbah << 16) | (tf->lob.lbam << 8) | (tf->lob.lbal);
> +        if (tf->is_lba48)
> +                lbah = (tf->hob.lbah << 16) | (tf->hob.lbam << 8) |
> (tf->hob.lbal);
> +        else
> +                lbah = (tf->dev & 0x0f);
> +        lba64 = (((__u64)lbah) << 24) | (__u64)lba24;
> +        return lba64;
> +}
> +
>  static ssize_t
>  sd_store_cache_type(struct device *dev, struct device_attribute *attr,
>  		    const char *buf, size_t count)
> @@ -1839,6 +1892,18 @@ sd_read_cache_type(struct scsi_disk *sdk
>  	int old_rcd = sdkp->RCD;
>  	int old_dpofua = sdkp->DPOFUA;
> 
> +	struct ata_tf tf;
> +	struct sg_io_hdr io_hdr;
> +	unsigned char cdb[SG_ATA_16_LEN] = {0};
> +	unsigned char sb[32] = {0};
> +	unsigned char buf[512] = {0};

Arrays generally should not have static initializers.  Also, a 512-byte
array is too large to allocate on the stack.  And there's already a
512-byte array available -- it's named "buffer".

> +	unsigned short wce_word = 0;

There's no reason to initialize this variable.

> +	void *data_cmd = buf;

Why do you need to alias a perfectly good variable?

> +
> +	memset(cdb, 0, SG_ATA_16_LEN);
> +	memset(&tf, 0, sizeof(struct ata_tf));
> +	memset(&io_hdr, 0, sizeof(struct sg_io_hdr));

There's no point initializing these things before you know that they 
will be used.

> +
>         first_len = 4;
>         if (sdp->skip_ms_page_8) {
>                 if (sdp->type == TYPE_RBC)
> @@ -1961,7 +2026,6 @@ Page_found:
>  				  sdkp->DPOFUA ? "supports DPO and FUA"
>  				  : "doesn't support DPO or FUA");
> 
> -		return;
>  	}
> 
>  bad_sense:
> @@ -1974,8 +2038,64 @@ bad_sense:
>  		sd_printk(KERN_ERR, sdkp, "Asking for cache data failed\n");
> 
>  defaults:
> -	sd_printk(KERN_ERR, sdkp, "Assuming drive cache: write through\n");
> -	sdkp->WCE = 0;
> +	if (sdkp->WCE)
> +		return;
> +	else {
> +		sd_printk(KERN_ERR, sdkp, "Normal Routine Failed: Trying ATA_16\n");

Instead of adding an awful lot of code inside an "else" clause, it 
would be better to put this into its own subroutine.

> +		
> +		/* The below are necessary parameters which are to set - in order
> +		to make use of ATA_OP_IDENTIFY command */
> +		tf.lob.lbal = 0;
> +	        tf.lob.lbam = 0;
> +	        tf.lob.lbah = 0;
> +	        tf.lob.nsect = 1; //Number of Sectors to Read
> +	        tf.lob.feat = 0;
> +
> +		/* Command Descriptor Block For SCSI 	*/
> +	        cdb[0] = SG_ATA_16;
> +	        cdb[1] = 0x08;
> +	        cdb[2] = 0x0e;
> +	        cdb[6] = 0x01; //No. of Sectors To Read
> +	        cdb[13] = ATA_USING_LBA;
> +	        cdb[14] = ATA_OP_IDENTIFY;
> +
> +	        io_hdr.cmd_len = SG_ATA_16_LEN;
> +	        io_hdr.interface_id = SG_INTERFACE_ID_ORIG;
> +	        io_hdr.mx_sb_len= sizeof(sb);
> +	        io_hdr.dxfer_direction = SG_DXFER_FROM_DEV;
> +	        io_hdr.dxfer_len = sizeof(buf);
> +	        io_hdr.dxferp = data_cmd;
> +	        io_hdr.cmdp = cdb;
> +	        io_hdr.sbp = sb;
> +	        io_hdr.pack_id = tf_to_lba(&tf);
> +        	io_hdr.timeout = 0;
> +
> +	        if (!scsi_cmd_ioctl(sdkp->disk->queue, sdkp->disk,
> O_RDONLY|O_NONBLOCK, SG_IO, &io_hdr))

Do you really need to do an ioctl?  Why not call scsi_execute_req() 
directly?

> +        	{
> +#if 0
> +#define DUMP_BYTES_BUFFER(x...) printk( x )
> +			int i;
> +			for (i = 0; i < 32; i++)
> +        	                DUMP_BYTES_BUFFER(" %02x", sb[i]);
> +	                DUMP_BYTES_BUFFER("\n");
> +	                for (i = 0; i < 512; i++)
> +        	                DUMP_BYTES_BUFFER(" %02x", buf[i]);
> +	                DUMP_BYTES_BUFFER("\n");
> +        	        printk(KERN_ERR"82 - [0x%x], 85 -
> [0x%x]\n",((unsigned short*)data_cmd)[82],((unsigned
> short*)data_cmd)[85]);
> +#endif

For the final patch submission, of course this section should be 
removed.

> +			/* '6th' Bit in Word 85 Corresponds to Write Cache being Enabled/disabled*/
> +                	wce_word = le16_to_cpu(((unsigned short*)data_cmd)[85]);
> +	                if (wce_word & 0x20) {
> +        	                sdkp->WCE = 1;
> +                		sd_printk(KERN_NOTICE, sdkp, "Write Cache Enabled
> after ATA_16 response\n");
> +			} else
> +				goto write_through;
> +	        } else {
> +write_through:
> +	        	sd_printk(KERN_ERR, sdkp, "Assuming drive cache: write through\n");
> +		        sdkp->WCE = 0;
> +        	}
> +	}
>  	sdkp->RCD = 0;
>  	sdkp->DPOFUA = 0;
>  }

Besides the potential problems raised by other people, these structural
weaknesses in the patch should be fixed.

Alan Stern
