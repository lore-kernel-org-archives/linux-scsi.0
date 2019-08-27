Return-Path: <SRS0=cdy6=WX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF030C3A5A3
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 21:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E01820656
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 21:28:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D97McMxa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730376AbfH0V2M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 17:28:12 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:45438 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbfH0V2M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Aug 2019 17:28:12 -0400
Received: by mail-pg1-f179.google.com with SMTP id o13so154867pgp.12
        for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2019 14:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=L+pn5NeK8Xsw7YgwZl3PrZDW342hE/3tYdo6nOQynC0=;
        b=D97McMxaYCQPWIbFn+MgGfuYsAUrYN2q/gvW93P/G5i2PBb5fCEpwCl0jawXQDroFf
         fQ2d3ASp55PR7qrgy3trFXM5Kg/yUJVbhXeQ4+ELSGqT22NYD8df2c60C0IJuAVBGgkN
         paemBLHSLBGApXBpu+RVWSHBtosWL6rLvS5j+qhJE+FmVDF6wTmGpNMs1hjM8t74U0JY
         T9OUMHORgUwXctLpewcd6tNuTjWrlypmljBdWOMaf2Dy56hcvW+Nrq1YuiQHk6KzyPUX
         8ImOajlT+Xs0Zq8zkyPcgAN3L7iCbwMv7jVRYI+UWPp2tgvmXLQFmCXSEJgvpvSSBa8r
         Bwcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=L+pn5NeK8Xsw7YgwZl3PrZDW342hE/3tYdo6nOQynC0=;
        b=O7qPTm7riDN56MfMOnIoeoYKquc6To4O69SESfWZ+SA0ynohLDHROj2i/RVYRrmBkk
         IlIhdmCQ4FrKEJmtNOLVCvPmVYgBHJLl6s8V79r7cgga/pbOKltyW+Pv3zn9HXuXpLPa
         hOvwC0MSD0YkyiYhO8zCa+J2EeO69FtmFOSV0ay0dLSbpW8mdFxU9pPXesyVOEncVqN7
         DP3luAZJrjvyFGe+ypCpS0amC0YCa9tsszL0PdWZMyu48+a/Q0uQ8RXMVlrjStGUzyIa
         y+b6X8dgs740E90CmBSIxZBNckZ3xUj3o3j9TNep4PuG7JRxgJ26uLhq/lcbCcS+vQhU
         zAmg==
X-Gm-Message-State: APjAAAWtUEHBfhRdauS7mYwwSD9KqzOT5g4/gJuQEBM/5plH5fu5XedW
        Lctp3BIBgJQ8N1DXT67TUBdr3Arv
X-Google-Smtp-Source: APXvYqz9hyaOvtbjtW7PIcyxVhRFP/7KrFvGQS8FMwWQGqrJ5a0GSfwsSCny0gKb/T0/pLJs8dl0+w==
X-Received: by 2002:a63:1749:: with SMTP id 9mr510872pgx.0.1566941290881;
        Tue, 27 Aug 2019 14:28:10 -0700 (PDT)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g8sm274862pgk.1.2019.08.27.14.28.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 27 Aug 2019 14:28:10 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        KyleMahlkuch <kmahlkuc@linux.vnet.ibm.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH] lpfc: Remove bg debugfs buffers
Date:   Tue, 27 Aug 2019 14:28:05 -0700
Message-Id: <20190827212805.30060-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Capturing and downloading dif command data and dif data was done a
dozen years ago and no longer being used. Also creates a potential
security hole.

