Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF50FC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 17:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8970922285
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 17:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391110AbhALRdu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 12:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389692AbhALRdt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 12:33:49 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408A8C061575;
        Tue, 12 Jan 2021 09:33:09 -0800 (PST)
Date:   Tue, 12 Jan 2021 18:33:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610472787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LAolnOXmE55ZGWKDi1ZWtF/yiYKdSoWGTb8A4N47mNc=;
        b=D7X8h0loH2jqm2j9VY0Fe4Ez9zyjMZ5SS1CzWUwz+T+TWfHLLvL+NDgnrOYvP5Efb5UcNk
        Z7KA/yf0lWyuM3foAjm+e5MMzXbMhF7nkTOYoBxSnc3uzFYDt1fvahRdjUgmEd0ckcXg2W
        erYJvLLUO5nMuretieFN8QCuQkJbuMQR6kx8DGPgTkt4m2OfKra7qTPNQcEs81XcpG7d06
        n+pPpf+DqmuUubIiVz5a6AcbsYDlH9p4WYSKL7x+39pY8KJEUPn/++e2r02bGTGJoQrVJa
        +s4Ze11j5JFxge+KBXdUtK+zdLrBGIUZQl/5pWjVdwJm28uSGswQNp80nZJfrA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610472787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LAolnOXmE55ZGWKDi1ZWtF/yiYKdSoWGTb8A4N47mNc=;
        b=TezOMx8W2Z5YRX92l2k+O/anNGRYXpdMVxdknEAHVv20GwgQtERN6Bs4my/9OjvoNLYT1Y
        gJYHmsGS2boO7WCA==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     John Garry <john.garry@huawei.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
Subject: Re: [PATCH v2 00/19] scsi: libsas: Remove in_interrupt() check
Message-ID: <X/3dUkPCC1SrLT4m@lx-t490>
References: <20210112110647.627783-1-a.darwish@linutronix.de>
 <8683f401-29b6-4067-af51-7b518ad3a10f@huawei.com>
 <X/2h0yNqtmgoLIb+@lx-t490>
 <e9bc0c89-a4d6-1e5b-793d-3c246882210e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9bc0c89-a4d6-1e5b-793d-3c246882210e@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 12, 2021 at 04:00:57PM +0000, John Garry wrote:
...
>
> I boot-tested on my machines which have hisi_sas v2 and v3 hw, and it's ok.
> I will ask some guys to test a bit more.
>

Thanks a lot!

> And generally the changes look ok. But I just have a slight concern that we
> don't pass the gfp_flags all the way from the origin caller.
>
> So we have some really long callchains, for example:
>
> host.c: sci_controller_error_handler(): atomic, irq handler     (*)
> OR host.c: sci_controller_completion_handler(), atomic, tasklet (*)
>   -> sci_controller_process_completions()
>     -> sci_controller_unsolicited_frame()
>       -> phy.c: sci_phy_frame_handler()
>         -> sci_change_state(SCI_PHY_SUB_AWAIT_SAS_POWER)
>           -> sci_phy_starting_await_sas_power_substate_enter()
>             -> host.c: sci_controller_power_control_queue_insert()
>               -> phy.c: sci_phy_consume_power_handler()
>                 -> sci_change_state(SCI_PHY_SUB_FINAL)
>         -> sci_change_state(SCI_PHY_SUB_FINAL)
>     -> sci_controller_event_completion()
>       -> phy.c: sci_phy_event_handler()
>         -> sci_phy_start_sata_link_training()
>           -> sci_change_state(SCI_PHY_SUB_AWAIT_SATA_POWER)
>             -> sci_phy_starting_await_sata_power_substate_enter
>               -> host.c: sci_controller_power_control_queue_insert()
>                 -> phy.c: sci_phy_consume_power_handler()
>                   -> sci_change_state(SCI_PHY_SUB_FINAL)
>
> So if someone rearranges the code later, adds new callchains, etc., it could
> be missed that the context may have changed than what we assume at the
> bottom. But then passing the flags everywhere is cumbersome, and all the
> libsas users see little or no significant changes anyway, apart from a
> couple.
>

The deep call chains like the one you've quoted are all within the isci
Intel driver (patches #5 => #7), due to the *massive* state transitions
that driver has. But as the commit logs of these three patches show,
almost all of such transitions happened under atomic context anyway and
GFP_ATOMIC was thus used.

The GFP_KERNEL call-chains were all very simple: a workqueue, functions
already calling msleep() or wait_event_timeout() two or three lines
nearby, and so on.

All the other libsas clients (that is, except isci) also had normal call
chains that were IMHO easy to follow.

Thanks,

--
Ahmed S. Darwish
Linutronix GmbH
