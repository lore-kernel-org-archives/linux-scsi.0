Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5777CC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiDLXgA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiDLXcs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:48 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A583EC5583
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:19 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id o5so109462pjr.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p3O3Yg9ObbcLqJBxL/VTmcd4M2F94bn3TMXLTmoPRyI=;
        b=Bek+R6+RBmjurR9Biv8yvuvuvnciJLsfp98d6RGyxNM6K4xqVvI3v+339pDKfG1hey
         m4WbDObxY/blanRQaaAk7U0UQfmbp9ZEX6RqaADw9KdOVkOqb7Q4xoItbA1i5nwqytfM
         jnwNiLwfrqGdr1Asx5Mya4O9Xof8MFOIiKuBe9h5wBeMuaejv9eBkMz911+tr0PuFTaP
         EdBc1hM1+niNAIxMt4HEwPtH9UaqxPcdQCk1J3O61eypjAHbaCSzNt26/ILvQq6RqBrI
         ffmbBkEW2IkL8yPK7wh+G2qEnUChVi1xFsf2irQx3KoWITqxbqd55JiJVw520tBext43
         QoEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p3O3Yg9ObbcLqJBxL/VTmcd4M2F94bn3TMXLTmoPRyI=;
        b=qPAopFo8DqEshISA7VKdVI6uEoxedTGZTQq+7bqdnIysAEwD8SEGS0tyZ3+d/5oVmL
         9W3+2A2781sa5I7TowafD8YKsefRfkNqWh4XkhTlpJQS114mlg8m53XGNryIGiAMwUM/
         GrQeWKY05yIVO74Vth6wpC1hXv7PwHdjBHCnkpAQBldafyFJCse3xv2zoqi7lQc3khxu
         k7DgOc5bu/7504/+QBwvETPlqAtxSkFToCIypiHuNwguoEs+a36gf0v83Jt8l6qzyApF
         LuVTzAUnx9K6x5e3xFSBICGF5wXMPwEiUUq9P6/qPhBNc2+zjkBM5PAHzPGNL6P7asoE
         FYOQ==
X-Gm-Message-State: AOAM5333q/nR8ju4V7nf3S/h+6kcXhnyI5iXDFO3AYqKvH+EcKyK1lpV
        LNNq3yhugcug37D5GmmjwKW8IWQhw+I=
X-Google-Smtp-Source: ABdhPJwz/DDbXu1190ZpcNMrYxnZ63XGMbIE2vHJpqdbd+l7O1Ghr76lOIZVwRZaDJdHpvyhrfSQ6g==
X-Received: by 2002:a17:902:ccc1:b0:156:6066:bd18 with SMTP id z1-20020a170902ccc100b001566066bd18mr39728230ple.28.1649802019135;
        Tue, 12 Apr 2022 15:20:19 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:18 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 05/26] lpfc: Requeue SCSI I/O to upper layer when fw reports link down
Date:   Tue, 12 Apr 2022 15:19:47 -0700
Message-Id: <20220412222008.126521-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During heavy I/O stress tests with 100+ vports and cable pulls, it may take
a while before the vport logs back into the fabric to resume I/O.

Currently, the driver immediately fails the I/O with DID_ERROR.

Change behavior to return DID_REQUEUE, and rely on SCSI layer's max retry
of 5 before erroring out the I/O.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index ba9dbb51b75f..ae340850d94f 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4276,6 +4276,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 			break;
 		}
 		if (lpfc_cmd->result == IOERR_INVALID_RPI ||
+		    lpfc_cmd->result == IOERR_LINK_DOWN ||
 		    lpfc_cmd->result == IOERR_NO_RESOURCES ||
 		    lpfc_cmd->result == IOERR_ABORT_REQUESTED ||
 		    lpfc_cmd->result == IOERR_RPI_SUSPENDED ||
-- 
2.26.2

