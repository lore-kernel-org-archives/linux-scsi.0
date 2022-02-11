Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C9C6C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354103AbiBKWfD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:35:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354166AbiBKWet (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:34:49 -0500
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE099D5F
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:45 -0800 (PST)
Received: by mail-pf1-f174.google.com with SMTP id i21so17186317pfd.13
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:34:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ACIKykN0EBRMFX9wNhDt2BPXzEzxukWVABPnH3eZLdg=;
        b=wO95JYTHOD7i3Y/E263m3WzGTDQIlCPxuRveu6QYExyL9ta62dnL3IKCHvdqiLAy0q
         eXPiZy3RPY/Dvq+QLvQ/IVpyIxUiYflO9oc/3MN2kI8K2bPI2IOQVFSD6k7aBY8wXu99
         zk38GFUOPLNArS8rPXnvYhhZQvbZ2RmbIp9f5zjTmP2Pk5OYGs2YWaiMXda33aDzErLY
         i9DgOp91qlu8fg/4mHX6AqJnZhMK+7KLW03sAOWATMlp5dyD8uU2vQn1H6AWHq+eroVG
         rR2VW9Qr0NKL2axwKBhMcCwJabtoc4Y7ipad5QnzqP2KkcswRhKl2lEmIVCTptnTJg0Y
         ym8w==
X-Gm-Message-State: AOAM5333Eszgal/br/pEDGyoeoJ4EYKHb51qQfSPLlYli9BXj95rYrrS
        LVtuTeJ7lb0tuM9GT9h+dxU=
X-Google-Smtp-Source: ABdhPJxTT/lh/EgnzzG6sgsTDnPtcYuNwNI5dkqct6nIAYIv7UYl5iucMIWX5CHbnbq36d2nPo+uiQ==
X-Received: by 2002:a05:6a00:170d:: with SMTP id h13mr3761921pfc.39.1644618885153;
        Fri, 11 Feb 2022 14:34:45 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:34:44 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 48/48] scsi: core: Remove struct scsi_pointer from struct scsi_cmnd
Date:   Fri, 11 Feb 2022 14:32:47 -0800
Message-Id: <20220211223247.14369-49-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove struct scsi_pointer from struct scsi_cmnd since the previous patches
removed all users of that member of struct scsi_cmnd. Additionally, reorder
the members of struct scsi_cmnd such that the statement that the field
below can be modified by the SCSI LLD is again correct.

Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_cmnd.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 6794d7322cbd..d99186a63469 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -123,11 +123,15 @@ struct scsi_cmnd {
 				 * command (auto-sense). Length must be
 				 * SCSI_SENSE_BUFFERSIZE bytes. */
 
+	int flags;		/* Command flags */
+	unsigned long state;	/* Command completion state */
+
+	unsigned int extra_len;	/* length of alignment and padding */
+
 	/*
-	 * The following fields can be written to by the host specific code. 
-	 * Everything else should be left alone. 
+	 * The fields below can be modified by the LLD but the fields above
+	 * must not be modified.
 	 */
-	struct scsi_pointer SCp;	/* Scratchpad used by some host adapters */
 
 	unsigned char *host_scribble;	/* The host adapter is allowed to
 					 * call scsi_malloc and get some memory
@@ -138,10 +142,6 @@ struct scsi_cmnd {
 					 * to be at an address < 16Mb). */
 
 	int result;		/* Status code from lower level driver */
-	int flags;		/* Command flags */
-	unsigned long state;	/* Command completion state */
-
-	unsigned int extra_len;	/* length of alignment and padding */
 };
 
 /* Variant of blk_mq_rq_from_pdu() that verifies the type of its argument. */
