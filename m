From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH] bnx2fc: fix race condition in bnx2fc_get_host_stats()
Date: Wed, 24 May 2017 08:42:40 -0400 (EDT)
Message-ID: <alpine.OSX.2.00.1705240841530.642@administrators-MacBook-Pro.local>
References: <1495627784-21048-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0082.outbound.protection.outlook.com ([104.47.32.82]:41629
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S940052AbdEXMnH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 May 2017 08:43:07 -0400
In-Reply-To: <1495627784-21048-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com


On Wed, 24 May 2017, 8:09am, Maurizio Lombardi wrote:

> If multiple tasks attempt to read the stats, it may happen
> that the start_req_done completion is re-initialized while
> still being used by another task, causing a list corruption.
> 
> This patch fixes the bug by adding a mutex to serialize the
> calls to bnx2fc_get_host_stats().
> 
> WARNING: at lib/list_debug.c:48 list_del+0x6e/0xa0() (Not tainted)
> Hardware name: PowerEdge R820
> list_del corruption. prev->next should be ffff882035627d90, but was ffff884069541588
> 
> Pid: 40267, comm: perl Not tainted 2.6.32-642.3.1.el6.x86_64 #1
> Call Trace:
>  [<ffffffff8107c691>] ? warn_slowpath_common+0x91/0xe0
>  [<ffffffff8107c796>] ? warn_slowpath_fmt+0x46/0x60
>  [<ffffffff812ad16e>] ? list_del+0x6e/0xa0
>  [<ffffffff81547eed>] ? wait_for_common+0x14d/0x180
>  [<ffffffff8106c4a0>] ? default_wake_function+0x0/0x20
>  [<ffffffff81547fd3>] ? wait_for_completion_timeout+0x13/0x20
>  [<ffffffffa05410b1>] ? bnx2fc_get_host_stats+0xa1/0x280 [bnx2fc]
>  [<ffffffffa04cf630>] ? fc_stat_show+0x90/0xc0 [scsi_transport_fc]
>  [<ffffffffa04cf8b6>] ? show_fcstat_tx_frames+0x16/0x20 [scsi_transport_fc]
>  [<ffffffff8137c647>] ? dev_attr_show+0x27/0x50
>  [<ffffffff8113b9be>] ? __get_free_pages+0xe/0x50
>  [<ffffffff812170e1>] ? sysfs_read_file+0x111/0x200
>  [<ffffffff8119a305>] ? vfs_read+0xb5/0x1a0
>  [<ffffffff8119b0b6>] ? fget_light_pos+0x16/0x50
>  [<ffffffff8119a651>] ? sys_read+0x51/0xb0
>  [<ffffffff810ee1fe>] ? __audit_syscall_exit+0x25e/0x290
>  [<ffffffff8100b0d2>] ? system_call_fastpath+0x16/0x1b
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc.h      |  1 +
>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 10 ++++++++--
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 

Thanks Maurizio.

Acked-by: Chad Dupuis <chad.dupuis@cavium.com>
