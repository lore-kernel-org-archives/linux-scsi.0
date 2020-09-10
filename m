Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 295DEC433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 07:48:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D672B20855
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 07:48:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Qgwll5YO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgIJHsw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 03:48:52 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:63781 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgIJHst (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 03:48:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1599724128; x=1631260128;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=MMGTLGGXQi7y4oWCrdFnHFsCwBCWiTbY/tb8jdobx/M=;
  b=Qgwll5YO6tBp9cu3Vga4MUYGMKX89UUhfdx0PWsjL51xin5Sr9/nILxC
   A7pEk0nzhRQL15cN3jJTf7xU256tl+i5cttUu5j+e2G9WjsTVx9PMNk4e
   tPJPj4mT2W0PMKtQevWM84xe+r5Xkc4rqhp+zFP9VLhfL0sNo/P2wytq3
   1OyTNQkMHMTcokHKXw12MNOeYTMNccKMCbNfItLouZ4eh0fDi4sA3YNg8
   0ZEYRdBTcb6ZDgLye1+uS9Ven02An+CbM9e8+/15XH8KtzmQ51N57qZgh
   uMQvXtwXnN2DyUcHP4MJJXtAgCmvTDI51Sswhv+Je9tfjmBUMXneC1ywa
   w==;
IronPort-SDR: cPcp3zvggxBG/QkBRrbPB6nX6fe4doCE/e+b+DTipJyXhUdyZ8bEyTjpCgRtFLVwIfaHZcxuE3
 1JsjAMetWOiTQGVsuL2Znv9EO3ejY6RJ5d6Oo9gk+/zpbTyfHyrn9HPEp/xuddiUM2acrYO5Le
 qJSTQ4QksczVuBlv+ul8BDWaq+voReZ0hC8aMW9HagVMT9jmUD+7eguYlqhYohXDZbeCD3oDjQ
 bd32iT4T0ILKbgirKXvV55bNDL3gWGvmM3v0KWnYPWBCAG/YOdyqYTYwfwjttXSbrpa1usNd+B
 br0=
X-IronPort-AV: E=Sophos;i="5.76,412,1592841600"; 
   d="scan'208";a="256599380"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Sep 2020 15:48:46 +0800
IronPort-SDR: 8DOhm5dLYvzjSc4waqoG25cIHlb5oak9EFqUQQnZx7Wg28DsKQfN7t3dPVbjst9fjMo7Io74F2
 qCw7WJIrpbuw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 00:36:04 -0700
IronPort-SDR: rv7KoABFkfADM8esGTASvY6VvRWjvjUQCsdP7w2tZtM8MlyIpyT8PW1UVzXcSU1teX7cR3Uxc/
 XEnvZwjrNwkw==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 10 Sep 2020 00:48:47 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 3/3] scsi: handle zone resources errors
Date:   Thu, 10 Sep 2020 16:48:43 +0900
Message-Id: <20200910074843.217661-4-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200910074843.217661-1-damien.lemoal@wdc.com>
References: <20200910074843.217661-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ZBC or ZAC disks that have a limit on the number of open zones may fail
a zone open command or a write to a zone that is not already implicitly
or explicitly open if the total number of open zones is already at the
maximum allowed.

For these operations, instead of returning the generic BLK_STS_IOERR,
return BLK_STS_DEV_RESOURCE which is returned as -EBUSY to the I/O
issuer, allowing the device user to act appropriately on these
relatively benign zone resource errors.

With this change the NVMe (ZNS) and sd drivers both return the same
error code for zone resource errors, facilitating the implementation of
IO error handling by the user with a common code base for both device
types.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/scsi_lib.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7c6dd6f75190..1b5c2a6ad072 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -758,6 +758,15 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 			/* See SSC3rXX or current. */
 			action = ACTION_FAIL;
 			break;
+		case DATA_PROTECT:
+			action = ACTION_FAIL;
+			if ((sshdr.asc == 0x0C && sshdr.ascq == 0x12) ||
+			    (sshdr.asc == 0x55 &&
+			     (sshdr.ascq == 0x0E || sshdr.ascq == 0x0F))) {
+				/* Insufficient zone resources */
+				blk_stat = BLK_STS_DEV_RESOURCE;
+			}
+			break;
 		default:
 			action = ACTION_FAIL;
 			break;
-- 
2.26.2

