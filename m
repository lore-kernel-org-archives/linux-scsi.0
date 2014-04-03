From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 0/9] target: Allow fabric to expose PI + add WRITE_INSERT/READ_STRIP
Date: Thu,  3 Apr 2014 09:35:44 +0000
Message-ID: <1396517753-23546-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:50089 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbaDCJ64 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2014 05:58:56 -0400
Received: by mail-ob0-f182.google.com with SMTP id uz6so1663098obc.41
        for <linux-scsi@vger.kernel.org>; Thu, 03 Apr 2014 02:58:56 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi MKP, Sagi, Quinn & Co,

This series allows fabric drivers to expose what TARGET_PROT hardware
operations they support at session initialization time, along with
adding proper WRITE_INSERT/READ_STRIP emulation support (as originally
mentioned by Sagi) into target-core.

This allows legacy initiator ports and/or legacy fabrics to interact
using hardware (or software) offloads together with T10 PI enabled
backend devices.

The code allows for the same backend device to report PROTECT=1
across one protected fabric port, while reporting PROTECT=0 to another
and performing locally generated WRITE_INSERT/READ_STRIP software
operations.

So far this is working across a RAMDISK_MCP backend using loopback
in existing TARGET_PROT PASS mode, and a traditional iSCSI target port
using WRITE_INSERT/READ_STRIP.

Please review.

--nab

Nicholas Bellinger (9):
  target/iblock: Fix double bioset_integrity_free bug
  target: Pass in transport supported PI at session initialization
  target/spc: Only expose PI inquiry bits when supported by fabric
  target/spc: Only expose PI mode page bits when supported by fabric
  target/sbc: Only expose PI read_cap16 bits when supported by fabric
  target/sbc: Add sbc_dif_write_insert software emulation
  target: Enable WRITE_INSERT emulation in target_execute_cmd
  target/sbc: Add sbc_dif_read_strip software emulation
  target: Enable READ_STRIP emulation in target_complete_ok_work

 drivers/infiniband/ulp/isert/ib_isert.c   |   13 +++++
 drivers/infiniband/ulp/srpt/ib_srpt.c     |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c        |    2 +-
 drivers/target/iscsi/iscsi_target.c       |    6 +++
 drivers/target/iscsi/iscsi_target_login.c |    4 +-
 drivers/target/loopback/tcm_loop.c        |    2 +-
 drivers/target/sbp/sbp_target.c           |    2 +-
 drivers/target/target_core_iblock.c       |    5 +-
 drivers/target/target_core_sbc.c          |   82 ++++++++++++++++++++++++++---
 drivers/target/target_core_spc.c          |   49 ++++++++++-------
 drivers/target/target_core_transport.c    |   50 ++++++++++++++++--
 drivers/target/tcm_fc/tfc_sess.c          |    3 +-
 drivers/usb/gadget/tcm_usb_gadget.c       |    2 +-
 drivers/vhost/scsi.c                      |    3 +-
 include/target/iscsi/iscsi_transport.h    |    1 +
 include/target/target_core_backend.h      |    2 +
 include/target/target_core_base.h         |   19 ++++---
 include/target/target_core_fabric.h       |    5 +-
 18 files changed, 205 insertions(+), 47 deletions(-)

-- 
1.7.10.4

