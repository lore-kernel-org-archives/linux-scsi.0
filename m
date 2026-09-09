Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB5556B849
	for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2026 19:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788982168; cv=none; b=V3mnFXMdUx5xv3QLPGR599SNYSGBuNa5NG4Dv+XxsFsMOSpnXzoK9i+6WcA6Gq2gbFzlWkiDUQiayVC3XlRhimKwJx8IfQfp2FMSmvLt/OmTgrf3V+vH4JhTeMxAdPr1/hXnpx8YVNOE/sE1sG5Hi4QzleXy+cnx9/GgNQCgYq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788982168; c=relaxed/simple;
	bh=qqzVzk6BBua7RE50MVG1Q49aBmUG2bMnob5VDXKeQB4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=p/RdsY8Q1F6ljhvC3pSosMWMyFcxUdMK4raAmACUVDWs49LUYlUErB7+taCNcuYCIV3hWGJ1jW4SGofDzRolmiTP4ILei0V4KdWK5rBc7NEeJKDXCq7tyHIOX1WKNHZIqmg9o+IGEoRgj8wJyjJs/gfswmBzaIfmJTfTzQQsY74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DUd1j4i3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DUd1j4i3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842681F000FF;
	Wed,  9 Sep 2026 19:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788982161;
	bh=9Qf/WIui4al7fbJJF4YWKFBe0cYvAepghubTO/i6hvg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DUd1j4i3M61PlYPVXpwZi5Ya7pZ/chZnSgIQ9A2KoU3TGx4Hb30vZMkQph8roz+m0
	 eodPY61OLb2KUfZ4O1StN4aFwx1aVhIG33BdQf4U6ULemFQK/HHRJ2beH265xjgA55
	 lnxNE6yJlxFNSdN+RvWahPRyAmJum3mpUboNRbbe9SuYRccrDhNJezOm1QxydCEvAt
	 w2XvGrm12JGNS62gt9Yc8rithjCZsruOoe5NXtA2C7uPqv36pVGl8SPrM4ZTeEtT6V
	 CC8Hw8ouC1m9dQfPjinyU/LShSZQUQdm1PUBoeKsUKY7hg9+p0l9UssqhlmCNTpQQd
	 cVAsDdHSdIG2w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 1/9] scsi: ibmvfc: add basic FPIN support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260909-ibmvfc-fpin-support-v8-1-b27183b055af@linux.ibm.com>
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
 <20260909-ibmvfc-fpin-support-v8-1-b27183b055af@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 19:29:21 +0000
Message-Id: <20260909192921.842681F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Reordering `scsi_remove_host()` to execute after `ibmvfc_release_c=
rq_queue()` causes a reliable deadlock and an infinite command requeue loop=
 during module removal.
- [Medium] NVMe over FC targets will not process FPIN events because they a=
re incorrectly filtered out by `ibmvfc_find_target`.
- [Medium] Missing `put_device()` and `scsi_host_put()` in the KUnit test `=
ibmvfc_async_fpin_test` causes resource leaks.
--

commit bba4f1f01d900a3f01556bca91e5e90f72a7c959
Author: Dave Marquardt <davemarq@linux.ibm.com>
Subject: scsi: ibmvfc: add basic FPIN support

