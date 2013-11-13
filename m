From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 0/2] iscsi/iser-target: Fix
Date: Wed, 13 Nov 2013 02:11:41 +0000
Message-ID: <1384308703-10034-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36733 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069Ab3KMCaI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2013 21:30:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Moussa Ba <moussaba@micron.com>, Or Gerlitz <ogerlitz@mellanox.com>, Mike Christie <michaelc@cs.wisc.edu>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

Here are the two patches to address the regression bug that Moussa
has recently been hitting with ib_isert ports + mtip32xx backends.

In the end, this bug was due to an incorrect usage of mutex_trylock(),
that was originally introduced to avoid an ib_isert specific nested
deadlock from an exception path, that inadvertently allowed normal
per RX/TX process context contention to increment sess->max_cmd_sn +
post a response + receive a new command in RX context with a CmdSN
larger than the last MaxCmdSN sychronized across RX/TX contexts.

This patch simply avoids the ib_isert callback in lio_queue_status()
for the special iscsi_execute_cmd() exception cases to avoid the
dead-lock, which allows the problematic mutex_trylock() usage in
iscsit_increment_maxcmdsn() to go away entirely.

I'll be including both of these with a CC' to stable for v3.10+

Special thanks to Moussa for helping track this bug down.

--nab

Nicholas Bellinger (2):
  iscsi-target: Fix mutex_trylock usage in iscsit_increment_maxcmdsn
  ib_isert: Avoid duplicate iscsit_increment_maxcmdsn call

 drivers/infiniband/ulp/isert/ib_isert.c      |    6 +-----
 drivers/target/iscsi/iscsi_target_configfs.c |    5 +++++
 drivers/target/iscsi/iscsi_target_device.c   |    6 +-----
 3 files changed, 7 insertions(+), 10 deletions(-)

-- 
1.7.10.4

