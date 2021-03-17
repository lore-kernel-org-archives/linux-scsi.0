Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECBC7C43332
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB39564F37
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhCQJND (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhCQJMr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:12:47 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AF7C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:46 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id v11so1001217wro.7
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oLJQSgQWxXN2wb6bBodFmEtoRfcnDqNqbqxISmqUROc=;
        b=aCK53FD1MvQhxDy9E5GlZ3fBCIB/5MJUl00lIdAFNFGX5slTA0hfmWWpQHXjPl5PYO
         Y3BeKR3dVg52uUnnUIY0wMhNntV0xmlQCOGFhxVPNUoZXDY22BML7bRnmGveD2UyEckb
         cnSZbwS+zC0aIilCAa8xL5mPJptbcts9RIjOBV+SE2PQRjbtCEx07IOjgCzWR9fnQu0Q
         dIgn17RFwXMMYfuyYelYCpSwBGxsPZuqjZyusCVkVw2Y+7eeik0G0LQr/d5uFrQN6n1s
         636247jJTOF80YvNmqvdE7itXQNisLSmsT7MNCmTIQ/D3wQUQ92YKBjPgUhmHXXGq6RP
         fO0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oLJQSgQWxXN2wb6bBodFmEtoRfcnDqNqbqxISmqUROc=;
        b=ZWnEekM7LGv0QD9R3n7pckAkV+FS5YjYjeOMg4e5R9xb2riWqyQ3RAsoFjPKMJup5K
         +hAF5g26em6m5csbMZSvBO2AGunXmEYIpmyA7I9oedkqKaKcgYV2Lv/m8i1BDRiFicwq
         uzSvVc8Pu9QLMS5LhI6cZBYqiX8wz+m+tpfLDsFBptVkj8ax8ZyXpOYQmCHpN0OFsakb
         MSYOH4lAwC9fG1Dwn0YR9sqx+enc1YtQCM5MKsxF+OXjkAQarQLJJuVcQtj6+mRoPswL
         bqkJxNHJEhCczAvVcc/zHuLsWhagPxKUib1zMJH5oPiO+8202WufUIadL97cDvuf+/1s
         cxSA==
X-Gm-Message-State: AOAM533LD6FwR3G4Z1oxknSoI2nzYNEhJMeUnal/6Gux5ku9kgpGoz3l
        pzRLr1XJ0uCSOpptwWHWskyjpg==
X-Google-Smtp-Source: ABdhPJzeb8pknJeI+uRC3ImYBONXlIC7hhj6T2DxZwl/mgDXu0RbgwQZHDABPcaneOsnJ2GEl+DljA==
X-Received: by 2002:adf:bbc2:: with SMTP id z2mr3207702wrg.180.1615972365666;
        Wed, 17 Mar 2021 02:12:45 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:12:45 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Drew Eckhardt <drew@colorado.edu>,
        Eric Youngdale <eric@andante.org>,
        Jirka Hanika <geo@ff.cuni.cz>,
        Richard Gooch <rgooch@atnf.csiro.au>,
        Torben Mathiasen <tmm@image.dk>,
        Alex Davis <letmein@erols.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Badari Pulavarty <pbadari@us.ibm.com>, willy@debian.org,
        Kurt Garloff <garloff@suse.de>, linux-scsi@vger.kernel.org
Subject: [PATCH 06/36] scsi: sd: Fix function name in header
Date:   Wed, 17 Mar 2021 09:12:00 +0000
Message-Id: <20210317091230.2912389-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/sd.c:1537: warning: expecting prototype for sd_ioctl(). Prototype was for sd_ioctl_common() instead

Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Drew Eckhardt <drew@colorado.edu>
Cc: Eric Youngdale <eric@andante.org>
Cc: Jirka Hanika <geo@ff.cuni.cz>
Cc: Richard Gooch <rgooch@atnf.csiro.au>
Cc: Torben Mathiasen <tmm@image.dk>
Cc: Alex Davis <letmein@erols.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: willy@debian.org
Cc: Kurt Garloff <garloff@suse.de>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ed0b1bb99f083..91c34ee972c79 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1519,7 +1519,7 @@ static int sd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 }
 
 /**
- *	sd_ioctl - process an ioctl
+ *	sd_ioctl_common - process an ioctl
  *	@bdev: target block device
  *	@mode: FMODE_* mask
  *	@cmd: ioctl command number
-- 
2.27.0

