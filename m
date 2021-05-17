Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20089C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 13:25:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2B18610E9
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 13:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235885AbhEQN0P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 May 2021 09:26:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54885 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233552AbhEQN0O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 May 2021 09:26:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621257898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4C6fFCyDeeziYXRKHCjm+MM9+mWW1Oj4OkJbOQOd//w=;
        b=Apo6aANBUIy95OXu+Y1UDICImH19Yrr7T5WFzK3rgpN+rWmzGrDXo523fLwtjSEWxas7oA
        3tNtKCBskg4ZWMngHCNdWoF2y/QOvMI9gArFurR9VyidYGYOc9gA/8cO9K3OXl+Cj0wzkH
        aB//VlIlRiC3D8+680icPRS7X36JV20=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-jybxXo6KPZmetXqhrLKloA-1; Mon, 17 May 2021 09:24:56 -0400
X-MC-Unique: jybxXo6KPZmetXqhrLKloA-1
Received: by mail-qt1-f200.google.com with SMTP id o5-20020ac872c50000b02901c32e7e3c21so5202148qtp.8
        for <linux-scsi@vger.kernel.org>; Mon, 17 May 2021 06:24:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4C6fFCyDeeziYXRKHCjm+MM9+mWW1Oj4OkJbOQOd//w=;
        b=TdlwbaHd1nBY4WscyztjBg67jJkO7T6fnxccBM9xu48WOn8Iuu7ZdN/PqWrJAvt/xP
         QmrvgPRH/XuLKvnv87YpCstTutyntH4EC1ERvnHzbhYyMOkNyVGWEjOFMs8TfmTDQ9VQ
         sj1IlmezMdBOwRNcwR6x1JWwxRi/uVURxTJ4gR/d0kEfhVuWD5bTy2m/F+DXE+iDd/bm
         VAYvnuIizXdeJ9qmkI9nvmdTu4xNy21RP+BEh6OSBb0xyOLeTXpYhk85SsyIwBrU5B8t
         e9GpDLNeT8fZMl+s0mZdjeubOE+ImOrynHTafrtyymLJrbLmsBd3uNB7+1pTctjJjk1+
         Sl5A==
X-Gm-Message-State: AOAM532BTH2yBGNvTcl6iQ3kcNE8TyAuC+wbGgi/LpISYKlO+O1werIU
        4pqoNlk7nqVgbt6J7EDMzPGaNw6zcC0nakQxVh4STQMLq9Bjvv+ACWxpYZrQbMguVKa/W8afkgc
        Xm6Rx0V+5d+Rcz6OLiwe42g==
X-Received: by 2002:a37:a6c6:: with SMTP id p189mr57669821qke.161.1621257896167;
        Mon, 17 May 2021 06:24:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCOpr7LsznsbLnBxVZvK3QSovzHlEmsmNqkrCGex478g/I2PC7rttrh4zgDS9QtpOkt9JzMw==
X-Received: by 2002:a37:a6c6:: with SMTP id p189mr57669805qke.161.1621257895984;
        Mon, 17 May 2021 06:24:55 -0700 (PDT)
Received: from localhost.localdomain.com (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id 195sm10125537qkj.1.2021.05.17.06.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 06:24:55 -0700 (PDT)
From:   trix@redhat.com
To:     hare@suse.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] scsi: aic7xxx: restore several defines for aix7xxx firmware build
Date:   Mon, 17 May 2021 06:24:51 -0700
Message-Id: <20210517132451.1832233-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tom Rix <trix@redhat.com>

With CONFIG_AIC7XXX_BUILD_FIRMWARE, there is this
representative error

aicasm: Stopped at file ./drivers/scsi/aic7xxx/aic7xxx.seq,
  line 271 - Undefined symbol MSG_SIMPLE_Q_TAG referenced

MSG_SIMPLE_Q_TAG used to be defined in
drivers/scsi/aic7xxx/scsi_message.h as
  #define MSG_SIMPLE_Q_TAG	0x20 /* O/O */

The new definition in include/scsi/scsi.h is
  #define SIMPLE_QUEUE_TAG    0x20

But aicasm can not handle the all the preprocessor directives
in scsi.h, so add MSG_SIMPLE_Q_TAB and similar back to
scsi_message.h

Fixes: d8cd784ff7b3 ("scsi: aic7xxx: aic79xx: Drop internal SCSI message definition"
Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/scsi/aic7xxx/scsi_message.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/aic7xxx/scsi_message.h b/drivers/scsi/aic7xxx/scsi_message.h
index a7515c3039edb..53343a6d8ae19 100644
--- a/drivers/scsi/aic7xxx/scsi_message.h
+++ b/drivers/scsi/aic7xxx/scsi_message.h
@@ -3,6 +3,17 @@
  * $FreeBSD: src/sys/cam/scsi/scsi_message.h,v 1.2 2000/05/01 20:21:29 peter Exp $
  */
 
+/* Messages (1 byte) */		     /* I/T (M)andatory or (O)ptional */
+#define MSG_SAVEDATAPOINTER	0x02 /* O/O */
+#define MSG_RESTOREPOINTERS	0x03 /* O/O */
+#define MSG_DISCONNECT		0x04 /* O/O */
+#define MSG_MESSAGE_REJECT	0x07 /* M/M */
+#define MSG_NOOP		0x08 /* M/M */
+
+/* Messages (2 byte) */
+#define MSG_SIMPLE_Q_TAG	0x20 /* O/O */
+#define MSG_IGN_WIDE_RESIDUE	0x23 /* O/O */
+
 /* Identify message */		     /* M/M */	
 #define MSG_IDENTIFYFLAG	0x80 
 #define MSG_IDENTIFY_DISCFLAG	0x40 
-- 
2.26.3

