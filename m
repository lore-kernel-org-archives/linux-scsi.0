Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45ED5C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 05:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347955AbiDLF2K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 01:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346902AbiDLF2J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 01:28:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AAE34B81;
        Mon, 11 Apr 2022 22:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qKT+rKxJxRTHwUX6zSPidvw6TsQOrmd//JseePK15uA=; b=hafi3HcZO8eclGRtpUfrnE7sz+
        GnBAtjQIZNL0tYtwdHuTZcGGXIpJdnbezVWLvAEmIgpr/gr+rzKToHd/w0XwyrBFB5p/FWfb5+Ej6
        JapzhsrEoapweCNZ5h4r3Dj3E+4PlafjaTJX0J0B+Tbx8yOAREaPPKadIanLPk+Ffiv3116nxwEt5
        g+pFhD6zKyBrqNfguDK1LNiQuOIgAk0e9zJwd547O7NmObUXW1eYNLsngge5e/VM0SQfM/KA3cLq7
        Jp4gRfd3Lkbi13GGMT3PSYNozHQoB5nUKtOJyn194Qmr9eP8ztXnRQEiGYg/O1GNm4aQXxnGUS5vZ
        uODATKMA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ne922-00BmCM-4j; Tue, 12 Apr 2022 05:25:38 +0000
Date:   Mon, 11 Apr 2022 22:25:38 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Tom Rix <trix@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, tim@cyberelk.net,
        axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        nathan@kernel.org, ndesaulniers@google.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] security: do not leak information in ioctl
Message-ID: <YlUNUgTfej6VpkWS@infradead.org>
References: <20220409145137.67592-1-trix@redhat.com>
 <YlREKRb/xgAFsi97@infradead.org>
 <eec2efee-1153-8d8e-77c2-96156733a0c6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eec2efee-1153-8d8e-77c2-96156733a0c6@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 11, 2022 at 09:31:20AM -0700, Tom Rix wrote:
> The failure can happen in the transfer loop, so some of the data will not be
> zero.
> 
> And checking status should be done.
> 
> zero-ing is because i am paranoid.

Maybe I'm just lost because of all the reformating.  Please do a first
patch that split the CDROMREADTOCHDR and CDROMREADTOCENTRY into one
helper each and the just do the minimal fix on top so that it is
reviewable.
