Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1101C433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 15:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 821A46186A
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 15:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhCVPyy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 11:54:54 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:50662 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230137AbhCVPyT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 11:54:19 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 12MFriE9023405;
        Mon, 22 Mar 2021 16:53:44 +0100
Date:   Mon, 22 Mar 2021 16:53:44 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] target: pscsi: avoid Wempty-body warning
Message-ID: <20210322155344.GA23040@1wt.eu>
References: <20210322114441.3479365-1-arnd@kernel.org>
 <20210322154735.GA2079192@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322154735.GA2079192@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 22, 2021 at 03:47:35PM +0000, Christoph Hellwig wrote:
> On Mon, Mar 22, 2021 at 12:44:34PM +0100, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > Building with 'make W=1' shows a harmless warning for pscsi:
> > 
> > drivers/target/target_core_pscsi.c: In function 'pscsi_complete_cmd':
> > drivers/target/target_core_pscsi.c:624:33: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
> >   624 |                                 ; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */
> >       |                                 ^
> > 
> > Rework the coding style as suggested by gcc to avoid the warning.
> 
> I would much, much prefer to drop the bogus warning;
> 
> 	if (foo)
> 		; /* comment */
> 
> is a fairly usual and absolutely sensible style.  The warning on hte
> other hand is completely stupid.

Agreed!

These days it seems there is a competition for the stupidest warning
between compilers, and we've reached the point where working around
them manages to introduce real bugs :-(

I predict we'll soon see warning such as "this comment looks like valid
C code, if you really intended to comment it out, use #if 0 instead". Oh
well, let's hope I have not given a new idea here...

Willy
