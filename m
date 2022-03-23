Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AEEBC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Mar 2022 16:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245527AbiCWQtS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Mar 2022 12:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240683AbiCWQtR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2022 12:49:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3301BE24;
        Wed, 23 Mar 2022 09:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bA8MZzQPjp8dAVh8AH3lrO5YO+7426Hn3PdSAQ7U40A=; b=hv6bkUf5iVKGgR4kAPXgXdFnv7
        QwkhGHw+PJutk3Jt9uhWizvVG75GGC6S9LzhGI/b9Zf9trDH7eMUQ9cLvHGYymr9DcQ1q5YKZPFUw
        34ew4O33R/aMiQPgY9okOvde7JaqNBnCothH4Qn87/kYjw/QP7DzCegU+GcuCwYJW37NvGpiagi1k
        vGmAw1aqx3g20BbxNMHcUTVgrnmZxKbb8o6NijjSeteOjZTMf+NNrrXajDinOMHvbA99LFa+MRfTf
        GSt5dveaGj7OzCtk5ER62qGHx34tOI7kzs+Pay2HR5W14c2RUXGGRgGd7aZ+gaGQPugNGhY3Yb2ok
        2HMjMuvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nX49B-00EIQA-A9; Wed, 23 Mar 2022 16:47:45 +0000
Date:   Wed, 23 Mar 2022 09:47:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     linux-mm@kvack.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        xuyu@linux.alibaba.com, bostroesser@gmail.com
Subject: Re: [RFC 2/3] mm: export zap_page_range()
Message-ID: <YjtPMRpUtgzXhllw@infradead.org>
References: <20220318095531.15479-1-xiaoguang.wang@linux.alibaba.com>
 <20220318095531.15479-3-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318095531.15479-3-xiaoguang.wang@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 18, 2022 at 05:55:30PM +0800, Xiaoguang Wang wrote:
> Module target_core_user will use it to implement zero copy feature.

NAK, this has no business being exported to modules.
