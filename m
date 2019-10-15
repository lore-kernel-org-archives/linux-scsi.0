Return-Path: <SRS0=R+5F=YI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D789ECE58C
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 19:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6177D20872
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 19:15:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="g7s4CzNH";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="yAYQpXW4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfJOTPe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Oct 2019 15:15:34 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38936 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726568AbfJOTPd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Oct 2019 15:15:33 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 723258EE0F8;
        Tue, 15 Oct 2019 12:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1571166932;
        bh=ekKBMp3tpyAWg5rfsviy9FuTKahW6ZlqxYecz+Svcjw=;
        h=Subject:From:To:Cc:Date:From;
        b=g7s4CzNHiEzzbwf+fCfcKukaO1siEgKZeu+JrSuGCPGDzJSsu3sXf1oR5tPAMUwW2
         i/EBzH12Io7/FY+rH189xF3clSkMjupGGEnk/96MlEv8ihKVjWJIV5FXr8rN5MLiO1
         88YnBEP236MQ9JjuPvJmSsG94zDwJkOerBapGhZE=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Td6vMj5bSHRi; Tue, 15 Oct 2019 12:15:30 -0700 (PDT)
Received: from [9.232.197.57] (unknown [129.33.253.145])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id BD2CE8EE0CF;
        Tue, 15 Oct 2019 12:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1571166929;
        bh=ekKBMp3tpyAWg5rfsviy9FuTKahW6ZlqxYecz+Svcjw=;
        h=Subject:From:To:Cc:Date:From;
        b=yAYQpXW4oU11SYwoJ/2RxuhGghBh3pYNphmY7KlTKG4yGA3xnYIOBNSGmynWxkT0O
         RKtE02pl40bW4v/aRrmdWeI1aAyneTAoGA0DJI23uYvrfscXRdMocQBxnuYagS81ya
         Zgos+Bh7ywl/KTd02HKdFFtcP0okqTkGWviCvqDY=
Message-ID: <1571166922.15362.19.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.4-rc3
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Tue, 15 Oct 2019 15:15:22 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Five changes, two in drivers (qla2xxx, zfcp), one to MAINTAINERS
(qla2xxx) and two in the core.  The last two are mostly about removing
incorrect messages from the kernel log: the resid message is definitely
wrong and the sync cache on protected drive problem is arguably wrong.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Damien Le Moal (1):
      scsi: core: save/restore command resid for error handling

Daniel Wagner (1):
      scsi: qla2xxx: Remove WARN_ON_ONCE in qla2x00_status_cont_entry()

Himanshu Madhani (1):
      scsi: MAINTAINERS: Update qla2xxx driver

Oliver Neukum (1):
      scsi: sd: Ignore a failure to sync cache due to lack of authorization

Steffen Maier (1):
      scsi: zfcp: fix reaction on bit error threshold notification

And the diffstat:

 MAINTAINERS                    |  2 +-
 drivers/s390/scsi/zfcp_fsf.c   | 16 +++++++++++++---
 drivers/scsi/qla2xxx/qla_isr.c |  2 --
 drivers/scsi/scsi_error.c      |  3 +++
 drivers/scsi/sd.c              |  3 ++-
 include/scsi/scsi_eh.h         |  1 +
 6 files changed, 20 insertions(+), 7 deletions(-)

With full diff below.

James

---

diff --git a/MAINTAINERS b/MAINTAINERS
index 783569e3c4b4..91f33522393a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13184,7 +13184,7 @@ S:	Maintained
 F:	drivers/scsi/qla1280.[ch]
 
 QLOGIC QLA2XXX FC-SCSI DRIVER
-M:	qla2xxx-upstream@qlogic.com
+M:	hmadhani@marvell.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	Documentation/scsi/LICENSE.qla2xxx
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 296bbc3c4606..cf63916814cc 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -27,6 +27,11 @@
 
 struct kmem_cache *zfcp_fsf_qtcb_cache;
 
+static bool ber_stop = true;
+module_param(ber_stop, bool, 0600);
+MODULE_PARM_DESC(ber_stop,
+		 "Shuts down FCP devices for FCP channels that report a bit-error count in excess of its threshold (default on)");
+
 static void zfcp_fsf_request_timeout_handler(struct timer_list *t)
 {
 	struct zfcp_fsf_req *fsf_req = from_timer(fsf_req, t, timer);
@@ -236,10 +241,15 @@ static void zfcp_fsf_status_read_handler(struct zfcp_fsf_req *req)
 	case FSF_STATUS_READ_SENSE_DATA_AVAIL:
 		break;
 	case FSF_STATUS_READ_BIT_ERROR_THRESHOLD:
-		dev_warn(&adapter->ccw_device->dev,
-			 "The error threshold for checksum statistics "
-			 "has been exceeded\n");
 		zfcp_dbf_hba_bit_err("fssrh_3", req);
+		if (ber_stop) {
+			dev_warn(&adapter->ccw_device->dev,
+				 "All paths over this FCP device are disused because of excessive bit errors\n");
+			zfcp_erp_adapter_shutdown(adapter, 0, "fssrh_b");
+		} else {
+			dev_warn(&adapter->ccw_device->dev,
+				 "The error threshold for checksum statistics has been exceeded\n");
+		}
 		break;
 	case FSF_STATUS_READ_LINK_DOWN:
 		zfcp_fsf_status_read_link_down(req);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 4c26630c1c3e..009fd5a33fcd 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2837,8 +2837,6 @@ qla2x00_status_cont_entry(struct rsp_que *rsp, sts_cont_entry_t *pkt)
 	if (sense_len == 0) {
 		rsp->status_srb = NULL;
 		sp->done(sp, cp->result);
-	} else {
-		WARN_ON_ONCE(true);
 	}
 }
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1c470e31ae81..ae2fa170f6ad 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -967,6 +967,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	ses->data_direction = scmd->sc_data_direction;
 	ses->sdb = scmd->sdb;
 	ses->result = scmd->result;
+	ses->resid_len = scmd->req.resid_len;
 	ses->underflow = scmd->underflow;
 	ses->prot_op = scmd->prot_op;
 	ses->eh_eflags = scmd->eh_eflags;
@@ -977,6 +978,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	memset(scmd->cmnd, 0, BLK_MAX_CDB);
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
 	scmd->result = 0;
+	scmd->req.resid_len = 0;
 
 	if (sense_bytes) {
 		scmd->sdb.length = min_t(unsigned, SCSI_SENSE_BUFFERSIZE,
@@ -1029,6 +1031,7 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 	scmd->sc_data_direction = ses->data_direction;
 	scmd->sdb = ses->sdb;
 	scmd->result = ses->result;
+	scmd->req.resid_len = ses->resid_len;
 	scmd->underflow = ses->underflow;
 	scmd->prot_op = ses->prot_op;
 	scmd->eh_eflags = ses->eh_eflags;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 91af598f2f53..0f96eb0ddbfa 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1655,7 +1655,8 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 		/* we need to evaluate the error return  */
 		if (scsi_sense_valid(sshdr) &&
 			(sshdr->asc == 0x3a ||	/* medium not present */
-			 sshdr->asc == 0x20))	/* invalid command */
+			 sshdr->asc == 0x20 ||	/* invalid command */
+			 (sshdr->asc == 0x74 && sshdr->ascq == 0x71)))	/* drive is password locked */
 				/* this is no error here */
 				return 0;
 
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 3810b340551c..6bd5ed695a5e 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -32,6 +32,7 @@ extern int scsi_ioctl_reset(struct scsi_device *, int __user *);
 struct scsi_eh_save {
 	/* saved state */
 	int result;
+	unsigned int resid_len;
 	int eh_eflags;
 	enum dma_data_direction data_direction;
 	unsigned underflow;
