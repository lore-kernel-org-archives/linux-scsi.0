Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB26C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354131AbiBKWd4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:33:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354126AbiBKWdu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:33:50 -0500
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDDAD4E
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:48 -0800 (PST)
Received: by mail-pl1-f173.google.com with SMTP id z17so5764896plb.9
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uD1tH8wDMn3Wm4Fc6dGeyWCxFL02tMZz49ogOKnrwOU=;
        b=SITVHmYrXYoPrYzAgpjweXzV0gYim+3bcU1mrvU8b4ekc/ef4UpAPMMu13PePpKnXF
         B3aAImepRq6g5t5bwwaVTE1sIIj0lascCMdRzMcUeVISTJ0Yl9H4OKiLAyQ9CRHm1eCQ
         zLzIDoMyrr12xkEY8Uwj0wYK5BXDpk3wfcJLXyQHgAAVZJu6gRkgtG8zJv5i8+6zIlm5
         ZcVcHUxd61/uoKX25Tw1ik2ZOmAhCnj7uV4JB4kL7J9Vov659wPaj6L6cKZKL97ln6cA
         y/jGhzXoUhAn3nIep4LZTfUVqfWzVNl1mV5GbML6z8Zcg2YmSPqIDAQX02159BsjhCv5
         5BZw==
X-Gm-Message-State: AOAM530s8FDUpSq9mjDq7G3mcMP6I5vvtpUfkU3RxRQ6w1CGWakmCDmM
        UmEhneem+qJiPbl/8tPmPOA=
X-Google-Smtp-Source: ABdhPJwXg/Rd80FzQ2xsVjRAs2R2MKyYtSyKq+n/0pi1PcYNUG5df6kL64JSB03lc9UptrGnz4nXvQ==
X-Received: by 2002:a17:902:d482:: with SMTP id c2mr3551208plg.148.1644618827598;
        Fri, 11 Feb 2022 14:33:47 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:33:46 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Oliver Neukum <oneukum@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Oliver Neukum <oliver@neukum.org>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 19/48] scsi: dc395x: Stop using the SCSI pointer
Date:   Fri, 11 Feb 2022 14:32:18 -0800
Message-Id: <20220211223247.14369-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the code that sets SCSI pointer members since there is no code in
this driver that reads these members.

Cc: Oliver Neukum <oneukum@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/dc395x.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index c11916b8ae00..67a89715c863 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3314,9 +3314,6 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 
 	/* Here is the info for Doug Gilbert's sg3 ... */
 	scsi_set_resid(cmd, srb->total_xfer_length);
-	/* This may be interpreted by sb. or not ... */
-	cmd->SCp.this_residual = srb->total_xfer_length;
-	cmd->SCp.buffers_residual = 0;
 	if (debug_enabled(DBG_KG)) {
 		if (srb->total_xfer_length)
 			dprintkdbg(DBG_KG, "srb_done: (0x%p) <%02i-%i> "
