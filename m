From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] scsi: use 64-bit value for 'max_luns'
Date: Wed, 20 Feb 2013 07:43:57 +0100
Message-ID: <512470AD.8020307@suse.de>
References: <1361261883-41467-1-git-send-email-hare@suse.de>  <1361261883-41467-4-git-send-email-hare@suse.de>  <26C9F254-62B6-460A-BEB3-BE41516B5186@cs.wisc.edu> <1361291625.2382.54.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33562 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab3BTGoG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Feb 2013 01:44:06 -0500
In-Reply-To: <1361291625.2382.54.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Michael Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jeremy Linton <jlinton@tributary.com>, Robert Elliott <Elliott@hp.com>, Bart Van Assche <bvanassche@acm.org>

On 02/19/2013 05:33 PM, James Bottomley wrote:
> On Tue, 2013-02-19 at 10:30 -0600, Michael Christie wrote:
>> On Feb 19, 2013, at 2:18 AM, Hannes Reinecke <hare@suse.de> wrote:
>>
>>> diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/lib=
cxgbi.c
>>> index b44c1cf..95105c0 100644
>>> --- a/drivers/scsi/cxgbi/libcxgbi.c
>>> +++ b/drivers/scsi/cxgbi/libcxgbi.c
>>> @@ -245,7 +245,7 @@ void cxgbi_hbas_remove(struct cxgbi_device *cde=
v)
>>> }
>>> EXPORT_SYMBOL_GPL(cxgbi_hbas_remove);
>>>
>>> -int cxgbi_hbas_add(struct cxgbi_device *cdev, unsigned int max_lun=
,
>>> +int cxgbi_hbas_add(struct cxgbi_device *cdev, uint64_t max_lun,
>>> 		unsigned int max_id, struct scsi_host_template *sht,
>>> 		struct scsi_transport_template *stt)
>>> {
>>> diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/lib=
cxgbi.h
>>> index 80fa99b..d3b27f8 100644
>>> --- a/drivers/scsi/cxgbi/libcxgbi.h
>>> +++ b/drivers/scsi/cxgbi/libcxgbi.h
>>> @@ -692,7 +692,7 @@ struct cxgbi_device *cxgbi_device_register(unsi=
gned int, unsigned int);
>>> void cxgbi_device_unregister(struct cxgbi_device *);
>>> void cxgbi_device_unregister_all(unsigned int flag);
>>> struct cxgbi_device *cxgbi_device_find_by_lldev(void *);
>>> -int cxgbi_hbas_add(struct cxgbi_device *, unsigned int, unsigned i=
nt,
>>> +int cxgbi_hbas_add(struct cxgbi_device *, uint64_t, unsigned int,
>>> 			struct scsi_host_template *,
>>> 			struct scsi_transport_template *);
>>> void cxgbi_hbas_remove(struct cxgbi_device *);
>>> diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
>>> index dfe90ce..9acdb9c 100644
>>
>>
>> Could it be possible to use u64, so it matches the rest of the drive=
r
>> coding style? The rest of the driver uses the u* definitions instead=
 f
>> the uint*_t ones.
>
> In general we should use u64 for kernel internal stuff (which this is=
).
> uint64_t is supposed to be reserved for user interfaces.
>
Ok. Will fix it up with the next series.

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
