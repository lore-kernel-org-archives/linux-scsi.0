From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH 2/2] scsi: retrieve cache mode using ATA_16 cmd if normal
 routine fails
Date: Thu, 16 Feb 2012 23:07:27 +0900
Message-ID: <CAKYAXd91v1vFa4EE27xn1sJkQDADJGcPOQ5WgsE900wPgw3mWw@mail.gmail.com>
References: <1329375141-6944-1-git-send-email-amit.sahrawat83@gmail.com>
	<1329398881.2893.8.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59445 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab2BPOH3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2012 09:07:29 -0500
In-Reply-To: <1329398881.2893.8.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>, Jeff Garzik <jgarzik@pobox.com>, Nam-Jae Jeon <namjae.jeon@samsung.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Amit Sahrawat <a.sahrawat@samsung.com>

2012/2/16 James Bottomley <James.Bottomley@hansenpartnership.com>:
> On Thu, 2012-02-16 at 12:22 +0530, Amit Sahrawat wrote:
>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index c691fb5..3ca507a 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -50,6 +50,11 @@
>> =C2=A0#include <linux/string_helpers.h>
>> =C2=A0#include <linux/async.h>
>> =C2=A0#include <linux/slab.h>
>> +
>> +#ifdef CONFIG_ATA
>> +#include <linux/libata.h>
>> +#endif
>> +
>> =C2=A0#include <linux/pm_runtime.h>
>> =C2=A0#include <asm/uaccess.h>
>> =C2=A0#include <asm/unaligned.h>
>> @@ -2129,7 +2134,11 @@ sd_read_cache_type(struct scsi_disk *sdkp, un=
signed char *buffer)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (modepage =3D=3D=
 0x3F) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 sd_printk(KERN_ERR, sdkp, "No Caching mode page "
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "present\n");
>> +#ifdef CONFIG_ATA
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 goto WCE_USING_ATA;
>> +#else
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto defaults;
>> +#endif
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if ((buffer[=
offset] & 0x3f) !=3D modepage) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 sd_printk(KERN_ERR, sdkp, "Got wrong page\n");
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto defaults;
>> @@ -2149,6 +2158,15 @@ sd_read_cache_type(struct scsi_disk *sdkp, un=
signed char *buffer)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Uses READ/WRITE(6), disabli=
ng FUA\n");
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 sdkp->DPOFUA =3D 0;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> +#ifdef CONFIG_ATA
>> +WCE_USING_ATA:
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!sdp->removable && !=
sdkp->WCE) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 sd_printk(KERN_NOTICE, sdkp, "Try to check write cache"
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 " enable/disable using ATA command\n");
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 sdkp->WCE =3D ata_get_cachestatus(sdp);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> +#endif
>> +
>
> I already said before, this is a non starter: we can't randomly send
> SCSI encapsulated ATA commands to disks from sd. =C2=A0What we can do=
 is give
> you a WCE variable you can change on the fly in sysfs via whatever
> mechanism is most appropriate (but this would have to be a mechanism
> external to sd.c).
Oops.. it is mistake. we will make patch v2 included setting via sysfs.
Thanks for your reply.
>
> Alternatively, you can co-opt the USB quirks handling to set it for y=
ou.
>
> James
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