Remove the debugfs buffer for dif debugging.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
CC: KyleMahlkuch <kmahlkuc@linux.vnet.ibm.com>
CC: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/lpfc/lpfc.h         |   2 -
 drivers/scsi/lpfc/lpfc_crtn.h    |  10 ---
 drivers/scsi/lpfc/lpfc_debugfs.c | 134 ---------------------------------------
 drivers/scsi/lpfc/lpfc_init.c    |  70 --------------------
 drivers/scsi/lpfc/lpfc_scsi.c    |  79 -----------------------
 5 files changed, 295 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 73540bb13b3e..691acbdcc46d 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1039,8 +1039,6 @@ struct lpfc_hba {
 	struct dentry *debug_hbqinfo;
 	struct dentry *debug_dumpHostSlim;
 	struct dentry *debug_dumpHBASlim;
-	struct dentry *debug_dumpData;   /* BlockGuard BPL */
-	struct dentry *debug_dumpDif;    /* BlockGuard BPL */
 	struct dentry *debug_InjErrLBA;  /* LBA to inject errors at */
 	struct dentry *debug_InjErrNPortID;  /* NPortID to inject errors at */
 	struct dentry *debug_InjErrWWPN;  /* WWPN to inject errors at */
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 8b84acc95a07..b2ad8c750486 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -433,16 +433,6 @@ int lpfc_sli4_get_allocated_extnts(struct lpfc_hba *, uint16_t,
 int lpfc_sli4_get_avail_extnt_rsrc(struct lpfc_hba *, uint16_t,
 					  uint16_t *, uint16_t *);
 
-/* externs BlockGuard */
-extern char *_dump_buf_data;
-extern unsigned long _dump_buf_data_order;
-extern char *_dump_buf_dif;
-extern unsigned long _dump_buf_dif_order;
-extern spinlock_t _dump_buf_lock;
-extern int _dump_buf_done;
-extern spinlock_t pgcnt_lock;
-extern unsigned int pgcnt;
-
 /* Interface exported by fabric iocb scheduler */
 void lpfc_fabric_abort_nport(struct lpfc_nodelist *);
 void lpfc_fabric_abort_hba(struct lpfc_hba *);
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 45f431fbe0d2..8d34be60d379 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -2162,89 +2162,6 @@ lpfc_debugfs_dumpHostSlim_open(struct inode *inode, struct file *file)
 	return rc;
 }
 
-static int
-lpfc_debugfs_dumpData_open(struct inode *inode, struct file *file)
-{
-	struct lpfc_debug *debug;
-	int rc = -ENOMEM;
-
-	if (!_dump_buf_data)
-		return -EBUSY;
-
-	debug = kmalloc(sizeof(*debug), GFP_KERNEL);
-	if (!debug)
-		goto out;
-
-	/* Round to page boundary */
-	pr_err("9059 BLKGRD:  %s: _dump_buf_data=0x%p\n",
-			__func__, _dump_buf_data);
-	debug->buffer = _dump_buf_data;
-	if (!debug->buffer) {
-		kfree(debug);
-		goto out;
-	}
-
-	debug->len = (1 << _dump_buf_data_order) << PAGE_SHIFT;
-	file->private_data = debug;
-
-	rc = 0;
-out:
-	return rc;
-}
-
-static int
-lpfc_debugfs_dumpDif_open(struct inode *inode, struct file *file)
-{
-	struct lpfc_debug *debug;
-	int rc = -ENOMEM;
-
-	if (!_dump_buf_dif)
-		return -EBUSY;
-
-	debug = kmalloc(sizeof(*debug), GFP_KERNEL);
-	if (!debug)
-		goto out;
-
-	/* Round to page boundary */
-	pr_err("9060 BLKGRD: %s: _dump_buf_dif=x%px file=%pD\n",
-			__func__, _dump_buf_dif, file);
-	debug->buffer = _dump_buf_dif;
-	if (!debug->buffer) {
-		kfree(debug);
-		goto out;
-	}
-
-	debug->len = (1 << _dump_buf_dif_order) << PAGE_SHIFT;
-	file->private_data = debug;
-
-	rc = 0;
-out:
-	return rc;
-}
-
-static ssize_t
-lpfc_debugfs_dumpDataDif_write(struct file *file, const char __user *buf,
-		  size_t nbytes, loff_t *ppos)
-{
-	/*
-	 * The Data/DIF buffers only save one failing IO
-	 * The write op is used as a reset mechanism after an IO has
-	 * already been saved to the next one can be saved
-	 */
-	spin_lock(&_dump_buf_lock);
-
-	memset((void *)_dump_buf_data, 0,
-			((1 << PAGE_SHIFT) << _dump_buf_data_order));
-	memset((void *)_dump_buf_dif, 0,
-			((1 << PAGE_SHIFT) << _dump_buf_dif_order));
-
-	_dump_buf_done = 0;
-
-	spin_unlock(&_dump_buf_lock);
-
-	return nbytes;
-}
-
 static ssize_t
 lpfc_debugfs_dif_err_read(struct file *file, char __user *buf,
 	size_t nbytes, loff_t *ppos)
@@ -2457,17 +2374,6 @@ lpfc_debugfs_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int
-lpfc_debugfs_dumpDataDif_release(struct inode *inode, struct file *file)
-{
-	struct lpfc_debug *debug = file->private_data;
-
-	debug->buffer = NULL;
-	kfree(debug);
-
-	return 0;
-}
-
 /**
  * lpfc_debugfs_multixripools_write - Clear multi-XRI pools statistics
  * @file: The file pointer to read from.
@@ -5448,26 +5354,6 @@ static const struct file_operations lpfc_debugfs_op_cpucheck = {
 	.release =      lpfc_debugfs_release,
 };
 
-#undef lpfc_debugfs_op_dumpData
-static const struct file_operations lpfc_debugfs_op_dumpData = {
-	.owner =        THIS_MODULE,
-	.open =         lpfc_debugfs_dumpData_open,
-	.llseek =       lpfc_debugfs_lseek,
-	.read =         lpfc_debugfs_read,
-	.write =	lpfc_debugfs_dumpDataDif_write,
-	.release =      lpfc_debugfs_dumpDataDif_release,
-};
-
-#undef lpfc_debugfs_op_dumpDif
-static const struct file_operations lpfc_debugfs_op_dumpDif = {
-	.owner =        THIS_MODULE,
-	.open =         lpfc_debugfs_dumpDif_open,
-	.llseek =       lpfc_debugfs_lseek,
-	.read =         lpfc_debugfs_read,
-	.write =	lpfc_debugfs_dumpDataDif_write,
-	.release =      lpfc_debugfs_dumpDataDif_release,
-};
-
 #undef lpfc_debugfs_op_dif_err
 static const struct file_operations lpfc_debugfs_op_dif_err = {
 	.owner =	THIS_MODULE,
@@ -5864,20 +5750,6 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 		} else
 			phba->debug_dumpHostSlim = NULL;
 
-		/* Setup dumpData */
-		snprintf(name, sizeof(name), "dumpData");
-		phba->debug_dumpData =
-			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
-				 phba->hba_debugfs_root,
-				 phba, &lpfc_debugfs_op_dumpData);
-
-		/* Setup dumpDif */
-		snprintf(name, sizeof(name), "dumpDif");
-		phba->debug_dumpDif =
-			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
-				 phba->hba_debugfs_root,
-				 phba, &lpfc_debugfs_op_dumpDif);
-
 		/* Setup DIF Error Injections */
 		snprintf(name, sizeof(name), "InjErrLBA");
 		phba->debug_InjErrLBA =
