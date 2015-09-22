From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 19/23] scsi_dh_alua: Use workqueue for RTPG
Date: Tue, 22 Sep 2015 22:15:41 +0200
Message-ID: <5601B6ED.7060400@suse.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
 <1440679281-13234-20-git-send-email-hare@suse.de>
 <1442951383.4132.65.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933812AbbIVUPr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2015 16:15:47 -0400
In-Reply-To: <1442951383.4132.65.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 09/22/2015 09:49 PM, Ewan Milne wrote:
> On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
>> The current ALUA device_handler has two drawbacks:
>> - We're sending a 'SET TARGET PORT GROUP' command to every LUN,
>>   disregarding the fact that several LUNs might be in a port group
>>   and will be automatically switched whenever _any_ LUN within
>>   that port group receives the command.
>> - Whenever a LUN is in 'transitioning' mode we cannot block I/O
>>   to that LUN, instead the controller has to abort the command.
>>   This leads to increased traffic across the wire and heavy load
>>   on the controller during switchover.
>=20
> I'm not sure I understand what this means - why couldn't we block I/O=
?
> and what does 'heavy load' mean?  Aborting commands is 'heavy load'?
>=20
If we're getting a sense code indicating that the LUN is in
transitioning _and_ we're blocking I/O we never ever send down I/Os to
that driver anymore, so we cannot receive any sense codes indicating th=
e
transitioning is done.
At the same time, every I/O we're sending down will be returned by the
storage I/O with a sense code, requiring us to retry the command.
Hence we're constantly retrying I/O.

[ .. ]
>> @@ -811,10 +1088,17 @@ failed:
>>  static void alua_bus_detach(struct scsi_device *sdev)
>>  {
>>  	struct alua_dh_data *h =3D sdev->handler_data;
>> +	struct alua_port_group *pg;
>> =20
>> -	if (h->pg) {
>> -		kref_put(&h->pg->kref, release_port_group);
>> -		h->pg =3D NULL;
>> +	spin_lock(&h->pg_lock);
>> +	pg =3D h->pg;
>> +	rcu_assign_pointer(h->pg, NULL);
>> +	spin_unlock(&h->pg_lock);
>> +	synchronize_rcu();
>> +	if (pg) {
>> +		if (pg->rtpg_sdev)
>> +			flush_workqueue(pg->work_q);
>> +		kref_put(&pg->kref, release_port_group);
>>  	}
>>  	sdev->handler_data =3D NULL;
>>  	kfree(h);
>=20
> So, you've already had a bit of discussion with Christoph about this,
> the main portion of your ALUA rewrite, and I won't go over all of tha=
t,
> except to say that I'd have to agree that having separate work queues
> for the different RTPG/STPG functions and having them manipulate each
> other's flags seems like we'd be better off having just one work
> function that did everything.  Less messy and easier to maintain.
>=20
> Also, it seems like wrong ordering of kref_get() vs. scsi_device_get(=
),
> in alua_rtpg_queue() since they are released as kref_put() then
> scsi_device_put()?
>=20
Yeah, I've reworked the reference counting.
And reverted the workqueue handling to use the original model.

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
