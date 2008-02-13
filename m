From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] scsi_transport_iscsi.c: make 2 functions static
Date: Wed, 13 Feb 2008 23:30:17 +0200
Message-ID: <20080213213017.GA3383@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55704 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763622AbYBMVad (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:33 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- __iscsi_unblock_session()
- iscsi_session_state_name()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/scsi_transport_iscsi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

c7b0a4c74538d3a53cd7325a5ad0f2ae774ebb94 diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index fac7534..9981682 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -231,7 +231,7 @@ static struct {
 	{ ISCSI_SESSION_FREE,		"FREE" },
 };
 
-const char *iscsi_session_state_name(int state)
+static const char *iscsi_session_state_name(int state)
 {
 	int i;
 	char *name = NULL;
@@ -373,7 +373,7 @@ static void session_recovery_timedout(struct work_struct *work)
 	scsi_target_unblock(&session->dev);
 }
 
-void __iscsi_unblock_session(struct iscsi_cls_session *session)
+static void __iscsi_unblock_session(struct iscsi_cls_session *session)
 {
 	if (!cancel_delayed_work(&session->recovery_work))
 		flush_workqueue(iscsi_eh_timer_workq);

