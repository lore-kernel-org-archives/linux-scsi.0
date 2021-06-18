Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78CDCC49361
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 13:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 571CD61222
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 13:44:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbhFRNqY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 09:46:24 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:7820 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233675AbhFRNqX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 09:46:23 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15IDhuW3017244;
        Fri, 18 Jun 2021 13:44:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=XtQFCbs5ZI4RrkXmpXdsaNC1zfO7sZG1Ccz1p3JNxS0=;
 b=AK4XRRL6LHdvlwUEfwQ0lpSyguvPLpahFUpvSa7oo8Nb3/rHidE7AcEX6yIqqYRXzVvb
 mF3NlO99ORU2keEwJ8Uw61aaaO4U+jvJb0SNnAOU7msE2RogHhJdNIS+hR63aNecbKpz
 0iJbbm4S8RzPq3Nq0HC9cdBTQa4gNCRwvkspqxH7UHOkfL2Sd1z9rZ2NS6SGXZaOKRPe
 xbVcAqo77kroh3aNbGQn6D6c4lCHwLGEEBzA5wfYcL5unpiLnETi9Sjq5fJG6NV2bJ6F
 LtNf2/ZZG6DG6fgKweyWOV4ZSqzQgESrDYVAAiYN6MuPnUXpAnJY4LY6wRYu5NRpfzko bA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39893qswu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 13:44:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15IDfQFl150517;
        Fri, 18 Jun 2021 13:44:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 396wawre1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 13:44:09 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15IDi80g159474;
        Fri, 18 Jun 2021 13:44:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 396wawre15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 13:44:08 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15IDi7t9016729;
        Fri, 18 Jun 2021 13:44:07 GMT
Received: from mwanda (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Jun 2021 06:44:06 -0700
Date:   Fri, 18 Jun 2021 16:43:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     James Smart <james.smart@broadcom.com>
Cc:     Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: elx: libefc: fix IRQ restore in
 efc_domain_dispatch_frame()
Message-ID: <YMyjH16k4M1yEmmU@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-ORIG-GUID: v_wRPe2JeLwGf7cj4_MYdF82cHtabv2M
X-Proofpoint-GUID: v_wRPe2JeLwGf7cj4_MYdF82cHtabv2M
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Calling a nested spin_lock_irqsave() will overwrite the original "flags"
so that they can not be enabled again at the end.

Fixes: 3146240f19bf ("scsi: elx: libefc: FC Domain state machine interfaces")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/elx/libefc/efc_domain.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/elx/libefc/efc_domain.c b/drivers/scsi/elx/libefc/efc_domain.c
index 0c08fa2066b9..ca9d7ff2c0d2 100644
--- a/drivers/scsi/elx/libefc/efc_domain.c
+++ b/drivers/scsi/elx/libefc/efc_domain.c
@@ -1001,10 +1001,10 @@ efc_domain_dispatch_frame(void *arg, struct efc_hw_sequence *seq)
 
 	if (node->hold_frames || !list_empty(&node->pend_frames)) {
 		/* add frame to node's pending list */
-		spin_lock_irqsave(&node->pend_frames_lock, flags);
+		spin_lock(&node->pend_frames_lock);
 		INIT_LIST_HEAD(&seq->list_entry);
 		list_add_tail(&seq->list_entry, &node->pend_frames);
-		spin_unlock_irqrestore(&node->pend_frames_lock, flags);
+		spin_unlock(&node->pend_frames_lock);
 		rc = EFC_HW_SEQ_HOLD;
 		goto out_release;
 	}
-- 
2.30.2

