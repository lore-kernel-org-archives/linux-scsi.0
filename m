Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 524F0C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 12:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 197B36128A
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 12:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240905AbhDLM0b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 08:26:31 -0400
Received: from angie.orcam.me.uk ([157.25.102.26]:38740 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240792AbhDLM0a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Apr 2021 08:26:30 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id CBD1392009C; Mon, 12 Apr 2021 14:26:10 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id C5A8C92009B;
        Mon, 12 Apr 2021 14:26:10 +0200 (CEST)
Date:   Mon, 12 Apr 2021 14:26:10 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Christoph Hellwig <hch@lst.de>
cc:     Jens Axboe <axboe@kernel.dk>, Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/8] Buslogic: remove ISA support
In-Reply-To: <alpine.DEB.2.21.2104031805520.18977@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2104120318100.65251@angie.orcam.me.uk>
References: <20210331073001.46776-1-hch@lst.de> <20210331073001.46776-3-hch@lst.de> <alpine.DEB.2.21.2104031805520.18977@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 3 Apr 2021, Maciej W. Rozycki wrote:

> I'll see if I can bisect the problem and report back.  I don't have a 
> FlashPoint adapter to verify that part of the driver, but I guess for your 
> change alone a MultiMaster one such as mine will suffice.

 FYI I have now tracked down the cause of the regression, which is outside 
BusLogic code; specifically commit af73623f5f10 ("[SCSI] sd: Reduce buffer 
size for vpd request").  It wasn't exactly easy as for an odd reason Linux 
versions ~3.15 through to ~4.5 usually crash with this system in early 
startup before anything is output to the serial console.

 I'm still working on a proper fix, but with said commit reverted the 
system boots and with your series applied it has survived system-wide fsck 
even, which happened to get scheduled.  So for BT-958:

Tested-by: Maciej W. Rozycki <macro@orcam.me.uk>

  Maciej
