Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DAE1DA62E
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 02:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783046756; cv=none; b=eIserd2RgoB0b45HZCEVou6xqtTPwOg/eqdXWAtA+qTl2CH1IJB7adKtxqhu8p4BfiF5iY+jm+gD62YDa+L2RGaQGHcHc/u3L3B41WHDCq04MHQ78uDiHfZ5amH8ZYGo6LsSXjz+G9tzmKtKQogJP2zHYGyB9u2nzq9SbOCZVkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783046756; c=relaxed/simple;
	bh=CAD8wcQ4wGMUpqQCNALPYiq0Xmjvw8kQjccVNQCPoAY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=V82tZbkEd8D3FKOcVqdKko285HdqJLQhyBmHBbmctXdsv5QZaG56zqEZbNbsSUFho92OY44txkwUMqwr6d2AsTJ3Vi4gZlQg1lshR4KGptUd9E6r3YVGD0SPXU4eMV3cN6srPxm93F0XV3IYk4NGFc8LKTGWtHIOjCsIJJcTiNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kUHOqPYM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kUHOqPYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB731F000E9;
	Fri,  3 Jul 2026 02:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783046754;
	bh=GgQzKeUuPxMJM3hLB8rspLvU/5fl9IreEebS6Gzh0W4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kUHOqPYMi4SFw4GntuvgLrc578lFY3FIlX5peNEevbEwlymJomq0OmfHPDhslBQS2
	 kfos1vjKzYngPeuQfKapIh0a+oJmt/VLSwSeXP4RB2JsIkJxJT3MtHrLCY3OWv8D1s
	 owOfsdo5W+pEy56oWeQultYUjuEhayOUagrm7K/jT4hiPu6g4Q+DOC8QUeJo+ObO3N
	 zf3vr1Ac5Gz16ZrUnsw2qaLp8o3rFhE3qNRcTyVmFN/Q2rrX8XZVhbtOaaNFB/yYMd
	 yc4oS3LmJe5uxH54NRXuQMqybTVObvBJw2PDMIJ3+nkbwlTqk++eIgHCZaN/uMYV22
	 Xkyc+Sr77DvSw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] scsi: hisi_sas: add spinup_notify callback to
 handle Active_Wait/Idle_Wait SSP devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703022833.36847-3-yangxingui@huawei.com>
References: <20260703022833.36847-1-yangxingui@huawei.com>
 <20260703022833.36847-3-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 02:45:54 +0000
Message-Id: <20260703024554.BCB731F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Lockless Read-Modify-Write (RMW) race on the `SL_CONTROL` hardware=
 register between process context (workqueue) and hardirq context.
--

commit 1e2c413ee8dab5cb152dd02e52904e080713afd6
Author: Xingui Yang <yangxingui@huawei.com>

scsi: hisi_sas: add spinup_notify callback to handle Active_Wait/Idle_Wait =
SSP devices

This commit adds a spinup_notify callback for waiting SSP devices. It queues
a work item to the driver's ordered workqueue to send a NOTIFY primitive by
pulsing the SL_CONTROL.NOTIFY_EN bit, which defers hardware access to proce=
ss
context.

> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sa=
s/hisi_sas_main.c
> index 944ce19ae2fc1..14cf01466a75d 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
[ ... ]
> @@ -996,10 +996,22 @@ static void hisi_sas_phyup_pm_work(struct work_stru=
ct *work)
>  	pm_runtime_put_sync(dev);
>  }
> =20
> +static void hisi_sas_spinup_notify_work(struct work_struct *work)
> +{
> +	struct hisi_sas_phy *phy =3D
> +		container_of(work, typeof(*phy), works[HISI_PHYE_SPINUP_NOTIFY]);
> +	struct hisi_hba *hisi_hba =3D phy->hisi_hba;
> +	int phy_no =3D phy->sas_phy.id;
> +
> +	hisi_hba->hw->sl_notify_ssp(hisi_hba, phy_no);

[Severity: High]
This is a pre-existing issue, but does the ordered workqueue actually preve=
nt
concurrent RMW races on SL_CONTROL against hardirq context here?

The commit message states that the ordered workqueue prevents concurrent RMW
races on SL_CONTROL, but looking at sl_notify_ssp_v3_hw(), the RMW operation
occurs in process context without interrupt disable or spinlock protection:

drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:sl_notify_ssp_v3_hw() {
        ...
        sl_control =3D hisi_sas_phy_read32(hisi_hba, phy_no, SL_CONTROL);
        sl_control |=3D SL_CONTROL_NOTIFY_EN_MSK;
        hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL, sl_control);
        ...
}

If an interrupt fires exactly between the read32 and write32 operations,
phy_down_v3_hw() executes another RMW on the same register in hardirq
context:

drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:phy_down_v3_hw() {
        ...
        sl_ctrl =3D hisi_sas_phy_read32(hisi_hba, phy_no, SL_CONTROL);
        hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL,
                                                sl_ctrl&(~SL_CTA_MSK));
        ...
}

If this preempts the workqueue RMW, wouldn't the process context write
revert the clearing of SL_CTA_MSK done by the interrupt, leading to
hardware state corruption and potentially causing the loss of the PHY/disk
connection?

> +	dev_info(hisi_hba->dev, "spinup notify primitive on phy%d\n", phy_no);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703022833.3684=
7-1-yangxingui@huawei.com?part=3D2
