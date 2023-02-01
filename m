Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 597A0C636D4
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Feb 2023 18:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbjBASGw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Feb 2023 13:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjBASGu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2023 13:06:50 -0500
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6807DBF3
        for <linux-scsi@vger.kernel.org>; Wed,  1 Feb 2023 10:06:49 -0800 (PST)
Received: by mail-pf1-f174.google.com with SMTP id g9so13192466pfo.5
        for <linux-scsi@vger.kernel.org>; Wed, 01 Feb 2023 10:06:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6gBZq0wYRHnGH4hjPubEjFbLxckfB/3To6qGi+QAYAg=;
        b=vOaGsZ3u1k+/Eljkq41q/cGTAk2tlE9hdYJClTMqPUwq0TpBXjfPfcnwUxbRx7qsL/
         whf0ywTlJqujVZzsQMwO8QqmVyX/0YUI4SFhguXFzpNj6Xgckg/vltw3qNow4QXIDiA5
         /AQAp2PXx0IPEVPMJCGjU8zWd7yJr7HBzwiCcKUGnWJ8dAleinUHp3nGZNdlfxXzajN8
         ABSG/VKElMQvtXGeCBjPBBpcTfRH99nrYDkbdBScTxIR05NFx+TeWABsLFLk2N2eBJ5D
         vUsFMAyDdnbERfP0xWNi9QM6sR5GMA9G3otbTttys+lJ6JsnEo7lw3zFR6lE1H2GLgyh
         845Q==
X-Gm-Message-State: AO0yUKVsrsSgihFH0uyAEYqDLiSD5N3MLgWnYJkotBe/0eSHC2cTG4OH
        sqoWdqVY/e9Ar4Fh4soJfkk=
X-Google-Smtp-Source: AK7set8h+bfhTclZBDCYOgxcrzUJ95RFs9ci5Mb1iZcvCGrbrxJ0MTmeqbaPfMOq5nv8vV5Zl+DIKQ==
X-Received: by 2002:a05:6a00:1ad2:b0:582:a212:d92c with SMTP id f18-20020a056a001ad200b00582a212d92cmr3772031pfv.10.1675274808523;
        Wed, 01 Feb 2023 10:06:48 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f3cf:17ca:687:af15])
        by smtp.gmail.com with ESMTPSA id x13-20020aa78f0d000000b005825b8e0540sm7021264pfr.204.2023.02.01.10.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 10:06:47 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 1/2] scsi: core: Introduce the BLIST_BROKEN_FUA flag
Date:   Wed,  1 Feb 2023 10:06:36 -0800
Message-Id: <20230201180637.2102556-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
In-Reply-To: <20230201180637.2102556-1-bvanassche@acm.org>
References: <20230201180637.2102556-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS devices perform better when using SYNCHRONIZE CACHE command instead of
the FUA flag. Introduce the BLIST_BROKEN_FUA flag for using SYNCHRONIZE
CACHE instead of FUA.

The BLIST_BROKEN_FUA flag can be set by using one of the following
approaches:
* From user space, by writing into /proc/scsi/device_info.
* From the kernel, by setting sdev_bflags from the slave_alloc callback.

For a prior version of this patch, see also
https://lore.kernel.org/lkml/YpecaXfIxZBHIcfj@google.com/T/

Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_scan.c    | 3 +++
 include/scsi/scsi_devinfo.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index a62925355c2c..c1eb6bfe7ed2 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1020,6 +1020,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (*bflags & BLIST_NO_RSOC)
 		sdev->no_report_opcodes = 1;
 
+	if (*bflags & BLIST_BROKEN_FUA)
+		sdev->broken_fua = 1;
+
 	/* set the device running here so that slave configure
 	 * may do I/O */
 	mutex_lock(&sdev->state_mutex);
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 5d14adae21c7..f89e8d1a9d64 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -68,6 +68,8 @@
 #define BLIST_RETRY_ITF		((__force blist_flags_t)(1ULL << 32))
 /* Always retry ABORTED_COMMAND with ASC 0xc1 */
 #define BLIST_RETRY_ASC_C1	((__force blist_flags_t)(1ULL << 33))
+/* Use SYNCHRONIZE CACHE instead of FUA */
+#define BLIST_BROKEN_FUA	((__force blist_flags_t)(1ULL << 34))
 
 #define __BLIST_LAST_USED BLIST_RETRY_ASC_C1
 
