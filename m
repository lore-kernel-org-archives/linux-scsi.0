Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF272949E0
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784306216; cv=none; b=d0heO2OUUutV+veNb/0P04eaIRSLpNyNdUmd+G8slgOUt5M8nenZMQ5DAqYPXAB4dFNujgNZQVYrgvFgSgzG41K5nSsqkyVgKWo6EVM4ko7knd/JNOGiF8M3nYgRZ9421QXC/3ue0rad9NEZPQBxkHQtyOOpw7pZDe2DdDhZZbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784306216; c=relaxed/simple;
	bh=KEd23Wuf3P0lYxVBs4l9jitvUQtM6NN9XfAgR9YijIo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Q8FU74YczUsCOKrG+6y7DEH3CoyGY9B7xyGWpFUYqGsId9UgaICAhHe4ZmVk+pIY+w9QG8Xh5EYHFjr8RuHI1cYflAZjc1twuas56BRpuZZsmpwsS4oJVIsjZjQd32pFnMeYB+JZNRMv6sb6YLraaPdQoo6Q6dAfkhXnptV87hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nQH1ZHHo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nQH1ZHHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65421F000E9;
	Fri, 17 Jul 2026 16:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784306215;
	bh=nfJZJHRtYgsRbP09+NnKFrcTcUrV6PcPyYmJbDZpBtY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nQH1ZHHowlY+9UDGxhcqNstCBqV2DrcbAg6C2ocrfiCOmUxWW/mK4xx2gT6cxOmp/
	 LK+5+x7IKq776dODP4WVRlfhmWYEsPTmDYAV+TNTlMtO2M1o1/I1h+X0wGBa7ieIHr
	 lcUhfD9LJmy44CIgPJy6FYMyUgVoNbnd+7EL7lYuSClJWCTLS+gNMIZsG+GSAgRsH5
	 lK/3ikevVzhxUyHf+zSOB7fMaZbMkRGP8CT+33QbneKxRyUxO6qNooDgrvHO2V6hgk
	 AFrGlQ5PGuE64RfnwkfCw91StD27attg9hSzi7b/6Tb3UMUKlvDflBw/WMWfT+MwZ7
	 B8uPpwyx4pLiw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 38/56] scsi: qla2xxx: Add LS4 pass-through IOCB
 handling for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-39-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-39-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:36:54 +0000
Message-Id: <20260717163654.E65421F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The `vp_idx` field in `struct qla_nvme_lsrjt_pt_arg` is defined as=
 `u8`, which silently truncates the 16-bit Virtual Port index to 8 bits whe=
n sending NVMe LS Rejects, breaking 9-bit VP index support for 29xx adapter=
s.
- [High] Unsolicited NVMe LS request handling (`PT_LS4_UNSOL`) lacks suppor=
t for the 9-bit Virtual Port index on 29xx adapters.

Pre-existing issues:
- [High] `qla_nvme_ls_reject_iocb()` modifies the shared hardware request r=
ing without holding the hardware queue lock (`qp_lock_ptr`).
--

--- Patch [38]: [PATCH v5 38/56] scsi: qla2xxx: Add LS4 pass-through IOCB h=
andling for 29xx series ---
commit 5707bda86601ab783dbcbdb4edacb7475a352b7d
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add LS4 pass-through IOCB handling for 29xx series

Extend the LS4 pass-through IOCB handling to support the 128-byte
pt_ls4_request_ext layout used by 29xx series adapters. The extension
grows inline DSD capacity from 2 to 5 entries. Function signatures are
widened to void * so both layouts can be passed without casts.

> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 8fa980db6ce4e..0038b6274d444 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -1197,37 +1197,57 @@ static void qla_nvme_fc_format_rjt(void *buf, u8 =
ls_cmd, u8 reason,

[ ... ]

> +	if (IS_QLA29XX(ha)) {
> +		struct pt_ls4_request_ext *ext =3D lsrjt_iocb;
> +
> +		ext->vp_index =3D cpu_to_le16(a->vp_idx);

[Severity: High]
Does this assignment truncate the 16-bit virtual port index to 8 bits?

The struct qla_nvme_lsrjt_pt_arg defines vp_idx as a u8. When an unsolicited
NVMe LS request fails, qla2xxx_process_purls_pkt() assigns the 16-bit
vha->vp_idx to a.vp_idx, dropping the high bits:

qla2xxx_process_purls_pkt()
    a.vp_idx =3D vha->vp_idx;

This truncates any virtual port index >=3D 256. When qla_nvme_lsrjt_pt_iocb=
()
then zero-extends this back to 16 bits for the extended IOCB here, the NVMe
LS Reject IOCB will be routed to the wrong virtual port.

> +		ext->tx_byte_count =3D cpu_to_le32(a->tx_byte_count);
> +		ext->rx_byte_count =3D 0;
> +		put_unaligned_le64(a->tx_addr, &ext->dsd[0].address);
> +		ext->dsd[0].length =3D cpu_to_le32(a->tx_byte_count);
> +		put_unaligned_le64(a->rx_addr, &ext->dsd[1].address);
> +		ext->dsd[1].length =3D 0;
> +	} else {

[ ... ]

> @@ -1245,13 +1265,13 @@ static int
>  qla_nvme_ls_reject_iocb(struct scsi_qla_host *vha, struct qla_qpair *qp,
>  			struct qla_nvme_lsrjt_pt_arg *a, bool is_xchg_terminate)
>  {
> -	struct pt_ls4_request *lsrjt_iocb;
> +	void *lsrjt_iocb;
> =20
>  	lsrjt_iocb =3D __qla2x00_alloc_iocbs(qp, NULL);

[Severity: High]
This is a pre-existing issue, but does qla_nvme_ls_reject_iocb() modify
the shared hardware request ring without holding the hardware queue lock?

When called from the DPC workqueue thread via qla2xxx_process_purls_pkt(),
the caller does not hold the queue lock (qp_lock_ptr):

vha->iocb_work (workqueue thread)
  qla2xxx_process_purls_pkt()
    qla_nvme_ls_reject_iocb(vha, vha->hw->base_qpair, &a, true);

This function calls __qla2x00_alloc_iocbs() here, and later calls
qla2x00_start_iocbs(), both of which require the lock to safely update
the request ring state. Can this concurrent modification corrupt the ring
structure?

>  	if (!lsrjt_iocb) {
>  		ql_log(ql_log_warn, vha, 0x210e,
>  		       "qla2x00_alloc_iocbs failed.\n");
>  		return QLA_FUNCTION_FAILED;
>  	}

[ ... ]

> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index f539190dd5044..186c6c7a39448 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -8402,6 +8402,7 @@ qla2x00_module_init(void)
>  	BUILD_BUG_ON(sizeof(struct nvram_24xx) !=3D 512);
>  	BUILD_BUG_ON(sizeof(struct nvram_81xx) !=3D 512);
>  	BUILD_BUG_ON(sizeof(struct pt_ls4_request) !=3D 64);
> +	BUILD_BUG_ON(sizeof(struct pt_ls4_request_ext) !=3D 128);
>  	BUILD_BUG_ON(sizeof(struct pt_ls4_rx_unsol) !=3D 64);

[Severity: High]
Does the handling for unsolicited NVMe LS requests also need a 29xx
extension to support 9-bit virtual port indices?

The struct pt_ls4_rx_unsol defines vp_index as an 8-bit uint8_t. When the
29xx firmware passes an unsolicited NVMe LS request to the driver,
qla2xxx_process_purls_iocb() extracts the 8-bit vp_index to look up the
virtual port:

qla2xxx_process_purls_iocb()
    vha =3D qla2xxx_get_vha_from_vp_idx(ha, p->vp_index);

If the incoming request is for a virtual port >=3D 256, truncating the 9-bit
index provided by the 29xx firmware will cause the driver to route the
request to the wrong virtual port.

>  	BUILD_BUG_ON(sizeof(struct purex_entry_24xx) !=3D 64);
>  	BUILD_BUG_ON(sizeof(struct purex_entry_24xx_ext) !=3D 128);
>  	BUILD_BUG_ON(sizeof(struct qla2100_fw_dump) !=3D 123634);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D38
