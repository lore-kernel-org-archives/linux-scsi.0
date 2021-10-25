Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B049EC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 05:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84CE160F22
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 05:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhJYFTd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Oct 2021 01:19:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20672 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbhJYFTc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Oct 2021 01:19:32 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211025051708epoutp0197c8158d74f6ddffa9f6a32c94837f56~xLkiRcwom0283502835epoutp01P
        for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2021 05:17:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211025051708epoutp0197c8158d74f6ddffa9f6a32c94837f56~xLkiRcwom0283502835epoutp01P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1635139028;
        bh=44TqgdLKr95Vg2MwjopWs0feFcpda2jeiVXHL7I9KAI=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=GqI+70/HXU7ZfJNEh1IJnOk7qayWUxQZfVQJVlmyykN0rEix+DuwCaWDm7wFdTsUN
         wg4VPJlScvQQalIkWBZ20DYQXAI57pRIKiqhD7FJFryE7dtdwemSLGLJFxnYWgpu7V
         1VFmyQcOpL0Uay6vDl51yyC3KvOxFzZCJ2oNbAfk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211025051708epcas2p1e941f7a72c1ef4cae7a38c7340dd1541~xLkhy2ISq3114531145epcas2p1H;
        Mon, 25 Oct 2021 05:17:08 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.99]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Hd3961DMZz4x9Pv; Mon, 25 Oct
        2021 05:16:58 +0000 (GMT)
X-AuditID: b6c32a46-a0fff70000002722-c8-61763dc7790b
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        CC.70.10018.7CD36716; Mon, 25 Oct 2021 14:16:55 +0900 (KST)
Mime-Version: 1.0
Subject: RE: please revert the UFS HPB support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <571fc7393fb043e3c34bca57402bd098a56ea8ac.camel@HansenPartnership.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20211025051654epcms2p36b259d237eb2b8b885210148118c5d3f@epcms2p3>
Date:   Mon, 25 Oct 2021 14:16:54 +0900
X-CMS-MailID: 20211025051654epcms2p36b259d237eb2b8b885210148118c5d3f
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmhe5x27JEg8Pv2C1W3+1ns5j24Sez
        xctDmharHoRbrFx9lMniyfpZzBYb+zks9t7Stui+voPNYvnxf0wOXB6Xr3h7TJt0is3j8tlS
        j02rOtk8dt9sYPP4+PQWi0ffllWMHp83yQVwRGXbZKQmpqQWKaTmJeenZOal2yp5B8c7x5ua
        GRjqGlpamCsp5CXmptoqufgE6Lpl5gCdp6RQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUot
        SMkpMC/QK07MLS7NS9fLSy2xMjQwMDIFKkzIztgz9zhzwWKJirYdn5gbGGcJdTFyckgImEjc
        eniYuYuRi0NIYAejxIWr+1i7GDk4eAUEJf7uEAapERbQk/jydA47iC0koCSx/uIsdpj4rYdr
        GEFsNgEdiekn7rODzBERWMwoMfX7OTCHWaCVSeJ3fwcrxDZeiRntT1kgbGmJ7cu3gnVzCgRL
        /Lu1kR0iriHxY1kvM4QtKnFz9Vt2GPv9sfmMELaIROu9s1A1ghIPfu6GiktKHNv9gQnCrpfY
        eucXI8gREgI9jBKHd96COkJf4lrHRrAjeAV8JU4svAC2gEVAVWLen1aooS4Ssy9uZQOxmQXk
        Jba/ncMMChVmAU2J9bv0QUwJAWWJI7dYYN5q2PibHZ3NLMAn0XH4L1x8x7wnUKepSaz7uZ5p
        AqPyLERQz0KyaxbCrgWMzKsYxVILinPTU4uNCozgsZucn7uJEZxUtdx2ME55+0HvECMTB+Mh
        RgkOZiURXptPJYlCvCmJlVWpRfnxRaU5qcWHGE2BvpzILCWanA9M63kl8YYmlgYmZmaG5kam
        BuZK4ryWotmJQgLpiSWp2ampBalFMH1MHJxSDUxXjf/JSNZsXK+yZN6/WOejZYViinsmMeRz
        /L/y3fBmnCvX34a3gW++e3wXTb0pHLqk67Sf6r0ZAgttpvT3yC2+Zzrlb1dXYbjruzLXtADN
        hvNvpm1sWpJz1Sdw1WyljDyvH5F2eglTKgLnVgsyuRceiryu3xmk31HW+aNsRTTnxOm7dzN9
        6Or6nxoo+Lhxd2/4put3glTMecx1mlaf5bSK8PX1eTLxZUHBN3ENgSR+DrGjCcpClXxF93bM
        iORxbtJpX65UJ538bUndWs2Ppk9W23AW3fwv7yt93PrttfyvSrVuy33uXvK27N65X/DMJe8+
        KTuNr3M+1T/M83hzd1/u9PymDPO/Oyqn/lSSUWIpzkg01GIuKk4EAEmpogAzBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211023154316epcas2p208f95cf1e4a87a4b61d2daf1a2b3c725
