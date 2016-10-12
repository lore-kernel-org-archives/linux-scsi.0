From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: [PATCH 2/2] sr: Drop custom handling of unit attention
Date: Wed, 12 Oct 2016 02:25:21 -0300
Message-ID: <1476249921-17017-2-git-send-email-krisman@linux.vnet.ibm.com>
References: <1476249921-17017-1-git-send-email-krisman@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33052 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751529AbcJLFZ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Oct 2016 01:25:58 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9C5Nl35126526
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 01:25:40 -0400
Received: from e24smtp02.br.ibm.com (e24smtp02.br.ibm.com [32.104.18.86])
        by mx0a-001b2d01.pphosted.com with ESMTP id 261dxxjnp7-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 01:25:39 -0400
Received: from localhost
        by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
        Wed, 12 Oct 2016 02:25:37 -0300
Received: from d24relay04.br.ibm.com (d24relay04.br.ibm.com [9.18.232.146])
        by d24dlp02.br.ibm.com (Postfix) with ESMTP id 995031DC0054
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 01:25:34 -0400 (EDT)
Received: from d24av03.br.ibm.com (d24av03.br.ibm.com [9.8.31.95])
        by d24relay04.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u9C5PY9939911650
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 02:25:34 -0300
Received: from d24av03.br.ibm.com (localhost [127.0.0.1])
        by d24av03.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u9C5PYFN004707
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 02:25:34 -0300
In-Reply-To: <1476249921-17017-1-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com
Cc: brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

This is no longer necessary, since we handle it in scsi_execute.

Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
---
 drivers/scsi/sr_ioctl.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 03054c0e7689..f7724e52fd0f 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -179,8 +179,7 @@ static int sr_play_trkind(struct cdrom_device_info *cdi,
 }
 
 /* We do our own retries because we want to know what the specific
-   error code is.  Normally the UNIT_ATTENTION code will automatically
-   clear after one error */
+   error code is. */
 
 int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 {
@@ -220,8 +219,6 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 			if (!cgc->quiet)
 				sr_printk(KERN_INFO, cd,
 					  "disc change detected.\n");
-			if (retries++ < 10)
-				goto retry;
 			err = -ENOMEDIUM;
 			break;
 		case NOT_READY:	/* This happens if there is no disc in drive */
-- 
2.7.4

