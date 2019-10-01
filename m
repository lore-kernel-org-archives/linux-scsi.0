Return-Path: <SRS0=Efrx=X2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0DDAECE589
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 07:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A90C4218DE
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 07:48:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ifEyUNqq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730344AbfJAHsm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Oct 2019 03:48:42 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:38051 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbfJAHsm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Oct 2019 03:48:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1569916123; x=1601452123;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=v2Q56QGsThDWkYp0lqGTwVCLnA1aCvxt50v5W5nlbbA=;
  b=ifEyUNqqTH/V/+COa+RPFPe9mXRNaERLr3kYeHoO9Dzh2QFV6cnkDcGC
   zLD0YlJtkAiVY5rRKzR4RCrK2ecalG/Pf1dLhz3RiuMiJRyaGj2wJN1pg
   ZyhvpiWs+bmql2j7gFa4iavmuMtiX3fTy+j6DzWy5gb1RJ469bfBD2213
   eD3+xnGhpGjtTM8sByeMTQpPrpWfJIX+v/nNmTSdM/xwORh7QBq9OV9SP
   aug/3onU3zbnpRxWfsVcpLHVjL9Ia/bO/8ZTq0VuHPgxlUaV4Qhr21np7
   LZBhJ1qVc7BxojMZL+46lwjuSdugejQ9bTknAe6shT+PG7K1U3a7n2CsQ
   Q==;
IronPort-SDR: 5MdZO5ofO5/5F5JCxr0WGQa6mdGENXCy753d1NPjypZPt8bAGBe7kvhNuy0mpoFmLSJaDVUwjS
 9lULi4qV7Fi/lQlTuGtX+vALOK/A+omdgQ7xrzK2wQXiHaJ+LJpYiepGtiiWup/cbDmYw8xbyv
 RONaYJ1HS00M6Wcl9wc6d7fUXIq4mTu4RRYBMnRvxQajM6kG4vSuFv0ZU68GNfxQkfuFPyocE3
 zD/HKW/asuAmRMk0KDRyvUlQKY9R6yi+YD2F74W8N4OeRzLW8sW1D+qqRb4MIAbgtRVsH/oOg8
 ySY=
X-IronPort-AV: E=Sophos;i="5.64,570,1559491200"; 
   d="scan'208";a="123953338"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 01 Oct 2019 15:48:42 +0800
IronPort-SDR: 8+gLYXzig78BDfDrf4tlrsg5yfSGI/WCAGhmp/6U+/h8RdJ+dZlVInSYb/ya9Y9jXuIJzjfzRX
 86GCJsAyhNAo3mHTKWRn+QhAJd4cMRlyQcj46yDRk94WgWzhvyA1OolSrxNXWEaErzFhb0J7eM
 XmKN/t3iB325oWOzoXZXRrxLyncJj8s3zW25vF9a637MVJVU6HwyoIlawQOFzw9yagTefJdyDV
 qQGDhisHdV4h+62u+5TZFEzgELpcqW6ZfYglP9wAJ5+g4ksavm3cFUjFpRF8x6WF4dCE2MgfYn
 1XDlyERAAnS9bAU1vsA8SGhk
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 00:44:54 -0700
IronPort-SDR: b310TOzOTn06o9J5QoAFs5lXe1YHdnXbrqk87NAsItAyW8ZpnedNhxP+VHfT4HC7dndSf5FBzt
 8Oq9e+xkA3XmBJbSQntxsxgOCn5DbFFIQoJys+aXOBOPbZKc4YcNaIWlKCuWM+2lBI93xJjIGW
 bpQF6xaFKH8ULiaaolAG6Idpe5oqlBelM1aOHxyO1xbpBO6FLgLQITIKmojRD2EsqVIfRhxPSa
 uzNjZVuI+ru5fSmtdd1aPUwTuosklKMI0CUTf/N/JzgQPGLq6JHLBIPhokPgrg7GxDR64qUCCX
 3mI=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 01 Oct 2019 00:48:41 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: [PATCH V3] scsi: save/restore command resid for error handling
Date:   Tue,  1 Oct 2019 16:48:39 +0900
Message-Id: <20191001074839.1994-1-damien.lemoal@wdc.com>
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
about the incorrect unaligned resid before the command is retried.

Fix this problem by saving the original command residual in struct
scsi_eh_save using scsi_eh_prep_cmnd() and restoring it in
scsi_eh_restore_cmnd(). In addition, to make sure that the request sense
command is executed with a correctly initialized command structure, also
reset the residual to 0 in scsi_eh_prep_cmnd() after saving the original
command value in struct scsi_eh_save.

Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
Changes from V2:
* Open code resid save/restore to keep the functions style
* rename struct scsi_eh_save resid field to resid_len to match struct
  scsi_request field name

Changes from V1:
* Dropped patch 2
* Add resid reset in scsi_eh_prep_cmnd()

 drivers/scsi/scsi_error.c | 3 +++
 include/scsi/scsi_eh.h    | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1c470e31ae81..ae2fa170f6ad 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -967,6 +967,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	ses->data_direction = scmd->sc_data_direction;
 	ses->sdb = scmd->sdb;
 	ses->result = scmd->result;
+	ses->resid_len = scmd->req.resid_len;
 	ses->underflow = scmd->underflow;
 	ses->prot_op = scmd->prot_op;
 	ses->eh_eflags = scmd->eh_eflags;
@@ -977,6 +978,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	memset(scmd->cmnd, 0, BLK_MAX_CDB);
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
 	scmd->result = 0;
+	scmd->req.resid_len = 0;
 
 	if (sense_bytes) {
 		scmd->sdb.length = min_t(unsigned, SCSI_SENSE_BUFFERSIZE,
@@ -1029,6 +1031,7 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 	scmd->sc_data_direction = ses->data_direction;
 	scmd->sdb = ses->sdb;
 	scmd->result = ses->result;
+	scmd->req.resid_len = ses->resid_len;
 	scmd->underflow = ses->underflow;
 	scmd->prot_op = ses->prot_op;
 	scmd->eh_eflags = ses->eh_eflags;
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 3810b340551c..6bd5ed695a5e 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -32,6 +32,7 @@ extern int scsi_ioctl_reset(struct scsi_device *, int __user *);
 struct scsi_eh_save {
 	/* saved state */
 	int result;
+	unsigned int resid_len;
 	int eh_eflags;
 	enum dma_data_direction data_direction;
 	unsigned underflow;
-- 
2.21.0

