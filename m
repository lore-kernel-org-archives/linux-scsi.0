Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A70CAC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Mar 2022 16:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239591AbiCWQue (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Mar 2022 12:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245626AbiCWQu1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2022 12:50:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD9EDFAF;
        Wed, 23 Mar 2022 09:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=W+s1QtlhSjsq/MYdWCk5+G4u/fvPQ1sjexrZPDlle7U=; b=NVmfU9gN6D2xiHnQorCyLErlMs
        U75m/ZIPXG+GbT5eleEf1PGKH8jyEgCt7hHt6Kj6DDP5mPL4JdRCHzDp4q3WnPUE42lRQwx8wUve8
        Nc1cqhvX2QMSUAStiGtWIwtscERy7uYA3aWpSMUPG5u2JU6+XIwI9Cn4XMdYRuAcfPRwmHpsNedJj
        curK+g8VFcoyQi9NnGPBVLuVswoA2p83HqPwDxz7drPWsJb0V0h+YpD1dOS/Avce/hdHq4Nd4EmBb
        xIFn2kIMDbXUs5oJLcv75XN0lGed7jWLzH4dACczYTEXegoxA7br19xj1b2W+1INkSWlTlK5VpOgt
        1pUlS8hQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nX4A5-00EIc6-EX; Wed, 23 Mar 2022 16:48:41 +0000
Date:   Wed, 23 Mar 2022 09:48:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        linux-mm@kvack.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        xuyu@linux.alibaba.com, bostroesser@gmail.com
Subject: Re: [RFC 2/3] mm: export zap_page_range()
Message-ID: <YjtPabOWZrbpSZV2@infradead.org>
References: <20220318095531.15479-1-xiaoguang.wang@linux.alibaba.com>
 <20220318095531.15479-3-xiaoguang.wang@linux.alibaba.com>
 <a37e9ba2-354b-0b75-cb05-bc730cb30151@redhat.com>
 <37d6b269-dd9d-dbd1-74b1-4191cc3d4bf9@linux.alibaba.com>
 <019a2159-57d6-c330-53c5-38458b6b5ec9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <019a2159-57d6-c330-53c5-38458b6b5ec9@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 22, 2022 at 02:08:13PM +0100, David Hildenbrand wrote:
> Reason is that we don't want anybody to blindly zap_page_range() within
> random VMAs from a kernel module.

Not just that, but there is no business for modules doing this at all.
These kinds of VM hooks for random drivers are not a good idea.
