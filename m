Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE46FC4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D365B6103B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241436AbhJGUbs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:31:48 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:42844 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233328AbhJGUbq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:31:46 -0400
Received: by mail-pl1-f169.google.com with SMTP id l6so4646550plh.9
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:29:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FTB59pMPuQhJHl5BS28nOuJXEUIlavD+Yi8w4LNUtqk=;
        b=HHwUo9aczwYaiwKcoYfvC7jTd/EnnAqM0ZK/WQvuEOqed8H88w1rNWWkbk+SH09iv6
         Fst0mG1ObdCemZsnRq7VD/fUHTdjiyGwXVKXtIXL45Y/Z8+KWHD+6hvEqzeseMJ6MViF
         Zmf8fpq2JlnP219PFuaMVt5s9ODN8etQu0923fn4De42pD8U3XYDHUy0AUtPx77DSK5l
         +lc7hJ0dlCe6Odf8G8WZ4A+hbe/huL/YAFty1JkE/llD17xUrX5s1WzpWUm+PjPDH5NU
         VZXHcLQO6NgMhdiConUpreeeW1ydn+i/fdEy2NGbkbQtSyF0wun+DpkXBJbVS7/FCrje
         0Tvw==
X-Gm-Message-State: AOAM533WxjzieWMY/bdm6b9FBTf8j+R5EqpN2lGvW8U5aJAaTP2A1UgF
        ddWdZ84wbFHgQeYeaa5wLq8=
X-Google-Smtp-Source: ABdhPJyOqGv76nqxHdb7EtnefoAP8hg5KJ8zAKj9ePXlc2+WFYlaRx7aqBdESEgDiPuIBR7uUSP+bw==
X-Received: by 2002:a17:903:18d:b0:13e:f1ef:d80c with SMTP id z13-20020a170903018d00b0013ef1efd80cmr5895312plg.63.1633638591655;
        Thu, 07 Oct 2021 13:29:51 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:29:51 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 12/88] BusLogic: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:07 -0700
Message-Id: <20211007202923.2174984-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/BusLogic.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 40088dcb98cd..7287a9081684 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2624,7 +2624,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 					command->reset_chain;
 				command->reset_chain = NULL;
 				command->result = DID_RESET << 16;
-				command->scsi_done(command);
+				scsi_done(command);
 				command = nxt_cmd;
 			}
 #endif
@@ -2641,7 +2641,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 					blogic_dealloc_ccb(ccb, 1);
 					adapter->active_cmds[tgt_id]--;
 					command->result = DID_RESET << 16;
-					command->scsi_done(command);
+					scsi_done(command);
 				}
 			adapter->bdr_pend[tgt_id] = NULL;
 		} else {
@@ -2713,7 +2713,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 			/*
 			   Call the SCSI Command Completion Routine.
 			 */
-			command->scsi_done(command);
+			scsi_done(command);
 		}
 	}
 	adapter->processing_ccbs = false;
@@ -3038,7 +3038,6 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 	ccb->sensedata = sense_buf;
-	command->scsi_done = comp_cb;
 	if (blogic_multimaster_type(adapter)) {
 		/*
 		   Place the CCB in an Outgoing Mailbox. The higher levels
@@ -3060,7 +3059,7 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
 				blogic_warn("Still unable to write Outgoing Mailbox - Host Adapter Dead?\n", adapter);
 				blogic_dealloc_ccb(ccb, 1);
 				command->result = DID_ERROR << 16;
-				command->scsi_done(command);
+				scsi_done(command);
 			}
 		}
 	} else {
