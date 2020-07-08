Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B317C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:02:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A1162078A
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:02:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bV9bLouL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbgGHMCb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728987AbgGHMCa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:02:30 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0989C08E6DC
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:02:29 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j4so46263571wrp.10
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/GI6WmzBD/tXdjRqMOCJ6wEDBpBeiEpQ/v95OUrVAL8=;
        b=bV9bLouLqxa4IS/T3dEi6X062He0tvGD4Qu/lii+sBTB4lF0PJlrBT8iLObnuSUf/d
         htNbTUHwkzbxbY17Ti9OZOI298t98K0MS6hNsoWwMwcsCPUo3nWfTqmkMHnMbxdFDwIi
         7cLhWhiWk7Jt+bIL+nYY7mPML81GkdliiPEbEJqIfUNk1igpLbKw/cz5TYWHDyLRjtgk
         S//PUlCBhoQn2NoheTUiYMruF8YG+aV7399r8pLTeHV4kq8MmiDx5BTyNiAuDzBcVPId
         n1PpGPt9MNZ2uNMMYT+7vRTd6tgVu8bpnr1hH9IbIyuKzf+P6pXBu4mNP+SiwWU1eBPv
         C1fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/GI6WmzBD/tXdjRqMOCJ6wEDBpBeiEpQ/v95OUrVAL8=;
        b=Hjd4Ryi7TEohjER5QChbC8ayQWQq0Xi+gtp9DPIOqMZ6PpgO5Q/v3DV4GUdLyEXxds
         5SAMV9v0j2aOG8cT4+sbDTfTpqH8PpZvKdG49yJkZRlqy4VRp8D/j26X05VilnpqcdXd
         tYM88YZDFROneGaSgSpmEvpzIIsDVxCbObkxZpTfeM+RkP0QoKMPZNSKWKJzSYa27MXk
         0BOEV1gnweUBiiHiskmlOvQNFgF78ikWWkIVUvOwfzNjytnIP3JN8YiunC5Al4kzA7t9
         8ifOi81a/jgcwZKBYx41vHS9yO3p84HuMSwIJpq0FHSMzpa+Bn42SUN2rHEVkwR9HaOG
         R/Rg==
X-Gm-Message-State: AOAM533+/vXEbvxULYzzKKJ3fajU+IyZv4ChiFip3ZxKaQKlIqSQJyA6
        bjWWTqb6rfEgrsTWwFkvXAdjPQ==
X-Google-Smtp-Source: ABdhPJwVGA5JxCPrvpb0mkdsBMsuK375rqhOSlXQczWVSfrzvBV+h/UTJTX6pj2n5TmhwEwR5NyToQ==
X-Received: by 2002:a05:6000:ca:: with SMTP id q10mr59989471wrx.135.1594209748519;
        Wed, 08 Jul 2020 05:02:28 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:02:27 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: [PATCH 03/30] scsi: libfc: fc_disc: trivial: Fix spelling mistake of 'discovery'
Date:   Wed,  8 Jul 2020 13:01:54 +0100
Message-Id: <20200708120221.3386672-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708120221.3386672-1-lee.jones@linaro.org>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is my fault (can't even blame copy/paste).

Cc: Hannes Reinecke <hare@suse.de>
Reported-by: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/libfc/fc_disc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 428f40cfd1c36..19721db232839 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -370,7 +370,7 @@ static void fc_disc_gpn_ft_req(struct fc_disc *disc)
 
 /**
  * fc_disc_gpn_ft_parse() - Parse the body of the dNS GPN_FT response.
- * @disc:  The descovery context
+ * @disc:  The discovery context
  * @buf:   The GPN_FT response buffer
  * @len:   The size of response buffer
  *
-- 
2.25.1

