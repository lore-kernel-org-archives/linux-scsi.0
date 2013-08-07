From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 5/8] [SCSI] initio: Staticize local symbols
Date: Wed, 07 Aug 2013 12:56:58 +0900
Message-ID: <001501ce9322$2aee8950$80cb9bf0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:26446 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab3HGD5B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Aug 2013 23:57:01 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MR5007AP6YEM730@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Wed, 07 Aug 2013 12:57:00 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: 'James Bottomley' <jejb@kernel.org>, linux-scsi@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>

These local symbols are used only in this file.
Fix the following sparse warnings:

drivers/scsi/initio.c:338:6: warning: symbol 'initio_se2_ew_en' was not declared. Should it be static?
drivers/scsi/initio.c:352:6: warning: symbol 'initio_se2_ew_ds' was not declared. Should it be static?
drivers/scsi/initio.c:897:22: warning: symbol 'initio_find_busy_scb' was not declared. Should it be static?
drivers/scsi/initio.c:935:22: warning: symbol 'initio_find_done_scb' was not declared. Should it be static?
drivers/scsi/initio.c:1673:5: warning: symbol 'initio_state_7' was not declared. Should it be static?
drivers/scsi/initio.c:1759:5: warning: symbol 'initio_xpad_in' was not declared. Should it be static?
drivers/scsi/initio.c:1783:5: warning: symbol 'initio_xpad_out' was not declared. Should it be static?
drivers/scsi/initio.c:1808:5: warning: symbol 'initio_status_msg' was not declared. Should it be static?
drivers/scsi/initio.c:1858:5: warning: symbol 'int_initio_busfree' was not declared. Should it be static?
drivers/scsi/initio.c:1928:5: warning: symbol 'int_initio_resel' was not declared. Should it be static?
drivers/scsi/initio.c:2384:5: warning: symbol 'initio_bus_device_reset' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/initio.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 1befc26..527b247 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -335,7 +335,7 @@ static void initio_se2_instr(unsigned long base, u8 instr)
  *
  *	Enable erase/write state of serial EEPROM
  */
-void initio_se2_ew_en(unsigned long base)
+static void initio_se2_ew_en(unsigned long base)
 {
 	initio_se2_instr(base, 0x30);	/* EWEN */
 	outb(0, base + TUL_NVRAM);	/* -CS  */
@@ -349,7 +349,7 @@ void initio_se2_ew_en(unsigned long base)
  *
  *	Disable erase/write state of serial EEPROM
  */
-void initio_se2_ew_ds(unsigned long base)
+static void initio_se2_ew_ds(unsigned long base)
 {
 	initio_se2_instr(base, 0);	/* EWDS */
 	outb(0, base + TUL_NVRAM);	/* -CS  */
@@ -894,7 +894,8 @@ static void initio_unlink_busy_scb(struct initio_host * host, struct scsi_ctrl_b
 	return;
 }
 
-struct scsi_ctrl_blk *initio_find_busy_scb(struct initio_host * host, u16 tarlun)
+static struct scsi_ctrl_blk *initio_find_busy_scb(struct initio_host *host,
+						u16 tarlun)
 {
 	struct scsi_ctrl_blk *tmp, *prev;
 	u16 scbp_tarlun;
@@ -932,7 +933,7 @@ static void initio_append_done_scb(struct initio_host * host, struct scsi_ctrl_b
 	}
 }
 
-struct scsi_ctrl_blk *initio_find_done_scb(struct initio_host * host)
+static struct scsi_ctrl_blk *initio_find_done_scb(struct initio_host *host)
 {
 	struct scsi_ctrl_blk *tmp;
 
@@ -1670,7 +1671,7 @@ static int initio_state_6(struct initio_host * host)
  *
  */
 
-int initio_state_7(struct initio_host * host)
+static int initio_state_7(struct initio_host *host)
 {
 	int cnt, i;
 
@@ -1756,7 +1757,7 @@ static int initio_xfer_data_out(struct initio_host * host)
 	return 0;		/* return to OS, wait xfer done , let jas_isr come in */
 }
 
-int initio_xpad_in(struct initio_host * host)
+static int initio_xpad_in(struct initio_host *host)
 {
 	struct scsi_ctrl_blk *scb = host->active;
 	struct target_control *active_tc = host->active_tc;
@@ -1780,7 +1781,7 @@ int initio_xpad_in(struct initio_host * host)
 	}
 }
 
-int initio_xpad_out(struct initio_host * host)
+static int initio_xpad_out(struct initio_host *host)
 {
 	struct scsi_ctrl_blk *scb = host->active;
 	struct target_control *active_tc = host->active_tc;
@@ -1805,7 +1806,7 @@ int initio_xpad_out(struct initio_host * host)
 	}
 }
 
-int initio_status_msg(struct initio_host * host)
+static int initio_status_msg(struct initio_host *host)
 {				/* status & MSG_IN */
 	struct scsi_ctrl_blk *scb = host->active;
 	u8 msg;
@@ -1855,7 +1856,7 @@ int initio_status_msg(struct initio_host * host)
 
 
 /* scsi bus free */
-int int_initio_busfree(struct initio_host * host)
+static int int_initio_busfree(struct initio_host *host)
 {
 	struct scsi_ctrl_blk *scb = host->active;
 
@@ -1925,7 +1926,7 @@ static int int_initio_scsi_rst(struct initio_host * host)
  *	and continue processing that command.
  */
 
-int int_initio_resel(struct initio_host * host)
+static int int_initio_resel(struct initio_host *host)
 {
 	struct scsi_ctrl_blk *scb;
 	struct target_control *active_tc;
@@ -2381,7 +2382,7 @@ static void initio_select_atn3(struct initio_host * host, struct scsi_ctrl_blk *
  *	Perform a device reset and abort all pending SCBs for the
  *	victim device
  */
-int initio_bus_device_reset(struct initio_host * host)
+static int initio_bus_device_reset(struct initio_host *host)
 {
 	struct scsi_ctrl_blk *scb = host->active;
 	struct target_control *active_tc = host->active_tc;
-- 
1.7.10.4


