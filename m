Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7537C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384330AbiBHR0Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384358AbiBHR0W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:26:22 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462F9C03FEEA
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:26:14 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id v4so11077895pjh.2
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:26:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NFKW4dOo/Xf01/0PtVmG2vqtR1RJIFHWVoQ11+RrB04=;
        b=4VZpbx539qyXJn+uvsMt4ITRlufP6dHTjKNnBHlnvfXT2+3IbRRuv78Gq85P/x+JvX
         eEBpcd7IR4NAFt+pvgEo7SxSeqDA4wbtsATtgaXer1QpUwI9YJeOhZqB3/UTe5TW2Oc7
         EhfQNfi8paPGWWfFZqgETZ7FuHUolpy+cSxhWJCvLkdrTfb7FUdtC/yzeGUVfVMHMudw
         ermaBSiLcySuFeuLCXIEcUUJS6OzER/ab6w2oy5bM8iyTuMD3Eqt4fpCbw6hUfe9FOYk
         js+aLyPFx5udJ/w8Jy2Tg0evuRfSPzY4uOOn+0ePSYI8Rikq4TfDQ3rPgDjYN6MIP2rX
         16EQ==
X-Gm-Message-State: AOAM530jyVz+Hu0iMBvAqsp9SAfiU+76WX5NqO31h1RUTGjFLAKEK3qu
        dPwrZpM/VUNk2QNXWmtPqrk=
X-Google-Smtp-Source: ABdhPJw8asikVc2P47VzScJ0Qwpahx+LZnyifDBR9INaT/VKU0D2NVzt9iJseTAxE3Z5O/0O+cgmkw==
X-Received: by 2002:a17:902:6902:: with SMTP id j2mr5646720plk.141.1644341173565;
        Tue, 08 Feb 2022 09:26:13 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:26:12 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hiral Patel <hiralpat@cisco.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH v2 18/44] fnic: Fix a tracing statement
Date:   Tue,  8 Feb 2022 09:24:48 -0800
Message-Id: <20220208172514.3481-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208172514.3481-1-bvanassche@acm.org>
References: <20220208172514.3481-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Report both the command flags and command state instead of only the
command state.

Cc: Hiral Patel <hiralpat@cisco.com>
Fixes: 4d7007b49d52 ("[SCSI] fnic: Fnic Trace Utility")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fnic/fnic_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 88c549f257db..549754245f7a 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -604,7 +604,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc)
 
 	FNIC_TRACE(fnic_queuecommand, sc->device->host->host_no,
 		  tag, sc, io_req, sg_count, cmd_trace,
-		  (((u64)CMD_FLAGS(sc) >> 32) | CMD_STATE(sc)));
+		  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
 
 	/* if only we issued IO, will we have the io lock */
 	if (io_lock_acquired)
