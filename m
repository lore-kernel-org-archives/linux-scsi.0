Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBEE9C00140
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Aug 2022 18:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbiHJS2U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Aug 2022 14:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbiHJS2J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Aug 2022 14:28:09 -0400
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B442D86C0D
        for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2022 11:28:08 -0700 (PDT)
Received: by mail-pl1-f180.google.com with SMTP id 13so13528853plo.12
        for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2022 11:28:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=kmheWdpd3i4Ml/tZ1AljZtyFoUeRDJWabI9ibZwfLNE=;
        b=lHJ/Pf0rcM+Mr4yRC9WwFtcjqMMBG3Il6eAtY9SdpHCUgicrlXP93guIpnZKg1QUOk
         25L+gK9uDpauzz+2LkjeEx+v+3VZ61skva61aEWbNb5ayZEH7oH2HTbvR5iHEyK+rGLL
         7DBPlLPajZBRKERp/zUIKlXx/KiCGcXO9a11+LieS4NBrX1AKikKbxnCEJQ/qAAnRWL1
         NlpLzorZckg4kwPJ67iF7NVGanR1WwArGsi02mCJyqzS9y2Nu1tfohsmD+aTfnBaMgAu
         cV2mP2vM4u3iAzDZWtfBZv7JuDYbySRdUra/3aIXYUautVS/BD9LCjFldP5EoNoa1Aen
         C8pg==
X-Gm-Message-State: ACgBeo0bgyY2Y86eI0ceCXydT1uNoaJpDZFKknqrg/BUbOj8mEIIxIJv
        ZmBnxlm/QYMm1gNSKFMMc50=
X-Google-Smtp-Source: AA6agR4J+AmjsV0UyN07n8XbG0Sa9aWe/pLUNvUKcRetuZ0ykRYkm8ktTmdC+QAQZT3JAQ/LDBaj1g==
X-Received: by 2002:a17:902:f649:b0:16d:22fd:5c14 with SMTP id m9-20020a170902f64900b0016d22fd5c14mr29542793plg.98.1660156087356;
        Wed, 10 Aug 2022 11:28:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:85c9:163f:8564:e41f])
        by smtp.gmail.com with ESMTPSA id p3-20020a170902780300b0016d10267927sm13080315pll.203.2022.08.10.11.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 11:28:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Doug Gilbert <dgilbert@interlog.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [sg3_utils 2/3] Replace the references to /proc/scsi/sg/debug
Date:   Wed, 10 Aug 2022 11:27:38 -0700
Message-Id: <20220810182739.756352-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
In-Reply-To: <20220810182739.756352-1-bvanassche@acm.org>
References: <20220810182739.756352-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for the removal of /proc/scsi from the Linux kernel by removing the
references to /proc/scsi.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 testing/sg_mrq_dd.cpp | 12 ++++++------
 testing/sgh_dd.cpp    | 12 ++++++------
 testing/uapi_sg.h     |  4 ++--
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/testing/sg_mrq_dd.cpp b/testing/sg_mrq_dd.cpp
index dc50ad21b8cf..40de12316b6d 100644
--- a/testing/sg_mrq_dd.cpp
+++ b/testing/sg_mrq_dd.cpp
@@ -632,12 +632,12 @@ page4:
             "each issued\nSCSI command. When both IFILE and OFILE are sg "
             "devices, then the READ in\neach read-write pair is issued an "
             "even pack_id and its WRITE pair is\ngiven the pack_id one "
-            "higher (i.e. an odd number). This enables a\n'cat '"
-            "/proc/scsi/sg/debug' user to see that progress is being "
+            "higher (i.e. an odd number). This enables a\n'dmesg -w' "
+            "user to see that progress is being "
             "made.\n\n");
     pr2serr("Debugging:\n"
             "Apart from using one or more '--verbose' options which gets a "
-            "bit noisy\n'cat /proc/scsi/sg/debug' can give a good overview "
+            "bit noisy\n'dmesg -w' can give a good overview "
             "of what is happening.\nThat does a sg driver object tree "
             "traversal that does minimal locking\nto make sure that each "
             "traversal is 'safe'. So it is important to note\nthe whole "
@@ -650,7 +650,7 @@ page4:
             "request entered it while some other nodes were being "
             "printed.\n\n");
     pr2serr("Busy state:\n"
-            "Busy state (abbreviated to 'bsy' in the /proc/scsi/sg/debug "
+            "Busy state (abbreviated to 'bsy' in the dmesg "
             "output)\nis entered during request setup and completion. It "
             "is intended to be\na temporary state. It should not block "
             "but does sometimes (e.g. in\nblock_get_request()). Even so "
@@ -1255,7 +1255,7 @@ bypass:
     }
     if (clp->verbose) {
         t = 1;
-        /* more info in /proc/scsi/sg/debug */
+        /* more info in the kernel log */
         res = ioctl(fd, SG_SET_DEBUG, &t);
         if (res < 0)
             perror("sg_mrq_dd: SG_SET_DEBUG error");
@@ -1507,7 +1507,7 @@ sig_listen_thread(struct global_collection * clp)
                     } else
                         pr2serr_lk("%s: subsequent stall at pack_id=%d\n",
                                    __func__, pack_id);
