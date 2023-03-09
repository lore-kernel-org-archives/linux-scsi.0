Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50341C64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjCIT11 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjCIT1S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:27:18 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEDEEB89F
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:27:15 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id p6so3162266plf.0
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:27:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qFxngvs+9YQWf/cm0pKR7KdAZBfNtlH0C+J3zrjYTbg=;
        b=Uj/kzSbPh26++vDSlhauYL9M87eF1S4Y/T15KqqGN6zz2S8B8NMf+F8pgpTCXeUbCh
         floUeNhCFpkHj28FZTxqbEmI2yM1ING+0IBMBgwhBCxLEFnwh5kmWp4U7RSn6/1NH7wg
         TG18CPgfGWScXIEBx4F4LXyWSlmC9kJ27U6lMPXYlaUekGe2wqs7S6mAbd1CjlUn9y47
         V0RbqlUWHGgacNr3rRxf/nq8ryJMBHvMxX3l/zl9q3phaTi2Ttku4QuQS+n0qOkcpPW5
         rfWEwjbkn1ZR7S5m+4+LMtvwk0u9P78TwqzeVAgHlbL7prgX/n2NzyXVPHn2H5DMZBG8
         vXeA==
X-Gm-Message-State: AO0yUKXo1A6lc66QR2yknNBok0kRsGGBHLnVfLnTmUJIDzwxLThay98/
        p9EUMfcyLI8V3SHlgzZDamQ=
X-Google-Smtp-Source: AK7set90QUNEThpyucUD+awcI/bnRevmucRCPnCnYGmnMNNkHjvLtFaKpcyoZJWo0V1PNetCT6400w==
X-Received: by 2002:a05:6a20:729f:b0:cc:4058:82bd with SMTP id o31-20020a056a20729f00b000cc405882bdmr26837291pzk.13.1678390034866;
        Thu, 09 Mar 2023 11:27:14 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:27:14 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v2 07/82] scsi: message: fusion: Declare SCSI host template members const
Date:   Thu,  9 Mar 2023 11:24:59 -0800
Message-Id: <20230309192614.2240602-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host templates are not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/message/fusion/mptfc.c  | 2 +-
 drivers/message/fusion/mptsas.c | 2 +-
 drivers/message/fusion/mptspi.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index fac747109209..22e7779a332b 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -105,7 +105,7 @@ static int mptfc_abort(struct scsi_cmnd *SCpnt);
 static int mptfc_dev_reset(struct scsi_cmnd *SCpnt);
 static int mptfc_bus_reset(struct scsi_cmnd *SCpnt);
 
-static struct scsi_host_template mptfc_driver_template = {
+static const struct scsi_host_template mptfc_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptfc",
 	.show_info			= mptscsih_show_info,
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 88fe4a860ae5..86f16f3ea478 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1997,7 +1997,7 @@ static enum scsi_timeout_action mptsas_eh_timed_out(struct scsi_cmnd *sc)
 }
 
 
-static struct scsi_host_template mptsas_driver_template = {
+static const struct scsi_host_template mptsas_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptsas",
 	.show_info			= mptscsih_show_info,
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 62089a8caa2f..6c5920db1e9d 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -820,7 +820,7 @@ static void mptspi_slave_destroy(struct scsi_device *sdev)
 	mptscsih_slave_destroy(sdev);
 }
 
-static struct scsi_host_template mptspi_driver_template = {
+static const struct scsi_host_template mptspi_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptspi",
 	.show_info			= mptscsih_show_info,
