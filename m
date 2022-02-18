Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5E83C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238063AbiBRTvs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:51:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238062AbiBRTvn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:51:43 -0500
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518CF1022
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:51:25 -0800 (PST)
Received: by mail-pl1-f169.google.com with SMTP id l8so7973949pls.7
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:51:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k7lGi5V8UE+vYk8leuP3XDOCvMS0Ir4ShlsC6V+WdRQ=;
        b=PDfscidz1Cu2J91NSX2d++hTd8jV0e43AGoPAdlB29X25g9qOky/H1DTVJn1W2hjLB
         0ioI3DJj89u3ewfPnXIZ7KM0tkfS9vKXP6oMFTmsHPMlhq6lVUvmSD2eVxJ/CganQGfj
         l/TQnwzVEi9lARwL+3PalHcWRvtXcGECby+g3E35J2NVH3wflIo4HUHUCYnShX+5OZj0
         qWSN9mVI5GP1rUzNa9Iw130Fg5CJHgdKLKgdg79wXCROHTXQy67iv9xnEK6Nca6B/2z5
         5+5cuV6QHIGp3C2vf2oyzxVWebCox1QKcvXCHHvRWJiALbFyU5tm/Ge6Jju+vrCB3IJ8
         RI2Q==
X-Gm-Message-State: AOAM531G96iGCpjr5upzAu7x9jIAxgf9DtoX6jCj5FhwJKs1EF9JLh9j
        DkuGOWFd0cz/B6K5juX9ejc=
X-Google-Smtp-Source: ABdhPJxlgj+wSkPhetO//vDSnEiXT+lgHTHqFnypHuiScuChq2f+6ldSXSR+gdPFBkhvQqEBzD2p9g==
X-Received: by 2002:a17:902:6a87:b0:14d:c432:fd89 with SMTP id n7-20020a1709026a8700b0014dc432fd89mr8856206plk.10.1645213884758;
        Fri, 18 Feb 2022 11:51:24 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:51:23 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 01/49] scsi: ips: Remove an unreachable statement
Date:   Fri, 18 Feb 2022 11:50:29 -0800
Message-Id: <20220218195117.25689-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Whether or not CONFIG_BUG is enabled, BUG() never returns. Hence, code past
a BUG() statement is unreachable. Remove one such unreachable statement.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ips.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 498bf04499ce..0db35e97ce8f 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -655,7 +655,6 @@ ips_release(struct Scsi_Host *sh)
 		printk(KERN_WARNING
 		       "(%s) release, invalid Scsi_Host pointer.\n", ips_name);
 		BUG();
-		return (FALSE);
 	}
 
 	ha = IPS_HA(sh);
