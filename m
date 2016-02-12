From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 22/23] scsi_dh_alua: update 'access_state' field
Date: Fri, 12 Feb 2016 08:20:20 +0100
Message-ID: <56BD87B4.7060702@suse.de>
References: <1454942086-128704-1-git-send-email-hare@suse.de>
 <1454942086-128704-23-git-send-email-hare@suse.de>
 <1455223025.22112.340.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbcBLHUW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Feb 2016 02:20:22 -0500
In-Reply-To: <1455223025.22112.340.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 02/11/2016 09:37 PM, Ewan Milne wrote:
> On Mon, 2016-02-08 at 15:34 +0100, Hannes Reinecke wrote:
>> Track attached SCSI devices and update the 'access_state' field
>> whenever an ALUA state change has been detected.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/device_handler/scsi_dh_alua.c | 45 +++++++++++++++++++=
+++++++++--
>>  1 file changed, 43 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/sc=
si/device_handler/scsi_dh_alua.c
>> index 51126b78..7bcc075 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -24,6 +24,7 @@
>>  #include <linux/module.h>
>>  #include <asm/unaligned.h>
>>  #include <scsi/scsi.h>
>> +#include <scsi/scsi_proto.h>
>>  #include <scsi/scsi_dbg.h>
>>  #include <scsi/scsi_eh.h>
>>  #include <scsi/scsi_dh.h>
>> @@ -75,6 +76,7 @@ struct alua_port_group {
>>  	struct kref		kref;
>>  	struct rcu_head		rcu;
>>  	struct list_head	node;
>> +	struct list_head	dh_list;
>>  	unsigned char		device_id_str[256];
>>  	int			device_id_len;
>>  	int			group_id;
>> @@ -92,6 +94,7 @@ struct alua_port_group {
>>  };
>> =20
>>  struct alua_dh_data {
>> +	struct list_head	node;
>>  	struct alua_port_group	*pg;
>>  	int			group_id;
>>  	spinlock_t		pg_lock;
>> @@ -247,6 +250,7 @@ struct alua_port_group *alua_alloc_pg(struct scs=
i_device *sdev,
>>  	INIT_DELAYED_WORK(&pg->rtpg_work, alua_rtpg_work);
>>  	INIT_LIST_HEAD(&pg->rtpg_list);
>>  	INIT_LIST_HEAD(&pg->node);
>> +	INIT_LIST_HEAD(&pg->dh_list);
>>  	spin_lock_init(&pg->lock);
>> =20
>>  	spin_lock(&port_group_lock);
>> @@ -328,6 +332,8 @@ static int alua_check_vpd(struct scsi_device *sd=
ev, struct alua_dh_data *h,
>>  {
>>  	int rel_port =3D -1, group_id;
>>  	struct alua_port_group *pg, *old_pg =3D NULL;
>> +	bool pg_updated;
>> +	unsigned long flags;
>> =20
>>  	group_id =3D scsi_vpd_tpg_id(sdev, &rel_port);
>>  	if (group_id < 0) {
>> @@ -357,13 +363,25 @@ static int alua_check_vpd(struct scsi_device *=
sdev, struct alua_dh_data *h,
>>  	old_pg =3D h->pg;
>>  	if (old_pg !=3D pg) {
>>  		/* port group has changed. Update to new port group */
>> +		if (h->pg) {
>> +			spin_lock_irqsave(&old_pg->lock, flags);
>> +			list_del_rcu(&h->node);
>> +			spin_unlock_irqrestore(&old_pg->lock, flags);
>> +		}
>>  		rcu_assign_pointer(h->pg, pg);
>> +		pg_updated =3D true;
>>  	}
>>  	if (sdev->synchronous_alua)
>>  		pg->flags |=3D ALUA_SYNC_STPG;
>>  	alua_rtpg_queue(h->pg, sdev, NULL, true);
>>  	spin_unlock(&h->pg_lock);
>> =20
>> +	if (pg_updated) {
>> +		spin_lock_irqsave(&pg->lock, flags);
>> +		list_add_rcu(&h->node, &pg->dh_list);
>> +		spin_unlock_irqrestore(&pg->lock, flags);
>> +	}
>> +
>>  	if (old_pg)
>>  		kref_put(&old_pg->kref, release_port_group);
>> =20
>> @@ -613,8 +631,18 @@ static int alua_rtpg(struct scsi_device *sdev, =
struct alua_port_group *pg)
>>  			if (spin_trylock_irqsave(&tmp_pg->lock, flags)) {
>>  				if ((tmp_pg =3D=3D pg) ||
>>  				    !(tmp_pg->flags & ALUA_PG_RUNNING)) {
>> +					struct alua_dh_data *h;
>> +
>>  					tmp_pg->state =3D desc[0] & 0x0f;
>>  					tmp_pg->pref =3D desc[0] >> 7;
>> +					rcu_read_lock();
>> +					list_for_each_entry_rcu(h,
>> +						&tmp_pg->dh_list, node) {
>> +						/* h->sdev should always be valid */
>> +						BUG_ON(!h->sdev);
>> +						h->sdev->access_state =3D desc[0];
>=20
> Here you did not mask desc[0] with 0x0f like you did in other places =
in the code.
>=20
Because the access_state field is a 1:1 copy of the 'desc[0]' field,
containing both the value and the pref bit.

>> +					}
>> +					rcu_read_unlock();
>>  				}
>>  				if (tmp_pg =3D=3D pg)
>>  					valid_states =3D desc[1];
>> @@ -646,10 +674,19 @@ static int alua_rtpg(struct scsi_device *sdev,=
 struct alua_port_group *pg)
>>  			pg->interval =3D 2;
>>  			err =3D SCSI_DH_RETRY;
>>  		} else {
>> +			struct alua_dh_data *h;
>> +
>>  			/* Transitioning time exceeded, set port to standby */
>>  			err =3D SCSI_DH_IO;
>>  			pg->state =3D SCSI_ACCESS_STATE_STANDBY;
>>  			pg->expiry =3D 0;
>> +			rcu_read_lock();
>> +			list_for_each_entry_rcu(h, &pg->dh_list, node) {
>> +				BUG_ON(!h->sdev);
>> +				h->sdev->access_state =3D (pg->state & 0x0f) |
>> +					(pg->pref << 7);
>=20
> Since SCSI_ACCESS_STATE_PREFERRED is #defined as 0x80 in scsi_proto.h=
 you
> should use | (pg->pref ? SCSI_ACCESS_STATE_PREFERRED : 0) here rather=
 than
> just shifting, otherwise you will have a hard to find bug if somebody
> changes the constant.  (But I would prefer keeping them separate anyw=
ay.)
>=20
_Actually_ I was pondering to make it the other way around, namely
shifting pg->pref on top of pg->state, then this whole thing would
become a simple assignment.
But I didn't as I wanted to keep the original code as-is.

So yeah, there is an inconsistency, but some I would like to resolve
in exactly the other direction :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
