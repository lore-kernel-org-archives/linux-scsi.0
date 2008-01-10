From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] another SCSI bug fix for 2.6.24-rc7
Date: Thu, 10 Jan 2008 09:35:35 -0600
Message-ID: <1199979335.3141.34.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44873 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755785AbYAJPfk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jan 2008 10:35:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This one's a fatal bug in the qla1280 32 bit descriptor handling, since
the unitialised req_cnt variable is used to count the number of
descriptor slots.  It turns out that qla1280 only uses 32 bit
descriptors on x86 if HIGHMEM isn't enabled, which is why it's taken so
long to find someone with a configuration that actually saw the problem.

The patch is available from:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

I've also attached it below for convenience.

James

---

>From 3a43e69ce50d467ded2f17f6e571e831d3677ab5 Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <tomof@acm.org>
Date: Tue, 8 Jan 2008 23:07:01 +0900
Subject: [SCSI] qla1280: fix 32 bit segment code

There's an error remaining in the 32 bit descriptor code after the
conversion to dma accessors:  req_cnt is left uninitialised.

qla1280_32bit_start_scsi gives the following warnings:

drivers/scsi/qla1280.c: In function 'qla1280_32bit_start_scsi':
drivers/scsi/qla1280.c:3044: warning: unused variable 'dma_handle'
drivers/scsi/qla1280.c: In function 'qla1280_queuecommand':
drivers/scsi/qla1280.c:3060: warning: 'req_cnt' is used uninitialized in this function
drivers/scsi/qla1280.c:3042: note: 'req_cnt' was declared here

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/qla1280.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 146d540..2886407 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -3041,7 +3041,6 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	int cnt;
 	int req_cnt;
 	int seg_cnt;
-	dma_addr_t dma_handle;
 	u8 dir;
 
 	ENTER("qla1280_32bit_start_scsi");
@@ -3050,6 +3049,7 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 		cmd->cmnd[0]);
 
 	/* Calculate number of entries and segments required. */
+	req_cnt = 1;
 	seg_cnt = scsi_dma_map(cmd);
 	if (seg_cnt) {
 		/*
-- 
1.5.3.7




