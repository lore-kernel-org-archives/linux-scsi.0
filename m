From: Bill Nottingham <notting@redhat.com>
Subject: [PATCH] Add a 'wait-scan' command to /proc/scsi/scsi.
Date: Wed, 25 Mar 2009 15:00:46 -0400
Message-ID: <1238007647-25752-1-git-send-email-notting@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44994 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbZCYTAv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2009 15:00:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Bill Nottingham <notting@redhat.com>

scsi_wait_scan.ko is a bad interface for a variety of reasons:
- once you load it, it stays in memory doing nothing
- if you need to call it again, you first need to check for the module
  and unload it first
- waiting for scsi scans shouldn't require module loading privleges in
  any case

This creates a simpler interface that doesn't require as much
scaffolding in userspace.

Signed-off-by: Bill Nottingham <notting@redhat.com>
---
 drivers/scsi/scsi_proc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index 82f7b2d..c9f9e0c 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -370,6 +370,8 @@ static ssize_t proc_scsi_write(struct file *file, const char __user *buf,
 		lun = simple_strtoul(p + 1, &p, 0);
 
 		err = scsi_remove_single_device(host, channel, id, lun);
+	} else if (!strncmp("scsi wait-scan", buffer, 14)) {
+	        err = scsi_complete_async_scans();
 	}
 
 	/*
-- 
1.6.2

