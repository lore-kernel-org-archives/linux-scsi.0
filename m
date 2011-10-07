From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] alua: clarify messages when blk_execute_rq fails
Date: Fri, 07 Oct 2011 08:12:15 +0200
Message-ID: <4E8E983F.10804@suse.de>
References: <1313182877-31377-1-git-send-email-revers@redhat.com> <4E8E269F.4020901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab1JGGMR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Oct 2011 02:12:17 -0400
In-Reply-To: <4E8E269F.4020901@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org

On 10/07/2011 12:07 AM, Rob Evers wrote:
> On 08/12/2011 05:01 PM, Rob Evers wrote:
>> replace numeric messages with string error messages when
>> blk_execute_rq
>> fails. Also add printing of sense info.
>>
>> Mike Christie suggested adding printing of sense info here
>>
>> Signed-off-by: Rob Evers<revers@redhat.com>
>> ---
>> drivers/scsi/device_handler/scsi_dh_alua.c | 27
>> ++++++++++++++++++---------
>> 1 files changed, 18 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
>> b/drivers/scsi/device_handler/scsi_dh_alua.c
>> index 6fec9fe..58fdf64 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -24,6 +24,7 @@
>> #include<scsi/scsi.h>
>> #include<scsi/scsi_eh.h>
>> #include<scsi/scsi_dh.h>
>> +#include<scsi/scsi_dbg.h>
>>
>> #define ALUA_DH_NAME "alua"
>> #define ALUA_DH_VER "1.3"
>> @@ -153,9 +154,12 @@ static int submit_std_inquiry(struct
>> scsi_device *sdev, struct alua_dh_data *h)
>>
>> err =3D blk_execute_rq(rq->q, NULL, rq, 1);
>> if (err =3D=3D -EIO) {
>> - sdev_printk(KERN_INFO, sdev,
>> - "%s: std inquiry failed with %x\n",
>> - ALUA_DH_NAME, rq->errors);
>> + sdev_printk(KERN_INFO, sdev, "%s: std inquiry failed\n",
>> + ALUA_DH_NAME);
>> + scsi_show_result(rq->errors);
>> + if (driver_byte(rq->errors)&& DRIVER_SENSE)
>> + __scsi_print_sense("alua std_inquiry", rq->sense,
>> + rq->sense_len);
>> h->senselen =3D rq->sense_len;
>> err =3D SCSI_DH_IO;
>> }
>> @@ -190,9 +194,12 @@ static int submit_vpd_inquiry(struct
>> scsi_device *sdev, struct alua_dh_data *h)
>>
>> err =3D blk_execute_rq(rq->q, NULL, rq, 1);
>> if (err =3D=3D -EIO) {
>> - sdev_printk(KERN_INFO, sdev,
>> - "%s: evpd inquiry failed with %x\n",
>> - ALUA_DH_NAME, rq->errors);
>> + sdev_printk(KERN_INFO, sdev, "%s: evpd inquiry failed\n",
>> + ALUA_DH_NAME);
>> + scsi_show_result(rq->errors);
>> + if (driver_byte(rq->errors)&& DRIVER_SENSE)
>> + __scsi_print_sense("alua vpd_inquiry", rq->sense,
>> + rq->sense_len);
>> h->senselen =3D rq->sense_len;
>> err =3D SCSI_DH_IO;
>> }
>> @@ -229,9 +236,11 @@ static unsigned submit_rtpg(struct
>> scsi_device *sdev, struct alua_dh_data *h)
>>
>> err =3D blk_execute_rq(rq->q, NULL, rq, 1);
>> if (err =3D=3D -EIO) {
>> - sdev_printk(KERN_INFO, sdev,
>> - "%s: rtpg failed with %x\n",
>> - ALUA_DH_NAME, rq->errors);
>> + sdev_printk(KERN_INFO, sdev, "%s: rtpg failed\n", ALUA_DH_NAME);
>> + scsi_show_result(rq->errors);
>> + if (driver_byte(rq->errors)&& DRIVER_SENSE)
>> + __scsi_print_sense("alua submit_rtpg", rq->sense,
>> + rq->sense_len);
>> h->senselen =3D rq->sense_len;
>> err =3D SCSI_DH_IO;
>> }
>
> Hannes,
>
> Did you get a chance to take a look at this patch?
>
Yes, I did.

And found it's actually not quite correct; we'll need to evaluate=20
the sense code here to do a possible retry.

I'll be updating the patch.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
