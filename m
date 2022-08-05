Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FAE3C25B08
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Aug 2022 17:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241315AbiHERrg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Aug 2022 13:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241318AbiHERrb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2022 13:47:31 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431DB75393
        for <linux-scsi@vger.kernel.org>; Fri,  5 Aug 2022 10:47:29 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id i24so2360195qkg.13
        for <linux-scsi@vger.kernel.org>; Fri, 05 Aug 2022 10:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references:reply-to
         :mime-version:content-transfer-encoding;
        bh=/LlJS+c4z5EF0xVWwVlF/+vbZfiCvXE/dVVbos7K3YE=;
        b=dGCWoXOSrYcCmNZoG34BN9on1y+U6sa1hA1OqT2TbOIIJ8VjU/ARhD4veqCqdAZf0q
         QyvGLRYkFJmGIPcAjOGwfGhmCYMlvwm4mVeVZ2Dkr+zbrZhVhoRRzibz3LwOc3tWgYUe
         74rxjww+hu3EqoNh4iX7y/IVHVmfWOS/g0wiLJvTCgkPdRSCaOW1aipyZ0bmF9I96KIx
         m8G2A/87tkHd8l8uO77xWVzm1un48mCDAaQ/N3CzUYH0d8zBxt0p22uz/7NwkRdDOrli
         apyZDVEW5EwwCLwjvLxlIaGW0QtmqqUKwGqLwty+XBtIgsNXgaEimIbd2I51ZXEzuZQV
         9P8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=/LlJS+c4z5EF0xVWwVlF/+vbZfiCvXE/dVVbos7K3YE=;
        b=ioghb4LmxDbjMElIEkJGEXN3XYfjfXNaoXnySs1mkps0bNzE7NNNTt9cUUHLooq3Y8
         qLHGZq6hvmztYfwQoaFRAB+AKrv3iXnxBZJqKEULOHnZnHdhW9zgNIhFl81Ov3ieGZkh
         Iciw+1nu5CH/OUC4juKpWkV8noBTq4pDNezX5kNwVaq1tpMb8fsVw7X8vs1takrEhyAK
         mu0wN/AQmREzC8r7CPmaVSo/YCBn0nThVkGZ03dK4QMAZLrqgRz4k0id8v5BKvS4iaCf
         2t5VDXSqzQKNsA+hV5KgcWDpb5rR/VqBCZnW+BAfyVL1vZd6EnWHNCctuHOs7FhQzCyg
         UGlw==
X-Gm-Message-State: ACgBeo3iODCBlwaEqzFA/6UtpBexfN9fuuE7e9w9Mes8aGTSp20jaErw
        olABWVGKsAUekvqe89ZV9gcOIeMAleC6PQ==
X-Google-Smtp-Source: AA6agR7tXfUqg6UD4jVFH06QRJLwfV7mnqWq74hrN51FD8szZj/DnbrEzYwpRe8vbctHgz9lWgoxLg==
X-Received: by 2002:a05:620a:4908:b0:6b8:e363:8ce9 with SMTP id ed8-20020a05620a490800b006b8e3638ce9mr5989410qkb.88.1659721648163;
        Fri, 05 Aug 2022 10:47:28 -0700 (PDT)
Received: from centos7-test-jenkins.localdomain (sw.attotech.com. [208.69.85.34])
        by smtp.googlemail.com with ESMTPSA id u17-20020a05622a011100b003051ea4e7f6sm3176554qtw.48.2022.08.05.10.47.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Aug 2022 10:47:27 -0700 (PDT)
From:   Bradley Grove <bradley.grove@gmail.com>
X-Google-Original-From: Bradley Grove <bgrove@attotech.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        suganath-prabu.subramani@broadcom.com,
        sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        Bradley Grove <bgrove@attotech.com>,
        Rob Crispo <rcrispo@attotech.com>
Subject: [PATCH v2 2/2] scsi: mpt3sas: Disable MPI2_FUNCTION_FW_DOWNLOAD for ATTO devices
Date:   Fri,  5 Aug 2022 13:46:09 -0400
Message-Id: <20220805174609.14830-2-bgrove@attotech.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220805174609.14830-1-bgrove@attotech.com>
References: <20220805174609.14830-1-bgrove@attotech.com>
Reply-To: bgrove@attotech.com
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Disable firmware download for ATTO devices where it is not supported.

Co-developed-by: Rob Crispo <rcrispo@attotech.com>
Signed-off-by: Rob Crispo <rcrispo@attotech.com>
Signed-off-by: Bradley Grove <bgrove@attotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 84c87c2c3e7e..1c99338a71a4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -948,6 +948,14 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		break;
 	}
 	case MPI2_FUNCTION_FW_DOWNLOAD:
+	{
+		if (ioc->pdev->vendor ==  MPI2_MFGPAGE_VENDORID_ATTO) {
+			ioc_info(ioc, "Firmware download not supported for ATTO HBA.\n");
+			ret = -EPERM;
+			break;
+		}
+		fallthrough;
+	}
 	case MPI2_FUNCTION_FW_UPLOAD:
 	{
 		ioc->build_sg(ioc, psge, data_out_dma, data_out_sz, data_in_dma,
-- 
2.36.0

