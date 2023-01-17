Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92F0C6379F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 07:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235941AbjAQHqK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 02:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235245AbjAQHqJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 02:46:09 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D382623DA9;
        Mon, 16 Jan 2023 23:46:04 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6CA0368281;
        Tue, 17 Jan 2023 07:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1673941563; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gcQSletvhO4wh1U/V7ppDt6OVyPkdg0/EF7pXKdjASg=;
        b=L8t5asuMW/yt91oRhL/9EEdPplMNjwFtJbKCNVgWplQtJI5RcqLiMkRPrWrZweXFYKAMIJ
        lIEeYZTASJiL1GUmu9XulcQSy4A5E1GrRZ1ntm8B7CUVE4Scgd2I83oQxSjrS5CF4iJVEJ
        ExPSm08YAHnrpWgF5HVpF6IPtQSLjR8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1781F13357;
        Tue, 17 Jan 2023 07:46:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id XbofBDtSxmMuPgAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 17 Jan 2023 07:46:03 +0000
Message-ID: <5fd704674fcf7ec08cf7e33b5db5d83078d7c5c2.camel@suse.com>
Subject: Re: kernel BUG scsi_dh_alua sleeping from invalid context && kernel
 WARNING do not call blocking ops when !TASK_RUNNING
From:   Martin Wilck <mwilck@suse.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Steffen Maier <maier@linux.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>,
        Benjamin Block <bblock@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Date:   Tue, 17 Jan 2023 08:46:02 +0100
In-Reply-To: <228d2351-e0ff-e743-6005-3ac0f0daf637@acm.org>
References: <b49e37d5-edfb-4c56-3eeb-62c7d5855c00@linux.ibm.com>
         <228d2351-e0ff-e743-6005-3ac0f0daf637@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Bart,

On Mon, 2023-01-16 at 09:55 -0800, Bart Van Assche wrote:
> On 1/16/23 06:59, Steffen Maier wrote:
> > Hi all,
> >=20
> > since a few days/weeks, we sometimes see below alua and sleep
> > related=20
> > kernel BUG and WARNING (with panic_on_warn) in our CI.
> >=20
> > It reminds me of
> > [PATCH 0/2] Rework how the ALUA driver calls scsi_device_put()
> > https://lore.kernel.org/linux-scsi/166986602290.2101055.173977343268438=
53911.b4-ty@oracle.com/
> >=20
> > which I thought was the fix and went into 6.2-rc(1?) on 2022-12-14
> > with
> > [GIT PULL] first round of SCSI updates for the 6.1+ merge window
> > https://lore.kernel.org/linux-scsi/b2e824bbd1e40da64d2d01657f2f7a67b989=
19fb.camel@HansenPartnership.com/T/#u
> >=20
> > Due to limited history, I cannot tell exactly when problems started
> > and=20
> > whether it really correlates to above.
> >=20
> > Test workload are all kinds of coverage tests for zfcp recovery=20
> > including scsi device removal and/or rescan.
> >=20
> > [ 4569.045992] BUG: sleeping function called from invalid context
> > at=20
> > drivers/scsi/device_handler/scsi_dh_alua.c:992
> > [ 4569.046003] in_atomic(): 1, irqs_disabled(): 0, non_block: 0,
> > pid: 0,=20
> > name: swapper/8
> > [ 4569.046013] preempt_count: 101, expected: 0
> > [ 4569.046023] RCU nest depth: 0, expected: 0
> > [ 4569.046033] no locks held by swapper/8/0.
> > [ 4569.046042] Preemption disabled at:




>=20
> Thanks,
>=20
> Bart.

