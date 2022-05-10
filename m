Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E0B7C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 10 May 2022 20:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbiEJUAn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 May 2022 16:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbiEJUAl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2022 16:00:41 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FA58A7CA
        for <linux-scsi@vger.kernel.org>; Tue, 10 May 2022 13:00:39 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id gj17-20020a17090b109100b001d8b390f77bso2894465pjb.1
        for <linux-scsi@vger.kernel.org>; Tue, 10 May 2022 13:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=chjZjuC+lbDo3Gkummb/m4qsyVSCCR3oseKaQvBuUTQ=;
        b=TEuFFDqvs74xNel7OAtEiR5a8AsmkKPR0TRmR/N8o665OYamH3trH5es8OFbmbIts2
         DS7YDQ56Pl1mzJqMPyyzFmySluIzOAt2hpTxmW8gx18RE9dNvC1L8VWGILv+oX4wsigy
         ztGtZ7gFmjvmy4IUQwF2jYoLGw9oKJrC9g9wjPk1iIQ4wNsDmVnE/v6GXWtBXgYJjRhD
         lF9DEfUd5aYcAU69GK+yuLXC20FK0qVY5Yr/fhKOsqgQKrn5dRKGDOFHP9fiPHYlF0t+
         hW02Y4oEa5+T9AfBr7gVIP2o4AVk6TIAhYBLcb3a+qk79UkUYp/D9SUobBcDdkHAKzOh
         hYtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=chjZjuC+lbDo3Gkummb/m4qsyVSCCR3oseKaQvBuUTQ=;
        b=bFZ/eTtRsDr+J0nFsstOfd0IVoF5O72NyfAumUsCodyYZ9iTVTVGkB4rZVCR6GEj86
         P+9J5sFWxI4V2Zxb93fV6k0lAB17U5GrTl1iNcHQ6iJO8GithT3gG3eV6LA3q5+5R0rk
         dw8C72R5U/GmpneGZ8Q5uIJRmQLE5YoePlBYnq+8DZsnEPmBkFu3a7SMx5mNcEp21pxb
         o5ybEW+VcmCrnhTN0N2bKk92ooNEnO06Rc+SQfDqAVZNlzGOn2ctdZ4pGO5o7IZ91mxW
         u3A5J2J4ziaxpyEkzWSpgI6Lfa5euZOlmpGO30KPWEW7s61uIWRoyNSyKNbWU9TC+Mj9
         J/XA==
X-Gm-Message-State: AOAM530i9rjiIa/Ks+0TBeaXE3p/9laR7fGXvwzri9lxCucuMPDNC4kx
        vM2ks4Eqik6EYeLctXxrpOY5VWxsTSk=
X-Google-Smtp-Source: ABdhPJxtWWenWYwPlzFvSicuytcSsKkA5kXIovWPHR0fW5p4fh8vTQMnLD2Ivy0uaW3YlTMiwnWZpw==
X-Received: by 2002:a17:90a:cf89:b0:1d7:7055:f49c with SMTP id i9-20020a17090acf8900b001d77055f49cmr1576457pju.12.1652212838284;
        Tue, 10 May 2022 13:00:38 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bh2-20020a170902a98200b0015e8d4eb2d2sm2422679plb.284.2022.05.10.13.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 13:00:37 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     linux-nvme@lists.infradead.org, James Smart <jsmart2021@gmail.com>,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Subject: [PATCH 2/4] lpfc: commonize VMID code location
Date:   Tue, 10 May 2022 13:00:26 -0700
Message-Id: <20220510200028.37399-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220510200028.37399-1-jsmart2021@gmail.com>
References: <20220510200028.37399-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove VMID code from its scsi-specific location and move to a new
file solely for VMID code.

Signed-off-by: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/Makefile    |   2 +-
 drivers/scsi/lpfc/lpfc_crtn.h |   2 +
 drivers/scsi/lpfc/lpfc_scsi.c | 256 ------------------------------
 drivers/scsi/lpfc/lpfc_vmid.c | 288 ++++++++++++++++++++++++++++++++++
 4 files changed, 291 insertions(+), 257 deletions(-)
 create mode 100644 drivers/scsi/lpfc/lpfc_vmid.c

