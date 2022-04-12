Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25CDDC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbiDLXgl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiDLXcx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:53 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F882C55B3
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:27 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso4403523pju.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A8x10dniHeRN0E/sm+bVJIFGFElYIDPha5Gn5CDecrc=;
        b=nacmmRgwoCZwGxhmF6WF3Kq2dGLXxJ+7+9KX187XBBL7TJpQJFbviy5PCi+684YCBU
         Zl0kzEzH6i+HVVNDqdTLvvdvwys5LaGaTJYtiA/l/I9FAHuyoWvmeR8ymQVNovS1fj8b
         7QTjoCfAp0imPS3HVe8puP5cZArsdFr0+Na1bErA/pGf9P6tRws5OPY4Ejq9V1wfrrl9
         P31q2VXELnJ03KuRw1JhZ6e2DLhCcxAnlEDr8CFp0oJdOKTaYf5yN+ioVcRI8uWKr5oT
         3x4TrF7zaE2F/HI0ropp2jHzT/OHSV9mNxklZ9adZ0yEQv6OpoG16gC827S0yk/AnceH
         IS/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A8x10dniHeRN0E/sm+bVJIFGFElYIDPha5Gn5CDecrc=;
        b=fE/kDGJVLoBB3hZKoK4nbasD3snH7r/NFZDquqqdFWJh0cmO9glGh55uGzWhe0Z0g6
         ZrtCLxdtEZxrX+Ly9umnlRefY0yPc1nPFJVl0obxw3Uvw13nrj87Eq1ChwzSYOeV8u8T
         7i06q3HXgtBGlrv/YnuJBZPpIqhbct2Fg6vzmFBUaeCMYrWgZ8lkkqVNfbzXWLPMNaKt
         zTufw14QJuM1pyE7xVUIodHxsZUc0Po4STTfiuz1MLQdQ6HB13qJYPlGkxQNuXisiwpO
         j9xPRl6Worqq+DvfF14ki0yxLSfljKEvq+b4KPryeY9KEVpriBU0eLlbGmggt78mT24x
         Mjkw==
X-Gm-Message-State: AOAM532qQ/3w98/6Znwq/s98iXzNT2CaD1R2Efg6alWecKuME+IGKGIn
        wUl4B4/tQjyn6+G0SPt8kzCHD6w+SDc=
X-Google-Smtp-Source: ABdhPJz2RkExfQb22/xSwsiQ4VDIVpv/sfeHS/3Naiwe1e5mqhRcCVt9m9BuGZEoVzTWHagUcdh/hw==
X-Received: by 2002:a17:90b:3144:b0:1cd:37de:3bbc with SMTP id ip4-20020a17090b314400b001cd37de3bbcmr4006958pjb.110.1649802026567;
        Tue, 12 Apr 2022 15:20:26 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:26 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 15/26] lpfc: Fix call trace observed during I/O with CMF enabled
Date:   Tue, 12 Apr 2022 15:19:57 -0700
Message-Id: <20220412222008.126521-16-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following was seen with CMF enabled:

BUG: using smp_processor_id() in preemptible
code: systemd-udevd/31711
kernel: caller is lpfc_update_cmf_cmd+0x214/0x420  [lpfc]
kernel: CPU: 12 PID: 31711 Comm: systemd-udevd
kernel: Call Trace:
kernel: <TASK>
kernel: dump_stack_lvl+0x44/0x57
kernel: check_preemption_disabled+0xbf/0xe0
kernel: lpfc_update_cmf_cmd+0x214/0x420 [lpfc]
kernel: lpfc_nvme_fcp_io_submit+0x23b4/0x4df0 [lpfc]

this_cpu_ptr() calls smp_processor_id() in a preemptible context.

Fix by using per_cpu_ptr() with raw_smp_processor_id() instead.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index c3daf7a3e123..a949fe53651a 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3835,7 +3835,7 @@ lpfc_update_cmf_cmpl(struct lpfc_hba *phba,
 		else
 			time = div_u64(time + 500, 1000); /* round it */
 
-		cgs = this_cpu_ptr(phba->cmf_stat);
+		cgs = per_cpu_ptr(phba->cmf_stat, raw_smp_processor_id());
 		atomic64_add(size, &cgs->rcv_bytes);
 		atomic64_add(time, &cgs->rx_latency);
 		atomic_inc(&cgs->rx_io_cnt);
@@ -3879,7 +3879,7 @@ lpfc_update_cmf_cmd(struct lpfc_hba *phba, uint32_t size)
 			atomic_set(&phba->rx_max_read_cnt, size);
 	}
 
-	cgs = this_cpu_ptr(phba->cmf_stat);
+	cgs = per_cpu_ptr(phba->cmf_stat, raw_smp_processor_id());
 	atomic64_add(size, &cgs->total_bytes);
 	return 0;
 }
-- 
2.26.2

