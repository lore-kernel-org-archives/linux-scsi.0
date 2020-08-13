Return-Path: <SRS0=CV/f=BX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAEC6C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 07:27:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF34720781
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 07:27:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aOm/z2B+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgHMH1I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Aug 2020 03:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgHMH1H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Aug 2020 03:27:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64155C061757
        for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2020 00:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ce6c/+nCm2OlEuxWFrXWJnsV9aT6QFs2S08fS1Z0b5k=; b=aOm/z2B+//HxUd3MnkKcGihfF1
        r5iL84oKQgxmjoaVnr8G4HB1RIhhPvTeLrDIfDYpYlSHKp8O7JmSqlGWRiY+Y5l603edt78jvzOs1
        zk77qnQD5Gxvz1A4+pAwTItjCFR+R3+BuchrB1EOs/VbVo5+EWRAH7ounuu7F/AnUG6eWQ/HWxvbk
        x1s9GsmLV7MCnkenGAYYblTaJdEYgkvm7Y/YGm1jEfodeRoUbi7/2Li9md5jXATyTAnwE3tQtYXDm
        DYqhUPxugES4Oludi7wYVxHmSzi00P5PkzZ4D1x56kff7N/EqoepqissLywuqTOboJc2rbVXjjAXL
        WaE5Q+4A==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k67dX-0003u6-Pc; Thu, 13 Aug 2020 07:26:55 +0000
Date:   Thu, 13 Aug 2020 08:26:55 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jim Gill <jgill@vmware.com>
Cc:     pv-drivers@vmware.com, jejb@ibm.linux.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/3 for-next] pvscsi: Limit ring pages for swiotlb
Message-ID: <20200813072655.GA14861@infradead.org>
References: <20200812205502.GA18382@petr-dev3.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812205502.GA18382@petr-dev3.eng.vmware.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 12, 2020 at 01:55:02PM -0700, Jim Gill wrote:
> A large number of outstanding scsi commands can
>  completely fill up the allowable DMA size. Typically this happens with
>  SWIOTLB and SEV encryption active. While this is harmless for the scsi middle
>  layer, it floods the kernel log with error messages and can cause other
>  device drivers to error. Reduce the number of ring pages to 1 if we detect
>  DMA size restrictions.

Umm, no.  Drivers have absolutely no business checking
mem_encrypt_active().