diff --git a/drivers/scsi/lpfc/Makefile b/drivers/scsi/lpfc/Makefile
index 092a971d066b..bbd1faf41e80 100644
--- a/drivers/scsi/lpfc/Makefile
+++ b/drivers/scsi/lpfc/Makefile
@@ -33,4 +33,4 @@ obj-$(CONFIG_SCSI_LPFC) := lpfc.o
 lpfc-objs := lpfc_mem.o lpfc_sli.o lpfc_ct.o lpfc_els.o \
 	lpfc_hbadisc.o	lpfc_init.o lpfc_mbox.o lpfc_nportdisc.o   \
 	lpfc_scsi.o lpfc_attr.o lpfc_vport.o lpfc_debugfs.o lpfc_bsg.o \
-	lpfc_nvme.o lpfc_nvmet.o
+	lpfc_nvme.o lpfc_nvmet.o lpfc_vmid.o
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index b0775be31d5c..913844f01bf5 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -671,6 +671,8 @@ int lpfc_vmid_cmd(struct lpfc_vport *vport,
 int lpfc_vmid_hash_fn(const char *vmid, int len);
 struct lpfc_vmid *lpfc_get_vmid_from_hashtable(struct lpfc_vport *vport,
 					      uint32_t hash, uint8_t *buf);
+int lpfc_vmid_get_appid(struct lpfc_vport *vport, char *uuid, struct
+			       scsi_cmnd * cmd, union lpfc_vmid_io_tag *tag);
 void lpfc_vmid_vport_cleanup(struct lpfc_vport *vport);
 int lpfc_issue_els_qfpa(struct lpfc_vport *vport);
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 1d134a01ff3e..70d0a4d3d92e 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -87,14 +87,6 @@ static void
 lpfc_release_scsi_buf_s3(struct lpfc_hba *phba, struct lpfc_io_buf *psb);
 static int
 lpfc_prot_group_type(struct lpfc_hba *phba, struct scsi_cmnd *sc);
-static void
-lpfc_put_vmid_in_hashtable(struct lpfc_vport *vport, u32 hash,
-			   struct lpfc_vmid *vmp);
-static void lpfc_vmid_update_entry(struct lpfc_vport *vport, struct scsi_cmnd
-				   *cmd, struct lpfc_vmid *vmp,
-				   union lpfc_vmid_io_tag *tag);
-static void lpfc_vmid_assign_cs_ctl(struct lpfc_vport *vport,
-				    struct lpfc_vmid *vmid);
 
 /**
  * lpfc_sli4_set_rsp_sgl_last - Set the last bit in the response sge.
@@ -5270,254 +5262,6 @@ void lpfc_poll_timeout(struct timer_list *t)
 	}
 }
 
-/*
- * lpfc_get_vmid_from_hashtable - search the UUID in the hash table
- * @vport: The virtual port for which this call is being executed.
- * @hash: calculated hash value
- * @buf: uuid associated with the VE
- * Return the VMID entry associated with the UUID
- * Make sure to acquire the appropriate lock before invoking this routine.
- */
-struct lpfc_vmid *lpfc_get_vmid_from_hashtable(struct lpfc_vport *vport,
-					      u32 hash, u8 *buf)
-{
-	struct lpfc_vmid *vmp;
-
-	hash_for_each_possible(vport->hash_table, vmp, hnode, hash) {
-		if (memcmp(&vmp->host_vmid[0], buf, 16) == 0)
-			return vmp;
-	}
-	return NULL;
-}
-
-/*
- * lpfc_put_vmid_in_hashtable - put the VMID in the hash table
- * @vport: The virtual port for which this call is being executed.
- * @hash - calculated hash value
- * @vmp: Pointer to a VMID entry representing a VM sending I/O
- *
- * This routine will insert the newly acquired VMID entity in the hash table.
- * Make sure to acquire the appropriate lock before invoking this routine.
- */
-static void
-lpfc_put_vmid_in_hashtable(struct lpfc_vport *vport, u32 hash,
-			   struct lpfc_vmid *vmp)
-{
-	hash_add(vport->hash_table, &vmp->hnode, hash);
-}
-
-/*
- * lpfc_vmid_hash_fn - create a hash value of the UUID
- * @vmid: uuid associated with the VE
- * @len: length of the VMID string
- * Returns the calculated hash value
- */
-int lpfc_vmid_hash_fn(const char *vmid, int len)
-{
-	int c;
-	int hash = 0;
-
-	if (len == 0)
-		return 0;
-	while (len--) {
-		c = *vmid++;
-		if (c >= 'A' && c <= 'Z')
-			c += 'a' - 'A';
-
-		hash = (hash + (c << LPFC_VMID_HASH_SHIFT) +
-			(c >> LPFC_VMID_HASH_SHIFT)) * 19;
-	}
-
-	return hash & LPFC_VMID_HASH_MASK;
-}
-
-/*
- * lpfc_vmid_update_entry - update the vmid entry in the hash table
- * @vport: The virtual port for which this call is being executed.
- * @cmd: address of scsi cmd descriptor
- * @vmp: Pointer to a VMID entry representing a VM sending I/O
- * @tag: VMID tag
- */
-static void lpfc_vmid_update_entry(struct lpfc_vport *vport, struct scsi_cmnd
-				   *cmd, struct lpfc_vmid *vmp,
-				   union lpfc_vmid_io_tag *tag)
-{
-	u64 *lta;
-
-	if (vport->phba->pport->vmid_flag & LPFC_VMID_TYPE_PRIO)
-		tag->cs_ctl_vmid = vmp->un.cs_ctl_vmid;
-	else if (vport->phba->cfg_vmid_app_header)
-		tag->app_id = vmp->un.app_id;
-
-	if (cmd->sc_data_direction == DMA_TO_DEVICE)
-		vmp->io_wr_cnt++;
-	else
-		vmp->io_rd_cnt++;
-
-	/* update the last access timestamp in the table */
-	lta = per_cpu_ptr(vmp->last_io_time, raw_smp_processor_id());
-	*lta = jiffies;
-}
-
-static void lpfc_vmid_assign_cs_ctl(struct lpfc_vport *vport,
-				    struct lpfc_vmid *vmid)
-{
-	u32 hash;
-	struct lpfc_vmid *pvmid;
-
-	if (vport->port_type == LPFC_PHYSICAL_PORT) {
-		vmid->un.cs_ctl_vmid = lpfc_vmid_get_cs_ctl(vport);
-	} else {
-		hash = lpfc_vmid_hash_fn(vmid->host_vmid, vmid->vmid_len);
-		pvmid =
-		    lpfc_get_vmid_from_hashtable(vport->phba->pport, hash,
-						vmid->host_vmid);
-		if (pvmid)
-			vmid->un.cs_ctl_vmid = pvmid->un.cs_ctl_vmid;
-		else
-			vmid->un.cs_ctl_vmid = lpfc_vmid_get_cs_ctl(vport);
-	}
-}
-
-/*
- * lpfc_vmid_get_appid - get the VMID associated with the UUID
- * @vport: The virtual port for which this call is being executed.
- * @uuid: UUID associated with the VE
- * @cmd: address of scsi_cmd descriptor
- * @tag: VMID tag
- * Returns status of the function
- */
-static int lpfc_vmid_get_appid(struct lpfc_vport *vport, char *uuid, struct
-			       scsi_cmnd * cmd, union lpfc_vmid_io_tag *tag)
-{
-	struct lpfc_vmid *vmp = NULL;
-	int hash, len, rc = -EPERM, i;
-
-	/* check if QFPA is complete */
-	if (lpfc_vmid_is_type_priority_tag(vport) &&
-	    !(vport->vmid_flag & LPFC_VMID_QFPA_CMPL) &&
-	    (vport->vmid_flag & LPFC_VMID_ISSUE_QFPA)) {
-		vport->work_port_events |= WORKER_CHECK_VMID_ISSUE_QFPA;
-		return -EAGAIN;
-	}
-
-	/* search if the UUID has already been mapped to the VMID */
-	len = strlen(uuid);
-	hash = lpfc_vmid_hash_fn(uuid, len);
-
-	/* search for the VMID in the table */
-	read_lock(&vport->vmid_lock);
-	vmp = lpfc_get_vmid_from_hashtable(vport, hash, uuid);
-
-	/* if found, check if its already registered  */
-	if (vmp  && vmp->flag & LPFC_VMID_REGISTERED) {
-		read_unlock(&vport->vmid_lock);
-		lpfc_vmid_update_entry(vport, cmd, vmp, tag);
-		rc = 0;
-	} else if (vmp && (vmp->flag & LPFC_VMID_REQ_REGISTER ||
-			   vmp->flag & LPFC_VMID_DE_REGISTER)) {
-		/* else if register or dereg request has already been sent */
-		/* Hence VMID tag will not be added for this I/O */
-		read_unlock(&vport->vmid_lock);
-		rc = -EBUSY;
-	} else {
-		/* The VMID was not found in the hashtable. At this point, */
-		/* drop the read lock first before proceeding further */
-		read_unlock(&vport->vmid_lock);
-		/* start the process to obtain one as per the */
-		/* type of the VMID indicated */
-		write_lock(&vport->vmid_lock);
-		vmp = lpfc_get_vmid_from_hashtable(vport, hash, uuid);
-
-		/* while the read lock was released, in case the entry was */
-		/* added by other context or is in process of being added */
-		if (vmp && vmp->flag & LPFC_VMID_REGISTERED) {
-			lpfc_vmid_update_entry(vport, cmd, vmp, tag);
-			write_unlock(&vport->vmid_lock);
-			return 0;
-		} else if (vmp && vmp->flag & LPFC_VMID_REQ_REGISTER) {
-			write_unlock(&vport->vmid_lock);
-			return -EBUSY;
-		}
-
-		/* else search and allocate a free slot in the hash table */
-		if (vport->cur_vmid_cnt < vport->max_vmid) {
-			for (i = 0; i < vport->max_vmid; i++) {
-				vmp = vport->vmid + i;
-				if (vmp->flag == LPFC_VMID_SLOT_FREE)
-					break;
-			}
-			if (i == vport->max_vmid)
-				vmp = NULL;
-		} else {
-			vmp = NULL;
-		}
-
-		if (!vmp) {
-			write_unlock(&vport->vmid_lock);
-			return -ENOMEM;
-		}
-
-		/* Add the vmid and register */
-		lpfc_put_vmid_in_hashtable(vport, hash, vmp);
-		vmp->vmid_len = len;
-		memcpy(vmp->host_vmid, uuid, vmp->vmid_len);
-		vmp->io_rd_cnt = 0;
-		vmp->io_wr_cnt = 0;
-		vmp->flag = LPFC_VMID_SLOT_USED;
-
-		vmp->delete_inactive =
-			vport->vmid_inactivity_timeout ? 1 : 0;
-
-		/* if type priority tag, get next available VMID */
-		if (vport->phba->pport->vmid_flag & LPFC_VMID_TYPE_PRIO)
-			lpfc_vmid_assign_cs_ctl(vport, vmp);
-
-		/* allocate the per cpu variable for holding */
-		/* the last access time stamp only if VMID is enabled */
-		if (!vmp->last_io_time)
-			vmp->last_io_time = __alloc_percpu(sizeof(u64),
-							   __alignof__(struct
-							   lpfc_vmid));
-		if (!vmp->last_io_time) {
-			hash_del(&vmp->hnode);
-			vmp->flag = LPFC_VMID_SLOT_FREE;
-			write_unlock(&vport->vmid_lock);
-			return -EIO;
-		}
-
-		write_unlock(&vport->vmid_lock);
-
-		/* complete transaction with switch */
-		if (vport->phba->pport->vmid_flag & LPFC_VMID_TYPE_PRIO)
-			rc = lpfc_vmid_uvem(vport, vmp, true);
-		else if (vport->phba->cfg_vmid_app_header)
-			rc = lpfc_vmid_cmd(vport, SLI_CTAS_RAPP_IDENT, vmp);
-		if (!rc) {
-			write_lock(&vport->vmid_lock);
-			vport->cur_vmid_cnt++;
-			vmp->flag |= LPFC_VMID_REQ_REGISTER;
-			write_unlock(&vport->vmid_lock);
-		} else {
-			write_lock(&vport->vmid_lock);
-			hash_del(&vmp->hnode);
-			vmp->flag = LPFC_VMID_SLOT_FREE;
-			free_percpu(vmp->last_io_time);
-			write_unlock(&vport->vmid_lock);
-			return -EIO;
-		}
-
-		/* finally, enable the idle timer once */
-		if (!(vport->phba->pport->vmid_flag & LPFC_VMID_TIMER_ENBLD)) {
-			mod_timer(&vport->phba->inactive_vmid_poll,
-				  jiffies +
-				  msecs_to_jiffies(1000 * LPFC_VMID_TIMER));
-			vport->phba->pport->vmid_flag |= LPFC_VMID_TIMER_ENBLD;
-		}
-	}
-	return rc;
-}
-
 /*
  * lpfc_is_command_vm_io - get the UUID from blk cgroup
  * @cmd: Pointer to scsi_cmnd data structure
diff --git a/drivers/scsi/lpfc/lpfc_vmid.c b/drivers/scsi/lpfc/lpfc_vmid.c
new file mode 100644
index 000000000000..f64ced04b912
--- /dev/null
+++ b/drivers/scsi/lpfc/lpfc_vmid.c
@@ -0,0 +1,288 @@
+/*******************************************************************
+ * This file is part of the Emulex Linux Device Driver for         *
+ * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
+ * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
+ * EMULEX and SLI are trademarks of Emulex.                        *
+ * www.broadcom.com                                                *
+ * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
+ *                                                                 *
+ * This program is free software; you can redistribute it and/or   *
+ * modify it under the terms of version 2 of the GNU General       *
+ * Public License as published by the Free Software Foundation.    *
+ * This program is distributed in the hope that it will be useful. *
+ * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
+ * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
+ * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
+ * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
+ * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
+ * more details, a copy of which can be found in the file COPYING  *
+ * included with this package.                                     *
+ *******************************************************************/
+
+#include <linux/interrupt.h>
+#include <linux/dma-direction.h>
+
+#include <scsi/scsi_transport_fc.h>
+
+#include "lpfc_hw4.h"
+#include "lpfc_hw.h"
+#include "lpfc_sli.h"
+#include "lpfc_sli4.h"
+#include "lpfc_nl.h"
+#include "lpfc_disc.h"
+#include "lpfc.h"
+#include "lpfc_crtn.h"
+
+
+/*
+ * lpfc_get_vmid_from_hashtable - search the UUID in the hash table
+ * @vport: The virtual port for which this call is being executed.
+ * @hash: calculated hash value
+ * @buf: uuid associated with the VE
+ * Return the VMID entry associated with the UUID
+ * Make sure to acquire the appropriate lock before invoking this routine.
+ */
+struct lpfc_vmid *lpfc_get_vmid_from_hashtable(struct lpfc_vport *vport,
+					       u32 hash, u8 *buf)
+{
+	struct lpfc_vmid *vmp;
+
+	hash_for_each_possible(vport->hash_table, vmp, hnode, hash) {
+		if (memcmp(&vmp->host_vmid[0], buf, 16) == 0)
+			return vmp;
+	}
+	return NULL;
+}
+
+/*
+ * lpfc_put_vmid_in_hashtable - put the VMID in the hash table
+ * @vport: The virtual port for which this call is being executed.
+ * @hash - calculated hash value
+ * @vmp: Pointer to a VMID entry representing a VM sending I/O
+ *
+ * This routine will insert the newly acquired VMID entity in the hash table.
+ * Make sure to acquire the appropriate lock before invoking this routine.
+ */
+static void
+lpfc_put_vmid_in_hashtable(struct lpfc_vport *vport, u32 hash,
+			   struct lpfc_vmid *vmp)
+{
+	hash_add(vport->hash_table, &vmp->hnode, hash);
+}
+
+/*
+ * lpfc_vmid_hash_fn - create a hash value of the UUID
+ * @vmid: uuid associated with the VE
+ * @len: length of the VMID string
+ * Returns the calculated hash value
+ */
+int lpfc_vmid_hash_fn(const char *vmid, int len)
+{
+	int c;
+	int hash = 0;
+
+	if (len == 0)
+		return 0;
+	while (len--) {
+		c = *vmid++;
+		if (c >= 'A' && c <= 'Z')
+			c += 'a' - 'A';
+
+		hash = (hash + (c << LPFC_VMID_HASH_SHIFT) +
+			(c >> LPFC_VMID_HASH_SHIFT)) * 19;
+	}
+
+	return hash & LPFC_VMID_HASH_MASK;
+}
+
+/*
+ * lpfc_vmid_update_entry - update the vmid entry in the hash table
+ * @vport: The virtual port for which this call is being executed.
+ * @iodir: io direction
+ * @vmp: Pointer to a VMID entry representing a VM sending I/O
+ * @tag: VMID tag
+ */
+static void lpfc_vmid_update_entry(struct lpfc_vport *vport,
+				   enum dma_data_direction iodir,
+				   struct lpfc_vmid *vmp,
+				   union lpfc_vmid_io_tag *tag)
+{
+	u64 *lta;
+
+	if (vport->phba->pport->vmid_flag & LPFC_VMID_TYPE_PRIO)
+		tag->cs_ctl_vmid = vmp->un.cs_ctl_vmid;
+	else if (vport->phba->cfg_vmid_app_header)
+		tag->app_id = vmp->un.app_id;
+
+	if (iodir == DMA_TO_DEVICE)
+		vmp->io_wr_cnt++;
+	else if (iodir == DMA_FROM_DEVICE)
+		vmp->io_rd_cnt++;
+
+	/* update the last access timestamp in the table */
+	lta = per_cpu_ptr(vmp->last_io_time, raw_smp_processor_id());
+	*lta = jiffies;
+}
+
+static void lpfc_vmid_assign_cs_ctl(struct lpfc_vport *vport,
+				    struct lpfc_vmid *vmid)
+{
+	u32 hash;
+	struct lpfc_vmid *pvmid;
+
+	if (vport->port_type == LPFC_PHYSICAL_PORT) {
+		vmid->un.cs_ctl_vmid = lpfc_vmid_get_cs_ctl(vport);
+	} else {
+		hash = lpfc_vmid_hash_fn(vmid->host_vmid, vmid->vmid_len);
+		pvmid =
+		    lpfc_get_vmid_from_hashtable(vport->phba->pport, hash,
+						 vmid->host_vmid);
+		if (pvmid)
+			vmid->un.cs_ctl_vmid = pvmid->un.cs_ctl_vmid;
+		else
+			vmid->un.cs_ctl_vmid = lpfc_vmid_get_cs_ctl(vport);
+	}
+}
+
+/*
+ * lpfc_vmid_get_appid - get the VMID associated with the UUID
+ * @vport: The virtual port for which this call is being executed.
+ * @uuid: UUID associated with the VE
+ * @cmd: address of scsi_cmd descriptor
+ * @iodir: io direction
+ * @tag: VMID tag
+ * Returns status of the function
+ */
+int lpfc_vmid_get_appid(struct lpfc_vport *vport, char *uuid,
+			enum dma_data_direction iodir,
+			union lpfc_vmid_io_tag *tag)
+{
+	struct lpfc_vmid *vmp = NULL;
+	int hash, len, rc = -EPERM, i;
+
+	/* check if QFPA is complete */
+	if (lpfc_vmid_is_type_priority_tag(vport) &&
+	    !(vport->vmid_flag & LPFC_VMID_QFPA_CMPL) &&
+	    (vport->vmid_flag & LPFC_VMID_ISSUE_QFPA)) {
+		vport->work_port_events |= WORKER_CHECK_VMID_ISSUE_QFPA;
+		return -EAGAIN;
+	}
+
+	/* search if the UUID has already been mapped to the VMID */
+	len = strlen(uuid);
+	hash = lpfc_vmid_hash_fn(uuid, len);
+
+	/* search for the VMID in the table */
+	read_lock(&vport->vmid_lock);
+	vmp = lpfc_get_vmid_from_hashtable(vport, hash, uuid);
+
+	/* if found, check if its already registered  */
+	if (vmp  && vmp->flag & LPFC_VMID_REGISTERED) {
+		read_unlock(&vport->vmid_lock);
+		lpfc_vmid_update_entry(vport, iodir, vmp, tag);
+		rc = 0;
+	} else if (vmp && (vmp->flag & LPFC_VMID_REQ_REGISTER ||
+			   vmp->flag & LPFC_VMID_DE_REGISTER)) {
+		/* else if register or dereg request has already been sent */
+		/* Hence VMID tag will not be added for this I/O */
+		read_unlock(&vport->vmid_lock);
+		rc = -EBUSY;
+	} else {
+		/* The VMID was not found in the hashtable. At this point, */
+		/* drop the read lock first before proceeding further */
+		read_unlock(&vport->vmid_lock);
+		/* start the process to obtain one as per the */
+		/* type of the VMID indicated */
+		write_lock(&vport->vmid_lock);
+		vmp = lpfc_get_vmid_from_hashtable(vport, hash, uuid);
+
+		/* while the read lock was released, in case the entry was */
+		/* added by other context or is in process of being added */
+		if (vmp && vmp->flag & LPFC_VMID_REGISTERED) {
+			lpfc_vmid_update_entry(vport, iodir, vmp, tag);
+			write_unlock(&vport->vmid_lock);
+			return 0;
+		} else if (vmp && vmp->flag & LPFC_VMID_REQ_REGISTER) {
+			write_unlock(&vport->vmid_lock);
+			return -EBUSY;
+		}
+
+		/* else search and allocate a free slot in the hash table */
+		if (vport->cur_vmid_cnt < vport->max_vmid) {
+			for (i = 0; i < vport->max_vmid; i++) {
+				vmp = vport->vmid + i;
+				if (vmp->flag == LPFC_VMID_SLOT_FREE)
+					break;
+			}
+			if (i == vport->max_vmid)
+				vmp = NULL;
+		} else {
+			vmp = NULL;
+		}
+
+		if (!vmp) {
+			write_unlock(&vport->vmid_lock);
+			return -ENOMEM;
+		}
+
+		/* Add the vmid and register */
+		lpfc_put_vmid_in_hashtable(vport, hash, vmp);
+		vmp->vmid_len = len;
+		memcpy(vmp->host_vmid, uuid, vmp->vmid_len);
+		vmp->io_rd_cnt = 0;
+		vmp->io_wr_cnt = 0;
+		vmp->flag = LPFC_VMID_SLOT_USED;
+
+		vmp->delete_inactive =
+			vport->vmid_inactivity_timeout ? 1 : 0;
+
+		/* if type priority tag, get next available VMID */
+		if (vport->phba->pport->vmid_flag & LPFC_VMID_TYPE_PRIO)
+			lpfc_vmid_assign_cs_ctl(vport, vmp);
+
+		/* allocate the per cpu variable for holding */
+		/* the last access time stamp only if VMID is enabled */
+		if (!vmp->last_io_time)
+			vmp->last_io_time = __alloc_percpu(sizeof(u64),
+							   __alignof__(struct
+							   lpfc_vmid));
+		if (!vmp->last_io_time) {
+			hash_del(&vmp->hnode);
+			vmp->flag = LPFC_VMID_SLOT_FREE;
+			write_unlock(&vport->vmid_lock);
+			return -EIO;
+		}
+
+		write_unlock(&vport->vmid_lock);
+
+		/* complete transaction with switch */
+		if (vport->phba->pport->vmid_flag & LPFC_VMID_TYPE_PRIO)
+			rc = lpfc_vmid_uvem(vport, vmp, true);
+		else if (vport->phba->cfg_vmid_app_header)
+			rc = lpfc_vmid_cmd(vport, SLI_CTAS_RAPP_IDENT, vmp);
+		if (!rc) {
+			write_lock(&vport->vmid_lock);
+			vport->cur_vmid_cnt++;
+			vmp->flag |= LPFC_VMID_REQ_REGISTER;
+			write_unlock(&vport->vmid_lock);
+		} else {
+			write_lock(&vport->vmid_lock);
+			hash_del(&vmp->hnode);
+			vmp->flag = LPFC_VMID_SLOT_FREE;
+			free_percpu(vmp->last_io_time);
+			write_unlock(&vport->vmid_lock);
+			return -EIO;
+		}
+
+		/* finally, enable the idle timer once */
+		if (!(vport->phba->pport->vmid_flag & LPFC_VMID_TIMER_ENBLD)) {
+			mod_timer(&vport->phba->inactive_vmid_poll,
+				  jiffies +
+				  msecs_to_jiffies(1000 * LPFC_VMID_TIMER));
+			vport->phba->pport->vmid_flag |= LPFC_VMID_TIMER_ENBLD;
+		}
+	}
+	return rc;
+}
-- 
2.26.2