@@ -6255,12 +6127,6 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 		debugfs_remove(phba->debug_dumpHostSlim); /* HostSlim */
 		phba->debug_dumpHostSlim = NULL;
 
-		debugfs_remove(phba->debug_dumpData); /* dumpData */
-		phba->debug_dumpData = NULL;
-
-		debugfs_remove(phba->debug_dumpDif); /* dumpDif */
-		phba->debug_dumpDif = NULL;
-
 		debugfs_remove(phba->debug_InjErrLBA); /* InjErrLBA */
 		phba->debug_InjErrLBA = NULL;
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 7fdd7be77bce..9600d1ecc518 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -66,12 +66,6 @@
 #include "lpfc_version.h"
 #include "lpfc_ids.h"
 
-char *_dump_buf_data;
-unsigned long _dump_buf_data_order;
-char *_dump_buf_dif;
-unsigned long _dump_buf_dif_order;
-spinlock_t _dump_buf_lock;
-
 /* Used when mapping IRQ vectors in a driver centric manner */
 static uint32_t lpfc_present_cpu;
 
@@ -7628,7 +7622,6 @@ lpfc_setup_bg(struct lpfc_hba *phba, struct Scsi_Host *shost)
 	uint32_t old_mask;
 	uint32_t old_guard;
 
