From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 16/20] scsi_dh_alua: Use workqueue for RTPG
Date: Sat, 25 Jul 2015 17:58:44 +0200
Message-ID: <55B3B234.80100@suse.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de> <1436346378-96518-17-git-send-email-hare@suse.de> <20150724152115.GC29434@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57353 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbbGYP6q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jul 2015 11:58:46 -0400
In-Reply-To: <20150724152115.GC29434@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>

On 07/24/2015 05:21 PM, Christoph Hellwig wrote:
>> +	char			work_q_name[264];
>=20
> create_workqueue and friends now accept printf-like format
> string, so there is no need for this temporary buffer.
>=20
>> +	int			error;
>> +	struct completion       init_complete;
>=20
> Please rename error to init_error and only assign to it before callin=
g
> complete().
>=20
> Also I'm not sure what the real point of init_complete is, shouldn't
> we just have a mutex held in alua_initialize and alua_activate to
> synchronize the two against each other?
>=20
Hmm. I guess I could; I'll check here.

>> +	rcu_read_lock();
>> +	pg =3D rcu_dereference(h->pg);
>> +	if (pg) {
>> +		kref_get(&pg->kref);
>> +		rcu_read_unlock();
>> +		alua_rtpg_queue(pg, sdev, NULL);
>> +		kref_put(&pg->kref, release_port_group);
>> +	} else
>> +		rcu_read_unlock();
>> +}
>=20
> How about:
>=20
> 	rcu_read_lock();
> 	pg =3D rcu_dereference(h->pg);
> 	if (!pg) {
> 		rcu_read_unlock();
> 		return;
> 	}
>=20
> 	kref_get(&pg->kref);
> 	rcu_read_unlock();
> 	alua_rtpg_queue(pg, sdev, NULL);
> 	kref_put(&pg->kref, release_port_group);
>=20

Ok.

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
