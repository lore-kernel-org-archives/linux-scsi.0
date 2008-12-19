From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [LIO-Target 0/14] Make logic generic for v3.0
Date: Fri, 19 Dec 2008 15:29:50 -0800
Message-ID: <1229729390.4560.100.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:39338 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752228AbYLSXaT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2008 18:30:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Greetings all,

This patch set for the Linux-iSCSI.org Target (LIO-Target) continues to
take functionality from iscsi_target_mod, and make it generic in
Target_Core_Mod/ConfigFS v3.0 so that said logic can be used across
multiple $FABRIC_MODs.  This includes moving se_device_t and
se_portal_group_t specific functionality used LIO-Target/ConfigFS from
iscsi_target_device.c and iscsi_target_tpg.c to target_core_device.c and
target_core_tpg.c respectively.

There is still some debug code enabled in this patch as the rest of the
LIO-Target functionality is brought online for Target_Core_Mod/ConfigFS
v3.0.  This debug code will be removed as development and testing
contintues for v3.0.

They are made against against lio-core-2.6.git/master and tested on
v2.6.28-rc7.  The lio-core-2.6.git tree can be found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

--nab

 drivers/lio-core/iscsi_auth_kernel.h     |   15 +-
 drivers/lio-core/iscsi_target.c          |  128 +++---
 drivers/lio-core/iscsi_target.h          |    3 +-
 drivers/lio-core/iscsi_target_configfs.c |  157 ++++---
 drivers/lio-core/iscsi_target_core.h     |   91 +---
 drivers/lio-core/iscsi_target_device.c   |  486 +-----------------
 drivers/lio-core/iscsi_target_device.h   |   15 +-
 drivers/lio-core/iscsi_target_erl0.c     |   22 +-
 drivers/lio-core/iscsi_target_erl0.h     |    2 +-
 drivers/lio-core/iscsi_target_erl1.c     |   26 +-
 drivers/lio-core/iscsi_target_erl2.c     |   21 +-
 drivers/lio-core/iscsi_target_login.c    |   90 ++--
 drivers/lio-core/iscsi_target_mib.c      |  114 +++--
 drivers/lio-core/iscsi_target_nego.c     |   19 +-
 drivers/lio-core/iscsi_target_tmr.c      |    8 +-
 drivers/lio-core/iscsi_target_tpg.c      |  809 ++++++------------------------
 drivers/lio-core/iscsi_target_tpg.h      |   25 +-
 drivers/lio-core/iscsi_target_util.c     |  227 ++-------
 drivers/lio-core/iscsi_target_util.h     |    5 -

[PATCH] [LIO-Target 1/14]: Update core data structures and defines
[PATCH] [LIO-Target 2/14]: Make iscsi_handle_authentication() use se_node_acl_t
[PATCH] [LIO-Target 3/14]: Remove what has now become generic code from iscsi_target_device.c
[PATCH] [LIO-Target 4/14]: Updates for iSCSI Target Portal Group logic with generic portal group code
[PATCH] [LIO-Target 5/14]: Make iscsi_target_util.c use generic target_core_mod code
[PATCH] [LIO-Target 6/14]: Make iSCSI TMR code use iscsi_tpg_get_node_attrib()
[PATCH] [LIO-Target 7/14]: Make ErrorRecoveryLevel=0 code use generic se_portal_group_t locks
[PATCH] [LIO-Target 8/14]: Make ErrorRecoveryLevel=1 code use iscsi_tpg_get_node_attrib()
[PATCH] [LIO-Target 9/14]: Updated ErrorRecoveryLevel=2 code to use SE_CMD(iscsi_cmd_t)
[PATCH] [LIO-Target 10/14]: Update iscsi_target_login.c for generic target_core_mod logic
[PATCH] [LIO-Target 11/14]: Update iscsi_target_nego.c for se_node_acl_t
[PATCH] [LIO-Target 12/14]: Updates for iscsi_target.c for generic target_core_mod v3.0
[PATCH] [LIO-Target/MIB 13/14]: Convert logic to use generic target_core_mod v3.0 code
[PATCH] [LIO-Target/ConfigFS 14/14]: Convert to use generic target_core_mod v3.0 logic


