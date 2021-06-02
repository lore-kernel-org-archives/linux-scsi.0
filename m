Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D44C7C4708F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 18:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B47A261DAD
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 18:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhFBSCB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 14:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229467AbhFBSB7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 14:01:59 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A945FC061574
        for <linux-scsi@vger.kernel.org>; Wed,  2 Jun 2021 11:00:05 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id lx17-20020a17090b4b11b029015f3b32b8dbso3928178pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 02 Jun 2021 11:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YzKTs0J8fXoCjJBzufm+adOqqY1UoziMMTbtfSyXGi4=;
        b=jGzYlGefJkjcaCnSFLDBlpOkaOpFVNv3fS5GUP8YE4ktBqcIHbf6HAakJy9aI7o+M2
         KigHSo+QsXCBPdWvp7p3XG5fLttkRQdieVUAWd94mHKpnTT/gISACF3S1zSzHmko6IwR
         ASy2T/ycXegM706E1mv4ROXrKqyxv5vYoCYEc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YzKTs0J8fXoCjJBzufm+adOqqY1UoziMMTbtfSyXGi4=;
        b=ADHuLObQd6yDuglDvKwjZd1GKJFHFgv2bal7P1wn/eP6cRbE9qSrfmLVq+1MRZ7iEZ
         +ljVEaVh07ZlHtEVeWTURbmtuEANlYiljfG6o2/3Gxd545EQ038Qi3uSwO7dmToAtmFO
         3daWtolEbNcnwgwcKksD/CKEKX1/zZ9iuslWrO9WW97JOyvoquWDMORs3NORAEQCiRfL
         Gft0Oaa3WcbAGB/sJkjp40o/eUjFPzOFK+gdlwWjB4zIcNaq2m3NHhfI2wNIFzbVq2SQ
         lp+VeA5yG01/mnlga2DHAJtQCeijkMtKuG0GLheW1MLG6qlaAfpEkPuPbFU23D95Th33
         InVg==
X-Gm-Message-State: AOAM533j370IMvsZMVT9/syoGa1nAJ89XfZJx6w4SvZfEDUh0k0wZoiq
        6r5xRDNvkWUk+9haLdPKnZp0mw==
X-Google-Smtp-Source: ABdhPJyuFM58x7Sv+O692q7ERK7l6HOo3hypRgAmtQSCzw0TYbpNKpnjoOZS1yIAntgzqL4AJ8Eyzg==
X-Received: by 2002:a17:90b:38cd:: with SMTP id nn13mr6696749pjb.48.1622656805115;
        Wed, 02 Jun 2021 11:00:05 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id m1sm397994pgd.78.2021.06.02.11.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 11:00:04 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Kees Cook <keescook@chromium.org>, Joe Perches <joe@perches.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-scsi@vger.kernel.org, linux-hardening@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: fcoe: Statically initialize flogi_maddr
Date:   Wed,  2 Jun 2021 11:00:00 -0700
Message-Id: <20210602180000.3326448-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=26150766ac749c1c294828a8255824f1c1f8fe16; i=95Is7JkaFTuD8yBK8ZqRtqMfruaTolJ5BECzzYphzjk=; m=Lx6JJw18vLqP7fW8njYDmnOt/EnJ++MkyC26ujChlaQ=; p=O0CUdXEefbXm/vJ3Z09Q1E3tpRXOhkgbS1ffGDQy7YY=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmC3xx8ACgkQiXL039xtwCafVBAAr2P 83Qty+fa78mrhypxErK9jHI/xfX1opwsSP+TyL2DUI57tARg7VoJVIAuCEuGjQs4v8dpzAh1NSEx7 ECMVil0Yy242LMHgZP3p7sBj1YToUCt3e7qxsfios1i7H3WoHBc5YlCSQHXZ2ELKzjviCbDFrGBEc bV5cKqsacIfFCFIqt6ou/UuVZrlP6EmF8NAICoxvkbTQcnz3+ns2718oRq7mEKraXsuztY0c6rf5N 94YbzGezhWi7pFje2XtfUrRktEz4T1o0/qeM4NRlWdzaEmLFCjE1p7n+SJ5qvuZvWueoC8qSDFdOJ 11H7CDkqVXbNOUPLCg3de6hxqsuQzaa36YKYVoPxpWVhEvp/HkC38bDogoyZJ86rDunApvIHVscBl 9QO6DtCgOTaKKvP4fvh9uBXgtsYaZIVDU76Ybzc0bw9OPcVt+SFveiq/5Q+Hl1qXdMe+NlSC3MPxX gJ+qsnAkgE84W+erbZjPrpV8Fj/qRhs4ZV2j47FQokuALTV5xX0E+Os66n4wP51AlLr0+KqeJU1Kt 9YKefP/rp2nZeQj6RIJ5zU3zUW49wYpvtcD1wWhi5qPGMrdDmjWkWF2Hj5H3Xzf/BB/xXcBGYek0o akHfC6iXrAQxPOdrrL7fjC5ICGqcbiVpn62DZ80VtSWCRYnu9xY19NI9EToBd5UY=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy() avoid using an inline const buffer
argument and instead just statically initialize the destination array
directly.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2:
 - use "static const" (Joe)
v1: https://lore.kernel.org/lkml/20210528181337.792268-2-keescook@chromium.org/
---
 drivers/scsi/fcoe/fcoe.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 89ec735929c3..5ae6c207d3ac 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -293,7 +293,7 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 	struct fcoe_ctlr *fip = fcoe_to_ctlr(fcoe);
 	struct netdev_hw_addr *ha;
 	struct net_device *real_dev;
-	u8 flogi_maddr[ETH_ALEN];
+	static const u8 flogi_maddr[ETH_ALEN] = FC_FCOE_FLOGI_MAC;
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
+	static const u8 flogi_maddr[ETH_ALEN] = FC_FCOE_FLOGI_MAC;
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

