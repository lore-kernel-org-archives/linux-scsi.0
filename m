Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06922C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 12:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB90922283
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 12:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgJSMSA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 08:18:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:49286 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbgJSMR7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Oct 2020 08:17:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EFB0FB020;
        Mon, 19 Oct 2020 12:17:57 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/4] bfa: move bfa_sm_fault() to dev_err()
Date:   Mon, 19 Oct 2020 14:17:56 +0200
Message-Id: <20201019121756.74644-5-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201019121756.74644-1-hare@suse.de>
References: <20201019121756.74644-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move bfa_sm_fault() to use dev_err() instead of a raw printk();
this also allows for better type-checking and related fixes to
the calls to bfa_sm_fault() in bfa_ioc.c

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/bfa/bfa_cs.h  |  2 +-
 drivers/scsi/bfa/bfa_ioc.c | 50 +++++++++++++++++++++++-----------------------
 drivers/scsi/bfa/bfad.c    | 14 ++++++-------
 3 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_cs.h b/drivers/scsi/bfa/bfa_cs.h
index 6b606bf589b4..f628ab0909c1 100644
--- a/drivers/scsi/bfa/bfa_cs.h
+++ b/drivers/scsi/bfa/bfa_cs.h
@@ -108,7 +108,7 @@ __bfa_trc32(struct bfa_trc_mod_s *trcm, int fileno, int line, u32 data);
 
 #define bfa_sm_fault(__mod, __event)	do {				\
 	bfa_trc(__mod, (((u32)0xDEAD << 16) | __event));		\
-	printk(KERN_ERR	"Assertion failure: %s:%d: %d",			\
+	dev_err(&(__mod)->bfad->pcidev->dev, "Assertion failure: %s:%d: %d",	\
 		__FILE__, __LINE__, (__event));				\
 } while (0)
 
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index dc518a4678a9..ffcd52177f41 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -272,7 +272,7 @@ bfa_ioc_sm_uninit(struct bfa_ioc_s *ioc, enum ioc_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 /*
@@ -290,7 +290,7 @@ bfa_ioc_sm_reset_entry(struct bfa_ioc_s *ioc)
 static void
 bfa_ioc_sm_reset(struct bfa_ioc_s *ioc, enum ioc_event event)
 {
-	bfa_trc(ioc, event);
+	bfa_trc(ioc->bfa, event);
 
 	switch (event) {
 	case IOC_E_ENABLE:
@@ -306,7 +306,7 @@ bfa_ioc_sm_reset(struct bfa_ioc_s *ioc, enum ioc_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
@@ -358,7 +358,7 @@ bfa_ioc_sm_enabling(struct bfa_ioc_s *ioc, enum ioc_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
@@ -404,7 +404,7 @@ bfa_ioc_sm_getattr(struct bfa_ioc_s *ioc, enum ioc_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
@@ -451,7 +451,7 @@ bfa_ioc_sm_op(struct bfa_ioc_s *ioc, enum ioc_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
@@ -493,7 +493,7 @@ bfa_ioc_sm_disabling(struct bfa_ioc_s *ioc, enum ioc_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
@@ -526,7 +526,7 @@ bfa_ioc_sm_disabled(struct bfa_ioc_s *ioc, enum ioc_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
@@ -579,7 +579,7 @@ bfa_ioc_sm_fail_retry(struct bfa_ioc_s *ioc, enum ioc_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
@@ -620,7 +620,7 @@ bfa_ioc_sm_fail(struct bfa_ioc_s *ioc, enum ioc_event event)
 		 */
 		break;
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
@@ -653,7 +653,7 @@ bfa_ioc_sm_hwfail(struct bfa_ioc_s *ioc, enum ioc_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
@@ -690,7 +690,7 @@ bfa_iocpf_sm_reset(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
@@ -801,7 +801,7 @@ bfa_iocpf_sm_fwcheck(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
@@ -848,7 +848,7 @@ bfa_iocpf_sm_mismatch(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
@@ -893,7 +893,7 @@ bfa_iocpf_sm_semwait(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
@@ -934,7 +934,7 @@ bfa_iocpf_sm_hwinit(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
@@ -985,7 +985,7 @@ bfa_iocpf_sm_enabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
@@ -1016,7 +1016,7 @@ bfa_iocpf_sm_ready(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
@@ -1056,7 +1056,7 @@ bfa_iocpf_sm_disabling(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
@@ -1092,7 +1092,7 @@ bfa_iocpf_sm_disabling_sync(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
@@ -1124,7 +1124,7 @@ bfa_iocpf_sm_disabled(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
@@ -1174,7 +1174,7 @@ bfa_iocpf_sm_initfail_sync(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
@@ -1205,7 +1205,7 @@ bfa_iocpf_sm_initfail(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
@@ -1265,7 +1265,7 @@ bfa_iocpf_sm_fail_sync(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
@@ -1291,7 +1291,7 @@ bfa_iocpf_sm_fail(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 		break;
 
 	default:
-		bfa_sm_fault(ioc, event);
+		bfa_sm_fault(ioc->bfa, event);
 	}
 }
 
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 0e2b81d74692..942f3d9a5627 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -181,7 +181,7 @@ bfad_sm_uninit(struct bfad_s *bfad, enum bfad_sm_event event)
 		break;
 
 	default:
-		bfa_sm_fault(bfad, event);
+		bfa_sm_fault(&bfad->bfa, event);
 	}
 }
 
@@ -256,7 +256,7 @@ bfad_sm_created(struct bfad_s *bfad, enum bfad_sm_event event)
 		break;
 
 	default:
-		bfa_sm_fault(bfad, event);
+		bfa_sm_fault(&bfad->bfa, event);
 	}
 }
 
@@ -295,7 +295,7 @@ bfad_sm_initializing(struct bfad_s *bfad, enum bfad_sm_event event)
 		bfa_sm_set_state(bfad, bfad_sm_failed);
 		break;
 	default:
-		bfa_sm_fault(bfad, event);
+		bfa_sm_fault(&bfad->bfa, event);
 	}
 }
 
@@ -326,7 +326,7 @@ bfad_sm_failed(struct bfad_s *bfad, enum bfad_sm_event event)
 		break;
 
 	default:
-		bfa_sm_fault(bfad, event);
+		bfa_sm_fault(&bfad->bfa, event);
 	}
 }
 
@@ -342,7 +342,7 @@ bfad_sm_operational(struct bfad_s *bfad, enum bfad_sm_event event)
 		break;
 
 	default:
-		bfa_sm_fault(bfad, event);
+		bfa_sm_fault(&bfad->bfa, event);
 	}
 }
 
@@ -358,7 +358,7 @@ bfad_sm_fcs_exit(struct bfad_s *bfad, enum bfad_sm_event event)
 		break;
 
 	default:
-		bfa_sm_fault(bfad, event);
+		bfa_sm_fault(&bfad->bfa, event);
 	}
 }
 
@@ -378,7 +378,7 @@ bfad_sm_stopping(struct bfad_s *bfad, enum bfad_sm_event event)
 		break;
 
 	default:
-		bfa_sm_fault(bfad, event);
+		bfa_sm_fault(&bfad->bfa, event);
 		break;
 	}
 }
-- 
2.16.4

