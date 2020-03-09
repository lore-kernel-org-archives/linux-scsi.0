Return-Path: <SRS0=qdS7=42=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28558C10F27
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 15:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F034C208C3
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 15:53:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y5wSdA1s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgCIPxg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Mar 2020 11:53:36 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:47015 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgCIPxg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2020 11:53:36 -0400
Received: by mail-pg1-f196.google.com with SMTP id y30so4867961pga.13;
        Mon, 09 Mar 2020 08:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0QOwGWZDroTuYZKUvEz4ThZBE28k0R9BlVBpj2B89t4=;
        b=Y5wSdA1sUAyKXpPWRphvCWwfduXynvra+u0WNhAfzkPhfNscROVbGY1S/bkaVAtR0d
         DWMvs8OIREJ2zcLq4NdG0hahwt1OzZt2yRnkl7O5eDMvo3y7kE/ujGZIGHRI7Tdp844p
         PBvypNHY1xNK/dsjrSC5IB/6EysRnW3R9ehUfxBd8dbMeyyS6mcs+V5dZYdnDZfV0SCY
         60WQA2j3zEZQ9Sv9UYyTU/rf4JJRqKbPXsvRewmszm/qQgtdpewpwyyvdysdb8ROXcVj
         Ti4UFYqV1Xp5vL87P/TG+TtI1QU22yrhdESprjAPQyapSkpHbXI+Ea4QsO5OxvEphEEg
         Gwkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0QOwGWZDroTuYZKUvEz4ThZBE28k0R9BlVBpj2B89t4=;
        b=iqu/wZSi/w3IsN//BSOcRQJNz/Up/UoNNwAjqHd86lFJcrOfLNchLKLycgGGQHK2za
         AKiKpYnkTOptXWUQVWqrY771FJ50zwVgpD7k4/CjdwXxOl5q7gKYHOfO6RcNFbxiCQTA
         Gzw/mM6bQnvgcU5epJc9QXVFwvkEalRtUcxOzwiWmbpHTx1sDe+lVKbaWxm1s8Csb+zz
         DeWmTFeH6+pdcTO17QEo8HcYFasO81IVShLiaU1RVTyjGNIZeO1v/UEpp7Ak9plnDO62
         wi+j3Ze6ADZ7UkrMhOF30RfCT2ZqJrIuPfuGHCJAAR5pcJsqLCVw6SbZb/LE86nwbGDV
         A8wg==
X-Gm-Message-State: ANhLgQ0gDNnx0Ys2fo4nxK43NdSWTwTikPIuG66TreEpXFN7op7r1Hbz
        vVpGm4traA1u5XF+X3KTSHQ=
X-Google-Smtp-Source: ADFU+vuQluF3zszB7MLftbqie/sqdqSHh8ucl+t/SkIiqtpGEtE4K7yJ2sP012gDBJrIwKyGUerv9w==
X-Received: by 2002:a63:1862:: with SMTP id 34mr13988788pgy.191.1583769214024;
        Mon, 09 Mar 2020 08:53:34 -0700 (PDT)
Received: from debian.net.fpt ([2405:4800:58c7:2b5b:996c:8b3a:a70f:c38a])
        by smtp.gmail.com with ESMTPSA id w31sm19138587pgl.84.2020.03.09.08.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 08:53:33 -0700 (PDT)
From:   Phong Tran <tranmanphong@gmail.com>
To:     john.garry@huawei.com
Cc:     aacraid@microsemi.com, bvanassche@acm.org, jejb@linux.ibm.com,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        tranmanphong@gmail.com
Subject: [PATCH v3] scsi: aacraid: cleanup warning cast-function-type
Date:   Mon,  9 Mar 2020 22:53:19 +0700
Message-Id: <20200309155319.12658-1-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <9a0e6373-b4a3-0822-3b65-e3b326266832@huawei.com>
References: <9a0e6373-b4a3-0822-3b65-e3b326266832@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make the aacraid driver -Wcast-function-type clean
Report by: https://github.com/KSPP/linux/issues/20

drivers/scsi/aacraid/aachba.c:813:23:
warning: cast between incompatible function types from
'int (*)(struct scsi_cmnd *)' to 'void (*)(struct scsi_cmnd *)'
[-Wcast-function-type]

Reviewed-by: Bart van Assche <bvanassche@acm.org>
Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/scsi/aacraid/aachba.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 33dbc051bff9..ebfb42af67f5 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -798,6 +798,11 @@ static int aac_probe_container_callback1(struct scsi_cmnd * scsicmd)
 	return 0;
 }
 
+static void aac_probe_container_scsi_done(struct scsi_cmnd *scsi_cmnd)
+{
+	aac_probe_container_callback1(scsi_cmnd);
+}
+
 int aac_probe_container(struct aac_dev *dev, int cid)
 {
 	struct scsi_cmnd *scsicmd = kmalloc(sizeof(*scsicmd), GFP_KERNEL);
@@ -810,7 +815,7 @@ int aac_probe_container(struct aac_dev *dev, int cid)
 		return -ENOMEM;
 	}
 	scsicmd->list.next = NULL;
-	scsicmd->scsi_done = (void (*)(struct scsi_cmnd*))aac_probe_container_callback1;
+	scsicmd->scsi_done = aac_probe_container_scsi_done;
 
 	scsicmd->device = scsidev;
 	scsidev->sdev_state = 0;
-- 
2.20.1

