Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D9DC77B70
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Apr 2023 18:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbjDDScz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236447AbjDDSci (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2023 14:32:38 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E72C72A0;
        Tue,  4 Apr 2023 11:30:02 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id br6so43478782lfb.11;
        Tue, 04 Apr 2023 11:30:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680633000;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JFCch4ACvmYufrbxJsh01vJ15Xj4AhHZaLEgl+aiNvg=;
        b=ZGP2RdMqD9SafTq47wnzCh/6E0/9fGmop/ft/Or0P6a+1ZAKrP/qshYxO7VhlAfsjL
         6GsDyfaxmNLsJUcbj3WigyXLjQSrZ+F+WeWeHkKYrwraX7DmNDFp/vTtaHS4lpcJW0mh
         OfEpK+ChXyi+F6Oh6+CjHPMawOUj0vVCbW4pFRQjafdP4CGH0pdB2iEGjBY2sjLnLPmS
         oQkE2axbBcekTyy5y4j9HQc/+muNrxUCVrimtFBYzA4X1uLGHxwxnJL6z8BEjDrcNDyV
         U3ZhR1VjWqtsNuoRhErywiU3HwiW8HKlNm/klhpjLdqO17O3vATDYQNdzUVVlNVYtoeI
         tCRA==
X-Gm-Message-State: AAQBX9fCzBpMl7GCt+0xRKWQ1ozCycvQub6SYGdiZ1JvCrJ2fRP8XbOR
        62xUq0s28T1rbxD9irbvQDxFX5gOPnLiLQ==
X-Google-Smtp-Source: AKy350Yuz1SlaiR7jXSMDCXYzjj+8yo+V8Jwe94gxYFQogPiw7CD6tJdmeKZYHGxLZLXGMTv4srCwA==
X-Received: by 2002:a19:a40a:0:b0:4db:1bab:98a4 with SMTP id q10-20020a19a40a000000b004db1bab98a4mr923703lfc.32.1680633000100;
        Tue, 04 Apr 2023 11:30:00 -0700 (PDT)
Received: from flawful.org (c-a3f5e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.245.163])
        by smtp.gmail.com with ESMTPSA id w9-20020ac25d49000000b004dbebb3a6fasm2431063lfd.175.2023.04.04.11.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 11:29:59 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id EFA8A865; Tue,  4 Apr 2023 20:29:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680632999; bh=W4z5eI6b9aTx+DVYBLNhhpezti3ssBlCzK7GNiWkMHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WJv659qk5zmLbykHSD/05RaQ/XxTx+mtsPhqCB1FWP6oVXfVCGIvlut5c6r/IG22n
         B3gAN+3iOd/biuq9fqo/HzV44f0rUFuNoWaACFjqUvmUGjFPegSfCGNkEUy70isoeY
         YKvUIja9OyNJYY0oh48W9gC9tdW9zeYIHXCf/CeM=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 6E723A5D;
        Tue,  4 Apr 2023 20:25:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680632738; bh=W4z5eI6b9aTx+DVYBLNhhpezti3ssBlCzK7GNiWkMHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QEUazBCeaIyFPZIj3bL3kv52nYlziUAxrfv9mU+Hjq0EPlUjBi6YtIPuQhfvQ/Pq5
         OpOp9M06ZtBEQQ2wuO2uccj4lZx7Hu4263AmBrFJbldDu4oskBkDeaKyIHCuk/QeuR
         jrqFpRBUl1CaZryEL7um82Vi3DXd4O/MOBhu/7y8=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v5 06/19] scsi: support retrieving sub-pages of mode pages
Date:   Tue,  4 Apr 2023 20:24:11 +0200
Message-Id: <20230404182428.715140-7-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404182428.715140-1-nks@flawful.org>
References: <20230404182428.715140-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Allow scsi_mode_sense() to retrieve sub-pages of mode pages by adding
the subpage argument. Change all the current caller sites to specify
the subpage 0.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c           | 4 +++-
 drivers/scsi/scsi_transport_sas.c | 2 +-
 drivers/scsi/sd.c                 | 9 ++++-----
 drivers/scsi/sr.c                 | 2 +-
 include/scsi/scsi_device.h        | 8 ++++----
 5 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fac9c31161d2..633c4e8af830 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2144,6 +2144,7 @@ EXPORT_SYMBOL_GPL(scsi_mode_select);
  *	@sdev:	SCSI device to be queried
  *	@dbd:	set to prevent mode sense from returning block descriptors
  *	@modepage: mode page being requested
