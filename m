Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B6E1C433E9
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 17:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33F5D23121
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 17:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389699AbhALRNh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 12:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392249AbhALRNg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 12:13:36 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAFDC061575;
        Tue, 12 Jan 2021 09:12:56 -0800 (PST)
Date:   Tue, 12 Jan 2021 18:12:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610471574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6/W5F33DLubCuSV5FhlC8sI+LESNtjrftT/4Oy9kQH0=;
        b=UxFIisiT2QYcyIlJQM+M4CDvhMniKuYYNk7aOp8srgzrv87sOAUG1Nn28WwO/ME37iBT+M
        ETEzV6Rq0XpEdqA7vYljk+ARaOw8xLQNHsOC7k3854ALUtsfAtDBX4xPmmpqw7ULjH4cdg
        0hD+JhC3neZBbrXHGqNE+pJMqu3TTZMy6joFjvKJysTJWitnBPxAzu8mKOPSOsqoHZEHqF
        jobwdKb1erWE5E5tt4moFsz07YpAcWixefbrOqAmHNGpIGIf03unHW1iSxJQeP4d/oTtcp
        eF3xLcQBy90HA0MbcCEdyvWoJMcNbvvuOjZR4AcUZG6zjMSRL8sDztDV0sKAtQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610471574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6/W5F33DLubCuSV5FhlC8sI+LESNtjrftT/4Oy9kQH0=;
        b=9afzGohH8UMt3DTl2V+/L6HbOFjh7CwGv8Nkcvoa9Ips+nML0t5AG9GCefzVdBwy9gWTJQ
        lpT9YcR8RiiLvLBg==
From:   "Sebastian A. Siewior" <bigeasy@linutronix.de>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        linux-scsi@vger.kernel.org, intel-linux-scu@intel.com,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 03/19] scsi: libsas: Introduce a _gfp() variant of
 event notifiers
Message-ID: <20210112171253.ues2euwoszf7mz4z@linutronix.de>
References: <20210112110647.627783-1-a.darwish@linutronix.de>
 <20210112110647.627783-4-a.darwish@linutronix.de>
 <20210112154512.GB1185705@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210112154512.GB1185705@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-12 15:45:12 [+0000], Christoph Hellwig wrote:
> What is the problem with simply adding a gfp_t argument to the existing
> calls?  The end result of this series looks fine, but the way we get
> there looks extremely cumbersome.

Maybe I don't understand you fully but if you want to avoid adding the
two _gftp functions (+ remove the other & rename at the end of series)
and passing the gfp_t argument right away then this what I had in my
inbox at the very beginning.
It was one big patch with a long description of the relevant code paths
and why it is the way it is. Since the two functions are used by many
drivers you had to patch all at once. So I suggested to split in smaller
chunks to make it easier to review (and bisect) and at the end the old
functions can be removed once all users are gone (and rename if the
maintainer wishes).
Once we had the individual patches for driver/folder it was easier to
review them. Then we also identified the first few patches which got the
Fixes: tag because in_interrupt() didn't take disabled interrupts into
account.

Sebastian
