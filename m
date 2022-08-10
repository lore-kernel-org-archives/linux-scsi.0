Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB560C00140
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Aug 2022 18:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbiHJS2N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Aug 2022 14:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiHJS2I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Aug 2022 14:28:08 -0400
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917EC85FB8
        for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2022 11:28:06 -0700 (PDT)
Received: by mail-pg1-f177.google.com with SMTP id f11so15051663pgj.7
        for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2022 11:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=h7JRgUiDRzNhsiyctx72rJg8reBaCRNEJwqXY48CE90=;
        b=hiPd1dDS1a9QOTSE/2ZXChKyOFxAn4O19Vapj1v0kxfut0xhPufOAx/Pigk+oEzUwc
         JWTXcsqcwbSkfleEKAa9il/tg14H1/q1yFQ1R2JzbKX3miSqVNGv2zbsmU1Se+RI1ZH+
         AOFZ1owwljm2W3iK3V5EJoZhp9U7PnaVzz9r+7zVxEyN0Ukrou+grkmNpt4N+M1+ZUH+
         jAzru5dZ0YNM5HO/t+xE8nUut6ie7+6OuuRAIvv3Ee60MNC13TwB/0QU9JrMB+itdfdF
         EWI7WOEps/kJ9fnbGy/4IltacTAr5YF+fG04pLxS0g/SsO9Zjx//o9+j6/VIQfrVLPrl
         37mg==
X-Gm-Message-State: ACgBeo2MyoqU9s9HFbRqbEn3r8nQ6Ieg52jBT1wG/OjbmlryEKntVDjL
        IA1ewP2/YgRg0jON6lQEhJp3Gi/V6A8=
X-Google-Smtp-Source: AA6agR7+x1slN5ulCYFdd42BiRtm05Yh5dH45Ic3vnrvfLMydLOy9fo+2oSIF+m6Qm/3qHP5UvHyeg==
X-Received: by 2002:a65:6a46:0:b0:41b:65fa:b09e with SMTP id o6-20020a656a46000000b0041b65fab09emr24384127pgu.292.1660156085753;
        Wed, 10 Aug 2022 11:28:05 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:85c9:163f:8564:e41f])
        by smtp.gmail.com with ESMTPSA id p3-20020a170902780300b0016d10267927sm13080315pll.203.2022.08.10.11.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 11:28:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Doug Gilbert <dgilbert@interlog.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [sg3_utils 1/3] Change /proc/scsi/sg/allow_dio into /sys/module/sg/parameters/allow_dio
Date:   Wed, 10 Aug 2022 11:27:37 -0700
Message-Id: <20220810182739.756352-2-bvanassche@acm.org>
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
 ChangeLog             | 2 +-
 doc/sg_dd.8           | 6 +++---
 doc/sg_read.8         | 4 ++--
 doc/sgp_dd.8          | 4 ++--
 examples/sgq_dd.c     | 6 +++---
 src/sg_dd.c           | 6 +++---
 src/sg_read.c         | 6 +++---
 src/sgm_dd.c          | 6 +++---
 src/sgp_dd.c          | 6 +++---
 testing/sg_mrq_dd.cpp | 6 +++---
 testing/sg_tst_bidi.c | 2 +-
 testing/sgh_dd.cpp    | 6 +++---
 12 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/ChangeLog b/ChangeLog
index 587a7844f631..54a778a653e4 100644
--- a/ChangeLog
+++ b/ChangeLog
@@ -1811,7 +1811,7 @@ Changelog for sg3_utils-0.96 [20011221]
 Changelog for sg3_utils-0.95 [20010915]
 ----------------------------
   - make sg_dd, sgp_dd and archive/sgq_dd warn if dio selected but
-    /proc/scsi/sg/allow_dio is '0'
+    /sys/module/sg/parameters/allow_dio is '0'
   - sg_map can now do any INQUIRY (when '-i' argument given)
   - expand example in scsi_inquiry
 
diff --git a/doc/sg_dd.8 b/doc/sg_dd.8
index 14290e0740e8..3268de32e738 100644
--- a/doc/sg_dd.8
+++ b/doc/sg_dd.8
@@ -139,7 +139,7 @@ issued and no copy takes place.
 \fBdio\fR={0|1}
 default is 0 which selects indirect (buffered) IO on sg devices. Value of 1
 attempts direct IO which, if not available, falls back to indirect IO and
