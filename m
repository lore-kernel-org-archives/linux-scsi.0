From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] scsi: silence an overflow warning
Date: Wed, 18 Mar 2015 11:21:09 +0300
Message-ID: <20150318082109.GA10434@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29597 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbbCRIVb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2015 04:21:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

Static checkers complain that these sprintf() calls can overflow one
character.  It's clear that the original author just forget to account
for the NUL character.

It is unlikely that we will have a billion SCSI hosts.  Even if we do,
when you consider alignment, then the overflow is going to happen in
padding and thus the overflow is not harmful.  But it costs us nothing
to fix this and it silences a static checker warning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index 251598e..a5d7464 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -138,7 +138,7 @@ void scsi_proc_host_add(struct Scsi_Host *shost)
 {
 	struct scsi_host_template *sht = shost->hostt;
 	struct proc_dir_entry *p;
-	char name[10];
+	char name[12];
 
 	if (!sht->proc_dir)
 		return;
@@ -158,7 +158,7 @@ void scsi_proc_host_add(struct Scsi_Host *shost)
  */
 void scsi_proc_host_rm(struct Scsi_Host *shost)
 {
-	char name[10];
+	char name[12];
 
 	if (!shost->hostt->proc_dir)
 		return;
