Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0477B35C190
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 20:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786999043; cv=none; b=KyGYC88uHz7NqjNhuDS60PgtBndC0I4poX1ZzT9GLt8U1ec6OT09UxqdJEgELVgZF5c5elUID3vX46ZsxZO2ytJGe4bme2phqwk9kn7BHxsLZNChkS3Y3i9YAM0TyBAUSIllfBt3SPtymY1gLP6xn01Kl0iypzgfWHEORud+h3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786999043; c=relaxed/simple;
	bh=qR+qmSBABhS1I5EtFGXEkCRFyFVPP7W9N1WhGQlUV/0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=R/rO6812LgP7URA3TsKDzS5/v+kqyDkXtdBjERlBV9bHOThlPDNz7x0s3iRdNTFVa4cYucMEGVYdaPeUCUiWwlbuAPqE6NP6uP2F+SJwQLvRupz66e759xKOt/gPxgTSzKMD/hyje6KvWtOVUnS0dlGaDBkuWcfx28yuD8fPmRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lsBwUAVB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lsBwUAVB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748DA1F000E9;
	Mon, 17 Aug 2026 20:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786999041;
	bh=JguY7+3noneRXrcYjhMEByGJffIsqPfiU1IPn7pQePU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lsBwUAVBMIzveGEogg0tVXipm/hxM7rDq4ZOXBmfyDO4xpK5Rt30nGvhAQAuDODGK
	 Y4x7RQ9Pr9a1hQFkGFkzdOZpKxmd4CmLkoSyxKnfd7dZ6JcU0Ph/fLlSJumkX2nuwO
	 nIEjrcCWDGn2+TZRJZaKhQln88F5FaqEar6Ath+UubcUXrzC/vOee2XW0MJSsboJjT
	 0BW5Q1Ch7ATgShXxIOv7U5fmg81Nk0zTSr/h8uqxZp7K9CNckzqoPJHO+nYGzpnJs5
	 NxJqxCBINABfnBIL/6R7QHKGQ1RFeezdC+g7034MQySVR/dQZFeHQdFueEwJPqm+cA
	 t3+bTBX9WTxdQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 1/8] scsi: ibmvfc: add basic FPIN support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260817-ibmvfc-fpin-support-v6-1-62a2d525e70d@linux.ibm.com>
References: <20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com>
 <20260817-ibmvfc-fpin-support-v6-1-62a2d525e70d@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 17 Aug 2026 20:37:20 +0000
Message-Id: <20260817203721.748DA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] The `fpin_workq` workqueue is destroyed too early during driver re=
moval, allowing a NULL pointer dereference if an FPIN event arrives before =
the CRQ is torn down.
- [Medium] KUnit test uses `KUNIT_EXPECT_NOT_NULL` instead of `KUNIT_ASSERT=
_NOT_NULL` on a pointer before dereferencing it, causing a crash if the poi=
nter is NULL.
- [Medium] KUnit test uses a hardcoded `msleep(1U)` to wait for workqueue e=
xecution, leading to race conditions and test flakiness.
- [Medium] KUnit test accesses global and host-specific lists without holdi=
ng the required locks, causing potential use-after-free or list corruption.
--

--- Patch [1]: [PATCH v6 1/8] scsi: ibmvfc: add basic FPIN support ---
commit ff91d1d40ba087181a6c3109c5264dac2870f637
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add basic FPIN support

Implement support for a basic level of Fabric Performance Impact
Notifications (FPIN) in the ibmvfc driver to enable monitoring of
fabric congestion and link integrity events. Offloads FPIN
processing to a dedicated workqueue and adds a KUnit test module.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 93b9f699c2e53..22b4d639e74be 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -6945,6 +7213,9 @@ static void ibmvfc_remove(struct vio_dev *vdev)
>  	ENTER;
>  	ibmvfc_remove_trace_file(&vhost->host->shost_dev.kobj, &ibmvfc_trace_at=
tr);
> =20
> +	destroy_workqueue(vhost->fpin_workq);
> +	vhost->fpin_workq =3D NULL;
> +

[Severity: High]
Is the fpin_workq destroyed too early during driver removal?

If an asynchronous FPIN event arrives from the fabric after this point but
before the CRQ is torn down in ibmvfc_release_crq_queue() later in the
function, ibmvfc_handle_async() could be called and attempt to queue work:

ibmvfc_handle_async()
    ...
    queue_work(vhost->fpin_workq, &aw->async_work_s);

Could this result in a NULL pointer dereference?

