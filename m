Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A1D5C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 22:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241974AbiBAWjx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 17:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241921AbiBAWjw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 17:39:52 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D37CC06173D
        for <linux-scsi@vger.kernel.org>; Tue,  1 Feb 2022 14:39:52 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id v74so17184212pfc.1
        for <linux-scsi@vger.kernel.org>; Tue, 01 Feb 2022 14:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0GZoUXjQnTH22StSBxliyAhVCzFd+c4Sty+J+gttCT4=;
        b=GvbP91DmhMLjdYOUoegWBpQqb/miyMjy6YYVevT1ZRxaED+A56kRX4KU+JTXwP6nzG
         ERAXGZiwKlE837KdlWrR3j55RfUGKEULV1iLqzKQLpG6nxVXyWhzYAIq8MPXax5d2Xio
         poQqIuMGBCsIYgx28ObzcK9TtItpQK1EoG0/8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0GZoUXjQnTH22StSBxliyAhVCzFd+c4Sty+J+gttCT4=;
        b=0A2lbrsZpOY+3tufeGfJZH1JqnKiaH6VHBrq7PifqJR1QuBK2/UdxrUulZfhW87m3l
         +eMzLJwIhwX9VmJSVQbeDO1LKkfigaU+MnRXSnN274YjxqQi5mefQx8bGacWarakLd31
         T8jSS4v/ah+Fml5RtNfQghSL8FuhhZ/55U/Htn+/S2IsMxFqG2CzIcTNbcuuoraJOutu
         Sclv+K+S/FZphuiVtR6eNZl09GdB9kRnL/NTr0f9fN/1SAUJ9/1qGBUt+u7VeFSBCDtJ
         8ayYbJUaOo5/TLmnOU88zwbHkNx43lILbphnWjE/ZnmBpXKS8IWHzzQ2rj1f5MS4kf4y
         YoIg==
X-Gm-Message-State: AOAM533kC7/CixAcRdge2eIlOzn+LKYatrAVaFkahfKnLo4ctMqVm1fq
        F11CLTDjepO0aXtqxnxFXenxdg==
X-Google-Smtp-Source: ABdhPJwuZ7k6dF/cFiU0qBjgvXbZaVrRvy9/zQsrbVOZdmskpEQFO8XlB1vdoE8SkKsHrEqK9IqH5g==
X-Received: by 2002:a63:8a44:: with SMTP id y65mr22413576pgd.590.1643755191827;
        Tue, 01 Feb 2022 14:39:51 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id pf4sm4305329pjb.35.2022.02.01.14.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 14:39:51 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Sathya Prakash <sathya.prakash@broadcom.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] scsi: mpt3sas: Convert to flexible arrays
Date:   Tue,  1 Feb 2022 14:39:48 -0800
Message-Id: <20220201223948.1455637-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1736; h=from:subject; bh=WqE1lLvEytA82FqSOgu42SZnb+3Opfv2XchLrZmpS1k=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBh+bazzkhdbXAOBFEqdvWi5RQJjP+g3X6lm+CMEChk LUFBymGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYfm2swAKCRCJcvTf3G3AJh13D/ 4zDXtef2HFvEMpK1XRUO77eefGFDwyQKy/IKFT26AwFqQWYu3UQ1rRlVJwcQns/FulB5VU6uXlpDPN ts1X7nJ7LfIy6MPBVtd0wyC3GiT7EcC/fdTZ6upbLbJVjqGwmXfyWRX7uoT0TALJufM/ZEPl5Wy5Sh RGc8a0y/stuk0zpZSfDXqUIFwlGp22Zy85ezBi5ir47s2/inLQoAKtO/zkPPm+d6eyWUQGjkFk0N/u 15fqGj++EYdaPTEuNGTc//q25ADfAtc9Bl/vnynVpBcX1fkVHxPC8W0+7iTW/LtpeunT3UvIZ559pE kOgp6YMot7REfvQa+pU+W53BKbxifbaCQVXj6TbXm6pheVWpNTlzxtnS9WVbdW63166IaEiw05z1Ky jBkhLwWiMJJu1aYKJztca0fp3fgVxn/6IFqhQwaAaylcDyPhvdU4CLwbujPr+KpnYGqjFwegbBlgRt VjGSnIceEsGoQu+TDBzliWwl/8uuwaR5QzJ+UtU9qaVm6wAjcS2bgZ8KRojiLeW1AhsHFkKNVvseZP 3SXI96wuHB9R2eG//G/au2PVD+SPa3KsrMybqBYCBcJwmraphe3gmrIQUlG9vC3LQ7/DyUD3ddtF5O CVe6inKjAL6KYQ0GZuaob/S3tBDC65ygNoxEvp8arfJ1OoadNOwD8P1qdLIA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This converts to a flexible array instead of the old-style 1-element
arrays. The existing code already did the correct math for finding the
size of the resulting flexible array structure, so there is no binary
difference.

The other two structures converted to use flexible arrays appear to
have no users at all.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h b/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
index e83c7c529dc9..2c57115172cf 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
@@ -537,7 +537,7 @@ typedef struct _MPI2_EVENT_NOTIFICATION_REPLY {
 	U16 Event;		/*0x14 */
 	U16 Reserved4;		/*0x16 */
 	U32 EventContext;	/*0x18 */
-	U32 EventData[1];	/*0x1C */
+	U32 EventData[];	/*0x1C */
 } MPI2_EVENT_NOTIFICATION_REPLY, *PTR_MPI2_EVENT_NOTIFICATION_REPLY,
 	Mpi2EventNotificationReply_t,
 	*pMpi2EventNotificationReply_t;
@@ -639,7 +639,7 @@ typedef struct _MPI2_EVENT_DATA_HOST_MESSAGE {
 	U8 Reserved1;		/*0x01 */
 	U16 Reserved2;		/*0x02 */
 	U32 Reserved3;		/*0x04 */
-	U32 HostData[1];	/*0x08 */
+	U32 HostData[];		/*0x08 */
 } MPI2_EVENT_DATA_HOST_MESSAGE, *PTR_MPI2_EVENT_DATA_HOST_MESSAGE,
 	Mpi2EventDataHostMessage_t, *pMpi2EventDataHostMessage_t;
 
@@ -1397,7 +1397,7 @@ typedef struct _MPI2_SEND_HOST_MESSAGE_REQUEST {
 	U32 Reserved8;		/*0x18 */
 	U32 Reserved9;		/*0x1C */
 	U32 Reserved10;		/*0x20 */
-	U32 HostData[1];	/*0x24 */
+	U32 HostData[];		/*0x24 */
 } MPI2_SEND_HOST_MESSAGE_REQUEST,
 	*PTR_MPI2_SEND_HOST_MESSAGE_REQUEST,
 	Mpi2SendHostMessageRequest_t,
-- 
2.30.2

