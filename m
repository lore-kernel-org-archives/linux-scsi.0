From: Fengguang Wu <fengguang.wu@intel.com>
Subject: bfa_ioc.c:3407 code aligned with following code on line 3409
Date: Thu, 20 Sep 2012 16:58:56 +0800
Message-ID: <20120920085856.GA6724@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6145 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191Ab2ITI7B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2012 04:59:01 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Krishna Gudipati <kgudipat@brocade.com>
Cc: kernel-janitors@vger.kernel.org, James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

Hi Krishna,

According to these (old) coccinelle warnings, bfa_cb_sfp_state_query() has very
weird indents and "if" blocks:

  drivers/scsi/bfa/bfa_ioc.c:3407:3-18: code aligned with following code on line 3409
  drivers/scsi/bfa/bfa_ioc.c:3415:4-19: code aligned with following code on line 3417

        3400 static void
        3401 bfa_cb_sfp_state_query(struct bfa_sfp_s *sfp)
        3402 {
        3403         bfa_trc(sfp, sfp->portspeed);
        3404         if (sfp->media) {
        3405                 bfa_sfp_media_get(sfp);
        3406                 if (sfp->state_query_cbfn)
>       3407                         sfp->state_query_cbfn(sfp->state_query_cbarg,
        3408                                         sfp->status);
        3409                         sfp->media = NULL;
        3410                 }
        3411 
        3412                 if (sfp->portspeed) {
        3413                         sfp->status = bfa_sfp_speed_valid(sfp, sfp->portspeed);
        3414                         if (sfp->state_query_cbfn)
        3415                                 sfp->state_query_cbfn(sfp->state_query_cbarg,
        3416                                                 sfp->status);
>       3417                                 sfp->portspeed = BFA_PORT_SPEED_UNKNOWN;
        3418                 }
        3419 
        3420                 sfp->state_query_lock = 0;
        3421                 sfp->state_query_cbfn = NULL;
        3422 }

The code was introduced by

commit 51e569aa1f0c10bd71af05e76e4ba0e42c51e4ab
Author:     Krishna Gudipati <kgudipat@brocade.com>
Commit:     James Bottomley <JBottomley@Parallels.com>
CommitDate: Wed Jun 29 17:22:26 2011 -0500

    [SCSI] bfa: Added support to obtain SFP info.

Thanks,
Fengguang
