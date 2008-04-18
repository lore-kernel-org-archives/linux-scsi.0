From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 3/3] zfcp: Fix error handling for blocked unit for send FCP command
Date: Fri, 18 Apr 2008 12:51:57 +0200
Message-ID: <20080418105456.235253000@de.ibm.com>
References: <20080418105154.135704000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:52562 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbYDRKy7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Apr 2008 06:54:59 -0400
Content-Disposition: inline; filename=zfcp-fix-goto-send-fcp.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Martin Peschke <mp3@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

In the case the unit is blocked, zfcp_unit_get has not been called
yet, so the error handling path should not call zfcp_unit_put.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2008-04-18 12:43:05.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-04-18 12:43:13.000000000 +0200
@@ -3562,8 +3562,8 @@ zfcp_fsf_send_fcp_command_task(struct zf
  send_failed:
  no_fit:
  failed_scsi_cmnd:
- unit_blocked:
 	zfcp_unit_put(unit);
+ unit_blocked:
 	zfcp_fsf_req_free(fsf_req);
 	fsf_req = NULL;
 	scsi_cmnd->host_scribble = NULL;

-- 
