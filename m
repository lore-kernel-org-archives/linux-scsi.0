Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83551C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Oct 2022 16:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiJQQfk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Oct 2022 12:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiJQQfj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2022 12:35:39 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAAC3B975
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2022 09:35:38 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id h24so7703597qta.7
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2022 09:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ptDyamYofHoy/erqE6WWoA4EsxdHTu9VdtG5MEtr8E0=;
        b=ax5+RwyHDFR4h3iMfan47kvNEaq+hM1pnpz3PHuA3uYp+IJS24sv81TY27aQ9ufJ4Q
         OFJiNp166HsgqGtflrXat2UldH3DEeeEjiriZrqcO4+UpDRSoL6ankXsmvG5lyS57fjV
         qbtqKzMf1ejqqh6xRY3y3ngC6bREQZZKnX6Rv38p2r+szJkG9XHPcqZYzbN/D/78/HGu
         6qhUQZhWtCtK0UWN8HY5jIrB5A6QRLUx6MLUuPovHyLXUHCG5z0iEDcrcQpnlzoec4yp
         ooTJ8C0lTICeOial3QGdSy6aWMNfG5yuR8fnDvWnYWsovr3QIkNWM7Go+5WaZTq2Wz0q
         Unpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ptDyamYofHoy/erqE6WWoA4EsxdHTu9VdtG5MEtr8E0=;
        b=V+8Tel1/pzCDjmaIOknnlsz3w3g5b98k5cm1NdfiUWDbwTT/gymKxCnnx17gUF9b6F
         35JukVWVra0cAuT6oaMn6hkxlygcBo1nEtr1dwNkSFCdx0AUGxq99DZSv1JhQJ4wG0B7
         KpofvovDZBoumEuQfzRZMcSm6ucUJQRYYwHbHtBirsZ8o4sv5RerwW/RQEtBdS+Mkr6z
         NogodQ8QDEj1mnXCZ0IhWRI8WecKkkSObSfIdGuPeWU6qknFGrDHB2PaAglLugHLUkdo
         +KYBzlZdRYQlZlViiyHdaeDkryO0jOwMYu6J9Fnzru4hQ59IVjAO3Kd0qi21fsgn1Jcp
         v1ZQ==
X-Gm-Message-State: ACrzQf2d3hQrg6qdquVOWh/jXkSGyti8l4a8PRNW4KHNXcr2DnbaDvC5
        BIgJRc1txx6WrjjpInXtUiabFoYoKHI=
X-Google-Smtp-Source: AMsMyM6sqNFdjO14ZYHUIY5Ai2b2WBaj/ojZBa0rS5fJHaWKK2mSn0o/zqTv9v1gfVllwbvl4bBf+w==
X-Received: by 2002:ac8:7d49:0:b0:399:d201:840b with SMTP id h9-20020ac87d49000000b00399d201840bmr9623921qtb.309.1666024537642;
        Mon, 17 Oct 2022 09:35:37 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r2-20020ae9d602000000b006ceb933a9fesm152235qkk.81.2022.10.17.09.35.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Oct 2022 09:35:37 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, Justin Tee <justintee8345@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 2/5] lpfc: Fix hard lockup when reading the rx_monitor from debugfs
Date:   Mon, 17 Oct 2022 09:43:20 -0700
Message-Id: <20221017164323.14536-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0.83.gd420dda057
In-Reply-To: <20221017164323.14536-1-justintee8345@gmail.com>
References: <20221017164323.14536-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During I/O and simultaneous cat of /sys/kernel/debug/lpfc/fnX/rx_monitor,
a hard lockup similar to the call trace below may occur.

The spin_lock_bh in lpfc_rx_monitor_report is not protecting from timer
interrupts as expected, so change the strength of the spin lock to _irq.

Kernel panic - not syncing: Hard LOCKUP
CPU: 3 PID: 110402 Comm: cat Kdump: loaded

exception RIP: native_queued_spin_lock_slowpath+91

[IRQ stack]
 native_queued_spin_lock_slowpath at ffffffffb814e30b
 _raw_spin_lock at ffffffffb89a667a
 lpfc_rx_monitor_record at ffffffffc0a73a36 [lpfc]
 lpfc_cmf_timer at ffffffffc0abbc67 [lpfc]
 __hrtimer_run_queues at ffffffffb8184250
 hrtimer_interrupt at ffffffffb8184ab0
 smp_apic_timer_interrupt at ffffffffb8a026ba
 apic_timer_interrupt at ffffffffb8a01c4f
[End of IRQ stack]

 apic_timer_interrupt at ffffffffb8a01c4f
 lpfc_rx_monitor_report at ffffffffc0a73c80 [lpfc]
 lpfc_rx_monitor_read at ffffffffc0addde1 [lpfc]
 full_proxy_read at ffffffffb83e7fc3
 vfs_read at ffffffffb833fe71
 ksys_read at ffffffffb83402af
 do_syscall_64 at ffffffffb800430b
 entry_SYSCALL_64_after_hwframe at ffffffffb8a000ad

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 768294b9bc0b..86ba45ac91c8 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8150,10 +8150,10 @@ u32 lpfc_rx_monitor_report(struct lpfc_hba *phba,
 					"IO_cnt", "Info", "BWutil(ms)");
 	}
 
-	/* Needs to be _bh because record is called from timer interrupt
+	/* Needs to be _irq because record is called from timer interrupt
 	 * context
 	 */
-	spin_lock_bh(ring_lock);
+	spin_lock_irq(ring_lock);
 	while (*head_idx != *tail_idx) {
 		entry = &ring[*head_idx];
 
@@ -8197,7 +8197,7 @@ u32 lpfc_rx_monitor_report(struct lpfc_hba *phba,
 		if (cnt >= max_read_entries)
 			break;
 	}
-	spin_unlock_bh(ring_lock);
+	spin_unlock_irq(ring_lock);
 
 	return cnt;
 }
-- 
2.38.0.83.gd420dda057