-notes this at completion. If direct IO is selected and /proc/scsi/sg/allow_dio
+notes this at completion. If direct IO is selected and /sys/module/sg/parameters/allow_dio
 has the value of 0 then a warning is issued (and indirect IO is performed).
 For finer grain control use 'iflag=dio' or 'oflag=dio'.
 .TP
@@ -333,7 +333,7 @@ utility. See note about READ LONG below.
 dio
 request the sg device node associated with this flag does direct IO. If direct
 IO is not available, falls back to indirect IO and notes this at completion.
-If direct IO is selected and /proc/scsi/sg/allow_dio has the value of 0 then a
+If direct IO is selected and /sys/module/sg/parameters/allow_dio has the value of 0 then a
 warning is issued (and indirect IO is performed).
 .TP
 direct
@@ -470,7 +470,7 @@ This is called "indirect IO" and there is a 'dio' option to
 select "direct IO" which will DMA directly into user memory. Due to some
 issues "direct IO" is disabled in the sg driver and needs a
 configuration change to activate it. This is typically done
-with 'echo 1 > /proc/scsi/sg/allow_dio'.
+with 'echo 1 > /sys/module/sg/parameters/allow_dio'.
 .PP
 All informative, warning and error output is sent to stderr so that
 dd's output file can be stdout and remain unpolluted. If no options
diff --git a/doc/sg_read.8 b/doc/sg_read.8
index c12dd57f087f..3f370a62f42d 100644
--- a/doc/sg_read.8
+++ b/doc/sg_read.8
@@ -71,7 +71,7 @@ to be transferred. This option is mandatory.
 default is 0 which selects indirect IO. Value of 1 attempts direct
 IO which, if not available, falls back to indirect IO and notes this
 at completion. This option is only active if \fIIFILE\fR is an sg device.
-If direct IO is selected and /proc/scsi/sg/allow_dio
+If direct IO is selected and /sys/module/sg/parameters/allow_dio
 has the value of 0 then a warning is issued (and indirect IO is performed)
 .TP
 \fBdpo\fR=0 | 1
@@ -140,7 +140,7 @@ This is called "indirect IO" and there is a "dio" option to select
 "direct IO" which will DMA directly into user memory. Due to some
 issues "direct IO" is disabled in the sg driver and needs a
 configuration change to activate it. This is typically done with
-"echo 1 > /proc/scsi/sg/allow_dio". An alternate way to avoid the
+"echo 1 > /sys/module/sg/parameters/allow_dio". An alternate way to avoid the
 2 stage copy is to select memory mapped IO with 'mmap=1'.
 .SH SIGNALS
 The signal handling has been borrowed from dd: SIGINT, SIGQUIT and
diff --git a/doc/sgp_dd.8 b/doc/sgp_dd.8
index 7f6115da5bb4..99afcf30f085 100644
--- a/doc/sgp_dd.8
+++ b/doc/sgp_dd.8
@@ -77,7 +77,7 @@ of debug (max debug output when \fIVERB\fR is 9).
 \fBdio\fR=0 | 1
 default is 0 which selects indirect IO. Value of 1 attempts direct
 IO which, if not available, falls back to indirect IO and notes this
-at completion. If direct IO is selected and /proc/scsi/sg/allow_dio
+at completion. If direct IO is selected and /sys/module/sg/parameters/allow_dio
 has the value of 0 then a warning is issued (and indirect IO is performed)
 For finer grain control use 'iflag=dio' or 'oflag=dio'.
 .TP
@@ -184,7 +184,7 @@ reported to stderr and the copy continues (as if nothing went wrong).
 dio
 request the sg device node associated with this flag does direct IO.
 If direct IO is not available, falls back to indirect IO and notes
-this at completion. If direct IO is selected and /proc/scsi/sg/allow_dio
+this at completion. If direct IO is selected and /sys/module/sg/parameters/allow_dio
 has the value of 0 then a warning is issued (and indirect IO is performed).
 .TP
 direct
diff --git a/examples/sgq_dd.c b/examples/sgq_dd.c
index 2f163ef16ee9..66c52efe25d9 100644
--- a/examples/sgq_dd.c
+++ b/examples/sgq_dd.c
@@ -148,7 +148,7 @@ static struct pollfd in_pollfd_arr[MAX_NUM_THREADS];
 static struct pollfd out_pollfd_arr[MAX_NUM_THREADS];
 static int dd_count = -1;
 
