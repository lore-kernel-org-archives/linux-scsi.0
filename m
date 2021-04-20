Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 439BBC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11DCF61107
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhDTCPF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:15:05 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:44828 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbhDTCPD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:15:03 -0400
Received: by mail-pf1-f178.google.com with SMTP id m11so24489547pfc.11
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ffu/wHlq0UCYwPfVc5uzNuSwZxWjDh3HsMgfkp3Gt6s=;
        b=KaO1i958R/CEiF1WORgjI+qszA7b0L8a9Nxb9UIBXpCvv2XorIxs7xBqvpay1R5F14
         LKObmpLWlMsXP4s1fJHDX8uNBjLB9LKkVxjlme0okSilJU5Zh7eD0+SPmK9JfMjNiX4P
         M3V7pIH8wppI0FJZBHHzlAwolPgzasMOwrODbLZRUdHPpWL8XCmTYKKCkkhYMGb+GvO2
         rAUPb7ZRgQWA0rIpZkpDhjNK5h0q9qR0z6ZRCxmECwEEibgzU6sS6OpDGHQhH5vn2q3E
         zfBGkQmwcZAxkwkwfPtEIQZtYoEcM8+cRzLFe03vOO9ppXy2/82CDU12m2aR2hV02cxj
         sbwA==
X-Gm-Message-State: AOAM533r76yXixRfKRjT2QUthBtzmkHRtbifob5qI3Qg+guCydCtupFA
        zWHVFUreWFuviSk/Z1mc5oU=
X-Google-Smtp-Source: ABdhPJyzg4kAhXoaYjODZVE36ezgxQZp1cvQqGlGz7el1ZklJm+deSNLsYiHilWL7wP1Lm+DNgEZpg==
X-Received: by 2002:a63:3812:: with SMTP id f18mr14689292pga.380.1618884872642;
        Mon, 19 Apr 2021 19:14:32 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Lee Duncan <lduncan@suse.com>, Can Guo <cang@codeaurora.org>
Subject: [PATCH 110/117] Finalize the switch from 'int' to 'union scsi_status'
Date:   Mon, 19 Apr 2021 19:13:55 -0700
Message-Id: <20210420021402.27678-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A previous patch changed 'int result;' into a union and introduced the
scsi_status member in that union. Now that the conversion from type
'int' into 'union scsi_status' is complete, remove the 'result' member.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Lee Duncan <lduncan@suse.com>
Cc: Can Guo <cang@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/linux/bsg-lib.h          | 5 +----
 include/scsi/scsi_bsg_iscsi.h    | 7 ++-----
 include/scsi/scsi_cmnd.h         | 5 +----
 include/scsi/scsi_eh.h           | 5 +----
 include/scsi/scsi_request.h      | 5 +----
 include/uapi/scsi/scsi_bsg_fc.h  | 5 +----
 include/uapi/scsi/scsi_bsg_ufs.h | 7 ++-----
 7 files changed, 9 insertions(+), 30 deletions(-)

diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index f934afc45760..6143a54454db 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -53,10 +53,7 @@ struct bsg_job {
 	struct bsg_buffer request_payload;
 	struct bsg_buffer reply_payload;
 
-	union {
-		int		  result; /* do not use in new code */
-		union scsi_status status;
-	};
+	union scsi_status status;
 	unsigned int reply_payload_rcv_len;
 
 	/* BIDI support */
diff --git a/include/scsi/scsi_bsg_iscsi.h b/include/scsi/scsi_bsg_iscsi.h
index d18e7e061927..e384df88fab1 100644
--- a/include/scsi/scsi_bsg_iscsi.h
+++ b/include/scsi/scsi_bsg_iscsi.h
@@ -76,17 +76,14 @@ struct iscsi_bsg_request {
 /* response (request sense data) structure of the sg_io_v4 */
 struct iscsi_bsg_reply {
 	/*
-	 * The completion result. Result exists in two forms:
+	 * The completion status. Result exists in two forms:
 	 * if negative, it is an -Exxx system errno value. There will
 	 * be no further reply information supplied.
 	 * else, it's the 4-byte scsi error result, with driver, host,
 	 * msg and status fields. The per-msgcode reply structure
 	 * will contain valid data.
 	 */
-	union {
-		uint32_t	  result; /* do not use in new code */
-		union scsi_status status;
-	};
+	union scsi_status status;
 
 	/* If there was reply_payload, how much was recevied ? */
 	uint32_t reply_payload_rcv_len;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 539be97b0a7d..b616e1d8af9a 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -141,10 +141,7 @@ struct scsi_cmnd {
 					 * to be at an address < 16Mb). */
 
 	/* Status code from lower level driver */
-	union {
-		int		  result; /* do not use in new code. */
-		union scsi_status status;
-	};
+	union scsi_status status;
 	int flags;		/* Command flags */
 	unsigned long state;	/* Command completion state */
 
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index dcd66bb9a1ba..406e22887d96 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -33,10 +33,7 @@ extern int scsi_ioctl_reset(struct scsi_device *, int __user *);
 
 struct scsi_eh_save {
 	/* saved state */
-	union {
-		int		  result; /* do not use in new code */
-		union scsi_status status;
-	};
+	union scsi_status status;
 	unsigned int resid_len;
 	int eh_eflags;
 	enum dma_data_direction data_direction;
diff --git a/include/scsi/scsi_request.h b/include/scsi/scsi_request.h
index 83f5549cc74c..41b8f9f6a349 100644
--- a/include/scsi/scsi_request.h
+++ b/include/scsi/scsi_request.h
@@ -11,10 +11,7 @@ struct scsi_request {
 	unsigned char	__cmd[BLK_MAX_CDB];
 	unsigned char	*cmd;
 	unsigned short	cmd_len;
-	union {
-		int		  result; /* do not use in new code */
-		union scsi_status status;
-	};
+	union scsi_status status;
 	unsigned int	sense_len;
 	unsigned int	resid_len;	/* residual count */
 	int		retries;
diff --git a/include/uapi/scsi/scsi_bsg_fc.h b/include/uapi/scsi/scsi_bsg_fc.h
index 419db719fe8e..6d095aefc265 100644
--- a/include/uapi/scsi/scsi_bsg_fc.h
+++ b/include/uapi/scsi/scsi_bsg_fc.h
@@ -295,10 +295,7 @@ struct fc_bsg_reply {
 	 *    will contain valid data.
 	 */
 #ifdef __KERNEL__
-	union {
-		__u32		  result; /* do not use in new kernel code */
-		union scsi_status status;
-	};
+	union scsi_status status;
 #else
 	__u32 result;
 #endif
diff --git a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bsg_ufs.h
index 3dfe5a5a0842..1c282ab144f6 100644
--- a/include/uapi/scsi/scsi_bsg_ufs.h
+++ b/include/uapi/scsi/scsi_bsg_ufs.h
@@ -92,7 +92,7 @@ struct ufs_bsg_request {
 /* response (request sense data) structure of the sg_io_v4 */
 struct ufs_bsg_reply {
 	/*
-	 * The completion result. Result exists in two forms:
+	 * The completion status. Exists in two forms:
 	 * if negative, it is an -Exxx system errno value. There will
 	 * be no further reply information supplied.
 	 * else, it's the 4-byte scsi error result, with driver, host,
@@ -100,10 +100,7 @@ struct ufs_bsg_reply {
 	 * will contain valid data.
 	 */
 #ifdef __KERNEL__
-	union {
-		__u32		  result; /* do not use in new kernel code */
-		union scsi_status status;
-	};
+	union scsi_status status;
 #else
 	__u32 result;
 #endif
