Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ACE7C35280
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 21:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E753C2054F
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 21:43:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A6O81F/X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgEAVnd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 17:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgEAVnc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 17:43:32 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B78C061A0C
        for <linux-scsi@vger.kernel.org>; Fri,  1 May 2020 14:43:32 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id d17so13146322wrg.11
        for <linux-scsi@vger.kernel.org>; Fri, 01 May 2020 14:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zS1gHsQdot/aWK29mtvhR9h+kIiXuYYXQ8PiZqBszOw=;
        b=A6O81F/XQCv5gadKxoBgoKcnyYvwS5KU0ogWVh6zSIDZcO2NZUe9lwUC+tLR43sia6
         8AZOvlva4BzRmMyXs491H+8w4FST23DClFvFzehHkb7b9AeJjXd7qnrfnVLhABCMTPKx
         rigrrJI1V0kOaPQn6LEoFYak3iocQiU6JLA7yW9QYjRM6NJkCh7nWaD2roxLSeKSCteu
         ILODy3qw7w2ZlOgMhcybkpGpLApuyByBKrsPMG/+O+oElbrFC82+HhjYziZ65VFwWJqX
         rYJVJ9domtONTj5vi/8pl06O7WH3K+hDdxnR1bVEE+fSX7TlUT48ir36jMC0Ibs5UNAM
         bDiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zS1gHsQdot/aWK29mtvhR9h+kIiXuYYXQ8PiZqBszOw=;
        b=N3Khaa0X6/6+U/acEdEG57puMwRJImZBXqh4eg1s66aTbtJyS5H+utZgexbKPkNxm5
         LmM1tWsgHSCATbTD4pXWWVGmk2gT1ryuw+fs/Igqd1QtMcNdVoXF2WudOkuB9vF+P3lM
         W09dQr+FzoKMWEqcD3sIqrJp4YaLBW+NgBmgBKttdxcDR4kq4ahQ6D+5GYelhGDxnIUz
         PkzP1GX8mG40xldWe+yHZvRmw6Z7FXAZ1ICge2MvQyXVtzbcPboMS1a/JOFL5MYiW9Ux
         L+QQvLj0Y0zO62fzRGvgkM5lKkH4nJ27tCKfmtT27uGAczfm6JsmE5zHW/fa3W8wVm1p
         HMRg==
X-Gm-Message-State: AGi0PuYx3TNuV7sHFuAAT/MHSmaOx2iepY5rAEU/fFUNeFIIFcoQOQUt
        5ar0BkRl0FNxxQxUX4mWpbMMLEGH
X-Google-Smtp-Source: APiQypJKx8yeYQzOlHkQDGKv4nOBAratxdC/lOqn+xksNHIeYKCpHvIfEO23bHEB7UR//jJQW6Yw+g==
X-Received: by 2002:adf:c7c3:: with SMTP id y3mr4961402wrg.196.1588369410465;
        Fri, 01 May 2020 14:43:30 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t2sm1207734wmt.15.2020.05.01.14.43.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 May 2020 14:43:29 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 6/9] lpfc: Remove unnecessary lockdep_assert_held calls
Date:   Fri,  1 May 2020 14:43:07 -0700
Message-Id: <20200501214310.91713-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200501214310.91713-1-jsmart2021@gmail.com>
References: <20200501214310.91713-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In an audit of lockdep calls in the driver, there are multiple lockdep
checks in successive calling layers. E.g. a routine checks, and then
calls a lower routine that also checks, and so on. Calling sequences
result in many redundant checks.

