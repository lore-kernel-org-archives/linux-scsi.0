Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0275CC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 14:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9EF060F93
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 14:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236986AbhJOOWT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 10:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234738AbhJOOWS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 10:22:18 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55324C061570
        for <linux-scsi@vger.kernel.org>; Fri, 15 Oct 2021 07:20:12 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id d23so8742380pgh.8
        for <linux-scsi@vger.kernel.org>; Fri, 15 Oct 2021 07:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WE8C3v2KkaegB38V452jYVeqSTa7V+Fbu4i+lCviRkQ=;
        b=GTlB+KMvKldVC9OZrA9JGLO22zZeMA7GkxnczPFRmGAkxr1DvoZsK3luqOCeW3ws2a
         5wAEvW7gJMuc4zWEmoV00u3qAAkeI42+0Yl4b0GFdYI7ZhXYdf8NtDQ/Ykd99Pd/icFt
         Ow9+mGTf7lyslFU3SNS3P2cg3dj0yZltGDoYcxofTeUkijWIobBDBLNiElUEuCpWP9K0
         sssu1mRvb0bWUb2uZUfmRLF2Vc7wkLZgSW+9HZWcYBY1vPO2Y2OQYZqZGbFsci4nNg1u
         mqMxjLBVeGHahraH73t3GnLC6ZvuOEjupFIJDnYYHpyMl0XcBL42xVz3z6HbDPCdIDNh
         caTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WE8C3v2KkaegB38V452jYVeqSTa7V+Fbu4i+lCviRkQ=;
        b=FPAlKdZJvYGXyDg1wAPV0OHxxiXBN1tCnLey8rvs97F7WGmnDu1H6cgw4hlSWqEDYv
         TLd2lSfgaU3YlR3s9vQSQCmt7kD4EvhRwbfgPRB5VT4I+zONpW5yDpcgplyHM5/Gdxl8
         cTrMh7+XTULRKxI2/Vk4XjilhpvBHrbjCjZuMElYVn4l1GEjql4oABY8vdWofEs8oWVi
         VhaUPMBb/M22mjZ7UDMg2ZWZY0qkVdBYDqX15em7hFp97xbynzFob6bsq8IMqlwEEqHb
         Q1gN2QZItWVFVdRY2xwMtuJGGVP68eM4BnaLwq+VT2vBUAHd9/NhCSKmt57+4VXB4jcA
         yvag==
X-Gm-Message-State: AOAM531lmcu9PPQ5la+l14fSka+TludkoqmwwqPwmaIAxJfSPoI/X5KV
        LyWrya33roErCCiNbg1dUjU=
X-Google-Smtp-Source: ABdhPJw3DCJ52QI+St2Lz/czXnS8foOE7qjYNogud0M7hIU+K93sTgw0E96YsU6ogj2SvTZeuPPTaQ==
X-Received: by 2002:a63:7504:: with SMTP id q4mr9304924pgc.103.1634307611677;
        Fri, 15 Oct 2021 07:20:11 -0700 (PDT)
Received: from localhost.localdomain ([223.39.146.200])
        by smtp.googlemail.com with ESMTPSA id e14sm4854832pga.23.2021.10.15.07.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 07:20:11 -0700 (PDT)
From:   MichelleJin <shjy180909@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     hare@suse.de, linux-scsi@vger.kernel.org
Subject: [PATCH net-next] scsi: fcoe: use netif_is_bond_master() instead of open code
Date:   Fri, 15 Oct 2021 14:20:06 +0000
Message-Id: <20211015142006.540773-1-shjy180909@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

'netdev->priv_flags & IFF_BONDING && netdev->flags & IFF_MASTER'
is defined as netif_is_bond_master() in netdevice.h.
So, replace it with netif_is_bond_master() for cleaning code.

Signed-off-by: MichelleJin <shjy180909@gmail.com>
---
 drivers/scsi/fcoe/fcoe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 5ae6c207d3ac..6415f88738ad 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -307,7 +307,7 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 	}
 
 	/* Do not support for bonding device */
-	if (netdev->priv_flags & IFF_BONDING && netdev->flags & IFF_MASTER) {
+	if (netif_is_bond_master(netdev)) {
 		FCOE_NETDEV_DBG(netdev, "Bonded interfaces not supported\n");
 		return -EOPNOTSUPP;
 	}
-- 
2.25.1

