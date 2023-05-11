Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9655BC7EE23
	for <linux-scsi@archiver.kernel.org>; Thu, 11 May 2023 01:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236905AbjEKBTE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 May 2023 21:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236657AbjEKBTB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2023 21:19:01 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E970559ED;
        Wed, 10 May 2023 18:18:59 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2ad819ab8a9so56061921fa.0;
        Wed, 10 May 2023 18:18:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683767938; x=1686359938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jDdPkH8QvjYDWInkQmGn7iUGK+CdA4f5Z7lWos3SK38=;
        b=lEhdN6kGfqmDrc1dSNy9EOGJjyUWYTF++bFtlihn88UUPM5vHI0avGmfetzPLeZONw
         q4HAZjf1dyt+ywlQvB/DgJDBLf084gk/dw4QZLnfNHCNdHpV6MONrat7bR1nR8yTHRlz
         kfU85rVHCqtLoA4SDl6A7SGJa78kI95KJjzIHrdnm9AEp1KTvdalYuYRYBolNWUOk7OE
         iIhdtO2GP7vRg/0UCIqzAJlPYiLkaKk9F7C/odqIr/+glQ48uzJgpuGpVQoyKoWrn0rc
         Q0Ro43CZIbPyUyvWQqv/QAdtuEzYPTmiaSAymrP3nOB3Jfvn895kF6t6YGtZ/l666dH3
         Y3YA==
X-Gm-Message-State: AC+VfDylDJPrP2g+mRIPzvlaH+GwWMBzaCmQMsVcnOgGeYnUacbIgkbl
        KVu+iEnvIgPL0D54xSdk7iemIUDSc4fEMOzd
X-Google-Smtp-Source: ACHHUZ7fGlX0UHjx7ucjDywJKHWdgNoUK3vb1lC4aJiouSqpyNYf1bw4u+o6/yl3BYpY87Dls1c4vA==
X-Received: by 2002:a2e:8185:0:b0:2ac:85d7:342b with SMTP id e5-20020a2e8185000000b002ac85d7342bmr2559054ljg.29.1683767938093;
        Wed, 10 May 2023 18:18:58 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id d6-20020ac244c6000000b004edc72be17csm915831lfm.2.2023.05.10.18.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 18:18:57 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id C8D4D3B3; Thu, 11 May 2023 03:18:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683767937; bh=1Q5cy9bSmIsrw/cQ/avf+2TZunOglLMkHhpNmSXwJ8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0NngbJqYTHozcKfCB6C66g1HGAD/N44XrK9tWk6oxzr0ncsMty3cfdMPb0JBbO/Z
         shj+eq/KdHq3oBBtMl5LLETPrxMToA3JZGdaWdXk3CNKPGWpXTqOCqdY1mC1cBDJoH
         zeUP/+RNmLHf5tpiJaM2VNZcOylHC6cH0QVsuUrc=
Received: from x1-carbon.. (unknown [64.141.80.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id AE8FA661;
        Thu, 11 May 2023 03:15:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683767706; bh=1Q5cy9bSmIsrw/cQ/avf+2TZunOglLMkHhpNmSXwJ8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BcK/wsORX/nermL5dMcrLlrl+lEsUSVXQxAzNbEECkbFIeKE4Mm/kexneK+N74jIN
         kGvwLDOobyTubumsrtVmzd3ElX/ey2hTXo0cq46ucK7jnbIDPq08x7t5HtUX2qX95l
         DJ5gNTrgJOTKdY5s82eV3WgzsYzsnVe8v/fJvjrg=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v7 06/19] scsi: support retrieving sub-pages of mode pages
Date:   Thu, 11 May 2023 03:13:39 +0200
Message-Id: <20230511011356.227789-7-nks@flawful.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511011356.227789-1-nks@flawful.org>
References: <20230511011356.227789-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <dlemoal@kernel.org>

Allow scsi_mode_sense() to retrieve sub-pages of mode pages by adding
the subpage argument. Change all the current caller sites to specify
the subpage 0.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
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
index 1624d528aa1f..cdcef1b651c1 100644
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
@@ -2609,9 +2609,8 @@ sd_do_mode_sense(struct scsi_disk *sdkp, int dbd, int modepage,
 	if (sdkp->device->use_10_for_ms && len < 8)
 		len = 8;
 
-	return scsi_mode_sense(sdkp->device, dbd, modepage, buffer, len,
-			       SD_TIMEOUT, sdkp->max_retries, data,
-			       sshdr);
+	return scsi_mode_sense(sdkp->device, dbd, modepage, 0, buffer, len,
+			       SD_TIMEOUT, sdkp->max_retries, data, sshdr);
 }
 
 /*
@@ -2868,7 +2867,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 	if (sdkp->protection_type == 0)
 		return;
 
-	res = scsi_mode_sense(sdp, 1, 0x0a, buffer, 36, SD_TIMEOUT,
+	res = scsi_mode_sense(sdp, 1, 0x0a, 0, buffer, 36, SD_TIMEOUT,
 			      sdkp->max_retries, &data, &sshdr);
 
 	if (res < 0 || !data.header_length ||
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 12869e6d4ebd..cd5b08689c1a 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -825,7 +825,7 @@ static int get_capabilities(struct scsi_cd *cd)
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
2.40.1

