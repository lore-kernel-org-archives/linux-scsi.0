Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB4FC43381
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 15:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 508952312F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 15:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405456AbhALPqb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 10:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405024AbhALPqa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 10:46:30 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9F7C061794;
        Tue, 12 Jan 2021 07:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tfwxIDtMqAgAUDQmeJmrWGnzpnGwIT85fqp5Ou8YLLs=; b=XUvZ+bTpFqTYLNZZcVSxa8sa3V
        lvGTwXTf1bM05tkVLrOg+7/aOIZyhFss9DbJOBa5er3YjzzVPxr34RwxV/rh2BrF4SYEkhBvAFQQ4
        aU6HbNuG0hNWi0Sk9n55yid+MEY7ymcpmtkzjCiz7IaKA7RwSbiltmvMd0Y1zJpDT8utFJ1UMjZ8d
        hGES9mU5RjqOGStOcRkKBQVkAG73P8nyvA08cBRQRVn7CZZzrZTtCYcXQYljNDvBpRfghmTRyKauK
        JvuFO388o5TXpRFrwB5MG3i7d+mEZCmThvWi03yhn0KkmqP00obN+JMhkZ7EMc+s7UePs/Ir/0IqJ
        D0A7G20A==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kzLr6-004ykN-S4; Tue, 12 Jan 2021 15:45:16 +0000
Date:   Tue, 12 Jan 2021 15:45:12 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        linux-scsi@vger.kernel.org, intel-linux-scu@intel.com,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
Subject: Re: [PATCH v2 03/19] scsi: libsas: Introduce a _gfp() variant of
 event notifiers
Message-ID: <20210112154512.GB1185705@infradead.org>
References: <20210112110647.627783-1-a.darwish@linutronix.de>
 <20210112110647.627783-4-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112110647.627783-4-a.darwish@linutronix.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 12, 2021 at 12:06:31PM +0100, Ahmed S. Darwish wrote:
> sas_alloc_event() uses in_interrupt() to decide which allocation should
> be used.
> 
> The usage of in_interrupt() in drivers is phased out and Linus clearly
> requested that code which changes behaviour depending on context should
> either be separated or the context be conveyed in an argument passed by
> the caller, which usually knows the context.
> 
> The in_interrupt() check is also only partially correct, because it
> fails to choose the correct code path when just preemption or interrupts
> are disabled. For example, as in the following call chain:

What is the problem with simply adding a gfp_t argument to the existing
calls?  The end result of this series looks fine, but the way we get
there looks extremely cumbersome.
