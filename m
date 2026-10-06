Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C282367B8
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 08:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791274508; cv=none; b=cPlkAM0+g6rCniWHXOyjTjyRkHMgygSgQ4VU3xU/ij6YXw+bif5kJW6ekMjgv85s+51j9E2ZEWlGk0um9gD1h/c/KUA27LwzUbW5XZnKcCreCguam1gY/aSV4yWp3Q5sFEdq+hW2fMIu1E0K5UjRjpG4nXEHgIUM6uId/dO2y3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791274508; c=relaxed/simple;
	bh=Htl0ci1tWgMj/biqGASwWms3pXUWKl2FImc1Oh93v4M=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=r87agPHZXAWfARa+J4bwvShVorzrUJe/AHfxihL9O1NK0qz86LEKVRxZD1MsuGDKGlchmCdrqLW2vjC+zAS/M+P9KITAL0gJx+33652Qx6ppm9ZeWffLrY0D7E0eFEueZw/p88VTsak55sOgbtvaTK9vTokIv5hME73KulLWkOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=na6I7rjI; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="na6I7rjI"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261006081503epoutp040f9e9547733c99db2c706676d3d07b34~b4quv8w972166221662epoutp04T
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 08:15:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261006081503epoutp040f9e9547733c99db2c706676d3d07b34~b4quv8w972166221662epoutp04T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791274503;
	bh=u5hrVf50ARWV2F+q0jWLTvUB8p3+4UzRCpVj1h6GS8s=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=na6I7rjIqF2X0DTmdqFgfRR8tYVp0mesRfQn2k6g/6f/X2x4AWBmw3OVrFZ/8YAD3
	 ctrpGWq7FcO+nSm1a+nALqnNSndh2Fza+yMvMj0sgZ5r8z4J5rtStGSt1aU7sXVf07
	 BwISQ9g2Vz0m9pyg8CHkTLvobjw4ZXdNnW5HlUHk=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20261006081503epcas2p47640f5ceafd292066798d6306ff97c2f~b4quXZ1hg0322703227epcas2p4F;
	Tue,  6 Oct 2026 08:15:03 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4hzTZb2kfMz2SSKm; Tue,  6 Oct
	2026 08:15:03 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH v2 2/2] scsi: ufs: Serve the device init reads from one
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
In-Reply-To: <5339f61b72b28af335b4761acd2f0f05744501de.camel@iokpp.de>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1582071873.61791274503378.JavaMail.epsvc@epcpadp1new>
Date: Tue, 06 Oct 2026 17:01:47 +0900
X-CMS-MailID: 20261006080147epcms2p6699646c32fc450655c747f2f558a86a7
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260930050201epcms2p13ab67182445b0555acc8d27b927cda86
References: <5339f61b72b28af335b4761acd2f0f05744501de.camel@iokpp.de>
	<20260930050201epcms2p13ab67182445b0555acc8d27b927cda86@epcms2p1>
	<1653986196.21790747102619.JavaMail.epsvc@epcpadp1new>
	<CGME20260930050201epcms2p13ab67182445b0555acc8d27b927cda86@epcms2p6>

Hi Bean,

Thank you for the detailed review.

On Fri, 02 Oct 2026 17:50:19 +0200, Bean Huo wrote:
> On Wed, 2026-09-30 at 14:18 +0900, Hyeoncheol Jeong wrote:
> > (bWriteBoosterBufferLifeTimeEst is served from the packet only in the
> > shared-buffer mode)
>
> I suggest we should aggregate-read as many of them as possible. If we lose even
> one descriptor, this feature becomes useless.

You are right. As this is the first step, I took a conservative approach
and left out the reads that are issued asynchronously, such as the power
and unit descriptors. I agree that covering as many of the init reads as
possible is what makes this worthwhile.

> table 14.28 gives the size of each attribute, but I could not find where Spec
> defines the layout of the attributes group in the aggregated data packet,
> section 10.7.9.14 only defines the group header.
>
> dDynCapNeeded (09h) is an array attribute; its number of indexes is MaxNumberLU.
> 1Ch-1Fh can also be per-LU in dedicated WB mode. If a device sends one entry per
> index, or keeps a slot for 01h or 11h-13h, every offset after it moves. Then
> bMaxNumOfRTT, bRefClkGatingWaitTime and bWriteBoosterBufferLifeTimeEst are read
> from the wrong bytes, with no error and no fallback to a single query.
> ufshcd_set_rtt() then writes a value based on that wrong data.
>
> Has this been tested on more than one vendor's UFS 5.0 device?

You are right, and thank you for the examples. It has been tested
only on a Samsung UFS 5.0 device.

I think this layout needs to be specified in more detail in the
specification. Once it is, I plan to rework the patch and submit it
again.

> if the reply is cut short (the device may return less than requested), a group
> that is complete but its next offset points past the end is rejected before its
> type is checked.

I will fix this when I rework the patch.

> > +       if (hba->dev_info.wspecversion < 0x500 ||
> > +           hba->dev_info.agg_read_unsupported)
> > +               return;
>
> is this feature mandatory? or you assume this feature should be supported by
> defualt?

JESD220H lists AGGREGATED READ in Table 10.32 without marking it
optional, and I could not find a capability bit for it. The patch
therefore assumes a UFS 5.0 device supports it, but falls back to
individual queries if the device rejects it.

> If the device rejects the opcode with a query response error, is there a reason
> to retry? Retrying makes sense for a transient error, but not for "invalid
> opcode"

Agreed. A query response error should not be retried.

As I replied to Stanley, I think consuming these groups should wait
until the JEDEC specification clarifies the intra-group format. In the
next version I will keep only the interface from patch 1 and drop the
users in patch 2, and I will address the points above when they come
back.

Thanks,
Hyeoncheol

