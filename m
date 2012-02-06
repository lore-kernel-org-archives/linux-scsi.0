From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH 1/1] scsi: retrieve cache mode using ATA_16 if normal
 routine fails
Date: Mon, 6 Feb 2012 11:10:22 +0530
Message-ID: <CADDb1s2xX6kzeTO6pjmE9LLcd_NxcZncE99E=roi1DfZGto4vA@mail.gmail.com>
References: <1328273954-5010-1-git-send-email-amit.sahrawat83@gmail.com>
	<4F2E709C.5060000@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F2E709C.5060000@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Nam-Jae Jeon <namjae.jeon@samsung.com>, Amit Sahrawat <a.sahrawat@samsung.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Sergei,
Thanks for your review comments.

On Sun, Feb 5, 2012 at 5:35 PM, Sergei Shtylyov <sshtylyov@mvista.com> =
wrote:
> Hello.
>
>
> On 03-02-2012 16:59, Amit Sahrawat wrote:
>
>> It has been observed that a number of USB HDD's do not respond corre=
ctly
>
>
> =A0 Why are you working around this in libata-scsi.c then if it's USB=
 HDD?
There has been a history to this problem. It has been a long pending
problem with SCSI layer and USB HDD. We observed when we encountered
various Filesystem corruption issues on USB HDD and on analysis - we
found that there is no SYNCHRONIZE_CACHE command going to a number of
USB HDD even though - they do seem to possess WRITE CACHE.
So, drivers/scsi/sd.c - was where we found that WCE is being set for
these kind of devices which will in-turn take care of setting the
correct 'cache_type - Writeback' and also take care of proper working
(by managing correct order in requests queue).
We first did a change by introducing  - mechanism to retrieve cache
bit in sd_read_cache_type, alongwith this we provided an interface
using 'syfs' if we can change the cache type from that place.
But, we received review comments in this regards - that the layer on
which we are doing changes is not the proper place(and also ATA_16
seems to crash some old HDD's, and were advised to look out for
changes in libata-scsi  instead).(Original link -
http://lkml.org/lkml/2011/12/12/164)

So, we went for changes in libata-scsi.

Please let me know in case more information is needed in this regards,
or may be if you could provide more inputs to these sort of changes.
>
>
>> to SCSI mode sense command(retrieve caching pages) which results in =
their
>> Write Cache being discarded by queue requests i.e., WCE if left set =
to
>> '0'(disabled).
>> This results in a number of Filesystem corruptions, when the device
>> is unplugged abruptly.
>
>
>> So, in order to identify the devices correctly - give it
>> a last try using ATA_16 after failure from normal routine.
>
>
> =A0 Shouldn't this be done in drivers/usb/storage somewhere?
>
>
>> Signed-off-by: Amit Sahrawat<a.sahrawat@samsung.com>
>> Signed-off-by: Namjae Jeon<namjae.jeon@samsung.com>
>
>
> [...]
>
>
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index 508a60b..d5b00e6 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
>> @@ -562,6 +562,57 @@ error:
>> =A0}
>>
>> =A0/**
>> + * =A0 =A0 =A0ata_get_cachestatus - Handler for to get WriteCache S=
tatus
>> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0using ATA_16 scsi com=
mand
>> + * =A0 =A0 =A0@scsidev: Device to which we are issuing command
>> + *
>> + * =A0 =A0 =A0LOCKING:
>> + * =A0 =A0 =A0Defined by the SCSI layer. =A0We don't really care.
>> + *
>> + * =A0 =A0 =A0RETURNS:
>> + * =A0 =A0 =A0'0' for Write Cache Disabled and on any error.
>> + * =A0 =A0 =A0'1' for Write Cache enabled
>> + */
>> +int ata_get_cachestatus(struct scsi_device *scsidev)
>> +{
>> + =A0 =A0 =A0 int rc =3D 0;
>> + =A0 =A0 =A0 u8 scsi_cmd[MAX_COMMAND_SIZE] =3D {0};
>> + =A0 =A0 =A0 u8 *sensebuf =3D NULL, *argbuf =3D NULL;
>
>
> =A0 No need to initialize them.
Tried to maintain the uniformity in the code for this file, at other
places it is being done like.
>
>
>> + =A0 =A0 =A0 enum dma_data_direction data_dir;
>> +
>> + =A0 =A0 =A0 sensebuf =3D kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_NOIO);
>> + =A0 =A0 =A0 if (!sensebuf)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> +
>> + =A0 =A0 =A0 argbuf =3D kmalloc(ATA_SECT_SIZE, GFP_KERNEL);
>> + =A0 =A0 =A0 if (argbuf =3D=3D NULL)
>
>
> =A0 Could you use an uniform NULL-check, either '!x' or 'x =3D=3D NUL=
L'?
Agreed, need to stick with one type of comparision.
>
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto error;
>> +
>> + =A0 =A0 =A0 scsi_cmd[0] =3D ATA_16;
>> + =A0 =A0 =A0 scsi_cmd[1] =A0=3D (4<< =A01); /* PIO Data-in */
>> + =A0 =A0 =A0 scsi_cmd[2] =A0=3D 0x0e; =A0 =A0 /* no off.line or cc,=
 read from dev,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 block =
count in sector count field */
>> + =A0 =A0 =A0 data_dir =3D DMA_FROM_DEVICE;
>> + =A0 =A0 =A0 scsi_cmd[14] =3D ATA_IDENTIFY_DEV;
>> +
>> + =A0 =A0 =A0 if (!scsi_execute(scsidev, scsi_cmd, data_dir, argbuf,
>> ATA_SECT_SIZE,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 senseb=
uf, (10*HZ), 5, 0, NULL)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* '6th' Bit in Word 85 Corresponds =
to Write Cache
>
>
> =A0 No need for apostrophes here.
Tried to highlight the 6th bit, if this is not the convention, I will
remove this.
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* being Enabled/disabled, Word 85 r=
epresnets the
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* features supported
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (le16_to_cpu(((unsigned short *)arg=
buf)[85])& =A00x20)
>>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 1;
>> + =A0 =A0 =A0 }
>> +
>> +error:
>> + =A0 =A0 =A0 kfree(sensebuf);
>> + =A0 =A0 =A0 kfree(argbuf);
>> + =A0 =A0 =A0 return rc;
>> +}
>> +
>> +/**
>> =A0 * =A0 =A0ata_task_ioctl - Handler for HDIO_DRIVE_TASK ioctl
>> =A0 * =A0 =A0@scsidev: Device to which we are issuing command
>> =A0 * =A0 =A0@arg: User provided data for issuing command
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index c691fb5..a6b887d 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -50,6 +50,11 @@
>> =A0#include<linux/string_helpers.h>
>> =A0#include<linux/async.h>
>> =A0#include<linux/slab.h>
>> +
>> +#ifdef CONFIG_ATA
>
>
> =A0 #ifdef not necessary here.
Yes, but just wanted to specifiy for code readability, as there is no
purpose to include - libata header in sd.c
>
>
>> +#include<linux/libata.h>
>> +#endif
>> +
>> =A0#include<linux/pm_runtime.h>
>> =A0#include<asm/uaccess.h>
>> =A0#include<asm/unaligned.h>
>> @@ -2129,7 +2134,11 @@ sd_read_cache_type(struct scsi_disk *sdkp, un=
signed
>> char *buffer)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (modepage =3D=3D 0x3F) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sd_printk(KERN_ERR, s=
dkp, "No Caching mode page "
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"=
present\n");
>> +#ifdef CONFIG_ATA
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto WCE_USING_ATA;
>
>
> =A0 Yikes.
>
>
>> +#else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto defaults;
>> +#endif
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if ((buffer[offset]& =A00x3f) =
!=3D modepage) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sd_printk(KERN_ERR, s=
dkp, "Got wrong page\n");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto defaults;
>> @@ -2149,6 +2158,14 @@ sd_read_cache_type(struct scsi_disk *sdkp, un=
signed
>> char *buffer)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"=
Uses READ/WRITE(6), disabling FUA\n");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sdkp->DPOFUA =3D 0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> +#ifdef CONFIG_ATA
>> +WCE_USING_ATA:
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!sdp->removable && !sdkp->WCE) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sd_printk(KERN_NOTICE,=
 sdkp, "Try to check write
>> cache "
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "enabl=
e/disable using ATA command\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sdkp->WCE =3D ata_get_=
cachestatus(sdp);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> +#endif
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (sdkp->first_scan || old_wce !=3D =
sdkp->WCE ||
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0old_rcd !=3D sdkp->RCD || old=
_dpofua !=3D sdkp->DPOFUA)
>> diff --git a/include/linux/libata.h b/include/linux/libata.h
>> index cafc09a..33fc73f 100644
>> --- a/include/linux/libata.h
>> +++ b/include/linux/libata.h
>> @@ -84,6 +84,8 @@
>> =A0 =A0 =A0 =A0} =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> =A0})
>>
>> +#define ATA_IDENTIFY_DEV =A0 =A0 =A0 0xEC
>> +
>
>
> =A0 This is alerady #defined in <linux/ata.h> as ATA_CMD_ID_ATA.
Yes, will include that instead of redifining.
>
> MBR, Sergei

Please share your inputs to this.

Thanks & Regards,
Amit Sahrawat
