From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH] target: Fix NULL dereference during LUN lookup + active
 I/O shutdown
Date: Thu, 23 Feb 2017 11:46:29 -0600
Message-ID: <1fd6d4ca-c010-f4c1-5586-127a6595ac53@linux.vnet.ibm.com>
References: <1487832999-3390-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35879 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751223AbdBWRqk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Feb 2017 12:46:40 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1NHiwZ2043172
        for <linux-scsi@vger.kernel.org>; Thu, 23 Feb 2017 12:46:39 -0500
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 28syh4pp2q-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 23 Feb 2017 12:46:39 -0500
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
        Thu, 23 Feb 2017 10:46:37 -0700
In-Reply-To: <1487832999-3390-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Rob Millner <rlm@daterainc.com>, Vaibhav Tandon <vst@datera.io>


> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> When transport_clear_lun_ref() is shutting down a se_lun via
> configfs with new I/O in-flight, it's possible to trigger a
> NULL pointer dereference in transport_lookup_cmd_lun() due
> to the fact percpu_ref_get() doesn't do any __PERCPU_REF_DEAD
> checking before incrementing lun->lun_ref.count after
> lun->lun_ref has switched to atomic_t mode.
>
> This results in a NULL pointer dereference as LUN shutdown
> code in core_tpg_remove_lun() continues running after the
> existing ->release() -> core_tpg_lun_ref_release() callback
> completes, and clears the RCU protected se_lun->lun_se_dev
> pointer.
>
> During the OOPs, the state of lun->lun_ref in the process
> which triggered the NULL pointer dereference looks like
> the following on v4.1.y stable code:
>
> struct se_lun {
>    lun_link_magic = 4294932337,
>    lun_status = TRANSPORT_LUN_STATUS_FREE,
>
>    .....
>
>    lun_se_dev = 0x0,
>    lun_sep = 0x0,
>
>    .....
>
>    lun_ref = {
>      count = {
>        counter = 1
>      },
>      percpu_count_ptr = 3,
>      release = 0xffffffffa02fa1e0 <core_tpg_lun_ref_release>,
>      confirm_switch = 0x0,
>      force_atomic = false,
>      rcu = {
>        next = 0xffff88154fa1a5d0,
>        func = 0xffffffff8137c4c0 <percpu_ref_switch_to_atomic_rcu>
>      }
>    }
> }
>
> To address this bug, use percpu_ref_tryget_live() to ensure
> once __PERCPU_REF_DEAD is visable on all CPUs and ->lun_ref
> has switched to atomic_t, all new I/Os will fail to obtain
> a new lun->lun_ref reference.
>
> Also use an explicit percpu_ref_kill_and_confirm() callback
> to block on ->lun_ref_comp to allow the first stage and
> associated RCU grace period to complete, and then block on
> ->lun_ref_shutdown waiting for the final percpu_ref_put()
> to drop the last reference via transport_lun_remove_cmd()
> before continuing with core_tpg_remove_lun() shutdown.
>
> Reported-by: Rob Millner <rlm@daterainc.com>
> Tested-by: Rob Millner <rlm@daterainc.com>
> Cc: Rob Millner <rlm@daterainc.com>
> Tested-by: Vaibhav Tandon <vst@datera.io>
> Cc: Vaibhav Tandon <vst@datera.io>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/target_core_device.c    | 10 ++++++++--
>   drivers/target/target_core_tpg.c       |  3 ++-
>   drivers/target/target_core_transport.c | 31 ++++++++++++++++++++++++++++++-
>   include/target/target_core_base.h      |  1 +
>   4 files changed, 41 insertions(+), 4 deletions(-)
>
I have seen this and have tested this with our custom kernel.

So this looks good from me!

-Bryant
