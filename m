Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED29C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Nov 2022 08:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiKBIrI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Nov 2022 04:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiKBIrG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2022 04:47:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478A724F22;
        Wed,  2 Nov 2022 01:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xlxIQG6wHiobj7EMkVPzuU4tyEqo1vs2vAZ1m4b7gNY=; b=YaIU/yVi9zCjwBrW+5AnzlFTDN
        olra+mKuZ33kODGoVZbzkh1mawAUw6FBXiFaCS6lgkxDDFIibwgS9hrSlU8w3VdM3xYmfxicAgM6C
        nJbZrZ6M70q8nEpq8X51XbE+Cnq+ll4PRihsVsliQnIeqAbkJNR6or6XE5uB2KmdCNcq4jGgkqOHa
        JbO5ryXNGFdNf9O7mbZtFtVP3xlM+N6oks0hXRm5N7PVNhhymE7bIOcfBvMigmwsAQPvBWVmWsn8+
        FINQ2YYMFeJ+ukYjHunJRlMM2yQKEhfd2gBaqTbnGTDXnpFX4jAd5aHlI5TlGT1fjZeIRkBRTdaT9
        sxWD+xRA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oq9Om-0099y3-N3; Wed, 02 Nov 2022 08:47:00 +0000
Date:   Wed, 2 Nov 2022 01:47:00 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jiaming Li <lijiaming3@xiaomi.corp-partner.google.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijiaming3 <lijiaming3@xiaomi.com>
Subject: Re: [RESEND PATCH 0/4] Implement File-Based optimization
 functionality
Message-ID: <Y2IuhG8nBJj0F1fd@infradead.org>
References: <20221102053058.21021-1-lijiaming3@xiaomi.corp-partner.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102053058.21021-1-lijiaming3@xiaomi.corp-partner.google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 02, 2022 at 01:30:54PM +0800, Jiaming Li wrote:
> 1) The host let the device know of lba range(s) of interest. Those
>    ranges are typically associated with a specific file. One can
>    obtain it from the iNode of the file and some offset calculations.

This is completely and utter madness.  Files are a logic concept, that
is non-unique (reflinks, snapshot) and can change at any time
(defragmentation, GC, dedup).  Whoever came up with this scheme is on
crack and the it has no business being in the Linux kernel

NAK.
