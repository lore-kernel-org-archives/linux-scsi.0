Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B25035E1AC
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 15:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784043660; cv=none; b=p2b+PSRYcVymyziUjR/2fpsjivGbaBgZKQEGiuNePoRUYcyWxrCiDHUj84D5O2i6sMNHFT1b9tUhhXBjn/NTtnfYGow0G2Bm7SfGVrPyDjtlE9rLRiGSzJ00LikKz1xOZqghV8XeBBaAzkCCzYCV9Lefe9M1sbvHuQMub7w7sk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784043660; c=relaxed/simple;
	bh=TFia1MaHnuZv3YjfU8Dk6Ukp3kafrNMPW6qCfCbiF+c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=L2+rqd09NeAA+I/UgaA1T0nFj4aZhGZnC6cV2RY3HiInworJYY/UATh4It67wKOmrzGwLF0NiTU0EylZes6+0HPbFBssi4QyNI6IgZz4LJsCuRt9hkgwKVSoblX3zRw/nPcTv1t2dTDFn5Me/wwC5MqYw6sK3FnP9KLAh2EW8Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fw6Z97hP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fw6Z97hP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E6A1F000E9;
	Tue, 14 Jul 2026 15:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784043659;
	bh=fYNaO10urFnIE2ENBaC2+1UVhb1jO9O5VKktSovgwL4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fw6Z97hPXb27ZQICQKIdA1QOcCZnyZ6xwfRVexW10g608viBfo6TTQnjC9xyk4TGh
	 blfkv2BS5Jykva3q8YrOl1ZWhQNxcl4A9jI3sY7fI3166zylbZmrNWAMBUsZ9I7l7J
	 MI9vigaDuj2WHLq3jK/zaxXEWCLMLa2Ol8qdw1wQUD/umhkvMUKyprPcken5n9/yEM
	 v5iFEYpboRzQqHQq8I6xzJ5ov+K+kbUtU0Rhhv/Hw3GOQ91bCMW3Wv7BAHo3U3wuOA
	 xiIb7S5sBLDXk8cNIVWOB49HgN2MVAbjmi8HlyZNHYwWq9nqWFqM0VGtbBDJA+NvQL
	 TWtW1/NUG86Bg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 38/56] scsi: qla2xxx: Add LS4 pass-through IOCB
 handling for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-39-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-39-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 15:40:58 +0000
Message-Id: <20260714154059.10E6A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Silent truncation of the 9-bit vp_index to 8 bits when handling NV=
Me LS rejects and aborts on 29xx adapters.
- [High] Incoming unsolicited NVMe LS requests silently truncate the 9-bit =
vp_index on 29xx adapters due to missing extended structure.
--

--- Patch [38]: [PATCH v4 38/56] scsi: qla2xxx: Add LS4 pass-through IOCB h=
andling for 29xx series ---
commit d14caf7c2396c7b59c2084f1b4f6a4306e45737c
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add LS4 pass-through IOCB handling for 29xx series

This commit extends the LS4 pass-through IOCB handling to support the
128-byte pt_ls4_request_ext layout used by 29xx series adapters. The
extension grows inline DSD capacity from 2 to 5 entries and handles the
divergent fields per adapter stride.

> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 8fa980db6ce4e..0038b6274d444 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c

[ ... ]

> @@ -1197,37 +1197,57 @@ static void qla_nvme_fc_format_rjt(void *buf, u8 =
ls_cmd, u8 reason,
>  	rjt->rjt.vendor =3D vendor;
>  }
> =20

[ ... ]

> +	if (IS_QLA29XX(ha)) {
> +		struct pt_ls4_request_ext *ext =3D lsrjt_iocb;
> +
> +		ext->vp_index =3D cpu_to_le16(a->vp_idx);

[Severity: High]
Can this silently truncate the 16-bit virtual port index?

Looking at struct qla_nvme_lsrjt_pt_arg, vp_idx is defined as an 8-bit
value:

struct qla_nvme_lsrjt_pt_arg {
	...
	u8 vp_idx;
	...

When an unsolicited NVMe LS request fails or needs to be rejected, this
u8 field silently truncates the 16-bit vha->vp_idx upon assignment. We
then assign this 8-bit truncated value to the extended IOCB's 16-bit
ext->vp_index here.

Could this cause NVMe LS reject requests to be routed out of the wrong
virtual port if the vport index is >=3D 256, breaking functionality for
NPIV ports on 29xx adapters?

> +		ext->tx_byte_count =3D cpu_to_le32(a->tx_byte_count);
> +		ext->rx_byte_count =3D 0;
> +		put_unaligned_le64(a->tx_addr, &ext->dsd[0].address);
> +		ext->dsd[0].length =3D cpu_to_le32(a->tx_byte_count);
> +		put_unaligned_le64(a->rx_addr, &ext->dsd[1].address);
> +		ext->dsd[1].length =3D 0;
> +	} else {

[ ... ]

> diff --git a/drivers/scsi/qla2xxx/qla_nvme.h b/drivers/scsi/qla2xxx/qla_n=
vme.h
> index a253ac55171bd..e6a41d53cbe1c 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.h
> +++ b/drivers/scsi/qla2xxx/qla_nvme.h
> @@ -144,7 +144,7 @@ struct pt_ls4_rx_unsol {

[Severity: High]
Does incoming unsolicited NVMe LS request handling truncate the 9-bit
vp_index on 29xx adapters?

When a 29xx adapter delivers an unsolicited LS request, it posts an
extended RX IOCB. If the driver casts it to the unextended 64-byte
struct pt_ls4_rx_unsol, vp_index is read as a uint8_t, truncating the
9-bit index provided by the hardware to 8 bits.

Should there be an extended layout for struct pt_ls4_rx_unsol for 29xx
adapters to ensure unsolicited NVMe LS requests on VPs >=3D 256 are not
misrouted?

>  int qla_nvme_register_hba(struct scsi_qla_host *);
>  int  qla_nvme_register_remote(struct scsi_qla_host *, struct fc_port *);
>  void qla_nvme_delete(struct scsi_qla_host *);
> -void qla24xx_nvme_ls4_iocb(struct scsi_qla_host *, struct pt_ls4_request=
 *,
> -    struct req_que *);
> +void qla24xx_nvme_ls4_iocb(struct scsi_qla_host *vha, void *pkt,
> +			   struct req_que *req);
>  void qla24xx_async_gffid_sp_done(struct srb *sp, int);
>  #endif

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D38
