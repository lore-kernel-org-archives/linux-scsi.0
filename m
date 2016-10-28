From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Crash in TCM-LIO
Date: Fri, 28 Oct 2016 00:02:17 -0700
Message-ID: <1477638137.19735.128.camel@haakon3.risingtidesystems.com>
References: <BN6PR11MB197044D930C8512F099143A494A90@BN6PR11MB1970.namprd11.prod.outlook.com>
         <1477292393.19735.40.camel@haakon3.risingtidesystems.com>
         <BY1PR0701MB164496C3C3E05D7B686D7CEA8EA80@BY1PR0701MB1644.namprd07.prod.outlook.com>
         <1477462728.19735.95.camel@haakon3.risingtidesystems.com>
         <BY1PR0701MB16441418742EDB804D96619A8EAB0@BY1PR0701MB1644.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:47074 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936411AbcJ1HCU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Oct 2016 03:02:20 -0400
In-Reply-To: <BY1PR0701MB16441418742EDB804D96619A8EAB0@BY1PR0701MB1644.namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Gurumurthy, Anil" <Anil.Gurumurthy@cavium.com>
Cc: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Malavali, Giridhar" <Giridhar.Malavali@cavium.com>, "Tran, Quinn" <Quinn.Tran@cavium.com>, TomK <tk@mdevsys.com>

On Wed, 2016-10-26 at 09:01 +0000, Gurumurthy, Anil wrote:
> Hello Nicholas,
> 

<SNIP>

> Thanks for confirming.  The ABORT_TASK TMR_TASK_DOES_NOT_EXIST
> exceptions here do not depend on the missing SCF_ACK_KREF bit
> assignment.
> 
> The earlier SCF_ACK_KREF reference leak fix is specific to TMR that
> reference active se_cmd->cmd_kref tags, when I/O is still outstanding
> to associated target-core se_cmd->se_dev backends.
> 
> > > 
> > > On this particular kernel version (4.7), I am unable to get a crash 
> > > dump, so cannot really fathom whats going on.
> > > 
> > 
> > Note there is a v4.1+ reference leak regression for ABORT_TASK + session shutdown here:
> > 
> > https://github.com/torvalds/linux/commit/527268df31e57cf2b6d417198717c
> > 6d6afdb1e3e
> > 
> > > Have you seen or have been notified of this behaviour?
> > 
> > TomK (CC') reported something similar using v4.8.4 with ESX hosts ABORT_TASK + tcm/qla2xxx ports.
> > 
> > >   Any ideas/thoughts on how to proceed?
> > > 
> > >  
> > 
> > Currently unsure if this list corruption is related to the above regression, or not.
> > 
> > Please verify using the patch on v4.7.y code during tcm/qla2xxx
> session shutdown -> restart, once ABORT_TASK has occurred.
> > [Anil] I see the issue even when I apply this patch to my kernel.
> > 
> 
> From above + TomK's list corruption logs, it looks like a
> se_cmd->cmd_kref is prematurely reaching zero + freeing memory while
> se_cmd memory is still outstanding to target-core backend.
> 
> The se_cmd->state_list is not used by TMR, so AFAICT list corruption
> here is specific to qla_tgt_cmd->se_cmd dispatched into target-core,
> released while se_cmd is still outstanding.
> 
> To confirm verify the theory, please change the list_debug warn above
> into BUG_ON with LKCD logic in place, and let's have a look.
> 
> [Anil]
> With the BUG_ON, I pretty much see the same thing. Getting a crash
> dump has been a significant challenge - never been able to generate
> one with kernel 4.6 and later.
> 
> [ 3513.258979] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 1258720
> [ 3513.258998] qla2xxx [0000:0b:00.1]-e900:4: RESET-TMR online/active/old-count/new-count = 1/0/0/1.
> [ 3513.259045] BUG: unable to handle kernel NULL pointer dereference at 00000000000000e0
> [ 3513.259177] IP: [<ffffffff811ff52a>] kmem_cache_free+0x11a/0x200
> [ 3513.259277] PGD 0
> [ 3513.259312] Oops: 0000 [#1] SMP
> [ 3513.259362] Modules linked in: target_core_pscsi tcm_qla2xxx(OE) qla2xxx(OE) iscsi_target_mod target_core_file target_core_iblock target_core_mod netconsole ebtable_nat ebtables ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat xt_CHECKSUM iptable_mangle bridge 8021q mrp garp stp llc ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_reject_ipv6[ 3513.260012] ------------[ cut here ]------------
> [ 3513.260018] WARNING: CPU: 2 PID: 389 at lib/list_debug.c:61 __list_del_entry+0x65/0xb0
> [ 3513.260019] list_del corruption. prev->next should be ffff8806ec7c3328, but was ffff8806ec7bcf68
> [ 3513.260019] Modules linked in: target_core_pscsi tcm_qla2xxx(OE) qla2xxx(OE) iscsi_target_mod target_core_file t

Ok, so it sounds like there are two issues here.

1) The TMR list_corruption observed here with tcm_qla2xxx, and
2) >= v4.6.y CONFIG_CRASH_DUMP=y breakage in your environment.

Looking at the difference between tcm_qla2xxx in v4.x.y code:

  - v4.7.y+ contains commit e3dc0e3 to convert to private sess_kref
  - v4.6.y+ contains commit 1b655b1 to convert to target_alloc_session()
  - v4.5.y+ contains commit a07100e to fix TMR ABORT interaction issue

At this point without a vmcore to root cause #1, I'd recommend
generating a vmcore on the earliest kernel (v4.5.y) possible in order to
confirm the regression.

For >= v4.6.y CONFIG_CRASH_DUMP=y breakage in #2, it needs to be
reported to LKML.

