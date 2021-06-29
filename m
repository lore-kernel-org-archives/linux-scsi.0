Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11FCCC11F67
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 15:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D654761D88
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 15:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbhF2QA5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 12:00:57 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:20030 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232698AbhF2QA4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 12:00:56 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TFr7ZV008984
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jun 2021 15:58:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=cbElCSRsxd7p8yRTL5MxPpckOCWOZCWBKU/ktqTWeHM=;
 b=hhEKDi6zhDV+x3S4mkJqDp9lYKZtlrOgYtLMxChhDjnJ3GVi61F8JRBKcpebqUuPhHW5
 XzFXQJOUmM8roJiGi/HoPo+Vk8sUoWr6A11KvVzLddxmmBRkcfNhXvalIMN0ZKXnp5qc
 eIygVZG6vIttiXyG+UouEm63JrbJsn0Hrp4GVnGSjXKbFpG9lDf5g/r6cuKzUFeV9JF9
 23mwmbGUWEaWiDrIlAZKQyBKiqLBQAaJ7gk4LWqSE6xAd2rKtlpB54R3od1gOzQsvAy6
 2Jhh79TuHDDj7w7U7HEp9q85G9k2RhSM3ckeZAUrFLufd8W4nzTBCMiGJ0usvBxERMBd yA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f6y3kymw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jun 2021 15:58:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15TFuBo6188002
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jun 2021 15:58:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 39ee0v5140-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jun 2021 15:58:27 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15TFwR0Q004388
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jun 2021 15:58:27 GMT
Received: from qvle-mac.us.oracle.com (dhcp-10-159-139-26.vpn.oracle.com [10.159.139.26])
        by userp3020.oracle.com with ESMTP id 39ee0v5135-1;
        Tue, 29 Jun 2021 15:58:27 +0000
From:   Quat Le <quat.le@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc:     Quat Le <quat.le@oracle.com>
Subject: [PATCH] scsi: Retry I/O for Notify (Enable Spinup) Required error.
Date:   Tue, 29 Jun 2021 08:58:26 -0700
Message-Id: <20210629155826.48441-1-quat.le@oracle.com>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
X-Proofpoint-GUID: S4UeHoTFr9BYD0gVmHZPMK0wkymAl-8J
X-Proofpoint-ORIG-GUID: S4UeHoTFr9BYD0gVmHZPMK0wkymAl-8J
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the device is power-cycled, it takes time for the initiator to
transmit the periodic NOTIFY (ENABLE SPINUP) SAS primitive, and for the
device to respond to the primitive to become ACTIVE. Retry the I/O
request to allow the device time to become ACTIVE.

Signed-off-by: Quat Le <quat.le@oracle.com>
---
 drivers/scsi/scsi_lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 532304d42f00..269bfb8f9165 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -728,6 +728,7 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 				case 0x07: /* operation in progress */
 				case 0x08: /* Long write in progress */
 				case 0x09: /* self test in progress */
+				case 0x11: /* notify (enable spinup) required */
 				case 0x14: /* space allocation in progress */
 				case 0x1a: /* start stop unit in progress */
 				case 0x1b: /* sanitize in progress */
-- 
2.17.2 (Apple Git-113)

