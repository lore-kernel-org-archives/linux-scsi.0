Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09410C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 03:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240820AbhKXD0n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 22:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbhKXD0m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 22:26:42 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0FD1C061574;
        Tue, 23 Nov 2021 19:23:33 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id v22so1331018qtx.8;
        Tue, 23 Nov 2021 19:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y2tqMr/WyUo/7BJaty/82tOiloaXhO0tkMuWEmSXY2M=;
        b=n50l9k+mOYXOzvE8Dkn6KdfemeZMCAMytvhFxPh1k3qqGhBYZOQIqH/OY8T/0j1kpU
         9RDWYr/51WByy9MFuA1TzgL3e1yRJuTWmvKBnpt+OLAwWjFfxwqwMGLxrGJjlziQuk4E
         l12YILqoYk2Wcb2njPsqlaX6/VNGc8+nwrJSxq5ZY3VTH3pjphAm+3RGpMjhQj2ES7qX
         8CHJDxMP5cc1Xxu/P00KC99b0Qfo9sX/07da1IIUdAwAIxF6N+rFhSOCIi8H1d1iO0jq
         rqOjtt5CLPqBrN2x0VgvZ9K1oOej4+arT7+I7CnFGFwlToR2R8PQe0BOWzTjI4ZW8OVI
         hnQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y2tqMr/WyUo/7BJaty/82tOiloaXhO0tkMuWEmSXY2M=;
        b=qisk8q3amNQWd1MzmUWTv9rrA8TFC+TQZbjmPzuJu+dgRAKGAhigdeU3rxo68SuivN
         gisu14/qn3PESZjZoJGCH/5urjAtasKWfl3+3ZCdEQFp4WZiI2I+oZDcSRXWmGNRe/Nu
         s6uyzQSHA79zpz14Q0LRzPB3yo5A2b7+hC/o16d5PSb55mAn/7P0fHUxwX3YVegGLP52
         HqHjhE7peZdie14gUX2Y/24JE4p0YnHV86M37VQv1hp5ctkg6J6rC9ROhKjmTokCsRW3
         TZgWPnXnYM8YMQrOtBHIatommCmxMOd3kipJCVsHYK5b0K5WklDhklzuldp7JPIQJ1q8
         2jUw==
X-Gm-Message-State: AOAM532BCop8MG1u1TbazX7BcP0I4oFfZnqTO5c6ashxMNvVS2YBZTSS
        qJu6MFaPOZCKHo5K+b2v8ag=
X-Google-Smtp-Source: ABdhPJyw+7uziXuDSVQi6Sm/Q9kjcCyC1922FS1GoH/05CK1lsJwqRN5/xHydfh0V5l04CEWqmH7Cg==
X-Received: by 2002:ac8:5b8c:: with SMTP id a12mr2926127qta.353.1637724213262;
        Tue, 23 Nov 2021 19:23:33 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id g123sm7143404qkf.108.2021.11.23.19.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 19:23:32 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     oliver@neukum.org
Cc:     aliakc@web.de, lenehan@twibble.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, dc395x@twibble.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] scsi: dc395x: Use bitwise instead of arithmetic operator for flags
Date:   Wed, 24 Nov 2021 03:23:14 +0000
Message-Id: <20211124032314.35452-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Fix the following coccicheck warnings:
./drivers/scsi/dc395x.c: 1129: sum of probable bitmasks, consider |

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 drivers/scsi/dc395x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 9b8796c9e634..854236d550e8 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1126,7 +1126,7 @@ static void reset_dev_param(struct AdapterCtlBlk *acb)
 	list_for_each_entry(dcb, &acb->dcb_list, list) {
 		u8 period_index;
 
-		dcb->sync_mode &= ~(SYNC_NEGO_DONE + WIDE_NEGO_DONE);
+		dcb->sync_mode &= ~(SYNC_NEGO_DONE | WIDE_NEGO_DONE);
 		dcb->sync_period = 0;
 		dcb->sync_offset = 0;
 
-- 
2.25.1

