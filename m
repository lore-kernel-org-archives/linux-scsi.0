From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v12 6/6] Avoid re-enabling I/O after the transport became
 offline
Date: Mon, 01 Jul 2013 14:09:48 +0200
Message-ID: <51D1718C.4090900@suse.de>
References: <51CC5176.90609@acm.org> <51CC52EB.9040900@acm.org> <51D13D8C.9070407@suse.de> <51D170A6.7060005@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738Ab3GAMJx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jul 2013 08:09:53 -0400
In-Reply-To: <51D170A6.7060005@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Chanho Min <chanho.min@lge.com>, Joe Lawrence <jdl1291@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, Tejun Heo <tj@kernel.org>

On 07/01/2013 02:05 PM, Bart Van Assche wrote:
> On 07/01/13 10:27, Hannes Reinecke wrote:
>> On 06/27/2013 04:57 PM, Bart Van Assche wrote:
>>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>>> index dfbaa34..666b741 100644
>>> --- a/drivers/scsi/scsi_sysfs.c
>>> +++ b/drivers/scsi/scsi_sysfs.c
>>> @@ -959,14 +959,16 @@ void __scsi_remove_device(struct scsi_device =
*sdev)
>>>   {
>>>   	struct Scsi_Host *shost =3D sdev->host;
>>>   	struct device *dev =3D &sdev->sdev_gendev;
>>> +	enum scsi_device_state sdev_state;
>>>   	int res;
>>>  =20
>>>   	if (sdev->is_visible) {
>>>   		spin_lock_irq(shost->host_lock);
>>> +		sdev_state =3D sdev->sdev_state;
>>>   		res =3D scsi_device_set_state(sdev, SDEV_CANCEL);
>>>   		spin_unlock_irq(shost->host_lock);
>>>  =20
>>> -		if (res !=3D 0)
>>> +		if (res !=3D 0 && sdev_state !=3D SDEV_TRANSPORT_OFFLINE)
>>>   			return;
>>>  =20
>>>   		bsg_unregister_queue(sdev->request_queue);
>>>
>> Hmm. This is really subtle. Do you mind adding inserting a comment
>> here on why this is required?
>=20
> How about inserting the following comment just above the last if-stat=
ement
> in the code cited above ?
>=20
> 		/*
> 		 * The transition from SDEV_TRANSPORT_OFFLINE into SDEV_CANCEL
> 		 * is not allowed since this transition would re-enable I/O. If
> 		 * the device state was already SDEV_TRANSPORT_OFFLINE,
> 		 * proceed with device removal.
> 		 */
>=20
> Bart.
>=20
Perfect.

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
