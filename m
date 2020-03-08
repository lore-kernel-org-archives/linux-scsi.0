Return-Path: <SRS0=held=4Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFBE3C10F26
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 02:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94E1E2070A
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 02:01:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qA/jUti5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgCHCB4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Mar 2020 21:01:56 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:50352 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgCHCB4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Mar 2020 21:01:56 -0500
Received: by mail-pj1-f67.google.com with SMTP id u10so1163828pjy.0;
        Sat, 07 Mar 2020 18:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xWsdMdzmWNya+Ylq3sHe7fr3e4mFBlxWLSMgspX6k2Y=;
        b=qA/jUti5vzb3Mo+e2cgb8WDs/kvIm2BkbG0DZHQfINF8TTmgdLVt1Vz2BhRVNA393u
         92wJtCjrO0CvPcg4J5sSvPHk2cT+2eQo80pHE9I82BbqqSOj+nYr5hDCoTvIwTga4MD1
         A0I/upEzAx0l4tvq9lIg3K8kzhcBUzHqmzBfrw2TqlNq3Biqo+pr6RtfA2EMits+GAIF
         a6Ox1J/yZ1qYfHs2P6IJ9Yf6VCYyrGIWt4RYEzwnDzFO79socga8h1g0NmqEXgQpQhaT
         3RFrj2DblSHgLRfW0rJixl42F752oySdh2h1kt6ql13NtH6+x2wgXgMbGwuaSVDbL0ss
         JWYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xWsdMdzmWNya+Ylq3sHe7fr3e4mFBlxWLSMgspX6k2Y=;
        b=Jq04JFfyZ072DB6ZYPkWyJ6DyZGoxr9Qcj/b+UDnB6ORvC2YkmOf1LjeKC3CUSNnmD
         l5XYnnoKjvulKSPBB4M2BHbp8lx+Z2uY7My6n1pg/YR1B0BjJ7H/VmZp+MXvrWJFQgIE
         IXw9mWi+GaZyGQZWzsZWP6kovrjjEvpxSQ712qj//JbCUZOknlflRIb5BxlL4ux+KW0Q
         547Rsg8hhSt4btMQ4uaa8a35Cy2zxGPl7Ll+IUjva8qHasHS6Z0Q+DM5ihC2i8rmqzRX
         LHiRNjU+4xfNZ6+W2PuETaw2e8Nulcfi6fXtrQ3Ew5hPwPuiah78cSxDH5YA72LgEoOm
         92gA==
X-Gm-Message-State: ANhLgQ3VRrHF08lPOgmN4ripl4Ou6ggTfjc9EPksVFpxV3Uc0wfmwQ9u
        gOYlQd9yRDJ3NsBVwP9mhldUmRMysIY=
X-Google-Smtp-Source: ADFU+vs+QzZ3fzrwj+AwOf+xxfGBNxm6pqWcYBFcwk2Q4q1mhomLmeQKBEEFYy/RBOyVFenH3aYafw==
X-Received: by 2002:a17:902:8f91:: with SMTP id z17mr9916158plo.234.1583632914923;
        Sat, 07 Mar 2020 18:01:54 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:4735:1319:cf26:e1d9:fc7c])
        by smtp.gmail.com with ESMTPSA id h29sm37758278pfk.57.2020.03.07.18.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2020 18:01:54 -0800 (PST)
From:   Phong Tran <tranmanphong@gmail.com>
To:     aacraid@microsemi.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, bvanassche@acm.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        keescook@chromium.org, Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH v2] scsi: aacraid: fix -Wcast-function-type
Date:   Sun,  8 Mar 2020 09:01:43 +0700
Message-Id: <20200308020143.9351-1-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200307132103.4687-1-tranmanphong@gmail.com>
References: <20200307132103.4687-1-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

correct usage prototype of callback scsi_cmnd.scsi_done()
Report by: https://github.com/KSPP/linux/issues/20

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/scsi/aacraid/aachba.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 33dbc051bff9..20ca3647d211 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -798,6 +798,11 @@ static int aac_probe_container_callback1(struct scsi_cmnd * scsicmd)
 	return 0;
 }
 
+static void  aac_probe_container_scsi_done(struct scsi_cmnd *scsi_cmnd)
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

