From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/17] scsi_dh_alua: Use separate alua_port_group structure
Date: Thu, 07 May 2015 15:37:47 +0200
Message-ID: <554B6AAB.6080300@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-11-git-send-email-hare@suse.de> <554B5BD8.2090605@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46616 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbbEGNhs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2015 09:37:48 -0400
In-Reply-To: <554B5BD8.2090605@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 05/07/2015 02:34 PM, Bart Van Assche wrote:
> On 05/04/15 14:42, Hannes Reinecke wrote:
>> +static void release_port_group(struct kref *kref)
>> +{
>> +    struct alua_port_group *pg;
>> +
>> +    pg =3D container_of(kref, struct alua_port_group, kref);
>> +    printk(KERN_WARNING "alua: release port group %d\n",
>> pg->group_id);
>=20
> Does this really need to be a warning ?
>=20
No, you are right. This it mainly for debugging.

>> +    spin_lock(&port_group_lock);
>> +    pg =3D kzalloc(sizeof(struct alua_port_group), GFP_ATOMIC);
>> +    if (!pg) {
>> +        sdev_printk(KERN_WARNING, sdev,
>> +                "%s: kzalloc port group failed\n",
>> +                ALUA_DH_NAME);
>> +        /* Temporary failure, bypass */
>> +        spin_unlock(&port_group_lock);
>> +        return SCSI_DH_DEV_TEMP_BUSY;
>> +    }
>> +    pg->group_id =3D group_id;
>> +    pg->buff =3D pg->inq;
>> +    pg->bufflen =3D ALUA_INQUIRY_SIZE;
>> +    pg->tpgs =3D h->tpgs;
>> +    pg->state =3D TPGS_STATE_OPTIMIZED;
>> +    kref_init(&pg->kref);
>> +    list_add(&pg->node, &port_group_list);
>> +    h->pg =3D pg;
>> +    spin_unlock(&port_group_lock);
>=20
> Sorry but it's not clear to me why the kzalloc() statement happens
> under port_group_lock. Please consider to perform only the
> list_add() statement under port_group_lock, to perform all other
> assignments without holding that lock and to change GFP_ATOMIC into
> GFP_KERNEL.
>=20
Right, kzalloc() doesn't need to happen under the lock.

>> -    len =3D (h->buff[0] << 24) + (h->buff[1] << 16) +
>> -        (h->buff[2] << 8) + h->buff[3] + 4;
>> +    len =3D (pg->buff[0] << 24) + (pg->buff[1] << 16) +
>> +        (pg->buff[2] << 8) + pg->buff[3] + 4;
>=20
> Has it been considered to use get_unaligned_be32() instead ?
>=20
Okay, will do.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
