Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D905C433F7
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 14:42:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5241220714
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 14:42:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dEXoxPUd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbgG0OmS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 10:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733131AbgG0OmQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 10:42:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B236C061794
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2020 07:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/Gfn9oRrSDuMojNIgYXtbopxuSKzqPdHmPavNt1mDa8=; b=dEXoxPUdijbfGhMXlXMEobBcrR
        K7mGxqX4P35J7IYy12gWnCErB36iwjNxgXsFD5V6gbMVPEFyImQopMvvB3rlPH9m7wW80iFOq78jn
        ssEEngPPF5aPn729RccjOarU3BpNgZAOkPhbIqT9hGpZvZmcRQq59BoZUqXa+PisBNpuvbGaM+WGR
        cLpEplBDuRRWS3WR+grpqbS5y+aGRRs2QXWFL9DsshLkjI2fIn8p7IDP/xTLgrSM8kFD79ERhQtE7
        byAGtKgdu/+C91QB+z+JPurq0NWWkk35EMHQ/AdmOs3xMhn5rh8Ychuyxb/F9TgBt8uss9JAWHGUX
        OKdg80jw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k04KP-0006rX-Uy; Mon, 27 Jul 2020 14:42:10 +0000
Date:   Mon, 27 Jul 2020 15:42:09 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     SEO HOYOUNG <hy50.seo@samsung.com>
Cc:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, junwoo80.lee@samsung.com
Subject: Re: [RFC PATCH v4 2/2] scsi: ufs: add vendor specific write booster
Message-ID: <20200727144209.GA24271@infradead.org>
References: <cover.1595850338.git.hy50.seo@samsung.com>
 <CGME20200727121708epcas2p17a1fc75b9737ee32d1de64f2fdfcdf9b@epcas2p1.samsung.com>
 <8fd7173a76d3508a9470fa49c736a3326bbe59fd.1595850338.git.hy50.seo@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fd7173a76d3508a9470fa49c736a3326bbe59fd.1595850338.git.hy50.seo@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 27, 2020 at 09:17:24PM +0900, SEO HOYOUNG wrote:
> To support the fuction of writebooster by vendor.
> The WB behavior that the vendor wants is slightly different.
> But we have to support it

And why would we give a f*%k what the so called vendor (of what
anyway) wants?  Either the policy makes sense and we should adopt it,
or it depends on device parameters and we need to take them into
account.

But these stupid overrides don't make any sense at all.  Even less than
all the other ufs crap.
