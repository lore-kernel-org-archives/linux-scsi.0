Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793267332;
	b=AtBtFfCgtpUMe2KdReiOY4MuiJgd9S26Vntx1bQZXBckelm8EH95eQaqxdQ2TIRa5+Jk
	 RjzdzeNCyZ+VKHLG+1Cy9S82xlHQX8Fwjc37L7zZvB+lt2eraGanKj3EhlxzkXVmMlLdd
	 SYMRG5zF+GtnjusPf/2kJ6r2uDhxDkXgNn7wC8qSREhUFoWwihq734OI+pecN66smiHoq
	 T7Hkg+CUAaDmTc81DylUix/r72X9H6cLWghSMMn+mNCv6A6VzKvb6xghTO0TBwQO/nXBZ
	 E8t0GeyFX3h2gQEKypLfRdTyghNEeat0deptANpzMITYN6tmpiq4Y1J+waiEmHVNj3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793267332;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KR37scHmq6JY275aWDNcGnSBfdCvl4Bi5dfYD8BhaIw=;
	b=4MLLIHp2rCPYaKptOG82GrHgncycV6eZex3RtIDEtM2BdyhhvKfGSHnBb+xY93pm3WKD
	 7yvFyEgMwWC0C4IxnJNkekt6NcmMcEsV17sV3fT1dM6GRY3EiniNWOKnXUGQj61mz2Vir
	 q54ghcrSyQp43/uZWjirvubolxttI0ZHfA82sfPS/Np42j2WlDDBcZKOpYLu32r4ECery
	 cPnUPUEFL+iFj9P6c4TdAkPpS+hCE2T8pWFi8+X+6Kb61V5Iv0qZSZZH+Mw5CcDMch1t0
	 yZ2wwaFeyd9b0EEU1SFqww4fET9OI66yc5PyBWMWDotVT/OAC65puXzT39nQ0FDMu/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YeWl2JG6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22C5606A31A
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 09:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YeWl2JG6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7771F01825;
	Thu, 29 Oct 2026 09:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793267331;
	bh=KR37scHmq6JY275aWDNcGnSBfdCvl4Bi5dfYD8BhaIw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YeWl2JG6ge8O11rcEJzCs6mrnsEzS3YFM6RCrECJFX3G+Ced4/KJRdqkZ10owVmiA
	 Yhsr2xuM27ay5mnETTqzgjt8x2Y8L5LbbnVrcnNAzBikVxal28/miQjnoIVlCZQ2Ah
	 qPBHfEcwX/bld42tNF7Kv238oJUVlE9bzsEOLiUhoW5G2E5IkN73YYGv3Fk4t03q6K
	 5HL0ug4yYluIgIh2EQ0Y3SYQqlhsxp5QSoC+k/ccHQdrUBjTJ08kI7jK3SeiRzniwu
	 CXphLtLXNPG0/5y0K6hGEX6/eGtjx8L/cgiqO/jNJOtGM9EIvAEh4RF4ZJ+19C0+Jg
	 tMfRC6FnG2Ueg==
Message-ID: <sashiko-outbox-189069@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] scsi: add basic CDB check to bsg_sg_io()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dmitry Antipov" <dmantipov@yandex.ru>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261029092624.579887-2-dmantipov@yandex.ru>
References: <20261029092624.579887-1-dmantipov@yandex.ru>
 <20261029092624.579887-2-dmantipov@yandex.ru>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 09:48:50 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] block: bsg: incomplete request_len check in bsg_sg_io() allows OOB=
 reads
- [High] block: bsg: SCSI_MIN_CDB_SIZE check in bsg_sg_io() breaks SAS SMP =
and FC BSG
- [Medium] block: bsg: misplaced CDB and access_ok() checks in bsg_sg_io()
--

commit f1d167c5abeebaea771b50853f4c7fc693ccc640
Author: Dmitry Antipov <dmantipov@yandex.ru>

scsi: add basic CDB check to bsg_sg_io()

This commit moves the uptr64() macro from block/bsg-lib.c to
include/linux/bsg-lib.h and adds a check in bsg_sg_io() requiring
hdr.request_len to be at least SCSI_MIN_CDB_SIZE and hdr.request to pass
access_ok() when hdr.subprotocol is not BSG_SUB_PROTOCOL_SCSI_TMF.

