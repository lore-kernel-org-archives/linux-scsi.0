Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B5AC433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 12:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D161212CC
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 12:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgFPMSd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Jun 2020 08:18:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:37474 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728643AbgFPMSb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Jun 2020 08:18:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 385A0AEE5;
        Tue, 16 Jun 2020 12:18:33 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/4] gdth: kill __gdth_execute()
Date:   Tue, 16 Jun 2020 14:18:20 +0200
Message-Id: <20200616121821.99113-4-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200616121821.99113-1-hare@suse.de>
References: <20200616121821.99113-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

gdth_execute() is just a wrapper around __gdth_execute(), which
tries to allocate the host device, too.
But the host device is required for other code paths, too, so
we should allocate it during pci init, kill the original
gdth_execute() and rename __gdth_execute() to gdth_execute().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/gdth.c      | 52 ++++++++++++++++++------------------------------
 drivers/scsi/gdth_proc.c | 16 +++++++--------
 drivers/scsi/gdth_proc.h |  2 +-
 3 files changed, 28 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index b62ecfc24bb6..6b509ba40017 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -332,10 +332,9 @@ static void gdth_scsi_done(struct scsi_cmnd *scp)
 		scp->scsi_done(scp);
 }
 
-static int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd,
-			  char *cmnd, int timeout, u32 *info)
+int gdth_execute(gdth_ha_str *ha, gdth_cmd_str *gdtcmd, char *cmnd,
+	int timeout, u32 *info)
 {
-	gdth_ha_str *ha = shost_priv(sdev->host);
 	struct scsi_cmnd *scp;
 	struct gdth_cmndinfo cmndinfo;
 	DECLARE_COMPLETION_ONSTACK(wait);
@@ -351,7 +350,7 @@ static int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd,
 		return -ENOMEM;
 	}
 
-	scp->device = sdev;
+	scp->device = ha->sdev;
 	memset(&cmndinfo, 0, sizeof(cmndinfo));
 
 	/* use request field to save the ptr. to completion struct. */
@@ -375,16 +374,6 @@ static int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd,
 	return rval;
 }
 
-int gdth_execute(struct Scsi_Host *shost, gdth_cmd_str *gdtcmd, char *cmnd,
-		 int timeout, u32 *info)
-{
-	struct scsi_device *sdev = scsi_get_host_dev(shost);
-	int rval = __gdth_execute(sdev, gdtcmd, cmnd, timeout, info);
-
-	scsi_free_host_dev(sdev);
-	return rval;
-}
-
 static void gdth_eval_mapping(u32 size, u32 *cyls, int *heads, int *secs)
 {
 	*cyls = size /HEADS/SECS;
@@ -3446,15 +3435,6 @@ static int __gdth_queuecommand(gdth_ha_str *ha, struct scsi_cmnd *scp,
 
 static int gdth_open(struct inode *inode, struct file *filep)
 {
-	gdth_ha_str *ha;
-
-	mutex_lock(&gdth_mutex);
-	list_for_each_entry(ha, &gdth_instances, list) {
-		if (!ha->sdev)
-			ha->sdev = scsi_get_host_dev(ha->shost);
-	}
-	mutex_unlock(&gdth_mutex);
-
 	TRACE(("gdth_open()\n"));
 	return 0;
 }
@@ -3558,7 +3538,7 @@ static int ioc_resetdrv(void __user *arg, char *cmnd)
 	else
 		cmd.u.cache.DeviceNo = res.number;
 
-	rval = __gdth_execute(ha->sdev, &cmd, cmnd, 30, NULL);
+	rval = gdth_execute(ha, &cmd, cmnd, 30, NULL);
 	if (rval < 0)
 		return rval;
 	res.status = rval;
@@ -3690,8 +3670,8 @@ static int ioc_general(void __user *arg, char *cmnd)
 			goto out_free_buf;
 	}
 
-	rval = __gdth_execute(ha->sdev, &gen.command, cmnd, gen.timeout,
-			      &gen.info);
+	rval = gdth_execute(ha, &gen.command, cmnd, gen.timeout,
+			    &gen.info);
 	if (rval < 0)
 		goto out_free_buf;
 	gen.status = rval;
@@ -3749,7 +3729,8 @@ static int ioc_hdrlist(void __user *arg, char *cmnd)
 				cmd->u.cache64.DeviceNo = i;
 			else
 				cmd->u.cache.DeviceNo = i;
-			if (__gdth_execute(ha->sdev, cmd, cmnd, 30, &cluster_type) == S_OK)
+			if (gdth_execute(ha, cmd, cmnd, 30,
+					 &cluster_type) == S_OK)
 				rsc->hdr_list[i].cluster_type = cluster_type;
 		}
 	}
