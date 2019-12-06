Return-Path: <SRS0=vR/u=Z4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36410C43603
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Dec 2019 08:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0573724677
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Dec 2019 08:35:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vCkW4+rw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfLFIfj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Dec 2019 03:35:39 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53906 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfLFIfj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Dec 2019 03:35:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UV9q3o7jAvEZwvvbVSHDzMwRL8D4dgdMETxRcUUBx3A=; b=vCkW4+rwW3x3/tPWqTK+TBxAv
        IJizviNkGbYhLxrDY1gXfQH/lWAYJuc4jJ7pOJGNYvacY+ptkIr+xYQph4zh7i/nuQ+n5+p7sPjMl
        hA8V/8eLkJ7pYeqidwfSGpkgwNiypUMFnOHcISYcqkWMzcpHvfGSOURLQ0DevI4hUWJXcxx19vyPV
        Ud01AdChoYN5xkw+rW6E+0PFbxip++fyek69UhQMyhGf3t97BJEWBidhggQ/m0vFwDEaWN36/mGpV
        Jdbsr5GByI9Cw02a08qD1knSOeWcKzCjcEWxQEgUSHWRry5bSSiX55betbCtoyqyBqxP/ufjB4LAp
        MLUcy/BkA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1id95M-00076u-VM; Fri, 06 Dec 2019 08:35:36 +0000
Date:   Fri, 6 Dec 2019 00:35:36 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: Export query request interfaces
Message-ID: <20191206083536.GA15390@infradead.org>
References: <0101016ed90ccaa9-28e4056b-b182-4739-80e0-c9f1dff0f257-000000@us-west-2.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0101016ed90ccaa9-28e4056b-b182-4739-80e0-c9f1dff0f257-000000@us-west-2.amazonses.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Dec 06, 2019 at 02:32:04AM +0000, Can Guo wrote:
> Vendor drivers may need to send query requests in proprietary
> implementations. Hence, export the query request interfaces
> so that vendor drivers can use them.

Vendor driver ain't matter.  If you submit your driver to mainline
and can prove a need you can add a patch to export interface to the
series adding the driver.
