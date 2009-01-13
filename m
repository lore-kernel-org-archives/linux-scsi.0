From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Restart scsi_device_lookup_by_target
Date: Tue, 13 Jan 2009 15:05:41 +0100
Message-ID: <496C9FB5.60908@suse.de>
References: <496C9C26.9020106@suse.de> <20090113135856.GE29283@parisc-linux.org> <496C9EF3.2090409@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41288 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbZAMOFn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2009 09:05:43 -0500
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id DFA2948538
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2009 15:05:41 +0100 (CET)
In-Reply-To: <496C9EF3.2090409@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi Matthew,

Hannes Reinecke wrote:
> Matthew Wilcox wrote:
>> On Tue, Jan 13, 2009 at 02:50:30PM +0100, Hannes Reinecke wrote:
>>> @@ -1131,14 +1137,15 @@ EXPORT_SYMBOL(__scsi_device_lookup_by_targe=
t);
>>>  struct scsi_device *scsi_device_lookup_by_target(struct scsi_targe=
t=20
>>> *starget,
>>>                           uint lun)
>>>  {
>>> -    struct scsi_device *sdev;
>>> +    struct scsi_device *sdev =3D NULL;
>>>      struct Scsi_Host *shost =3D dev_to_shost(starget->dev.parent);
>>>      unsigned long flags;
>>> =20
>>>      spin_lock_irqsave(shost->host_lock, flags);
>>> -    sdev =3D __scsi_device_lookup_by_target(starget, lun);
>>> + restart:
>>> +    sdev =3D __scsi_device_lookup_by_target(starget, sdev, lun);
>>>      if (sdev && scsi_device_get(sdev))
>>> -        sdev =3D NULL;
>>> +        goto restart;
>>>      spin_unlock_irqrestore(shost->host_lock, flags);
>>> =20
>>>      return sdev;
>>
>> Backwards jumps are generally disapproved of.  How about:
>>
>>     spin_lock_irqsave(shost->host_lock, flags);
>>     for (;;) {
>>         sdev =3D __scsi_device_lookup_by_target(starget, sdev, lun);
>>         if (!sdev || !scsi_device_get(sdev))
>>             break;
>>     }
>>     spin_unlock_irqrestore(shost->host_lock, flags);
>>
>>
> I must say I don't really like the for(;;) construct.
> And it's really confusing as we want to find an sdev, so breaking
> if it's _not_ found is ... weird.
>=20
What about

	do {
		sdev =3D __scsi_device_lookup_by_target(starget, sdev, lun);
	} while (sdev && scsi_device_get(sdev));

?
Should be identical and easier to read ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