+ *	@subpage: sub-page of the mode page being requested
  *	@buffer: request buffer (may not be smaller than eight bytes)
  *	@len:	length of request buffer.
  *	@timeout: command timeout
@@ -2155,7 +2156,7 @@ EXPORT_SYMBOL_GPL(scsi_mode_select);
  *	Returns zero if successful, or a negative error number on failure
  */
 int
-scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
+scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage, int subpage,
 		  unsigned char *buffer, int len, int timeout, int retries,
 		  struct scsi_mode_data *data, struct scsi_sense_hdr *sshdr)
 {
@@ -2175,6 +2176,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	dbd = sdev->set_dbd_for_ms ? 8 : dbd;
 	cmd[1] = dbd & 0x18;	/* allows DBD and LLBA bits */
 	cmd[2] = modepage;
+	cmd[3] = subpage;
 
 	sshdr = exec_args.sshdr;
 
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 74b99f2b0b74..d704c484a251 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1245,7 +1245,7 @@ int sas_read_port_mode_page(struct scsi_device *sdev)
 	if (!buffer)
 		return -ENOMEM;
 
-	error = scsi_mode_sense(sdev, 1, 0x19, buffer, BUF_SIZE, 30*HZ, 3,
+	error = scsi_mode_sense(sdev, 1, 0x19, 0, buffer, BUF_SIZE, 30*HZ, 3,
 				&mode_data, NULL);
 
 	if (error)
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4bb87043e6db..2de4b27cedc5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -183,7 +183,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 		return count;
 	}
 
-	if (scsi_mode_sense(sdp, 0x08, 8, buffer, sizeof(buffer), SD_TIMEOUT,
+	if (scsi_mode_sense(sdp, 0x08, 8, 0, buffer, sizeof(buffer), SD_TIMEOUT,
 			    sdkp->max_retries, &data, NULL))
 		return -EINVAL;
 	len = min_t(size_t, sizeof(buffer), data.length - data.header_length -
@@ -2610,9 +2610,8 @@ sd_do_mode_sense(struct scsi_disk *sdkp, int dbd, int modepage,
 	if (sdkp->device->use_10_for_ms && len < 8)
 		len = 8;
 
-	return scsi_mode_sense(sdkp->device, dbd, modepage, buffer, len,
-			       SD_TIMEOUT, sdkp->max_retries, data,
-			       sshdr);
+	return scsi_mode_sense(sdkp->device, dbd, modepage, 0, buffer, len,
+			       SD_TIMEOUT, sdkp->max_retries, data, sshdr);
 }
 
 /*
@@ -2869,7 +2868,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 	if (sdkp->protection_type == 0)
 		return;
 
-	res = scsi_mode_sense(sdp, 1, 0x0a, buffer, 36, SD_TIMEOUT,
+	res = scsi_mode_sense(sdp, 1, 0x0a, 0, buffer, 36, SD_TIMEOUT,
 			      sdkp->max_retries, &data, &sshdr);
 
 	if (res < 0 || !data.header_length ||
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 9e51dcd30bfd..09fdb0e269d9 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -830,7 +830,7 @@ static int get_capabilities(struct scsi_cd *cd)
 	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
 
 	/* ask for mode page 0x2a */
-	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, ms_len,
+	rc = scsi_mode_sense(cd->device, 0, 0x2a, 0, buffer, ms_len,
 			     SR_TIMEOUT, 3, &data, NULL);
 
 	if (rc < 0 || data.length > ms_len ||
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f10a008e5bfa..c146cc807d44 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -421,10 +421,10 @@ extern int scsi_track_queue_full(struct scsi_device *, int);
 
 extern int scsi_set_medium_removal(struct scsi_device *, char);
 
-extern int scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
-			   unsigned char *buffer, int len, int timeout,
-			   int retries, struct scsi_mode_data *data,
-			   struct scsi_sense_hdr *);
+int scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
+		    int subpage, unsigned char *buffer, int len, int timeout,
+		    int retries, struct scsi_mode_data *data,
+		    struct scsi_sense_hdr *);
 extern int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
 			    unsigned char *buffer, int len, int timeout,
 			    int retries, struct scsi_mode_data *data,
-- 
2.39.2