@@ -3799,7 +3780,7 @@ static int ioc_rescan(void __user *arg, char *cmnd)
 			cmd->u.cache.DeviceNo = LINUX_OS;
 		}
 
-		status = __gdth_execute(ha->sdev, cmd, cmnd, 30, &info);
+		status = gdth_execute(ha, cmd, cmnd, 30, &info);
 		i = 0;
 		hdr_cnt = (status == S_OK ? (u16)info : 0);
 	} else {
@@ -3815,7 +3796,7 @@ static int ioc_rescan(void __user *arg, char *cmnd)
 		else
 			cmd->u.cache.DeviceNo = i;
 
-		status = __gdth_execute(ha->sdev, cmd, cmnd, 30, &info);
+		status = gdth_execute(ha, cmd, cmnd, 30, &info);
 
 		spin_lock_irqsave(&ha->smp_lock, flags);
 		rsc->hdr_list[i].bus = ha->virt_bus;
@@ -3849,7 +3830,7 @@ static int ioc_rescan(void __user *arg, char *cmnd)
 		else
 			cmd->u.cache.DeviceNo = i;
 
-		status = __gdth_execute(ha->sdev, cmd, cmnd, 30, &info);
+		status = gdth_execute(ha, cmd, cmnd, 30, &info);
 
 		spin_lock_irqsave(&ha->smp_lock, flags);
 		ha->hdr[i].devtype = (status == S_OK ? (u16)info : 0);
@@ -3862,7 +3843,7 @@ static int ioc_rescan(void __user *arg, char *cmnd)
 		else
 			cmd->u.cache.DeviceNo = i;
 
-		status = __gdth_execute(ha->sdev, cmd, cmnd, 30, &info);
+		status = gdth_execute(ha, cmd, cmnd, 30, &info);
 
 		spin_lock_irqsave(&ha->smp_lock, flags);
 		ha->hdr[i].cluster_type =
@@ -3877,7 +3858,7 @@ static int ioc_rescan(void __user *arg, char *cmnd)
 		else
 			cmd->u.cache.DeviceNo = i;
 
-		status = __gdth_execute(ha->sdev, cmd, cmnd, 30, &info);
+		status = gdth_execute(ha, cmd, cmnd, 30, &info);
 
 		spin_lock_irqsave(&ha->smp_lock, flags);
 		ha->hdr[i].rw_attribs = (status == S_OK ? (u16)info : 0);
@@ -4070,7 +4051,7 @@ static void gdth_flush(gdth_ha_str *ha)
 			TRACE2(("gdth_flush(): flush ha %d drive %d\n",
 				ha->hanum, i));
 
-			gdth_execute(ha->shost, &gdtcmd, cmnd, 30, NULL);
+			gdth_execute(ha, &gdtcmd, cmnd, 30, NULL);
 		}
 	}
 }
@@ -4208,6 +4189,9 @@ static int gdth_pci_probe_one(gdth_pci_str *pcistr, gdth_ha_str **ha_out)
 		goto out_free_pmsg;
 	list_add_tail(&ha->list, &gdth_instances);
 
+	ha->sdev = scsi_get_host_dev(shp);
+	if (!ha->sdev)
+		goto out_unlink;
 	pci_set_drvdata(ha->pdev, ha);
 	gdth_timer_init();
 
@@ -4217,6 +4201,8 @@ static int gdth_pci_probe_one(gdth_pci_str *pcistr, gdth_ha_str **ha_out)
 
 	return 0;
 
+ out_unlink:
+	list_del_init(&ha->list);
  out_free_pmsg:
 	dma_free_coherent(&ha->pdev->dev, sizeof(gdth_msg_str),
 				ha->pmsg, ha->msg_phys);
diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index 1a695364fd2e..9963cb570fb6 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -71,7 +71,7 @@ static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
 					gdtcmd.u.cache.BlockNo = 1;
 				}
 
-				gdth_execute(host, &gdtcmd, cmnd, 30, NULL);
+				gdth_execute(ha, &gdtcmd, cmnd, 30, NULL);
 			}
 		}
 		if (!found)
@@ -134,7 +134,7 @@ static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
 		gdtcmd.u.ioctl.channel = INVALID_CHANNEL;
 		pcpar->write_back = wb_mode==1 ? 0:1;
 
-		gdth_execute(host, &gdtcmd, cmnd, 30, NULL);
+		gdth_execute(ha, &gdtcmd, cmnd, 30, NULL);
 
 		spin_lock_irqsave(&ha->smp_lock, flags);
 		ha->scratch_busy = FALSE;
