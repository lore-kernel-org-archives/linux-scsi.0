Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C9C4C64EC4
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Feb 2023 09:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjBKI72 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Feb 2023 03:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjBKI71 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Feb 2023 03:59:27 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE4837F2C;
        Sat, 11 Feb 2023 00:59:24 -0800 (PST)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 5426F3419C4;
        Sat, 11 Feb 2023 11:59:22 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-type:content-type:date:from:from:in-reply-to
        :message-id:mime-version:references:reply-to:subject:subject:to
        :to; s=mta-01; bh=94KKcn/ZKGm3HZG93jV9vOnK6ZsJV9CdmmgF4tSOUSs=; b=
        FQgCuYCZenH2AgrqEhSJOhlspKGZaep6QLWDZfIJmwTX0rJL8PxABIm/m2TN3mqS
        TbRiHlXg2sptTYxWImsjSiNvMkcno1BxBixYYAqqGLtRr/SDuAeYHB+qqgX90IQ2
        7OsW71yHIF9BNig59JkQEoC1XhyiyARscfhBvilXQWY=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 4AE9D34191F;
        Sat, 11 Feb 2023 11:59:22 +0300 (MSK)
Received: from yadro.com (10.199.20.11) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Sat, 11 Feb
 2023 11:59:21 +0300
Date:   Sat, 11 Feb 2023 11:59:22 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     <mlombard@redhat.com>, <martin.petersen@oracle.com>,
        <mgurtovoy@nvidia.com>, <sagi@grimberg.me>,
        <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
Subject: Re: [PATCH v3 07/14] scsi: target: Fix multiple LUN_RESET handling
Message-ID: <20230211085922.GA5419@yadro.com>
References: <20230129234441.116310-1-michael.christie@oracle.com>
 <20230129234441.116310-8-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230129234441.116310-8-michael.christie@oracle.com>
X-Originating-IP: [10.199.20.11]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jan 29, 2023 at 05:44:34PM -0600, Mike Christie wrote:
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
> Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>

Actually, this patch even fixes a crash that we've just faced.
The second LUN_RESET moves the first LUN_RESET from tmr_list to its
drain_tmr_list, then the first LUN_RESET removes itself from second`s
drain_tmr_list, then the second LUN_RESET tries to remove the first from
the list and crashes because it was deleted already.
So,

Tested-by: Dmitry Bogdanov <d.bogdanov@yadro.com>

