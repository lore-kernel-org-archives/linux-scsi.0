Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44913CA9EAF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 06:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 169182166E
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 06:37:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PRRMrHis"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437751AbfJXGhs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 02:37:48 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43695 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436471AbfJXGhs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Oct 2019 02:37:48 -0400
Received: by mail-pg1-f195.google.com with SMTP id l24so8679257pgh.10
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 23:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wut7wa2kH3JJjswqkyvKznwH6YzcTwQ9IpmU5ayP8iE=;
        b=PRRMrHiszXW+s6oODlkes1mBacnZgY7eLV4QECeyGOxYNW4or9dlld9I90ldFzjvvR
         eVF+9GwoJ0uGm7SAswpf4gjmUuN7LYxi1GmLxZPYfmKgqn+kz46EBaU6wz7iqWG5WsE/
         brgnS/QyTZaW7VLQM38d+rsEmsSNz+KOuDH6VG31J1ICRiiLmIfbpfcfJdKo9+dXDjl9
         +JQ7yXnyyVWsSZLGii8Z7JvYZyxXTyzD5fufD4pu7Pcn4CgwmXRKQZ9VH1jxWv5I+2FZ
         /okVrys6fcfjDX7xL7XokNvE6PiKJJtRF4hQCDEA38lNR9/goq+Y8hJ+2u+JitScTK2Y
         bLsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wut7wa2kH3JJjswqkyvKznwH6YzcTwQ9IpmU5ayP8iE=;
        b=LBLz+EffKBiD1qSJMKd7SJTI9rlYKWTSvMXJ0VbtTO/ur4csGHdKW6nHZhsF2H6ce3
         NJ6iX8Fr/L52YxGBwj1xoKcTw1/7lxoJN7KpIwB2BGchQGjQ71XwEMFHT8zbuS0yBlEf
         7EDDMx/3t/KpANjxbMt1B35beXrTw+WMR2xiG4VNq8YhNFF9IF9tzdS4RvPAtn69jpNe
         1BEiJ3K66wz8UdzY1pkJvfikc9zFGWVg6zn9N3q1kOFpiQo+uvl7ZdhABQ7iQI9ZQPa6
         uMQBrvudqZ0bVT0m/KJm+NMBPRxT/BZ7R4tkUGRRBoK2SyY35GaBJye/DGx7lOMWdEfu
         ZXWA==
X-Gm-Message-State: APjAAAVgh8PHCJRB460PUvuSAXBMFJdWuLCq+EEffkQDFTUB6Z/Bf27p
        KKPHgsXpR0GhDdaiz+Htcm2TtRLhe6U=
X-Google-Smtp-Source: APXvYqzh2bkE/gQ+QK8XrMvAPAcfy2S8qdtTVLo+G2eCJvGK6/AApRaZspU2h3Leu2inJvnolEwpag==
X-Received: by 2002:a17:90a:ff07:: with SMTP id ce7mr5222978pjb.12.1571899067523;
        Wed, 23 Oct 2019 23:37:47 -0700 (PDT)
Received: from bobo.local0.net ([210.185.75.56])
        by smtp.gmail.com with ESMTPSA id z23sm24164859pgu.16.2019.10.23.23.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 23:37:46 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        zengxhsh@cn.ibm.com
Subject: [PATCH] scsi: qla2xxx: stop timer in shutdown path
Date:   Thu, 24 Oct 2019 16:38:04 +1000
Message-Id: <20191024063804.14538-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In shutdown/reboot paths, the timer is not stopped:

  qla2x00_shutdown
  pci_device_shutdown
  device_shutdown
  kernel_restart_prepare
  kernel_restart
  sys_reboot

This causes lockups (on powerpc) when firmware config space access
calls are interrupted by smp_send_stop later in reboot.

Fixes: e30d1756480dc ("[SCSI] qla2xxx: Addition of shutdown callback handler.")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
The Fixes: tag is not exactly fixing the commit, presumably the timer
was still left running before then too. However it gives a handle
for backports: if you care about cleaning up resources on shutdown,
then you need that patch, so you'll notice this one too.

Thanks,
Nick

 drivers/scsi/qla2xxx/qla_os.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3568031c6504..28a40763fabe 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3531,6 +3531,10 @@ qla2x00_shutdown(struct pci_dev *pdev)
 		qla2x00_try_to_stop_firmware(vha);
 	}
 
+	/* Disable timer */
+	if (vha->timer_active)
+		qla2x00_stop_timer(vha);
+
 	/* Turn adapter off line */
 	vha->flags.online = 0;
 
-- 
2.23.0

