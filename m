Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18BDAC43460
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8434610F7
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236575AbhDOWJN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 18:09:13 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:45575 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235285AbhDOWJJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 18:09:09 -0400
Received: by mail-pj1-f42.google.com with SMTP id nm3-20020a17090b19c3b029014e1bbf6c60so9300526pjb.4
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 15:08:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dI5y2pj+Al0+2aC0ZPqBvqEqkhXKrklWG5otUSr/XY4=;
        b=USdqvIxBxcu7+JYD6OTrxcLozozCo24f7nMQkcefxI8fOu6/nPem+eckeu5aVP625U
         aYwj+MZrNlHq0KmsPExrcl0kV5HUygFhVKKBjzChk+PKYYA7VJQWno2/MrWPGV1Cj7a3
         RiFjMsjuHzXLronpTkcrAndusbhtm+GxSYGtWPhjjpsBBLY4F4He9JD82MgzEAAScdyL
         XrRQCFEiAa+/IpuNUEyYSXBtn/BPdc3QRZ67NCvTfa80sOgIL1HO+aYj0S8AZKPiCWNa
         o97mD1tlxsw+fNLEo37JDpkIC0m0UsKAeWiAwpk2hmsjSo+4p0tdkn28YDNuKtArhp0m
         Kh7g==
X-Gm-Message-State: AOAM530szrhiEXawVgJhwG496Uoy/Jk8Fu87rbQ2KP/gpS5pMyIjwEve
        AbvpWlE+4IIoJoDKhWYXE5I=
X-Google-Smtp-Source: ABdhPJyqV+GGpofNMMRBni616zipYMAiG+u1d+QlCcDGivbdIpHfhfvg4+3pBQ59xHuWrHebbORZrQ==
X-Received: by 2002:a17:90a:6b84:: with SMTP id w4mr6134010pjj.134.1618524525183;
        Thu, 15 Apr 2021 15:08:45 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:f031:1d3a:7e95:2876])
        by smtp.gmail.com with ESMTPSA id w4sm3311155pjk.55.2021.04.15.15.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 15:08:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 08/20] fcoe: Suppress a compiler warning
Date:   Thu, 15 Apr 2021 15:08:14 -0700
Message-Id: <20210415220826.29438-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415220826.29438-1-bvanassche@acm.org>
References: <20210415220826.29438-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Suppress the following compiler warning:

warning: cast to smaller integer type
      'enum fip_mode' from 'void *' [-Wvoid-pointer-to-enum-cast]
        enum fip_mode fip_mode = (enum fip_mode)kp->arg;
                                 ^~~~~~~~~~~~~~~~~~~~~~

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fcoe/fcoe_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index b927b3d84523..4d0e19e7c84b 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -863,7 +863,7 @@ static int fcoe_transport_create(const char *buffer,
 	int rc = -ENODEV;
 	struct net_device *netdev = NULL;
 	struct fcoe_transport *ft = NULL;
-	enum fip_mode fip_mode = (enum fip_mode)kp->arg;
+	enum fip_mode fip_mode = (enum fip_mode)(uintptr_t)kp->arg;
 
 	mutex_lock(&ft_mutex);
 