-static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
+static const char * sg_allow_dio = "/sys/module/sg/parameters/allow_dio";
 
 static int sg_finish_io(int wr, Rq_elem * rep);
 
@@ -1214,11 +1214,11 @@ main(int argc, char * argv[])
 
         fprintf(stderr, ">> Direct IO requested but incomplete %d times\n",
                 rcoll.dio_incomplete);
-        if ((fd = open(proc_allow_dio, O_RDONLY)) >= 0) {
+        if ((fd = open(sg_allow_dio, O_RDONLY)) >= 0) {
             if (1 == read(fd, &c, 1)) {
                 if ('0' == c)
                     fprintf(stderr, ">>> %s set to '0' but should be set "
-                            "to '1' for direct IO\n", proc_allow_dio);
+                            "to '1' for direct IO\n", sg_allow_dio);
             }
             close(fd);
         }
diff --git a/src/sg_dd.c b/src/sg_dd.c
index 10ede6fd01da..cba519dc39d4 100644
--- a/src/sg_dd.c
+++ b/src/sg_dd.c
@@ -182,7 +182,7 @@ static long seed;
 static struct drand48_data drand;/* opaque, used by srand48_r and mrand48_r */
 #endif
 
-static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
+static const char * sg_allow_dio = "/sys/module/sg/parameters/allow_dio";
 
 struct flags_t {
     bool append;
@@ -2733,11 +2733,11 @@ bypass_copy:
 
         pr2serr(">> Direct IO requested but incomplete %d times\n",
                 dio_incomplete_count);
-        if ((fd = open(proc_allow_dio, O_RDONLY)) >= 0) {
+        if ((fd = open(sg_allow_dio, O_RDONLY)) >= 0) {
             if (1 == read(fd, &c, 1)) {
                 if ('0' == c)
                     pr2serr(">>> %s set to '0' but should be set to '1' for "
-                            "direct IO\n", proc_allow_dio);
+                            "direct IO\n", sg_allow_dio);
             }
             close(fd);
         }
diff --git a/src/sg_read.c b/src/sg_read.c
index a4f7ceec7a11..0538472f9023 100644
--- a/src/sg_read.c
+++ b/src/sg_read.c
@@ -98,7 +98,7 @@ static int in_partial = 0;
 static int pack_id_count = 0;
 static int verbose = 0;
 
-static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
+static const char * sg_allow_dio = "/sys/module/sg/parameters/allow_dio";
 
 
 static void
@@ -916,11 +916,11 @@ main(int argc, char * argv[])
 
         pr2serr(">> Direct IO requested but incomplete %d times\n",
                 dio_incomplete);
-        if ((fd = open(proc_allow_dio, O_RDONLY)) >= 0) {
+        if ((fd = open(sg_allow_dio, O_RDONLY)) >= 0) {
             if (1 == read(fd, &c, 1)) {
                 if ('0' == c)
                     pr2serr(">>> %s set to '0' but should be set to '1' for "
-                            "direct IO\n", proc_allow_dio);
+                            "direct IO\n", sg_allow_dio);
             }
             close(fd);
         }
diff --git a/src/sgm_dd.c b/src/sgm_dd.c
index aa656b390f6a..57ca1e17cae8 100644
--- a/src/sgm_dd.c
+++ b/src/sgm_dd.c
@@ -126,7 +126,7 @@ static struct timeval start_tm;
 static int blk_sz = 0;
 static uint32_t glob_pack_id = 0;       /* pre-increment */
 
-static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
+static const char * sg_allow_dio = "/sys/module/sg/parameters/allow_dio";
 
 struct flags_t {
     bool append;
@@ -1286,11 +1286,11 @@ main(int argc, char * argv[])
         int fd;
         char c;
 
-        if ((fd = open(proc_allow_dio, O_RDONLY)) >= 0) {
+        if ((fd = open(sg_allow_dio, O_RDONLY)) >= 0) {
             if (1 == read(fd, &c, 1)) {
                 if ('0' == c)
                     pr2serr(">>> %s set to '0' but should be set to '1' for "
-                            "direct IO\n", proc_allow_dio);
+                            "direct IO\n", sg_allow_dio);
             }
             close(fd);
         }
diff --git a/src/sgp_dd.c b/src/sgp_dd.c
index a36d9d03a96d..7f69406beec4 100644
--- a/src/sgp_dd.c
+++ b/src/sgp_dd.c
@@ -214,7 +214,7 @@ typedef struct request_element
 static sigset_t signal_set;
 static pthread_t sig_listen_thread_id;
 
-static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
+static const char * sg_allow_dio = "/sys/module/sg/parameters/allow_dio";
 
 static void sg_in_operation(struct opts_t * clp, Rq_elem * rep);
 static void sg_out_operation(struct opts_t * clp, Rq_elem * rep,
@@ -1991,11 +1991,11 @@ fini:
 
         pr2serr(">> Direct IO requested but incomplete %d times\n",
                 clp->dio_incomplete_count);
-        if ((fd = open(proc_allow_dio, O_RDONLY)) >= 0) {
+        if ((fd = open(sg_allow_dio, O_RDONLY)) >= 0) {
             if (1 == read(fd, &c, 1)) {
                 if ('0' == c)
                     pr2serr(">>> %s set to '0' but should be set to '1' for "
-                            "direct IO\n", proc_allow_dio);
+                            "direct IO\n", sg_allow_dio);
             }
             close(fd);
         }
diff --git a/testing/sg_mrq_dd.cpp b/testing/sg_mrq_dd.cpp
index 9f17146c31c6..dc50ad21b8cf 100644
--- a/testing/sg_mrq_dd.cpp
+++ b/testing/sg_mrq_dd.cpp
@@ -396,7 +396,7 @@ static atomic<bool> vb_first_time(true);
 static sigset_t signal_set;
 static sigset_t orig_signal_set;
 
-static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
+static const char * sg_allow_dio = "/sys/module/sg/parameters/allow_dio";
 
 static int do_both_sg_segment(Rq_elem * rep, scat_gath_iter & i_sg_it,
                               scat_gath_iter & o_sg_it, int seg_blks,
@@ -4614,11 +4614,11 @@ fini:
 
         pr2serr(">> Direct IO requested but incomplete %d times\n",
                 clp->dio_incomplete_count.load());
-        if ((fd = open(proc_allow_dio, O_RDONLY)) >= 0) {
+        if ((fd = open(sg_allow_dio, O_RDONLY)) >= 0) {
             if (1 == read(fd, &c, 1)) {
                 if ('0' == c)
                     pr2serr(">>> %s set to '0' but should be set to '1' for "
-                            "direct IO\n", proc_allow_dio);
+                            "direct IO\n", sg_allow_dio);
             }
             close(fd);
         }
diff --git a/testing/sg_tst_bidi.c b/testing/sg_tst_bidi.c
index 6865e9a9245f..981a64fb9303 100644
--- a/testing/sg_tst_bidi.c
+++ b/testing/sg_tst_bidi.c
@@ -585,7 +585,7 @@ rep_async:
     }
     if (direct_io && (dirio_count < q_len)) {
         pr2serr("Direct IO requested %d times, done %d times\nMaybe need "
-                "'echo 1 > /proc/scsi/sg/allow_dio'\n", q_len, dirio_count);
+                "'echo 1 > /sys/module/sg/parameters/allow_dio'\n", q_len, dirio_count);
     }
     if (rep_count-- > 0)
         goto rep_async;
diff --git a/testing/sgh_dd.cpp b/testing/sgh_dd.cpp
index 2c1f24336595..e329f6bc52f7 100644
--- a/testing/sgh_dd.cpp
+++ b/testing/sgh_dd.cpp
@@ -387,7 +387,7 @@ static sigset_t signal_set;
 static sigset_t orig_signal_set;
 static pthread_t sig_listen_thread_id;
 
-static const char * proc_allow_dio = "/proc/scsi/sg/allow_dio";
+static const char * sg_allow_dio = "/sys/module/sg/parameters/allow_dio";
 
 static void sg_in_rd_cmd(struct global_collection * clp, Rq_elem * rep,
                          mrq_arr_t & def_arr);
@@ -5040,11 +5040,11 @@ fini:
 
         pr2serr(">> Direct IO requested but incomplete %d times\n",
                 clp->dio_incomplete_count.load());
-        if ((fd = open(proc_allow_dio, O_RDONLY)) >= 0) {
+        if ((fd = open(sg_allow_dio, O_RDONLY)) >= 0) {
             if (1 == read(fd, &c, 1)) {
                 if ('0' == c)
                     pr2serr(">>> %s set to '0' but should be set to '1' for "
-                            "direct IO\n", proc_allow_dio);
+                            "direct IO\n", sg_allow_dio);
             }
             close(fd);
         }
