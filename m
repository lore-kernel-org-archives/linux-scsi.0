From: Rob Evers <revers@redhat.com>
Subject: [RFC PATCH] SCSI: Correct UA being ignored when notifying of media-changed
Date: Wed,  3 Aug 2011 09:39:18 -0400
Message-ID: <1312378758-17308-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab1HCNjW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Aug 2011 09:39:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

Unit attention commands are getting ignored when a dvd is
replaced, resulting in errors when accessing the new dvd.

This problem occurred when a system is booted in rescue
mode via dvd and the dvd is then replaced with another dvd.
Subsequent commands to a filesystem on the dvd, such as
'fsck' and 'restore' report errors.

Solution suggested by Mike Christie.

Signed-off-by: Rob Evers <revers@redhat.com>
---
 drivers/scsi/scsi_error.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a4b9cdb..725cc11 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -294,6 +294,10 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		 */
 		if (scmd->device->expecting_cc_ua) {
 			scmd->device->expecting_cc_ua = 0;
+				if (sdev->removable) {
+					sdev->changed = 1;
+					return SUCCESS;
+				}
 			return NEEDS_RETRY;
 		}
 		/*
-- 
1.7.1

