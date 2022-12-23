Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17481C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Dec 2022 07:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiLWHYF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Dec 2022 02:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiLWHYD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Dec 2022 02:24:03 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D612B64EB;
        Thu, 22 Dec 2022 23:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Wg2clfQRdnGAunAT7gUdQ67t9fBODx9mH3RwlxNN0Pc=; b=Us5RkFh7zLq7LO5b1uYP16sBpv
        CphDGhro+RFDRGgJ3Tl9lNiyROz8wF/3Nd8wECBZ2onImKyOwVEFXLrj4fkh1RiIGUhIMaJFkvkFR
        ugVEPD28pOYz1S6ucOgku0bYdZyHuy3fnD8gVwcvnmkvMcSXu15A2RC++c2zcyVDWQ7RUesaHwFS8
        dCoqKZ/xwo8xorbUBiHHWehfiqoy5+B+kgA6HtgQ364C0OVG1Xa9MCb/k74swl1vsxsQX6K758gPo
        aC15qAV2RDlY4cK311WBJYspwij/h3hSjtNEUVOBJ1wF0LqmIRROxqUgr1pApLAPUWE19XDu/ybh1
        lwNrUXNg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p8cPP-004kQ3-M4; Fri, 23 Dec 2022 07:23:59 +0000
Date:   Thu, 22 Dec 2022 23:23:59 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>
Subject: Re: blktests failures with v6.1
Message-ID: <Y6VXjztUUz7GFmAW@infradead.org>
References: <20221223045041.dl6ivxgo25eiwy33@shindev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221223045041.dl6ivxgo25eiwy33@shindev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Dec 23, 2022 at 04:50:42AM +0000, Shinichiro Kawasaki wrote:
>    The test case fails with NVME devices due to lockdep WARNING "possible
>    circular locking dependency detected". Reported in September [1] and solution
>    was discussed. A kernel fix patch was posted [2]. It may not be the best fix.
> 
>    [1] https://lore.kernel.org/linux-block/20220930001943.zdbvolc3gkekfmcv@shindev/
>    [2] https://lore.kernel.org/linux-nvme/20221012080318.705449-1-shinichiro.kawasaki@wdc.com/
> 
>    This test case shows different failure symptom with HDDs. Need further
>    investigation.

Yes.  Not a huge fan of the fix, but we need to look into this.
Sorry for delaying this so long, I'll try to look into this.

> #2: block/024
> 
>    Fails on slow machines. I suspect test case needs improvement.
>    Need further investigation.
> 
>    block/024 (do I/O faster than a jiffy and check iostats times) [failed]
>     runtime    ...  4.347s
>     --- tests/block/024.out     2022-12-06 20:51:41.525066605 +0900
>     +++ /home/shin/kts/kernel-test-suite/sets/blktests/log/runlog/nodev/block/024.out.bad       2022-12-07 12:51:03.610924521 +0900
>     @@ -6,5 +6,5 @@
>      read 1 s
>      write 1 s
>      read 2 s
>     -write 3 s
>     +write 4 s

Yes, I've been seeing this for a while as well.

> #3: nvme/002
> #4: nvme/016
> #5: nvme/017
> 
>    The test cases fail with similar messages below. Reported in June [3].
>    Fixes in the test cases are expected.

I think this is related to the current NQN that Hannes added.
Hannes, can you look into this?

