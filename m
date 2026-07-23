Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6AB1DA0E1
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784767808; cv=none; b=EkwCQvI7Jf4Eny/bcW4oqMRh5UvM7zDN11kD/pMSOZzksRJUvQuzWgtO7bA+5mum7nLN2xeqYDYPl6WpCZRTr6qjLjqxWKeZtNOD7HPE1owPuo/M4Dl9fktB41prxtDuuoD4LanNdRLYrgqPhIE0KyOfT1sCcfuk0gfUnIhmOSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784767808; c=relaxed/simple;
	bh=4N9fmAGzFyKJCsBH7bHdw2DxslZXr2JuoKkOJiQN8TY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lbyX3AViTVVh7vhoLfepMyBCEZNRiHoioLf0PouSfLl6h17ugmE/WevlkuXbwgE4h7/pueQClLfX4kmvEV2dDCay9jAsZvbK/Jz7QE2Q81lpUJyNNX13by/ozdJ+31Cv3iX2xcQaLUFD6Ib8b+V/Qp6djtvCU/aM9MvYwwIuGeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WKIRZWUl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WKIRZWUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EE21F00A3A;
	Thu, 23 Jul 2026 00:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784767806;
	bh=lITSwjkPFl1Q1+qc2UZjSUEupMnHM9PuQhkyXyiONA0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WKIRZWUlYf8+bXvAzouPiiV4s8x8OSs00oXDJiXB0cXMkpziWW4jrfdmUjjunSNvX
	 2C9F0mnMtYwJ2Jqj9WrjfSiWW25gRv0Gp0rLVlDyNyzgj4e2vc5dObncToim6wjAnq
	 J+VgfRhx+y8zYOSA07PnRL9Puub0lqMgwvFcV1cRGbdJqM8P3agXNskyF59mEEQXtY
	 sGCFGCMhaON3H07zkUNjC2QgCk/Z/eQHUHPqz9G5P5b0ffJgPYhugxZCaQaBEfS+va
	 AotLsRJT4ENCq3aYotoa4QbJVwPmxFrBluz7saa+h+fwz+1JHeQZe4g99bI3UGaDBh
	 Wihbmar7dNwTA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 25/33] ibmvfc: process NVMe/FC rports in work thread
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-26-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-26-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:50:06 +0000
Message-Id: <20260723005006.C7EE21F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Uninitialized variable `rport` used in NVMe target cleanup loop, l=
eading to random state machine stalls.
- [High] Data race on `tgt->nvme_remote_port` causes NVMe remote port memor=
y leak and dangling pointer.
- [High] Use-After-Free of NVMe remote port during concurrent unregistratio=
n.
--

--- Patch [25]: [PATCH v2 25/33] ibmvfc: process NVMe/FC rports in work thr=
ead ---
commit 5ac14eea9ebcccbdd022d855ccc9eba7a87b95be
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: process NVMe/FC rports in work thread

This commit adds NVMe-specific remote-port handling to the rport worker thr=
ead.
It registers new NVMe remote ports, rescans existing ones, and manages remo=
te
port deletion transitions within the same worker context used for SCSI targ=
ets.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 81d9229bf388a..ffb579816e847 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -5856,6 +5856,51 @@ static void ibmvfc_log_ae(struct ibmvfc_host *vhos=
t, int events)
>  		fc_host_post_event(vhost->host, fc_get_event_number(), FCH_EVT_LINKUP,=
 0);
>  }
> =20
> +/**
> + * ibmvfc_tgt_add_nvme_rport - Tell the FC transport about a new remote =
port
> + * @tgt:		ibmvfc target struct
> + *
> + **/
> +static void ibmvfc_tgt_add_nvme_rport(struct ibmvfc_target *tgt)
> +{
> +	struct ibmvfc_host *vhost =3D tgt->vhost;
> +	struct nvme_fc_remote_port *rport;
> +	unsigned long flags;
> +
> +	tgt_dbg(tgt, "Adding NVMe rport\n");
> +	ibmvfc_nvme_register_remoteport(tgt);
> +	spin_lock_irqsave(vhost->host->host_lock, flags);
> +	rport =3D tgt->nvme_remote_port;
> +
> +	if (rport && tgt->action =3D=3D IBMVFC_TGT_ACTION_DEL_RPORT) {
> +		tgt_dbg(tgt, "Deleting NVMe rport\n");
> +		list_del(&tgt->queue);
> +		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DELETED_RPORT);
> +		spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +		ibmvfc_nvme_unregister_remoteport(tgt);
> +		timer_delete_sync(&tgt->timer);
> +		kref_put(&tgt->kref, ibmvfc_release_tgt);
> +		return;
> +	} else if (rport && tgt->action =3D=3D IBMVFC_TGT_ACTION_DEL_AND_LOGOUT=
_RPORT) {
> +		tgt_dbg(tgt, "Deleting NVMe rport with outstanding I/O\n");
> +		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT);
> +		tgt->init_retries =3D 0;
> +		spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +		ibmvfc_nvme_unregister_remoteport(tgt);
> +		return;
> +	} else if (rport && tgt->action =3D=3D IBMVFC_TGT_ACTION_DELETED_RPORT)=
 {

[Severity: High]
Does this sequence create a data race and memory leak of the NVMe remote po=
rt?

If ibmvfc_nvme_register_remoteport() updates tgt->nvme_remote_port without
holding vhost->host->host_lock:

CPU1 in ibmvfc_tgt_add_nvme_rport():
    ibmvfc_nvme_register_remoteport(tgt);=20

CPU2 in ibmvfc_do_work():
    spin_lock_irqsave(...)
    nvme_rport =3D tgt->nvme_remote_port;=20
    list_del(&tgt->queue);
    ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DELETED_RPORT);
    spin_unlock_irqrestore(...)
    // skips unregister because nvme_rport was read as NULL

