Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 351DAC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238184AbiBRTvv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:51:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238109AbiBRTvp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:51:45 -0500
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F97291F85
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:51:27 -0800 (PST)
Received: by mail-pj1-f49.google.com with SMTP id q11-20020a17090a304b00b001b94d25eaecso9484455pjl.4
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:51:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f/tyf6xX9BmyWKtKTQi812+2T5RV6GzN1mDcL3nDAAM=;
        b=zomoT5yL/qoYVrIiZcXZRThwzJwwZmUzmESqwSOPWrHUZWgV6Wz8jHmBgpLNo4ldm7
         zVh3smry0W3p1paOOAxE1myiNzHiJ49piCTM7AwcF2KRZ/YDXIAp9ZR+KjbCgz3t9b5A
         nnwg7GkqnIKAhhycJp7Q1Hd0Cl2a+oejNuqV37z0jen9JjIr+Z0ZF6KTd5yWrcmNmmlY
         rvQJaWpjAyZmBtXUBheHXm2LSb6jH0sMg0mnMEOw9t8UHJdBflpqkSNlyXELpQ9Ags4v
         +WJzKKTe7nNm6d9XkoIb7wwi7k+/N7TBPn6lZXrONZW0wj4Z2qcFYhgQu99uwdEO0iux
         qn+A==
X-Gm-Message-State: AOAM530NgwQu3glx7o+GusjJN3+mY6XfEZWWmxzr1WG0J0AUFqxwVtij
        pfyijjO0mP90G+BwY1sa52A=
X-Google-Smtp-Source: ABdhPJw61hhNPPoSItfzzZwg2o0tZ5jClnMWBcdD64sISxsH7YVxq2Qun2D2lfl3ScjcMx4MOBfCQw==
X-Received: by 2002:a17:90a:5b06:b0:1b8:b705:470b with SMTP id o6-20020a17090a5b0600b001b8b705470bmr9710310pji.168.1645213886611;
        Fri, 18 Feb 2022 11:51:26 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:51:25 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 02/49] scsi: ips: Change the return type of ips_release() into 'void'
Date:   Fri, 18 Feb 2022 11:50:30 -0800
Message-Id: <20220218195117.25689-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ips_release() has one caller and that caller ignores the value returned by
ips_release(). Hence change the return type of that function into 'void'.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ips.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 0db35e97ce8f..59664e92ec8a 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -638,8 +638,7 @@ ips_setup_funclist(ips_ha_t * ha)
 /*   Remove a driver                                                        */
 /*                                                                          */
 /****************************************************************************/
-static int
-ips_release(struct Scsi_Host *sh)
+static void ips_release(struct Scsi_Host *sh)
 {
 	ips_scb_t *scb;
 	ips_ha_t *ha;
@@ -660,7 +659,7 @@ ips_release(struct Scsi_Host *sh)
 	ha = IPS_HA(sh);
 
 	if (!ha)
-		return (FALSE);
+		return;
 
 	/* flush the cache on the controller */
 	scb = &ha->scbs[ha->max_cmds - 1];
@@ -698,8 +697,6 @@ ips_release(struct Scsi_Host *sh)
 	scsi_host_put(sh);
 
 	ips_released_controllers++;
-
-	return (FALSE);
 }
 
 /****************************************************************************/
