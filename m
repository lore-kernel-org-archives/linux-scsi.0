Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F3B3612ED
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 03:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791518346; cv=none; b=q5Qod5+Gk7cqZNosF3xTYSqZaT/ZdIlFvkSUYQBoK0Ki3LjAVJ4L5/M759TvvoX1kTl2IsCd/wO1CvfTGWw9Ov3pm8H80J4NRTuO/vN3iknBrWPFaMsJZFgH4KJWm++sJPDfcXMODWWVZ5GJUZnPrqpGC2/gsuOdBYR+G2qVAI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791518346; c=relaxed/simple;
	bh=Nd0zxlTkptaH+M9DFNp3yuyLWmduEjhpxo8YldUQBLg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=pGqSlgy/vs0wzbhKRgJJX85+AxyzQv/itTbe6V5WMPo4h1oFPEALN27/1IjHn/oWRdstXvCvzVl8ybm7K0XnHORUAa9bhXRAAsxQn7a9s6P1/PgrKtOHUsv/UN1jWibkg/iMcGahialsxzK12zBDVSL9aVFrCPAmb34vxQROknQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GA1hpGDX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GA1hpGDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C492A1F000FF;
	Fri,  9 Oct 2026 03:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791518333;
	bh=jG4NG1ysbwJG71pRifutltvre+Z9r8E1jx0RRomcRMA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GA1hpGDXcb/hLEvBlENxrjo88daZTxIj7kzohqBbRrZOIOEalQGQlblMNJqcPHo9l
	 77PksguJe98c0aTGM9THADJIDFG7R6ioA5sxoTBpjIp5PAF404KGMSlX8um5jADpyE
	 ejcV4GW/5oWD+UuErC12osf965V+R1SO0akCxKVrKhVzD+chsjiaLYdW8FEPA0rFIU
	 HhT/jb2TmHxVdt6JFDH9d2JjBuzueF/gDgsAp0tpPINsuWuzajcmbP5RsoxRdDjXO4
	 b6YBP43CpsA/AwoJeIHSIJ75UWeJC1GF2kVfChsJRc30fJjI8UWuznpYidZJSK20Ty
	 tRCkjzGRj7ggg==
Message-ID: <sashiko-outbox-164806@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/4] scsi: hisi_sas: Fix spinup failure for SAS SSP
 devices in Active_Wait state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261009033238.1076098-5-yangxingui@huawei.com>
References: <20261009033238.1076098-1-yangxingui@huawei.com>
 <20261009033238.1076098-5-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 03:58:53 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] pm: usage count underflow due to incorrect pm_runtime_get_if_act=
ive() check in hisi_sas_spinup_notify()
--

commit 255dba6c6286916d717929164fd02a77f83d3168
Author: Xingui Yang <yangxingui@huawei.com>
Subject: scsi: hisi_sas: Fix spinup failure for SAS SSP devices in Active_W=
ait state

This commit addresses spinup failures for directly-attached SSP devices=20
waiting in the Active_Wait state. It parses sense data during slot=20
completion and queues work to send a NOTIFY(ENABLE SPINUP) primitive while=
=20
managing the runtime PM state of the controller.

> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sa=
s/hisi_sas_main.c
> index 944ce19ae2fc1..cf7aa0a699cde 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -996,10 +996,25 @@ static void hisi_sas_phyup_pm_work(struct work_stru=
ct *work)
[ ... ]
> +static void hisi_sas_spinup_notify_work(struct work_struct *work)
> +{
[ ... ]
> +	hisi_hba->hw->sl_notify_ssp(hisi_hba, phy_no);
> +	dev_info(dev, "spinup notify primitive on phy%d\n", phy_no);
> +
> +	pm_runtime_put_sync(dev);

[Severity: Medium]
If the earlier pm_runtime_get_if_active() check bypassed a negative error
code, will this cause a runtime PM usage count underflow since the reference
was never successfully incremented?

> +}
[ ... ]
> @@ -1639,6 +1654,34 @@ void hisi_sas_controller_reset_done(struct hisi_hb=
a *hisi_hba)
[ ... ]
> +void hisi_sas_spinup_notify(struct hisi_hba *hisi_hba,
> +			    struct sas_task *task)
> +{
[ ... ]
> +	if (!pm_runtime_get_if_active(hisi_hba->dev))
> +		return;

[Severity: Medium]
Does this check properly handle negative error codes?

pm_runtime_get_if_active() returns 1 if the device is active, 0 if inactive,
and a negative error code (like -EINVAL) if runtime PM is disabled. If it
returns -EINVAL, !(-EINVAL) evaluates to false, causing execution to proceed
without actually acquiring a PM reference.

Should this check be `if (pm_runtime_get_if_active(...) <=3D 0)` instead?

> +
> +	local_phy =3D sas_get_local_phy(dev);
> +	phy =3D &hisi_hba->phy[local_phy->number];
> +	if (!hisi_sas_notify_phy_event(phy, HISI_PHYE_SPINUP_NOTIFY))
> +		pm_runtime_put(hisi_hba->dev);

[Severity: Medium]
Similarly, if queueing fails here, but the initial pm_runtime_get_if_active=
()
returned a negative error code, does this cause an immediate usage count
underflow?

> +
> +	sas_put_local_phy(local_phy);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009033238.1076=
098-1-yangxingui@huawei.com?part=3D4
