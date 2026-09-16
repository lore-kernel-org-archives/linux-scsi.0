Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE30448B93
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 07:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543331; cv=none; b=Ud2UxmcOLK2ssmgDzaWMVltylZ22iDCkHYnEyfnzI4HihLrK0pV3fTC2IRcuk93oyN6JKxcImRhvo/Cz1eWU2IeW5k3qQ0wP/gUSF016hHupoOcu/RCON7l4LzYYRmpZe3fwW/HUbwn9sKrfd1jQGRjMeX2PT8AlyUCrkvWq+70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543331; c=relaxed/simple;
	bh=310U+E0ecQy91rjW2iV32h32UpEgNx0LGFBaGJg/IzA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ETjIgmF6gthvrrjn5PBeYDcS3FWwCODrhOekhU6gZP5L2S1JzFr4vhhEC3dO5bkdkDlkn1wjiP+/AZdqte/o6c4zpiHMsPE4PuRI/zvAWZxZn0pZTAWXX+5vi4AToBeL1X2x/YuIeuVFiDC5GOoX2exiBlXWnv/ZO8jvYMBIbfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=e8gE0sPa; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="e8gE0sPa"
X-UUID: 28ee4280b19f11f1b1788b6acf885367-20260916
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=310U+E0ecQy91rjW2iV32h32UpEgNx0LGFBaGJg/IzA=;
	b=e8gE0sPaSahyB4iRy+yxvHI95yOQ43XvsmWmWwNkCWQS57Fa4b5RwvxIWkLt5pnCKZSKNwYqFeRxCmRjVxNT6FDbf9tq4EQpmEy7VpVjEBSNXIv9WZs1XVhL7JCEoFN6BiDlXc8Y6ciasict2sPJfxD21nzwINGiq33p5sfnUqQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:cc506787-b39f-4792-bf02-1fff45749d7c,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:7db8b62,CLOUDID:9ff9f36c-9dd5-4555-834a-4f1343344a9f,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 28ee4280b19f11f1b1788b6acf885367-20260916
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <naomi.chu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1822374606; Wed, 16 Sep 2026 15:20:56 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 16 Sep 2026 15:20:55 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 16 Sep 2026 15:20:55 +0800
From: Naomi Chu <naomi.chu@mediatek.com>
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-scsi@vger.kernel.org>, <mkp@kernel.org>, <avri.altman@sandisk.com>,
	<alim.akhtar@samsung.com>, <James.Bottomley@HansenPartnership.com>,
	<bvanassche@acm.org>
Subject: Re: [PATCH v1] scsi: ufs: core: Hold a clock reference across the probe
Date: Wed, 16 Sep 2026 15:20:55 +0800
Message-ID: <20260916072055.1346914-1-naomi.chu@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260909092536.B78571F00A3D@smtp.kernel.org>
References: <20260909092536.B78571F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

On Wed, Sep 09, 2026 at 09:25:36AM +0000, sashiko-bot@kernel.org wrote:
> Pre-existing issues:
> - [Critical] Missing scsi_remove_host() on the ufshcd_init() error path
> leaves dangling sysfs references leading to use-after-free.
[...]
> If ufshcd_init() fails after successfully calling ufshcd_add_scsi_host()
> (for example, if ufshcd_link_startup() or ufshcd_verify_dev_init() fails
> and jumps to out_release), the function returns an error without calling
> scsi_remove_host().

Thanks for the report. As the bot itself notes, this is a pre-existing
issue, and this patch neither introduces nor changes it.

The new out_release label only drops the clock reference taken earlier in
ufshcd_init() and then falls through to out_disable. Every goto that this
patch retargets used to jump to out_disable directly, so the set of
failures that leaves ufshcd_init() without calling scsi_remove_host() is
exactly the same before and after this patch.

Fixing that error path is independent of the clock reference problem
addressed here, so it should be fixed by a completely separate patch
rather than folded into this one.

Thanks,
Naomi
