Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C343AC0D0
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783407008; cv=none; b=e7qmJzg9AwCcQ9CGT09UU7eHnkLE1hQONT2tRmpOTldQ+Gt/2vga7+lRIoTAH1ke/yT6/1wRXCokEvU8NZM8O+Kf03yypPVQ/7/muXWK+bf5+M3EcSR9keJw7DYADZw/xtXBgiyDKgJ5w4phBEobvPMKHSmVv7MBliA+L1B4Ez8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783407008; c=relaxed/simple;
	bh=MWQ1y1VG61jWs4TrEP07POvoQ3C6dMRmCoLkJqrX1rY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rLKl3QmFU84669VVI2AyVO1QCWdw52UfeCxDBn0od4z3h82aLVUNzO9MBx7foNtR5h769ZZSVQsiGUKg3r0/45yTYr6Ze5kYDY4rMdAyNVoEhsw0aEBL3f0HEdjQHZgW1cMwTX/h4GZqcXdVa57BeOaTXrsgFSe00LknTC1o7VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q7+kxTnx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q7+kxTnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A7F1F000E9;
	Tue,  7 Jul 2026 06:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783407007;
	bh=Hye47LqpAaZPRLD2kZN4alh9gmBzxnFqibT8QziY4pM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q7+kxTnxqibvVSi9tZQKikLJ8svCBmANiQyK2bRRD5b2xrrurjEWBG8fJWQMdPPua
	 2+Y/1ZBcvfFWksMV6QWMzwlGmN3lfMnoahQ6GUedLv60yYkTtKKDdQCLK7VI9Drv6a
	 kPRo01g4rPLWOxm84NEcFEUrgOU8lBUE+OFBPHADRnearXKCIf7eCqP6Mj5LvHL8hq
	 KP2CqJPnvdG2YMT2Nyrefda88vEmnnhsVMBD19v1vOBTYrpzWvq0z8ETgOFT7hqZlV
	 DgpU/66duMzYbCVIBaJLyl7dJ7fzX1e9BCu8SyL5fBmkXZAnpfv9I/tL64mvSRnnTC
	 369FUjeKvEnKQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 40/88] scsi: qla2xxx: Fix queue teardown NULL
 dma_free and bitmap locking
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-41-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-41-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:50:06 +0000
Message-Id: <20260707065007.25A7F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Queue ring buffer is freed before being removed from the global ma=
p, creating a race with asynchronous firmware dumps.
- [High] Pending queue pair worker (`q_work`) is not cancelled during a `ql=
a2xxx_create_qpair()` failure, leading to a Use-After-Free of the `qpair` s=
truct.
- [High] The queue pair `work_struct` (`q_work`) can be queued by the inter=
rupt handler before it is initialized, causing a NULL pointer dereference o=
r list corruption.
--

--- Patch [40]: [PATCH v3 40/88] scsi: qla2xxx: Fix queue teardown NULL dma=
_free and bitmap locking ---
commit 88d0670e7fb3084bb51e8aaca31241034a20bd22
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Fix queue teardown NULL dma_free and bitmap locking

This commit fixes queue teardown bugs in qla25xx_free_req_que() and
qla25xx_free_rsp_que(). It guards dma_free_coherent() with a NULL check
and safely locks map assignments under mq_lock. It also removes redundant
bitmap clears from the creation error paths.

> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> index bb2521c052bf8..7072af5b42178 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -576,16 +576,17 @@ qla25xx_free_req_que(struct scsi_qla_host *vha, str=
uct req_que *req)
>  	uint16_t que_id =3D req->id;
>  	size_t req_entry_size =3D qla_req_entry_size(ha);
> =20
> -	dma_free_coherent(&ha->pdev->dev,
> -			  (req->length + 1) * req_entry_size,
> -			  req->ring, req->dma);
> +	if (req->ring)
> +		dma_free_coherent(&ha->pdev->dev,
> +				  (req->length + 1) * req_entry_size,
> +				  req->ring, req->dma);
>  	req->ring =3D NULL;

