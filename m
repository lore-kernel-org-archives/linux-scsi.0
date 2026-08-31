Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1441390C95
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 21:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788211805; cv=none; b=MlNFtbwv52f0ApGCkxykLE87bOMQnRMVK9Enk2pJ6Sg6sQ/Krl6DEEGcKpxDOT4eLEEmz4HotN71DQB9cpVKMVxfAN5mM9JSd4jWyNjzCrSq1XLlm8+XTMeDNhy23rcGM46vZvvJULgqZfzMwYYWuBluyw15Hb45ZR4kaxVrmjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788211805; c=relaxed/simple;
	bh=qI0Jd9kcX/P8qyWypGtAO6TKESib7q8M5js8BJbfP/k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=C8RSm7QXSP/+rvOY/65991ZzZ706oKM6IvejfVM06GrbIxwykpiO1+8kGtt8QDDiaeh+Xe/VNE2JwYLqzeoE1t/U2Tx3WNwtiv98PmSWbjSNc//YioT4zTjwfa1yy5IJmEh3xqT9vZpVpNp50UsG1QK2alnuB9BPIiM/Lsciujc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U2lOY+NT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U2lOY+NT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085A21F000E9;
	Mon, 31 Aug 2026 21:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788211804;
	bh=SYhZW5T+0udyCYzPIa6QVqseB96tf7U0qppunFMmvz0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U2lOY+NTULqrDq7Xglo3e2Rl6EuArNApCqL9homM9kL4dDrk8CEVMXB7uRgrn/Ioa
	 2kPtAv+lDYzumLALruAXJ/7cHXnhCSdFSCqxfVqWXG0DuDoIdNoTCVkPN3vLIuIqGY
	 uVenBPdwka6FeKWEItykmcO6JD9MbuwpPfXZOPEikufD4rCwJyk0xeh0pVDksXgyYZ
	 tL7LvYL5gqyv4ePiKt9Vl1gdjCRDqlDrvgGMW+NVwS8ivrZc7nqBIvBDrFkVNVcmfZ
	 Ga56htdGS2Outk2jSoTpEGR1k1bsmzvFQN7Q5ghgnN6HFWp/SUnjJZt6XVUvvTu8Ax
	 Bul4Mp5ciGuKg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 1/8] scsi: ibmvfc: add basic FPIN support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260831-ibmvfc-fpin-support-v7-1-77d0b9809080@linux.ibm.com>
References: <20260831-ibmvfc-fpin-support-v7-0-77d0b9809080@linux.ibm.com>
 <20260831-ibmvfc-fpin-support-v7-1-77d0b9809080@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 21:30:03 +0000
Message-Id: <20260831213004.085A21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Teardown ordering race allows FPIN works to execute on an unregist=
ered `fc_host`.
- [Medium] Lockless traversal of global `ibmvfc_head` list in KUnit test ri=
sks use-after-free.
- [Medium] The KUnit test accesses `tgt->rport` outside of the `host_lock`.
--

commit 6a259111a28ef932ad14496cabbef71084312dfe
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add basic FPIN support

Implement support for a basic level of Fabric Performance Impact
Notifications (FPIN) in the ibmvfc driver to enable monitoring of
fabric congestion and link integrity events. Offloads FPIN processing
to a dedicated workqueue and adds a KUnit test module for validation.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index b3bc3ce872d6d..78be00d31a064 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -6962,6 +7231,8 @@ static void ibmvfc_remove(struct vio_dev *vdev)
>  	ibmvfc_complete_purge(&purge);
>  	ibmvfc_release_sub_crqs(vhost);
>  	ibmvfc_release_crq_queue(vhost);
> +	destroy_workqueue(vhost->fpin_workq);
> +	vhost->fpin_workq =3D NULL;
> =20
>  	ibmvfc_free_mem(vhost);
>  	spin_lock(&ibmvfc_driver_lock);

[Severity: High]
Could this teardown ordering race cause a regression by allowing FPIN works=
 to
execute on an unregistered fc_host?

Earlier in ibmvfc_remove(), fc_remove_host() is called which destroys
fc_host->work_q and sets it to NULL. This happens before disabling FPIN
interrupts via ibmvfc_release_sub_crqs() and ibmvfc_release_crq_queue(), and
before destroying the new fpin_workq here.

If an FPIN interrupt arrives concurrently before the queues are released,
it can queue a work item to fpin_workq. When that work executes
fc_host_fpin_rcv(), it calls fc_queue_event(). Because scsi_remove_host() h=
as
not yet executed to clear state_in_sysfs, fc_queue_event() may attempt to
queue work to the already destroyed fc_host->work_q via queue_work(NULL, ..=
.),
resulting in a kernel crash.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> new file mode 100644
> index 0000000000000..8a73ea1b1da8c
> --- /dev/null
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
[ ... ]
> @@ -0,0 +1,146 @@
[ ... ]
> +static void ibmvfc_async_fpin_test(struct kunit *test)
> +{
[ ... ]
> +	headp =3D ibmvfc_get_headp();
> +	if (list_empty(headp))
> +		kunit_skip(test, "No ibmvfc devices available");
> +	queue =3D headp->next;
> +	vhost =3D container_of_const(queue, struct ibmvfc_host, queue);

[Severity: Medium]
Could this lockless traversal of the global ibmvfc_head list lead to a
use-after-free regression?

If ibmvfc_remove() executes concurrently (for instance, during a device
hot-unplug), it could remove and free the vhost structure while the KUnit t=
est
is still traversing the list.

> +
> +	spin_lock_irqsave(vhost->host->host_lock, flags);
> +	if (vhost->scsi_scrqs.num_targets < 1) {
> +		spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +		kunit_skip(test, "No targets");
> +	}
> +	tgt =3D list_first_entry(&vhost->scsi_scrqs.targets, struct ibmvfc_targ=
et, queue);
> +	if (!tgt->rport) {
> +		spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +		kunit_skip(test, "No rport");
> +	}
> +	kref_get(&tgt->kref);
> +	spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +
> +	fc_host =3D shost_to_fc_host(vhost->host);
> +
> +	pre[IBMVFC_AE_FPIN_LINK_CONGESTED] =3D READ_ONCE(fc_host->fpin_stats.cn=
_device_specific);
> +	pre[IBMVFC_AE_FPIN_PORT_CONGESTED] =3D READ_ONCE(tgt->rport->fpin_stats=
.cn_device_specific);

[Severity: Medium]
Is there a potential use-after-free regression here if tgt->rport is
dereferenced outside of the host_lock?

The test grabs a reference to tgt and drops vhost->host->host_lock, but then
reads tgt->rport->fpin_stats locklessly. If an event like a link down trigg=
ers
ibmvfc_del_tgt() concurrently, it can schedule the removal of the remote po=
rt.
The worker thread would then call fc_remote_port_delete(rport), freeing the
rport while the test is still dereferencing it.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831-ibmvfc-fpi=
n-support-v7-0-77d0b9809080@linux.ibm.com?part=3D1
