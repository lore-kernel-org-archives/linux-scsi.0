Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2079328B7C8;
	Thu, 15 Oct 2026 04:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792039156; cv=none; b=pi1esRN5A7LprNP85L0aw+mEZKSHiCXDtN7qkTEzvDOn86Ixxgef3d4NvhBxY3dMY+i78pa3Iw2fkEmE5CEzjQtMBszGsJpoRENFPR4BVE78q0322dSzH6aT0osgEuseN3Dki+got/dyvkiVOPPi8V1CXLcHClbBEQzsOiR4MPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792039156; c=relaxed/simple;
	bh=E9RWCZAXxs7+Yyso8qlWF9UwfN24byDG5vZCcl3LO+Y=;
	h=Message-ID:Subject:From:To:CC:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ss7y7NW4qvEnT8vF9aeFQb5oFw7uRdbG0Bs8zBOmuhhs0cQLeGC/6KqXlDfLaxBpztGdxcmWRVXCBDlJh4cdkGQ9I30Ps+u0dY7Ke5I4xYEOQ+wn3rSI0umWyd3mfA2lxMPSwRvFKVQnxOK03WMx03ruBw1oiigI3deZSylALb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=lG1QwwPx; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="lG1QwwPx"
X-UUID: 581697fac85211f1b1788b6acf885367-20261015
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=E9RWCZAXxs7+Yyso8qlWF9UwfN24byDG5vZCcl3LO+Y=;
	b=lG1QwwPxZQ1mquTjt6eziz/oAVeOULSWfvgsXEZ+a+xqjrQ9qMdtPRBg6ybYtgV6c5muUV/vd40g/kAd5LacwiK9BH2toaAY971zzxBoVhce3GW2v5V2dDBL0rfx8disdYGnN8qBOs4AIszZ6ofkMydm3zt0g1OPfrzYmkxro4A=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:7306874b-cb1f-4afa-8f87-9f9679fdea70,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:73025c20-2f17-48f6-b8a0-2bb5971c52b4,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|136|836|865|888|898,TC:-5,Cont
	ent:0|15|50|99,EDM:-3|-100,IP:nil,URL:99|1,File:130,RT:0,Bulk:nil,QS:nil,B
	EC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 581697fac85211f1b1788b6acf885367-20261015
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 848792969; Thu, 15 Oct 2026 12:39:01 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Oct 2026 12:39:00 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Thu, 15 Oct 2026 12:39:00 +0800
Message-ID: <825da2b59b5aee026256ebe6db23383aa25e4238.camel@mediatek.com>
Subject: Re: [PATCH v2 0/5] scsi: ufs: Fix UIC result byte and BSG request
 handling
From: Peter Wang <peter.wang@mediatek.com>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K. Petersen"
	<mkp@kernel.org>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>
CC: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche
	<bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>, Brian Kao
	<powenkao@google.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Date: Thu, 15 Oct 2026 12:39:00 +0800
In-Reply-To: <20261015001855.3450573-1-stanleyjhu@google.com>
References: <20261015001855.3450573-1-stanleyjhu@google.com>
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

On Thu, 2026-10-15 at 08:18 +0800, Stanley Jhu wrote:
> ufs-bsg fixes for issues found by fuzzing /dev/bsg/ufs-bsg* with
> syzkaller on QEMU's emulated UFS host controller and in review of v1,
> plus a fix for peer DME retries.
>=20
> Patch 1 completes failed BSG requests via bsg_job_done() so error
> paths
> do not leak the job's device reference and mapped scatterlists.
> Patch 2 clears the reused reply buffer so replies do not carry bytes
> from an earlier request.
> Patch 3 rejects requests shorter than the UFS BSG request structures.
> Patch 4 rejects UIC commands with a non-zero result byte from
> userspace.
> Patch 5 clears the stale UIC result byte and restores argument3
> before
> peer DME retries.
>=20
> Patches 1-2 also address the sashiko review of the bsg reply_len
> patch:
> https://lore.kernel.org/all/sashiko-outbox-169843@kernel.org/=C2=A0
>=20
> Tested on QEMU arm64: the reproducers no longer trigger.
>=20
> Differences from v1:
> - New patch 1/5: complete failed jobs via bsg_job_done().
> - New patch 2/5: clear the reply buffer on entry.
> - Patch 4/5: reject non-zero UIC result byte with -EINVAL (Bart).
> - Patch 5/5: restore argument3 on each retry in
> ufshcd_dme_set_attr().
>=20
> Link:
> https://lore.kernel.org/all/20261013102913.948718-1-stanleyjhu@google.com=
/
> =C2=A0
>=20
> Stanley Jhu (5):
> =C2=A0 scsi: ufs: bsg: Complete the job on error
> =C2=A0 scsi: ufs: bsg: Clear the reply buffer before use
> =C2=A0 scsi: ufs: bsg: Validate request_len before accessing request
> =C2=A0 scsi: ufs: bsg: Reject UIC commands with a non-zero result byte
> =C2=A0 scsi: ufs: core: Clear stale UIC result byte before peer DME
> retries
>=20
> =C2=A0drivers/ufs/core/ufs_bsg.c | 23 +++++++++++++++++------
> =C2=A0drivers/ufs/core/ufshcd.c=C2=A0 |=C2=A0 9 +++++++--
> =C2=A02 files changed, 24 insertions(+), 8 deletions(-)
>=20
> base-commit: 9621cbd332862eb6651e2aba24ed18f66560de66

For the series:
Reviewed-by: Peter Wang <peter.wang@mediatek.com>