Refine the code to remove lower-level lockdep checks.
Update comments on the lock, correcting a few places where lock object
in comment was incorrect.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c |  8 +++-----
 drivers/scsi/lpfc/lpfc_sli.c     | 33 +++++++++++++++-----------------
 2 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 789eecbf32eb..a8f4ced0fc41 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1356,14 +1356,14 @@ lpfc_vlan_id_match(uint16_t curr_vlan_id, uint16_t new_vlan_id)
 }
 
 /**
- * lpfc_update_fcf_record - Update driver fcf record
  * __lpfc_update_fcf_record_pri - update the lpfc_fcf_pri record.
  * @phba: pointer to lpfc hba data structure.
  * @fcf_index: Index for the lpfc_fcf_record.
  * @new_fcf_record: pointer to hba fcf record.
  *
  * This routine updates the driver FCF priority record from the new HBA FCF
- * record. This routine is called with the host lock held.
+ * record. The hbalock is asserted held in the code path calling this
+ * routine.
  **/
 static void
 __lpfc_update_fcf_record_pri(struct lpfc_hba *phba, uint16_t fcf_index,
@@ -1372,8 +1372,6 @@ __lpfc_update_fcf_record_pri(struct lpfc_hba *phba, uint16_t fcf_index,
 {
 	struct lpfc_fcf_pri *fcf_pri;
 
-	lockdep_assert_held(&phba->hbalock);
-
 	fcf_pri = &phba->fcf.fcf_pri[fcf_index];
 	fcf_pri->fcf_rec.fcf_index = fcf_index;
 	/* FCF record priority */
@@ -1451,7 +1449,7 @@ lpfc_copy_fcf_record(struct lpfc_fcf_rec *fcf_rec,
  *
  * This routine updates the driver FCF record from the new HBA FCF record
  * together with the address mode, vlan_id, and other informations. This
- * routine is called with the host lock held.
+ * routine is called with the hbalock held.
  **/
 static void
 __lpfc_update_fcf_record(struct lpfc_hba *phba, struct lpfc_fcf_rec *fcf_rec,
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 9ce37560f4c0..df77e75b9f53 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1248,8 +1248,8 @@ lpfc_sli_get_iocbq(struct lpfc_hba *phba)
  * @phba: Pointer to HBA context object.
  * @iocbq: Pointer to driver iocb object.
  *
- * This function is called with hbalock held to release driver
- * iocb object to the iocb pool. The iotag in the iocb object
+ * This function is called to release the driver iocb object
+ * to the iocb pool. The iotag in the iocb object
  * does not change for each use of the iocb object. This function
  * clears all other fields of the iocb object when it is freed.
  * The sqlq structure that holds the xritag and phys and virtual
@@ -1259,7 +1259,8 @@ lpfc_sli_get_iocbq(struct lpfc_hba *phba)
  * this IO was aborted then the sglq entry it put on the
  * lpfc_abts_els_sgl_list until the CQ_ABORTED_XRI is received. If the
  * IO has good status or fails for any other reason then the sglq
- * entry is added to the free list (lpfc_els_sgl_list).
+ * entry is added to the free list (lpfc_els_sgl_list). The hbalock is
+ *  asserted held in the code path calling this routine.
  **/
 static void
 __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
@@ -1269,8 +1270,6 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 	unsigned long iflag = 0;
 	struct lpfc_sli_ring *pring;
 
-	lockdep_assert_held(&phba->hbalock);
-
 	if (iocbq->sli4_xritag == NO_XRI)
 		sglq = NULL;
 	else
@@ -1333,18 +1332,17 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
  * @phba: Pointer to HBA context object.
  * @iocbq: Pointer to driver iocb object.
  *
- * This function is called with hbalock held to release driver
- * iocb object to the iocb pool. The iotag in the iocb object
- * does not change for each use of the iocb object. This function
- * clears all other fields of the iocb object when it is freed.
+ * This function is called to release the driver iocb object to the
+ * iocb pool. The iotag in the iocb object does not change for each
+ * use of the iocb object. This function clears all other fields of
+ * the iocb object when it is freed. The hbalock is asserted held in
+ * the code path calling this routine.
  **/
 static void
 __lpfc_sli_release_iocbq_s3(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 {
 	size_t start_clean = offsetof(struct lpfc_iocbq, iocb);
 
-	lockdep_assert_held(&phba->hbalock);
-
 	/*
 	 * Clean all volatile data fields, preserve iotag and node struct.
 	 */
@@ -1789,17 +1787,17 @@ lpfc_sli_next_iotag(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
  * @nextiocb: Pointer to driver iocb object which need to be
  *            posted to firmware.
  *
- * This function is called with hbalock held to post a new iocb to
- * the firmware. This function copies the new iocb to ring iocb slot and
- * updates the ring pointers. It adds the new iocb to txcmplq if there is
+ * This function is called to post a new iocb to the firmware. This
+ * function copies the new iocb to ring iocb slot and updates the
+ * ring pointers. It adds the new iocb to txcmplq if there is
  * a completion call back for this iocb else the function will free the
- * iocb object.
+ * iocb object.  The hbalock is asserted held in the code path calling
+ * this routine.
  **/
 static void
 lpfc_sli_submit_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		IOCB_t *iocb, struct lpfc_iocbq *nextiocb)
 {
-	lockdep_assert_held(&phba->hbalock);
 	/*
 	 * Set up an iotag
 	 */
@@ -11170,6 +11168,7 @@ lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * request, this function issues abort out unconditionally. This function is
  * called with hbalock held. The function returns 0 when it fails due to
  * memory allocation failure or when the command iocb is an abort request.
+ * The hbalock is asserted held in the code path calling this routine.
  **/
 static int
 lpfc_sli_abort_iotag_issue(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
@@ -11183,8 +11182,6 @@ lpfc_sli_abort_iotag_issue(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	unsigned long iflags;
 	struct lpfc_nodelist *ndlp;
 
-	lockdep_assert_held(&phba->hbalock);
-
 	/*
 	 * There are certain command types we don't want to abort.  And we
 	 * don't want to abort commands that are already in the process of
-- 
2.26.1