> > [ 4569.046046] [<000000017e27ce4e>]
> > __slab_alloc.constprop.0+0x36/0xb8
> > [ 4569.046072] CPU: 8 PID: 0 Comm: swapper/8 Tainted: G=A0=A0=A0=A0=A0=
=A0=A0 W=20
> > 6.2.0-20230114.rc3.git0.46e26dd43df0.300.fc37.s390x+debug #1
> > [ 4569.046084] Hardware name: IBM 2964 NC9 702 (z/VM 6.4.0)
> > [ 4569.046094] Call Trace:
> > [ 4569.046102]=A0 [<000000017ed21bcc>] dump_stack_lvl+0xac/0x100
> > [ 4569.046118]=A0 [<000000017df9192c>] __might_resched+0x284/0x2c8
> > [ 4569.046131]=A0 [<000003ff7fb9c874>] alua_rtpg_queue+0x3c/0x98=20
> > [scsi_dh_alua]
> > [ 4569.046146]=A0 [<000003ff7fb9cfb2>] alua_check+0x122/0x250
> > [scsi_dh_alua]
> > [ 4569.046167]=A0 [<000003ff7fb9d562>] alua_check_sense+0x172/0x228=20
> > [scsi_dh_alua]
> > [ 4569.046179]=A0 [<000000017e96b3e2>] scsi_check_sense+0x8a/0x2e0
> > [ 4569.046191]=A0 [<000000017e96e4b6>]
> > scsi_decide_disposition+0x286/0x298
> > [ 4569.046201]=A0 [<000000017e972bca>] scsi_complete+0x6a/0x108
> > [ 4569.046212]=A0 [<000000017e746906>] blk_complete_reqs+0x6e/0x88
> > [ 4569.046227]=A0 [<000000017ed3830e>] __do_softirq+0x13e/0x6b8
> > [ 4569.046238]=A0 [<000000017df57902>] __irq_exit_rcu+0x14a/0x170
> > [ 4569.046264]=A0 [<000000017df58472>] irq_exit_rcu+0x22/0x50
> > [ 4569.046275]=A0 [<000000017ed2242a>] do_ext_irq+0x10a/0x1d0
> > [ 4569.046286]=A0 [<000000017ed36156>] ext_int_handler+0xd6/0x110
> > [ 4569.046296]=A0 [<000000017ed362e6>] psw_idle_exit+0x0/0xa
> > [ 4569.046307] ([<000000017defc5da>] arch_cpu_idle+0x52/0xe0)
> > [ 4569.046318]=A0 [<000000017ed34744>] default_idle_call+0x84/0xd0
> > [ 4569.046329]=A0 [<000000017dfbe4cc>] do_idle+0xfc/0x1b8
> > [ 4569.046340]=A0 [<000000017dfbe80e>] cpu_startup_entry+0x36/0x40
> > [ 4569.046350]=A0 [<000000017df11964>]
> > smp_start_secondary+0x14c/0x160
> > [ 4569.046371]=A0 [<000000017ed3658e>] restart_int_handler+0x6e/0x90
> > [ 4569.046381] no locks held by swapper/8/0.
> Hi Steffen,
>=20
> Thanks for your report and also for having included this call trace.
> Is=20
> my understanding correct that alua_rtpg_queue+0x3c refers to the=20
> might_sleep() near the start of alua_rtpg_queue()? If so, please help
> with testing the following patch:
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c=20
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 49cc18a87473..79afa7acdfbc 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -989,8 +989,6 @@ static bool alua_rtpg_queue(struct
> alua_port_group
> =A0=A0=A0=A0=A0=A0=A0=A0int start_queue =3D 0;
> =A0=A0=A0=A0=A0=A0=A0=A0unsigned long flags;
>=20
> -=A0=A0=A0=A0=A0=A0=A0might_sleep();
> -
> =A0=A0=A0=A0=A0=A0=A0=A0if (WARN_ON_ONCE(!pg) || scsi_device_get(sdev))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
>=20
>=20
> I'm proposing this change because the context from which a request is
> queued should hold a reference on 'sdev' while a request is in
> progress=20
> so alua_check_sense() should not trigger the scsi_device_put() call
> in=20
> alua_rtpg_queue().

alua_rtpg_queue() must take an additional reference in order to make
sure that the ref survives until the workqueue is started. A possible
reference hold by the caller doesn't help because the caller might have
dropped the ref before the workqueue runs.

Please explain. Am I overlooking something?

Regards
Martin

