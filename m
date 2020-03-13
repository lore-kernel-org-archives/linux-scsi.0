Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C83BAC2BB1D
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 02:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A01A8206F1
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 02:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgCMChg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 22:37:36 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44698 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgCMChf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2020 22:37:35 -0400
Received: by mail-pf1-f195.google.com with SMTP id b72so4267148pfb.11
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 19:37:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6tY4FFTq6Ygi2Z8/kj5Udlg9a06deWMMZmiKUDwiIEk=;
        b=Sz6959E910EM3h1olxtzdSYHlRQT1o0O8N9V4TQ/cDq+jGFV0mgcVe+BxbmtWVeKVs
         aMLoWotqlH6SadDceSrE8jl7cHg/sv7dtfTvk1Jp5SSzbgoMA4cXr5KhIBekc5vxol7L
         a17cCU55zGPJbtXcaCD/jJ7j0XJ4TYtvdG34Hn4E/I//2K8Fw8v46wDxuvlvizvI0u1Y
         g5JuKjgu8/wPTF+PHM7xHxH7O5J7tyRgNEMXHEJfYRxNrrGbdDdbXtVKREDjtIH0gTeu
         +8bXgSHcE9euDTp3sJ7cGxqaxfinRJ/EblT1BgKzw/TxBw/xJy0lxeHpxfu+7c8DXybi
         z4mA==
X-Gm-Message-State: ANhLgQ2gbsC2WxJcqw2T2ORp9j/e1QYsAhmtMg9EYxcO9Pe0ufvxTvZY
        uKpua1XSvGLRk/AFSyzgDuI=
X-Google-Smtp-Source: ADFU+vtFNx7TRByc+pjsPBfbWP0udFo9I9yk0tlDLiI0LOGwNmhM+f0kwtwBEmTlen6KPcscGtrZTA==
X-Received: by 2002:aa7:99d1:: with SMTP id v17mr7882460pfi.165.1584067052996;
        Thu, 12 Mar 2020 19:37:32 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dc2:675a:7f2a:2f89])
        by smtp.gmail.com with ESMTPSA id o129sm3123516pfb.61.2020.03.12.19.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 19:37:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Kai Makisara <Kai.Makisara@kolumbus.fi>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 4/5] scsi/st: Use get_unaligned_be24() and sign_extend32()
Date:   Thu, 12 Mar 2020 19:37:17 -0700
Message-Id: <20200313023718.21830-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200313023718.21830-1-bvanassche@acm.org>
References: <20200313023718.21830-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use these functions instead of open-coding them.

Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/st.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 393f3019ccac..0f315dadf7e8 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -45,6 +45,7 @@ static const char *verstr = "20160209";
 
 #include <linux/uaccess.h>
 #include <asm/dma.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_dbg.h>
@@ -2680,8 +2681,7 @@ static void deb_space_print(struct scsi_tape *STp, int direction, char *units, u
 	if (!debugging)
 		return;
 
-	sc = cmd[2] & 0x80 ? 0xff000000 : 0;
-	sc |= (cmd[2] << 16) | (cmd[3] << 8) | cmd[4];
+	sc = sign_extend32(get_unaligned_be24(&cmd[2]), 23);
 	if (direction)
 		sc = -sc;
 	st_printk(ST_DEB_MSG, STp, "Spacing tape %s over %d %s.\n",
