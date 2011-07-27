From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] target: Allow demo-mode sessions with INQUIRY 'not connected' status
Date: Wed, 27 Jul 2011 00:45:15 +0000
Message-ID: <1311727518-1927-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:52606 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab1G0BIy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2011 21:08:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Roland Dreier <roland@purestorage.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Roland and Andrew,

Here is the series for target_core v4.1 (lio-core-2.6.git/master) to allow
demo-mode I_T FC nexuses (struct se_session) to login without the active
fabric Port/LUNs appearing as the default layout with generate_node_acl=1
WWPN endpoint access.

This also changes standard INQUIRY response to set 0x3f (not connected) status
as recommended by Roland for those fabrics like tcm_qla2xxx that expect to have
initiators be at least able login and recognize 'not connected' status with the
default virtual LUN=0 device.  This is expected by modern qla2xxx initiators,
and will currently cause ABORT -> DEVICE_RESET when we explictly disable
demo-mode access for the WWPN and only allow explict NodeACLs+MappedLUNs to
establish a FC Nexus.

The main question here is if running 'not connected' as the default for virtual LUN=0
access is OK for all cases here.  Any comments folks..?

With the series, the following lio-core-2.6.git/master commit is also being reverted

   commit a138af3ef3b199226ad2cc3ffb24c494302d0f4c
   Author: Nicholas Bellinger <nab@linux-iscsi.org>
   Date:   Mon Jul 25 22:11:43 2011 +0000

    tcm_qla2xxx: Remove Demo-mode by default settings

Thanks,

Nicholas Bellinger (3):
  target: Change TCM_NON_EXISTENT_LUN response to ASC=LOGICAL UNIT NOT
    SUPPORTED
  target: Make standard INQUIRY return 'not connected' for
    tpg_virt_lun0
  tcm_qla2xxx: Add tfo->tpg_check_demo_mode_login_only usage

 drivers/target/target_core_cdb.c                  |   11 ++++++++---
 drivers/target/target_core_tpg.c                  |   12 ++++++++++--
 drivers/target/target_core_transport.c            |    7 +++++++
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c |    2 ++
 include/target/target_core_fabric_ops.h           |    6 ++++++
 5 files changed, 33 insertions(+), 5 deletions(-)

-- 
1.7.2.5

