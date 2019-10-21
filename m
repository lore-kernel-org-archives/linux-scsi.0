Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBD3CA9EBE
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 09:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D23420830
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 09:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbfJUJxn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 05:53:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:48890 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727912AbfJUJxd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Oct 2019 05:53:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0D218BAC4;
        Mon, 21 Oct 2019 09:53:29 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 23/24] scsi: Kill DRIVER_MEDIA, DRIVER_SOFT, and DRIVER_BUSY
Date:   Mon, 21 Oct 2019 11:53:21 +0200
Message-Id: <20191021095322.137969-24-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191021095322.137969-1-hare@suse.de>
References: <20191021095322.137969-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Unused.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/message/fusion/mptscsih.c | 2 +-
 drivers/scsi/constants.c          | 2 +-
 include/scsi/scsi.h               | 8 --------
 include/trace/events/scsi.h       | 5 +----
 4 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index f0737c57ed5f..0064547cef1a 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -703,7 +703,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 		case MPI_IOCSTATUS_BUSY:			/* 0x0002 */
 		case MPI_IOCSTATUS_INSUFFICIENT_RESOURCES:	/* 0x0006 */
 			/* CHECKME!
-			 * Maybe: DRIVER_BUSY | SUGGEST_RETRY | DID_SOFT_ERROR (retry)
+			 * Maybe: SUGGEST_RETRY | DID_SOFT_ERROR (retry)
 			 * But not: DID_BUS_BUSY lest one risk
 			 * killing interrupt handler:-(
 			 */
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 57c544fd8c6b..be7eacb67841 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -407,7 +407,7 @@ static const char * const hostbyte_table[]={
 "DID_NEXUS_FAILURE" };
 
 static const char * const driverbyte_table[]={
-"DRIVER_OK", "DRIVER_BUSY", "DRIVER_SOFT",  "DRIVER_MEDIA"};
+"DRIVER_OK"};
 
 const char *scsi_hostbyte_string(int result)
 {
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index b7960ec46c9c..d10308651f0a 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -161,14 +161,6 @@ static inline int scsi_is_wlun(u64 lun)
 #define DID_MEDIUM_ERROR  0x13  /* Medium error */
 #define DRIVER_OK       0x00	/* Driver status                           */
 
-/*
- *  These indicate the error that occurred, and what is available.
- */
-
-#define DRIVER_BUSY         0x01
-#define DRIVER_SOFT         0x02
-#define DRIVER_MEDIA        0x03
-
 /*
  * Internal return values.
  */
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index b2d3ce9e3990..5984db6996bb 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -127,10 +127,7 @@
 #define scsi_driverbyte_name(result)	{ result, #result }
 #define show_driverbyte_name(val)				\
 	__print_symbolic(val,					\
-		scsi_driverbyte_name(DRIVER_OK),		\
-		scsi_driverbyte_name(DRIVER_BUSY),		\
-		scsi_driverbyte_name(DRIVER_SOFT),		\
-		scsi_driverbyte_name(DRIVER_MEDIA))
+		scsi_driverbyte_name(DRIVER_OK))
 
 #define scsi_msgbyte_name(result)	{ result, #result }
 #define show_msgbyte_name(val)					\
-- 
2.16.4

