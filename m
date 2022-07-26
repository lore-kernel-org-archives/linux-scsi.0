Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 113D7C04A68
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jul 2022 18:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbiGZSDQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jul 2022 14:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbiGZSDO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2022 14:03:14 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42EA327CC1
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2022 11:03:13 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id n2so11547541qkk.8
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2022 11:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references:reply-to
         :mime-version:content-transfer-encoding;
        bh=/LlJS+c4z5EF0xVWwVlF/+vbZfiCvXE/dVVbos7K3YE=;
        b=lazB21oOHJAdA5S94GDFgCgM0NpG4kIXGrPoWEinFg1EcvXFCFjcDKo1iXCg7u8kRX
         soccgF/njiS5sbQqncnu5TKNPEYHzH1dyI3HpBaH07qp8Z5aaXFWDvGUv7gtv/TwEhfh
         +7eV8j9STcVxgAhzYQSn4Cvm5xalXmytvbGU+CqYA0nb7gQzCXP2v9pXhMwY+lkJ4BNk
         3hV6syaKKXXbqa9NTmvBBjz+uLe6V0FL/+sgWnlFnN9XrGy3bft+Z6PfBQp3jeBg28wh
         0RtrCF/qZcJqkD0odn9DmI1l9QTPObYVMcBh8kVYValO62Y9vD2d+BUHxLHxNK9TW3Gp
         8h5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=/LlJS+c4z5EF0xVWwVlF/+vbZfiCvXE/dVVbos7K3YE=;
        b=TjduR/+oUOpXIHYV0/kNklxW3xOKBubkpF4zuYwUN6gVOAG9yPISJiulyFfuS7tTMo
         9h23iNQxFgyNVfUpJG0yx3XfMkM+diyqeF8TdJxkQa65C+klYa13F24XUbY3jNtREqzr
         BVPqJXsdLjNzekv7uzrtbfcViuzdkmPb9TyM6aF4QMm+sSeNnTkEJetENsZpHyqNaD9E
         tTS0adJlwCcEuthRsEToj0htfck5hqWGdPQql367epqOSwngXSxIBLErSzngo7OHajor
         tPnNfZEQxiKvs8+1CXGWWsZ48C3kAx0dGTiENkcO+HJmP5Iz79ohkdEu5dyw4gvu0AfP
         RmuQ==
X-Gm-Message-State: AJIora+Ly2tnYG1JmonIGqmghidzRyrUygbU2Ow7eYIYAtxAgl01aCRC
        mcrIEo5PYDOsLN4IysaQ07gGoXVic+O8uw==
X-Google-Smtp-Source: AGRyM1vNKl9nhUmXs0etg6oFc8iJfaI8OEHIFcCS9L5th0djN8mpEZUD3AZ1LarbDNL5Zzz4KZ/7tA==
X-Received: by 2002:a05:620a:f8f:b0:6b5:be6c:255e with SMTP id b15-20020a05620a0f8f00b006b5be6c255emr14119367qkn.638.1658858592169;
        Tue, 26 Jul 2022 11:03:12 -0700 (PDT)
Received: from centos7-test-jenkins.localdomain (sw.attotech.com. [208.69.85.34])
        by smtp.googlemail.com with ESMTPSA id y8-20020a05620a44c800b006b5c5987ff2sm12471160qkp.96.2022.07.26.11.03.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Jul 2022 11:03:11 -0700 (PDT)
From:   Bradley Grove <bradley.grove@gmail.com>
X-Google-Original-From: Bradley Grove <bgrove@attotech.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        suganath-prabu.subramani@broadcom.com,
        sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        Bradley Grove <bgrove@attotech.com>,
        Rob Crispo <rcrispo@attotech.com>
Subject: [PATCH 2/2] scsi: mpt3sas: Disable MPI2_FUNCTION_FW_DOWNLOAD for ATTO devices
Date:   Tue, 26 Jul 2022 14:01:03 -0400
Message-Id: <20220726180103.31575-2-bgrove@attotech.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220726180103.31575-1-bgrove@attotech.com>
References: <20220726180103.31575-1-bgrove@attotech.com>
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

