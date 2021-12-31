Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC2F3C43217
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Dec 2021 02:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242553AbhLaCQM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Dec 2021 21:16:12 -0500
Received: from smtp.infotech.no ([82.134.31.41]:46081 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242546AbhLaCQL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Dec 2021 21:16:11 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 1E86A2041CB;
        Fri, 31 Dec 2021 03:08:47 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fFfh8VW146ie; Fri, 31 Dec 2021 03:08:45 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-45-58-208-241.dyn.295.ca [45.58.208.241])
        by smtp.infotech.no (Postfix) with ESMTPA id 49EF02041AF;
        Fri, 31 Dec 2021 03:08:40 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Subject: [PATCH 9/9] scsi_debug: add environmental reporting log subpage
Date:   Thu, 30 Dec 2021 21:08:29 -0500
Message-Id: <20211231020829.29147-10-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211231020829.29147-1-dgilbert@interlog.com>
References: <20211231020829.29147-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Log subpages are starting to appear in real devices (e.g. SSDs)
so add support for one. Adopt approach where all "wild"
sub-pages are themselves listed as long as there is at least
one non-wild page or subpage for a given page number.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index ba4a5a7dd25f..6e981c4b6379 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2793,6 +2793,18 @@ static int resp_ie_l_pg(unsigned char *arr)
 	return sizeof(ie_l_pg);
 }
 
+static int resp_env_rep_l_spg(unsigned char *arr)
+{
+	unsigned char env_rep_l_spg[] = {0x0, 0x0, 0x23, 0x8,
+					 0x0, 40, 72, 0xff, 45, 18, 0, 0,
+					 0x1, 0x0, 0x23, 0x8,
+					 0x0, 55, 72, 35, 55, 45, 0, 0,
+		};
+
+	memcpy(arr, env_rep_l_spg, sizeof(env_rep_l_spg));
+	return sizeof(env_rep_l_spg);
+}
+
 #define SDEBUG_MAX_LSENSE_SZ 512
 
 static int resp_log_sense(struct scsi_cmnd *scp,
@@ -2845,26 +2857,47 @@ static int resp_log_sense(struct scsi_cmnd *scp,
 			arr[n++] = 0xff;	/* this page */
 			arr[n++] = 0xd;
 			arr[n++] = 0x0;		/* Temperature */
+			arr[n++] = 0xd;
+			arr[n++] = 0x1;		/* Environment reporting */
+			arr[n++] = 0xd;
+			arr[n++] = 0xff;	/* all 0xd subpages */
 			arr[n++] = 0x2f;
 			arr[n++] = 0x0;	/* Informational exceptions */
+			arr[n++] = 0x2f;
+			arr[n++] = 0xff;	/* all 0x2f subpages */
 			arr[3] = n - 4;
 			break;
 		case 0xd:	/* Temperature subpages */
 			n = 4;
 			arr[n++] = 0xd;
 			arr[n++] = 0x0;		/* Temperature */
+			arr[n++] = 0xd;
+			arr[n++] = 0x1;		/* Environment reporting */
+			arr[n++] = 0xd;
+			arr[n++] = 0xff;	/* these subpages */
 			arr[3] = n - 4;
 			break;
 		case 0x2f:	/* Informational exceptions subpages */
 			n = 4;
 			arr[n++] = 0x2f;
 			arr[n++] = 0x0;		/* Informational exceptions */
+			arr[n++] = 0x2f;
+			arr[n++] = 0xff;	/* these subpages */
 			arr[3] = n - 4;
 			break;
 		default:
 			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, 5);
 			return check_condition_result;
 		}
+	} else if (subpcode > 0) {
+		arr[0] |= 0x40;
+		arr[1] = subpcode;
+		if (pcode == 0xd && subpcode == 1)
+			arr[3] = resp_env_rep_l_spg(arr + 4);
+		else {
+			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, 5);
+			return check_condition_result;
+		}
 	} else {
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 3, -1);
 		return check_condition_result;
-- 
2.25.1

