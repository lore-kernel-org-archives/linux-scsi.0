Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB01EC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 19:00:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B87D220728
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 19:00:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oJBvAo8Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgEOTA3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 15:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgEOTA3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 15:00:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6C2C061A0C;
        Fri, 15 May 2020 12:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cpdp67EUtxwQ4pvAlHHorIRNUGF4UtquU7Pnx9Rww6E=; b=oJBvAo8ZP0MxYVgwBCVArAwAjU
        ksi/m0csrnuZAbzFyX+GIi2y9tiwHZYjJUb9SWcRqRtAmVb/CL9oI2cGKoVw95o9gl+NlsGLOQvoG
        Fg3QpYPy1cBLS6cdmi1kA1P0I7I4LVkxO64m23SkXTDu3tt/AotueGrwOkzDjJLTS3P0qnsoQYy7F
        xAqYTLA06l0bJV0g84y3ZuqtM6UZjHvgoykv8NZBVSKUaiI/4dimcgIRb8+ajUcQ9iHaJ6AgeJjko
        k0NLU9xyh5P5L5dCsKDJUm6q0DX4ly03R4uOHxEyZg8WjqhbToo8C81op/n0x9ndGLqRqa65ALEQw
        rRDGLbUg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jZfZK-0005ND-Lw; Fri, 15 May 2020 19:00:26 +0000
Date:   Fri, 15 May 2020 12:00:26 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     kbuild test robot <lkp@intel.com>
Cc:     Michal Simek <monstr@monstr.eu>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Stefan Asserhall <stefan.asserhall@xilinx.com>,
        linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: drivers/scsi/ncr53c8xx.c:5306:9: sparse: sparse: cast truncates
 bits from constant value (58f becomes 8f)
Message-ID: <20200515190026.GI16070@bombadil.infradead.org>
References: <202005160227.h6Ieqnmz%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202005160227.h6Ieqnmz%lkp@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, May 16, 2020 at 02:20:38AM +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   051e6b7e34b9bd24f46725f74994a4d3a653966e
> commit: 06e85c7e9a1c1356038936566fc23f7c0d363b96 asm-generic: fix unistd_32.h generation format
> date:   5 weeks ago

I don't see how that commit in any way reflects this error message.

> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.1-193-gb8fad4bc-dirty
>         git checkout 06e85c7e9a1c1356038936566fc23f7c0d363b96
>         make ARCH=x86_64 allmodconfig

I can't even see a way to build the ncr53c8xx module with this config.
Unless somebody reenabled EISA on x86, the only way I can see to
still build this driver is on PA-RISC with the ZALON code.

>         make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> 
> sparse warnings: (new ones prefixed by >>)
> 
> >> drivers/scsi/ncr53c8xx.c:5306:9: sparse: sparse: cast truncates bits from constant value (58f becomes 8f)
> 
> ^1da177e4c3f41 Linus Torvalds 2005-04-16 @5306  	OUTW (nc_sien , STO|HTH|MA|SGE|UDC|RST|PAR);

This seems entirely intentional.

Something like this should do the job (whitespace damaged):

+++ b/drivers/scsi/ncr53c8xx.h
@@ -407,7 +407,7 @@
 
 #ifdef CONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS
 /* Only 8 or 32 bit transfers allowed */
-#define OUTW_OFF(o, val)       do { writeb((char)((val) >> 8), (char __iomem *)np->reg + ncr_offw(o)); writeb((char)(val), (char __iomem *)np->reg + ncr_offw(o) + 1); } while (0)
+#define OUTW_OFF(o, val)       do { writeb((char)((val) >> 8), (char __iomem *)np->reg + ncr_offw(o)); writeb((char)((val) & 0xff), (char __iomem *)np->reg + ncr_offw(o) + 1); } while (0)
 #else
 #define OUTW_OFF(o, val)       writew_raw((val), (char __iomem *)np->reg + ncr_offw(o))
 #endif


