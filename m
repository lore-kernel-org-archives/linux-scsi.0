Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D0DC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 01:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbiKPBLM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 20:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbiKPBLJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 20:11:09 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6396D32041
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 17:11:08 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id jr19so9875962qtb.7
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 17:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=va6z4skUjBuTA6wLqVS0c5wezs8fA2I6HL5Adpgt554=;
        b=Wzcs0mHslv64fkl63BLh+IEqGaaBywTcFYmqAnObUgx+SRbtJZW8WEVqfSAUyZfEcn
         mNe9gOmSmCQP138S6W3KLiYpQHi/biys8eDWRBq6aF956fUDRkfU5/JfvWuL0YKbVFUo
         41Y8yLB6X4YMREQD8cG6V4TFq3DLsLr6uI+PSpRgGN8NteW+Vw8bK0cRuwEupZTMz3mf
         aw3ra3+nYb6UQWf5o0+8J8uP1abnZhUe0276WEnh5SmtnVRv6OdDwnoIPpxrwGKej1O0
         s0JhOoqauAvzaMlQKa4IKOUMuYGXdZyQYq+L9RwAODVSWnJZkpwiUW2Bj/vVympCie8s
         2evQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=va6z4skUjBuTA6wLqVS0c5wezs8fA2I6HL5Adpgt554=;
        b=uc72v484rRGJsHdMCIa/Qyx7OQQkoj1zLOkh1WaknJiYrxV5K7u6YBNX8E7bK4GKkN
         eqxsK8Ny4U/ajP9SxxRIfj3QWn6RPoqIumdklPX6U4MQ3O3baZUMsvi8VTJ29naXpXQg
         pSM+bkW7+T2arpZSHyKCrAO92TY9Ey7YXsgzduPJjDMUxYVP4XFc8wodp1xrlOhDYDWq
         S86DPW1qdYkxERYZTJrhX4t46f+XsEMK860yVSh3BKa7+tmkL36DDzgVd6wABH/Lb44B
         4PGGywGSABq/wLwLRNmKfLqOxuQm8uWs7LxqL8iYFZ+3E3+JwPpvyYbX+XXAFIzMc6v8
         7Ngg==
X-Gm-Message-State: ANoB5pmKmYsGqoPS894755Jy7nvLisVpGQftJVsl7jHN92s3Fr2wgWpl
        lbxx7Qw25uCx4YWai1u0gMZHSZQ6jXc=
X-Google-Smtp-Source: AA0mqf4/ZvH4GQ/ToF+UxflWddqIRGvusW7zJYz2TYEk8mCGA9HSPPx77dSFHiZcdWKrqivwNOoM9w==
X-Received: by 2002:ac8:5455:0:b0:3a5:2fd6:cf82 with SMTP id d21-20020ac85455000000b003a52fd6cf82mr19194311qtq.62.1668561067369;
        Tue, 15 Nov 2022 17:11:07 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y12-20020ac8128c000000b00399b73d06f0sm7901966qti.38.2022.11.15.17.11.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Nov 2022 17:11:07 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, Justin Tee <justintee8345@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 6/6] lpfc: Update lpfc version to 14.2.0.9
Date:   Tue, 15 Nov 2022 17:19:21 -0800
Message-Id: <20221116011921.105995-7-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221116011921.105995-1-justintee8345@gmail.com>
References: <20221116011921.105995-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 14.2.0.9

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 378eba7b09d9..41a1128f8651 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.2.0.8"
+#define LPFC_DRIVER_VERSION "14.2.0.9"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

