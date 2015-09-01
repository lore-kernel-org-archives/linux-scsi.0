From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/23] scsi_dh_alua: Use separate alua_port_group
 structure
Date: Tue, 1 Sep 2015 16:01:32 +0200
Message-ID: <55E5AFBC.5080100@suse.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
 <1440679281-13234-14-git-send-email-hare@suse.de>
 <20150901102055.GC9838@lst.de> <55E5A1E5.8000701@suse.de>
 <20150901134439.GA13566@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbbIAOBf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 10:01:35 -0400
In-Reply-To: <20150901134439.GA13566@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 09/01/2015 03:44 PM, Christoph Hellwig wrote:
> On Tue, Sep 01, 2015 at 03:02:29PM +0200, Hannes Reinecke wrote:
>>>> +	rcu_read_lock();
>>>> +	pg =3D rcu_dereference(h->pg);
>>>> +	if (!pg) {
>>>> +		rcu_read_unlock();
>>>> +		return -ENXIO;
>>>> +	}
>>>
>>> What is this rcu_read_lock supposed to protect against given
>>> that struct alua_port_group isn't RCU freed?  I think this needs
>>> to be another kref_get_unless_zero.
>>>
>> It's not freed now, but it'll be with one of the next patches (ie wi=
th
>> the 'rescan' patch).
>> I just kept it here for consistency, following the rule to always
>> enclose 'rcu_dereference' with 'rcu_read_lock()/rcu_read_unlock()'
>> pairs. Irrespective on whether it's being freed or not.
>=20
> After this patch this is the only RCU call in the driver.  I don't
> think adding it here make any sense.
>=20
Right, I'll be moving it to the rescan patch then.

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
