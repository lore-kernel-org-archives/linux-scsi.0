Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17EF5C6FD19
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbjCITaW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjCIT3S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:29:18 -0500
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5FBCF999
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:29:17 -0800 (PST)
Received: by mail-pf1-f179.google.com with SMTP id b20so2199057pfo.6
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:29:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390157;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dfUNV5XAjPKJxQkNcgHdjbQdBWQvUazYP8mFmRY6Fik=;
        b=YkbFc8zgfAJX9SPXVdn211Yjpzc53Ti1UyaEdEhlX94qps2VOLcxoto0l/Vf7mdHaU
         dCnnawKN/uJnr9gYOf64zjGt6znpJHoc2yGd6uJMxWO9Cj9UT7uQ5HRbsHals7dewijf
         9bAVfcVAkTrK+e2Zvd1DGeDpCADHON8Gn05MMCit+wp/MiYQDFcKIt38iDinPWj15XTx
         xr47ffRuwRas2dHjNk2eJZPoqNds5Z8B8t9YHf9D3/Alkek3yvYq2TWO1E9HIMrI4gIP
         vbzxLHI9vEGMI4KeYyOIn+J63sT0TKUzXHxUlxUMYo4KzPcqn0hvm6ISPfLy8xFsbEmz
         TVCA==
X-Gm-Message-State: AO0yUKWp+P6zL03foY3KEbZXblN5HRirdeuVmPR3v2ufJoGPXtLpjKoC
        DgLjr1pZMDcPEoIfE2YzB6Y=
X-Google-Smtp-Source: AK7set+nkEml9Tzq9l3oA6W3dhgUeXHLMv/QmktO+Gi3T4irfRNzaJA7qwUFvsBzaHIBp71oBzCvEA==
X-Received: by 2002:aa7:9909:0:b0:5a9:fa49:904c with SMTP id z9-20020aa79909000000b005a9fa49904cmr20951208pff.5.1678390156714;
        Thu, 09 Mar 2023 11:29:16 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:29:16 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 54/82] scsi: mpi3mr: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:46 -0800
Message-Id: <20230309192614.2240602-55-bvanassche@acm.org>
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
 drivers/scsi/mpi3mr/mpi3mr_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 6eaeba41072c..207a607d8997 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4757,7 +4757,7 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 	return retval;
 }
 
-static struct scsi_host_template mpi3mr_driver_template = {
+static const struct scsi_host_template mpi3mr_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= "MPI3 Storage Controller",
 	.proc_name			= MPI3MR_DRIVER_NAME,
