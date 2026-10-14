Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42DF4334A5;
	Wed, 14 Oct 2026 07:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791962944; cv=none; b=R85hCiwXXafL7oyklitz5WSJwvxLQl+XIHz2cbb0PbyVqPTbc1JA7ICzQWsSezr0LMSAsr1ec3kYiu/TgwGxUc3hDUz4uw7Yew0O7M1AGXihWEAZKEEphG15J32PT6+7HRqZCU/19OCyLZ2Riryvayy1IYqc6lgARM93baXL+uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791962944; c=relaxed/simple;
	bh=yyej2xlBADXECYdNP7xUgE69xFnPcTg7CV+ZJLWTNPs=;
	h=Message-ID:Subject:From:To:CC:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=plS8mK42EXR3e9R78gKA4BHtqwS1iUy/RCiZSh/hQkz5S/Ss3qDi8NeZbBr70cogvmdN6xgggNJCkq+WAawhz6AYIqWQaz7ELLJqyE7HYe/JJ11ZAkzUS4usSjQaod8MOPz9KrsPWWboPoD/i9JopkV/3yq7rbzY7fRM7k/5TOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=cURh56RX; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="cURh56RX"
X-UUID: e83bd262c7a011f18dc8c9802ae25ab1-20261014
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=yyej2xlBADXECYdNP7xUgE69xFnPcTg7CV+ZJLWTNPs=;
	b=cURh56RX50xBQgIeETnKrxYqeLCihFKk5ppnIrLY2HLiSqf9BW63z11CDHBZn40KE3gOBn3IT1zKy3sNNlrc9EMI183xpAH/MvgiK2HfOG3WzCaFj7+qYq1w/nqtjf8HMALF6/w3Et+7XBLe7U2K0A1zRPx4EhLXdg/DBv0h8mw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:51dcb2c8-a6dd-4e17-8dc7-c663ec9263dc,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:22f35120-2f17-48f6-b8a0-2bb5971c52b4,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e83bd262c7a011f18dc8c9802ae25ab1-20261014
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 498926688; Wed, 14 Oct 2026 15:28:53 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Oct 2026 15:28:51 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Wed, 14 Oct 2026 15:28:51 +0800
Message-ID: <07b41e9e46d26b4a0e0683404e98cd29d38cced0.camel@mediatek.com>
Subject: Re: [PATCH 2/3] scsi: ufs: bsg: Clear the UIC result byte before
 sending UIC commands
From: Peter Wang <peter.wang@mediatek.com>
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K. Petersen"
	<mkp@kernel.org>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>
CC: <powenkao@google.com>, Alim Akhtar <alim.akhtar@samsung.com>, "Bart Van
 Assche" <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Date: Wed, 14 Oct 2026 15:28:51 +0800
In-Reply-To: <20261013102913.948718-3-stanleyjhu@google.com>
References: <20261013102913.948718-1-stanleyjhu@google.com>
	 <20261013102913.948718-3-stanleyjhu@google.com>
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

On Tue, 2026-10-13 at 18:29 +0800, Stanley Jhu wrote:
> ufs_bsg_request() passes the user-supplied UIC argument2 unchanged,
> including the result byte (bits 7:0) that only the host controller
> writes. A non-zero value triggers the WARN_ON_ONCE() in
> ufshcd_dispatch_uic_cmd() and corrupts the reported result. Found by
> syzkaller.
>=20
> Clear the result byte before sending the command.
>=20
> Fixes: e77044c5a842 ("scsi: ufs-bsg: Add support for uic commands in
> ufs_bsg_request()")
> Fixes: 9fb4c793223b ("scsi: ufs: core: Complain if UIC argument 2 is
> invalid")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
> ---


Reviewed-by: Peter Wang <peter.wang@mediatek.com>
