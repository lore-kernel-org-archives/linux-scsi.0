Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD7BC64ED8
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Feb 2023 10:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjB0KHi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Feb 2023 05:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjB0KHg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2023 05:07:36 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C5B1E2AD;
        Mon, 27 Feb 2023 02:07:32 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id v16so2765326wrn.0;
        Mon, 27 Feb 2023 02:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aryQAhvsSY+Hbo1a8NQr5WK5lRwd5wGrYicSNyjnIAs=;
        b=iKyIgI0NKzm5EQCAj1+9yEE3snoyPKq98PTKr1c9vbfXL3+vXDcuxtUjeFfGLoKa+b
         rzgATe26luIji9Ats+QU55vG5UJnykksvJz7mRzjwWMkuxkzq6RXn5U2txWG3yp48Xxc
         FpmU91VvXuZTcPTf0ec7XNpmuzy3pFr6Q7XHLPIpkNOvWsSaY1Bb8cdtp+VSGk+Dkyg1
         l855ifRTCp93+TNtcOrZd7NYhJ29c9KXEgYFywMHtdNBbjBArnnS/H6lr3v2kKuiplF3
         L2hP3cmjn7LuMcaQQaUi6BFDURmUFgiK9EVXoZr/F3j5hDQiE6wRUybbMhBqZQ/m+nUQ
         ukjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aryQAhvsSY+Hbo1a8NQr5WK5lRwd5wGrYicSNyjnIAs=;
        b=NuNB/1iRsytay4Nsu1T4Qy/ZISfDPDPNxwnREy4v5kqOVXLrB7dhu3uyRhhyFVqX5D
         VVGtXpUAe2w9HqhkKX0gZ79MMaLz0wYGJj7xchg3w8ht3m6Fp1Y34J0AwEkyF2utwRCu
         8UpiA4yTeqO8W8oMYCOGn4MkX/sZHc2t8mOqJQGzkWlb29WmFuSfLkmGfAfXNUFqRQIW
         CfTI1w7ZAqv/0QMzcnxT7h4jUuGdrzveM7qUH2K8OkxLtuynZLrIh/MD2Z+Xn6qAnMiD
         VC6ri7wAnJIDC5cvR4LrT4QcvX3YQFb2HC6SPXK+VNHo1KwJNQV9MdMl0uZGhhIlIXvF
         F7rw==
X-Gm-Message-State: AO0yUKUDQtoyB+8NoLajSI8e4Zn3qrQspvl3en8LoeNc2FCEaBI5RiYT
        NQTJkdwDdYa4VHT4kikaUA4=
X-Google-Smtp-Source: AK7set9kXruz4qDyKvNS2xYLlHU7YARTec/KWK0vo9XtOAsb1NEGpb1pEuS11t9zlpM9BlB9n/VMUw==
X-Received: by 2002:adf:ec03:0:b0:2c9:850c:6b15 with SMTP id x3-20020adfec03000000b002c9850c6b15mr5454138wrn.41.1677492451049;
        Mon, 27 Feb 2023 02:07:31 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id a4-20020a5d5704000000b002c559843748sm6681955wrv.10.2023.02.27.02.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 02:07:30 -0800 (PST)
Date:   Mon, 27 Feb 2023 13:07:26 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Yaniv Gardi <ygardi@codeaurora.org>
Cc:     Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Gilad Broner <gbroner@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: ufs: ufs-qcom: remove impossible check
Message-ID: <Y/yA3niWUcGYgBU8@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The "dev_req_params" pointer points to inside the middle of a struct
so it can't be NULL.  Removing this impossible condition is nice because
now we don't need to consider the correct error code for that situation.

Fixes: f06fcc7155dc ("scsi: ufs-qcom: add QUniPro hardware support and power optimizations")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 34fc453f3eb1..797230ad3939 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1177,7 +1177,7 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba,
 			err = ufs_qcom_clk_scale_down_post_change(hba);
 
 
-		if (err || !dev_req_params) {
+		if (err) {
 			ufshcd_uic_hibern8_exit(hba);
 			return err;
 		}
-- 
2.39.1

