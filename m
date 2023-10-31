Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 717D2C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Oct 2023 18:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbjJaS73 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Oct 2023 14:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234271AbjJaS7X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Oct 2023 14:59:23 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B59EA
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2023 11:59:21 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1cc4d306fe9so5150095ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2023 11:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698778761; x=1699383561; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SWCHVlrp4QI6QJQeA3Yw7epl6gIptzpQaQ9nMWBqSiM=;
        b=JnkYvtB8yYqGdGFeJvIzVjw6t3xFPkItyHNiolExwFpvj0MlZM0kn3/U6Sw0ffSkfj
         rzwA29J3kAJZ1RGBMIJ6PabgzIvpAId61zqlox2YgefS2n5o6XkFg76qHl2QZgo7IheR
         eZchkfdw2g26TQEBArsYSJtb9ds8FD1bZMh+CZPcZMUfhfzj58hhn6FLsoDc31aA5zkP
         tLLXX4TI7Lr6Rxz/0nEtZf0P6oWcxpSjXc4boD5funH/ezlwLbTmudMxzM7T+IkXb3su
         ADVhKkPxdhXMct5uWpJaeTF97/Dsbh6qh/wRnji1vu3gHapPAqjGnWg9ew5Ftrw/QMKJ
         pvxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698778761; x=1699383561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SWCHVlrp4QI6QJQeA3Yw7epl6gIptzpQaQ9nMWBqSiM=;
        b=hI/fNZNRJaCISGjpLbBFIM3fLk2ZV5OykXuPg+9aBfaGDhGHJUWYnJ86d2UCq/d6sR
         YW0SdfELrqQvrW5uvAMDqATiIwuBhnsCqfKBQYTR4vOBFhXKpe/bNskoLpmpbBNC2YGa
         LJ98EJ9zb2S/o8EmQpaSeoxmGYa6/LZrpeLYrD2BqTxMvurhc8UbpsXjcGhHHOyy4LnA
         xgMkPk1JpcuIGJmT3JqtB/n2ZovpBFgPtAZaEvaojmrO/B40VfshjehHQaX3gxpavG5x
         E3jI8uJIPzbRsJwRwOEcQhslNfQwkZLVGJTNj9ir0vLh/Y7oMb1UNJM/fVVPiyso65YV
         qmTg==
X-Gm-Message-State: AOJu0YzOEUIxxMkxnrGvaYxkaqKD05mEPXokfW4D7ko8HFdl90IxzA2e
        yUY+ZddWhmvDn9htxlnHqKQvnt5h9lE=
X-Google-Smtp-Source: AGHT+IET9HCSxKx+S1UkRIHjAxrtbsnYMpzbEe1niqAqWoT0N2GvrEYPpIfLd/nCHbjoWASPqh7kDQ==
X-Received: by 2002:a17:902:c74c:b0:1cc:2ba2:55f4 with SMTP id q12-20020a170902c74c00b001cc2ba255f4mr10887502plq.0.1698778760877;
        Tue, 31 Oct 2023 11:59:20 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bh6-20020a170902a98600b001c9d6923e7dsm1628657plb.222.2023.10.31.11.59.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Oct 2023 11:59:20 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 8/9] lpfc: Update lpfc version to 14.2.0.16
Date:   Tue, 31 Oct 2023 12:12:23 -0700
Message-Id: <20231031191224.150862-9-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20231031191224.150862-1-justintee8345@gmail.com>
References: <20231031191224.150862-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 14.2.0.16

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 88068834cab9..b7d39e2f19fc 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.2.0.15"
+#define LPFC_DRIVER_VERSION "14.2.0.16"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

