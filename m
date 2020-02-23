Return-Path: <SRS0=lsQb=4L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 742B3C35675
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Feb 2020 23:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BB712465D
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Feb 2020 23:19:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fyRR9/wO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbgBWXSX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Feb 2020 18:18:23 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35689 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbgBWXSW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Feb 2020 18:18:22 -0500
Received: by mail-wr1-f67.google.com with SMTP id w12so8248053wrt.2;
        Sun, 23 Feb 2020 15:18:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qy7AvatIqffY4xvh/iJWRifOixdLsIdAN4n8+psibAI=;
        b=fyRR9/wOz6/pueORMQ9XChTVG1DxK0ngllIHnUr5GLw7QNP8uIt7JavJM48/c6DK3f
         PRl7n2OWBd+vW9WVy4xLzApenTBuRzO85PMsnPeuRtMCAJSjRDUsFkb/cCUdCYE5UeUx
         2d4hRdmQxnt+C45haJC44mlpZeNN6Lp+Y7awK5/CRXCyNRbh98fDVEXu+kxbpOIThNlD
         8xJflORRyyzB6ns5dep8GLrAhISeqU2/1+ZmMRMVNH1Qr63v8ULSx3cI9yYfTxKvzCp7
         uGOEMbYR/vEj9MldNJYgB5L3THQLl0VWM9L3QxE3AA80UPI0e9MPfKkc2vq9fcpB+zBk
         aKzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qy7AvatIqffY4xvh/iJWRifOixdLsIdAN4n8+psibAI=;
        b=eTb8riPwP+sxHbYD1SoWBcAKOxIvKzEl67PIx/kOMVxTI4JjEuklLn82J1nfZuR4s+
         aTim5NSc6iKhOdju0o9ujcMorzESUqG8hSi5+ZrUH27SA8OO2LG4C71Z6ChcMt3uiBX9
         oDhg+Q0cyZEo5diNXnMZpcgjRmpxh8PsDmuW7Viz+Cv+Rdu3mQRKkKnE7+p/mgrH81wl
         vsHu8ndeTHuC+qT4FZXwScSw4kOWX3hfQwbVIZc1JlnaPX77uAasDBiA5VRGm0SThYJE
         K1vfgbMNmA/4oDI+dh1t3YFM0sNzcq+bZ2MwjyudUYd99RUiC0+w4T59QYlI3Ei1T1em
         hxfw==
X-Gm-Message-State: APjAAAVACAoMNZyy1AvodAahMktrvnIpYgQRfzx7iDUxS7UpYFv57Ke1
        WfoHcFU4uEmIst9JkGsbcg==
X-Google-Smtp-Source: APXvYqxLrKsNxp44YDZ8paqqib3l4pwruN6fw8TTAaKf2QgDD2HQRNccyOTTHE8v9BiZJ/EZ1I2EQQ==
X-Received: by 2002:adf:f581:: with SMTP id f1mr63156801wro.264.1582499901211;
        Sun, 23 Feb 2020 15:18:21 -0800 (PST)
Received: from ninjahost.lan (host-2-102-13-223.as13285.net. [2.102.13.223])
        by smtp.googlemail.com with ESMTPSA id q6sm8968203wrf.67.2020.02.23.15.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 15:18:20 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     boqun.feng@gmail.com
Cc:     jbi.octave@gmail.com, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Varun Prakash <varun@chelsio.com>,
        Hannes Reinecke <hare@suse.com>,
        linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM)
Subject: [PATCH 21/30] scsi: csiostor: Add missing annotation for csio_scsi_cleanup_io_q()
Date:   Sun, 23 Feb 2020 23:17:02 +0000
Message-Id: <20200223231711.157699-22-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200223231711.157699-1-jbi.octave@gmail.com>
References: <0/30>
 <20200223231711.157699-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sparse reports a warning at csio_scsi_cleanup_io_q()

warning: context imbalance in csio_scsi_cleanup_io_q() - unexpected unlock

The root cause is the missing annotation at csio_scsi_cleanup_io_q()
Add the missing __must_hold(&hw->lock)

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 drivers/scsi/csiostor/csio_scsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 00cf33573136..77cba766ae52 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1157,6 +1157,7 @@ csio_scsi_cmpl_handler(struct csio_hw *hw, void *wr, uint32_t len,
  */
 void
 csio_scsi_cleanup_io_q(struct csio_scsim *scm, struct list_head *q)
+	__must_hold(&hw->lock)
 {
 	struct csio_hw *hw = scm->hw;
 	struct csio_ioreq *ioreq;
-- 
2.24.1

