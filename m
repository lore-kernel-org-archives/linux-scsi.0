Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B8FC7EE2F
	for <linux-scsi@archiver.kernel.org>; Mon, 22 May 2023 11:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjEVLPL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 May 2023 07:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbjEVLOW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2023 07:14:22 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB21D1BEC
        for <linux-scsi@vger.kernel.org>; Mon, 22 May 2023 04:09:23 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f423521b10so38296695e9.0
        for <linux-scsi@vger.kernel.org>; Mon, 22 May 2023 04:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684753762; x=1687345762;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sLT0FiEH6oouW8EPbLKNIG4DOpkfuz+O0fMu7cMLcHk=;
        b=nu3YM0iUXLIuTadpg9XfeL2HO5Cy8+Ply9Xz3glZP7fDt9bfdPnXfKgA5uAbFVKarv
         s1Qr1kNxovzWjRWgiwFuak7bLwf5LRdYMo55YNDYrCUe0Pz1XLCq+0RumEQ6bPZ3BkXK
         u/7Z/b0j5ob0gKnMTyeKBlbkFLdabjDqWo1Hd34CSsuQseCzLjXKdCeqAYWnhMToNaGh
         knWgyPR1I7mVLPqRrnNcyvn+26j2wLb78p1tv0r+8EGYGhgprd+Ac1uMpeJ0RuNN7ft7
         EfOiXCQn3D8RqEsWnwqGJoBeZhVd1WdTcVTIn00orON/rUKvg6BBuIR9Ecl+MFqD1q8I
         XeJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684753762; x=1687345762;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sLT0FiEH6oouW8EPbLKNIG4DOpkfuz+O0fMu7cMLcHk=;
        b=Y8XHDYag016yY3DivXp6SgR/Yoz2UsJCq6Kma+jbjV5FXIYBYaEIxuVB4bblOVOyGr
         yk8QzERQAk2Ee8aJmwhv61mggPywQBczp5X6ZYMN8VTWL+QHE2P1Vab44PZdj2Uj6Oac
         b8xfjHPM3FsO4kAwiQ/mVRKq7D8fHmIzOvOk/vRlBAiY8tHtJ2U3jvtFlUSw3WQVAEkV
         zfJolexy3Ok3rpl8+JKi7n8WT5a12pvFeHAzu/bEWTLQ2PN3AuGG/qtzlc5jgauSyZoY
         qTYnbjUwcNiYbxSkccb/YCt8E1fLnCY38U8ihwjFP/lPlm4cJDkx92iMrUi0NZiR40/S
         wb8Q==
X-Gm-Message-State: AC+VfDzzbv/lmRcLrxFDu/ZtzGy3yHVX8ZztUMiiLSoA1EkSyISXQgjZ
        lMxz9uzlSXomQs01GYKWju2/ng==
X-Google-Smtp-Source: ACHHUZ5XZTB4dlHa/+0NY4wJX7D5N/1kzLzsT7k7gh+ItHCgz6w/oGeocYFtmuMAPvcdrflAo0GEuQ==
X-Received: by 2002:a7b:c014:0:b0:3f4:fd67:6d7c with SMTP id c20-20020a7bc014000000b003f4fd676d7cmr6140295wmb.40.1684753762341;
        Mon, 22 May 2023 04:09:22 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id j3-20020a5d4483000000b003062b57ffd1sm7374058wrq.50.2023.05.22.04.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 04:09:21 -0700 (PDT)
Date:   Mon, 22 May 2023 14:09:17 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Quinn Tran <qutran@marvell.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: fix end of loop test
Message-ID: <cea5a62f-b873-4347-8f8e-c67527ced8d2@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This loop will exit successfully when "found" is false or in the failure
case it times out with "wait_iter" set to -1.  The test for timeouts is
impossible as is.

Fixes: b843adde8d49 ("scsi: qla2xxx: Fix mem access after free")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index bc89d3da8fd0..952fd2b5e6da 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1409,7 +1409,7 @@ __qla2x00_eh_wait_for_pending_commands(struct qla_qpair *qpair, unsigned int t,
 			break;
 	}
 
-	if (!wait_iter && found)
+	if (wait_iter == -1)
 		status = QLA_FUNCTION_FAILED;
 
 	return status;
-- 
2.39.2

