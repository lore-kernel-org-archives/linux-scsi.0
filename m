Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3722F383323
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 16:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784825239; cv=none; b=E60KZNHz9q7Eu8ITkBen87n2RN9VVZAChvpyiR/ShE21xqsTNw+N3Y/pYt9gHx7LVclv0ceFWGTDSy/8Y5s6tNSv8T/qYSmtWQ2Otd4p6gmiQ7TPxChhyEuPSGnVF5m7PRXQiBP5FjaCtGwULbmcYLqMO/q/9fIluFC5pYy8MsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784825239; c=relaxed/simple;
	bh=8vMerEuvfBxaemHbIKhpZZltlJdAIRj71VHQWz+n9fs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JpsVfKnAs+bID2n++cA6U6gEyeKkhnKBBjrxjdPAMUosKxc6XgZONnooZSgxVfTrL5+qGlbnesM0WKzAncmMBLWTh9bZy2NhMYVN06dFVMqA45icenVWWofF2fopgG8x2Xu0S3VUzAs6jq3bAeDB2CsrPlQBFoXVu0ueAjvtDjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ICxkt00U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ICxkt00U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6E11F000E9;
	Thu, 23 Jul 2026 16:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784825237;
	bh=pMmguTeyZr4b7w1v6VpGcn0MeHFEUcrdiK3FviJFEfc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ICxkt00U4oCytAIYqJFat21sWwtx9IciYO5AvXJGNeMIjkLpvXGGsowhHyUPC43Dt
	 89lLVOjM0YmzP6YQkBa6szy8G42uNjW8DJ+BEJ/r8PruuRYm3uz97aCG9S7RkKXOb7
	 hJKBhVt1K7qPPREMP9vwjXfGBlVodNCGH1EJaQq+O4P5UDEuhrNWa4ksY5MKUJ3jB9
	 WuAmqy8its2uk6N3T8wW9YdmxNoq/Kjvle8pkVXFgkwEs7YMFzAoo7efWiluWcZRcq
	 JKQRFfS79+Vsl+0mwcxqfDk+b76XDEsBH/OWfuPjNqKwuFzVjh5W+oflCflvs3/3mx
	 x6RxhaO85Swew==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 38/56] scsi: qla2xxx: Add LS4 pass-through IOCB
 handling for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-39-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-39-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 16:47:13 +0000
Message-Id: <20260723164717.8B6E11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The 29xx extended NVMe LS reject path truncates 9-bit virtual port=
 indices (vp_idx >=3D 256) to 8 bits, potentially causing the reject IOCB t=
o be sent on the wrong vport.

Pre-existing issues:
- [High] The function qla_nvme_ls_reject_iocb() modifies the hardware reque=
st queue and a shared DMA buffer without holding the required queue locks, =
causing queue corruption.
--

--- Patch [38]: [PATCH v6 38/56] scsi: qla2xxx: Add LS4 pass-through IOCB h=
andling for 29xx series ---
commit f75839a47ccdbe873640f70512142d6ebee38618
Author: Manish Rangankar <mrangankar@marvell.com>
Date:   Thu Jul 23 05:03:55 2026 +0000

    scsi: qla2xxx: Add LS4 pass-through IOCB handling for 29xx series
   =20
    Extend the LS4 pass-through IOCB handling to support the 128-byte
    pt_ls4_request_ext layout used by 29xx series adapters. The extension
    grows inline DSD capacity from 2 to 5 entries.

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
Does this truncate 9-bit virtual port indices (vp_idx >=3D 256)?

The struct pt_ls4_request_ext widens vp_index to a 16-bit integer, but the=
=20
intermediate struct qla_nvme_lsrjt_pt_arg still defines vp_idx as a u8.=20

Assigning a->vp_idx to ext->vp_index will drop the highest bit for any index
over 255. Will this cause the reject IOCB to be sent on the wrong vport if
an initiator sends an invalid request to a high-numbered vport?

> +		ext->tx_byte_count =3D cpu_to_le32(a->tx_byte_count);
> +		ext->rx_byte_count =3D 0;

[ ... ]

>  static int
>  qla_nvme_ls_reject_iocb(struct scsi_qla_host *vha, struct qla_qpair *qp,
>  			struct qla_nvme_lsrjt_pt_arg *a, bool is_xchg_terminate)
>  {
> -	struct pt_ls4_request *lsrjt_iocb;
> +	void *lsrjt_iocb;
> =20
>  	lsrjt_iocb =3D __qla2x00_alloc_iocbs(qp, NULL);

[Severity: High]
This is a pre-existing issue, but does calling __qla2x00_alloc_iocbs() here
modify the hardware request queue safely?

__qla2x00_alloc_iocbs() typically requires the hardware queue lock=20
(qp_lock_ptr) to be held to safely manipulate ring buffer pointers.=20
However, qla_nvme_ls_reject_iocb() is called from qla2xxx_process_purls_pkt=
()
in a workqueue context without holding the hardware_lock or qp_lock.

Additionally, it can be called from qla24xx_process_nvme_ls4_unsol() in
interrupt context holding hardware_lock, but not qp_lock. Can this concurre=
nt
lockless access cause queue corruption or garbled NVMe reject payloads?

>  	if (!lsrjt_iocb) {
>  		ql_log(ql_log_warn, vha, 0x210e,
>  		       "qla2x00_alloc_iocbs failed.\n");

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D38
