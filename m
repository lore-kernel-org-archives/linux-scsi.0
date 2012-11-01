From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Re-add explict zeroing of INQUIRY bounce buffer memory
Date: Thu,  1 Nov 2012 05:13:08 +0000
Message-ID: <1351746788-25985-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36632 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab2KAFT1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Nov 2012 01:19:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Kelsey Prantis <kelsey.prantis@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Andy Grover <agrover@redhat.com>, stable@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a regression in spc_emulate_inquiry() code where the
local scope bounce buffer was no longer getting it's memory zeroed,
causing various problems with SCSI initiators that depend upon areas
of INQUIRY EVPD=0x83 payload having been zeroed.

This bug was introduced with the following v3.7-rc1 patch + CC'ed
stable commit:

commit ffe7b0e9326d9c68f5688bef691dd49f1e0d3651
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri Sep 7 17:30:38 2012 +0200

    target: support zero allocation length in INQUIRY

Go ahead and re-add the missing memset of bounce buffer memory to be
copied into the outgoing se_cmd descriptor kmapped SGL payload.

Reported-by: Kelsey Prantis <kelsey.prantis@intel.com>
Cc: Kelsey Prantis <kelsey.prantis@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andy Grover <agrover@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_spc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 9229bd9..6fd434d 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -605,6 +605,8 @@ static int spc_emulate_inquiry(struct se_cmd *cmd)
 	unsigned char buf[SE_INQUIRY_BUF];
 	int p, ret;
 
+	memset(buf, 0, SE_INQUIRY_BUF);
+
 	if (dev == tpg->tpg_virt_lun0.lun_se_dev)
 		buf[0] = 0x3f; /* Not connected */
 	else
-- 
1.7.2.5