This commit implements support for a basic level of Fabric Performance
Impact Notifications (FPIN) in the ibmvfc driver. It adds an async event
handler for IBMVFC_AE_FPIN events that offloads processing to a dedicated
workqueue, along with FPIN conversion routines and a KUnit test module.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index b3bc3ce872d6d..0dde8dcf43de3 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -3261,16 +3266,259 @@ static const char *ibmvfc_get_link_state(enum ib=
mvfc_ae_link_state state)
> +static struct ibmvfc_target *ibmvfc_find_target(struct list_head *target=
_list,
> +						__be64 scsi_id, __be64 wwpn,
> +						__be64 node_name)
> +{
> +	struct ibmvfc_target *tgt;
> +
> +	list_for_each_entry(tgt, target_list, queue) {
> +		if (scsi_id && cpu_to_be64(tgt->scsi_id) !=3D scsi_id)
> +			continue;
> +		if (wwpn && cpu_to_be64(tgt->ids.port_name) !=3D wwpn)
> +			continue;
> +		if (node_name && cpu_to_be64(tgt->ids.node_name) !=3D node_name)
> +			continue;
> +		if (!tgt->rport)
> +			continue;

[Severity: Medium]
Does this check unintentionally filter out NVMe over FC targets?

Since NVMe targets populate tgt->nvme_remote_port instead of tgt->rport,
this check forces ibmvfc_find_target() to always skip them.

> +		return tgt;
> +	}
> +
> +	return NULL;
> +}
> +
> +/**
> + * ibmvfc_process_async_work - Process IBMVFC_AE_FPIN async CRQ from wor=
k queue
> + * @work: pointer to work_struct
> + */
> +static void ibmvfc_process_async_work(struct work_struct *work)
> +{

[ ... ]

> +	spin_lock_irqsave(vhost->host->host_lock, flags);
> +	tgt =3D ibmvfc_find_target(&vhost->scsi_scrqs.targets, crq->scsi_id,
> +				 crq->wwpn, crq->node_name);
> +	if (!tgt) {
> +		/* Target not found in scsi_scrqs, search nvme_scrqs */
> +		tgt =3D ibmvfc_find_target(&vhost->nvme_scrqs.targets,
> +					 crq->scsi_id, crq->wwpn,
> +					 crq->node_name);
> +	}

[Severity: Medium]
Because of the rport check in ibmvfc_find_target() mentioned above, won't
this fallback search for NVMe targets always return NULL?

This appears to be dead code that will cause Fabric Performance Impact
Notifications for NVMe over FC targets to be silently dropped.

[ ... ]

> @@ -6952,8 +7221,6 @@ static void ibmvfc_remove(struct vio_dev *vdev)
>  	ibmvfc_wait_while_resetting(vhost);
>  	kthread_stop(vhost->work_thread);
>  	flush_work(&vhost->rport_add_work_q);
> -	fc_remove_host(vhost->host);
> -	scsi_remove_host(vhost->host);
> =20
>  	spin_lock_irqsave(vhost->host->host_lock, flags);
>  	ibmvfc_purge_requests(vhost, DID_ERROR);
> @@ -6962,6 +7229,10 @@ static void ibmvfc_remove(struct vio_dev *vdev)
>  	ibmvfc_complete_purge(&purge);
>  	ibmvfc_release_sub_crqs(vhost);
>  	ibmvfc_release_crq_queue(vhost);
> +	destroy_workqueue(vhost->fpin_workq);
> +	vhost->fpin_workq =3D NULL;
> +	fc_remove_host(vhost->host);
> +	scsi_remove_host(vhost->host);

[Severity: High]
Can this reordering of scsi_remove_host() cause an infinite stall during
module removal?

By the time scsi_remove_host() is called here, ibmvfc_release_crq_queue()
has already run, overwriting the host state to IBMVFC_NO_CRQ. When the
SCSI midlayer attempts to flush devices during removal,
ibmvfc_host_chkready() will return DID_REQUEUE. The midlayer will retry
the command repeatedly, leading to a deadlock since the hardware
communication queues are already gone.

[ ... ]

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> new file mode 100644
> index 0000000000000..80e7f8e0fd700
> --- /dev/null
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c

[ ... ]

> +static void ibmvfc_async_fpin_test(struct kunit *test)
> +{

[ ... ]

> +	KUNIT_EXPECT_EQ(test, pre[IBMVFC_AE_FPIN_PORT_DEGRADED],
> +			post[IBMVFC_AE_FPIN_PORT_DEGRADED]);
> +	KUNIT_EXPECT_EQ(test, pre[IBMVFC_AE_FPIN_CONGESTION_CLEARED],
> +			post[IBMVFC_AE_FPIN_CONGESTION_CLEARED]);
> +
> +	kref_put(&tgt->kref, ibmvfc_release_tgt);
> +}

[Severity: Medium]
Does this exit path leak the references to vhost->host and rport->dev?

The test acquires references via ibmvfc_get_first_vhost() and
get_device(&rport->dev) during initialization, but appears to omit the
corresponding scsi_host_put() and put_device() calls at the end of the
test, unlike the sibling tests in this module.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-ibmvfc-fpi=
n-support-v8-0-b27183b055af@linux.ibm.com?part=3D1
