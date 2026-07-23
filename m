Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4A41EDA32
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784768325; cv=none; b=uq8pcllzzRp3uu4dD/6Vnn5QTWRxNAxXBmq7o4pqUzYVwgbnhPO9mu8/RUe+VrxYHu4tqg/C1nWqLTI6+rYXEMLDXumueb/5Ym++kS4pwclb1Y6VPZqrqZyA48XrLrzut1h2vBdwRhp+vYAZGPoePyYnl2L5NhDFyJJ8skWEOoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784768325; c=relaxed/simple;
	bh=fntwzUhvPB+v1WKLJnDYHN/qXGTQk1R0ETZMPzwaWUM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Z75Ieo0Eg1C79+UUapqESPcFoL4ngUkX/43p9FQuaQZ9tB0PmQbB6EsSsCaX1OySZbRnFX9nF/zd8CvrpCqyshgnSViX1u6YKis4ii/8kbLec5cyUND2Dj+Ac89uF3UJeSVPD6ZpRvoWifTiIzQQ97fgABZfCsxGjNt5wzT2ZAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RqbEE+J/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RqbEE+J/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713591F000E9;
	Thu, 23 Jul 2026 00:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784768323;
	bh=hgY8iAGouM4VBABDY/CV6sKnuG1z9R67UkDa6hzziyc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RqbEE+J/q5NAmxR+E8oK8zLFbWQiNHVkbymHtyEl7Zq2VHJPp60iFzrM3K8d9okwr
	 Q2i+6O4zPDtCgrbYLttPnwmJpkBtsnVEPGKpjKIWuWM9CgI30bgoh2y27TuyYZmwff
	 6E0n3zt9R1rrNBi66nMY06enWv294lRcLz5KAo36XGa9/MCQso3/CkOpjUIofiIrlC
	 PyTw3Z9RpAVNKv2IEyUHhsh3ahv33LCdFB0QVArRDcLYDmlFn6dU9bBPV9R35fxcin
	 cpBa9q45n3s9qVZihtz3t0XcabaF7GEJ6d2Z5eyOXvkN4G28Y4fsPpQoZsNpiiky3s
	 luFZKoMHYfw7Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 28/33] ibmvfc: implement LLDD callbacks for mapping
 nvme-fc queues
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-29-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-29-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:58:42 +0000
Message-Id: <20260723005843.713591F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Missing `nvme_fc_unregister_localport` during adapter teardown cau=
ses Use-After-Free.
- [High] TOCTOU race in `ibmvfc_nvme_create_queue` leading to divide-by-zer=
o and NULL pointer dereference.
- [High] Stub implementations of `ls_req` and `fcp_io` return 0 without inv=
oking completion callbacks, causing uninterruptible kernel hangs.
--

--- Patch [28]: [PATCH v2 28/33] ibmvfc: implement LLDD callbacks for mappi=
ng nvme-fc queues ---
commit 186f72e380294760659d725fac77194c4e72d82e
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: implement LLDD callbacks for mapping nvme-fc queues

Implement the NVMe-FC queue create and delete callbacks and map NVMe
controller queues onto ibmvfc hardware queues. Use qidx of NVMe controller
queue to map onto a ibmvfc_queue channel. Add a new ibmvfc_nvme_qhandle
struct that will be used as the opaque queue handle by the NVMe-FC layer
when issuing fcp IO.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/=
ibmvfc-nvme.c
> index 637d7d7015cf5..ecf9f4c0549c2 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c

[ ... ]

> +static int ibmvfc_nvme_create_queue(struct nvme_fc_local_port *lport, un=
signed int qidx,
> +				    u16 qsize, void **handle)
> +{
> +	struct ibmvfc_host *vhost =3D lport->private;
> +	struct ibmvfc_nvme_qhandle *qhandle;
> +
> +	if (!vhost->nvme_scrqs.active_queues)
> +		return -ENODEV;
> +
> +	qhandle =3D kzalloc_obj(struct ibmvfc_nvme_qhandle);
> +	if (!qhandle)
> +		return -ENOMEM;
> +
> +	qhandle->cpu_id =3D raw_smp_processor_id();
> +	qhandle->qidx =3D qidx;
> +
> +	/* Admin and first IO queue are both mapped to index 0 */
> +	if (qidx)
> +		qhandle->index =3D (qidx - 1) % vhost->nvme_scrqs.active_queues;

[Severity: High]
Could this result in a divide-by-zero or NULL pointer dereference?

The vhost->nvme_scrqs.active_queues value is read locklessly at the start of
the function. Since kzalloc_obj() can sleep, if a concurrent teardown or re=
set
(such as ibmvfc_release_channels()) executes during this window, it could s=
et
active_queues to 0 and scrqs to NULL.

When the thread resumes, it would divide by zero here.

> +	else
> +		qhandle->index =3D qidx;
> +
> +	qhandle->queue =3D &vhost->nvme_scrqs.scrqs[qhandle->index];

[Severity: High]
Will this lead to a use-after-free during adapter teardown?

When unloading the driver or hot-removing the adapter, ibmvfc_remove() frees
the memory backing vhost->nvme_scrqs.scrqs via ibmvfc_release_sub_crqs().

However, it appears nvme_fc_unregister_localport() is never called during t=
his
teardown path. Without notifying the NVMe-FC transport layer, it retains ac=
tive
references to the local port and its queues. Any subsequent background tran=
sport
operations could dereference the freed queues.

[ ... ]

> @@ -59,8 +93,8 @@ static void ibmvfc_nvme_fcp_abort(struct nvme_fc_local_=
port *lport,
>  static struct nvme_fc_port_template ibmvfc_nvme_fc_transport =3D {
>  	.localport_delete	=3D ibmvfc_nvme_localport_delete,
>  	.remoteport_delete	=3D ibmvfc_nvme_remoteport_delete,
> -	.create_queue		=3D NULL,
> -	.delete_queue		=3D NULL,
> +	.create_queue		=3D ibmvfc_nvme_create_queue,
> +	.delete_queue		=3D ibmvfc_nvme_delete_queue,
>  	.ls_req			=3D ibmvfc_nvme_ls_req,
>  	.ls_abort		=3D ibmvfc_nvme_ls_abort,
>  	.fcp_io			=3D ibmvfc_nvme_fcp_io,

[Severity: High]
Does returning 0 from the stub implementations of ibmvfc_nvme_ls_req() and
ibmvfc_nvme_fcp_io() cause uninterruptible kernel hangs?

The NVMe-FC transport layer calls the LLDD's ls_req and fcp_io functions.
Returning 0 signals that the request was successfully dispatched and the
LLDD will asynchronously invoke the req->done() callback.

For example, __nvme_fc_send_ls_req() issues a synchronous wait_for_completi=
on()
with no timeout. Because the stub functions simply return 0 and never call
done(), the caller would block forever, leaving block layer I/Os permanently
outstanding.

If these are meant to be stubs, should they return an error code like
-EOPNOTSUPP or -EIO instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D28
