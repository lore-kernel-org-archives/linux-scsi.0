Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83039CA9EC0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:59:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58010214E0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:59:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yk20A5ke"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388505AbfJ1U7B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 16:59:01 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43585 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728022AbfJ1U7B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 16:59:01 -0400
Received: by mail-pg1-f195.google.com with SMTP id l24so7761747pgh.10;
        Mon, 28 Oct 2019 13:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=fnnx0BsXF5mY3wVLlFvOOcZalsRDnZJxgNUMzEL+TXc=;
        b=Yk20A5keXvFNXwedn9yOfCW5dvi15M5/ay1DI5zxMIrb962NhbOz6qURd6Wnu+VbqY
         FkH7H5PGlTlimmRX/alDPf75RDf8YG71e5QSFUv/9vF4mVT2cXP3zmDI/00VaWbPBvGt
         zFqL+xlI1h0IJTdwk+mOipFmHiv7op94UzRu1621/qiKn+ea2LlQVOhwk93iPBA2H9xF
         kY4LKBvw96rRAfFDHcAtOByfKMuSSZFJ3xbwTgJ6T3u5dS6w3LwMonfaAZhPsgjOhpwW
         soA5z22UhJirzCYLlE3PcQplvNaj65pArXR8NRkKMNAyCU7FMl+vZyiW4e/F93qNC/rP
         qw9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=fnnx0BsXF5mY3wVLlFvOOcZalsRDnZJxgNUMzEL+TXc=;
        b=IYrylKMgHnZBZaiTCw2SWq5rFgG8Lvj+BSh/eVkq5OmJ0cQtjwfv1n+uoN9km/3O7B
         GvKn373ChfCMQKiQS9RTf7DOxQC331p9GoPWUAPxxqEVRxSyyJOglbRltszxO8yYqxJ+
         fBntvJPlbm5A5MghieRNUwwvvFUlQZvmKvw4taPwxtm8wZQIVOHJRkWKceaF0hzcGxTI
         2F7h8eDp/Ut213tX26hbj3pj5wQkbJoNkUc+BMfmS7STgCr1mITs+zBNsJtxB7aWYcoX
         a3Crnu9M4MuOhMBJmorLQw/wRQNDW/KpuW8xB34IH2J0EiLyh9C52b33DMBIGjbOdbFY
         dx8A==
X-Gm-Message-State: APjAAAUYfrDmAlUcjVpkj6vhYQGPd4JRk1+os6ISDPsorgGXDS977pTG
        3IZinikWXH9bG2GM4tZ+xQ4=
X-Google-Smtp-Source: APXvYqzOfsOzxOd5zhs7OfjrYKSGqNPmtvNSgnOaUezBHTakTHhWRXRzfTpDVE4aYOnkBHu50sHUyA==
X-Received: by 2002:a62:e508:: with SMTP id n8mr23443365pff.111.1572296340334;
        Mon, 28 Oct 2019 13:59:00 -0700 (PDT)
Received: from saurav ([27.62.167.137])
        by smtp.gmail.com with ESMTPSA id c8sm383708pjo.1.2019.10.28.13.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 13:58:59 -0700 (PDT)
Date:   Tue, 29 Oct 2019 02:28:53 +0530
From:   Saurav Girepunje <saurav.girepunje@gmail.com>
To:     Kai.Makisara@kolumbus.fi, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com
Subject: [PATCH] scsi: st.c: Remove unneeded variable.
Message-ID: <20191028205853.GA29719@saurav>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

variable "result" is not modified in function st_release().
So remove it.

Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
---
 drivers/scsi/st.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e3266a64a477..bddabecfbe5c 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1455,7 +1455,6 @@ static int st_flush(struct file *filp, fl_owner_t id)
    accessing this tape. */
 static int st_release(struct inode *inode, struct file *filp)
 {
-	int result = 0;
 	struct scsi_tape *STp = filp->private_data;
 
 	if (STp->door_locked == ST_LOCKED_AUTO)
@@ -1468,7 +1467,7 @@ static int st_release(struct inode *inode, struct file *filp)
 	scsi_autopm_put_device(STp->device);
 	scsi_tape_put(STp);
 
-	return result;
+	return 0;
 }
 
 /* The checks common to both reading and writing */
-- 
2.20.1

