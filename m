From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Restart scsi_device_lookup_by_target
Date: Tue, 13 Jan 2009 16:28:21 +0100
Message-ID: <496CB315.8070702@suse.de>
References: <496C9C26.9020106@suse.de> <1231860128.4519.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56311 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbZAMP2X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2009 10:28:23 -0500
In-Reply-To: <1231860128.4519.6.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi James,

James Bottomley wrote:
> On Tue, 2009-01-13 at 14:50 +0100, Hannes Reinecke wrote:
>> Hi all,
>>
>> currently we have this:
>>
>> struct scsi_device *scsi_device_lookup_by_target(struct scsi_target =
*starget,
>>                                                  uint lun)
>> {
>>         struct scsi_device *sdev;
>>         struct Scsi_Host *shost =3D dev_to_shost(starget->dev.parent=
);
>>         unsigned long flags;
>>
>>         spin_lock_irqsave(shost->host_lock, flags);
>>         sdev =3D __scsi_device_lookup_by_target(starget, lun);
>>         if (sdev && scsi_device_get(sdev))
>>                 sdev =3D NULL;
>>         spin_unlock_irqrestore(shost->host_lock, flags);
>>
>>         return sdev;
>> }
>>
>> now consider an sdev list with two entries for LUN 0, the first
>> being in SDEV_DEL and the second being in SDEV_RUNNING.
>>
>> scsi_device_lookup_by_target will always return NULL here, as
>> it will never be able to skip past the first (unuseable)
>> entry. So scsi_report_lun_scan will happily create duplicate
>> sdevs for LUN 0 and we'll be getting the infamous
>>
>> sysfs: duplicate filename 'xxxx' can not be created
>>
>> errors.
>>
>> What we should be doing here is to restart
>> __scsi_device_lookup_by_target() if we find an
>> sdev but cannot use it (ie is in SDEV_DEL).
>>
>> James, please apply.
>>
>> Cheers,
>>
>> Hannes
>> plain text document attachment (scsi-restart-lookup-by-target)
>> Restart scsi_device_lookup_by_target()
>>
>> When scsi_device_lookup_by_target() will always return
>> the first sdev with a matching LUN, regardless of
>> the state. However, when this sdev is in SDEV_DEL
>> it's quite possible to have additional sdevs in the
>> list with the same LUN which are active.
>> So we should restart __scsi_device_lookup_by_target()
>> whenever we find an sdev with state SDEV_DEL.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>=20
> That's brilliant, thanks for finding this bug.
>=20
> rather than go to the trouble of restarting the scan looking for
> duplicates, since none of the users of __scsi_device_lookup_by_target
> actually want invisible dying devices in SDEV_DEL, why not just make =
it
> skip over them.  If we ignore devices in SDEV_DEL, the target id of t=
he
> visible devices should all be unique, so alter the
>=20
> if (sdev->lun =3D=3D lun)
>=20
> to
>=20
> if (sdev->lun =3D=3D lun && sdev->sdev_state !=3D SDEV_DEL)
>=20
> And everything should work.
>=20
> I think this is the correct fix because scsi_device_get() is also
> programmed to ignore devices in SDEV_DEL (for the same reason).
>=20
As already mentioned, I'm not sure if esp_scsi.c expects it to
be that way. If someone confirms that we won't break it with this
change, then of course it's the easier way.

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
