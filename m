Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB838C761A6
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Apr 2023 11:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238664AbjDFLnd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Apr 2023 07:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238661AbjDFLnQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2023 07:43:16 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94557BDEB;
        Thu,  6 Apr 2023 04:38:58 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id t14so40405042ljd.5;
        Thu, 06 Apr 2023 04:38:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680781064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JFCch4ACvmYufrbxJsh01vJ15Xj4AhHZaLEgl+aiNvg=;
        b=P9PpSenmEdL5snjU1YqS2z7F5snwolLJEyLLkzfLeupEKJvXVm4JDq/pDcQ8ijNX8a
         AFFl1iRDcYHLJ/YJF/gCGx0aWs9frHyHVdxpqwTo0UmbCd7jWcdDmnhHSpMKR18dCctr
         IDw0qhZSqEiwlO1hwfZsJj9I5fBB/B8oNrQneFQGa5At8Gdr5Eo2/8xN1vLQm09C+s2S
         RQZDPOvlB6US7cmltqDVvvaGiRBruF7sfnpdQ971P7ya9wJM22bEJXZ6HdbJPF4b7o+3
         771S2Ql/d5PaQwICdRjap7L+yvlExw/3Tl8XHFpvS7uycNtGqfg/bkWGKIGY8+4vCGej
         hESw==
X-Gm-Message-State: AAQBX9cPH4HQLwlrbkGOe4iPECI65oyoYONZPRzdwyM8cjsLsr8afzE2
        xP4oh+0K77fCTV7+b4Xvn7Njgc4yQkttPA==
X-Google-Smtp-Source: AKy350aalDteLKmn/Iv+83alinZbhWA6sVOdYjaPwNBdVU8uvJxBYnHXOeHuwiOj4ZMKyZPhWZH7pA==
X-Received: by 2002:a2e:8016:0:b0:2a6:15c7:1926 with SMTP id j22-20020a2e8016000000b002a615c71926mr2876729ljg.3.1680781063986;
        Thu, 06 Apr 2023 04:37:43 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id l10-20020a2e868a000000b00295a33eda65sm250120lji.137.2023.04.06.04.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 04:37:43 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id DB85167E; Thu,  6 Apr 2023 13:37:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680781063; bh=W4z5eI6b9aTx+DVYBLNhhpezti3ssBlCzK7GNiWkMHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZTu4likdDhO7MPUREMsXkUombUYI7swr01tj7qrOr3jGInwruM6K/yJuO2SWmkT/
         FBjvRHMZoBievTAMIe6EhGhSTfiJL+hfmGLI2MRBFYnBRg/s3R4Er8A8/kX+VJ/6uQ
         cvrcj4xZmN+v9fJFY5Z0Ul6P5ViOJCB4rLQxgm8Y=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 487D289C;
        Thu,  6 Apr 2023 13:33:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680780790; bh=W4z5eI6b9aTx+DVYBLNhhpezti3ssBlCzK7GNiWkMHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zj6aJCbxGw5vvCrRmd/HWvHLra2dnGTDpMwCVCQ9fAcTtLWOVMASB/zVRZ3Ag6b9M
         ptrj7KFEeVyLkJfnl3m4jCGz9cL2lNmuC9j0aSYNVOb5J80LmM1967CsgXwf2ozoFc
         LxtiNIUPBMdeB3ROyabekWkrktQSHIEaaBVwm91s=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Damien Le Moal <dlemoal@fastmail.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v6 06/19] scsi: support retrieving sub-pages of mode pages
Date:   Thu,  6 Apr 2023 13:32:35 +0200
Message-Id: <20230406113252.41211-7-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113252.41211-1-nks@flawful.org>
References: <20230406113252.41211-1-nks@flawful.org>
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

