From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 6/9] iscsi update: set correct state at creation time
Date: Wed, 01 Feb 2006 21:07:06 -0600
Message-ID: <1138849626.3456.39.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:32180 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1423072AbWBBDHf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2006 22:07:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

>From erezz@voltaire.com:

We are still in ISCSI_STATE_FREE state at create time. The addition
of the first connection puts us in ISCSI_STATE_LOGGED_IN.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 7965c46..f5ba940 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -3267,7 +3267,7 @@ iscsi_session_create(struct scsi_transpo
 	session = iscsi_hostdata(shost->hostdata);
 	memset(session, 0, sizeof(struct iscsi_session));
 	session->host = shost;
-	session->state = ISCSI_STATE_LOGGED_IN;
+	session->state = ISCSI_STATE_FREE;
 	session->mgmtpool_max = ISCSI_MGMT_CMDS_MAX;
 	session->cmds_max = ISCSI_XMIT_CMDS_MAX;
 	session->cmdsn = initial_cmdsn;


