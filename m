Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F67380FC1
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 08:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791274508; cv=none; b=ju0uzt35hui1CFBbh3S+YDhnn5359KtEA6cfV7vYHCiU8rr7Qjv6ArvkiRe3i0GbZmzFu1zgB+qnLfgxoaEjx4OdD4vtRM8ThurxcrhYsYou+G5yKu2VwRgFPPNuGw/rBGETi/TI0O4lbzWnEOqiwKzZ8mftcFsRZljb058hyZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791274508; c=relaxed/simple;
	bh=8NrzkBe6sqvhfd9Mx3JXlRNrAO1yoEalp0MCIoNGIZU=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=ZNWey+Jz/HBz9HFVLwZrM01IvH+/GicutiBOKjrMuVOQzs/PASfZAVpcz7ozrPJMW70J+eUPA2KJt1CwCI04I+a15g/YPa+fqlIONdppvL6BFKwJRuAb+KL9TQUgxtFyhRBeLpVM9fEg1dZm/9dFB3NiEkGFPJEtH+k7t4QxGOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Eub3SbtH; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Eub3SbtH"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261006081503epoutp0365de001883ab36303d6f3580e90ef852~b4qufVSqS2611626116epoutp03E
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 08:15:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261006081503epoutp0365de001883ab36303d6f3580e90ef852~b4qufVSqS2611626116epoutp03E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791274503;
	bh=8NrzkBe6sqvhfd9Mx3JXlRNrAO1yoEalp0MCIoNGIZU=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=Eub3SbtH7DGuDR/EkVV9Crt4aUYGVyl89TJSIzpwgKQ+BUxGkR0r0F+bwlkpNlIyQ
	 Z/s0xHWVO/QpLA8Dpy5+DJinrU5nntD6PSfYLzJE0LHV4nu0PX26DCCWh6+ByMRtvG
	 d/y4GY+eqG4VG2rGpVSs5AvjMulkQIY4/QKqlKUQ=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261006081503epcas2p3201f08debd4f5dadeb92105a16bcab7b~b4quA2Hgu2397323973epcas2p39;
	Tue,  6 Oct 2026 08:15:03 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4hzTZb01Ljz3hhTL; Tue,  6 Oct
	2026 08:15:03 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH v2 0/2] scsi: ufs: batch device-init reads with UFS 5.0
 aggregated read
Reply-To: hyenc.jeong@samsung.com
Sender: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
From: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
To: Bean Huo <beanhuo@iokpp.de>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mkp@kernel.org" <mkp@kernel.org>,
	"avri.altman@sandisk.com" <avri.altman@sandisk.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: Jinyoung Choi <j-young.choi@samsung.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <8ab9b08e12bf60e89a60a86137a23e9164e43839.camel@iokpp.de>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <973576304.21791274502988.JavaMail.epsvc@epcpadp1new>
Date: Tue, 06 Oct 2026 16:17:53 +0900
X-CMS-MailID: 20261006071753epcms2p8553acc780be5126e830594fb1af5de4b
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260930050201epcms2p13ab67182445b0555acc8d27b927cda86
References: <8ab9b08e12bf60e89a60a86137a23e9164e43839.camel@iokpp.de>
	<1860250540.01790747102385.JavaMail.epsvc@epcpadp1new>
	<CGME20260930050201epcms2p13ab67182445b0555acc8d27b927cda86@epcms2p8>

Hi Bean,

On Fri, 2 Oct 2026 11:24:15 +0200, Bean Huo wrote:
> On Wed, 2026-09-30 at 14:02 +0900, Hyeoncheol Jeong wrote:
> > Motivation: on a Qualcomm SM8850 platform with a Samsung UFS 5.0 device,
> > timing raw UPIU queries over BSG (100 iterations) shows that replacing the
> > device-init read burst with a single aggregated read reduces the query
> > time by 75-78% (min 75.3%, avg 76.4%, max 78.5%).
>
> I don't know if you have plan to enable this feature in UEFI or any bootloaders
> to eliminate the boot overhead becaused of query iterations.

For now, my focus is on the kernel side. I do plan to bring the same
approach to bootloaders such as EDK II as a follow-up.

Thanks,
Hyeoncheol

