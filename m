From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [Patch] SCSI: Retrieve Cache Mode Using SG_ATA_16 if normal
 routine fails
Date: Tue, 11 Oct 2011 21:33:18 +0530
Message-ID: <CADDb1s0EqcNHZ7onpMiyj+XqQCEx_vjF_yrpX1neA7_G9o2Axw@mail.gmail.com>
References: <CADDb1s2=Ykh711grVjHV542pVJwpf1K+zzTRVEY2KH3T=wB_xg@mail.gmail.com>
	<Pine.LNX.4.44L0.1110111010210.2177-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1110111010210.2177-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NamJae Jeon <linkinjeon@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 11, 2011 at 7:49 PM, Alan Stern <stern@rowland.harvard.edu>=
 wrote:
> On Tue, 11 Oct 2011, Amit Sahrawat wrote:
>
>> SCSI: Retrieve Cache Mode Using SG_ATA_16 if normal routine fails
>>
>> It has been observed that a number of USB HDD's do not respond corre=
ctly
>> to SCSI mode sense command(retrieve caching pages) which results in =
their
>> Write Cache being discarded by queue requests i.e., WCE if left set =
to
>> '0'(disabled). So, in order to identify the devices correctly - give=
 it
>> a last try using SG_ATA_16 after failure from normal routine.
>>
>> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
>>
>> diff -Nurp linux-Orig/drivers/scsi/sd.c linux-Updated/drivers/scsi/s=
d.c
>> --- linux-Orig/drivers/scsi/sd.c =A0 =A0 =A02011-10-11 11:02:48.0000=
00000 +0530
>> +++ linux-Updated/drivers/scsi/sd.c =A0 2011-10-11 11:10:09.00000000=
0 +0530
>> @@ -56,6 +56,7 @@
>> =A0#include <asm/uaccess.h>
>> =A0#include <asm/unaligned.h>
>>
>> +#include <scsi/sg.h>
>> =A0#include <scsi/scsi.h>
>> =A0#include <scsi/scsi_cmnd.h>
>> =A0#include <scsi/scsi_dbg.h>
>> @@ -134,6 +135,58 @@ static const char *sd_cache_types[] =3D {
>> =A0 =A0 =A0 "write back, no read (daft)"
>> =A0};
>>
>> +/* Relevant Structure and Function to be used to Retrieve
>> + * Caching Information from USB HDD - this is picked from
>> + * source code of 'hdparm'
>> + *
>> + *
>> + * Definitions and structures for use with SG_IO + ATA_16:
>> + * */
>> +#define SG_ATA_16 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x85
>> +#define SG_ATA_16_LEN =A0 =A0 =A0 =A0 =A0 16
>> +
>> +#define ATA_OP_IDENTIFY =A0 =A0 =A0 =A0 =A0 =A0 =A00xec
>> +
>> +/*
>> + * Some useful ATA register bits
>> + */
>> +enum {
>> + =A0 =A0 =A0 =A0ATA_USING_LBA =A0 =A0 =A0 =A0 =A0 =3D (1 << 6),
>> + =A0 =A0 =A0 =A0ATA_STAT_DRQ =A0 =A0 =A0 =A0 =A0 =A0=3D (1 << 3),
>> + =A0 =A0 =A0 =A0ATA_STAT_ERR =A0 =A0 =A0 =A0 =A0 =A0=3D (1 << 0),
>> +};
>> +
>> +struct ata_lba_regs {
>> + =A0 =A0 =A0 =A0__u8 =A0 =A0feat;
>> + =A0 =A0 =A0 =A0__u8 =A0 =A0nsect;
>> + =A0 =A0 =A0 =A0__u8 =A0 =A0lbal;
>> + =A0 =A0 =A0 =A0__u8 =A0 =A0lbam;
>> + =A0 =A0 =A0 =A0__u8 =A0 =A0lbah;
>> +};
>> +struct ata_tf {
>> + =A0 =A0 =A0 =A0__u8 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev;
>> + =A0 =A0 =A0 =A0__u8 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0command=
;
>> + =A0 =A0 =A0 =A0__u8 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0error;
>> + =A0 =A0 =A0 =A0__u8 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0status;
>> + =A0 =A0 =A0 =A0__u8 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0is_lba4=
8;
>> + =A0 =A0 =A0 =A0struct ata_lba_regs =A0 =A0 lob;
>> + =A0 =A0 =A0 =A0struct ata_lba_regs =A0 =A0 hob;
>> +};
>
> Don't these things already exist in some standard header file? =A0If =
not,
> shouldn't they be added in a more central location?
>
>> +__u64 tf_to_lba (struct ata_tf *tf)
>> +{
>> + =A0 =A0 =A0 =A0__u32 lba24, lbah;
>> + =A0 =A0 =A0 =A0__u64 lba64;
>> +
>> + =A0 =A0 =A0 =A0lba24 =3D (tf->lob.lbah << 16) | (tf->lob.lbam << 8=
) | (tf->lob.lbal);
>> + =A0 =A0 =A0 =A0if (tf->is_lba48)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lbah =3D (tf->hob.lbah << 16) | (tf=
->hob.lbam << 8) |
>> (tf->hob.lbal);
>> + =A0 =A0 =A0 =A0else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lbah =3D (tf->dev & 0x0f);
>> + =A0 =A0 =A0 =A0lba64 =3D (((__u64)lbah) << 24) | (__u64)lba24;
>> + =A0 =A0 =A0 =A0return lba64;
>> +}
>> +
>> =A0static ssize_t
>> =A0sd_store_cache_type(struct device *dev, struct device_attribute *=
attr,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *buf, size_t count)
>> @@ -1839,6 +1892,18 @@ sd_read_cache_type(struct scsi_disk *sdk
>> =A0 =A0 =A0 int old_rcd =3D sdkp->RCD;
>> =A0 =A0 =A0 int old_dpofua =3D sdkp->DPOFUA;
>>
>> + =A0 =A0 struct ata_tf tf;
>> + =A0 =A0 struct sg_io_hdr io_hdr;
>> + =A0 =A0 unsigned char cdb[SG_ATA_16_LEN] =3D {0};
>> + =A0 =A0 unsigned char sb[32] =3D {0};
>> + =A0 =A0 unsigned char buf[512] =3D {0};
>
> Arrays generally should not have static initializers. =A0Also, a 512-=
byte
> array is too large to allocate on the stack. =A0And there's already a
> 512-byte array available -- it's named "buffer".
>
>> + =A0 =A0 unsigned short wce_word =3D 0;
>
> There's no reason to initialize this variable.
>
>> + =A0 =A0 void *data_cmd =3D buf;
>
> Why do you need to alias a perfectly good variable?
>
>> +
>> + =A0 =A0 memset(cdb, 0, SG_ATA_16_LEN);
>> + =A0 =A0 memset(&tf, 0, sizeof(struct ata_tf));
>> + =A0 =A0 memset(&io_hdr, 0, sizeof(struct sg_io_hdr));
>
> There's no point initializing these things before you know that they
> will be used.
>
>> +
>> =A0 =A0 =A0 =A0 first_len =3D 4;
>> =A0 =A0 =A0 =A0 if (sdp->skip_ms_page_8) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sdp->type =3D=3D TYPE_RBC)
>> @@ -1961,7 +2026,6 @@ Page_found:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sdkp=
->DPOFUA ? "supports DPO and FUA"
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 : "d=
oesn't support DPO or FUA");
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 return;
>> =A0 =A0 =A0 }
>>
>> =A0bad_sense:
>> @@ -1974,8 +2038,64 @@ bad_sense:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sd_printk(KERN_ERR, sdkp, "Asking for ca=
che data failed\n");
>>
>> =A0defaults:
>> - =A0 =A0 sd_printk(KERN_ERR, sdkp, "Assuming drive cache: write thr=
ough\n");
>> - =A0 =A0 sdkp->WCE =3D 0;
>> + =A0 =A0 if (sdkp->WCE)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return;
>> + =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 sd_printk(KERN_ERR, sdkp, "Normal Routine =
=46ailed: Trying ATA_16\n");
>
> Instead of adding an awful lot of code inside an "else" clause, it
> would be better to put this into its own subroutine.
>
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* The below are necessary parameters whic=
h are to set - in order
>> + =A0 =A0 =A0 =A0 =A0 =A0 to make use of ATA_OP_IDENTIFY command */
>> + =A0 =A0 =A0 =A0 =A0 =A0 tf.lob.lbal =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 tf.lob.lbam =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 tf.lob.lbah =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 tf.lob.nsect =3D 1; //Number of Sectors to=
 Read
>> + =A0 =A0 =A0 =A0 =A0 =A0 tf.lob.feat =3D 0;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* Command Descriptor Block For SCSI =A0 =A0=
*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 cdb[0] =3D SG_ATA_16;
>> + =A0 =A0 =A0 =A0 =A0 =A0 cdb[1] =3D 0x08;
>> + =A0 =A0 =A0 =A0 =A0 =A0 cdb[2] =3D 0x0e;
>> + =A0 =A0 =A0 =A0 =A0 =A0 cdb[6] =3D 0x01; //No. of Sectors To Read
>> + =A0 =A0 =A0 =A0 =A0 =A0 cdb[13] =3D ATA_USING_LBA;
>> + =A0 =A0 =A0 =A0 =A0 =A0 cdb[14] =3D ATA_OP_IDENTIFY;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 io_hdr.cmd_len =3D SG_ATA_16_LEN;
>> + =A0 =A0 =A0 =A0 =A0 =A0 io_hdr.interface_id =3D SG_INTERFACE_ID_OR=
IG;
>> + =A0 =A0 =A0 =A0 =A0 =A0 io_hdr.mx_sb_len=3D sizeof(sb);
>> + =A0 =A0 =A0 =A0 =A0 =A0 io_hdr.dxfer_direction =3D SG_DXFER_FROM_D=
EV;
>> + =A0 =A0 =A0 =A0 =A0 =A0 io_hdr.dxfer_len =3D sizeof(buf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 io_hdr.dxferp =3D data_cmd;
>> + =A0 =A0 =A0 =A0 =A0 =A0 io_hdr.cmdp =3D cdb;
>> + =A0 =A0 =A0 =A0 =A0 =A0 io_hdr.sbp =3D sb;
>> + =A0 =A0 =A0 =A0 =A0 =A0 io_hdr.pack_id =3D tf_to_lba(&tf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 io_hdr.timeout =3D 0;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!scsi_cmd_ioctl(sdkp->disk->queue, sdk=
p->disk,
>> O_RDONLY|O_NONBLOCK, SG_IO, &io_hdr))
>
> Do you really need to do an ioctl? =A0Why not call scsi_execute_req()
> directly?
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 {
>> +#if 0
>> +#define DUMP_BYTES_BUFFER(x...) printk( x )
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int i;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < 32; i++)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DUMP_BYTES=
_BUFFER(" %02x", sb[i]);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DUMP_BYTES_BUFFER("\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < 512; i++=
)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DUMP_BYTES=
_BUFFER(" %02x", buf[i]);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DUMP_BYTES_BUFFER("\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR"82 - [0x%x=
], 85 -
>> [0x%x]\n",((unsigned short*)data_cmd)[82],((unsigned
>> short*)data_cmd)[85]);
>> +#endif
>
> For the final patch submission, of course this section should be
> removed.
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* '6th' Bit in Word 85 Co=
rresponds to Write Cache being Enabled/disabled*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wce_word =3D le16_to_cpu((=
(unsigned short*)data_cmd)[85]);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (wce_word & 0x20) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sdkp->WCE =
=3D 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sd_printk(=
KERN_NOTICE, sdkp, "Write Cache Enabled
>> after ATA_16 response\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto write=
_through;
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> +write_through:
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sd_printk(KERN_ERR, sdkp, =
"Assuming drive cache: write through\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sdkp->WCE =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> =A0 =A0 =A0 sdkp->RCD =3D 0;
>> =A0 =A0 =A0 sdkp->DPOFUA =3D 0;
>> =A0}
>
> Besides the potential problems raised by other people, these structur=
al
> weaknesses in the patch should be fixed.
>
> Alan Stern
>
>

Thanks Alan for the thorough review, I will consider all your points.
Also, will try and make use of scsi_execute_req() instead of ioctl().

Regards,
Amit Sahrawat
