Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D21AC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 02:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB9822072E
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 02:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgFJCm0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 22:42:26 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41844 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgFJCmY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 22:42:24 -0400
Received: by mail-pf1-f195.google.com with SMTP id 10so436795pfx.8
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jun 2020 19:42:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xg3sQ+EGXdrhqWAkS/FF3xA85+wC4N8WAZpGgWJ1ge8=;
        b=LYM/6R18lxcI1h8UAUnQyS/Rio9h7yhweUKDG9Atsg0/tkZXJogX9yM7fagH1YL9P/
         4h5vNSKx0Dq/A1mg704uNQ3tqB+kiU8fBtyDrYekQUPqGWZ7V6K0RrWN8xG3mfw19YLv
         E3ygLQU2e7C1g/XJb9678vzhIbIZtCxsEeQ572jsRMQe/OlPdixDRKs/tllVXd5yDNqE
         UxHWSqx+USvAxqOYEOkikKQHql7bDwQF2q9XPU2FcGprIKBDFCwg2vo5XGPEHGEVix8i
         9wTY/hiuYEZfLpOUAKCYLTt2iREAtUBGxH+csVCLOhvhVr37wtiAdEIbXDGZV61420Om
         uFRQ==
X-Gm-Message-State: AOAM5317AeOETMs8+L5F0DhWBDUFmiKzVxKNvyaCQ11meUnp1ddvVsT8
        0oA+2RaoKwCSr5Cm/4Gdbl0=
X-Google-Smtp-Source: ABdhPJzZ9gfNhoIhZIPZnuvDBsaK7BAmu5VKrJEhlHNfiG5y8dE/lGyM8vRXalvAM11NE5QEch11MQ==
X-Received: by 2002:a62:7706:: with SMTP id s6mr728732pfc.285.1591756941994;
        Tue, 09 Jun 2020 19:42:21 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id j130sm11282091pfd.94.2020.06.09.19.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 19:42:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2] qla2xxx: Fix the ARM build
Date:   Tue,  9 Jun 2020 19:42:15 -0700
Message-Id: <20200610024215.27997-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the build errors reported by the kernel test robot on June
7th. Does this perhaps mean that so far nobody has tried to use the qla2xxx
driver on an ARM system? For the kernel test robot output, see also
https://lore.kernel.org/lkml/202006070558.Cy93XggE%25lkp@intel.com/.

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_def.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 42dbf90d4651..de9c1604c575 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -46,7 +46,7 @@ typedef struct {
 	uint8_t al_pa;
 	uint8_t area;
 	uint8_t domain;
-} le_id_t;
+} __packed le_id_t;
 
 #include "qla_bsg.h"
 #include "qla_dsd.h"