[Severity: High]
This is a pre-existing issue, but does clearing req->ring before removing t=
he
queue from ha->req_q_map create a race condition?

If an asynchronous firmware error interrupt fires right after req->ring is
set to NULL:

ISR
ha->isp_ops->fw_dump()
    qla25xx_copy_mqueues()
        req =3D ha->req_q_map[que];
        if (!req)
            break;
        ...
        memcpy(ptr, req->ring, req->length * sizeof(request_t));
       =20
Could the firmware dump locklessly iterate ha->req_q_map, find the queue, a=
nd
dereference the newly NULL pointer or freed memory?

>  	req->dma =3D 0;
>  	if (que_id) {
> +		mutex_lock(&ha->mq_lock);
>  		ha->req_q_map[que_id] =3D NULL;
> -		mutex_lock(&ha->vport_lock);
>  		clear_bit(que_id, ha->req_qid_map);
> -		mutex_unlock(&ha->vport_lock);
> +		mutex_unlock(&ha->mq_lock);
>  	}

[ ... ]

> @@ -605,16 +606,17 @@ qla25xx_free_rsp_que(struct scsi_qla_host *vha, str=
uct rsp_que *rsp)
>  		rsp->msix->handle =3D NULL;
>  	}
> =20
> -	dma_free_coherent(&ha->pdev->dev,
> -			  (rsp->length + 1) * rsp_entry_size,
> -			  rsp->ring, rsp->dma);
> +	if (rsp->ring)
> +		dma_free_coherent(&ha->pdev->dev,
> +				  (rsp->length + 1) * rsp_entry_size,
> +				  rsp->ring, rsp->dma);
>  	rsp->ring =3D NULL;
>  	rsp->dma =3D 0;
>  	if (que_id) {
> +		mutex_lock(&ha->mq_lock);
>  		ha->rsp_q_map[que_id] =3D NULL;
> -		mutex_lock(&ha->vport_lock);
>  		clear_bit(que_id, ha->rsp_qid_map);
> -		mutex_unlock(&ha->vport_lock);
> +		mutex_unlock(&ha->mq_lock);
>  	}
>  	kfree(rsp);

[Severity: High]
This is a pre-existing issue, but could this teardown path lead to a
use-after-free of the qpair structure?

During a qla2xxx_create_qpair() failure where the response queue creation
succeeds but the request queue creation fails, the error path calls
qla25xx_free_rsp_que().=20

At this point, qpair->rsp->qpair is not yet assigned (it is assigned after
both queues are successfully created). Because of this, the check for
rsp->qpair evaluates to NULL, and cancel_work_sync(&rsp->qpair->q_work)
is bypassed.

If an early interrupt fired on the response queue's MSI-X vector before
teardown, the un-cancelled work item would remain active on ha->wq after
the qpair struct is freed.

[ ... ]

> @@ -942,9 +941,6 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16=
_t options,
>  		if (ret !=3D QLA_SUCCESS) {
>  			ql_log(ql_log_fatal, base_vha, 0x00e7,
>  			    "%s failed.\n", __func__);
> -			mutex_lock(&ha->mq_lock);
> -			clear_bit(que_id, ha->rsp_qid_map);
> -			mutex_unlock(&ha->mq_lock);
>  			goto que_failed;
>  		}
>  		vha->flags.qpairs_rsp_created =3D 1;

[Severity: High]
This is a pre-existing issue, but does this function safely initialize the
workqueue?

Earlier in qla25xx_create_rsp_que(), qla25xx_request_irq() is called, which
unmasks the MSI-X vector and activates the ISR qla2xxx_msix_rsp_q(). Then
qla25xx_init_rsp_que() activates the queue in firmware.

However, INIT_WORK(&qpair->q_work, qla_do_work) is not called until the
very end of the function.

If an interrupt fires immediately after IRQ registration and queue
activation, the ISR calls queue_work() on the work_struct which is complete=
ly
zeroed (from the kzalloc of qpair). Could this enqueueing of a
zero-initialized work_struct corrupt workqueue lists or cause a crash when
executing a NULL function pointer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D40
