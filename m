Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3217F39934B;
	Tue, 22 Sep 2026 07:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790062572; cv=none; b=VrWO0bfOtcHSGWUlDexwqPXNBrJAwUwecv5XmpLuSPZ+gJamKMRP+O/Lx73H0Njm+LeQORQFxIkDl70df0r9cQMtjTtk94sfuBd0L5uUEtXQNJs3Ki8QhZjhJXBL4kFEZZaWsZlFd7RuX+YNtqivtbgjZQJhC/g3mUjJi6HnLaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790062572; c=relaxed/simple;
	bh=WupABRg8PQciqkiZODB3KE4SK2+q62N13KdNbofq0MA=;
	h=Message-ID:Subject:From:To:CC:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L5yQfA9eSfh91xh83VjKIaDWRGhwD1tKDnbdbxWh8K9h82/TpFcHN+uK1MdVVlKrwY8UMuQ+m37OqL3hFAifSL/BHNG+aYUnxwNS80hqmfzW8PcJn09apBOjQBP1kGbQLkQVs/3OQPHHH/Sf5/2GoyLZE9lPIBk05oIta4oYojg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=WsTWYFuc; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="WsTWYFuc"
X-UUID: 4406c4d0b65811f18dc8c9802ae25ab1-20260922
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=WupABRg8PQciqkiZODB3KE4SK2+q62N13KdNbofq0MA=;
	b=WsTWYFuccNc2x1TdmCZRXuXMfmIDuEwQC9v7i2EX5es8lnQy7GaLUfuMYoDZdLd/HT710O21Wn0rxL3zeNIHgyQDU+Bncuy/oZYzpbVnWy+dMFgZHQTobgt/Q5In5gOOrjtL9FdXPnfTyZOg32bFsVKdYGl23Bb+wlnsjNlxuxo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:1905e1f5-ffe6-4f6d-b302-6e062f087e0a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:c36fa028-9ebf-4787-bb42-3cd26eee85aa,B
	ulkID:nil,BulkQuantity:0,SF:81|82|83|102|136|836|865|888|898,TC:-5,Content
	:0|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,
	COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4406c4d0b65811f18dc8c9802ae25ab1-20260922
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1898250511; Tue, 22 Sep 2026 15:36:03 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 22 Sep 2026 15:36:02 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Tue, 22 Sep 2026 15:36:02 +0800
Message-ID: <96bdcb9f6ccb228ab5cf01161d785b2ed8b80868.camel@mediatek.com>
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Decouple CQ sweep from request
 iterator in MCQ
From: Peter Wang <peter.wang@mediatek.com>
To: Stanley Jhu <stanleyjhu@google.com>, Bart Van Assche <bvanassche@acm.org>
CC: <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, Bean Huo
	<beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Can Guo
	<can.guo@oss.qualcomm.com>, Manivannan Sadhasivam <mani@kernel.org>,
	<linux-kernel@vger.kernel.org>
Date: Tue, 22 Sep 2026 15:36:02 +0800
In-Reply-To: <20260920135014.3528082-1-stanleyjhu@google.com>
References: <CAE14pdek6ynze+muDZrK+yNX-3ioe3vprxOA4W22qokg352tJQ@mail.gmail.com>
	 <20260918143809.3034592-1-stanleyjhu@google.com>
	 <20260918143809.3034592-3-stanleyjhu@google.com>
	 <1ddc5181-f547-465c-bfbe-dbf14a91493e@acm.org>
	 <20260920135014.3528082-1-stanleyjhu@google.com>
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

On Sun, 2026-09-20 at 21:49 +0800, Stanley Jhu wrote:
> That said, doing this inside ufshcd_host_reset_and_restore() right
> after
> ufshcd_hba_stop() is indeed the wrong place: at controller stop time


Hi Stanley,

I have different idea. The original design was that only after
the HBA stop can we ensure the host will no longer process the
remaining commands (those that need to be forcibly requeued)
due to receiving IRQs or other factors, thus avoiding unnecessary
racing. Both SDB and MCQ modes are implemented based on this idea.
However, MCQ indeed does not need to read the CQ register to update
the CQ, because it holds no meaning after the host reset either.

Thanks
Peter


