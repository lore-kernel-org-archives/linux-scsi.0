Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B55C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Oct 2022 07:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiJQHmU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Oct 2022 03:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJQHmT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2022 03:42:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567491DF21;
        Mon, 17 Oct 2022 00:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mtIbN1V65bhzv1gpdXAK02P2qioQeqGd9pNhnWCpaRQ=; b=koMm7eX5vkS3e2d/d8iSeoGjeP
        kHFzb8VCCQNprtIcP/VlCpz0SV/YoiZkG2JxuNLru5Egs58Lz9dsmdShymUMFMcFgFJU0WOzj3Auf
        1V51iUGRWTMyZfgFK4XcEGYBups6FLVYGjnG1vFtX8jowxnJ6y6wuBMp/aLlGzB035nZXA+AK65R7
        4WWtD2h0LTsvLjmJkIbNUzWgww+AkTcO+ZGMzzitLSUWmpxHLySp/bJ2sGe4QHhFrRbWNXGCOjoFJ
        qJLf0Jd012EdJ37+Kvt7EuDfm17iv/Yx2W15bMn8wnzT+846Jk7cVjRn1nOmS6PO2DiCTk1wBnVFt
        j+v8K5iA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1okKlM-008XC3-69; Mon, 17 Oct 2022 07:42:16 +0000
Date:   Mon, 17 Oct 2022 00:42:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v2 4/5] scsi: target: core: Add common port attributes
Message-ID: <Y00HWKHL3gj/An8E@infradead.org>
References: <20221006105057.30184-1-d.bogdanov@yadro.com>
 <20221006105057.30184-5-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221006105057.30184-5-d.bogdanov@yadro.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 06, 2022 at 01:50:56PM +0300, Dmitry Bogdanov wrote:
> From: Roman Bolshakov <r.bolshakov@yadro.com>
> 
> All SCSI target port attributes (tpgN/attribs/attrname) are defined and
> implemented in fabric modules in existing implementation.
> 
> The change introduces a way to have common tpg attribs in configfs for
> all fabrics without code duplication.

But does it really buy you much?  There is quite a lot of boilerplate
code vs just adding an attribute to an array in the drivers, which could
be further simplified by having a macro for all common ones.
