Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322C8C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Mar 2021 23:25:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F24D261937
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Mar 2021 23:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhCTXYy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Mar 2021 19:24:54 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:34542 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbhCTXYS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Mar 2021 19:24:18 -0400
Received: by mail-pj1-f53.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so9741227pjb.1
        for <linux-scsi@vger.kernel.org>; Sat, 20 Mar 2021 16:24:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VE1qmUCYp8cPGXujMeoDdARb9KpXb9/Fho8K3nlKaug=;
        b=PPgNNHLavJV1JM2U7zzN1wcgWlbdst4atwj9vj8w20iKH81VM7pTJ12I8h4mKKhr3q
         pltjn4boFLgQ+bsieqHswraVe6DDnBdTpEe99q50IhLVj25gtcyKVEaoq8XsLGSH+/HW
         y11ahRtdGmbVL1cIVkfHns6M0mL8h8J7ngiZPpFCqjHYNv///VOFXAz4SD3wjO9NlRmT
         gCY94JBKsqLbAYCDM1O/zwqz2rR3/mAK9MQ1/mXduuSAR3aJpfca2b3uDBxF+Aa9NENR
         HJCMYAZhnUIjDS3NBhxe+sZtRmWpn8QvVF1pUp+6vtfOLT0gCy+z5od6qg3XYE+c8UDk
         WtgQ==
X-Gm-Message-State: AOAM531n5GlXBAhbRmxsTMlIJ+IRej1+N1Eww4Oboac8EOYwpiCBd14Q
        VI6CobcM8sxRM4gsXsVXMEM=
X-Google-Smtp-Source: ABdhPJxcnV1g7tjlsqZPn0pssqD4b7wc2NWnkQIoEjTNt4ZFHPUX6gNXExDPdiW5NU38LPUcy2wZcQ==
X-Received: by 2002:a17:90a:f40c:: with SMTP id ch12mr5540480pjb.176.1616282657676;
        Sat, 20 Mar 2021 16:24:17 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:9252:a76b:2952:3189])
        by smtp.gmail.com with ESMTPSA id u7sm8869159pfh.150.2021.03.20.16.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 16:24:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>, Lee Duncan <lduncan@suse.com>
Subject: [PATCH v3 7/7] qla2xxx: Check kzalloc() return value
Date:   Sat, 20 Mar 2021 16:23:59 -0700
Message-Id: <20210320232359.941-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210320232359.941-1-bvanassche@acm.org>
References: <20210320232359.941-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of crashing if kzalloc() fails, make qla2x00_get_host_stats()
return -ENOMEM.

Fixes: dbf1f53cfd23 ("scsi: qla2xxx: Implementation to get and manage host, target stats and initiator port")
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Saurav Kashyap <skashyap@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Lee Duncan <lduncan@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index bee8cf9f8123..bc84b2f389f8 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2583,6 +2583,10 @@ qla2x00_get_host_stats(struct bsg_job *bsg_job)
 	}
 
 	data = kzalloc(response_len, GFP_KERNEL);
+	if (!data) {
+		kfree(req_data);
+		return -ENOMEM;
+	}
 
 	ret = qla2xxx_get_ini_stats(fc_bsg_to_shost(bsg_job), req_data->stat_type,
 				    data, response_len);
