Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315B0279329;
	Tue, 22 Sep 2026 03:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790046339; cv=none; b=BqLPXD69j4syFRdr0qfVEJISUCcDIDli0ChRFBQB0FohYB72niWZQkYjdMbv2hq2sm402bcxSGhgx3RYt9ctaG0Wp6p5YC6aWOW9JL3j4jei1AgN96AeIR7Eva2scRVbM+eJpa4aFNO8Z5Cr/JdCJPJV3YsP2XInbCZ4Rl81za0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790046339; c=relaxed/simple;
	bh=jNzOnq1/TZ39LDjuPRMZdUwRjEuolZVGcIxQ+s+XyP0=;
	h=Message-ID:Subject:From:To:CC:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=afmxDh32rBs1/S5zyusLwg2n+Uo3a8N/KgK6xmqo68Uy10//W40ZNNtwjRDA7N+x+33ca39reaW8Zk78B0hNnk26ElfB6498RB9AYinNvqikJxymHNWPEc78y/oJXViYlLA5wqi7UArlOw4UjwFsbmiMnL8y4d7ieL4EaZs5nG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=F21fCrBB; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="F21fCrBB"
X-UUID: 7942d38ab63211f18dc8c9802ae25ab1-20260922
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=jNzOnq1/TZ39LDjuPRMZdUwRjEuolZVGcIxQ+s+XyP0=;
	b=F21fCrBBvLujxrB9o+ZNeNVMswTOUTu3jPg8Sk4WulZChmrz5hNlPDPQ1QZvPSL0Fh0UV74s8+FC7nZJcjnS3nnyP6kdd5gxOcc9AwotrXK95Fc7bZU5TKZCYpFfOX9d87NzSVU3cDFFHh7gPm01q2mkw3kcjS/q6twGbSgTtVo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:69a34c20-cc2d-4800-9829-af1d32a32567,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:76b4657c-2058-4298-90ad-1156c3f1dffd,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7942d38ab63211f18dc8c9802ae25ab1-20260922
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 11498419; Tue, 22 Sep 2026 11:05:32 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 22 Sep 2026 11:05:31 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Tue, 22 Sep 2026 11:05:31 +0800
Message-ID: <d48ff9b9b74b2e1f9feef1322ca5d3cfb1704b62.camel@mediatek.com>
Subject: Re: [PATCH v2 1/2] scsi: ufs: core: Avoid unsafe MMIO reads in
 ufshcd_mcq_compl_all_cqes_lock()
From: Peter Wang <peter.wang@mediatek.com>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, Bean Huo <beanhuo@micron.com>, "Bart Van
 Assche" <bvanassche@acm.org>
CC: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, Manivannan
 Sadhasivam <mani@kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Date: Tue, 22 Sep 2026 11:05:31 +0800
In-Reply-To: <20260918143809.3034592-2-stanleyjhu@google.com>
References: <CAE14pdek6ynze+muDZrK+yNX-3ioe3vprxOA4W22qokg352tJQ@mail.gmail.com>
	 <20260918143809.3034592-1-stanleyjhu@google.com>
	 <20260918143809.3034592-2-stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MTK: N

On Fri, 2026-09-18 at 22:38 +0800, Stanley Jhu wrote:
> During MCQ host reset, ufshcd_host_reset_and_restore() stops the host
> controller via ufshcd_hba_stop() (HCE =3D 0) before calling
> ufshcd_complete_requests(hba, true) ->
> ufshcd_mcq_compl_pending_transfer(hba, true) ->
> ufshcd_mcq_force_compl_one() -> ufshcd_mcq_compl_all_cqes_lock().
> Because ufshcd_mcq_force_compl_one() is its sole caller,
> ufshcd_mcq_compl_all_cqes_lock() always runs with HCE =3D 0.
>=20
> Despite the comment above ufshcd_mcq_compl_all_cqes_lock() stating
> that
> reading CQTPy may not be safe with the controller disabled, the
> function
> still calls ufshcd_mcq_update_cq_tail_slot() at the end of its sweep:
>=20
> 1. Unsafe CQTPy MMIO read:
> =C2=A0=C2=A0 Calling ufshcd_mcq_update_cq_tail_slot() at the end of the s=
weep
> =C2=A0=C2=A0 reads CQTPy over MMIO while HCE =3D 0, directly contradictin=
g the
> =C2=A0=C2=A0 function's documented contract (commit 1373df88d535 ("scsi: =
ufs:
> =C2=A0=C2=A0 core: Add a comment block above
> ufshcd_mcq_compl_all_cqes_lock()"))
> =C2=A0=C2=A0 that reading CQTPy may not be safe with the controller disab=
led.
>=20
> 2. Spurious error logs on empty slots:
> =C2=A0=C2=A0 Sweeping all max_entries slots visits empty entries where
> =C2=A0=C2=A0 command_desc_base_addr is 0, causing ufshcd_mcq_process_cqe(=
) to
> log
> =C2=A0=C2=A0 unguarded dev_err(hba->dev, "Abnormal CQ entry!\n") messages=
.
>=20
> Fix both issues in ufshcd_mcq_compl_all_cqes_lock():
> - Synchronize hwq->cq_tail_slot =3D hwq->cq_head_slot in software after
> =C2=A0 sweeping the ring, avoiding CQTPy MMIO reads while HCE =3D 0.
> - Extract ufshcd_mcq_compl_cqe() and invoke it only on non-empty
> slots
> =C2=A0 during full-ring sweeps, keeping "Abnormal CQ entry!" logging
> strictly
> =C2=A0 for unexpected empty entries in ufshcd_mcq_poll_cqe_lock().
>=20
> Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ
> mode")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
> ---

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
