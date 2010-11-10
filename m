From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 00/16] BNX2I: Patch set to fix various bug fixes
Date: Wed, 10 Nov 2010 15:04:41 -0800
Message-ID: <1289430297-30221-1-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3606 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757260Ab0KJXDH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2010 18:03:07 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Hello,

This patch set contains various bug fixes as categorized in the following:
- scsi command handling (nop-ins, tmfs)
- various connection clean up bug fixes

Your comments are grealy appreciated.  Please review, thanks.

Eddie

Eddie Wai (16):
  BNX2I: Fixed bugs in the handling of unsolicited NOP-Ins
  BNX2I: Added fix for NOP-Out response panic from unsolicited NOP-In
  BNX2I: Fixed the endian bug in the TMF LUN cmd send
  BNX2I: Updated the handling of NETEVENTs to alleviate recovery
  BNX2I: Modified the bnx2i stop path to compensate for in progress ops
  BNX2I: Added code to handle the binding of an existing connection
  BNX2I: Fixed the remote TCP RST handling for the 570X (1g)
  BNX2I: Added mutex lock protection to conn_get_param
  BNX2I: Removed the dynamic registration of CNIC
  BNX2I: Fixed a cid leak issue for 5771X (10g)
  BNX2I: Added return code check for chip kwqe submission request
  BNX2I: Added feature to silently drop NOPOUT request
  BNX2I: Cleaned up various error conditions in ep_connect/disconnect
  BNX2I: Allow to abort the connection if connect request times out
  BNX2I: Updated copyright and maintainer info
  BNX2I: Updated version to 2.6.2.2

 drivers/scsi/bnx2i/57xx_iscsi_constants.h |    3 +-
 drivers/scsi/bnx2i/57xx_iscsi_hsi.h       |    3 +-
 drivers/scsi/bnx2i/bnx2i.h                |   18 ++--
 drivers/scsi/bnx2i/bnx2i_hwi.c            |  152 ++++++++++++++++++++-----
 drivers/scsi/bnx2i/bnx2i_init.c           |  108 ++++--------------
 drivers/scsi/bnx2i/bnx2i_iscsi.c          |  177 +++++++++++++++++++---------
 drivers/scsi/bnx2i/bnx2i_sysfs.c          |    3 +-
 drivers/scsi/libiscsi.c                   |    3 +-
 include/scsi/libiscsi.h                   |    1 +
 9 files changed, 280 insertions(+), 188 deletions(-)


