Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AE9DC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 19:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E53A664F9F
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 19:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbhCJTGZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 14:06:25 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:32842 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233946AbhCJTGQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 14:06:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615403176; x=1646939176;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rdvveZD4rQxDmWVDDFo9BTrvpscE0jxmmT7CsSZDcJQ=;
  b=AhtrwVcrHbFThln0FhNXr3n401EvUJxhRAeG9PqBhprqjTVeE9uICjBi
   w0N5xo57M2ntmQWF25TO0Eel9wl0xv8C5vYrf15a1C0I7g2XrB+tkpSE2
   /snj4c+WLfGzSTJ+KH8BtKKERnUg46Ddk+yIKy3kLI6K5S77Wk68ksjis
   H4Sejd7sdz/UhES/jKcTaVzycR5+SdLchGl2uQUeQTUfKggwwQ3xmWL2U
   BvbKJ1a2EEDJHAteV6flNvPMGmDXkqkHrIgdzq/hEmiDQbJYsxf1Szdd2
   DtXj+cuV9omeaUgQl3MeYQ04aK2Mnfp3VR2xyUb9Cyw5KGLp8IfQGJ9Ru
   g==;
IronPort-SDR: oPbOEY+QfxDZHGoiQw9p0fyLswdH4yOy4wSWrdYFFj3yL3zwD0uQugfmr716RxxtJvLmvBA6Q4
 AVcFvMj+4BXhB4Q0M5aS47dZZv9bNBauMkhwseUbtYaClafCYp/YK7CvtckeBp4U8JM22IISDx
 wee3PD6z+Q76r97f9fc86y4tFmuoq2DWA/3GDffvSlmFHaOeUxE0VcEwmEa48VJ0xQ9+OH1VQ2
 vE2xnhEP4xUE2XmGlOcqVRPm3oBq7qaSGrFHkmKL7NtUdUw4MH/tEK0OIXc71CwJPCbhPcpoTq
 yso=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="47016504"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 12:06:15 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 12:06:12 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 12:06:12 -0700
Subject: [PATCH] hpsa: fix regression issue for old controllers
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 13:06:12 -0600
Message-ID: <161540317205.18786.5821926127237311408.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix CommandList alignment issues for old and
unsupported controllers.

This patch fixes the alignment issue reported for patch
'commit f749d8b7a989
     ("scsi: hpsa: Correct dev cmds outstanding for retried cmds")'
reported in https://lkml.org/lkml/2021/3/3/243

Patch 'commit f749d8b7a989
     ("scsi: hpsa: Correct dev cmds outstanding for retried cmds")'
removed an 'int' member field "abort_pending" and replaced it with
a 'bool' field "retry_pending". This was tested and verified both
by me and several others outside of Microchip.
  * It should be noted that the patch changed the alignment of an
    atomic_t shown in my pahole analysis below.

However, when the cciss block driver was removed from the
kernel, some old legacy cciss controllers were added into the
hpsa driver in patch 'commit 135ae6edeb51
     ("scsi: hpsa: add support for legacy boards")'

Changing the field from 'int' to 'bool' caused a command alignment
issue on these legacy controllers (reported on IA64 architectures)
but went unnoticed because we no longer have any functional test
systems supporting these controllers and also these controller
are not included in our out-of-box driver.

This patch corrects the CommandList alignment issue on
the legacy controllers by changing the 'bool' back to
an 'int'. I ran pahole against the original driver, current driver,
and on the driver built using the updated patch to verify
the alignment.

I changed setting retry_pending in the driver accordingly.

Before patch 'f749d8b7a989
     ("scsi: hpsa: Correct dev cmds outstanding for retried cmds")
   /* --- cacheline 10 boundary (640 bytes) was 4 bytes ago --- */
   struct hpsa_scsi_dev_t *   phys_disk;            /*   644     8 */
   int                        abort_pending;        /*   652     4 */
   struct hpsa_scsi_dev_t *   device;               /*   656     8 */
   atomic_t                   refcount;             /*   664     4 */

   /* size: 768, cachelines: 12, members: 16 */
   /* padding: 100 */
} __attribute__((__aligned__(128)));

