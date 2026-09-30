Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A383B8958;
	Wed, 30 Sep 2026 07:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790753569; cv=none; b=YNKFX5GKv/HXWCjG0/kkY+wV4xMoRo8e6HTMdFAFppdM6E6y0qEEduLzlSeIEEeJ4mUA+nO48Fq0b1s3fngeIVOyjVnQvWKrPjlcdZjFhzWKwE72ocot2FAaH0NEs1dLO2I6l/8Vnz6fpVD3srt7LPTLL/+DMNNH1P1cMtuV6eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790753569; c=relaxed/simple;
	bh=gOLCtVRmaBN+1rWxqGAsnpdL2Fs9Tw1hwDh3KmQQ/SM=;
	h=Message-ID:Subject:From:To:CC:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Hl8UA0XeDiwLeWSwZP//ctgWuz3VEtD0qqnES4N3FKsT4u5H6wzYMvyT5RaGWFY0zI0tTgy9QMPCMryUUIM6oYGKaZ6XK/zBo87uK4YhzCEtuXvWpurQZNWEVMh4H71YydXiAd1winG+u/E1Vkcz2rczn3Rj2Tyev8Fb1CBjwvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=r236zFUl; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="r236zFUl"
X-UUID: 1f3082d2bca111f1b1788b6acf885367-20260930
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=gOLCtVRmaBN+1rWxqGAsnpdL2Fs9Tw1hwDh3KmQQ/SM=;
	b=r236zFUlEO4225puLzKYQgyz9zRnO4NoXe/pZ68UK8gj177oyDHvQXlSdQGfAQJLHGLGDvJd2mUdgJccM73FmeJJSbGV/wTp+xhk+kVB3AcehzL6KsDoDH9+jVQKIPooN8F0JGaydkNp+MFVu9vkGErfeubOCk/py6t83fIiJg0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:f1a4caf9-d1ae-4811-8409-80426c9f9105,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:49267775-a994-4a3a-ab0d-b7638be1f94c,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|136|836|865|888|898,TC:-5,Cont
	ent:0|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:
	-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1f3082d2bca111f1b1788b6acf885367-20260930
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 217409389; Wed, 30 Sep 2026 15:32:42 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 30 Sep 2026 15:32:41 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Wed, 30 Sep 2026 15:32:41 +0800
Message-ID: <c7ce0c71efb432696a40a1ee8b4d403822c8cbec.camel@mediatek.com>
Subject: Re: [PATCH v3 2/2] scsi: ufs: core: Decouple CQ sweep from request
 iterator in MCQ
From: Peter Wang <peter.wang@mediatek.com>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, Bean Huo <beanhuo@micron.com>, "Bart Van
 Assche" <bvanassche@acm.org>
CC: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, Manivannan
 Sadhasivam <mani@kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Date: Wed, 30 Sep 2026 15:32:41 +0800
In-Reply-To: <20260928035816.1294326-3-stanleyjhu@google.com>
References: <20260928035816.1294326-1-stanleyjhu@google.com>
	 <20260928035816.1294326-3-stanleyjhu@google.com>
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

On Mon, 2026-09-28 at 11:58 +0800, Stanley Jhu wrote:
> In MCQ mode, ufshcd_mcq_compl_pending_transfer() uses
> blk_mq_tagset_busy_iter() to iterate over busy requests during error
> recovery and host reset. However, both iterator callbacks perform
> whole-queue operations redundantly for each visited request:
>=20
> - force_compl =3D=3D true: ufshcd_mcq_force_compl_one() calls
> =C2=A0 ufshcd_mcq_compl_all_cqes_lock() on every busy request, sweeping
> the
> =C2=A0 entire completion ring (hwq->max_entries slots) once per active
> =C2=A0 request under spin_lock_irqsave even though the first sweep alread=
y
> =C2=A0 cleared all completion entries.
> - force_compl =3D=3D false: ufshcd_mcq_compl_one() acquires cq_lock and
> =C2=A0 polls CQTPy over MMIO via ufshcd_mcq_poll_cqe_lock() for every bus=
y
> =C2=A0 request without doing any per-request work.
>=20
> Sweep or poll each hardware queue (hba->uhq[i]) once at the start of
> ufshcd_mcq_compl_pending_transfer(). When force_compl is true, run
> blk_mq_tagset_busy_iter() afterward to complete residual in-flight
> requests with DID_REQUEUE, and remove the now-unused
> ufshcd_mcq_compl_one() callback.
>=20
> Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ
> mode")
> Cc: stable@vger.kernel.org
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>

Reviewed-by: Peter Wang <peter.wang@mediatek.com>

