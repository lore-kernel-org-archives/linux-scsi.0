From: Yum Rayan <yum.rayan@gmail.com>
Subject: [PATCH]megaraid_sas: Reduce stack usage in megasas_probe_one()
Date: Wed, 20 Apr 2005 00:59:43 -0700
Message-ID: <df35dfeb0504200059279a4417@mail.gmail.com>
Reply-To: Yum Rayan <yum.rayan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.198]:49978 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261470AbVDTH7q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 03:59:46 -0400
Received: by wproxy.gmail.com with SMTP id 68so82257wri
        for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2005 00:59:43 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreenivas.Bagalkote@lsil.com
Cc: linux-scsi@vger.kernel.org

This patch reduces stack usage in megasas_probe_one() from to 2200 to
156. A patched version of gcc 3.4.3 with -fno-unit-at-a-time disabled
was used on i386 platform.

Signed-off-by: Yum Rayan <yum.rayan@gmail.com>

--- linux-2.6.12-rc2-mm3.a/drivers/scsi/megaraid/megaraid_sas.c	2005-04-14
22:15:44.000000000 -0700
+++ linux-2.6.12-rc2-mm3.b/drivers/scsi/megaraid/megaraid_sas.c	2005-04-20
00:26:01.000000000 -0700
@@ -731,7 +731,7 @@
 	struct megasas_register_set*	reg_set;
 
 	struct megasas_cmd*		cmd;
-	struct megasas_ctrl_info	ctrl_info;
+	struct megasas_ctrl_info	*ctrl_info;
 
 	struct megasas_init_frame*	init_frame;
 	struct megasas_init_queue_info*	initq_info;
@@ -846,15 +846,19 @@
 
 	megasas_return_cmd( instance, cmd );
 
+	ctrl_info = kmalloc(sizeof(struct megasas_ctrl_info), GFP_KERNEL);
+
 	/*
 	 * Gather misc FW related information
 	 */
-	if (!megasas_get_ctrl_info( instance, &ctrl_info ))
-		instance->max_sectors_per_req = ctrl_info.max_request_size;
+	if (ctrl_info && !megasas_get_ctrl_info( instance, ctrl_info ))
+		instance->max_sectors_per_req = ctrl_info->max_request_size;
 	else
 		instance->max_sectors_per_req = instance->max_num_sge *
 						PAGE_SIZE / 512;
 
+	kfree(ctrl_info);
+
 	return 0;
 
 fail_fw_init:
