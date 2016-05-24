From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [PATCHv2] libfc: Update rport reference counting
Date: Tue, 24 May 2016 09:39:04 -0700
Message-ID: <1464107944.29525.1.camel@linux.intel.com>
References: <1464070318-69866-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4642 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbcEXQjS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2016 12:39:18 -0400
In-Reply-To: <1464070318-69866-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Tue, 2016-05-24 at 08:11 +0200, Hannes Reinecke wrote:
> Originally libfc would just be initializing the refcount to '1',
> and using the disc_mutex to synchronize if and when the final put
> should be happening.
> This has a race condition as the mutex might be delayed, causing
> other threads to access an invalid structure.
> This patch updates the rport reference counting to increase the
> reference every time 'rport_lookup' is called, and decreases
> the reference correspondingly.
> This removes the need to hold 'disc_mutex' when removing the
> structure, and avoids the above race condition.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
> =C2=A0drivers/scsi/fcoe/fcoe_ctlr.c |=C2=A0=C2=A07 +------
> =C2=A0drivers/scsi/libfc/fc_lport.c | 19 ++++++++++-------
> =C2=A0drivers/scsi/libfc/fc_rport.c | 49 ++++++++++++++++++++++------=
-----
> ----------
> =C2=A03 files changed, 38 insertions(+), 37 deletions(-)
>=20
> diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c
> b/drivers/scsi/fcoe/fcoe_ctlr.c
> index 3e83d48..ada4bde 100644
> --- a/drivers/scsi/fcoe/fcoe_ctlr.c
> +++ b/drivers/scsi/fcoe/fcoe_ctlr.c
> @@ -2496,14 +2496,13 @@ static int fcoe_ctlr_vn_lookup(struct
> fcoe_ctlr *fip, u32 port_id, u8 *mac)
> =C2=A0	struct fcoe_rport *frport;
> =C2=A0	int ret =3D -1;
> =C2=A0
> -	rcu_read_lock();
> =C2=A0	rdata =3D lport->tt.rport_lookup(lport, port_id);
> =C2=A0	if (rdata) {
> =C2=A0		frport =3D fcoe_ctlr_rport(rdata);
> =C2=A0		memcpy(mac, frport->enode_mac, ETH_ALEN);
> =C2=A0		ret =3D 0;
> +		kref_put(&rdata->kref, lport->tt.rport_destroy);
> =C2=A0	}
> -	rcu_read_unlock();
> =C2=A0	return ret;
> =C2=A0}
> =C2=A0
> @@ -2585,11 +2584,7 @@ static void fcoe_ctlr_vn_beacon(struct
> fcoe_ctlr *fip,
> =C2=A0		fcoe_ctlr_vn_send(fip, FIP_SC_VN_PROBE_REQ,
> fcoe_all_vn2vn, 0);
> =C2=A0		return;
> =C2=A0	}
> -	mutex_lock(&lport->disc.disc_mutex);
> =C2=A0	rdata =3D lport->tt.rport_lookup(lport, new->ids.port_id);
> -	if (rdata)
> -		kref_get(&rdata->kref);
> -	mutex_unlock(&lport->disc.disc_mutex);
> =C2=A0	if (rdata) {
> =C2=A0		if (rdata->ids.node_name =3D=3D new->ids.node_name &&
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0rdata->ids.port_name =3D=3D new->ids.=
port_name) {
> diff --git a/drivers/scsi/libfc/fc_lport.c
> b/drivers/scsi/libfc/fc_lport.c
> index e01a298..b9b44da 100644
> --- a/drivers/scsi/libfc/fc_lport.c
> +++ b/drivers/scsi/libfc/fc_lport.c
> @@ -2090,7 +2090,7 @@ int fc_lport_bsg_request(struct fc_bsg_job
> *job)
> =C2=A0	struct fc_rport *rport;
> =C2=A0	struct fc_rport_priv *rdata;
> =C2=A0	int rc =3D -EINVAL;
> -	u32 did;
> +	u32 did, tov;
> =C2=A0
> =C2=A0	job->reply->reply_payload_rcv_len =3D 0;
> =C2=A0	if (rsp)
> @@ -2121,15 +2121,20 @@ int fc_lport_bsg_request(struct fc_bsg_job
> *job)
> =C2=A0
> =C2=A0	case FC_BSG_HST_CT:
> =C2=A0		did =3D ntoh24(job->request->rqst_data.h_ct.port_id);
> -		if (did =3D=3D FC_FID_DIR_SERV)
> +		if (did =3D=3D FC_FID_DIR_SERV) {
> =C2=A0			rdata =3D lport->dns_rdata;
> -		else
> +			if (!rdata)
> +				break;
> +			tov =3D rdata->e_d_tov;
> +		} else {
> =C2=A0			rdata =3D lport->tt.rport_lookup(lport, did);
> +			if (!rdata)
> +				break;
> +			tov =3D rdata->e_d_tov;
> +			kref_put(&rdata->kref, lport-
> >tt.rport_destroy);
> +		}
> =C2=A0
> -		if (!rdata)
> -			break;
> -
> -		rc =3D fc_lport_ct_request(job, lport, did, rdata-
> >e_d_tov);
> +		rc =3D fc_lport_ct_request(job, lport, did, tov);
> =C2=A0		break;
> =C2=A0
> =C2=A0	case FC_BSG_HST_ELS_NOLOGIN:
> diff --git a/drivers/scsi/libfc/fc_rport.c
> b/drivers/scsi/libfc/fc_rport.c
> index 589ff9a..93f5961 100644
> --- a/drivers/scsi/libfc/fc_rport.c
> +++ b/drivers/scsi/libfc/fc_rport.c
> @@ -95,17 +95,23 @@ static const char *fc_rport_state_names[] =3D {
> =C2=A0 * @lport:=C2=A0=C2=A0=C2=A0The local port to lookup the remote=
 port on
> =C2=A0 * @port_id: The remote port ID to look up
> =C2=A0 *
> - * The caller must hold either disc_mutex or rcu_read_lock().
> + * The reference count of the fc_rport_priv structure is
> + * increased by one.
> =C2=A0 */
> =C2=A0static struct fc_rport_priv *fc_rport_lookup(const struct fc_lp=
ort
> *lport,
> =C2=A0					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u32 port_id)
> =C2=A0{
> -	struct fc_rport_priv *rdata;
> +	struct fc_rport_priv *rdata =3D NULL, *tmp_rdata;
> =C2=A0
> -	list_for_each_entry_rcu(rdata, &lport->disc.rports, peers)
> -		if (rdata->ids.port_id =3D=3D port_id)
> -			return rdata;
> -	return NULL;
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(tmp_rdata, &lport->disc.rports,
> peers)
> +		if (tmp_rdata->ids.port_id =3D=3D port_id &&
> +		=C2=A0=C2=A0=C2=A0=C2=A0kref_get_unless_zero(&tmp_rdata->kref)) {
> +			rdata =3D tmp_rdata;
> +			break;
> +		}
> +	rcu_read_unlock();
> +	return rdata;
> =C2=A0}
> =C2=A0
> =C2=A0/**
> @@ -340,7 +346,6 @@ static void fc_rport_work(struct work_struct
> *work)
> =C2=A0			fc_remote_port_delete(rport);
> =C2=A0		}
> =C2=A0
> -		mutex_lock(&lport->disc.disc_mutex);
> =C2=A0		mutex_lock(&rdata->rp_mutex);
> =C2=A0		if (rdata->rp_state =3D=3D RPORT_ST_DELETE) {
> =C2=A0			if (port_id =3D=3D FC_FID_DIR_SERV) {
> @@ -370,7 +375,6 @@ static void fc_rport_work(struct work_struct
> *work)
> =C2=A0				fc_rport_enter_ready(rdata);
> =C2=A0			mutex_unlock(&rdata->rp_mutex);
> =C2=A0		}
> -		mutex_unlock(&lport->disc.disc_mutex);
> =C2=A0		break;
> =C2=A0
> =C2=A0	default:
> @@ -702,7 +706,7 @@ out:
> =C2=A0err:
> =C2=A0	mutex_unlock(&rdata->rp_mutex);
> =C2=A0put:
> -	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
> +	kref_put(&rdata->kref, lport->tt.rport_destroy);
> =C2=A0	return;
> =C2=A0bad:
> =C2=A0	FC_RPORT_DBG(rdata, "Bad FLOGI response\n");
> @@ -762,8 +766,6 @@ static void fc_rport_recv_flogi_req(struct
> fc_lport *lport,
> =C2=A0	FC_RPORT_ID_DBG(lport, sid, "Received FLOGI request\n");
> =C2=A0
> =C2=A0	disc =3D &lport->disc;
> -	mutex_lock(&disc->disc_mutex);
> -
> =C2=A0	if (!lport->point_to_multipoint) {
> =C2=A0		rjt_data.reason =3D ELS_RJT_UNSUP;
> =C2=A0		rjt_data.explan =3D ELS_EXPL_NONE;
> @@ -808,7 +810,7 @@ static void fc_rport_recv_flogi_req(struct
> fc_lport *lport,
> =C2=A0		mutex_unlock(&rdata->rp_mutex);
> =C2=A0		rjt_data.reason =3D ELS_RJT_FIP;
> =C2=A0		rjt_data.explan =3D ELS_EXPL_NOT_NEIGHBOR;
> -		goto reject;
> +		goto reject_put;
> =C2=A0	case RPORT_ST_FLOGI:
> =C2=A0	case RPORT_ST_PLOGI_WAIT:
> =C2=A0	case RPORT_ST_PLOGI:
> @@ -825,13 +827,13 @@ static void fc_rport_recv_flogi_req(struct
> fc_lport *lport,
> =C2=A0		mutex_unlock(&rdata->rp_mutex);
> =C2=A0		rjt_data.reason =3D ELS_RJT_BUSY;
> =C2=A0		rjt_data.explan =3D ELS_EXPL_NONE;
> -		goto reject;
> +		goto reject_put;
> =C2=A0	}
> =C2=A0	if (fc_rport_login_complete(rdata, fp)) {
> =C2=A0		mutex_unlock(&rdata->rp_mutex);
> =C2=A0		rjt_data.reason =3D ELS_RJT_LOGIC;
> =C2=A0		rjt_data.explan =3D ELS_EXPL_NONE;
> -		goto reject;
> +		goto reject_put;
> =C2=A0	}
> =C2=A0
> =C2=A0	fp =3D fc_frame_alloc(lport, sizeof(*flp));
> @@ -851,12 +853,13 @@ static void fc_rport_recv_flogi_req(struct
> fc_lport *lport,
> =C2=A0		fc_rport_state_enter(rdata, RPORT_ST_PLOGI_WAIT);
> =C2=A0out:
> =C2=A0	mutex_unlock(&rdata->rp_mutex);
> -	mutex_unlock(&disc->disc_mutex);
> +	kref_put(&rdata->kref, lport->tt.rport_destroy);
> =C2=A0	fc_frame_free(rx_fp);
> =C2=A0	return;
> =C2=A0
> +reject_put:
> +	kref_put(&rdata->kref, lport->tt.rport_destroy);
> =C2=A0reject:
> -	mutex_unlock(&disc->disc_mutex);
> =C2=A0	lport->tt.seq_els_rsp_send(rx_fp, ELS_LS_RJT, &rjt_data);
> =C2=A0	fc_frame_free(rx_fp);
> =C2=A0}
> @@ -923,7 +926,7 @@ out:
> =C2=A0	fc_frame_free(fp);
> =C2=A0err:
> =C2=A0	mutex_unlock(&rdata->rp_mutex);
> -	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
> +	kref_put(&rdata->kref, lport->tt.rport_destroy);
> =C2=A0}
> =C2=A0
> =C2=A0static bool
> @@ -1477,14 +1480,11 @@ static void fc_rport_recv_els_req(struct
> fc_lport *lport, struct fc_frame *fp)
> =C2=A0	struct fc_rport_priv *rdata;
> =C2=A0	struct fc_seq_els_data els_data;
> =C2=A0
> -	mutex_lock(&lport->disc.disc_mutex);
> =C2=A0	rdata =3D lport->tt.rport_lookup(lport, fc_frame_sid(fp));
> -	if (!rdata) {
> -		mutex_unlock(&lport->disc.disc_mutex);
> +	if (!rdata)
> =C2=A0		goto reject;
> -	}
> +
> =C2=A0	mutex_lock(&rdata->rp_mutex);
> -	mutex_unlock(&lport->disc.disc_mutex);
> =C2=A0
> =C2=A0	switch (rdata->rp_state) {
> =C2=A0	case RPORT_ST_PRLI:
> @@ -1494,6 +1494,7 @@ static void fc_rport_recv_els_req(struct
> fc_lport *lport, struct fc_frame *fp)
> =C2=A0		break;
> =C2=A0	default:
> =C2=A0		mutex_unlock(&rdata->rp_mutex);
> +		kref_put(&rdata->kref, lport->tt.rport_destroy);
> =C2=A0		goto reject;
> =C2=A0	}
> =C2=A0
> @@ -1524,6 +1525,7 @@ static void fc_rport_recv_els_req(struct
> fc_lport *lport, struct fc_frame *fp)
> =C2=A0	}
> =C2=A0
> =C2=A0	mutex_unlock(&rdata->rp_mutex);
> +	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
> =C2=A0	return;
> =C2=A0
> =C2=A0reject:
> @@ -1907,7 +1909,6 @@ static void fc_rport_recv_logo_req(struct
> fc_lport *lport, struct fc_frame *fp)
> =C2=A0
> =C2=A0	sid =3D fc_frame_sid(fp);
> =C2=A0
> -	mutex_lock(&lport->disc.disc_mutex);
> =C2=A0	rdata =3D lport->tt.rport_lookup(lport, sid);
> =C2=A0	if (rdata) {
> =C2=A0		mutex_lock(&rdata->rp_mutex);
> @@ -1916,10 +1917,10 @@ static void fc_rport_recv_logo_req(struct
> fc_lport *lport, struct fc_frame *fp)
> =C2=A0
> =C2=A0		fc_rport_enter_delete(rdata, RPORT_EV_LOGO);
> =C2=A0		mutex_unlock(&rdata->rp_mutex);
> +		kref_put(&rdata->kref, rdata->local_port-
> >tt.rport_destroy);
> =C2=A0	} else
> =C2=A0		FC_RPORT_ID_DBG(lport, sid,
> =C2=A0				"Received LOGO from non-logged-in
> port\n");
> -	mutex_unlock(&lport->disc.disc_mutex);
> =C2=A0	fc_frame_free(fp);
> =C2=A0}

Looks good.

Acked-by: Vasu Dev <vasu.dev@intel.com>
> =C2=A0
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
