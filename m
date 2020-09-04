Return-Path: <SRS0=dnbB=CN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41FDC43461
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 20:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 729C32084D
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 20:06:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jAGlZSlE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgIDUGN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Sep 2020 16:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgIDUGM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2020 16:06:12 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D063CC061244
        for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2020 13:06:11 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id s10so1669579plp.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2020 13:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GH3vO2zorCGfPUvIZzkKisvrCrW3Qnmk8aOiUtht/RM=;
        b=jAGlZSlEVcbd43mtRZUEtflBOiKgmHEETXnSYUPQoQZ3/wBaeC/09c3tur/dwWnm5a
         Dn2C/FBR7BsFs3Jegl+/dTzY4NzhFtIVfrDC3kMu3eDfU7lqn3VLyIbcQbpR/5RhoW2e
         gwC784Av+1A64yihrBgAQOLosOh6j7JQ+giHJxFGJ6zU+3RnZK/XiP+2NiROXFyBl6zp
         7l48N6s9fa690oVojbdw3MJ2GY4D0NH1Fqkn2XE/TtQa/MZRDKMJTSZarGBOuc+FESHu
         hyoAkykux3Osc9j0d0BX+xPlZN41N5AG4qbpUvqz6FFB+OMKaDISY29iUF35DeA3TJ7N
         eqFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GH3vO2zorCGfPUvIZzkKisvrCrW3Qnmk8aOiUtht/RM=;
        b=VhcpkvcEYbd+5/y13a9n5rIcN2AjFupEc5N90ouLwUQAEHsLTLJ4nF08h9CFQIWsSs
         AP8Q5zi2RsHnZ3DaLzXSe7ZXy8YG3sw6czHtBHIrM3xyihkt3dilx5HrEuBdSNHZCMRQ
         qbYYJ0zl3+BqWIsbcntQxKEnIq45NS37LOMV5BQtRVUlWQMGc8sPHb+Y4wrCijYNCGzm
         5U/lI0FDhQMrKyFo4GqwD9LSY4pxUb3l5sHO/ONqNFwGdg6ejw+hqjPLBOsoR10K10K2
         kDWY8FpHiz0rbUo50T44ZlwEu4bHHtuIYsi9X95RVdPixnZbbFagBpnXd8C8rbEYMO8i
         j8jw==
X-Gm-Message-State: AOAM532K36En+dJXHX9lpoRB/PF5D61AcGpM/zeCBRG8ghE0o2p6X4MZ
        vdY5RF69YXk4VMbNguxJwoshRO/bswk=
X-Google-Smtp-Source: ABdhPJwlnJZ6d7IDPK1pENRPn9CV8VUXLyCCuFLGn5Xethn7+5WnqcQ7cSVf66PtrU5i7gb/fRqfbg==
X-Received: by 2002:a17:90a:ac07:: with SMTP id o7mr9955161pjq.194.1599249971113;
        Fri, 04 Sep 2020 13:06:11 -0700 (PDT)
Received: from localhost.localdomain ([161.81.62.213])
        by smtp.gmail.com with ESMTPSA id k5sm21131905pjl.3.2020.09.04.13.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 13:06:10 -0700 (PDT)
From:   Tom Yan <tom.ty89@gmail.com>
To:     linux-scsi@vger.kernel.org, dgilbert@interlog.com
Cc:     stern@rowland.harvard.edu, James.Bottomley@SteelEye.com,
        akinobu.mita@gmail.com, hch@lst.de, jens.axboe@oracle.com,
        Tom Yan <tom.ty89@gmail.com>
Subject: [PATCH 3/4] scsi: sg: use queue_logical_sector_size() in max_sectors_bytes()
Date:   Sat,  5 Sep 2020 04:05:53 +0800
Message-Id: <20200904200554.168979-3-tom.ty89@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904200554.168979-1-tom.ty89@gmail.com>
References: <CAGnHSE=fY2wkzNeZTSHC37Sp-uD4D8YMEb7LesDkPcQWAfiK=w@mail.gmail.com>
 <20200904200554.168979-1-tom.ty89@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Tom Yan <tom.ty89@gmail.com>
---
 drivers/scsi/sg.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 0e3f084141a3..deeab4855172 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -848,10 +848,11 @@ static int srp_done(Sg_fd *sfp, Sg_request *srp)
 static int max_sectors_bytes(struct request_queue *q)
 {
 	unsigned int max_sectors = queue_max_sectors(q);
+	unsigned int logical_block_size = queue_logical_block_size(q);
 
-	max_sectors = min_t(unsigned int, max_sectors, INT_MAX >> 9);
+	max_sectors = min_t(unsigned int, max_sectors, USHRT_MAX);
 
-	return max_sectors << 9;
+	return max_sectors * logical_block_size;
 }
 
 static void
-- 
2.28.0

