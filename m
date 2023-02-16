Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD02C636CC
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Feb 2023 06:01:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjBPGBx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Feb 2023 01:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjBPGBw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2023 01:01:52 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D77305D3;
        Wed, 15 Feb 2023 22:01:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AUbmeBdem5l2PPe71lC2Hwpp8TmcrkF3Fg+VJod4r80=; b=RthiQ5+YANkz57EZlEYZCldRMC
        gfF5M8FOBgKY5eGkqi/aKvgPYinGSY8W4fRwqxbrL1pven6nZsYO+15XcuQR5gXioG6nlSpwZawO0
        I1uuKpGV/jvP/PfN1XzA9zQkY7BMndoM/OLRQ5iyFjQMwHFynOWkCGX2Vpxj9AyvC699bjVyL9Ip4
        FC2n/C0Pm3bgOV69HOhzY13hWI+q7/Ogjl2yhEldwJ5VBHJAHraLRqeAqWcrc3OO+04Y1fZTilXNi
        LegpxpuW9h/+yM4Wqr6oLvGzzVeU51pZvth9ByRLfyrXzFZPx54JsdGTufCrkZVbzSCb0KLNHDfth
        tpyLRbZg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pSXL3-008djb-CO; Thu, 16 Feb 2023 06:01:49 +0000
Date:   Wed, 15 Feb 2023 22:01:49 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>, Jaegeuk Kim <jaegeuk@google.com>
Subject: Re: [PATCH] scsi: ufs: support IO traces for zoned block device
Message-ID: <Y+3GzX6yMOKUFTh3@infradead.org>
References: <20230215190448.1687786-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215190448.1687786-1-jaegeuk@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Why does UFS even have it's own common tracing instad of just relying
on the core SCSI one, and even worse pokes into command set specifics
which is a no-go for LLDDs.  This code simply needs to go away instead
of beeing "enhanced".
