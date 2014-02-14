From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/16] scsi_dh_alua: Use separate alua_port_group structure
Date: Fri, 14 Feb 2014 13:16:32 +0100
Message-ID: <52FE0920.60105@suse.de>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-8-git-send-email-hare@suse.de> <52FE045F.8050603@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54481 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbaBNMQe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Feb 2014 07:16:34 -0500
In-Reply-To: <52FE045F.8050603@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 02/14/2014 12:56 PM, Bart Van Assche wrote:
> On 01/31/14 10:29, Hannes Reinecke wrote:
>> +static void release_port_group(struct kref *kref)
>> +{
>> +	struct alua_port_group *pg;
>> +
>> +	pg =3D container_of(kref, struct alua_port_group, kref);
>> +	printk(KERN_WARNING "alua: release port group %d\n", pg->group_id)=
;
>> +	spin_lock(&port_group_lock);
>> +	list_del(&pg->node);
>> +	spin_unlock(&port_group_lock);
>> +	if (pg->buff && pg->inq !=3D pg->buff)
>> +		kfree(pg->buff);
>> +	kfree(pg);
>> +}
>=20
> Does that message really need level "WARNING" ?
>=20
>> +	sdev_printk(KERN_INFO, sdev,
>> +		    "%s: port group %02x rel port %02x\n",
>> +		    ALUA_DH_NAME, group_id, h->rel_port);
>> +	spin_lock(&port_group_lock);
>> +	pg =3D kzalloc(sizeof(struct alua_port_group), GFP_KERNEL);
>> +	if (!pg) {
>> +		sdev_printk(KERN_WARNING, sdev,
>> +			    "%s: kzalloc port group failed\n",
>> +			    ALUA_DH_NAME);
>> +		/* Temporary failure, bypass */
>> +		spin_unlock(&port_group_lock);
>> +		err =3D SCSI_DH_DEV_TEMP_BUSY;
>> +		goto out;
>> +	}
>> +	pg->group_id =3D group_id;
>> +	pg->buff =3D pg->inq;
>> +	pg->bufflen =3D ALUA_INQUIRY_SIZE;
>> +	pg->tpgs =3D h->tpgs;
>> +	pg->state =3D TPGS_STATE_OPTIMIZED;
>> +	pg->flags =3D h->flags;
>> +	kref_init(&pg->kref);
>> +	list_add(&pg->node, &port_group_list);
>> +	h->pg =3D pg;
>> +	spin_unlock(&port_group_lock);
>> +	err =3D SCSI_DH_OK;
>=20
> A GFP_KERNEL allocation with a spin lock held ?? Please move that
> allocation outside the critical section and also the code for
> initializing *pg. What's not clear to me is why no uniqueness check i=
s
> performed before invoking list_add() ? Does that mean that informatio=
n
> for the same port group ID can end up multiple times in the
> port_group_list ? Such a uniqueness check can only be performed if a
> storage array identification is available so patches 07 and 08 may ha=
ve
> to be swapped.
>=20
With this patch I'm allocating one pg per sdev, so I won't need any
uniqueness check here (sdevs are already unique).
I only need to check for uniqueness once I have array identifiers.

But yes, the allocation can be moved to outside the critical section.

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
