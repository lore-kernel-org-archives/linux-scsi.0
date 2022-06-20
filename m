Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F8C3C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jun 2022 06:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238947AbiFTGpY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jun 2022 02:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238318AbiFTGpX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jun 2022 02:45:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660DBC72;
        Sun, 19 Jun 2022 23:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VGZXQMA4RswyIvF0+1zx63xq3BMHhvUQ2lzlFp39NoQ=; b=MpiJzwEBNoGmvBFXN7t6HGxQIG
        PT2tOSqawZtR/raFUG/cM6wL7Jszf8x5ZvIIqY3/hUpBTpxcf8KOEeZcaQw9bM4QdXqyIN0mLLaZj
        DAonbfse1K5YwvH4Bgms1lv+Sfxpd0WHx1MIbHuuPFovIrpd7yqemPwC11W6rVQQGjse7QeBiZ3AZ
        ZQTFOoiPnUP0bZmxlSvsA31Hse+191vODKwum4Q0I4Kvekt7+Di3uVRZ0vCoKpTtwS2LsNMZbshRG
        v/b9nFFdIxBLebNwCacfiN+vOPkioqsf8F+IYomglxVvbfkEumd4kqUj/rEZ/7r4waKgSOzX07r6O
        nsCSKH6A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o3B9p-00GTrD-9r; Mon, 20 Jun 2022 06:45:09 +0000
Date:   Sun, 19 Jun 2022 23:45:09 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     michael.christie@oracle.com
Cc:     Christoph Hellwig <hch@infradead.org>, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH 1/4] scsi: target: Fix WRITE_SAME NDOB size check
Message-ID: <YrAXdTWu4/xsdWgq@infradead.org>
References: <20220617030440.116427-1-michael.christie@oracle.com>
 <20220617030440.116427-2-michael.christie@oracle.com>
 <Yq7AmRBWtkyqzt0g@infradead.org>
 <b154e89c-6b83-2d8d-0505-06fc3615e8a7@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b154e89c-6b83-2d8d-0505-06fc3615e8a7@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jun 19, 2022 at 11:25:33AM -0500, michael.christie@oracle.com wrote:
> sg_write_same allows it. We found the bug because some user just decided
> to do:
> 
> sg_write_same ... -nbod .. /dev/sdb
> 
> and it crashed the box.

Oh.

> I didn't know about the MI_REPORT_SUPPORTED_OPERATION_CODES part of it.
> I don't need support for the feature. I just want to fix the crash.
> I prefer just returning failure since nothing ever has ever used it if
> other people prefer that as well.

I think the feature is generally useful, and I know Martin had patches
to use it in Linux.  But I think a minimal fix for the remotely
exploitable crash has the highest priority.  Where does it crash?
Maybe we just need a better sanity check somewhere if a command
claims to transfer data but has not payload?
