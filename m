From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] target: Fixes for v4.12-rc1
Date: Wed,  3 May 2017 06:13:33 +0000
Message-ID: <1493792016-6435-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:42690 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750966AbdECGME (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2017 02:12:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Gary Guo <ghg@datera.io>, Bill Borsari <wgb@datera.io>, Raghu Krishnamurthy <rk@datera.io>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi all,

Here are a couple of fixes from the last weeks testing while
continuing longevity and scale out workloads on v4.x target code.

This series contains three patches.  The first is to address
a COMPARE_AND_WRITE se_cmd reference leak where the READ phase
hits a non GOOD status, observed with ESX VAAI hosts when
outstanding READ I/O reaches a point where non SAM_STAT_GOOD
status completions start to happen.

The second addresses a hung task bug observed with iscsi-target
ports while explicitly changing the active per se_node_acl
queue_depth via the existing configfs attribute, if a new iscsi
login was already forcing session reinstatement.

And the third to is avoid forcing an session reinstatement if
queue_depth is changed via configfs, but the value itself has
not changed.

The series has been verified on v4.1.y by DATERA Q/A and
automation teams.

Thank you,

--nab

Nicholas Bellinger (3):
  target: Fix compare_and_write_callback handling for non GOOD status
  iscsi-target: Set session_fall_back_to_erl0 when forcing reinstatement
  target: Don't force session reset if queue_depth does not change

 drivers/target/iscsi/iscsi_target.c          | 1 +
 drivers/target/iscsi/iscsi_target_configfs.c | 1 +
 drivers/target/iscsi/iscsi_target_login.c    | 1 +
 drivers/target/target_core_sbc.c             | 5 ++++-
 drivers/target/target_core_tpg.c             | 7 +++++++
 5 files changed, 14 insertions(+), 1 deletion(-)

-- 
1.9.1
