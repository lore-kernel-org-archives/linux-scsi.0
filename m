From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 13/20] qla2xxx: Remove dependency on hardware_lock to
 reduce lock contention.
Date: Tue, 8 Dec 2015 03:26:04 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1512080325110.2520@hadrien>
References: <201512081049.GB0meMIa%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:56910 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754652AbbLHC0T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2015 21:26:19 -0500
In-Reply-To: <201512081049.GB0meMIa%fengguang.wu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org, himanshu.madhani@qlogic.com, kbuild-all@01.org

Looks suspicious.  Please check.

julia

On Tue, 8 Dec 2015, kbuild test robot wrote:

> CC: kbuild-all@01.org
> In-Reply-To: <1449535747-2850-14-git-send-email-himanshu.madhani@qlogic.com>
> TO: Himanshu Madhani <himanshu.madhani@qlogic.com>
> CC: target-devel@vger.kernel.org, nab@linux-iscsi.org
> CC: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org, himanshu.madhani@qlogic.com
>
> Hi Quinn,
>
> [auto build test WARNING on target/master]
> [also build test WARNING on v4.4-rc4 next-20151207]
> [cannot apply to scsi/for-next]
>
> url:    https://github.com/0day-ci/linux/commits/Himanshu-Madhani/qla2xxx-Patches-for-target-pending-branch/20151208-093328
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master
> :::::: branch date: 47 minutes ago
> :::::: commit date: 47 minutes ago
>
> >> drivers/scsi/qla2xxx/qla_target.c:1091:2-8: preceding lock on line 1074
>
> git remote add linux-review https://github.com/0day-ci/linux
> git remote update linux-review
> git checkout 13bfc932c19778c08e1fc8908c4f0825fd70583f
> vim +1091 drivers/scsi/qla2xxx/qla_target.c
>
> 2d70c103 Nicholas Bellinger 2012-05-15  1068  	if (!vha->hw->tgt.tgt_ops)
> 2d70c103 Nicholas Bellinger 2012-05-15  1069  		return;
> 2d70c103 Nicholas Bellinger 2012-05-15  1070
> b2032fd5 Roland Dreier      2015-07-14  1071  	if (!tgt)
> 2d70c103 Nicholas Bellinger 2012-05-15  1072  		return;
> 2d70c103 Nicholas Bellinger 2012-05-15  1073
> 13bfc932 Quinn Tran         2015-12-07 @1074  	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
> 2d70c103 Nicholas Bellinger 2012-05-15  1075  	if (tgt->tgt_stop) {
> 13bfc932 Quinn Tran         2015-12-07  1076  		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
> 2d70c103 Nicholas Bellinger 2012-05-15  1077  		return;
> 2d70c103 Nicholas Bellinger 2012-05-15  1078  	}
> 2d70c103 Nicholas Bellinger 2012-05-15  1079  	sess = qlt_find_sess_by_port_name(tgt, fcport->port_name);
> 2d70c103 Nicholas Bellinger 2012-05-15  1080  	if (!sess) {
> 13bfc932 Quinn Tran         2015-12-07  1081  		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
> 2d70c103 Nicholas Bellinger 2012-05-15  1082  		return;
> 2d70c103 Nicholas Bellinger 2012-05-15  1083  	}
> 2d70c103 Nicholas Bellinger 2012-05-15  1084
> df673274 Alexei Potashnik   2015-07-14  1085  	if (max_gen - sess->generation < 0) {
> df673274 Alexei Potashnik   2015-07-14  1086  		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf092,
> df673274 Alexei Potashnik   2015-07-14  1087  		    "Ignoring stale deletion request for se_sess %p / sess %p"
> df673274 Alexei Potashnik   2015-07-14  1088  		    " for port %8phC, req_gen %d, sess_gen %d\n",
> df673274 Alexei Potashnik   2015-07-14  1089  		    sess->se_sess, sess, sess->port_name, max_gen,
> df673274 Alexei Potashnik   2015-07-14  1090  		    sess->generation);
> df673274 Alexei Potashnik   2015-07-14 @1091  		return;
> df673274 Alexei Potashnik   2015-07-14  1092  	}
> df673274 Alexei Potashnik   2015-07-14  1093
> 2d70c103 Nicholas Bellinger 2012-05-15  1094  	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf008, "qla_tgt_fc_port_deleted %p", sess);
>
> :::::: The code at line 1091 was first introduced by commit
> :::::: df673274fa4896f25f0bf348d2a3535d74b4cbec qla2xxx: added sess generations to detect RSCN update races
>
> :::::: TO: Alexei Potashnik <alexei@purestorage.com>
> :::::: CC: Nicholas Bellinger <nab@linux-iscsi.org>
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>
