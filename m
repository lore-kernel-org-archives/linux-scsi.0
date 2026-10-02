Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890A635E1B8
	for <linux-scsi@vger.kernel.org>; Fri,  2 Oct 2026 05:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790917901; cv=none; b=nOaeO4VpuxAZropxM2AGww1Z4xXIr4bb9IW5BwDxme+qIv8mQhnL63fPDSGIh6erDvL37X1G/FzYxircgY/9d7oiduU2Dm5ZaRTU3rlvjDvr7ZhEfscHkO++dW76tNoCtSRVmAkEks28sPx/VkVcTcCEC4kJGEGCgFpFNzGSzTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790917901; c=relaxed/simple;
	bh=r0Jo6QxW17BfK+zNKleekUYMOfmiHLUBxjIyfWOvcq4=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=QoQiUzl4Ngzh/vNwUY9IoJC6IwReczazpkvMZDjFumiIXwhRVDEWUAk6OprGfHA+dcd0OCoa7k+Jk3KNknD4975Q8jCC1imjzg2DThb0miRntBRgJ2RCUCXwG4xai8NZ5kTGmWoAJRLMtLUPrPJrXrmRxxUGZEMyeT1LFSJAbHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=FgWkmY+Y; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FgWkmY+Y"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261002051136epoutp0249d1b8964dc0aa26b7899a75341fb1f1~anlZ_mZqA2319223192epoutp02i
	for <linux-scsi@vger.kernel.org>; Fri,  2 Oct 2026 05:11:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261002051136epoutp0249d1b8964dc0aa26b7899a75341fb1f1~anlZ_mZqA2319223192epoutp02i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1790917896;
	bh=bvbUGswlHCKvnI1JWx+YgFfywrBPmWQsfqZLuDlxAgQ=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=FgWkmY+Yr8YrAPBmplkQTElWPqP6Tfh9yCFlK+fbDkMoD5+1MORxVr/kKeYsr61go
	 2MhllI8lKoXkF2Y9z5lJC70yEWXdkJF4gJygTiim8QxFVeXb3e3W5RDjA6Szd7DPiM
	 YmHAItKRUtO6SX2Ijtpow2oHBdc3uZ76P3nSMa7U=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261002051135epcas2p36c46cd96cdb622eb7495c8c8d549d2ac~anlZuZcZk2239822398epcas2p3T;
	Fri,  2 Oct 2026 05:11:35 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.210]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4hwxhl43D0z2SSKX; Fri,  2 Oct
	2026 05:11:35 +0000 (GMT)
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
To: Stanley Jhu <stanleyjhu@google.com>
CC: "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jinyoung Choi
	<j-young.choi@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20261001055307.4097978-1-stanleyjhu@google.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261002051135epcms2p5f0d9ca64f9e25bcf8adb971a81bc710a@epcms2p5>
Date: Fri, 02 Oct 2026 14:11:35 +0900
X-CMS-MailID: 20261002051135epcms2p5f0d9ca64f9e25bcf8adb971a81bc710a
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261001055313epcas2p2be6d82b4c3ffc401876fb1477755651e
References: <20261001055307.4097978-1-stanleyjhu@google.com>
	<1860250540.01790747102385.JavaMail.epsvc@epcpadp1new>
	<1653986196.21790747102619.JavaMail.epsvc@epcpadp1new>
	<CGME20261001055313epcas2p2be6d82b4c3ffc401876fb1477755651e@epcms2p5>

Hi Stanley,

Thank you for taking the time to review this so carefully.

On Thu, 1 Oct 2026 13:53:07 +0800, Stanley Jhu wrote:
> On Wed, 30 Sep 2026 14:18:25 +0900, Hyeoncheol Jeong wrote:
> > +    for (i = 0; i < idn; i++)
> > +        off += ufs_agg_attr_width[i];
>
> This assumes the Attributes group (Group Type 02h) is serialized by
> ascending IDN at fixed offsets. JESD220H Section 10.7.9.14 and
> Table 10.56 define only the group header and Next Group Offset chain;
> the intra-group layout and ordering are not specified.

You are right. The layout of entries within the Attributes and Flags
groups is not defined in JESD220H.

> > +    if (index == 0 && !ufshcd_agg_attr(hba, idn, out))
> > +        return 0;
>
> The commit message states that bWriteBoosterBufferLifeTimeEst is
> served from the packet only in shared-buffer mode. In LU-dedicated
> mode (bWriteBoosterBufferType != 01h, Table 14.28 NOTE 15) with
> wb_dedicated_lu == 0, ufshcd_wb_get_query_index() also returns 0, so
> this check serves LU 0's lifetime from a packet with no LUN qualifier.

Thank you for catching this. Checking index == 0 does not limit this
to the shared-buffer mode. This code will be dropped with patch 2.

> > +    if (!group_buf || idn >= group_len)
> > +        return -ENOENT;
> > +
> > +    *out = group_buf[idn];
>
> The Flags group (Group Type 01h) has the same issue: Table 14.26
> NOTE 1 distinguishes device-level flags from array flags addressed by
> INDEX and SELECTOR, and the specification defines no 1-byte-per-IDN
> packed layout.

I agree that the same concern applies to the Flags group.

I think using these groups needs to wait until the JEDEC specification
clarifies the format. In the next version, I will keep only the
interface introduced by patch 1 and drop the users in patch 2.
The parts the specification leaves undefined will follow once
it is clarified.

Thanks,
Hyeoncheol
