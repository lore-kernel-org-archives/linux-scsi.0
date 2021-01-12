Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38DFBC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E38792310C
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbhALLZu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 06:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727886AbhALLZu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 06:25:50 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B819DC061575;
        Tue, 12 Jan 2021 03:25:09 -0800 (PST)
Date:   Tue, 12 Jan 2021 12:25:01 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610450708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tmprvas6jLxhRPYSF5LVYJr9paTJThYHwOQ+vhudxDc=;
        b=eW2a3CKYys8xrKKpS7bxW64hXTyUcHzt+2r2lymEhZMhHGaCz5ksjb5THZTDS872Up9nQ0
        SCBbUiO7hWD9N7vHE9rt0E4VwnEfxyuRCfU0+NtPjIfALdXh8N+3nVFMzYaLJ8lgprZE5L
        XuE7FuMT5fDQNdQJxNIy/INXEUFVUUONdNzbs669nwf0j00UvbrRKOdADD1DFl9ztYMX7C
        iiHDdIcDtV+lyjqB7AaIaSJhTcNxeHk/j9m3M01G4PCP8eQeCzZ9/AbJ2BHUqo1pSLz5h7
        iLs5/kn+zIEtTd0TEwTmphfiHVIhCvQGqW7eAaQFLVjHmjAN7Yf/l0fnee/x7g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610450708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tmprvas6jLxhRPYSF5LVYJr9paTJThYHwOQ+vhudxDc=;
        b=5cH2Sow1zY6BCPZBHZiseV4wlUnR6fz0e6NQ9qHAHyXHTiLPJdxOyKbsAfOQQ6tB/fCjO1
        xpGHvCiYwbXQgVAw==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     John Garry <john.garry@huawei.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        artur.paszkiewicz@intel.com, jinpu.wang@cloud.ionos.com,
        corbet@lwn.net, yanaijie@huawei.com, bigeasy@linutronix.de,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-linux-scu@intel.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH] scsi: libsas and users: Remove notifier indirection
Message-ID: <X/2HDUmb8L8LPELG@lx-t490>
References: <1610386112-132641-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610386112-132641-1-git-send-email-john.garry@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi John,

On Tue, Jan 12, 2021 at 01:28:32AM +0800, John Garry wrote:
> LLDDs report events to libsas with .notify_port_event and
> .notify_phy_event callbacks.
>
> These callbacks are fixed and so there is no reason why the functions
> cannot be called directly, so do that.
>
> This neatens the code slightly, makes it more obvious, and reduces
> function pointer usage, which is generally a good thing. Downside is that
> there are 2x more symbol exports.
>
> Signed-off-by: John Garry <john.garry@huawei.com>
>

Since this patch necessitates a careful manual rebase of _every_ patch
in my series, I've included it at the top of my v2 submission and
rebased everything on top:

    https://lkml.kernel.org/r/20210112110647.627783-1-a.darwish@linutronix.de

Some left-over 'sas_ha' local variables were removed, and I've mentioned
that in the commit log of course.

Thanks!

--
Ahmed S. Darwish
Linutronix GmbH
