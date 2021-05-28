Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B159C47087
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 18:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F0EA613D1
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 18:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhE1SPS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 May 2021 14:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhE1SPQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 May 2021 14:15:16 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A66C061761
        for <linux-scsi@vger.kernel.org>; Fri, 28 May 2021 11:13:41 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id g18so3854851pfr.2
        for <linux-scsi@vger.kernel.org>; Fri, 28 May 2021 11:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2qeALokNh1iV94XoUXRrDmoZR32MixsQjhUt5pfNJoI=;
        b=lQNTcma3W0ACxWMruXV7/81HRYphyAY8g2cuty+wJCt3nGYR4BkCqF93KWCxfVSgWd
         CYIQAdbJ9q5xGrttJRZcBKZ1qBxC7OiO8W6Lg+No4WLDszS7V76vc/Ijr4ZwZLWxdvo0
         hzKK655EJn+SH0dQglsX3i9ZruvGAqgX4/RCs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2qeALokNh1iV94XoUXRrDmoZR32MixsQjhUt5pfNJoI=;
        b=cd5sg0PfHMMFMCy3zWrz+ivUgwNthmKXDapSBGjzYPSQStXpnp/GtmioXWJHo0WFq0
         asWzMJeC0z3uZLvmI551fmnM1+jeLqi0cBzDIYKVzlmmLJ96lS7kDm09fa6IzaKOF9sT
         FQ3EuCHpTGkenbHlCz5ccMQ3A6hbEemsNfWsEbqkLtqvJpYTuJuqaPHnbvsDNLL1Xzvd
         nF2cG6Towdm9ftdu5YJCoziO79wG3O/PUUT9wVbu4kub+7rqnTopADJ6a+L0eNirO76X
         BMFORvlo/Y7ItfXEg20IealsbGiS1x+YvbLCWm74dQCl8hibBzALL9QjckGOcdoAv27H
         p1og==
X-Gm-Message-State: AOAM531tN0HftAldcFG5JIXj/+mgmhdPNxAqKjA01GmNp9l+rgieK8Jw
        EKdGB84XFWATO50x9UoyxrxJIw==
X-Google-Smtp-Source: ABdhPJxFmCkd0ibmjXyUuAdn8d/4VfScR2HWYJAXlSdavzr2ixQTNEmpBI6ECAbqgrgR+QBJ/JKcrQ==
X-Received: by 2002:aa7:9632:0:b029:2dc:6ef5:b1d3 with SMTP id r18-20020aa796320000b02902dc6ef5b1d3mr5112059pfg.53.1622225621169;
        Fri, 28 May 2021 11:13:41 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a4sm2586464pjw.46.2021.05.28.11.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 11:13:40 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Kees Cook <keescook@chromium.org>, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Bradley Grove <linuxdrivers@attotech.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH 1/3] scsi: fcoe: Statically initialize flogi_maddr
Date:   Fri, 28 May 2021 11:13:35 -0700
Message-Id: <20210528181337.792268-2-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210528181337.792268-1-keescook@chromium.org>
References: <20210528181337.792268-1-keescook@chromium.org>
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=e47d32aead2f09bc45fd65562793c517f4bec062; i=95Is7JkaFTuD8yBK8ZqRtqMfruaTolJ5BECzzYphzjk=; m=vQ0LG77sh0mlAVazI/73j+Gz+gKUZUqL7rNbsd9G8Fs=; p=TzjuF1GRL8hWYpJl6NqKvAbiso01z27hEDzS+3XCjHI=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmCxMtAACgkQiXL039xtwCbwyQ/9Hy2 OTO06JGqppO0iq5Dx1GWxVn4JgLYqE3VJ0gnpter+B+v1LiMh56sZRTI7x4QH5gwb3JVm88AuFGcU DNVW/xus2hxgZ+ACYLgHgrvlvXsd48n+7ikO4yoDbI0AAYUy2ytnqCz1G+JZ6c1G+ACQrvOvo2FPM vAm7ZrzieMlnI/wLMsliurZ1nej0X2dmU+PNki/rkNdsqUPGJfYyPxpFcL88ThJi+yLS43VDVzIrf mtOUkomtBQ5tBUzMi668R/IUoN0SwXl1MKoTQhVO82sgRRJgwSdUxEtEY/hEGq0afVLpBDmDeQ7hd Qrx8DrEYijHnxNT/F7hQL/9/vX/OP3x/KJc98DSGO8IzyplJ1nl9kaf17UB8Sd1TsKXFnHsoHMTya PXHJWDbBW/KmhyoH9Nsa+pgAleQE+zMbXN3LtOgqWwJd2v50GiJOT0/pnU6RreWn0bNMkOGXCdgif 02Vq17oK5PKnd0PjJfkyZOu9XXmneKeGVrK/IOh+HgaBJSjOB2H5P0P0nRJbA6Q+ucDeT4Ak3K2FI Xg25afXg4/wLMvNMqjUcI5d3E14vs1hxPsglDzH8oWKB7tnDckuAoBCb09ZLmXSWBRYdHQWFxM/AU D13XZeosaTixq0Zp14CuJvAIVrJdGmf5Bq5ma4b/WP5wVe3PDD+GMzQK7swLg/+E=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy() using memcpy() with an inline const
buffer and instead just statically initialize the destination array
directly.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/fcoe/fcoe.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 89ec735929c3..8991990e6639 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -293,7 +293,7 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 	struct fcoe_ctlr *fip = fcoe_to_ctlr(fcoe);
 	struct netdev_hw_addr *ha;
 	struct net_device *real_dev;
-	u8 flogi_maddr[ETH_ALEN];
+	u8 flogi_maddr[ETH_ALEN] = FC_FCOE_FLOGI_MAC;
 	const struct net_device_ops *ops;
 
 	fcoe->netdev = netdev;
@@ -336,7 +336,6 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 	 * or enter promiscuous mode if not capable of listening
 	 * for multiple unicast MACs.
 	 */
-	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
 	dev_uc_add(netdev, flogi_maddr);
 	if (fip->spma)
 		dev_uc_add(netdev, fip->ctl_src_addr);
@@ -442,7 +441,7 @@ static void fcoe_interface_remove(struct fcoe_interface *fcoe)
 {
 	struct net_device *netdev = fcoe->netdev;
 	struct fcoe_ctlr *fip = fcoe_to_ctlr(fcoe);
-	u8 flogi_maddr[ETH_ALEN];
+	u8 flogi_maddr[ETH_ALEN] = FC_FCOE_FLOGI_MAC;
 	const struct net_device_ops *ops;
 
 	/*
@@ -458,7 +457,6 @@ static void fcoe_interface_remove(struct fcoe_interface *fcoe)
 	synchronize_net();
 
 	/* Delete secondary MAC addresses */
-	memcpy(flogi_maddr, (u8[6]) FC_FCOE_FLOGI_MAC, ETH_ALEN);
 	dev_uc_del(netdev, flogi_maddr);
 	if (fip->spma)
 		dev_uc_del(netdev, fip->ctl_src_addr);
-- 
2.25.1

