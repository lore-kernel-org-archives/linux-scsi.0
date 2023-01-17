Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A82BC63797
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 07:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235637AbjAQHYh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 02:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235491AbjAQHYf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 02:24:35 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCCE22A38;
        Mon, 16 Jan 2023 23:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Tct5vcPxOWy0iZ2lmh79dh3X6Nr5bJxjpAG0TMhawew=; b=u6Gz7uYenAzIxcTkBKLwNjHu8+
        GLwQ/8NSMnExc450r6r0weot6kka2dRDvR0juXbBjO5MvGfQ4GvFozi9nO3Z8nQGx3D9veuDa8twZ
        rrToBiEYmeq930JA+LbJu+S7JNBdtU5gw2DC7oIjGs0llEB2cBVHEFzG3eG3tgU+jKgBJRfiGrbzC
        XxWgaCl0bhrkXZchmg7MUXKddYX4/qbR2UOvg1gN7d7kBkTmbhTc0eeGONhQRA8K9NG2cj150PnCV
        IDwKnzHp2K6rgf1dp9JYQN4xK1+f6u5aPG9yR0g4OwERWostmFqn4jISIeWYrsWYtvSprcJ0xkuGd
        baglxb4g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pHgKc-00D9az-3u; Tue, 17 Jan 2023 07:24:30 +0000
Date:   Mon, 16 Jan 2023 23:24:30 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Niklas Cassel <niklas.cassel@wdc.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH v2 03/18] scsi: core: allow libata to complete successful
 commands via EH
Message-ID: <Y8ZNLpDEMx2AHioW@infradead.org>
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
 <20230112140412.667308-4-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112140412.667308-4-niklas.cassel@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I'd rename the flag to something like SCMD_FORCE_EH_SUCCESS,
but otherwise this looks good.
