From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/24] scsi: introduce sdev_prefix_printk()
Date: Mon, 06 Oct 2014 08:00:50 +0200
Message-ID: <54323012.5020008@suse.de>
References: <1412144580-72880-1-git-send-email-hare@suse.de>	 <1412144580-72880-5-git-send-email-hare@suse.de>	 <94D0CD8314A33A4D9D801C0FE68B402958CCAB53@G4W3202.americas.hpqcorp.net> <1412353880.5241.136.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbaJFGAx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2014 02:00:53 -0400
In-Reply-To: <1412353880.5241.136.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com, "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 10/03/2014 06:31 PM, Ewan Milne wrote:
> On Thu, 2014-10-02 at 18:37 +0000, Elliott, Robert (Server Storage)
> wrote:
>>> -----Original Message-----
>>> From: Hannes Reinecke [mailto:hare@suse.de]
>> ...
>>> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
>>> index 4c3ab83..c01dc89 100644
>>> --- a/drivers/scsi/sd.h
>>> +++ b/drivers/scsi/sd.h
>>> @@ -103,9 +103,10 @@ static inline struct scsi_disk *scsi_disk(stru=
ct gendisk
>>> *disk)
>>>
>>>  #define sd_printk(prefix, sdsk, fmt, a...)				\
>>>          (sdsk)->disk ?							\
>>> -	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\
>>> -		    (sdsk)->disk->disk_name, ##a) :			\
>>> -	sdev_printk(prefix, (sdsk)->device, fmt, ##a)
>>> +	      sdev_prefix_printk(prefix, (sdsk)->device,		\
>>> +				 (sdsk)->disk->disk_name, fmt, ##a) :	\
>>> +	      sdev_prefix_printk(prefix, (sdsk)->device,		\
>>> +				 NULL, fmt, ##a)
>>>
>>>  #define sd_first_printk(prefix, sdsk, fmt, a...)			\
>>>  	do {								\
>> ...
>>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.=
h
>>> index 27ecee7..0b18a09 100644
>>> --- a/include/scsi/scsi_device.h
>>> +++ b/include/scsi/scsi_device.h
>>> @@ -244,6 +244,15 @@ struct scsi_dh_data {
>>>  #define sdev_dbg(sdev, fmt, a...) \
>>>  	dev_dbg(&(sdev)->sdev_gendev, fmt, ##a)
>>>
>>> +/*
>>> + * like scmd_printk, but the device name is passed in
>>> + * as a string pointer
>>> + */
>>> +#define sdev_prefix_printk(l, sdev, p, fmt, a...)			\
>>> +	(p) ?								\
>>> +	sdev_printk(l, sdev, "[%s] " fmt, p, ##a) :			\
>>> +	sdev_printk(l, sdev, fmt, ##a)
>>> +
>>>  #define scmd_printk(prefix, scmd, fmt, a...)				\
>>>          (scmd)->request->rq_disk ?					\
>>>  	sdev_printk(prefix, (scmd)->device, "[%s] " fmt,		\
>>> --
>>> 1.8.5.2
>>
>> This triggers lots of compiler warnings with gcc 4.4.7 like:
>>
>> drivers/scsi/sd.c: In function 'sd_open':
>> drivers/scsi/sd.c:1179: warning: reading through null pointer (argum=
ent 4)
>> drivers/scsi/sd.c:1179: warning: format '%s' expects type 'char *', =
but argument 4 has type 'void *'
>>
>>
>> That is from:
>>         SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_open\n"))=
;
>>
>> Since:
>> #define NULL ((void *)0)
>>
>> gcc probably doesn't realize the (p)? prevents the NULL (a void *)=20
>> from being passed to sdev_printk.
>>
>> Passing "" rather than NULL eliminates the compiler warnings.
>=20
> It eliminates the warnings, but unfortunately we then get log message=
s
> that look like:
>=20
> Oct  3 11:30:08 rhel-storage-01 kernel: sd 10:0:0:0: [sde] (null)FAIL=
ED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
>=20
>                                                            ^^^^^^
>=20
> Changing it to (char *)NULL, like this:
>=20
> #define sd_printk(prefix, sdsk, fmt, a...)                           =
   \
>         (sdsk)->disk ?                                               =
   \
>               sdev_prefix_printk(prefix, (sdsk)->device,             =
   \
>                                  (sdsk)->disk->disk_name, fmt, ##a) :=
   \
>               sdev_prefix_printk(prefix, (sdsk)->device,             =
   \
>                                  (char *)NULL, fmt, ##a)
>=20
> doesn't work either.  The compiler gives an error:
>=20
> drivers/scsi/sd.c: In function 'sd_open':
> drivers/scsi/sd.c:1158:2: error: reading through null pointer (argume=
nt 4) [-Werror=3Dformat=3D]
>   SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_open\n"));
>   ^
>=20

I've fixed it up in my next iteration of the patchset.
(By simply using 'sdev_printk' if the prefix argument is NULL ...)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
