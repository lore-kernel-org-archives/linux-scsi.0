Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 830B7C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 14:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E0A2610FC
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 14:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239641AbhDPO3V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Apr 2021 10:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241079AbhDPO3P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Apr 2021 10:29:15 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 74F53C061574;
        Fri, 16 Apr 2021 07:28:50 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id E038592009C; Fri, 16 Apr 2021 16:28:47 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id D923292009B;
        Fri, 16 Apr 2021 16:28:47 +0200 (CEST)
Date:   Fri, 16 Apr 2021 16:28:47 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Joe Perches <joe@perches.com>
cc:     Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] scsi: BusLogic: Fix missing `pr_cont' use
In-Reply-To: <86c10671ff86f96004a6d6c3c08aed3e27d58d0a.camel@perches.com>
Message-ID: <alpine.DEB.2.21.2104161627130.44318@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>  <alpine.DEB.2.21.2104141419040.44318@angie.orcam.me.uk>  <787aae5540612555a8bf92de2083c8fa74e52ce9.camel@perches.com>  <alpine.DEB.2.21.2104161224300.44318@angie.orcam.me.uk>
 <86c10671ff86f96004a6d6c3c08aed3e27d58d0a.camel@perches.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 16 Apr 2021, Joe Perches wrote:

> > I'm not sure if that complex message 
> > routing via `blogic_msg' is worth having even, rather than calling 
> > `printk' or suitable variants directly.
> 
> It's to allow the message content to be added to the internal
> 	&adapter->msgbuf[adapter->msgbuflen]
> with strcpy for later use with blogic_show_info()/seq_write.

 I know, but it's not clear to me if it's worth it (a potential buffer 
overrun there too, BTW).

  Maciej
