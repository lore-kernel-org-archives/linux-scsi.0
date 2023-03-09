Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC90AC6FD19
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbjCIT3F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjCIT2i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:38 -0500
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC60260D48
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:30 -0800 (PST)
Received: by mail-pf1-f171.google.com with SMTP id n5so2181911pfv.11
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JCDnsBDyD5KdL/cOWwSjhVPjFE5ySWXB1GfjV8JeIjI=;
        b=AUzMUzBaFaEj8YIsXa/PZoCqQ/tR9yR3eNtlXQdgLSGhKnlku6r5Px9JibTHvynzzB
         6JHyrrXI4SbR47BIesKTibqxWV5HJ8klJTI2Y7xmTXvLpqCITPR5g50a5ZmFcz9DaKkh
         Jhyl5Eb+kppvxkBTosSJCfFhpN24ePGCMV4j8sqwLjJK/qibznx4skkc2EWtYIgx5Nmo
         PmCKo6y34ZBda+ebyj1ZyvVz2zDf9HMXUX2E5k+GFJBS206P3ahjAtj/fJLfz++GFBRy
         3mSQUNnc77hor6UFcGqAI8AEoxZCl5pL4bN5CD6nyqQ0xhz0cfoZQCBgplMS2y0hEiqG
         zLcw==
X-Gm-Message-State: AO0yUKVOen1EaoVfwXtgJs95G8jyVB9ZR2VJVpPxypzq8cVvyGdS29SG
        0KMj+NRAWNR0+i+9VwiKxkk=
X-Google-Smtp-Source: AK7set+Rb8NPY1p7l7VEhW7wnYd5P+NhrFANBKvjr3I7HlZJnJsfiv9CgMFDjNXvB7FCRqNP7GCMDA==
X-Received: by 2002:a05:6a00:8010:b0:5a8:c469:e47c with SMTP id eg16-20020a056a00801000b005a8c469e47cmr24584776pfb.10.1678390109958;
        Thu, 09 Mar 2023 11:28:29 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:29 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 36/82] scsi: fnic: Declare host template const
Date:   Thu,  9 Mar 2023 11:25:28 -0800
Message-Id: <20230309192614.2240602-37-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fnic/fnic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 1077110ab273..984bc5fc55e2 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -95,7 +95,7 @@ static int fnic_slave_alloc(struct scsi_device *sdev)
 	return 0;
 }
 
-static struct scsi_host_template fnic_host_template = {
+static const struct scsi_host_template fnic_host_template = {
 	.module = THIS_MODULE,
 	.name = DRV_NAME,
 	.queuecommand = fnic_queuecommand,