>  	spin_lock_irqsave(vhost->host->host_lock, flags);
>  	ibmvfc_link_down(vhost, IBMVFC_HOST_OFFLINE);
>  	spin_unlock_irqrestore(vhost->host->host_lock, flags);

[ ... ]

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> new file mode 100644
> index 0000000000000..64a517a74af8e
> --- /dev/null
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c

[ ... ]

> +static void ibmvfc_async_fpin_test(struct kunit *test)
> +{
> +	u64 post[IBMVFC_AE_FPIN_CONGESTION_CLEARED + 1];
> +	u64 pre[IBMVFC_AE_FPIN_CONGESTION_CLEARED + 1];
> +	enum ibmvfc_ae_fpin_status fs;
> +	struct fc_host_attrs *fc_host;
> +	struct ibmvfc_async_crq crq[IBMVFC_AE_FPIN_CONGESTION_CLEARED + 1];
> +	struct ibmvfc_target *tgt;
> +	struct ibmvfc_host *vhost;
> +	struct list_head *queue;
> +	struct list_head *headp;
> +
> +	headp =3D ibmvfc_get_headp();
> +	if (list_empty(headp))
> +		kunit_skip(test, "No ibmvfc devices available");
> +	queue =3D headp->next;
> +	vhost =3D container_of_const(queue, struct ibmvfc_host, queue);
> +
> +	KUNIT_ASSERT_GE_MSG(test, vhost->scsi_scrqs.num_targets, 1, "No targets=
");
> +	tgt =3D list_first_entry(&vhost->scsi_scrqs.targets, struct ibmvfc_targ=
et, queue);

[Severity: Medium]
Is it safe to iterate over the global ibmvfc_head list and access
vhost->scsi_scrqs.targets without acquiring the ibmvfc_driver_lock or
host_lock?

If a device is unbound or a target logs out concurrently while the test
runs, could the lists mutate and cause an invalid pointer dereference?

> +	KUNIT_EXPECT_NOT_NULL(test, tgt->rport);
> +
> +	fc_host =3D shost_to_fc_host(vhost->host);
> +
> +	pre[IBMVFC_AE_FPIN_LINK_CONGESTED] =3D READ_ONCE(fc_host->fpin_stats.cn=
_device_specific);
> +	pre[IBMVFC_AE_FPIN_PORT_CONGESTED] =3D READ_ONCE(tgt->rport->fpin_stats=
.cn);

[Severity: Medium]
Since KUNIT_EXPECT_NOT_NULL() allows execution to continue on failure, coul=
d a
NULL tgt->rport be immediately dereferenced on the following lines when rea=
ding
tgt->rport->fpin_stats.cn?

Should this use KUNIT_ASSERT_NOT_NULL() instead to abort the test and preve=
nt a
crash?

> +	pre[IBMVFC_AE_FPIN_PORT_CLEARED] =3D READ_ONCE(tgt->rport->fpin_stats.c=
n_clear);
> +	pre[IBMVFC_AE_FPIN_PORT_DEGRADED] =3D READ_ONCE(tgt->rport->fpin_stats.=
li_failure_unknown);
> +	pre[IBMVFC_AE_FPIN_CONGESTION_CLEARED] =3D READ_ONCE(fc_host->fpin_stat=
s.cn_clear);
> +
> +	for (fs =3D IBMVFC_AE_FPIN_LINK_CONGESTED; fs <=3D IBMVFC_AE_FPIN_CONGE=
STION_CLEARED; fs++) {
> +		crq[fs].valid =3D 0x80;
> +		crq[fs].link_state =3D IBMVFC_AE_LS_LINK_UP;
> +		crq[fs].fpin_status =3D fs;
> +		crq[fs].event =3D cpu_to_be64(IBMVFC_AE_FPIN);
> +		crq[fs].scsi_id =3D cpu_to_be64(tgt->scsi_id);
> +		crq[fs].wwpn =3D cpu_to_be64(tgt->wwpn);
> +		crq[fs].node_name =3D cpu_to_be64(tgt->ids.node_name);
> +		ibmvfc_handle_async(&crq[fs], vhost);
> +		msleep(1U);
> +	}

[Severity: Medium]
Is msleep(1U) a reliable way to wait for the fpin_workq to process the
offloaded FPIN event?

Under load, it seems like 1 millisecond might be insufficient, causing the =
test
to read stale counters and fail intermittently. Would it be safer to use
flush_workqueue(vhost->fpin_workq) here instead of a hardcoded sleep?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260817-ibmvfc-fpi=
n-support-v6-0-62a2d525e70d@linux.ibm.com?part=3D1