-                    system_wrapper("/usr/bin/cat /proc/scsi/sg/debug\n");
+                    system_wrapper("/usr/bin/dmesg\n");
                 } else
                     prev_pack_id = pack_id;
             } else if (EAGAIN != err)
diff --git a/testing/sgh_dd.cpp b/testing/sgh_dd.cpp
index e329f6bc52f7..5482b0c39dc8 100644
--- a/testing/sgh_dd.cpp
+++ b/testing/sgh_dd.cpp
@@ -660,12 +660,12 @@ page4:
             "each issued\nSCSI command. When both IFILE and OFILE are sg "
             "devices, then the READ in\neach read-write pair is issued an "
             "even pack_id and its WRITE pair is\ngiven the pack_id one "
-            "higher (i.e. an odd number). This enables a\n'cat '"
-            "/proc/scsi/sg/debug' user to see that progress is being "
+            "higher (i.e. an odd number). This enables a\n'dmesg -w' "
+            "user to see that progress is being "
             "made.\n\n");
     pr2serr("Debugging:\n"
             "Apart from using one or more '--verbose' options which gets a "
-            "bit noisy\n'cat /proc/scsi/sg/debug' can give a good overview "
+            "bit noisy\n'dmesg -w' can give a good overview "
             "of what is happening.\nThat does a sg driver object tree "
             "traversal that does minimal locking\nto make sure that each "
             "traversal is 'safe'. So it is important to note\nthe whole "
@@ -678,7 +678,7 @@ page4:
             "request entered it while some other nodes were being "
             "printed.\n\n");
     pr2serr("Busy state:\n"
-            "Busy state (abbreviated to 'bsy' in the /proc/scsi/sg/debug "
+            "Busy state (abbreviated to 'bsy' in the dmesg "
             "output)\nis entered during request setup and completion. It "
             "is intended to be\na temporary state. It should not block "
             "but does sometimes (e.g. in\nblock_get_request()). Even so "
@@ -1258,7 +1258,7 @@ sig_listen_thread(void * v_clp)
                     } else
                         pr2serr_lk("%s: subsequent stall at pack_id=%d\n",
                                __func__, pack_id);
-                    system_wrapper("/usr/bin/cat /proc/scsi/sg/debug\n");
+                    system_wrapper("/usr/bin/dmesg\n");
                 } else
                     prev_pack_id = pack_id;
             } else if (EAGAIN != err)
@@ -3752,7 +3752,7 @@ bypass:
         }
     }
     t = 1;
-    res = ioctl(fd, SG_SET_DEBUG, &t);  /* more info in /proc/scsi/sg/debug */
+    res = ioctl(fd, SG_SET_DEBUG, &t);  /* more info in the kernel log */
     if (res < 0)
         perror("sgs_dd: SG_SET_DEBUG error");
     return (res < 0) ? 0 : num;
diff --git a/testing/uapi_sg.h b/testing/uapi_sg.h
index 270ad4689ea7..9cc51dc00654 100644
--- a/testing/uapi_sg.h
+++ b/testing/uapi_sg.h
@@ -442,8 +442,8 @@ struct sg_header {
 #define SG_SET_COMMAND_Q 0x2271   /* Change queuing state with 0 or 1 */
 
 /*
- * Turn on/off error sense trace (1 and 0 respectively, default is off).
- * Try using: "# cat /proc/scsi/sg/debug" instead in the v3 driver
+ * Turn on/off error sense trace in the kernel log (1 and 0 respectively, default is
+ * off).
  */
 #define SG_SET_DEBUG 0x227e    /* 0 -> turn off debug */
 
