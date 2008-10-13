From: Levy_Jerome@emc.com
Subject: [PATCH 1/1] scsi_dh: fix boot oops with EMC Clariion
Date: Mon, 13 Oct 2008 13:41:03 -0400
Message-ID: <6416EE16C1AF1E4C86882867E4DD0FF602B1F971@CORPUSMX40B.corp.emc.com>
References: <6416EE16C1AF1E4C86882867E4DD0FF6026D1BF1@CORPUSMX40B.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:47188 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbYJMRtu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Oct 2008 13:49:50 -0400
Content-class: urn:content-classes:message
In-Reply-To: <6416EE16C1AF1E4C86882867E4DD0FF6026D1BF1@CORPUSMX40B.corp.emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Patch to fix intermittent but frequent oops occurring with multiple
paths to Clariion at boot. 
Cause is uninitialized rq->flags variable which presents garbage from
clariion_activate.

Signed-off-by: Jerry Levy <levy_jerome@emc.com>
---------------------
--- drivers/scsi/device_handler/scsi_dh_emc.orig        2008-10-13
13:33:35.000000000 -0400
+++ drivers/scsi/device_handler/scsi_dh_emc.c   2008-10-09
16:20:15.000000000 -0400
@@ -283,6 +283,7 @@
        memset(rq->cmd, 0, BLK_MAX_CDB);
        rq->cmd[0] = cmd;
        rq->cmd_len = COMMAND_SIZE(cmd);
+       rq->flags = 0;

        switch (cmd) {
        case MODE_SELECT:
