Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C810C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B06920674
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:47:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kMQi+LF4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbgGMHrA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 03:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729049AbgGMHqz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 03:46:55 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBCBC08C5DD
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:46:55 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f139so12170847wmf.5
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DmqYn8cL7eqDFwNGfmdwoQHTEQPwopRMh0yPN6WNGOc=;
        b=kMQi+LF463/qxHEfKGPGvCd2c6A2f6xdj3zZKG62HaLhW8tV06HUqvCtmNufbjrIdu
         +r8xls+i2UHhzWACB73k0OoRRj72ou0OQ7r1zeWimj+ntzHg+CFP9fmpyJghgJkXjJw2
         A05uGrWkzxgx82ApMTP8wqs03s9phPr++cD16/GYWchOzyqTxHwiRbqo1Ti/3YL4CJdL
         1oI53ro3+ZySyLW27dLpxBvokNzD2PUv9mcRHuC9gs1CzeL3E0ICDp/IkeEJ97/ZAv46
         hoZrC/IoAlccRJpK6OjveW//uzODgE0RYRvPXuTpnzfhNkdxuY/0noyO/8IWnS5hR8iF
         ZKAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DmqYn8cL7eqDFwNGfmdwoQHTEQPwopRMh0yPN6WNGOc=;
        b=b4HEdLH8cIX6VlWgyfQJ+QReVOJY+Dnm+9NBEv72+DqS04dAkJz7i3YJn1IM6iA0gg
         +S5mXFXCFrhDbFtjcvDXvSkP2lK87OinMDctrZjWd/LpB70tWrYLoj1nD+/FPn2efRGo
         uFOe+TdP1m3uZ+QWU7sFugJqZen+c7x7v652Ny6W4MTA1dcXJj6zZ9uXLqEaoGxHVmbh
         OiqbigmknMwwOA+Tb9V6q1pEI2UyxlFOnEarOa+YiqJ1blGvR3ZKRU78FoGKHnfQnECL
         qBTIJRTrx71CTwzcNFP/lfqNu4BujiEIcX5V6vsv487jDWyI2v5SHXiGoyxCPXnq57mH
         j2hA==
X-Gm-Message-State: AOAM533/qMcyKU5grwlcEUoIKJ879MaaXmGeaUUq4Ss7Tqm5th4aEuLw
        VGMO7qIrDW+amlxsioCC5QCF3JPMm7E=
X-Google-Smtp-Source: ABdhPJxYPfD3jt/wvcLfJGWG+I9epedTnVYg39jHCJvCocIhbmxWOlTXNJ6eiKgn70cyJoojayZiGA==
X-Received: by 2002:a1c:a557:: with SMTP id o84mr17773676wme.42.1594626414066;
        Mon, 13 Jul 2020 00:46:54 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id k11sm25142488wrd.23.2020.07.13.00.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:46:53 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 06/29] scsi: fcoe: fcoe_transport: Correct some kernel-doc issues
Date:   Mon, 13 Jul 2020 08:46:22 +0100
Message-Id: <20200713074645.126138-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713074645.126138-1-lee.jones@linaro.org>
References: <20200713074645.126138-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Mainly due to misdocumentation or bitrotted descriptions.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/fcoe/fcoe_transport.c:396: warning: Function parameter or member 'skb' not described in 'fcoe_check_wait_queue'
 drivers/scsi/fcoe/fcoe_transport.c:447: warning: Function parameter or member 't' not described in 'fcoe_queue_timer'
 drivers/scsi/fcoe/fcoe_transport.c:447: warning: Excess function parameter 'lport' description in 'fcoe_queue_timer'
 drivers/scsi/fcoe/fcoe_transport.c:682: warning: Function parameter or member 'netdev' not described in 'fcoe_netdev_map_lookup'

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/fcoe/fcoe_transport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index a20ddc301c89e..6e187d0e71fd2 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -382,6 +382,7 @@ EXPORT_SYMBOL_GPL(fcoe_clean_pending_queue);
 /**
  * fcoe_check_wait_queue() - Attempt to clear the transmit backlog
  * @lport: The local port whose backlog is to be cleared
+ * @skb: The received FIP packet
  *
  * This empties the wait_queue, dequeues the head of the wait_queue queue
  * and calls fcoe_start_io() for each packet. If all skb have been
@@ -439,7 +440,7 @@ EXPORT_SYMBOL_GPL(fcoe_check_wait_queue);
 
 /**
  * fcoe_queue_timer() - The fcoe queue timer
- * @lport: The local port
+ * @t: Timer context use to obtain the FCoE port
  *
  * Calls fcoe_check_wait_queue on timeout
  */
@@ -672,6 +673,7 @@ static void fcoe_del_netdev_mapping(struct net_device *netdev)
 /**
  * fcoe_netdev_map_lookup - find the fcoe transport that matches the netdev on which
  * it was created
+ * @netdev: The net device that the FCoE interface is on
  *
  * Returns : ptr to the fcoe transport that supports this netdev or NULL
  * if not found.
-- 
2.25.1

