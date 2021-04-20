Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C7CBC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A6CF613AB
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbhDTCPW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:15:22 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:39588 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbhDTCPM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:15:12 -0400
Received: by mail-pf1-f170.google.com with SMTP id c17so24496410pfn.6
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=krxDzFEfDdHJoAFRcvs98ymdi4VtAXsyP2h50yvLkAk=;
        b=KMj28a6jW7P+kyEHKrCsBIgck2F9sqi54rh6yNlQhnPrZxPMIPWfXOYTTs8IHEXdwB
         oAIQFuWzVsZxhUleSzzFaCb8bMl1JSon7xqpDlfiOdRlD6Xdtiud/X8qtlz3cjnegLQr
         LxcsHuB3znB08LpfZWXazz8XIKlBpc/o0sAc4XrCMspf0rgcv1Rgq2i3up7D9cgmJtNY
         8aRXky1kD1znpvVuQ/IejoR2MAqvnCljWJQTeBaemdwmx/Ld/THquRzr5YTQXxHXtdPV
         0t5jLzfkzFZcTyOqWik6RWEAwJiJOJWo4U45+ZsQt6cHGbw3MPJEJW9LADwcSh5UrV0f
         a/Nw==
X-Gm-Message-State: AOAM533LihuykbspXYvnBf3UA5WKJVZqHvOTD3EnQy4CFRflSvgRhngI
        ZIeIINUCquuk9n1ysc2E4XY=
X-Google-Smtp-Source: ABdhPJw50ei6raBV+nx6SVunXxjPiM7Eqn7KR2pYBdJJg8XhyqJ4KrNZGaW8tJri0eNgLEkjnr4OdQ==
X-Received: by 2002:a63:1813:: with SMTP id y19mr12118051pgl.144.1618884881280;
        Mon, 19 Apr 2021 19:14:41 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 117/117] Change the return type of ioctl_internal_command() into union scsi_status
Date:   Mon, 19 Apr 2021 19:14:02 -0700
Message-Id: <20210420021402.27678-27-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that ioctl_internal_command() returns a SCSI status.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_ioctl.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 8b3bab5b5cb8..896cf5bac255 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -86,8 +86,8 @@ static int ioctl_probe(struct Scsi_Host *host, void __user *buffer)
  * The output area is then filled in starting from the command byte. 
  */
 
-static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
-				  int timeout, int retries)
+static union scsi_status ioctl_internal_command(struct scsi_device *sdev,
+				char *cmd, int timeout, int retries)
 {
 	union scsi_status result;
 	struct scsi_sense_hdr sshdr;
@@ -136,13 +136,13 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 
 	SCSI_LOG_IOCTL(2, sdev_printk(KERN_INFO, sdev,
 				      "IOCTL Releasing command\n"));
-	return result.combined;
+	return result;
 }
 
 int scsi_set_medium_removal(struct scsi_device *sdev, char state)
 {
 	char scsi_cmd[MAX_COMMAND_SIZE];
-	int ret;
+	union scsi_status ret;
 
 	if (!sdev->removable || !sdev->lockable)
 	       return 0;
@@ -156,9 +156,9 @@ int scsi_set_medium_removal(struct scsi_device *sdev, char state)
 
 	ret = ioctl_internal_command(sdev, scsi_cmd,
 			IOCTL_NORMAL_TIMEOUT, NORMAL_RETRIES);
-	if (ret == 0)
+	if (ret.combined == 0)
 		sdev->locked = (state == SCSI_REMOVAL_PREVENT);
-	return ret;
+	return ret.combined;
 }
 EXPORT_SYMBOL(scsi_set_medium_removal);
 
@@ -244,14 +244,14 @@ static int scsi_ioctl_common(struct scsi_device *sdev, int cmd, void __user *arg
 		scsi_cmd[2] = scsi_cmd[3] = scsi_cmd[5] = 0;
 		scsi_cmd[4] = 1;
 		return ioctl_internal_command(sdev, scsi_cmd,
-				     START_STOP_TIMEOUT, NORMAL_RETRIES);
+				START_STOP_TIMEOUT, NORMAL_RETRIES).combined;
 	case SCSI_IOCTL_STOP_UNIT:
 		scsi_cmd[0] = START_STOP;
 		scsi_cmd[1] = 0;
 		scsi_cmd[2] = scsi_cmd[3] = scsi_cmd[5] = 0;
 		scsi_cmd[4] = 0;
 		return ioctl_internal_command(sdev, scsi_cmd,
-				     START_STOP_TIMEOUT, NORMAL_RETRIES);
+				START_STOP_TIMEOUT, NORMAL_RETRIES).combined;
         case SCSI_IOCTL_GET_PCI:
                 return scsi_ioctl_get_pci(sdev, arg);
 	case SG_SCSI_RESET:
