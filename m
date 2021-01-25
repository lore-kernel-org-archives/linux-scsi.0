Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660C0C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 20:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BE262067B
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 20:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732250AbhAYU1r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jan 2021 15:27:47 -0500
Received: from smtp.infotech.no ([82.134.31.41]:48964 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732219AbhAYU1n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Jan 2021 15:27:43 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 4945A204258;
        Mon, 25 Jan 2021 21:26:57 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3NRcu0YoN8m9; Mon, 25 Jan 2021 21:26:54 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        by smtp.infotech.no (Postfix) with ESMTPA id 7BD9920418D;
        Mon, 25 Jan 2021 21:26:52 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org, axboe@kernel.dk,
        linux-block@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        kashyap.desai@broadcom.com
Subject: [PATCH v2] fio: add hipri option to sg engine
Date:   Mon, 25 Jan 2021 15:26:51 -0500
Message-Id: <20210125202651.346783-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Adds hipri option to the Linux sg driver engine. This turns on the
SGV4_FLAG_HIPRI flag in recent sg drivers (January 2021) on READ
and WRITE commands (and not on UNMAP (trim), VERIFY, etc). Uses
blk_poll() and the mq_poll() callback in SCSI LLDs. The mechanism
is also called "iopoll".

The Linux sg engine in fio uses the struct sg_io_hdr based interface
known as the sg driver "v3" interface.
Linux sg drivers in the kernel prior to January 2021 (sg version
4.0.12) will just ignore the SGV4_FLAG_HIPRI flag and do normal
completions where LLDs indicate command completion with a (software)
interrupt or similar mechanism.

Update fio.1 (manpage) with new hipri sg engine option.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 engines/sg.c | 22 +++++++++++++++++++++-
 fio.1        | 10 ++++++++++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/engines/sg.c b/engines/sg.c
index a1a6de4c..0c2d2c8b 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -60,6 +60,10 @@
 
 #ifdef FIO_HAVE_SGIO
 
+#ifndef SGV4_FLAG_HIPRI
+#define SGV4_FLAG_HIPRI 0x800
+#endif
+
 enum {
 	FIO_SG_WRITE		= 1,
 	FIO_SG_WRITE_VERIFY	= 2,
@@ -68,12 +72,22 @@ enum {
 
 struct sg_options {
 	void *pad;
+	unsigned int hipri;
 	unsigned int readfua;
 	unsigned int writefua;
 	unsigned int write_mode;
 };
 
 static struct fio_option options[] = {
+        {
+                .name   = "hipri",
+                .lname  = "High Priority",
+                .type   = FIO_OPT_STR_SET,
+                .off1   = offsetof(struct sg_options, hipri),
+                .help   = "Use polled IO completions",
+                .category = FIO_OPT_C_ENGINE,
+                .group  = FIO_OPT_G_SG,
+        },
 	{
 		.name	= "readfua",
 		.lname	= "sg engine read fua flag support",
@@ -527,6 +541,8 @@ static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 		else
 			hdr->cmdp[0] = 0x88; // read(16)
 
+		if (o->hipri)
+			hdr->flags |= SGV4_FLAG_HIPRI;
 		if (o->readfua)
 			hdr->cmdp[1] |= 0x08;
 
@@ -542,6 +558,8 @@ static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 				hdr->cmdp[0] = 0x2a; // write(10)
 			else
 				hdr->cmdp[0] = 0x8a; // write(16)
+			if (o->hipri)
+				hdr->flags |= SGV4_FLAG_HIPRI;
 			if (o->writefua)
 				hdr->cmdp[1] |= 0x08;
 			break;
@@ -865,6 +883,7 @@ static int fio_sgio_init(struct thread_data *td)
 {
 	struct sgio_data *sd;
 	struct sgio_trim *st;
+	struct sg_io_hdr *h3p;
 	int i;
 
 	sd = calloc(1, sizeof(*sd));
@@ -880,12 +899,13 @@ static int fio_sgio_init(struct thread_data *td)
 #ifdef FIO_SGIO_DEBUG
 	sd->trim_queue_map = calloc(td->o.iodepth, sizeof(int));
 #endif
-	for (i = 0; i < td->o.iodepth; i++) {
+	for (i = 0, h3p = sd->sgbuf; i < td->o.iodepth; i++, ++h3p) {
 		sd->trim_queues[i] = calloc(1, sizeof(struct sgio_trim));
 		st = sd->trim_queues[i];
 		st->unmap_param = calloc(td->o.iodepth + 1, sizeof(char[16]));
 		st->unmap_range_count = 0;
 		st->trim_io_us = calloc(td->o.iodepth, sizeof(struct io_u *));
+		h3p->interface_id = 'S';
 	}
 
 	td->io_ops_data = sd;
diff --git a/fio.1 b/fio.1
index d477b508..9636a85f 100644
--- a/fio.1
+++ b/fio.1
@@ -2114,6 +2114,16 @@ client and the server or in certain loopback configurations.
 Specify stat system call type to measure lookup/getattr performance.
 Default is \fBstat\fR for \fBstat\fR\|(2).
 .TP
+.BI (sg)hipri
+If this option is set, fio will attempt to use polled IO completions. This
+will have a similar effect as (io_uring)hipri. Only SCSI READ and WRITE
+commands will have the SGV4_FLAG_HIPRI set (not UNMAP (trim) nor VERIFY).
+Older versions of the Linux sg driver that do not support hipri will simply
+ignore this flag and do normal IO. The Linux SCSI Low Level Driver (LLD)
+that "owns" the device also needs to support hipri (also known as iopoll
+and mq_poll). The MegaRAID driver is an example of a SCSI LLD.
+Default: clear (0) which does normal (interrupted based) IO.
+.TP
 .BI (sg)readfua \fR=\fPbool
 With readfua option set to 1, read operations include the force
 unit access (fua) flag. Default: 0.
-- 
2.25.1

