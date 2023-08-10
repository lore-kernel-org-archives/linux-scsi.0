Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD9FC04FE2
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Aug 2023 16:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236709AbjHJQVo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Aug 2023 12:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236675AbjHJQVm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2023 12:21:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A8F270A;
        Thu, 10 Aug 2023 09:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nzbm7zQ6piDxhfyPXbFOtMIzi1rH9tl9eRtCZrp6e/g=; b=0tuO6XmD/1avgiWMDtNwlVC9G2
        mO72eTVDQn19DyCZkHq0Gk0RSvpuoXidwIkEvJn0/WVgOfSx1/TFzcCSxJsIOJ6p1vCg1KGEzsXEu
        QjMsO+P+W3ACg2gwHJFi3gRy6QUPFvrgNprH54dILqMZ2A+9oneHnyCEW+DzL69zRqEDzvu7XuRQX
        uCXUxNamWuxzQUkst1DRE5y/wbFjnHuJ5VKINnWvHGShkpE6PYAhiOrN1HzEQyrhmMfuUma7d37x0
        QUxtcAib1rzB992eb7lcU+MVGVqZZWZLI9bVUukHCV+NjpSmyQjjfur6XMdrrpslKX532GYZ1cy1P
        lbQdzGfQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qU8Pl-008AuS-1j;
        Thu, 10 Aug 2023 16:21:33 +0000
Date:   Thu, 10 Aug 2023 09:21:33 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Richard Weinberger <richard@nod.at>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Stephan Wurm <stephan.wurm@a-eberle.de>,
        stable <stable@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Oliver Neukum <oliver@neukum.org>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        James Bottomley <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/7] ubi: block: Refactor sg list processing for highmem
Message-ID: <ZNUOjQVivR/5pFKE@infradead.org>
References: <20230810160019.16977-1-richard@nod.at>
 <20230810160019.16977-2-richard@nod.at>
 <ZNUK8nWnUYB6B4Kg@infradead.org>
 <298860961.5257332.1691684136772.JavaMail.zimbra@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <298860961.5257332.1691684136772.JavaMail.zimbra@nod.at>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 10, 2023 at 06:15:36PM +0200, Richard Weinberger wrote:
> >> The followup patches in this series will switch to kmap_sg()
> >> and we can remove our own helper and the bounce buffer.
> > 
> > Please just use kmap_local and avoid the bounce buffering.
> 
> Patch 6 does this.

But why add the bounce buffering first if you can avoid it from the
very beginning by just using kmap_local instead of adding a new
caller for the deprecate kmap_atomic?
