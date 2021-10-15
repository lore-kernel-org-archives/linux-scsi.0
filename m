Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67239C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 07:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50CA961181
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 07:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236396AbhJOH5g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 03:57:36 -0400
Received: from mout02.posteo.de ([185.67.36.66]:56591 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236389AbhJOH5e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Oct 2021 03:57:34 -0400
Received: from submission (posteo.de [89.146.220.130]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 01805240105
        for <linux-scsi@vger.kernel.org>; Fri, 15 Oct 2021 09:55:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1634284526; bh=8LBwH0+3amptIJvQVsPMwO8fecT2f8DQCw7UNZ5r/x0=;
        h=Subject:From:To:Cc:Date:From;
        b=ZUhOGCRa5prF1cIJqU0d16RTAa1ZeS5v2chFDazn+hSZUjU8na1yH8ts8vmMmR2ka
         SzmAgHajj5GNwvufnzoWEJ9rmnaYangcHfzYYhC/abIImVKsK/iQBgFwNSZ5nXb0cd
         xGEeDj05kKBB+DEuv+CS+V2z7P3rTzGLqGTOvlkcFuieO+jf8XLJ6vt2sK8No7gfWR
         wfQRBEXk5jgwzUI/ZsKZFI1aG7iP4MV2cYyb1rTqqVpGl0RnVM0c1Kd5YTPkPmeguq
         ojfj0vrzRim9OJ/pCbXXkLPtAmK42uGm/2tb/6+5fUELwtfMccN4WH0TRbiWv6jLga
         SPjEIgzGMCb9Q==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4HVz8W2b9Vz6tmN;
        Fri, 15 Oct 2021 09:55:23 +0200 (CEST)
Message-ID: <b42514b749d78e1c5c48d3e39ac64decc8965600.camel@posteo.de>
Subject: Re: [PATCH] scsi: sd: fix crashes in sd_resume_runtime
From:   Martin Kepplinger <martink@posteo.de>
To:     Miles Chen <miles.chen@mediatek.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
        Stanley Chu <stanley.chu@mediatek.com>
Date:   Fri, 15 Oct 2021 07:55:22 +0000
In-Reply-To: <20211015074654.19615-1-miles.chen@mediatek.com>
References: <20211015074654.19615-1-miles.chen@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Am Freitag, dem 15.10.2021 um 15:46 +0800 schrieb Miles Chen:
> After merging commit ed4246d37f3b ("scsi: sd: REQUEST SENSE for
> BLIST_IGN_MEDIA_CHANGE devices in runtime_resume()"), I hit the
> following crash on my device.
> 
> static int sd_resume_runtime(struct device *dev)
> {
>         struct scsi_disk *sdkp = dev_get_drvdata(dev);
>         struct scsi_device *sdp = sdkp->device; // sdkp == NULL and
> crash
> 
>         if (sdp->ignore_media_change) {
>         ...
> }
> 
> I checked sd_resume() and found that sdkp is possbile to be NULL, and
> there is a null pointer test in sd_resume() for this case.
> To fix this crash, follow sd_resume() to test if sdkp is NULL
> before dereferencing it.
> 
> Crash:
> [    4.695171][  T151] Unable to handle kernel NULL pointer
> dereference at virtual address 0000000000000008
> [    4.696591][  T151] Mem abort info:
> [    4.697919][  T151]   ESR = 0x96000005
> [    4.699692][  T151]   EC = 0x25: DABT (current EL), IL = 32 bits
> [    4.701990][  T151]   SET = 0, FnV = 0
> [    4.702513][  T151]   EA = 0, S1PTW = 0
> [    4.704431][  T151]   FSC = 0x05: level 1 translation fault
> [    4.705254][  T151] Data abort info:
> [    4.705806][  T151]   ISV = 0, ISS = 0x00000005
> [    4.706484][  T151]   CM = 0, WnR = 0
> [    4.707048][  T151] [0000000000000008] user address but active_mm
> is swapper
> [    4.710577][  T151] Internal error: Oops: 96000005 [#1] PREEMPT
> SMP
> [    4.832361][  T151] Kernel Offset: 0x12acc80000 from
> 0xffffffc010000000
> [    4.833254][  T151] PHYS_OFFSET: 0x40000000
> [    4.833814][  T151] pstate: 80400005 (Nzcv daif +PAN -UAO)
> [    4.834546][  T151] pc : sd_resume_runtime+0x20/0x14c
> [    4.835227][  T151] lr : scsi_runtime_resume+0x84/0xe4
> [    4.835916][  T151] sp : ffffffc0110db8d0
> [    4.836450][  T151] x29: ffffffc0110db8d0 x28: 0000000000000001
> [    4.837258][  T151] x27: ffffff80c0bd1ac0 x26: ffffff80c0bd1ad0
> [    4.838063][  T151] x25: ffffff80cea7e448 x24: ffffffd2bf961000
> [    4.838867][  T151] x23: ffffffd2be69f838 x22: ffffffd2bd9dfb4c
> [    4.839670][  T151] x21: 0000000000000000 x20: ffffff80cea7e000
> [    4.840474][  T151] x19: ffffff80cea7e260 x18: ffffffc0110dd078
> [    4.841277][  T151] x17: 00000000658783d9 x16: 0000000051469dac
> [    4.842081][  T151] x15: 00000000b87f6327 x14: 0000000068fd680d
> [    4.842885][  T151] x13: ffffff80c0bd2470 x12: ffffffd2bfa7f5f0
> [    4.843688][  T151] x11: 0000000000000078 x10: 0000000000000001
> [    4.844492][  T151] x9 : 00000000000000b1 x8 : ffffffd2be69f88c
> [    4.845295][  T151] x7 : ffffffd2bd9e0e5c x6 : 0000000000000000
> [    4.846099][  T151] x5 : 0000000000000080 x4 : 0000000000000001
> [    4.846902][  T151] x3 : 68fd680dfe4ebe5e x2 : 0000000000000003
> [    4.847706][  T151] x1 : ffffffd2bf7f9380 x0 : ffffff80cea7e260
> [    4.856708][  T151]  die+0x16c/0x59c
> [    4.857191][  T151]  __do_kernel_fault+0x1e8/0x210
> [    4.857833][  T151]  do_page_fault+0xa4/0x654
> [    4.858418][  T151]  do_translation_fault+0x6c/0x1b0
> [    4.859083][  T151]  do_mem_abort+0x68/0x10c
> [    4.859655][  T151]  el1_abort+0x40/0x64
> [    4.860182][  T151]  el1h_64_sync_handler+0x54/0x88
> [    4.860834][  T151]  el1h_64_sync+0x7c/0x80
> [    4.861395][  T151]  sd_resume_runtime+0x20/0x14c
> [    4.862025][  T151]  scsi_runtime_resume+0x84/0xe4
> [    4.862667][  T151]  __rpm_callback+0x1f4/0x8cc
> [    4.863275][  T151]  rpm_resume+0x7e8/0xaa4
> [    4.863836][  T151]  __pm_runtime_resume+0xa0/0x110
> [    4.864489][  T151]  sd_probe+0x30/0x428
> [    4.865016][  T151]  really_probe+0x14c/0x500
> [    4.865602][  T151]  __driver_probe_device+0xb4/0x18c
> [    4.866278][  T151]  driver_probe_device+0x60/0x2c4
> [    4.866931][  T151]  __device_attach_driver+0x228/0x2bc
> [    4.867630][  T151]  __device_attach_async_helper+0x154/0x21c
> [    4.868398][  T151]  async_run_entry_fn+0x5c/0x1c4
> [    4.869038][  T151]  process_one_work+0x3ac/0x590
> [    4.869670][  T151]  worker_thread+0x320/0x758
> [    4.870265][  T151]  kthread+0x2e8/0x35c
> [    4.870792][  T151]  ret_from_fork+0x10/0x20
> 
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Fixes: ed4246d37f3b ("scsi: sd: REQUEST SENSE for
> BLIST_IGN_MEDIA_CHANGE devices in runtime_resume()")
> Signed-off-by: Miles Chen <miles.chen@mediatek.com>
> ---
>  drivers/scsi/sd.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 523bf2fdc253..fce63335084e 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3683,7 +3683,12 @@ static int sd_resume(struct device *dev)
>  static int sd_resume_runtime(struct device *dev)
>  {
>         struct scsi_disk *sdkp = dev_get_drvdata(dev);
> -       struct scsi_device *sdp = sdkp->device;
> +       struct scsi_device *sdp;
> +
> +       if (!sdkp)      /* E.g.: runtime resume at the start of
> sd_probe() */
> +               return 0;
> +
> +       sdp = sdkp->device;
>  
>         if (sdp->ignore_media_change) {
>                 /* clear the device's sense data */

I'm fine with this, thank you.

Reviewed-by: Martin Kepplinger <martin.kepplinger@puri.sm>



