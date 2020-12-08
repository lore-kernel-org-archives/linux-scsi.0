Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E1BFC4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 18:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFF1E23AAC
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 18:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731093AbgLHSiB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 13:38:01 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:8166 "EHLO
        mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730854AbgLHSiB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 13:38:01 -0500
X-IronPort-AV: E=Sophos;i="5.78,403,1599516000"; 
   d="scan'208";a="366953506"
Received: from 173.121.68.85.rev.sfr.net (HELO hadrien) ([85.68.121.173])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Dec 2020 19:37:18 +0100
Date:   Tue, 8 Dec 2020 19:37:18 +0100 (CET)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     Linus Torvalds <torvalds@linux-foundation.org>
cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nicolas.palix@univ-grenoble-alpes.fr,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: problem booting 5.10
In-Reply-To: <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com>
Message-ID: <alpine.DEB.2.22.394.2012081935580.16458@hadrien>
References: <alpine.DEB.2.22.394.2012081813310.2680@hadrien> <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On Tue, 8 Dec 2020, Linus Torvalds wrote:

> On Tue, Dec 8, 2020 at 9:37 AM Julia Lawall <julia.lawall@inria.fr> wrote:
> >
> > We have not succeeded to boot 5.10 on our Intel(R) Xeon(R) CPU E7-8870 v4 @
> > 2.10GHz server.  Previous versions (eg 4.19 - 5.9) boot fine.  We have
> > tried various rcs.
>
> So the problem started with rc1?

Yes.

>
> Could you try bisecting - even partially?

Sure.

Thanks for the feedback.

julia

> If you do only six
> bisections, the number of suspect commits drops from 15k to about 230
> - which likely pinpoints the suspect area.
>
> That said, your traces certainly makes me go "Hmm. Some thing broke in
> SCSI device scanning", with the primary one being the
> wait_for_completion() one - the rest of the stuck processes seem to be
> stuck in async_synchronize_cookie_domain() and are presumably waiting
> for this kthread that is waiting for the scan to finish.
>
> So I'm adding SCSI people to the cc, just in case they go "Hmm..".
>
> Martin & co - in the next email Julia also quotes
>
> > [   51.355655][    T7] scsi 0:0:14:0: Direct-Access     ATA      ST2000LM015-2E81 SDM1 PQ: 0 ANSI: 6
> > Gave up waiting for root file system device.  Common problems:[..]
>
> which seems to be more of the same pattern with the SCSI scanning failure.
>
> Of course, it could be some non-scsi patch that causes this, but.. A
> bisect would hopefully clarify.
>
> Leaving the (simplified) backtrace quoted below.
>
>                    Linus
>
> >The backtrace for rc7 is shown below.
> >
> > [  253.207171][  T979] INFO: task kworker/u321:2:1278 blocked for more than 120 seconds.
> > [  253.224089][  T979]       Tainted: G            E     5.10.0-rc7 #3
> > [  253.239209][  T979] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  253.256990][  T979] task:kworker/u321:2  state:D stack:    0 pid: 1278 ppid:     2 flags:0x00004000
> > [  253.275552][  T979] Workqueue: events_unbound async_run_entry_fn
> > [  253.290687][  T979] Call Trace:
> > [  253.302491][  T979]  __schedule+0x31e/0x890
> > [  253.315353][  T979]  schedule+0x3c/0xa0
> > [  253.327688][  T979]  schedule_timeout+0x274/0x310
> > [  253.379283][  T979]  wait_for_completion+0x8a/0xf0
> > [  253.392327][  T979]  scsi_complete_async_scans+0x107/0x170
> > [  253.406115][  T979]  __scsi_add_device+0xf7/0x130
> > [  253.418974][  T979]  ata_scsi_scan_host+0x98/0x1c0
> > [  253.431948][  T979]  async_run_entry_fn+0x39/0x160
> > [  253.444853][  T979]  process_one_work+0x24c/0x490
>
