Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF88C43461
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A7202077D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:01:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F40StJ0J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729636AbgGMIBk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729175AbgGMIAR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 04:00:17 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83762C061755
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:17 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id r12so14701421wrj.13
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kZ+k2VRrvfDu4ASYD2+0hveDy1rv8dVhxsnPb7NP+X0=;
        b=F40StJ0JDEughnyCZdC4zD4CADMmCEX+GdBEWIJkmZ4vaNaxG08FHoT+/Ef3TpqKA3
         7Et7t+js1PLlhqegkg0tIN0YJqr48NIpDRJnspa8qwGRfPXtK8InR88gY+tBDjmthXWu
         LdsNkMqwMVf+7qtfHRX0VC4ySJSllCd8lDC+WBL/rn8wYOuCXOY9g9zAsdjX7QWTrHab
         5JGTxWMne7/Mw0z5Qm+5dy2eGxyP6uTW90jT+krRISw7A0f4KcCD/Iz8yX2++EC+XHLK
         jgSWFQv0ZnAfzNgc+sLHNl/IxNWRhKtqbHR30Seku+m8gD3eN1XR0y4U5brZNTEVvL94
         pspw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kZ+k2VRrvfDu4ASYD2+0hveDy1rv8dVhxsnPb7NP+X0=;
        b=KrZAN8fWi4EJmwCzzWr1SmMlqQCcjrXHynJpocr1Xsf91YDI03w7KIxRrks/LB1azF
         wLAHvmq0hDccbCKS4duiK4vZRUcxDqs44j+GdcXNiDFROJLxvfaBgKlxvhkuGknFNmc+
         WDonaOwDi0K/g6BLVAGnEWms/w0rUzd/FcBQHvVJsB2SUUe38Mjawlhve8jNHc3wROvW
         W8ezmZ3gUKwnwXDaswbf/yAglnDwTe4z8OcJY8ATO9kHI28ay6FVDGr+OrQLMEzfqxcu
         1Nt5JO5oIbV4mnTsk1Whwkq3fKWYSUlZ5GMSmEP/UipcqmWe5M1btEZ+cuqQI8H7d7vC
         jRIw==
X-Gm-Message-State: AOAM533T//6Vi02PL57/Qymqh3CM/koe6k7Y9PeH4NN9mTBMsjqFfypQ
        jEwLA4RiDbAuGp/7Ymo/AKgdWw==
X-Google-Smtp-Source: ABdhPJwEk2RTfsYPZCrwW/6JZss9ehBe6X5OJOmh5OKgO1/Gr7DZGwQlNRj0NwRoqP3KYf6vv5xpoQ==
X-Received: by 2002:a5d:6a04:: with SMTP id m4mr76716494wru.418.1594627216305;
        Mon, 13 Jul 2020 01:00:16 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id 33sm24383549wri.16.2020.07.13.01.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 01:00:15 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [PATCH v2 08/24] scsi: aic94xx: aic94xx_scb: Fix a couple of formatting and bitrot issues
Date:   Mon, 13 Jul 2020 08:59:45 +0100
Message-Id: <20200713080001.128044-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713080001.128044-1-lee.jones@linaro.org>
References: <20200713080001.128044-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Kerneldoc format should be '@.*: ', else the checker gets confused.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aic94xx/aic94xx_scb.c:137: warning: Function parameter or member 'phy' not described in 'asd_get_attached_sas_addr'
 drivers/scsi/aic94xx/aic94xx_scb.c:137: warning: Function parameter or member 'sas_addr' not described in 'asd_get_attached_sas_addr'
 drivers/scsi/aic94xx/aic94xx_scb.c:860: warning: Function parameter or member 't' not described in 'asd_ascb_timedout'
 drivers/scsi/aic94xx/aic94xx_scb.c:860: warning: Excess function parameter 'data' description in 'asd_ascb_timedout'

Cc: Luben Tuikov <luben_tuikov@adaptec.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aic94xx/aic94xx_scb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index 4a80ec08f0c96..c264b4b56970b 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -123,8 +123,8 @@ static unsigned ord_phy(struct asd_ha_struct *asd_ha, struct asd_phy *phy)
 
 /**
  * asd_get_attached_sas_addr -- extract/generate attached SAS address
- * phy: pointer to asd_phy
- * sas_addr: pointer to buffer where the SAS address is to be written
+ * @phy: pointer to asd_phy
+ * @sas_addr: pointer to buffer where the SAS address is to be written
  *
  * This function extracts the SAS address from an IDENTIFY frame
  * received.  If OOB is SATA, then a SAS address is generated from the
@@ -847,7 +847,7 @@ void asd_build_initiate_link_adm_task(struct asd_ascb *ascb, int phy_id,
 
 /**
  * asd_ascb_timedout -- called when a pending SCB's timer has expired
- * @data: unsigned long, a pointer to the ascb in question
+ * @t: Timer context used to fetch the SCB
  *
  * This is the default timeout function which does the most necessary.
  * Upper layers can implement their own timeout function, say to free
-- 
2.25.1