-	int pagecnt = 10;
 	if (phba->cfg_prot_mask && phba->cfg_prot_guard) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"1478 Registering BlockGuard with the "
@@ -7665,56 +7658,6 @@ lpfc_setup_bg(struct lpfc_hba *phba, struct Scsi_Host *shost)
 				"layer, Bad protection parameters: %d %d\n",
 				old_mask, old_guard);
 	}
-
-	if (!_dump_buf_data) {
-		while (pagecnt) {
-			spin_lock_init(&_dump_buf_lock);
-			_dump_buf_data =
-				(char *) __get_free_pages(GFP_KERNEL, pagecnt);
-			if (_dump_buf_data) {
-				lpfc_printf_log(phba, KERN_ERR, LOG_BG,
-					"9043 BLKGRD: allocated %d pages for "
-				       "_dump_buf_data at x%px\n",
-				       (1 << pagecnt), _dump_buf_data);
-				_dump_buf_data_order = pagecnt;
-				memset(_dump_buf_data, 0,
-				       ((1 << PAGE_SHIFT) << pagecnt));
-				break;
-			} else
-				--pagecnt;
-		}
-		if (!_dump_buf_data_order)
-			lpfc_printf_log(phba, KERN_ERR, LOG_BG,
-				"9044 BLKGRD: ERROR unable to allocate "
-			       "memory for hexdump\n");
-	} else
-		lpfc_printf_log(phba, KERN_ERR, LOG_BG,
-			"9045 BLKGRD: already allocated _dump_buf_data=x%px"
-		       "\n", _dump_buf_data);
-	if (!_dump_buf_dif) {
-		while (pagecnt) {
-			_dump_buf_dif =
-				(char *) __get_free_pages(GFP_KERNEL, pagecnt);
-			if (_dump_buf_dif) {
-				lpfc_printf_log(phba, KERN_ERR, LOG_BG,
-					"9046 BLKGRD: allocated %d pages for "
-				       "_dump_buf_dif at x%px\n",
-				       (1 << pagecnt), _dump_buf_dif);
-				_dump_buf_dif_order = pagecnt;
-				memset(_dump_buf_dif, 0,
-				       ((1 << PAGE_SHIFT) << pagecnt));
-				break;
-			} else
-				--pagecnt;
-		}
-		if (!_dump_buf_dif_order)
-			lpfc_printf_log(phba, KERN_ERR, LOG_BG,
-			"9047 BLKGRD: ERROR unable to allocate "
-			       "memory for hexdump\n");
-	} else
-		lpfc_printf_log(phba, KERN_ERR, LOG_BG,
-			"9048 BLKGRD: already allocated _dump_buf_dif=x%px\n",
-		       _dump_buf_dif);
 }
 
 /**
@@ -13522,19 +13465,6 @@ lpfc_exit(void)
 	pci_unregister_driver(&lpfc_driver);
 	fc_release_transport(lpfc_transport_template);
 	fc_release_transport(lpfc_vport_transport_template);
-	if (_dump_buf_data) {
-		printk(KERN_ERR	"9062 BLKGRD: freeing %lu pages for "
-				"_dump_buf_data at x%px\n",
-				(1L << _dump_buf_data_order), _dump_buf_data);
-		free_pages((unsigned long)_dump_buf_data, _dump_buf_data_order);
-	}
-
-	if (_dump_buf_dif) {
-		printk(KERN_ERR	"9049 BLKGRD: freeing %lu pages for "
-				"_dump_buf_dif at x%px\n",
-				(1L << _dump_buf_dif_order), _dump_buf_dif);
-		free_pages((unsigned long)_dump_buf_dif, _dump_buf_dif_order);
-	}
 	idr_destroy(&lpfc_hba_index);
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 7c65bd652c4d..fe1097666de4 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -53,8 +53,6 @@
 #define LPFC_RESET_WAIT  2
 #define LPFC_ABORT_WAIT  2
 
-int _dump_buf_done = 1;
-
 static char *dif_op_str[] = {
 	"PROT_NORMAL",
 	"PROT_READ_INSERT",
@@ -89,63 +87,6 @@ lpfc_release_scsi_buf_s3(struct lpfc_hba *phba, struct lpfc_io_buf *psb);
 static int
 lpfc_prot_group_type(struct lpfc_hba *phba, struct scsi_cmnd *sc);
 
-static void
-lpfc_debug_save_data(struct lpfc_hba *phba, struct scsi_cmnd *cmnd)
-{
-	void *src, *dst;
-	struct scatterlist *sgde = scsi_sglist(cmnd);
-
-	if (!_dump_buf_data) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_BG,
-			"9050 BLKGRD: ERROR %s _dump_buf_data is NULL\n",
-				__func__);
-		return;
-	}
-
-
-	if (!sgde) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_BG,
-			"9051 BLKGRD: ERROR: data scatterlist is null\n");
-		return;
-	}
-
-	dst = (void *) _dump_buf_data;
-	while (sgde) {
-		src = sg_virt(sgde);
-		memcpy(dst, src, sgde->length);
-		dst += sgde->length;
-		sgde = sg_next(sgde);
-	}
-}
-
-static void
-lpfc_debug_save_dif(struct lpfc_hba *phba, struct scsi_cmnd *cmnd)
-{
-	void *src, *dst;
-	struct scatterlist *sgde = scsi_prot_sglist(cmnd);
-
-	if (!_dump_buf_dif) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_BG,
-			"9052 BLKGRD: ERROR %s _dump_buf_data is NULL\n",
-				__func__);
-		return;
-	}
-
-	if (!sgde) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_BG,
-			"9053 BLKGRD: ERROR: prot scatterlist is null\n");
-		return;
-	}
-
-	dst = _dump_buf_dif;
-	while (sgde) {
-		src = sg_virt(sgde);
-		memcpy(dst, src, sgde->length);
-		dst += sgde->length;
-		sgde = sg_next(sgde);
-	}
-}
-
 static inline unsigned
 lpfc_cmd_blksize(struct scsi_cmnd *sc)
 {
@@ -2962,26 +2903,6 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 	uint32_t bgstat = bgf->bgstat;
 	uint64_t failing_sector = 0;
 
-	spin_lock(&_dump_buf_lock);
-	if (!_dump_buf_done) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_BG,  "9070 BLKGRD: Saving"
-			" Data for %u blocks to debugfs\n",
-				(cmd->cmnd[7] << 8 | cmd->cmnd[8]));
-		lpfc_debug_save_data(phba, cmd);
-
-		/* If we have a prot sgl, save the DIF buffer */
-		if (lpfc_prot_group_type(phba, cmd) ==
-				LPFC_PG_TYPE_DIF_BUF) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_BG, "9071 BLKGRD: "
-				"Saving DIF for %u blocks to debugfs\n",
-				(cmd->cmnd[7] << 8 | cmd->cmnd[8]));
-			lpfc_debug_save_dif(phba, cmd);
-		}
-
-		_dump_buf_done = 1;
-	}
-	spin_unlock(&_dump_buf_lock);
-
 	if (lpfc_bgs_get_invalid_prof(bgstat)) {
 		cmd->result = DID_ERROR << 16;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
-- 
2.13.7

