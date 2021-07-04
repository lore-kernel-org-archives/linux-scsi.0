Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B515FC07E95
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Jul 2021 08:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 899B66145D
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Jul 2021 08:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbhGDIsa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 4 Jul 2021 04:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhGDIsa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jul 2021 04:48:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C252C061762
        for <linux-scsi@vger.kernel.org>; Sun,  4 Jul 2021 01:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7PP6p0F8q9jYwNxRZoT6R7IPAy+bbP8SEbqlPdThlCk=; b=dAn3teqSnfZcXKgHx5k9e8ZMFS
        KoJG6pjSt0x7HK/Oly0pvwvySdJ1rOkDkEA/WcjzTEgtHDfztPy2n1pnkMQ3cabVJl/Mrcdk8E41R
        VTsciOJ3EKBVYlc0Omj10ZpuKcJlM35676fQe16SJDc78YHQqWobyDuDnTCsgYTrgOHA1fyidouRg
        QVC32ihFJv8XKdPCzjnpCnAqyx5sATKeOLhTz50ewq8u7K9lXvdjjUOrk71KndX3vrUFajhOCzzck
        Z9fY45rAovyYF1cdDApB/P397lzqdaRTPnTQjrPJVdP5OGjot6ucV0koUrAM+cTcshV5M4nUpmVPC
        qvCByW9Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzxkS-009B6f-Gh; Sun, 04 Jul 2021 08:45:23 +0000
Date:   Sun, 4 Jul 2021 09:45:08 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, torvalds@linux-foundation.org,
        muneendra.kumar@broadcom.com
Subject: Re: [PATCH] scsi: blkcg: Fix application ID config options
Message-ID: <YOF1FBdMd65S6L57@infradead.org>
References: <20210703155833.3267-1-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210703155833.3267-1-martin.petersen@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Jul 03, 2021 at 11:58:33AM -0400, Martin K. Petersen wrote:
> -	depends on BLK_CGROUP=y
> +	depends on BLK_CGROUP=y && NVME_FC

BLK_CGROUP is a bool, so I think this can simply be:

	depends on BLK_CGROUP && NVME_FC

Otherwise this looks much better:

Reviewed-by: Christoph Hellwig <hch@lst.de>
