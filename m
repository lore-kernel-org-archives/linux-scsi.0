From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/4] target: LUN_RESET bugfixes for HW target mode
Date: Thu, 29 Sep 2011 22:25:12 -0700
Message-ID: <1317360312.27478.89.camel@haakon2.linux-iscsi.org>
References: <1317358511-10664-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39480 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab1I3FZV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Sep 2011 01:25:21 -0400
In-Reply-To: <1317358511-10664-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>

On Fri, 2011-09-30 at 04:55 +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Hi folks,
> 
> This patch series addresses a number of issues that have come up recently for
> TMR LUN_RESET operation with HW target mode + qla2xxx/tcm_qla2xxx code.  Aside
> from the various bugfixes in this series, the big change is the re-org of
> core_tmr_lun_reset() logic to prevent possible list corruption while scanning
> the various lists and breaking this out of this code into seperate functions.
> 
> I know the re-org patch diff is very difficult to read without more context, so
> apologies ahead of time for that.  At this point it makes sense to queue these
> for v3.2, and CC stable to ensure they are also picked up for v3.1 target code
> as well.
> 
> Please let us know if you have any comments.
> 
> Thank you,
> 
> --nab
> 
> Nicholas Bellinger (3):
>   target: Re-org of core_tmr_lun_reset + FREE_CMD_INTR bugfix
>   target: Fix transport_cmd_finish_abort queue removal bug
>   target: Prevent transport_send_task_abort when CHECK_CONDITION status
> 
> Roland Dreier (1):
>   target: Prevent cmd->se_queue_node double add
> 
>  drivers/target/target_core_tmr.c       |  228 ++++++++++++++++++++------------
>  drivers/target/target_core_transport.c |   45 ++++---
>  2 files changed, 169 insertions(+), 104 deletions(-)
> 

Hi again folks,

The full context for 'Re-org of core_tmr_lun_reset + FREE_CMD_INTR
bugfix' can be found here for review.

http://www.risingtidesystems.com/git/?p=lio-core-2.6.git;a=blob;f=drivers/target/target_core_tmr.c;h=89459086e68628a87a77dd086c6136871db86f0b;hb=HEAD#l104

Thanks,

--nab

