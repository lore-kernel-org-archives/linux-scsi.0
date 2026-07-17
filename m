Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FBBE54B
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784306954; cv=none; b=bLBAjMJ61wsuHmu/5FrQCAANYAdeH8ZoCWTjfTF0GPCKUkmtS9yMULCqPOTk/EHfpY4xzT0oTNRdkaeLwMXE7oz2u2LZbxp3uKKJfNuxO0LuqJZQK1bzbpV5wyluCNZb81y6MIw5AqUK585F+cZPM/jhIJbOR43LUc8csE/oJXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784306954; c=relaxed/simple;
	bh=b0gHqUqJA+SS97N3IRHfpLYXUx80J4LGt9wBlcY0VWo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uoWixVMtb+fdCI4XCMNXX6FxIPm1jc79vtO+7zgALUHOmyMc2/w0npjDBIUTcY2lcqpuLp5kakzZ+TX1s24B/Dzf4UDE1RZEMSUPi0GXXnZFagddGemj0bMkDqEuU7EN15rBBk1+9yy3gTXvtGWSaelTbnICV0vyKyLSKONp0MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B4AkiSrM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B4AkiSrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4AD41F000E9;
	Fri, 17 Jul 2026 16:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784306952;
	bh=rx6/ROnA0Xgzuw7qBAXhze8ykzlwTLumqiwYl27RPNg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B4AkiSrMFtPQXKvh4a+BiJ/Lf40a6EJmcTgxAl4k/9aapCwAkeODYVyfdaVw5hgKM
	 K4GT1DgAApEb7uw9wQmvPqCnlnrCxzOvQo2DNKN/5YZCHAtGI8/r3VDTCzeH7iuxOQ
	 rGdgY5jvRPoawVJBR/FWHNKOZrI3MKivNozr0vOh81iDn2r907e7TJ4lRbEfa1NQ7c
	 lpvuOWmu6ModxkT4jXVQnYfVOfLFLS/s6yPdm4VJr0mpLplu5B9Y/P2wFUWItOHKjX
	 EiFiNsr7G5tFVPg63ldPM44MYJ2OQ9Jm/uk598abwQSuI/0zSDId4vOT8liXZGJGOW
	 jPZeJD5gu0Mvw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 40/56] scsi: qla2xxx: Fix queue teardown NULL
 dma_free and bitmap locking
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-41-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-41-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:49:12 +0000
Message-Id: <20260717164912.C4AD41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Interrupt handler drops valid interrupts if any lower-numbered que=
ue is deleted, due to misuse of find_first_zero_bit().
- [High] Sysfs firmware dump can concurrently read freed `req->ring` or `rs=
p->ring` memory.
- [High] Race condition during qpair deletion causes UAF of `req->outstandi=
ng_cmds` in the interrupt handler.
- [High] Orphaned request/response queues when deleting queue pairs created=
 with `startqp =3D false`.
--

--- Patch [40]: [PATCH v5 40/56] scsi: qla2xxx: Fix queue teardown NULL dma=
_free and bitmap locking ---
commit 9e994d85d8469000c7bf32a3a2ebd3db56b893a4
Author: Nilesh Javali <njavali@marvell.com>
Date:   Fri Jul 17 15:28:48 2026 +0000

    scsi: qla2xxx: Fix queue teardown NULL dma_free and bitmap locking
   =20
    qla25xx_free_req_que() and qla25xx_free_rsp_que() have two pre-existing
    bugs exposed on the error path of qla25xx_create_{req,rsp}_que():
   =20
[ ... ]

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
This isn't a bug introduced by this patch, but does this create a use-after=
-free
or NULL pointer dereference during sysfs firmware dumps?

If a firmware dump is triggered concurrently with a queue teardown,
qla25xx_copy_mqueues() copies queue memory into the dump buffer under
hardware_lock. However, here we free the DMA memory and set req->ring to NU=
LL
before the queue is removed from req_q_map, and without holding hardware_lo=
ck:

drivers/scsi/qla2xxx/qla_dbg.c:qla25xx_copy_mqueues() {
        ...
        memcpy(ptr, req->ring, req->length * req_entry_size);
        ...
}

>  	req->dma =3D 0;
>  	if (que_id) {
> +		mutex_lock(&ha->mq_lock);
>  		ha->req_q_map[que_id] =3D NULL;
> -		mutex_lock(&ha->vport_lock);
>  		clear_bit(que_id, ha->req_qid_map);

[Severity: High]
This is a pre-existing issue, but does clearing bits here expose a flaw with
how interrupts are validated?

If multiple queue pairs are created and a lower-numbered queue is deleted,
this clear_bit creates a hole in the bitmask. When an interrupt arrives for
a higher-numbered queue, qla2x00_status_entry() validates it using:

drivers/scsi/qla2xxx/qla_isr.c:qla2x00_status_entry() {
        ...
        if (req =3D=3D NULL ||
            que >=3D find_first_zero_bit(ha->req_qid_map, ha->max_req_queue=
s)) {
        ...
}

The find_first_zero_bit call returns the index of the deleted queue, causing
the check to incorrectly drop valid interrupts for the higher-numbered queu=
es.

> -		mutex_unlock(&ha->vport_lock);
> +		mutex_unlock(&ha->mq_lock);
>  	}
>  	kfree(req->outstanding_cmds);

[Severity: High]
This is a pre-existing issue, but could this cause a use-after-free of
req->outstanding_cmds in the interrupt handler?

During queue pair deletion in qla2xxx_delete_qpair(), the request queue is
deleted and freed here before the response queue is deleted. The response
queue's MSI-X interrupt remains active during this window.

If an interrupt fires (or q_work is executing), it reads req without mq_loc=
k.
If it fetches req just before it is nullified but dereferences
req->outstanding_cmds after it is freed here, a use-after-free occurs.
Additionally, the qpair->q_work work item appears to never be canceled.

>  	kfree(req);
>  }

[Severity: High]
This is a pre-existing issue, but do we leak these request and response
queues when they are created with startqp =3D false?

If a queue pair is created with startqp =3D false, vha->flags.qpairs_req_cr=
eated
is not set. Later, qla25xx_delete_req_que() skips calling qla25xx_free_req_=
que()
completely because of this check:

drivers/scsi/qla2xxx/qla_mid.c:qla25xx_delete_req_que() {
        ...
        if (req && vha->flags.qpairs_req_created) {
                ...
                qla25xx_free_req_que(vha, req);
        }
        return ret;
}

The same bypass happens in qla25xx_delete_rsp_que(). This seems to leak the
DMA rings, struct req/rsp, and the map indexes forever.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D40
