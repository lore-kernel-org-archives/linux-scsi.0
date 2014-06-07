From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.15
Date: Sat, 07 Jun 2014 11:18:04 -0700
Message-ID: <1402165084.16568.10.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:37201 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbaFGSSP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Jun 2014 14:18:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Hi Linus,

Here are the remaining fixes for v3.15.  Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

This series includes:

  - iser-target fix for ImmediateData exception reference count bug (Sagi + nab)
  - iscsi-target fix for MC/S login + potential iser-target MRDSL buffer
    overrun (Santosh + Roland)
  - iser-target fix for v3.15-rc multi network portal shutdown regression (nab)
  - target fix for allowing READ_CAPCITY during ALUA Standby access state
    (Chris + nab)
  - target fix for NULL pointer dereference of alua_access_state for
    un-configured devices (Chris + nab) 

Thank you,

--nab

Nicholas Bellinger (4):
  iser-target: Add missing target_put_sess_cmd for ImmedateData failure
  iser-target: Fix multi network portal shutdown regression
  target: Allow READ_CAPACITY opcode in ALUA Standby access state
  target: Fix alua_access_state attribute OOPs for un-configured
    devices

Roland Dreier (1):
  iscsi-target: Fix wrong buffer / buffer overrun in
    iscsi_change_param_value()

 drivers/infiniband/ulp/isert/ib_isert.c   |    2 +
 drivers/target/iscsi/iscsi_target.c       |    1 +
 drivers/target/iscsi/iscsi_target_login.c |   70 +++++++++++++----------------
 drivers/target/iscsi/iscsi_target_tpg.c   |    3 +-
 drivers/target/target_core_alua.c         |    9 ++++
 drivers/target/target_core_configfs.c     |    5 +++
 6 files changed, 50 insertions(+), 40 deletions(-)