Then CPU1 resumes in ibmvfc_tgt_add_nvme_rport():
    spin_lock_irqsave(...)
    if (... tgt->action =3D=3D IBMVFC_TGT_ACTION_DELETED_RPORT) {
        spin_unlock_irqrestore(...)
        return;=20
    }

Could this permanently leak the port structure and leave a dangling pointer=
 in
the NVMe transport by returning without unregistering the newly allocated p=
ort?

> +		spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +		return;
> +	}
> +
> +	if (rport) {
> +		tgt_dbg(tgt, "NVMe rport add succeeded\n");
> +		tgt->target_id =3D tgt->nvme_remote_port->port_id;
> +	} else
> +		tgt_dbg(tgt, "NVMe rport add failed\n");
> +	spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +}

[ ... ]

> @@ -6073,6 +6119,30 @@ static void ibmvfc_do_work(struct ibmvfc_host *vho=
st)
>  			}
>  		}
> =20
> +		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue) {
> +			if (tgt->action =3D=3D IBMVFC_TGT_ACTION_DEL_RPORT) {
> +				tgt_dbg(tgt, "Deleteing NVMe rport\n");
> +				nvme_rport =3D tgt->nvme_remote_port;
> +				list_del(&tgt->queue);
> +				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DELETED_RPORT);
> +				spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +				if (nvme_rport)
> +					ibmvfc_nvme_unregister_remoteport(tgt);
> +				timer_delete_sync(&tgt->timer);
> +				kref_put(&tgt->kref, ibmvfc_release_tgt);
> +				return;
> +			} else if (rport && tgt->action =3D=3D IBMVFC_TGT_ACTION_DEL_AND_LOGO=
UT_RPORT) {

[Severity: High]
Is rport uninitialized or containing stale data here?

This loop iterates over nvme_scrqs.targets, but rport is the local variable
used for the SCSI targets loop earlier in the function. If the preceding SC=
SI
loop exits early or finds no targets, rport could evaluate to false based on
uninitialized stack memory.

Should this use nvme_rport instead of rport? Also, if the registration fail=
ed
and the port pointer is NULL, does gating this state transition on port
existence cause the target to stall in the state machine indefinitely?

> +				tgt_dbg(tgt, "Deleting NVMe rport with outstanding I/O\n");
> +				nvme_rport =3D tgt->nvme_remote_port;
> +				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT);
> +				tgt->init_retries =3D 0;
> +				spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +				if (nvme_rport)
> +					ibmvfc_nvme_unregister_remoteport(tgt);
> +				return;
> +			}
> +		}
> +

[ ... ]

> @@ -6691,7 +6762,28 @@ static void ibmvfc_rport_add_thread(struct work_st=
ruct *work)
>  				break;
>  			}
>  		}
> -	} while(did_work);
> +
> +		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue) {
> +			if (tgt->add_rport) {
> +				did_work =3D 1;
> +				tgt->add_rport =3D 0;
> +				kref_get(&tgt->kref);
> +				nvme_rport =3D tgt->nvme_remote_port;
> +				if (!nvme_rport) {
> +					spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +					ibmvfc_tgt_add_nvme_rport(tgt);
> +				} else {
> +					spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +					if (IS_ENABLED(CONFIG_NVME_FC))
> +						nvme_fc_rescan_remoteport(nvme_rport);

[Severity: High]
Can nvme_rport be freed while nvme_fc_rescan_remoteport() is running?

Once host_lock is dropped, a concurrent thread executing ibmvfc_do_work() c=
ould
transition the target to IBMVFC_TGT_ACTION_DEL_RPORT and call
ibmvfc_nvme_unregister_remoteport(), which frees the remote port.

The legacy SCSI code in this thread pins the port using get_device(&rport->=
dev)
before dropping the lock. Should a similar reference be taken for the NVMe
remote port before calling rescan?

> +				}
> +
> +				kref_put(&tgt->kref, ibmvfc_release_tgt);
> +				spin_lock_irqsave(vhost->host->host_lock, flags);
> +				break;
> +			}
> +		}
> +	} while (did_work);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D25
