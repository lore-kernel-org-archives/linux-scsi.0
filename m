Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CF742089C
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783404945; cv=none; b=FRsCcERAoyfBSeCLccy6Ec1vLSiad7ga6dL5kA8K14oarLorqNe0zRnGmpN8eZxClM1gZ3Hg4YjJIqG6D279wfU0wvRhWHIcMxQjvwASzeRkjYGZ3IAgMFh3RcJumoGUUSvoCXyiAH1qcgcCLWylv8S/lcNILUzfk83uxm1VMTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783404945; c=relaxed/simple;
	bh=PXAsyiESQ5eTM2m8/hYZbsgMDQ6AvrQ3Lb9v/yvpo24=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VHYg57p0e3U0/UkU9dV3xMH1uh3LpnZpe7JHvL+h22yAFkL+TUC74wDhXn7xheaDi3UQn0fsQ/ll3F/nTxMlltFyNeX5E78cHsjeFvCeFVuuhKff//kT7ScF4GHkhJq8CfELhOuOsc0G7slRHuF1hJKrTjifdDHtF4nJCgZU+w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MceU6a54; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MceU6a54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989F11F000E9;
	Tue,  7 Jul 2026 06:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783404943;
	bh=UU9OeDgQT1DGGDCB5IYEOPp+YUbHKFURcbzLLAggcQA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MceU6a54wGzH6EZUlDOukfuA9XoRXpB0gr+c1IYp3DYidq9zjzih9/YBkJwhSid1S
	 cRoEIhdKtpFq2Hk1KTBeNN/uNpGu8ypcmVq+XyR7hMxbG8CwkRQnPYQaOF6SJyLU3Z
	 6TT7s8esMR3P7t+eJzuCqqBbPEB8EJ+XT3v1thZBc+eyDddbaveyn2cEk5inXIQdHR
	 ZD3882YES7yAiG9ant9jYwRrlv5cQY9QN4TA6fSBEp4Je2kmbVKk48sb3ZCtTJV8TZ
	 CICtoVJH58fS9z17+adDwFOM5hyvj2htGD/uG7jRM2FP8UdjlJ86Qt9ImHMtTqjP1O
	 DY3MrNZsckU5Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 16/88] scsi: qla2xxx: Enable get_adapter_id mailbox
 for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-17-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-17-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:15:43 +0000
Message-Id: <20260707061543.989F11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Incomplete feature enablement: BBCR data for QLA29XX adapters is=
 fetched but inaccessible to userspace.
--

--- Patch [16]: [PATCH v3 16/88] scsi: qla2xxx: Enable get_adapter_id mailb=
ox for 29xx ---
commit 239e664ad50c43bb93243854a8f202ecb4bc46cc
Author: Nilesh Javali <njavali@marvell.com>
scsi: qla2xxx: Enable get_adapter_id mailbox for 29xx

This commit adds the IS_QLA29XX() check to qla2x00_get_adapter_id() so that
the additional mailbox registers for buffer-to-buffer credit (BBCR) and
SCM/EDC status are read on 29xx adapters.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
[ ... ]
> @@ -1827,7 +1827,7 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16=
_t *id, uint8_t *al_pa,
>  			}
>  		}
> =20
> -		if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw)) {
> +		if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw) || IS_QLA29XX(vha->hw))=
 {
>  			vha->bbcr =3D mcp->mb[15];

[Severity: Medium]
Does this change miss an update in the BSG interface for userspace?

While vha->bbcr is successfully read from the adapter for 29xx hardware
here, it appears userspace still cannot access it. Looking at
qla27xx_get_bbcr_data() in drivers/scsi/qla2xxx/qla_bsg.c, it unconditional=
ly
rejects 29xx adapters:

drivers/scsi/qla2xxx/qla_bsg.c:qla27xx_get_bbcr_data() {
        ...
        if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
                return -EPERM;
        ...
}

Will this result in QL_VND_GET_BBCR_DATA BSG commands failing with -EPERM
for 29xx adapters, preventing userspace from retrieving the BBCR data read
by this patch?

>  			if (mcp->mb[7] & SCM_EDC_ACC_RECEIVED) {
>  				ql_log(ql_log_info, vha, 0x11a4,
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D16
