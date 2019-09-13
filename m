Return-Path: <SRS0=Er8N=XI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 988D6C49ED7
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E88D206BB
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="I3pTeEhn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388176AbfIMNFW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Sep 2019 09:05:22 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33932 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387533AbfIMNFV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2019 09:05:21 -0400
Received: by mail-pl1-f195.google.com with SMTP id d3so13251261plr.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2019 06:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=r8Wub1Gv5kwU8NTkyDFBFj/6r+g1Rvev9JdO4bQzznQ=;
        b=I3pTeEhntjEsHM8orJ0gMOuQG8fXYxce+sEugG3OhKxcBnUDmIos0gMwZWjNv5cVZK
         Z05C3Ti/fEcBybmiWLefYrJlhtcRXVLPnlFcbVGm2iaUn0k7RNl9qGuuJYIuzZkzRQm/
         5dzx/PsIj88pEAFEjrXGTTyK4YvYw/Clgtpvs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=r8Wub1Gv5kwU8NTkyDFBFj/6r+g1Rvev9JdO4bQzznQ=;
        b=hGmKN0L8d8BLTsc/LxHLFthOhucsRU1WvLRThyo+UQ5O+t6uw4kg8XnJgr4vxshV5M
         Ltx9D0qZf/A4hwkKo3sYY0y6mqKX/bPmqZD8k26wIskzdpkpS8izprHHoXCJF5rRz528
         /lj76iVwi1g4cEyqgFEfIcbhbrqMka58o//CbVEIWF/O++yyyDLmtrMHdzyOEtF52+7T
         m0xQV2TGW8hSTPt6k3dKq1YEslgVdiUOeMNr5FDYjRKDLQm9AphXy8oQLBRT/+uylg+v
         q0+wBBiBkcow+q5HjXesrr0dCTI00gULYEwTuW5J5y/Sa8cAHtbu3m7oEmXYf7TjErnN
         aGyQ==
X-Gm-Message-State: APjAAAXX2h6gtEZnLFw+Gq9kwPOmQA7kuN1oYuER6EDjmU+Ij31McBOK
        YgaWZMlMRdNWAXwQRxu6spnykQ==
X-Google-Smtp-Source: APXvYqztuNW8prUwBNAxYPE+MUgpZdsdYRxfJS1teJgyYoa/YjFN+1qSy+C/bS7nKGm31fhQs7L1Tg==
X-Received: by 2002:a17:902:b685:: with SMTP id c5mr10244592pls.16.1568379921138;
        Fri, 13 Sep 2019 06:05:21 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 69sm37208841pfb.145.2019.09.13.06.05.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 06:05:20 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, suganath-prabu.subramani@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 09/13] mpt3sas: Fail release cmnd if diag buffer is released
Date:   Fri, 13 Sep 2019 09:04:46 -0400
Message-Id: <1568379890-18347-10-git-send-email-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
References: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Return the diag buffer release command with -EINVAL status if the buffer
is already released.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 62e878d..9267ffe 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -2235,7 +2235,7 @@ _ctl_diag_release(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	    MPT3_DIAG_BUFFER_IS_RELEASED) {
 		ioc_err(ioc, "%s: buffer_type(0x%02x) is already released\n",
 			__func__, buffer_type);
-		return 0;
+		return -EINVAL;
 	}
 
 	request_data = ioc->diag_buffer[buffer_type];
-- 
1.8.3.1

