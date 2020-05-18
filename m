Return-Path: <SRS0=k4K9=7A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38024C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 21:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 117242081A
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 21:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgERVRb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 May 2020 17:17:31 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35860 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbgERVRa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2020 17:17:30 -0400
Received: by mail-pf1-f195.google.com with SMTP id z1so5551603pfn.3
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2020 14:17:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5PAr07KyosFaRWdjR4RcflzvciFqf1eSyyhk49sXs70=;
        b=tDz8B9og/7Y2PzVKLFLpsA19Sj3CTnw+Dmgz9//Fk2OH5eTt0Eu7hApltJZvk3RG4t
         hi+Iuxu/LUM/B7cm9/HopdB7NskF6T5d+fdSmS1h5qZB3c6woI8ntJaG/ToQFsxZXhFm
         i9VRatTLqG3NTVOvYDZAwOFh8MmfY19ezwvCSSSX+4I281T70SsGjB0jJEmL17mP+zU7
         EM6tn++UPrDGwLwLbChKERn6gJy57HbGh8OSB+zg2lovKCdsOJGivMUENzUQBXrAAEPV
         dHd0rHqhAEJbjxnYoiaLpeidyYEqKIdy7C4HDgGRRQUbTujBe2Rj2PTRKWLduRFchFTw
         998g==
X-Gm-Message-State: AOAM530L43zXVXvDMgzc5l9V6LzdedsPivfu9TBeXh0JYX8YX/L53DX4
        0OEwtGt61VpvGXjuZORWP3Q=
X-Google-Smtp-Source: ABdhPJxEzKM79umef2PZhVSO9xosr+QJ5cGlO7owwekvOp8hwvJLTCXEeYtvXfu6KGPmCZ2PyVN/jg==
X-Received: by 2002:a62:6404:: with SMTP id y4mr17833542pfb.64.1589836648737;
        Mon, 18 May 2020 14:17:28 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:dc5d:b628:d57b:164])
        by smtp.gmail.com with ESMTPSA id i184sm8813123pgc.36.2020.05.18.14.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 14:17:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v7 06/15] qla2xxx: Make a gap in struct qla2xxx_offld_chain explicit
Date:   Mon, 18 May 2020 14:17:03 -0700
Message-Id: <20200518211712.11395-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518211712.11395-1-bvanassche@acm.org>
References: <20200518211712.11395-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch makes struct qla2xxx_offld_chain compatible with ARCH=i386.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Arun Easi <aeasi@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_dbg.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 433e95502808..b106b6808d34 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -238,6 +238,7 @@ struct qla2xxx_offld_chain {
 	uint32_t chain_size;
 
 	uint32_t size;
+	uint32_t reserved;
 	u64	 addr;
 };
 
