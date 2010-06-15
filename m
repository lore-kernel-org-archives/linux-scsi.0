From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 21/23] bfa: fix wrong arg to callback
Date: Tue, 15 Jun 2010 11:51:51 -0700
Message-ID: <1276627911-12170-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:44645 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758269Ab0FOSvz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2010 14:51:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: vravindr@brocade.com, rvadivel@brocade.com, kgudipat@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

This patch fixes the issue of passing wrong argument to callback function.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_port.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_port.c b/drivers/scsi/bfa/bfa_port.c
index 6773e22..c7e69f1 100644
--- a/drivers/scsi/bfa/bfa_port.c
+++ b/drivers/scsi/bfa/bfa_port.c
@@ -407,7 +407,7 @@ bfa_port_hbfail(void *arg)
 	 */
 	if (port->stats_busy) {
 		if (port->stats_cbfn)
-			port->stats_cbfn(port->dev, BFA_STATUS_FAILED);
+			port->stats_cbfn(port->stats_cbarg, BFA_STATUS_FAILED);
 		port->stats_cbfn = NULL;
 		port->stats_busy = BFA_FALSE;
 	}
@@ -417,7 +417,7 @@ bfa_port_hbfail(void *arg)
 	 */
 	if (port->endis_pending) {
 		if (port->endis_cbfn)
-			port->endis_cbfn(port->dev, BFA_STATUS_FAILED);
+			port->endis_cbfn(port->endis_cbarg, BFA_STATUS_FAILED);
 		port->endis_cbfn = NULL;
 		port->endis_pending = BFA_FALSE;
 	}
-- 
1.6.5.2

