Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3026CC4CECE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 20:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0693C205F4
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 20:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbgCMUbT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 16:31:19 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:38788 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgCMUbT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 16:31:19 -0400
Received: by mail-pj1-f68.google.com with SMTP id m15so4246354pje.3
        for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2020 13:31:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6tY4FFTq6Ygi2Z8/kj5Udlg9a06deWMMZmiKUDwiIEk=;
        b=mE2iecrJfGGsWv4iiKVb3//jst+LdToheBtCFEqdIJe9tqwfmthsMXd2KEYoKBdG3T
         cFoYsAYKUir1+jj+QSJm09zeJmBNLuuTBfXskoZtPtn45/Ebwzb50XKetbb4ioFa0xNH
         woLDmp5P01v/RlaTWQkyDRTL5B6rhre/pZM6+FkfvJLm7s+PPwnpxSYRWnfgeYDydCBi
         4gtakYsPRE5DVGtzu8CNeY1VjLbl4Rs/YLraO/iCH6KsGj24I9LOmhs5qx/8Gy3i8ifd
         6U+HEXEgbM6H5bw6lfuAXZWkvVbvbaZCUKgt6THYWFGrxpqWoDj0TDChTQ0ksXg9fbX/
         O4hg==
X-Gm-Message-State: ANhLgQ27Cpxz1CdQNIeA5WNdynIgRYGvX6z4RKRWcfybHIYDgAeeCH5L
        ef8NEQ069v2tEJEgx2j5zkM=
X-Google-Smtp-Source: ADFU+vtlDNtejSJlionFrhBrLAFz9iJru7A7mzqA5FGpl9fm28MXkpa3xaV+oKuJIPH0KvtIfUwWyQ==
X-Received: by 2002:a17:90a:c383:: with SMTP id h3mr11778206pjt.119.1584131477313;
        Fri, 13 Mar 2020 13:31:17 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4927:51b8:6d1e:6c02])
        by smtp.gmail.com with ESMTPSA id m12sm12656000pjf.25.2020.03.13.13.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 13:31:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Kai Makisara <Kai.Makisara@kolumbus.fi>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 4/5] scsi/st: Use get_unaligned_be24() and sign_extend32()
Date:   Fri, 13 Mar 2020 13:31:01 -0700
Message-Id: <20200313203102.16613-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200313203102.16613-1-bvanassche@acm.org>
References: <20200313203102.16613-1-bvanassche@acm.org>
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
