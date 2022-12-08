Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6DEEC4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 09:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiLHJW0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 04:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiLHJWF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 04:22:05 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324FD3A6;
        Thu,  8 Dec 2022 01:22:00 -0800 (PST)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 1581A34173A;
        Thu,  8 Dec 2022 12:21:58 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-type:content-type:date:from:from:in-reply-to
        :message-id:mime-version:references:reply-to:subject:subject:to
        :to; s=mta-01; bh=bKZShlJKcjpZATsiXr4kIE3rlUZNn3BBKZbDgQWf1ik=; b=
        hs05Za6dDBUk1dvIHwgzhc63hk/kDAiOSXdIDUlIMkCB2ysBI++KkeOurjo/8qOj
        GMD8F4WxHmDh9VY7v/YE20B7+NeWB31qPh1HSQ7CMXuwuTTZ0RfG803Oq4Z+1WRo
        HAaFDaIYyl/y3KyruANxagBVqGaZwVNcdAfAJv7d+2s=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 083B8341736;
        Thu,  8 Dec 2022 12:21:58 +0300 (MSK)
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Thu, 8 Dec 2022
 12:21:57 +0300
Date:   Thu, 8 Dec 2022 12:21:56 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     <mlombard@redhat.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
Subject: Re: [PATCH 7/7] scsi: target: Fix multiple LUN_RESET handling
Message-ID: <20221208092156.GB15327@yadro.com>
References: <20221208031002.106700-1-michael.christie@oracle.com>
 <20221208031002.106700-8-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221208031002.106700-8-michael.christie@oracle.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 07, 2022 at 09:10:02PM -0600, Mike Christie wrote:
> 
> This fixes a bug where an initiator thinks a LUN_RESET has cleaned
> up running commands when it hasn't. The bug was added in:
> 
> commit 51ec502a3266 ("target: Delete tmr from list before processing")
> 
> The problem occurs when:
> 
> 1. We have N IO cmds running in the target layer spread over 2 sessions.
> 2. The initiator sends a LUN_RESET for each session.
> 3. session1's LUN_RESET loops over all the running commands from both
> sessions and moves them to its local drain_task_list.
> 4. session2's LUN_RESET does not see the LUN_RESET from session1 because
> the commit above has it remove itself. session2 also does not see any
> commands since the other reset moved them off the state lists.
> 5. sessions2's LUN_RESET will then complete with a successful response.
> 6. sessions2's inititor believes the running commands on its session are
> now cleaned up due to the successful response and cleans up the running
> commands from its side. It then restarts them.
> 7. The commands do eventually complete on the backend and the target
> starts to return aborted task statuses for them. The initiator will
> either throw a invalid ITT error or might accidentally lookup a new task
> if the ITT has been reallocated already.
> 
> This fixes the bug by reverting the patch.
> 
> Fixes: 51ec502a3266 ("target: Delete tmr from list before processing")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/target/target_core_tmr.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
> index bac111456fa1..ba2a2c18dae9 100644
> --- a/drivers/target/target_core_tmr.c
> +++ b/drivers/target/target_core_tmr.c
> @@ -188,9 +188,10 @@ static void core_tmr_drain_tmr_list(
>          * LUN_RESET tmr..
>          */
>         spin_lock_irqsave(&dev->se_tmr_lock, flags);
> -       if (tmr)
> -               list_del_init(&tmr->tmr_list);
>         list_for_each_entry_safe(tmr_p, tmr_pp, &dev->dev_tmr_list, tmr_list) {
> +               if (tmr_p == tmr)
> +                       continue;
> +
>                 cmd = tmr_p->task_cmd;
>                 if (!cmd) {
>                         pr_err("Unable to locate struct se_cmd for TMR\n");
> --
> 2.25.1
> 

Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>



