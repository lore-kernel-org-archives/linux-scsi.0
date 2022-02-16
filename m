Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30898C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbiBPVDC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:03:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232077AbiBPVC6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:02:58 -0500
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C112069A9
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:02:45 -0800 (PST)
Received: by mail-pf1-f172.google.com with SMTP id d187so3154010pfa.10
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:02:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k7lGi5V8UE+vYk8leuP3XDOCvMS0Ir4ShlsC6V+WdRQ=;
        b=vXu9UnULNhy/dC4thSV6RfG/K/iTdOIUaTFxQeKYv/lmGj9JOIUGdLlFdodff4gqjk
         wagZEEAddp0jlMRhuJeemL2eYsHYlJBhB5i6sS2JDcraT4IdeJvYmj1rBDDuetY75OV4
         M4ILBu4aGlY6Cr+Pni/kObGgY+jIMQ8em2khkV9xGWowbS8uB/upevmjYCZSb2nSGdKV
         x7CrjYUUSn57SmMiE2Pw9VIlqIiuoGu3jRX2OsiLn+lfFhPCHMBlxxASjI+Q3x3wd/DK
         frWe+/FmvVn+ERdUSz48rIL436s1QFBoSkHXSS/8f1N2zuJl8idjg+AmhOvg5r+3/2wO
         eMVA==
X-Gm-Message-State: AOAM532SzFrSNNaNPP5z0XMmV9tYOJp52W10tNQenPbvFXZCXEvoo/RF
        UPJeaxmhpFRFxEdJ+FJoHMclNA3hnt9QWQ==
X-Google-Smtp-Source: ABdhPJxfH8RDTNg7APZ2jftkCQsAJP7FwubWTRQfbzXvSyv0Hq3ppfEc3pFYT8dQJSUvyoqr0gkWlw==
X-Received: by 2002:a63:6b8a:0:b0:373:1037:1c65 with SMTP id g132-20020a636b8a000000b0037310371c65mr3744584pgc.7.1645045365025;
        Wed, 16 Feb 2022 13:02:45 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:02:44 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 01/50] scsi: ips: Remove an unreachable statement
Date:   Wed, 16 Feb 2022 13:01:44 -0800
Message-Id: <20220216210233.28774-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
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
