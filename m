Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D333C465
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 03:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791430887; cv=none; b=EG/NWk0EfW6TOvRzhcgu2PGrjh1+oRJ3mhLus6eN/ouuCHMO9Ew9omhgWcTSu8yKJ65dhQ3JK1yFaitxnSBPvgJiXVawlG3RJUg6HBnIuWU+pagcVuI80eoxZMhSVh5swMdzwQ4JdDVdF2O68RVTEQ5Yo46vUOs+lQciF4Mzo0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791430887; c=relaxed/simple;
	bh=Wh+wN/oIo/xHUFljo2ET19qcyPr+n/6ry2K909eTEEM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=KktLzpYapBCIP7U6NvrjgtDGyXlhoN3/3ZIyv+JHysRg7CqUMeExobZ/gFR9vg66oUhDMa0TCluUH5w0btPQp+ll/PWuVmu16dBC+nFQiCXWlv/1nRApjO/k5eMpiRQT5IRDjOQjYmsWLZKeYiexQ+0rXL97DHniFsn9obiC2Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OeDH3iiT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OeDH3iiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83581F000FF;
	Thu,  8 Oct 2026 03:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791430886;
	bh=jLn6IUhx6qXhD4+EXO1klluPNeEHzDHw/Vbvlqwd4BY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OeDH3iiTR/F8+1R2Wbg8Lry6GESEAqtltxddbHiAHobAnKAwEAOR0lmlvLEqm1iJt
	 Jsqh4aRN0Mog/iCcEcvMeChm6OJAfSAdAqxC+ISJpoEiXGkpEGdcyEUtQAm/f0Wukm
	 nk1RC63ulj8dHrRELhYLH1XcXSqHEV81XE8sxqpwP4ZvnvDTYFKE9lMEcxL41oyudz
	 S03hR25kgFZCEBCPxcmJX0qjroQLIYBgik17326RiYzOG7AYSXNj72nkqKn1bwPgBY
	 3jYMJihiwM4OEIFWs6wdUnnSaLxtjiMzyhpI+9A1TXhoaKHiCxNW67BIOxpa1fSrBA
	 aaOzbOZPBMiPQ==
Message-ID: <sashiko-outbox-163572@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/4] scsi: hisi_sas: Clear PHY error counts on phyup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261008032605.2853026-4-yangxingui@huawei.com>
References: <20261008032605.2853026-1-yangxingui@huawei.com>
 <20261008032605.2853026-4-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 03:41:25 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] scsi: hisi_sas: incomplete error clearance on phyup leaves softw=
are counters stale
- [Low] scsi: hisi_sas: missing clear of DWS_LOST and RESET_PROB error coun=
ts
--

commit a53167ef54dbf21492725f9d96ce4668c8ac3e7e
Author: Xingui Yang <yangxingui@huawei.com>

scsi: hisi_sas: Clear PHY error counts on phyup

This patch attempts to clear intermediate link error counts generated during
link establishment in phyup. This is done to prevent stale error data from
polluting runtime statistics.

> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_s=
as/hisi_sas_v3_hw.c
> index 9c363e2373538..a2011d77915bb 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
[ ... ]
> @@ -1061,16 +1064,29 @@ static void enable_phy_v3_hw(struct hisi_hba *his=
i_hba, int phy_no)
>  	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
>  }
> =20
> +static void clear_phy_err_cnt_v3_hw(struct hisi_hba *hisi_hba, int phy_n=
o)
> +{
> +	u32 irq_msk =3D hisi_sas_phy_read32(hisi_hba, phy_no, CHL_INT2_MSK);
> +
> +	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2_MSK,
> +			     CHL_INT2_RX_ERR_MSK | irq_msk);
> +
> +	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_INVLD_DW);
> +	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_DISP_ERR);
> +	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_CODE_ERR);

[Severity: Medium]
Will this leave the software counters stale? While the hardware registers a=
re
cleared here, intermediate errors might have already been accumulated into
software counters during link establishment via phy_get_events_v3_hw():

handle_chl_int2_v3_hw()
  phy_get_events_v3_hw()
    reg_value =3D hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_INVLD_DW);
    sphy->invalid_dword_count +=3D reg_value;

Because clear_phy_err_cnt_v3_hw() only reads and clears the hardware
registers, the corresponding software counters like sphy->invalid_dword_cou=
nt
and phy->code_violation_err_count remain untouched. Should the software
counters also be reset here to completely clear the stale data?

[Severity: Low]
Does this function also need to clear ERR_CNT_DWS_LOST and ERR_CNT_RESET_PR=
OB?

Since these registers are clear-on-read, and phy_get_events_v3_hw() reads a=
ll
five of them, any subsequent RX error could cause phy_get_events_v3_hw() to
read the uncleared, stale DWS_LOST and RESET_PROB counts, incorrectly adding
them to the running statistics.

> +
> +	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2, CHL_INT2_RX_ERR_MSK);
> +	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2_MSK, irq_msk);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008032605.2853=
026-1-yangxingui@huawei.com?part=3D3