@@ -254,7 +254,7 @@ int gdth_show_info(struct seq_file *m, struct Scsi_Host *host)
 			if (pds->entries > cnt)
 				pds->entries = cnt;
 
-			if (gdth_execute(host, gdtcmd, cmnd, 30, NULL) != S_OK)
+			if (gdth_execute(ha, gdtcmd, cmnd, 30, NULL) != S_OK)
 				pds->count = 0;
 
 			/* other IOCTLs must fit into area GDTH_SCRATCH/4 */
@@ -271,7 +271,7 @@ int gdth_show_info(struct seq_file *m, struct Scsi_Host *host)
 				gdtcmd->u.ioctl.channel =
 					ha->raw[i].address | ha->raw[i].id_list[j];
 
-				if (gdth_execute(host, gdtcmd, cmnd, 30, NULL) == S_OK) {
+				if (gdth_execute(ha, gdtcmd, cmnd, 30, NULL) == S_OK) {
 					strncpy(hrec,pdi->vendor,8);
 					strncpy(hrec+8,pdi->product,16);
 					strncpy(hrec+24,pdi->revision,4);
@@ -318,7 +318,7 @@ int gdth_show_info(struct seq_file *m, struct Scsi_Host *host)
 						ha->raw[i].address | ha->raw[i].id_list[j];
 					pdef->sddc_type = 0x08;
 
-					if (gdth_execute(host, gdtcmd, cmnd, 30, NULL) == S_OK) {
+					if (gdth_execute(ha, gdtcmd, cmnd, 30, NULL) == S_OK) {
 						seq_printf(m,
 							   " Grown Defects:\t%d\n",
 							   pdef->sddc_cnt);
@@ -350,7 +350,7 @@ int gdth_show_info(struct seq_file *m, struct Scsi_Host *host)
 				gdtcmd->u.ioctl.param_size = sizeof(gdth_cdrinfo_str);
 				gdtcmd->u.ioctl.subfunc = CACHE_DRV_INFO;
 				gdtcmd->u.ioctl.channel = drv_no;
-				if (gdth_execute(host, gdtcmd, cmnd, 30, NULL) != S_OK)
+				if (gdth_execute(ha, gdtcmd, cmnd, 30, NULL) != S_OK)
 					break;
 				pcdi->ld_dtype >>= 16;
 				j++;
@@ -427,7 +427,7 @@ int gdth_show_info(struct seq_file *m, struct Scsi_Host *host)
 			gdtcmd->u.ioctl.param_size = sizeof(gdth_arrayinf_str);
 			gdtcmd->u.ioctl.subfunc = ARRAY_INFO | LA_CTRL_PATTERN;
 			gdtcmd->u.ioctl.channel = i;
-			if (gdth_execute(host, gdtcmd, cmnd, 30, NULL) == S_OK) {
+			if (gdth_execute(ha, gdtcmd, cmnd, 30, NULL) == S_OK) {
 				if (pai->ai_state == 0)
 					strcpy(hrec, "idle");
 				else if (pai->ai_state == 2)
@@ -486,7 +486,7 @@ int gdth_show_info(struct seq_file *m, struct Scsi_Host *host)
 			gdtcmd->u.ioctl.channel = i;
 			phg->entries = MAX_HDRIVES;
 			phg->offset = GDTOFFSOF(gdth_hget_str, entry[0]);
-			if (gdth_execute(host, gdtcmd, cmnd, 30, NULL) == S_OK) {
+			if (gdth_execute(ha, gdtcmd, cmnd, 30, NULL) == S_OK) {
 				ha->hdr[i].ldr_no = i;
 				ha->hdr[i].rw_attribs = 0;
 				ha->hdr[i].start_sec = 0;
diff --git a/drivers/scsi/gdth_proc.h b/drivers/scsi/gdth_proc.h
index 6ba5ddf93c8c..3ad496d6cedf 100644
--- a/drivers/scsi/gdth_proc.h
+++ b/drivers/scsi/gdth_proc.h
@@ -6,7 +6,7 @@
  * $Id: gdth_proc.h,v 1.16 2004/01/14 13:09:01 achim Exp $
  */
 
-int gdth_execute(struct Scsi_Host *shost, gdth_cmd_str *gdtcmd, char *cmnd,
+int gdth_execute(gdth_ha_str *ha, gdth_cmd_str *gdtcmd, char *cmnd,
 		 int timeout, u32 *info);
 
 static int gdth_set_asc_info(struct Scsi_Host *host, char *buffer,
-- 
2.16.4

