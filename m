Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E62E2C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 07:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0427610A5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 07:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240221AbhJGHB4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 03:01:56 -0400
Received: from comms.puri.sm ([159.203.221.185]:46186 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233511AbhJGHBx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Oct 2021 03:01:53 -0400
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id D628EE0D56;
        Wed,  6 Oct 2021 23:59:29 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Hipv_NAuIO4g; Wed,  6 Oct 2021 23:59:29 -0700 (PDT)
Message-ID: <905cf8dc63a2e909f61b8265f630d18a542ea62e.camel@puri.sm>
Subject: Re: [PATCH 3/3] scsi: pm: Only runtime resume if necessary
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Date:   Thu, 07 Oct 2021 08:59:24 +0200
In-Reply-To: <20211006215453.3318929-4-bvanassche@acm.org>
References: <20211006215453.3318929-1-bvanassche@acm.org>
         <20211006215453.3318929-4-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Am Mittwoch, dem 06.10.2021 um 14:54 -0700 schrieb Bart Van Assche:
> The following query shows which drivers define callbacks that are
> called
> by the power management support code in the SCSI core (scsi_pm.c):
> 
> $ git grep -nHEwA16 "$(echo $(git grep -h 'scsi_register_driver(&' |
>       sed 's/.*&//;s/\..*//') | sed 's/ /|/g')" |
>     grep '\.pm[[:blank:]]*=[[:blank:]]'
> drivers/scsi/sd.c-620-          .pm             = &sd_pm_ops,
> drivers/scsi/sr.c-100-          .pm             = &sr_pm_ops,
> drivers/scsi/ufs/ufshcd.c-9765-         .pm = &ufshcd_wl_pm_ops,
> 
> Since unconditionally runtime resuming a device during system resume
> is
> not necessary, remove that code. Modify the SCSI disk (sd) driver
> such
> that it follows the same approach as the UFS driver, namely to skip
> system suspend and resume for devices that are runtime suspended. The
> CD-ROM code does not need to be updated since its PM callbacks do not
> affect the device power state.
> 
> This patch has been tested as follows:
> 
> [ shell 1 ]
> 
> cd /sys/kernel/debug/tracing
> grep -E
> 'blk_(pre|post)_runtime|runtime_(suspend|resume)|autosuspend_delay|pm
> _runtime_(get|put)' available_filter_functions |
>   while read a b; do echo "$a"; done |
>   grep -v __pm_runtime_resume >set_ftrace_filter
> echo function > current_tracer
> echo 1 > tracing_on
> cat trace_pipe
> 
> [ shell 2 ]
> 
> cd /sys/block/sr0
>  # Increase the event poll interval to make it easier to derive from
> the
>  # tracing output whether runtime power actions are the result of
> sg_inq.
> echo 30000 > events_poll_msecs
> cd device/power
>  # Enable runtime power management.
> echo auto > control
> echo 1000 > autosuspend_delay_ms
> sleep 1
>  # Verify in shell 1 that sr0 has been runtime suspended
> sg_inq /dev/sr0
> eject /dev/sr0
> sg_inq /dev/sr0
>  # Disable runtime power management.
> echo on > control
> 
> cd /sys/block/sda/device/power
> echo auto > control
> echo 1000 > autosuspend_delay_ms
> sleep 1
>  # Verify in shell 1 that sr0 has been runtime suspended
> sg_inq /dev/sda
> 
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Martin Kepplinger <martin.kepplinger@puri.sm>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_pm.c | 69 +++++++++-------------------------------
> --
>  drivers/scsi/sd.c      |  6 ++++
>  2 files changed, 20 insertions(+), 55 deletions(-)
> 


Tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>

on my system with a runtime-suspend enabled sd cardreader.

thanks,
                             martin


