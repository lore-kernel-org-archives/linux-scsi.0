Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43844EB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 17:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjGLRya (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbjGLRx7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 13:53:59 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F94210A
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:52 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b8c364ad3bso12901935ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689184431; x=1691776431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iz7ZF/P7DVc41TNYZJYra9/4i+Xij5lvK8vmkcD/FyQ=;
        b=MmHu1rnU2OMptWTAmVhyvUZdIavxh3pbv//XkjSeDR824eDqqgGhT+kJUFDVKFB5wr
         539pvu/ifkKXnG4fNEqLSgA4ceI4+4J6eO0RpX3/9h6XAaArtjDmJFQ+3M79dANI6aXD
         HkT5SpQ4MHFyFeODFXiCaSS+y6ivffHt/2tinOViZ5o8A439+BZVxZnB6YIseT8ON/gB
         myol8RrLb9Je1HUcdDGti/C7BiU65bN8/V0n0ueATODDdXjpGA+icT7O/czaj2+D5qV9
         wEX1c1mku6M5R9Mr3BFyFW0vmgzlsQPoedvknW71dWyDhWXQNY3d40cFn6eieBjfO3iF
         HLxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689184431; x=1691776431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Iz7ZF/P7DVc41TNYZJYra9/4i+Xij5lvK8vmkcD/FyQ=;
        b=NaRPzTlbBW7zz4bE1QNjNqXhOg08EBbrLChpaJT730zwWg0WdQfmcTs6ogtedxlOW6
         c7RszoD3HKrXt2++SOZMy/566dnz4cqFgqEInrB7Z+N/A6hQHDo61JMFUQFUttCh5Ahz
         u4KeDtOvG1fv4Vn7ZuwwyudYJgbBDTeskgq/G8oJtFLk4E4vybvXOEd83qEsefgkRGJp
         qzQ092oIG1JxXP6ki13h2V2RJ4/R5b8MMxPZ1e8WjmV7A3T87szYsFEcd+khT64qkCv2
         lTX02fL9EJO8Kr4rIMWH/lNJhhZ8v+PLe49VJc5DUiVkl8OQCPDmYmgSLgt9C9H5krwA
         j1Pg==
X-Gm-Message-State: ABy/qLZJmjdANwtDF9g9mV+ZBFl+o3MZQ7kLuIhlUhiNBmCDr5KBcxFl
        wCo9QTapVOAF77Q8yUmX8iqBPLBuuhk=
X-Google-Smtp-Source: APBJJlGofkkYopJxgnQHm2qLHzc6UIS9p48qK+jwObjcru6105uHYKkFIgqqmzYeSt3tmkv8NnByXA==
X-Received: by 2002:a17:902:f68b:b0:1b8:b4f6:1327 with SMTP id l11-20020a170902f68b00b001b8b4f61327mr50057plg.6.1689184431580;
        Wed, 12 Jul 2023 10:53:51 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902b70b00b001b898595be7sm4218459pls.291.2023.07.12.10.53.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jul 2023 10:53:51 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 12/12] lpfc: Copyright updates for 14.2.0.14 patches
Date:   Wed, 12 Jul 2023 11:05:22 -0700
Message-Id: <20230712180522.112722-13-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230712180522.112722-1-justintee8345@gmail.com>
References: <20230712180522.112722-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update copyrights to 2023 for files modified in the 14.2.0.14 patch set.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 8f6424487397..1eb7f7e60bba 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
-- 
2.38.0

