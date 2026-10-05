Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEC936B909;
	Mon,  5 Oct 2026 08:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791189272; cv=none; b=TzFU0ER4uOlqg2D9XRQihUP4netlQtammeutOJGaZ//pqX4n9qJn34qYEVxWdxKJ1F/BklCuiOrpxjrHzSVp4dW0shrD3L1x3l7N2ZyHCz33qBM93mawWnTJDOtDw43yY9iU2vMpzvYojFkrfMOmA/LkQ1Y6na87umPPoTFJOeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791189272; c=relaxed/simple;
	bh=w+wwFVK6KHQeaI9uRymOZz39D1QHGigoaSM3nqJFb2o=;
	h=Message-ID:Subject:From:To:CC:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cuTcruimFhmMA0lHmoeqeup3xV4csyRrv1RVG9yqvjPqpPoV6u+jZgK3q1D9NpTKhpF0tAuAgbrmOcL4tzI7W2rbrB8aF153j+86x4+znCr0BWJ0jvVgDiPn/YQo2xmANAef32pQ78lIYZ3D7m8Z4QifVC3X3wwBJmGA1GJ8opE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=T82Yj+bf; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="T82Yj+bf"
X-UUID: 91014c30c09711f18dc8c9802ae25ab1-20261005
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=w+wwFVK6KHQeaI9uRymOZz39D1QHGigoaSM3nqJFb2o=;
	b=T82Yj+bfTswDS50xJKmn8YEuCE/0gz5Dwpekm18qsdMCgRXxZ8QyY0yuTzaWVgb7zSbQ+iLJTYSZIIFYAOHQN0tWuZy5+lv2gB04NdpU7rp/LJwUdFQ+/uQ2WyLMF48ahaPJwyNDLmz3JedCkaFb6TdOg0eVPOVaLy9gjUAFtyo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:101acceb-3428-4f4d-88bd-8739f094ec14,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:8e95a094-f92e-44c1-a195-feed1a426245,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 91014c30c09711f18dc8c9802ae25ab1-20261005
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <alice.chao@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 106743173; Mon, 05 Oct 2026 16:34:23 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Oct 2026 16:34:21 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Mon, 5 Oct 2026 16:34:21 +0800
Message-ID: <be68524572540edfd87ec4b5f25c28933ccd45f6.camel@mediatek.com>
Subject: Re: [PATCH 6.18.y] scsi: ufs: core: Re-arm the device command
 completion before submitting
From: Alice Chao <alice.chao@mediatek.com>
To: <martin.petersen@oracle.com>, <bvanassche@acm.org>
CC: Sasha Levin <sashal@kernel.org>, <stable@vger.kernel.org>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<James.Bottomley@HansenPartnership.com>, <avri.altman@sandisk.com>,
	<alim.akhtar@samsung.com>, <wsd_upstream@mediatek.com>,
	<linux-mediatek@lists.infradead.org>, <peter.wang@mediatek.com>,
	<chun-hung.wu@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>
Date: Mon, 5 Oct 2026 16:34:21 +0800
In-Reply-To: <daily-reply-20260915-0008-re-ufs-dev-cmd-completion@kernel.org>
References: <20260915052638.459390-1-alice.chao@mediatek.com>
	 <daily-reply-20260915-0008-re-ufs-dev-cmd-completion@kernel.org>
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

On Tue, 2026-09-15 at 21:52 -0400, Sasha Levin wrote:
> > Re-arm the completion in ufshcd_issue_dev_cmd(), immediately before
> > submitting. All submitters - ufshcd_exec_dev_cmd(),
> > ufshcd_issue_devman_upiu_cmd() and ufshcd_advanced_rpmb_op() -
> > reach it
> > holding hba->dev_cmd.lock, so no extra serialization is needed.
>=20
> The analysis reads correct to me and the patch is clean against 6.18,
> but
> this is a stable only change in the UFS core completion path with no
> mainline counterpart, since 08b12cda6c44 ("scsi: ufs: core: Switch to
> scsi_get_internal_cmd()") deleted this code outright. I would like a
> subsystem ack before queueing it.
>=20


Gentle Ping.

Hi Martin and Bart, any thoughts on this one?

Thanks.
