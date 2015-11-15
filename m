From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 0/2] target: kthread login failure hung task + CAW use-after-free
Date: Sun, 15 Nov 2015 00:21:41 +0000
Message-ID: <1447546903-15305-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:34217 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbbKOAVv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Nov 2015 19:21:51 -0500
Received: by obbbj7 with SMTP id bj7so80279549obb.1
        for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2015 16:21:51 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi all,

Here are two patches to address issues encountered over the
last month while stress testing with ESX hosts.

This first is hopefully the last regression around iscsi-target
changes over the last releases to create kthreads on-demand
during login negotiation.  It addresses a case that would end
up leaving left-over iscsi_target_rx_thread() in uninterruptible
sleep, if the failure occured in iscsi_target_do_tx_login_io()
attempting to send the last login response PDU.

The second is a COMPARE_AND_WRITE use-after-free bug, that
is difficult to hit for normal backends, but with just the
right scheduling delays will result in OOPsen.  The problem
centers around the use of SCF_COMPARE_AND_WRITE_POST flag
checking in target_complete_ok_work() to determine the
first or second phase processing of COMPARE_AND_WRITE.

That is, there is nothing that prevents the CAW callbacks
in target_complete_ok_work() from completing in reverse order,
so the dependency on checking cmd->se_cmd_flags is incorrect.
To address this, allow cmd->transport_complete_callback() to
propigate up 'post_ret' to target_complete_ok_work(), and
avoid se_cmd dereference after ->transport_complete_callback().

Both patches are straight-forward fixes, and have been verified
extensively on Linux + ESX hosts the last weeks.

--nab

Nicholas Bellinger (2):
  iscsi-target: Fix rx_login_comp hang after login failure
  target: Fix race for SCF_COMPARE_AND_WRITE_POST checking

 drivers/target/iscsi/iscsi_target.c      | 13 ++++++++++++-
 drivers/target/iscsi/iscsi_target_nego.c |  1 +
 drivers/target/target_core_sbc.c         | 13 +++++++++----
 drivers/target/target_core_transport.c   | 14 ++++++++------
 include/target/target_core_base.h        |  2 +-
 5 files changed, 31 insertions(+), 12 deletions(-)

-- 
1.9.1

