Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 504D8C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 06:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244992AbiBKGef (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 01:34:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244565AbiBKGee (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 01:34:34 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4FBE56;
        Thu, 10 Feb 2022 22:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wmT7NdpIIaZIZ4RJN8MppwRUgJ7HrGVSC4APn17UeMY=; b=29czAqJRGXG9/3d5XsS3Qn5xPf
        msIroF9kN5cnhhZVwC1VEpMYxztAzu1w/QoGaORO9AXhwrQe3iWqmu1mjrO96HH2IGf+78L9I1Y/e
        uZLVt2DNRlf69kviZF0Ma3rimb3FJwKlx7aNodiI0EmLI13WwMokZVpM7Bgvib9L+I1yVXpIf/0bQ
        N5qs8K2lzHviDpdOG8zebJc+reU+Ku7krq5ulnVBeYjeZipiricP1UYVBV15nj+oSC6+J9VzCgUuV
        t7+rQ1LJz66kZsUg2SDPckzpjChVwEs6GM33uzdUlnsWXdKnTrwZPt+IPiXkxYStH55wVdTBp5wDG
        J4g6aMEQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nIPVo-005zmJ-3R; Fri, 11 Feb 2022 06:34:32 +0000
Date:   Thu, 10 Feb 2022 22:34:32 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH REPOST] irq_poll: Add local_bh_disable() in cpu_dead
 notifier
Message-ID: <YgYDePJLsVLXKqEP@infradead.org>
References: <YgJ/XWVxxWDVBBVA@linutronix.de>
 <YgNzsnIE9bwQZ1Zg@infradead.org>
 <YgUGI9qAKUh4AOUY@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgUGI9qAKUh4AOUY@linutronix.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 10, 2022 at 01:33:39PM +0100, Sebastian Andrzej Siewior wrote:
> You need to handle the pending softirqs. If you don't handle them
> immediately or in a deterministic say (like on IRQ exit) then they will
> be handled at a random point.

Yes.  Just like regular interrupts.
