Return-Path: <SRS0=de5d=CV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D7FC10DAA
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Sep 2020 07:21:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2822720723
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Sep 2020 07:21:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tLhDzwg7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbgILHVD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Sep 2020 03:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgILHVA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Sep 2020 03:21:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D73C061573;
        Sat, 12 Sep 2020 00:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IO15FPfV7WlpSs/4QD3nTgCmNRAVUjKHodQH7y6cWwc=; b=tLhDzwg795yoiuFQqAj2x/Pntj
        LJWzdWp7CSBxptRrH+UZNlui/ZsGChvfD3/bHUsW6L81Q50JAUKMsubFzeERNXuqDGkHKwUNr9LoX
        ABzE1pr8xP0rWrBY8rjJ5nSWwB+QxJo6LP04nryZ5LA+hWUXX3VTXTHcYE8H8RIi9ggCRdXHUyUve
        7hiQUuboDW7wZcll2QxyB3qK+XAo0xG7KYgnv1YDfwPQUqKk+LhzGUgR192w9T4ppKuEPvANjXKYX
        kgVqKAHz5sVu8Gw4fYkVUyUyxf3E2RU8M81qNg8Gx1GSmbN+YHlvDn/oKEX/nxyQp8RirLwQ4aEKB
        87qu1HYQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kGzq9-00019Q-Uq; Sat, 12 Sep 2020 07:20:54 +0000
Date:   Sat, 12 Sep 2020 08:20:53 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        hch@infradead.org, stable@vger.kernel.org,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] scsi: megaraid_sas: check user-provided offsets
Message-ID: <20200912072053.GB1945@infradead.org>
References: <20200908213715.3553098-1-arnd@arndb.de>
 <20200908213715.3553098-2-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908213715.3553098-2-arnd@arndb.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 08, 2020 at 11:36:22PM +0200, Arnd Bergmann wrote:
> It sounds unwise to let user space pass an unchecked 32-bit
> offset into a kernel structure in an ioctl. This is an unsigned
> variable, so checking the upper bound for the size of the structure
> it points into is sufficient to avoid data corruption, but as
> the pointer might also be unaligned, it has to be written carefully
> as well.
> 
> While I stumbled over this problem by reading the code, I did not
> continue checking the function for further problems like it.

Oh, yikes!

> 
> Cc: stable@vger.kernel.org

What about a Fixes tag instead?

>  	if (ioc->sense_len) {
> +		/* make sure the pointer is part of the frame */
> +		if (ioc->sense_off > (sizeof(union megasas_frame) - sizeof(__le64))) {

No need for the inner braces and please avoid over 80 char lines.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
