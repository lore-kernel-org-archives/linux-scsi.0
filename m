Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 694F7C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Nov 2021 17:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355760AbhK0Rnz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Nov 2021 12:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbhK0Rlz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Nov 2021 12:41:55 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED7EC061574;
        Sat, 27 Nov 2021 09:38:40 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id r138so11160159pgr.13;
        Sat, 27 Nov 2021 09:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KXHOYE2DGpHKJjVyUDHRjV9NmlxJIMrpXm3uC4olpKs=;
        b=migdmGkkMQ3km3OtfvhJRC6bNOuIX0tVx5umTvyla6Sgyuy8cswRVmq9bunpQrcztu
         /GKRaMViJuH252Ix3WWZC7GrOS3AM8bQ025Y+rV/lvu6+Ri5JAollWd+SmbYZwz9HdYJ
         FpUZFrYxgNAfD0kdYMte22h/MNWJcEbK3MvzSOOgX6gU1yGYb0dGMt1YkTSn+7xjdnsq
         gLulWpF+ZmqeJ9eHZkiufDlEZcZPAyP08buPOBADEHAPIEQIbDGvEiOLkBOdAucy0ks/
         BjjxxrNu3wmKbMo54oK91ZgzS9LPXf1GuRZf/tf2YddPlmwn0utJo5xxCDqXdId5cvEF
         u0lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KXHOYE2DGpHKJjVyUDHRjV9NmlxJIMrpXm3uC4olpKs=;
        b=3hjDLtfrIlcJk1iekKNdAdVV7SvpuylC8wODwwwptuo8fhdFXVfNSf/XAxLkbL2lJm
         bDCfQLodSfPFlXpJh0j95DeMJlb2Zf4SqUEdxuuDu1t1BbcI4mxPm5ugQm7TNltR4IPy
         2t6MJKNQQdsa5Tg4RWBUNRF5CjJYZepCAOTL2ftPKNjKG8pMY31a3CSTc+81MTzUDLNb
         SAuTglc1Xm1P8TltxD3iMBDqbIxWgpDtCI/i56MQroxhy60JB3/iXW0nECl6vQZekYIF
         yKpAzbFCIYjYS+oDqruzbCOoVvrY5tJsoaLToSlZlLx6N8sh8cvgrVlUzTdUTnsrwc9P
         zZTw==
X-Gm-Message-State: AOAM532mTukkqEMQE3WHlc+w5l93XUkvvpH7tNXmmsZ32DEb4sySmGjg
        r7cd23lWK5fNTRQmlBY/MP3SNP8W9VEaAQ==
X-Google-Smtp-Source: ABdhPJyKFHji3KirT7hXrnmGoSamfC1s0BzrGR92mwf9Vt7W9b45eWnhICptB24UDv8sKxtjB7LBzQ==
X-Received: by 2002:a05:6a00:2151:b0:4a2:5c9a:f0a9 with SMTP id o17-20020a056a00215100b004a25c9af0a9mr29308241pfk.39.1638034719529;
        Sat, 27 Nov 2021 09:38:39 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net (70-36-60-214.dyn.novuscom.net. [70.36.60.214])
        by smtp.gmail.com with ESMTPSA id t19sm8051776pgn.7.2021.11.27.09.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 09:38:39 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com (supporter:QLOGIC QL41xxx ISCSI
        DRIVER), "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org (open list:QLOGIC QL41xxx ISCSI DRIVER)
Subject: [PATCH v2 0/2] scsi: qedi: Couple of warning fixes
Date:   Fri, 26 Nov 2021 12:17:06 -0800
Message-Id: <20211126201708.27140-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These warnings started to show up after enabling PCI on BMIPS (32-bit
MIPS architecture) and were reported by the kbuild robot.

I don't know whether they are technically correct, in particular the
unused 'page' variable might be unveiling a genuine bug whereby it
should have been used. Please review.

Changes in v2:

- added Acked-by to patch #1
- changed SYSFS_FLAG_FW_SEL_BOOT to contain the typecasting and not
  change the way it is formatted before sysfs printing

Florian Fainelli (2):
  scsi: qedi: Remove set but unused 'page' variable
  scsi: qedi: Fix SYSFS_FLAG_FW_SEL_BOOT formatting

 drivers/scsi/qedi/qedi.h      | 2 +-
 drivers/scsi/qedi/qedi_main.c | 3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

-- 
2.25.1

