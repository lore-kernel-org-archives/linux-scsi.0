From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 1/4] scsi_cmnd: Rearrange and shrink some elements
Date: Thu, 18 Oct 2007 04:46:12 -0400
Message-ID: <1192697175888-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:33175 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868AbXJRIpy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 04:45:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

By
 - rearranging the elements of the scsi_pointer
 - shrinking and moving the eh_eflags element
 - turning sc_data_direction into an unsigned char
 - moving tag

we achieve a size reduction in scsi_cmnd of 376 to 352 bytes on x86-64
and from 272 to 260 bytes on i386.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 include/scsi/scsi_cmnd.h |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 047ffe6..04fe0d8 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -13,22 +13,21 @@ struct Scsi_Host;
 struct scsi_device;
 
 struct scsi_data_buffer {
+	struct scatterlist* sglist;
 	unsigned length;
 	int resid;
 	unsigned short sg_count;
 	unsigned short alloc_sg_count;
-	struct scatterlist* sglist;
 };
 
 /* embedded in scsi_cmnd */
 struct scsi_pointer {
 	char *ptr;		/* data pointer */
-	int this_residual;	/* left in this buffer */
 	struct scatterlist *buffer;	/* which buffer */
+	dma_addr_t dma_handle;
+	int this_residual;	/* left in this buffer */
 	int buffers_residual;	/* how many buffers left */
 
-        dma_addr_t dma_handle;
-
 	volatile int Status;
 	volatile int Message;
 	volatile int have_data_in;
@@ -40,7 +39,6 @@ struct scsi_cmnd {
 	struct scsi_device *device;
 	struct list_head list;  /* scsi_cmnd participates in queue lists */
 	struct list_head eh_entry; /* entry for the host eh_cmd_q */
-	int eh_eflags;		/* Used by error handlr */
 
 	/*
 	 * A SCSI Command is assigned a nonzero serial_number before passed
@@ -64,7 +62,9 @@ struct scsi_cmnd {
 	int timeout_per_command;
 
 	unsigned char cmd_len;
-	enum dma_data_direction sc_data_direction;
+	unsigned char eh_eflags;		/* Used by error handler */
+	unsigned char sc_data_direction;	/* enum dma_data_direction */
+	unsigned char tag;			/* SCSI-II queued command tag */
 
 	/* These elements define the operation we are about to perform */
 #define MAX_COMMAND_SIZE	16
@@ -82,8 +82,7 @@ struct scsi_cmnd {
 				   reconnects.   Probably == sector
 				   size */
 
-	struct request *request;	/* The command we are
-				   	   working on */
+	struct request *request;	/* The command we are working on */
 
 #define SCSI_SENSE_BUFFERSIZE 	96
 	unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE];
@@ -111,8 +110,6 @@ struct scsi_cmnd {
 
 	int result;		/* Status code from lower level driver */
 
-	unsigned char tag;	/* SCSI-II queued command tag */
-
 	union {
 		struct scsi_data_buffer sdb;
 		/*
@@ -121,11 +118,11 @@ struct scsi_cmnd {
 		 *        of struct scsi_data_buffer members.
 		 */
 		struct {
+			void __deprecated *request_buffer;
 			unsigned __deprecated request_bufflen;
 			int __deprecated resid;
 			unsigned short __deprecated use_sg;
 			unsigned short __deprecated place_holder_sg_alloc;
-			void __deprecated *request_buffer;
 		};
 	};
 };
-- 
1.4.4.2