> diff --git a/block/bsg.c b/block/bsg.c
> index 82aaf3cee5825..80f367ae7d240 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -11,6 +11,7 @@
>  #include <linux/percpu.h>
>  #include <linux/idr.h>
>  #include <linux/bsg.h>
> +#include <linux/bsg-lib.h>
>  #include <linux/slab.h>
>  #include <linux/io_uring/cmd.h>
> =20
> @@ -66,6 +67,14 @@ static int bsg_sg_io(struct bsg_device *bd, bool open_=
for_write,
>  		return -EFAULT;
>  	if (hdr.guard !=3D 'Q')
>  		return -EINVAL;
> +
> +	if (hdr.subprotocol !=3D BSG_SUB_PROTOCOL_SCSI_TMF) {
> +		if (hdr.request_len < SCSI_MIN_CDB_SIZE)
> +			return -EINVAL;

[Severity: High]
Does checking hdr.request_len < SCSI_MIN_CDB_SIZE (6 bytes) in bsg_sg_io()
prevent out-of-bounds reads in ufs_bsg_request() and other bsg-lib transport
handlers?

For BSG_SUB_PROTOCOL_SCSI_TRANSPORT queues, bsg_transport_sg_io_fn()
allocates job->request with the exact user-supplied length:

block/bsg-lib.c:bsg_transport_sg_io_fn() {
	...
	job->request_len =3D hdr->request_len;
	job->request =3D memdup_user(uptr64(hdr->request), hdr->request_len);
	...
}

Unlike BSG_SUB_PROTOCOL_SCSI_CMD, BSG_SUB_PROTOCOL_SCSI_TRANSPORT requests =
do
not carry a SCSI CDB in hdr.request, but instead pass transport-specific
structures. In drivers/ufs/core/ufs_bsg.c, ufs_bsg_request() casts
job->request to struct ufs_bsg_request (36 bytes) and
ufs_bsg_exec_advanced_rpmb_req() casts job->request to struct
ufs_rpmb_request without checking job->request_len:

drivers/ufs/core/ufs_bsg.c:ufs_bsg_request() {
	struct ufs_bsg_request *bsg_request =3D job->request;
	...
	msgcode =3D bsg_request->msgcode;
	switch (msgcode) {
	case UPIU_TRANSACTION_QUERY_REQ:
		desc_op =3D bsg_request->upiu_req.qr.opcode;
	...
}

drivers/ufs/core/ufs_bsg.c:ufs_bsg_exec_advanced_rpmb_req() {
	struct ufs_rpmb_request *rpmb_request =3D job->request;
	...
	if (rpmb_request->ehs_req.length !=3D 2 ||
	    rpmb_request->ehs_req.ehs_type !=3D 1)
		return -EINVAL;
	...
}

Similarly, in drivers/scsi/mpi3mr/mpi3mr_app.c, mpi3mr_bsg_request() and its
helpers mpi3mr_bsg_process_drv_cmds() and mpi3mr_bsg_process_mpt_cmds()
dereference struct mpi3mr_bsg_packet from job->request without validating
job->request_len.

If userspace passes hdr.request_len =3D 6 with
hdr.subprotocol =3D BSG_SUB_PROTOCOL_SCSI_TRANSPORT, won't it bypass this
SCSI_MIN_CDB_SIZE check in bsg_sg_io(), allocate a 6-byte buffer in
bsg_transport_sg_io_fn(), and still trigger a slab-out-of-bounds read in
ufs_bsg_request(), ufs_bsg_exec_advanced_rpmb_req(), or
mpi3mr_bsg_request()?

[Severity: High]
Will requiring hdr.request_len >=3D SCSI_MIN_CDB_SIZE in bsg_sg_io() also c=
ause
regressions for existing BSG_SUB_PROTOCOL_SCSI_TRANSPORT users such as SAS
SMP passthrough and FC BSG?

In drivers/scsi/scsi_transport_sas.c, sas_smp_dispatch() and the SAS
transport smp_handler callbacks transfer the SMP request and response frames
entirely through job->request_payload (hdr.dout_xferp / hdr.dout_xfer_len)
and job->reply_payload (hdr.din_xferp / hdr.din_xfer_len), leaving
hdr.request =3D 0 and hdr.request_len =3D 0:

drivers/scsi/scsi_transport_sas.c:sas_smp_dispatch() {
	...
	if (!job->reply_payload.payload_len) {
		dev_warn(job->dev, "space for a smp response is missing\n");
		bsg_job_done(job, -EINVAL, 0);
		return 0;
	}

	to_sas_internal(shost->transportt)->f->smp_handler(job, shost, rphy);
	return 0;
}

Additionally, in drivers/scsi/scsi_transport_fc.c, fc_bsg_rport_dispatch()
accepts FC_BSG_RPT_ELS commands whose request length is
sizeof(uint32_t) + sizeof(struct fc_bsg_rport_els) (5 bytes), and both
fc_bsg_host_dispatch() / fc_bsg_rport_dispatch() and
iscsi_bsg_host_dispatch() in drivers/scsi/scsi_transport_iscsi.c explicitly
check for job->request_len < sizeof(uint32_t) to return -ENOMSG:

drivers/scsi/scsi_transport_fc.c:fc_bsg_rport_dispatch() {
	int cmdlen =3D sizeof(uint32_t);	/* start with length of msgcode */
	int ret;

	/* check if we really have all the request data needed */
	if (job->request_len < cmdlen) {
		ret =3D -ENOMSG;
		goto fail_rport_msg;
	}

	/* Validate the rport command */
	switch (bsg_request->msgcode) {
	case FC_BSG_RPT_ELS:
		cmdlen +=3D sizeof(struct fc_bsg_rport_els);
	...
}

Won't rejecting hdr.request_len < 6 with -EINVAL in bsg_sg_io() break SAS S=
MP
passthrough requests with hdr.request_len =3D=3D 0, reject valid 5-byte
FC_BSG_RPT_ELS requests, and change the -ENOMSG return code expected by FC
and iSCSI BSG callers?

> +		if (!access_ok(uptr64(hdr.request), hdr.request_len))
> +			return -EFAULT;
> +	}

[ ... ]

> diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
> index a697246feeaca..fac7c89516caf 100644
> --- a/include/linux/bsg-lib.h
> +++ b/include/linux/bsg-lib.h
> @@ -17,6 +17,8 @@ struct device;
>  struct scatterlist;
>  struct request_queue;
> =20
> +#define uptr64(val) ((void __user *)(uintptr_t)(val))

[Severity: Medium]
Is the access_ok() check in bsg_sg_io() and exposing uptr64() in
include/linux/bsg-lib.h needed here?

In the crash described by the commit message (hdr.request =3D NULL,
hdr.request_len =3D 0), ufs_bsg_request() dereferenced ZERO_SIZE_PTR (0x10)
because memdup_user(NULL, 0) in bsg_transport_sg_io_fn() returns
ZERO_SIZE_PTR when the length is 0. Calling access_ok(NULL, len) does not
reject a NULL pointer because __access_ok() treats address 0 as within the
user address range.

When hdr.request_len > 0, both bd->sg_io_fn() implementations already copy
hdr.request from userspace and return -EFAULT on invalid pointers:
scsi_bsg_sg_io_fn() in drivers/scsi/scsi_bsg.c uses copy_from_user(), and
bsg_transport_sg_io_fn() in block/bsg-lib.c uses memdup_user(). Running
access_ok() earlier in bsg_sg_io() causes requests with invalid kernel
addresses in hdr.request to return -EFAULT before bd->sg_io_fn() checks
hdr->protocol and hdr->subprotocol (-EINVAL), CAP_SYS_RAWIO (-EPERM in
bsg_transport_sg_io_fn()), bidirectional support (-EOPNOTSUPP in
scsi_bsg_sg_io_fn()), or scmd->cmd_len > sizeof(scmd->cmnd) (-EINVAL in
scsi_bsg_sg_io_fn()), while also exposing the unprefixed uptr64() macro in
include/linux/bsg-lib.h.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029092624.5798=
87-1-dmantipov@yandex.ru?part=3D2
