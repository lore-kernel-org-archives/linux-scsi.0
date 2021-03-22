Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEF1BC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 15:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BC1A619A4
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 15:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhCVPtf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 11:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbhCVPtY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 11:49:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42C5C061574;
        Mon, 22 Mar 2021 08:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xFkVl9GtHpru0bLv4N3vvuoNepAVBKJ0zyP6LRIKoyE=; b=H1NLAfgzVh7fuL7xk8M4VD3TbL
        /hGvSs6RAxUHYCcDNbGL55p6SAVPlXB+9riC1SmB3ZbaIQmLy2+xKgJkKWkOuHsfzzjvQ8sHPFUHr
        OR+c2g20qrCmEi8Bn8/M8op8ktcrIA73JEcMnM/JKEIdo5pemCV4pKqMWQj+u9w65h8wMzYgNLzDt
        gC4XnH9l+IkFnbpmSwg6pIM1V0ICfq9en08QmbEnU+RiNXJ40LW/pjSPGzG3e3J9OGVHJCVmsmJ8r
        WR60p4c4iZbp2TDS8vx9hq6E45K2kZWPdQNNQrviNIPmxNFY8xiAFzHCLtY16ohK40+hU+l0D6Jmx
        LOBfOSaA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lOMmF-008jhA-Vh; Mon, 22 Mar 2021 15:47:43 +0000
Date:   Mon, 22 Mar 2021 15:47:35 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] target: pscsi: avoid Wempty-body warning
Message-ID: <20210322154735.GA2079192@infradead.org>
References: <20210322114441.3479365-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322114441.3479365-1-arnd@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 22, 2021 at 12:44:34PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Building with 'make W=1' shows a harmless warning for pscsi:
> 
> drivers/target/target_core_pscsi.c: In function 'pscsi_complete_cmd':
> drivers/target/target_core_pscsi.c:624:33: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
>   624 |                                 ; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */
>       |                                 ^
> 
> Rework the coding style as suggested by gcc to avoid the warning.

I would much, much prefer to drop the bogus warning;

	if (foo)
		; /* comment */

is a fairly usual and absolutely sensible style.  The warning on hte
other hand is completely stupid.
