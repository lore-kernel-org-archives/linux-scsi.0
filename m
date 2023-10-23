Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A195DCDB474
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 09:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbjJWJ2w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 05:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjJWJ2s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 05:28:48 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F4AF7
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 02:28:45 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 7C5F021ACF;
        Mon, 23 Oct 2023 09:28:43 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id D800C2CF5A;
        Mon, 23 Oct 2023 09:28:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 14E3551EC354; Mon, 23 Oct 2023 11:28:43 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Benjamin Block <bblock@linux.ibm.com>
Subject: [PATCH 09/10] scsi_error: map FAST_IO_FAIL to -EAGAIN in SCSI EH
Date:   Mon, 23 Oct 2023 11:28:36 +0200
Message-Id: <20231023092837.33786-10-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231023092837.33786-1-hare@suse.de>
References: <20231023092837.33786-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++
Authentication-Results: smtp-out1.suse.de;
        dkim=none;
        dmarc=none;
        spf=softfail (smtp-out1.suse.de: 149.44.160.134 is neither permitted nor denied by domain of hare@suse.de) smtp.mailfrom=hare@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [5.49 / 50.00];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.20)[suse.de];
         BROKEN_CONTENT_TYPE(1.50)[];
         R_SPF_SOFTFAIL(0.60)[~all:c];
         RCPT_COUNT_FIVE(0.00)[6];
         TO_MATCH_ENVRCPT_SOME(0.00)[];
         VIOLATED_DIRECT_SPF(3.50)[];
         MX_GOOD(-0.01)[];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         MID_CONTAINS_FROM(1.00)[];
         RWL_MAILSPIKE_GOOD(0.00)[149.44.160.134:from];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         R_DKIM_NA(0.20)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         BAYES_HAM(-0.00)[11.35%]
X-Rspamd-Queue-Id: 7C5F021ACF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Returning FAST_IO_FAIL from any of the SCSI EH functions is perfectly
valid, and indicates that the request could not be executed due to
the transport being busy.
But that is not an I/O error, and we should return -EAGAIN from
scsi_ioctl_reset() to correctly inform userspace.

Suggested-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 7c655d08a305..8e184d92abe9 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2453,22 +2453,25 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 		break;
 	case SG_SCSI_RESET_DEVICE:
 		rtn = scsi_try_bus_device_reset(dev);
-		if (rtn == SUCCESS || (val & SG_SCSI_RESET_NO_ESCALATE))
+		if (rtn == SUCCESS || rtn == FAST_IO_FAIL ||
+		    (val & SG_SCSI_RESET_NO_ESCALATE))
 			break;
 		fallthrough;
 	case SG_SCSI_RESET_TARGET:
 		rtn = scsi_try_target_reset(shost, starget);
-		if (rtn == SUCCESS || (val & SG_SCSI_RESET_NO_ESCALATE))
+		if (rtn == SUCCESS || rtn == FAST_IO_FAIL ||
+		    (val & SG_SCSI_RESET_NO_ESCALATE))
 			break;
 		fallthrough;
 	case SG_SCSI_RESET_BUS:
 		rtn = scsi_try_bus_reset(shost, dev->channel);
-		if (rtn == SUCCESS || (val & SG_SCSI_RESET_NO_ESCALATE))
+		if (rtn == SUCCESS || rtn == FAST_IO_FAIL ||
+		    (val & SG_SCSI_RESET_NO_ESCALATE))
 			break;
 		fallthrough;
 	case SG_SCSI_RESET_HOST:
 		rtn = scsi_try_host_reset(shost);
-		if (rtn == SUCCESS)
+		if (rtn == SUCCESS || rtn == FAST_IO_FAIL)
 			break;
 		fallthrough;
 	default:
@@ -2476,7 +2479,17 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 		break;
 	}
 
-	error = (rtn == SUCCESS) ? 0 : -EIO;
+	switch (rtn) {
+	case SUCCESS:
+		error = 0;
+		break;
+	case FAST_IO_FAIL:
+		error = -EAGAIN;
+		break;
+	default:
+		error = -EIO;
+		break;
+	}
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->tmf_in_progress = 0;
-- 
2.35.3