References: <571fc7393fb043e3c34bca57402bd098a56ea8ac.camel@HansenPartnership.com>
        <20211021144210.GA28195@lst.de>
        <84fac5a3-135a-2ac8-5929-a1031a311cb7@kernel.dk>
        <20211021151520.GA31407@lst.de> <20211021151728.GA31600@lst.de>
        <2cba13c3-bcd5-2a47-e4cb-54fa1ca088f3@acm.org>
        <CGME20211023154316epcas2p208f95cf1e4a87a4b61d2daf1a2b3c725@epcms2p3>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On Thu, 2021-10-21 at 09:22 -0700, Bart Van Assche wrote:
> > On 10/21/21 8:17 AM, Christoph Hellwig wrote:
> > > On Thu, Oct 21, 2021 at 05:15:20PM +0200, Christoph Hellwig wrote:
> > > > > > I just noticed the UFS HPB support landed in 5.15, and just
> > > > > > as before it is completely broken by allocating another
> > > > > > request on the same device and then reinserting it in the
> > > > > > queue.  It is bad enough that we have to live with
> > > > > > blk_insert_cloned_request for dm-mpath, but this is too big
> > > > > > of an API abuse to make it into a release.  We need to drop
> > > > > > this code ASAP, and I can prepare a patch for that.
> > > > > 
> > > > > That sounds awful, do you have a link to the offending
> > > > > commit(s)?
> > > > 
> > > > I'll need to look for it, busy in calls right now, but just grep
> > > > for blk_insert_cloned_request.
> > > 
> > > Might as well finish the git blame:
> > > 
> > > commit 41d8a9333cc96f5ad4dd7a52786585338257d9f1
> > > Author: Daejun Park <daejun7.park@samsung.com>
> > > Date:   Mon Jul 12 18:00:25 2021 +0900
> > > 
> > >      scsi: ufs: ufshpb: Add HPB 2.0 support
> > >          
> > >      Version 2.0 of HBP supports reads of varying sizes from 4KB to
> > > 1MB.
> > > 
> > >      A read operation <= 32KB is supported as single HPB read. A
> > > read between
> > >      36KB and 1MB is supported by a combination of write buffer
> > > command and HPB
> > >      read command to deliver more PPN. The write buffer commands
> > > may not be
> > >      issued immediately due to busy tags. To use HPB read more
> > > aggressively, the
> > >      driver can requeue the write buffer command. The requeue
> > > threshold is
> > >      implemented as timeout and can be modified with
> > > requeue_timeout_ms entry in
> > >      sysfs.
> > 
> > (+Daejun)
> > 
> > Daejun, can the HPB code be reworked such that it does not use 
> > blk_insert_cloned_request()? I'm concerned that if the HPB code is
> > not reworked that it will be removed from the upstream kernel.
>  
> Just to give urgency to Bart's request: we have two or three weeks
> before the kernel is due to go final.  Can the problems identified by
> Christoph be fixed within that timeframe?

I'm checking to see if I can replace blk_execute_rq_nowait with
blk_insert_cloned_request in the HPB code.

>  
> Specifically, looking at the paper you reference, it only uses READ
> BUFFER for the host cache sharing.  Since the JDEC standard appears to
> be proprietary, I have no method of understanding why the driver now
> uses WRITE BUFFER as well, but it appears to be a simple optimization. 
> If you can cut out the WRITE BUFFER code, blk_insert_cloned_request()
> will also be gone and thus the API abuse.  Can you get us a simple
> patch doing this ASAP so we don't have to revert the driver?

If WRITE BUFFER is not used, only READs with a size of 32KB or less can be
changed to HPB READs. This becomes a limiting factor in how READ
performance can be improved by the HPB.

Thanks,
Daejun
