From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 00/14] BNX2I: Patch set to fix various bug fixes
Date: Thu, 18 Nov 2010 17:29:55 -0800
Message-ID: <1290130209-32133-1-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3479 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab0KSCGt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2010 21:06:49 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Hello,

>This patch set contains various bug fixes as categorized in the following:
>- scsi command handling (nop-ins, tmfs)
>- various connection clean up bug fixes
In v2, the following patches are modified based on Mike Christie's comments:
  BNX2I: Added mutex lock protection to conn_get_param (rm ret 0)
  BNX2I: Removed the dynamic registration of CNIC (trailing space)

These patches were removed pending better resolution:
  BNX2I: Updated the handling of NETEVENTs to alleviate recovery
  BNX2I: Added code to handle the binding of an existing connection

Your comments are grealy appreciated.  Please review, thanks.

Eddie

Eddie Wai (14):
  BNX2I: Fixed bugs in the handling of unsolicited NOP-Ins
  BNX2I: Added fix for NOP-Out response panic from unsolicited NOP-In
  BNX2I: Fixed the endian bug in the TMF LUN cmd send
  BNX2I: Fixed a cid leak issue for 5771X (10g)
  BNX2I: Fixed the remote TCP RST handling for the 570X (1g)
  BNX2I: Allow to abort the connection if connect request times out
  BNX2I: Added mutex lock protection to conn_get_param
  BNX2I: Removed the dynamic registration of CNIC
  BNX2I: Modified the bnx2i stop path to compensate for in progress ops
  BNX2I: Added return code check for chip kwqe submission request
  BNX2I: Added feature to silently drop NOPOUT request
  BNX2I: Cleaned up various error conditions in ep_connect/disconnect
  BNX2I: Updated copyright and maintainer info
  BNX2I: Updated version to 2.6.2.1

 drivers/scsi/bnx2i/57xx_iscsi_constants.h |    3 +-
 drivers/scsi/bnx2i/57xx_iscsi_hsi.h       |    3 +-
 drivers/scsi/bnx2i/bnx2i.h                |   15 ++--
 drivers/scsi/bnx2i/bnx2i_hwi.c            |   99 +++++++++++++-----
 drivers/scsi/bnx2i/bnx2i_init.c           |  108 ++++---------------
 drivers/scsi/bnx2i/bnx2i_iscsi.c          |  164 +++++++++++++++++++----------
 drivers/scsi/bnx2i/bnx2i_sysfs.c          |    3 +-
 drivers/scsi/libiscsi.c                   |    3 +-
 include/scsi/libiscsi.h                   |    1 +
 9 files changed, 216 insertions(+), 183 deletions(-)


