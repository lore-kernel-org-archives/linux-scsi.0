Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE4EC433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CB5A216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405384AbfHIDDz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:55 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46387 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404533AbfHIDDz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:55 -0400
Received: by mail-pf1-f195.google.com with SMTP id c3so22085862pfa.13
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I00wm+N9pakcsX4J8TfEy96f7jiZIOD1SYmi0tu5GMg=;
        b=Jsir3rnJd7uPe5k5iRnznexNC5wkkwIeu9uF9uFqRv1w4iEub78izbOynopudANo6p
         DhjIOkAYdHHQxQZr3y9kXezR92ZPjqfl2YWLyixfZsRxhdBLLHIpw3ZgjJ8ZgG3CNwgz
         J2C+CPxe+GrdvqLzR0r0Cvjg69/hMX6RqsG2O2l8ZP0AkNChdS+u3WQjQFSeYJmLfmfq
         ByHB7sEhHladWeJv9Gt5zdPHNOpU6IYe0axjljtRDskpKaky3EUXt+UEazfO8jIiI7mH
         mlne99qkBU20solQdRwVJMZiDXIY83P/wwruOIqmPzLZIN0Mqm9L6+LPHheOAvpp+6mw
         pfDw==
X-Gm-Message-State: APjAAAWvDXVrsRJxEaIL6QzU6G0FWjFam0YWWQNs036ocPmE+0lwIKas
        PpzzsgN2AlWcyKjBa8UQLpE=
X-Google-Smtp-Source: APXvYqwl2ZfNV3GpPBGVJXGbgfE3q+EnMTfdKYdSeuSq8f70N/l5mFTeP3B+78iQTypncKO20SO3Jg==
X-Received: by 2002:a17:90a:d817:: with SMTP id a23mr7064668pjv.54.1565319834113;
        Thu, 08 Aug 2019 20:03:54 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 58/58] qla2xxx: Fix a NULL pointer dereference
Date:   Thu,  8 Aug 2019 20:02:19 -0700
Message-Id: <20190809030219.11296-59-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

BUG: KASAN: null-ptr-deref in qla24xx_handle_plogi_done_event+0x134/0x9f0 [qla2xxx]
Read of size 4 at addr 00000000000000a0 by task swapper/2/0

CPU: 2 PID: 0 Comm: swapper/2 Not tainted 5.2.0-dbg+ #1
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
Call Trace:
 <IRQ>
 dump_stack+0x8a/0xd6
 __kasan_report.cold+0x5/0x41
 kasan_report+0x16/0x20
 __asan_load4+0x7e/0x80
 qla24xx_handle_plogi_done_event+0x134/0x9f0 [qla2xxx]
 qla2x00_els_dcmd2_sp_done+0x15f/0x230 [qla2xxx]
 qla24xx_els_ct_entry+0x3b3/0x610 [qla2xxx]
 qla24xx_process_response_queue+0x514/0x10e0 [qla2xxx]
 qla24xx_msix_rsp_q+0x80/0x100 [qla2xxx]
 __handle_irq_event_percpu+0x72/0x450
 handle_irq_event_percpu+0x74/0xf0
 handle_irq_event+0x5e/0x8f
 handle_edge_irq+0x13a/0x320
 handle_irq+0x30/0x40
 do_IRQ+0x91/0x190
 common_interrupt+0xf/0xf
 </IRQ>
RIP: 0010:default_idle+0x31/0x230

Fixes: 8777e4314d39 ("scsi: qla2xxx: Migrate NVME N2N handling into state machine") # v4.19.
Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 7021fbeb6d23..e92e52aa6e9b 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2755,7 +2755,8 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 		} else {
 			memset(&ea, 0, sizeof(ea));
 			ea.fcport = fcport;
-			ea.rc = res;
+			ea.data[0] = MBS_COMMAND_COMPLETE;
+			ea.sp = sp;
 			qla24xx_handle_plogi_done_event(vha, &ea);
 		}
 
-- 
2.22.0

