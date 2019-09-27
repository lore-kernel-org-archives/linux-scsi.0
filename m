Return-Path: <SRS0=gVs6=XW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A5D8C4360C
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 22:16:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B9842054F
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 22:16:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MiMu5vGa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbfI0WQG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Sep 2019 18:16:06 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:24948 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfI0WQF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Sep 2019 18:16:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1569622565; x=1601158565;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0+RS/WQ72uYjuEOJgGNw9I8eOFw7oExgvMwrLdBMfrM=;
  b=MiMu5vGaVs6uER205Kv449WeJC5hU6WFwOSBsQ7WwvKvg7GDAKztfNeg
   9ah5AzfuEESkzVmw+f6eA+R8cGaczje8SOzyrDxD9JAZS4id2fDG9tD0m
   rJ3kXsUPG1lmcFbGJebztOFIkCxzw5FUp3yIF3JjDPTqxygv1WqLnwDpF
   XxvyJhXuz9sbm3jCoIGVXrgT102i8w6t9i6rW0E76bXA3U8CKDgeIGfTT
   UU0WSDww3URvevuNM4W5WJ39Bwj4IlFgH86N/laAcFt0bph+Savf5UCQe
   kvMAVccS/IIWg6NFKBbDmAFl5UUVhC/nM9G/la4Up7jbEXjdvCGub3x6s
   w==;
IronPort-SDR: v59weQC5YtCsiI7Y8s9hlkUZ7YOIqzBMIk9xHcyDBOo8pQzRC9i3W3Q/TzG6XX5EnjzAcy/4gm
 irLK0G7PAEPlfMQLNB1U0FLZoLbrtw5GA+j+YxllUxuBNCCsGYTUh/3QNKsBeWqis+fn2IfaE7
 X8m+NDH3mJ6oMpGHYpfN0KVGk7QknCtAkHTCQC/jUA/kFgm9kpnusd3249FZRsqjA0uiQeICrE
 tDPPC3cyii6toOaBxD+c14DbM9pF3ODWEU/0Udi0+QiWRJ7gE/G1xshtyIfryp2kkTJp93XRMC
 FXM=
X-IronPort-AV: E=Sophos;i="5.64,557,1559491200"; 
   d="scan'208";a="226192875"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Sep 2019 06:16:05 +0800
IronPort-SDR: pI4+ODXcV9r+uKCq1AearHABR0226SdXqKxjlijGO6tPANJQ3+XURt/rXAEygHoeqdEcMa9qzw
 Qj0JdDkqYAroiqVTAQEb+8ClUo5IrIY5iDGozI5tnWou300twIgyZRMSXLHwBb0C9H0lMUKnIJ
 oBLCfKy47pCMf9+CyNF3SnmpfpnNSTCQ8gGxuya0wVURXQiHpmIH36lP8FRqMd1lN7IX4rGAyA
 VfY/I8i1omjBeQJlkmgF0yThkmgYoNp1nFCJ1+fOgYfBl10iZahtpYpkWfLmm//tnH5b2iE0+7
 FWagZtnSr9Xnfj2z+106FUK2
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 15:12:23 -0700
IronPort-SDR: tZdmX3bdUZlvjWOiFTNad9aNGZL0A5zV+zzeyCfY2O0S9QYZEuUhbSKv8slyrY2npbGOKRuTp3
 xd4FOF0O5B7SSbq6rd7DIAMl3ga4rkV9CNJa7Y/N7wLYS8Y8AhxGCOPP707ckJctwLX+EpXsZq
 GenmHR0riYJld8fS5PRl1S8v55QRoXb+cAhzU3VlHiSjCbLFx0d8uAJbjEQfuaZb08Ou3YNt4W
 8jOWeL3vWhdWlOmn+6brOhbiD7Zuslbvs+rOP7/6e5m8CxsgpjzIN/UVkpIeYfLjfpL4fytZ9V
 /OY=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Sep 2019 15:16:03 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: [PATCH V2] scsi: save/restore command resid for error handling
Date:   Sat, 28 Sep 2019 07:16:02 +0900
Message-Id: <20190927221602.27080-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When a non-passthrough command is terminated with CHECK CONDITION,
request sense is executed by hijacking the command descriptor. Since
scsi_eh_prep_cmnd() and scsi_eh_restore_cmnd() do not save/restore the
original command resid, the value returned on failure of the original
command is lost and replaced with the value set by the execution of the
request sense command. This value may in many instances be unaligned to
the device sector size, causing sd_done() to print a warning message
about the incorrect unaligned resid before the command is retried or
aborted.

Fix this problem by saving the original command resid in struct
scsi_eh_save using scsi_eh_prep_cmnd() and restoring it in
scsi_eh_restore_cmnd(). In addition, to make sure that the request sense
command is executed with a correctly initialized command structure, also
reset resid to 0 in scsi_eh_prep_cmnd() after saving the original
command resid value in struct scsi_eh_save.

Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---

Changes from V1:
* Dropped patch 2
* Add resid reset in scsi_eh_prep_cmnd()

 drivers/scsi/scsi_error.c | 3 +++
 include/scsi/scsi_eh.h    | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1c470e31ae81..f53828bf7ad7 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -967,6 +967,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	ses->data_direction = scmd->sc_data_direction;
 	ses->sdb = scmd->sdb;
 	ses->result = scmd->result;
+	ses->resid = scsi_get_resid(scmd);
 	ses->underflow = scmd->underflow;
 	ses->prot_op = scmd->prot_op;
 	ses->eh_eflags = scmd->eh_eflags;
@@ -977,6 +978,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	memset(scmd->cmnd, 0, BLK_MAX_CDB);
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
 	scmd->result = 0;
+	scsi_set_resid(scmd, 0);
 
 	if (sense_bytes) {
 		scmd->sdb.length = min_t(unsigned, SCSI_SENSE_BUFFERSIZE,
@@ -1029,6 +1031,7 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 	scmd->sc_data_direction = ses->data_direction;
 	scmd->sdb = ses->sdb;
 	scmd->result = ses->result;
+	scsi_set_resid(scmd, ses->resid);
 	scmd->underflow = ses->underflow;
 	scmd->prot_op = ses->prot_op;
 	scmd->eh_eflags = ses->eh_eflags;
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 3810b340551c..9caa9b262a32 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -32,6 +32,7 @@ extern int scsi_ioctl_reset(struct scsi_device *, int __user *);
 struct scsi_eh_save {
 	/* saved state */
 	int result;
+	unsigned int resid;
 	int eh_eflags;
 	enum dma_data_direction data_direction;
 	unsigned underflow;
-- 
2.21.0

