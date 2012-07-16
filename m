From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 0/7] series to fix qla2xxx use-after-free
Date: Mon, 16 Jul 2012 11:04:35 -0700
Message-ID: <1342461882-5848-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog102.obsmtp.com ([74.125.245.72]:36328 "HELO
	na3sys010aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753112Ab2GPSEs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2012 14:04:48 -0400
Received: by pbbrp2 with SMTP id rp2so10492739pbb.28
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jul 2012 11:04:47 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

Hi Nic,

Here's a series that's fundamentally about fixing a use-after-free in
qla_target code.  It ends up being seven patches because I wanted to
make each step easy to review, and several of these are just cleanups
that stand on their own.

We have a few more qla2xxx-related fixes that I need to clean up and
merge with the latest.  I'll send them soon.

Roland Dreier (7):
  qla2xxx: Get rid of redundant qla_tgt_sess.tearing_down
  target: Un-export target_get_sess_cmd()
  sbp-target: Consolidate duplicated error path code in
    sbp_handle_command()
  target: Allow for target_submit_cmd() returning errors
  target: Check sess_tearing_down in target_get_sess_cmd()
  qla2xxx: Remove racy, now-redundant check of sess_tearing_down
  target: Remove se_session.sess_wait_list

 drivers/scsi/qla2xxx/qla_target.c      |   16 ++--------
 drivers/scsi/qla2xxx/qla_target.h      |    1 -
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |   10 +++---
 drivers/target/sbp/sbp_target.c        |   36 ++++++++++-----------
 drivers/target/target_core_transport.c |   55 ++++++++++++++++++++------------
 drivers/target/tcm_fc/tfc_cmd.c        |    8 +++--
 drivers/usb/gadget/tcm_usb_gadget.c    |   20 +++++-------
 include/target/target_core_base.h      |    1 -
 include/target/target_core_fabric.h    |    5 ++-
 9 files changed, 73 insertions(+), 79 deletions(-)

-- 
1.7.10.4

