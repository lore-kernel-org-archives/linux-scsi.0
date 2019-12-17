Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B76FC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 20:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5810921775
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 20:19:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="BIIiesen"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbfLQUTW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 15:19:22 -0500
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:42828 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbfLQUTV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2019 15:19:21 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id 47cqHF430Hz9wSyr
        for <linux-scsi@vger.kernel.org>; Tue, 17 Dec 2019 20:19:21 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5w2jPRUOTeRv for <linux-scsi@vger.kernel.org>;
        Tue, 17 Dec 2019 14:19:21 -0600 (CST)
Received: from mail-yw1-f72.google.com (mail-yw1-f72.google.com [209.85.161.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id 47cqHF2qJMz9wSyv
        for <linux-scsi@vger.kernel.org>; Tue, 17 Dec 2019 14:19:21 -0600 (CST)
Received: by mail-yw1-f72.google.com with SMTP id w4so9017424ywa.16
        for <linux-scsi@vger.kernel.org>; Tue, 17 Dec 2019 12:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fJwaMd0fevbKHZRU0DLVKij8pzUPa0WqyxtmIkNc4nI=;
        b=BIIiesenVHGdLybihTNSiz9akMOJgqJB/KZrr41D83IdTw8S0npY8pyX2dVEpFz9Bk
         D+jOWBkFBTbSLx38QGtySEZDRO92UNW6FKZctKpjaZEvmYqsE6UFNtBFMkgOSWLSVa4b
         vlGy1LRip6Glu//0b8mCBwqJDen3NFPPBjXRnv0g+wAcOuIwczEu7NdgWiYDK4PPxKhz
         wydldm2ye3vqXiKsqn+1XZHV+sl9eUrYaUACEqXywqybpsYDjFZ0bXo9vt61gQncKv4p
         5ANWcVURre3pINJzU10Sprls62+dJjaywt4r5teZ9Xjev6LwDDRtI+EfdvQkSe9E3JXq
         n8NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fJwaMd0fevbKHZRU0DLVKij8pzUPa0WqyxtmIkNc4nI=;
        b=LNBnT+eWaPzthDMQbgK7GJ+GxBbjh9pMTW5PzoK8b9AlLEehosQ7HB+MZeSEiqwSI6
         T7WTbDrSXqNRFh6N8GDvQTKZ3vorGebPinTAf4nW7i9wzZjxQ/V+Z9Ygk4OT87Usj2gd
         rUkWiSx4SdoCGzKkfwcYEM3YPmAgDGv+xpngX1LVJdwAK2sOFTFQ50bvhaYDcfmxhbvZ
         8tPJoYaF3i+DoqEIvw+IbkzVoFSra7DuLmx9dtRFxmgIGK+kl7jzUgKIJBiVuu+v3WQD
         p3A0I4zfZYdKJ3aVlzj3bbh1MyIdy0DfAQMgU7LGHCUZwk7fLAUTVMXho7imDRo+0Rw0
         cxkA==
X-Gm-Message-State: APjAAAUSdoiv7JEyjgE0rXSroE8iSuCTX5yobkQW98kOLqofhylXLg4x
        8bMlh1HAy3H/bEsf5K/EbNj4hiJMoxUYng0mpEuz2Dez5FySDH9nQt+MZT0K8Yqna0WVUtq11KR
        Pdbf4fQIUG2Khj5uLk1K4g2h3yQ==
X-Received: by 2002:a0d:cc88:: with SMTP id o130mr417361ywd.498.1576613960858;
        Tue, 17 Dec 2019 12:19:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqxKBAqrOGl8Ps9Kd5+AyKOknjkvcMjbw0ckO8Lbf0tbis1QNrvjC6bGBJxzmqXoYdaNOLVOuQ==
X-Received: by 2002:a0d:cc88:: with SMTP id o130mr417339ywd.498.1576613960611;
        Tue, 17 Dec 2019 12:19:20 -0800 (PST)
Received: from cs-u-syssec1.dtc.umn.edu (cs-u-syssec1.cs.umn.edu. [128.101.106.66])
        by smtp.gmail.com with ESMTPSA id w74sm3184157ywa.71.2019.12.17.12.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 12:19:20 -0800 (PST)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: aic94xx: remove unnecessary assertion
Date:   Tue, 17 Dec 2019 14:19:12 -0600
Message-Id: <20191217201914.27672-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In asd_unbuild_smp_ascb, the task is never NULL when called from
asd_execute_task and asd_task_tasklet_complete. The BUG_ON assertion
is thus unnecessary and can be removed.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/scsi/aic94xx/aic94xx_task.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index f923ed019d4a..6aa75777fff1 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -452,7 +452,6 @@ static void asd_unbuild_smp_ascb(struct asd_ascb *a)
 {
 	struct sas_task *task = a->uldd_task;
 
-	BUG_ON(!task);
 	dma_unmap_sg(&a->ha->pcidev->dev, &task->smp_task.smp_req, 1,
 		     DMA_TO_DEVICE);
 	dma_unmap_sg(&a->ha->pcidev->dev, &task->smp_task.smp_resp, 1,
-- 
2.20.1

