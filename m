Return-Path: <SRS0=ejtk=BS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06DE9C433DF
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Aug 2020 11:16:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D030F2087C
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Aug 2020 11:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596885404;
	bh=xOlA13J14llRjE2N0TZcpR4oOV9jqr6drXMl5woOIIs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=GQ6mlpoLFen0/CNcZdwqY3q8y2HVmmqvM1XnWnsz5mMnuiQ/xOseOnKJccvkYYdO1
	 Ufe6HgM8AtjTP9t7IylUTuWECEaiB+unJXR83bPDlhC0EWPFg5+Q1nHkbmxPy1s0RZ
	 mFR9hg/C3vEgpBs8B/Zf7j5VCN9PocJ99tXef2Xk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgHHLQo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Aug 2020 07:16:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbgHHLQn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 8 Aug 2020 07:16:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C302F20855;
        Sat,  8 Aug 2020 11:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596885402;
        bh=xOlA13J14llRjE2N0TZcpR4oOV9jqr6drXMl5woOIIs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qKAY3sohXKMOCc1Es3YSCdX9OKFG9Wa/G4b6cod6JY1cnecnuVuMDTxexVGGhEThv
         hsr2aDODcNMqKItECLXr7tQz9Ls9FdiGJ4b8qlGCj4zlQk8BBcUd4/Wj9VGrBKPQ9M
         GmkMg3DVsQK+tN8S0KkVH6Trh4Q8oN21RIJdnsh4=
Date:   Sat, 8 Aug 2020 13:16:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     hy50.seo@samsung.com, asutoshd@codeaurora.org, bvanassche@acm.org,
        alim.akhtar@samsung.com, grant.jung@samsung.com,
        linux-scsi@vger.kernel.org, sc.suh@samsung.com, beanhuo@micron.com,
        jejb@linux.ibm.com, sh425.lee@samsung.com, avri.altman@wdc.com,
        Kiwoong Kim <kwmad.kim@samsung.com>, cang@codeaurora.org
Subject: Re: [PATCH v6 0/3] ufs: exynos: introduce the way to get cmd info
Message-ID: <20200808111655.GA3063514@kroah.com>
References: <CGME20200715074757epcas2p344b4e188af3221655c1697405b9e17f4@epcas2p3.samsung.com>
 <cover.1594798514.git.kwmad.kim@samsung.com>
 <159530290480.22526.15318134249960762889.b4-ty@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159530290480.22526.15318134249960762889.b4-ty@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 20, 2020 at 11:42:07PM -0400, Martin K. Petersen wrote:
> On Wed, 15 Jul 2020 16:39:54 +0900, Kiwoong Kim wrote:
> 
> > v5 -> v6
> > replace put_aligned with get_unaligned_be32 to set lba and sct
> > fix null pointer access symptom
> > 
> > v4 -> v5
> > Rebased on Stanley's patch (scsi: ufs: Fix and simplify ..
> > Change cmd history print order
> > rename config to SCSI_UFS_EXYNOS_DBG
> > feature functions in ufs-exynos-dbg.c by SCSI_UFS_EXYNOS_DBG
> > 
> > [...]
> 
> Applied to 5.9/scsi-queue, thanks!
> 
> [1/3] scsi: ufs: Introduce callback to capture command completion information
>       https://git.kernel.org/mkp/scsi/c/679d4ca6c93f
> [2/3] scsi: ufs: exynos: Introduce command history
>       https://git.kernel.org/mkp/scsi/c/c3b5e96ef515
> [3/3] scsi: ufs: exynos: Implement dbg_register_dump
>       https://git.kernel.org/mkp/scsi/c/957ee40d413b

These links no longer work, did the patches get dropped from your tree
or rebased or something else?

thanks,

greg k-h
