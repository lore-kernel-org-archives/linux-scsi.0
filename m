Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E7EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Mar 2022 16:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237570AbiCWQrS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Mar 2022 12:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245542AbiCWQrE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2022 12:47:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747DB5FF29;
        Wed, 23 Mar 2022 09:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=O6SFKONUTvLIQdQzfaDKFf4xslPRUYzgRdkwBAJy9AU=; b=F4bY1Ko8RtdLoTqRAtzKuUTF04
        J4sfCqUaTCB7QFLrhyYUi+pV3sT6yV2XcC5i/mNuLOwkC4NVgmaoLyMcPUM4r7IEKCSqzjJNm5Aw3
        u//0QeuZ+BGuAeSupgDQqjpHLdXUeRrwv9F2kltz0ql8mkB/mGE0PIstMn9r16vkswUHcIWHNUVvH
        n8tsBPOhe3SMRp/xEv4JhF5F5o9Yr5dBpBe7/cnTe6W5G0Bq8PXPga5CTE7syNTrLyk/J8GSAvGWA
        tt8ulAOL6+KZX3F1NnP9TpqbUe+Ibqk/7l/536dwpW4/1FnzY3TlRWjh1016z4o517klXtc0e2ObQ
        oqJTMGqQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nX46v-00EHrK-6J; Wed, 23 Mar 2022 16:45:25 +0000
Date:   Wed, 23 Mar 2022 09:45:25 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     linux-mm@kvack.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        xuyu@linux.alibaba.com, bostroesser@gmail.com
Subject: Re: [RFC 1/3] mm/memory.c: introduce vm_insert_page(s)_mkspecial
Message-ID: <YjtOpf1bf0qH87HD@infradead.org>
References: <20220318095531.15479-1-xiaoguang.wang@linux.alibaba.com>
 <20220318095531.15479-2-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318095531.15479-2-xiaoguang.wang@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I relaly don't think we should add this amount of overhead to the
core VM for a (relatively) irrelevant driver.
