From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 04/12] IB/srp: Fix connection state tracking
Date: Thu, 30 Apr 2015 12:08:14 -0400
Message-ID: <1430410094.102408.71.camel@redhat.com>
References: <5541EE21.3050809@sandisk.com> <5541EE9F.8090605@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-DWP/l3xBLtSdJrORhY/2"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbbD3QIT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2015 12:08:19 -0400
In-Reply-To: <5541EE9F.8090605@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


--=-DWP/l3xBLtSdJrORhY/2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-04-30 at 10:58 +0200, Bart Van Assche wrote:
> Reception of a DREQ message only causes the state of a single
> channel to change. Modify the SRP initiator such that channel
> and target connection state are tracked separately. This patch
> avoids that following false positive warning can be reported
> by srp_destroy_qp():
>=20
> WARNING: at drivers/infiniband/ulp/srp/ib_srp.c:617 srp_destroy_qp+0xa6/0=
x120 [ib_srp]()
> Call Trace:
> [<ffffffff8106e10f>] warn_slowpath_common+0x7f/0xc0
> [<ffffffff8106e16a>] warn_slowpath_null+0x1a/0x20
> [<ffffffffa0440226>] srp_destroy_qp+0xa6/0x120 [ib_srp]
> [<ffffffffa0440322>] srp_free_ch_ib+0x82/0x1e0 [ib_srp]
> [<ffffffffa044408b>] srp_create_target+0x7ab/0x998 [ib_srp]
> [<ffffffff81346f60>] dev_attr_store+0x20/0x30
> [<ffffffff811dd90f>] sysfs_write_file+0xef/0x170
> [<ffffffff8116d248>] vfs_write+0xc8/0x190
> [<ffffffff8116d411>] sys_write+0x51/0x90
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
> Cc: <stable@vger.kernel.org> #v3.19
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 7 ++++---
>  drivers/infiniband/ulp/srp/ib_srp.h | 1 +
>  2 files changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp=
/srp/ib_srp.c
> index 5ce6cfd..0eb07d3 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -465,14 +465,13 @@ static struct srp_fr_pool *srp_alloc_fr_pool(struct=
 srp_target_port *target)
>   */
>  static void srp_destroy_qp(struct srp_rdma_ch *ch)
>  {
> -	struct srp_target_port *target =3D ch->target;
>  	static struct ib_qp_attr attr =3D { .qp_state =3D IB_QPS_ERR };
>  	static struct ib_recv_wr wr =3D { .wr_id =3D SRP_LAST_WR_ID };
>  	struct ib_recv_wr *bad_wr;
>  	int ret;
> =20
>  	/* Destroying a QP and reusing ch->done is only safe if not connected *=
/
> -	WARN_ON_ONCE(target->connected);
> +	WARN_ON_ONCE(ch->connected);
> =20
>  	ret =3D ib_modify_qp(ch->qp, &attr, IB_QP_STATE);
>  	WARN_ONCE(ret, "ib_cm_init_qp_attr() returned %d\n", ret);
> @@ -836,6 +835,7 @@ static void srp_disconnect_target(struct srp_target_p=
ort *target)
> =20
>  		for (i =3D 0; i < target->ch_count; i++) {
>  			ch =3D &target->ch[i];
> +			ch->connected =3D false;
>  			if (ch->cm_id && ib_send_cm_dreq(ch->cm_id, NULL, 0)) {
>  				shost_printk(KERN_DEBUG, target->scsi_host,
>  					     PFX "Sending CM DREQ failed\n");
> @@ -1017,6 +1017,7 @@ static int srp_connect_ch(struct srp_rdma_ch *ch, b=
ool multich)
>  		switch (ch->status) {
>  		case 0:
>  			srp_change_conn_state(target, true);
> +			ch->connected =3D true;
>  			return 0;
> =20
>  		case SRP_PORT_REDIRECT:
> @@ -2367,7 +2368,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, s=
truct ib_cm_event *event)
>  	case IB_CM_DREQ_RECEIVED:
>  		shost_printk(KERN_WARNING, target->scsi_host,
>  			     PFX "DREQ received - connection closed\n");
> -		srp_change_conn_state(target, false);
> +		ch->connected =3D false;

So, in this patch, you modify disconnect to set srp_change_conn_state()
to false for the target, then loop through all the channels sending
cm_dreq's, and on the receiving side, you modify the cm_dreq handler to
set each channel to false.  However, once you get to 0 channels open,
shouldn't you then set the target state to false too just to keep things
consistent?

>  		if (ib_send_cm_drep(cm_id, NULL, 0))
>  			shost_printk(KERN_ERR, target->scsi_host,
>  				     PFX "Sending CM DREP failed\n");
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp=
/srp/ib_srp.h
> index a611556..95a4471 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.h
> +++ b/drivers/infiniband/ulp/srp/ib_srp.h
> @@ -170,6 +170,7 @@ struct srp_rdma_ch {
> =20
>  	struct completion	tsk_mgmt_done;
>  	u8			tsk_mgmt_status;
> +	bool			connected;
>  };
> =20
>  /**


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--=-DWP/l3xBLtSdJrORhY/2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVQlNuAAoJELgmozMOVy/dMzgQALtDLXBJ5wZqhAfoeB19wz9d
GTzmJmqYyGzDPJTYFN2I/KR9hLoB3q627cxeS9kr6NZyzETDGCvxwoDqvx1jr9Xj
1ystrDxEQ4ehiJt8ldwjZ3bYuVemK4mygJ3XEeScdd1oSI8ExyxXBmXNr1ptDj0u
fpq3THZezWWpOEij05Sf5b1TfnNGRxufGjRjzYiGD4X/OmScHqEAP28qgqgCSgr5
ghL/+NYGuq8rfzyQBwz/4hQ8A7X6QH8bO2AqPV+6xcfxhEVXjq6YQruuvQEsFRz9
sFwUDrDqB5PZWijhqrNT3N9stlKKjLPQV9VZBO9i2mBT4GFyJJO4TIS5f5/NYY5P
5Es/0E6w6TTK1MPavRzQezvjZ+xLz8upihZ+/kfq9VZj8MmZtBNbBKZm55S5pPyf
XYAT8shwC8OFRglGy6Kwkd+DEQv6APsnpzIncPOpkzfIf0xs6BYXeLlM1UrvB0xl
sVzhQwe8qy+/9omhyfjCUkqSFIGHxeb+OHyFvNi4aQlx9v5RN8qMJbyHPSN+gBrP
TCZng6ochYSy5l4L0L4O2U3P7J/WBOwP7vGQw7LLqVwhyLR4HHqWmrCtRmz6kXJY
dBz7RE2NEvCn+kRHfyQ/+VTDdQYkQSG/zY8dXpZETlKwLRFkXub6R9mz9YZLgKqe
to9g71Au8XdSD2IDiGup
=TBBH
-----END PGP SIGNATURE-----

--=-DWP/l3xBLtSdJrORhY/2--

