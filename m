From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH 2/2] scsi: retrieve cache mode using ATA_16 cmd if normal
 routine fails
Date: Tue, 6 Mar 2012 23:08:57 +0530
Message-ID: <CADDb1s0rhEDnRunexnEyL3htpkN+Fu4P7cKJjiZr_s-F48J57g@mail.gmail.com>
References: <1329375141-6944-1-git-send-email-amit.sahrawat83@gmail.com>
	<1329398881.2893.8.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1329398881.2893.8.camel@dabdike>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Nam-Jae Jeon <namjae.jeon@samsung.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Amit Sahrawat <a.sahrawat@samsung.com>
List-Id: linux-scsi@vger.kernel.org

Hi James,

=46ew queries relating to solution for this long pending problem.
As per your suggestions - it is clear - we cannot have this as part of
default routine to retrieve WCE using ATA - as for some USB HDD - it
will result in halting their operations.
So,
1) USB quirks -> i think this will only be a workaround for few USB
hard disks - wherein we can their add their entries in the quirks list
and control this WC. So, this wont be a solution which can be used as
part of a long term solution.
2) As part of 'sysfs' interface - there is already an array for
cache_types in sd.c - Can we make an entry in this array for "write
back(ata cmd)" and make corresponding changes - to reflect this when
we do " echo "write back(ata cmd) >
/sys/class/scsi_disk/<>/cache_type".
So, these changes won't be part of default routine - but this will
still need minor changes in sd.c - will those changes be acceptable?
sd_store_cache_type()->revalidate_disk()->sd_revalidate_disk()->sd_read=
_cache_type()

Please share your opinion to bring out a solution to this.

Thanks & Regards,
Amit Sahrawat

On Thu, Feb 16, 2012 at 6:58 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2012-02-16 at 12:22 +0530, Amit Sahrawat wrote:
>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index c691fb5..3ca507a 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -50,6 +50,11 @@
>> =A0#include <linux/string_helpers.h>
>> =A0#include <linux/async.h>
>> =A0#include <linux/slab.h>
>> +
>> +#ifdef CONFIG_ATA
>> +#include <linux/libata.h>
>> +#endif
>> +
>> =A0#include <linux/pm_runtime.h>
>> =A0#include <asm/uaccess.h>
>> =A0#include <asm/unaligned.h>
>> @@ -2129,7 +2134,11 @@ sd_read_cache_type(struct scsi_disk *sdkp, un=
signed char *buffer)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (modepage =3D=3D 0x3F) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sd_printk(KERN_ERR, sdkp=
, "No Caching mode page "
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "pre=
sent\n");
>> +#ifdef CONFIG_ATA
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto WCE_USING_ATA;
>> +#else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto defaults;
>> +#endif
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if ((buffer[offset] & 0x3f) !=3D =
modepage) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sd_printk(KERN_ERR, sdkp=
, "Got wrong page\n");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto defaults;
>> @@ -2149,6 +2158,15 @@ sd_read_cache_type(struct scsi_disk *sdkp, un=
signed char *buffer)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Use=
s READ/WRITE(6), disabling FUA\n");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sdkp->DPOFUA =3D 0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> +#ifdef CONFIG_ATA
>> +WCE_USING_ATA:
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!sdp->removable && !sdkp->WCE) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sd_printk(KERN_NOTICE, sdk=
p, "Try to check write cache"
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " enable/d=
isable using ATA command\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sdkp->WCE =3D ata_get_cach=
estatus(sdp);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +#endif
>> +
>
> I already said before, this is a non starter: we can't randomly send
> SCSI encapsulated ATA commands to disks from sd. =A0What we can do is=
 give
> you a WCE variable you can change on the fly in sysfs via whatever
> mechanism is most appropriate (but this would have to be a mechanism
> external to sd.c).
>
> Alternatively, you can co-opt the USB quirks handling to set it for y=
ou.
>
> James
>
>