Current patch 'f749d8b7a989
     ("scsi: hpsa: Correct dev cmds outstanding for retried cmds")
   /* --- cacheline 10 boundary (640 bytes) was 4 bytes ago --- */
   struct hpsa_scsi_dev_t *   phys_disk;            /*   644     8 */
   bool                       retry_pending;        /*   652     1 */
   struct hpsa_scsi_dev_t *   device;               /*   653     8 */
   atomic_t                   refcount;             /*   661     4 */

   /* size: 768, cachelines: 12, members: 16 */
   /* padding: 103 */
} __attribute__((__aligned__(128)));

After proposed patch applied:
   /* --- cacheline 10 boundary (640 bytes) was 4 bytes ago --- */
   struct hpsa_scsi_dev_t *   phys_disk;            /*   644     8 */
   int                        retry_pending;        /*   652     4 */
   struct hpsa_scsi_dev_t *   device;               /*   656     8 */
   atomic_t                   refcount;             /*   664     4 */

   /* size: 768, cachelines: 12, members: 16 */
   /* padding: 100 */
} __attribute__((__aligned__(128)));

Reported-by: Sergei Trofimovich <slyich@gmail.com>
Tested-by: Sergei Trofimovich <slyich@gmail.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/hpsa.c     |   10 +++++-----
 drivers/scsi/hpsa_cmd.h |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 38369766511c..96f26e250dae 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5593,7 +5593,7 @@ static int hpsa_ioaccel_submit(struct ctlr_info *h,
 		c->scsi_cmd = cmd;
 		c->device = dev;
 		if (retry) /* Resubmit but do not increment device->commands_outstanding. */
-			c->retry_pending = true;
+			c->retry_pending = 1;
 		rc = hpsa_scsi_ioaccel_raid_map(h, c);
 		if (rc < 0)     /* scsi_dma_map failed. */
 			rc = SCSI_MLQUEUE_HOST_BUSY;
@@ -5603,7 +5603,7 @@ static int hpsa_ioaccel_submit(struct ctlr_info *h,
 		c->scsi_cmd = cmd;
 		c->device = dev;
 		if (retry) /* Resubmit but do not increment device->commands_outstanding. */
-			c->retry_pending = true;
+			c->retry_pending = 1;
 		rc = hpsa_scsi_ioaccel_direct_map(h, c);
 		if (rc < 0)     /* scsi_dma_map failed. */
 			rc = SCSI_MLQUEUE_HOST_BUSY;
@@ -5661,7 +5661,7 @@ static void hpsa_command_resubmit_worker(struct work_struct *work)
 	 * Note: hpsa_ciss_submit does not zero out the command fields like
 	 *       ioaccel submit does.
 	 */
-	c->retry_pending = true;
+	c->retry_pending = 1;
 	if (hpsa_ciss_submit(c->h, c, cmd, dev)) {
 		/*
 		 * If we get here, it means dma mapping failed. Try
@@ -6169,7 +6169,7 @@ static struct CommandList *cmd_tagged_alloc(struct ctlr_info *h,
 	 * This is a new command obtained from queue_command so
 	 * there have not been any driver initiated retry attempts.
 	 */
-	c->retry_pending = false;
+	c->retry_pending = 0;
 
 	return c;
 }
@@ -6243,7 +6243,7 @@ static struct CommandList *cmd_alloc(struct ctlr_info *h)
 	 * cmd_alloc is for "internal" commands and they are never
 	 * retried.
 	 */
-	c->retry_pending = false;
+	c->retry_pending = 0;
 
 	return c;
 }
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index d126bb877250..e86af4e9eef0 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -448,7 +448,7 @@ struct CommandList {
 	 */
 	struct hpsa_scsi_dev_t *phys_disk;
 
-	bool retry_pending;
+	int retry_pending;
 	struct hpsa_scsi_dev_t *device;
 	atomic_t refcount; /* Must be last to avoid memset in hpsa_cmd_init() */
 } __aligned(COMMANDLIST_ALIGNMENT);

