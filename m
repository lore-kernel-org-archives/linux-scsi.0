Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C539CC53210
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Jan 2023 10:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbjAEKyJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Jan 2023 05:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbjAEKx4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2023 05:53:56 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B83750174;
        Thu,  5 Jan 2023 02:53:55 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id m8-20020a05600c3b0800b003d96f801c48so1025650wms.0;
        Thu, 05 Jan 2023 02:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5nwMq5RxlGq2Rp72O65oHNJVovNCqvBQEsaRzCUxkl4=;
        b=aEtpEUSN8zeVQtThy9khsr+NMiqMbu1k3j3jW5zT0evRPzwWLjgbGKjwxENMQIKrmF
         AWJPJtUhk/fr0msY2Y9Xn3RiuzBiduBkxPwLjyXhZN00bHzpwzZKuOuBuBOe6SDuEdo8
         JEx0QRp1Yo5XLK/y+5P9/RJN9WlAQDnAHpXYTHwHwNHfAt+NmBlYqcbj5XCDedghjwZJ
         CLAklcIQVwMy8uv1GTNNqVnBAkVGvxQio4WoEgrUWVLZ4hT2B4MIawePXkYZj9uCyyi9
         WZEWcJkWp23WACRXS6he8BWSAFNt+Y9exct0PVAvBoczQVcP8n0OituhTbjzPzU/K7lx
         Hf8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5nwMq5RxlGq2Rp72O65oHNJVovNCqvBQEsaRzCUxkl4=;
        b=5pq9d6CSmK59NBr5kf8pfBxoROJMxjWYlefGoODjF5HJu4s9k2w0ei98TnUudZkllx
         i2AgDTmdszijQGxjufaxAeQM7mEy7R9hnbJPnaBX7mk69yojq+byLTL6dCL8c3doUoHH
         zzKAa0USzFEqsIR5ZunyaywcBCSkypRXmNOq2n7HknrmrStpoq0Q3MIr+1bikvtbIBr+
         19Zturlu/EWpD5JdQQCmbJZDhjv1htQ8ZUoEp+tRml/4JJ92LJz6YdIE2NszglDa+nio
         Qw3+pFgs8bXiEY52r7230IDTa+PLNxiSVQPsN2qrx9qK6OdXDfiNT6QtWT4+xsBPnOkL
         /BXg==
X-Gm-Message-State: AFqh2kopbI/9SiyNmE6fwSlm7h0lbS4aJQ0P69TFgaeqCKeH7KshtngC
        IkJRHrUjZnPWzL1Wh64hq74=
X-Google-Smtp-Source: AMrXdXvYf5181nm386ergfcbjb6gWFTPRfHv+VtXO1iLkiqFscFV/rDF/dVwvAxr0YFbbMSWimk3Ow==
X-Received: by 2002:a05:600c:13ca:b0:3d3:4427:dfbf with SMTP id e10-20020a05600c13ca00b003d34427dfbfmr35289301wmg.5.1672916033540;
        Thu, 05 Jan 2023 02:53:53 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id v16-20020a05600c445000b003c6c3fb3cf6sm2197277wmn.18.2023.01.05.02.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 02:53:53 -0800 (PST)
Date:   Thu, 5 Jan 2023 13:53:35 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jie Zhan <zhanjie9@hisilicon.com>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: libsas: fix an error code in sas_ata_add_dev()
Message-ID: <Y7asLxzVwQ56G+ya@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This code accidentally returns success instead of -ENOMEM.

Fixes: 7cc7646b4b24 ("scsi: libsas: Factor out sas_ata_add_dev()")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 drivers/scsi/libsas/sas_ata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 177cdaef3cad..f5e1c24f54ca 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -716,7 +716,7 @@ int sas_ata_add_dev(struct domain_device *parent, struct ex_phy *phy,
 
 	rphy = sas_end_device_alloc(phy->port);
 	if (!rphy)
-		return ret;
+		return -ENOMEM;
 
 	rphy->identify.phy_identifier = phy_id;
 	child->rphy = rphy;
-- 
2.35.1

