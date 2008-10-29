From: akpm@linux-foundation.org
Subject: [patch 16/17] megaraid: fix mega_internal_command oops
Date: Wed, 29 Oct 2008 14:24:48 -0700
Message-ID: <200810292124.m9TLOmVu021317@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754548AbYJ2VZG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2008 17:25:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp, Bo.Yang@lsi.com, bharrosh@panasas.com, pterjan@gmail.com

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

scsi_cmnd->cmnd was changed from a static array to a pointer post
2.6.25. It breaks mega_internal_command():

static int
mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
{
...
	scb = &adapter->int_scb;
	memset(scb, 0, sizeof(scb_t));

	scmd = &adapter->int_scmd;
	memset(scmd, 0, sizeof(Scsi_Cmnd));

	sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
	scmd->device = sdev;

	scmd->device->host = adapter->host;
	scmd->host_scribble = (void *)scb;
	scmd->cmnd[0] = MEGA_INTERNAL_CMD;

mega_internal_command() uses scsi_cmnd allocated internally so
scmd->cmnd is NULL here. This patch adds a static array for cdb to
adapter_t and uses it here. This also uses
scsi_allocate_command/scsi_free_command, the recommended way to
allocate struct scsi_cmnd since the driver might use sense_buffer in
struct scsi_cmnd.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=11792

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Reviewed-by: Boaz Harrosh <bharrosh@panasas.com>
Tested-by: Pascal Terjan <pterjan@gmail.com>
Reported-by: Pascal Terjan <pterjan@gmail.com>
Cc: "Yang, Bo" <Bo.Yang@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid.c |   11 ++++++++---
 drivers/scsi/megaraid.h |    2 +-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/megaraid.c~megaraid-fix-mega_internal_command-oops drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~megaraid-fix-mega_internal_command-oops
+++ a/drivers/scsi/megaraid.c
@@ -4402,6 +4402,10 @@ mega_internal_command(adapter_t *adapter
 	scb_t	*scb;
 	int	rval;
 
+	scmd = scsi_allocate_command(GFP_KERNEL);
+	if (!scmd)
+		return -ENOMEM;
+
 	/*
 	 * The internal commands share one command id and hence are
 	 * serialized. This is so because we want to reserve maximum number of
@@ -4412,12 +4416,11 @@ mega_internal_command(adapter_t *adapter
 	scb = &adapter->int_scb;
 	memset(scb, 0, sizeof(scb_t));
 
-	scmd = &adapter->int_scmd;
-	memset(scmd, 0, sizeof(Scsi_Cmnd));
-
 	sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
 	scmd->device = sdev;
 
+	memset(adapter->int_cdb, 0, sizeof(adapter->int_cdb));
+	scmd->cmnd = adapter->int_cdb;
 	scmd->device->host = adapter->host;
 	scmd->host_scribble = (void *)scb;
 	scmd->cmnd[0] = MEGA_INTERNAL_CMD;
@@ -4456,6 +4459,8 @@ mega_internal_command(adapter_t *adapter
 
 	mutex_unlock(&adapter->int_mtx);
 
+	scsi_free_command(GFP_KERNEL, scmd);
+
 	return rval;
 }
 
diff -puN drivers/scsi/megaraid.h~megaraid-fix-mega_internal_command-oops drivers/scsi/megaraid.h
--- a/drivers/scsi/megaraid.h~megaraid-fix-mega_internal_command-oops
+++ a/drivers/scsi/megaraid.h
@@ -888,8 +888,8 @@ typedef struct {
 
 	u8	sglen;	/* f/w supported scatter-gather list length */
 
+	unsigned char int_cdb[MAX_COMMAND_SIZE];
 	scb_t			int_scb;
-	Scsi_Cmnd		int_scmd;
 	struct mutex		int_mtx;	/* To synchronize the internal
 						commands */
 	struct completion	int_waitq;	/* wait queue for internal
_
