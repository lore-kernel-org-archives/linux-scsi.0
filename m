Return-Path: <SRS0=XP5+=5I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 245F6C3F2CD
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Mar 2020 16:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E648E2051A
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Mar 2020 16:19:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y+GrnDwE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbgCWQTp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Mar 2020 12:19:45 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53697 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbgCWQTp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Mar 2020 12:19:45 -0400
Received: by mail-wm1-f66.google.com with SMTP id b12so23071wmj.3
        for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2020 09:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rSYNxTmzu3TiCXxUcSFo3BVrqohJ8GApIw30Eu/fyiw=;
        b=Y+GrnDwEKUZtgxWN58ljit6djwKbTvrikZ0ce6EtGoDg/n4Z3T9NrYPb5bx0PwZJWm
         ny0/6NbX9EmB4W7pPva4C0/1SMJLsTqmPH8MpOekuuTm4jNkhb6Kh3TN1KiilqoIlgnz
         KiYmH007gKP8FTRE5x3fHMteHYeau5pAhZQJmLpItQH4ZwuiLUKzP5Ywyq/Bf+pyR9Yh
         O37PoLnmAv1TWkfaJxQO5P3sQheaVu7o+fXurQypyM881hOjROqg9JpT4GKiRtAdtD3F
         TVqNMhReNVm672/2aqet2EkZoea8YmY4yo0Eby5rZp00mfbiAnpwlPLcxHyfiT+LlXTe
         23uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rSYNxTmzu3TiCXxUcSFo3BVrqohJ8GApIw30Eu/fyiw=;
        b=FwzfI+FvLXk7S9zfcaDPw6cHZC5FST+8UeLcgyX0pxf+nGnHy6cIs4AD88uos02MjL
         tVa4F/iHmvpl9fJi7LJH3RZWTbqz8fZT7h7z9KbnZlRSTvIM6GfuJXF0H/n1ShgVC0c4
         jHnu5/pmf2D05o2F8j1TJTxt6ktgJQg2xpTLkLRfgrkyF4sWt+zeNqJNDsS8rWN8WtX/
         5kGvv+QRK2+B0VmKYZx4FsZUmAYxSvHxqTFOjQX5UnopBmELlrlVd/A711QRxR/kW2LS
         8BBiJ9/OwkOWPFg7GkR/Qbustb4vOy9g4bEWtXvs1nKi+Ih4ay4guxlLLv5HNy5+u4bD
         z0hA==
X-Gm-Message-State: ANhLgQ2ozSmO+R4T4Ar+5iXDnUorQtZ+xu0P5x+cj+7DDhvby37dopsU
        FvHDE6i4FTtjP16fv6SRMjSIjJLW
X-Google-Smtp-Source: ADFU+vu2Nolg+Lsx2wC3Neqmk2YUi+qdlNB1QIdaE/+cpJyOGzpYQNJRkClBRsdP/05Msz+Cq4xoLg==
X-Received: by 2002:a1c:5452:: with SMTP id p18mr48647wmi.102.1584980383020;
        Mon, 23 Mar 2020 09:19:43 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id v8sm24509480wrw.2.2020.03.23.09.19.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 Mar 2020 09:19:42 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [REPOST][PATCH 09/12] lpfc: Change default SCSI LUN QD to 64
Date:   Mon, 23 Mar 2020 09:19:35 -0700
Message-Id: <20200323161935.40341-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The default lun queue depth by the driver has been 30 for many years.
However, this value, when used with more recent hardware, has actually
throttled some tests that concentrate io on a lun.

Increase the default lun queue depth to 64.

Queue full handling, reported by the target, remains in effect and
unchanged.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
repost:
  Respond to review comment on the value in the comment.
  Removed min, max, default from comment. No need to state when they are
  clearly specified in the macro.
---
 drivers/scsi/lpfc/lpfc_attr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 4317c9ce7eca..63affb2269e7 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3868,9 +3868,9 @@ LPFC_VPORT_ATTR_R(enable_da_id, 1, 0, 1,
 
 /*
 # lun_queue_depth:  This parameter is used to limit the number of outstanding
-# commands per FCP LUN. Value range is [1,512]. Default value is 30.
+# commands per FCP LUN.
 */
-LPFC_VPORT_ATTR_R(lun_queue_depth, 30, 1, 512,
+LPFC_VPORT_ATTR_R(lun_queue_depth, 64, 1, 512,
 		  "Max number of FCP commands we can queue to a specific LUN");
 
 /*
-- 
2.16.4

