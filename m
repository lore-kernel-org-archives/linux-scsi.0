Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A2ECA9EBC
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 10:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A468214D9
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 10:57:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nJgmuaIn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388388AbfJ1K5f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 06:57:35 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:3064 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728554AbfJ1K5f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 06:57:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572260254; x=1603796254;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5cU6D73Hs2L+9WKhpJ/DxPgX9YooUgDZWEqmp8qc6Tk=;
  b=nJgmuaInWSWG8RvnihJXpDcP7SUk0Rmg7tMmNYqtW3VxYZe3iDWQjLpr
   0vkgVE+6XS8tArcfTa7keVcTtR/kN9cYrMtK3ruKobkdIZgTagx8n0Re/
   ZfzABgPdumpiJdJvJ5ogF/yEwjnX4jrJOUIAurli2Bwjj3BTnCMZJdIpi
   FkGs1+Rv0bxNwGRe1Pue0kTJgOG6qQOOg4aSOHGHMDt8S9C8UkdGbeExH
   GmVKJujwKESUxlFWYgPGODVtA/YtBbR46upFthLOQ61NOb+NEZxEUDU/8
   glFhXq3jpK2dgMrB+TUxHnvfwlJUJR8BIX0iAHzQeH63BH1Gw+zVEMOn9
   g==;
IronPort-SDR: cSNpMmvJe7sraI8y4QWZOfDh/HpSWP9U13TLr46Y+RGGjaXfqLQUw8iPCEP862v79fhtqp9NU/
 st3+h99K8Q6PZuAJg/5+29pM9wfJUjZyxxwL3DhYHt7mmE9WHC6ZvWRP44kigTiex6ISXhNtzB
 UMOfsB0UOGZEElPUQ0ZQ+LCkzrFY+GY2RZTVELg4KKLZ9vt5Hu98S8VCLrU6DKaGsvjo12HQOr
 nHB70397KPXloevrpikLcaMDAUcdEgS/03qB1/wfIusSAgxJsCK/nR5+fqC3jdGR7lvVOJjtqj
 6v8=
X-IronPort-AV: E=Sophos;i="5.68,239,1569254400"; 
   d="scan'208";a="121482191"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2019 18:57:34 +0800
IronPort-SDR: diRdj7OC/Q2ftUQIxX76GtC8HdBGTT7aIHOy4dkYpBDfA/RnCBcSl8hlyed9ThrRy2OR+kWd77
 xMgYNJV2XC2KRcm8iTLRHKN4lAoHeVqpyVbT01wFmVQne0Lkq8b3McIATliwLTDPNpdh31ltql
 4hBwc6ThavIPhburudmSKGTVo7OWCbOOUUC7sCXFwEGBUCRAROt6pYz3z3kJ3ovMDagGNSVK7V
 5Xrk2RH0mQd+5YVi2afzVHNG0cuY5rMnFJJc4Vr8nl1N0O/yNj8WidjBDvj00Hn/IioNzUCiCC
 s8doMTX9upVyyoJoHIzODOnM
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2019 03:52:56 -0700
IronPort-SDR: HF+d3JKARyFvJYiVVFrIfJUDiGbVDvC+DpJK0P98J87M+BaVK7PE3AJ29odtlXd+wxKO1TZpSZ
 4t3cL6MEj8FlE5KZ65xk0U0lfUbtFhfwSbgpVTX1wOVPwTe6VhJY0qzq7LkBJ0qWK2iWjf+AVo
 uKYz2KzdhccfuG/9ucm/6Bj8vW49UQjmcdAK4qKuSu8pjgYNzhht9Qc8L/Y1UqQZnhQCtOxsCy
 XYUleEXeLE+gF6g1UxI7kaxkuOVq+EJNaFa3pdvbADzYk0g8yY1uSDdBRojBypHkKl0Ht9+KMj
 sLc=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 28 Oct 2019 03:57:33 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: [PATCH] scsi: Fix scsi_get/set_resid() interface
Date:   Mon, 28 Oct 2019 19:57:32 +0900
Message-Id: <20191028105732.29913-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

struct scsi_cmnd cmd->req.resid_len which is returned and set
respectively by the helper functions scsi_get_resid() and
scsi_set_resid() is an unsigned int. Reflect this fact in the interface
of these helper functions.

Also fix compilation errors due to min() and max() type mismatch
introduced by this change in scsi debug code and usb transport code.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/scsi_debug.c       | 4 ++--
 drivers/usb/storage/transport.c | 3 +--
 include/scsi/scsi_cmnd.h        | 4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d323523f5f9d..4daf2637c011 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1025,7 +1025,7 @@ static int fill_from_dev_buffer(struct scsi_cmnd *scp, unsigned char *arr,
 static int p_fill_from_dev_buffer(struct scsi_cmnd *scp, const void *arr,
 				  int arr_len, unsigned int off_dst)
 {
-	int act_len, n;
+	unsigned int act_len, n;
 	struct scsi_data_buffer *sdb = &scp->sdb;
 	off_t skip = off_dst;
 
@@ -1039,7 +1039,7 @@ static int p_fill_from_dev_buffer(struct scsi_cmnd *scp, const void *arr,
 	pr_debug("%s: off_dst=%u, scsi_bufflen=%u, act_len=%u, resid=%d\n",
 		 __func__, off_dst, scsi_bufflen(scp), act_len,
 		 scsi_get_resid(scp));
-	n = (int)scsi_bufflen(scp) - ((int)off_dst + act_len);
+	n = scsi_bufflen(scp) - (off_dst + act_len);
 	scsi_set_resid(scp, min(scsi_get_resid(scp), n));
 	return 0;
 }
diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index 96cb0409dd89..238a8088e17f 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -1284,8 +1284,7 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 		} else {
 			residue = min(residue, transfer_length);
-			scsi_set_resid(srb, max(scsi_get_resid(srb),
-			                                       (int) residue));
+			scsi_set_resid(srb, max(scsi_get_resid(srb), residue));
 		}
 	}
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 91bd749a02f7..3772ae5d40cd 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -190,12 +190,12 @@ static inline unsigned scsi_bufflen(struct scsi_cmnd *cmd)
 	return cmd->sdb.length;
 }
 
-static inline void scsi_set_resid(struct scsi_cmnd *cmd, int resid)
+static inline void scsi_set_resid(struct scsi_cmnd *cmd, unsigned int resid)
 {
 	cmd->req.resid_len = resid;
 }
 
-static inline int scsi_get_resid(struct scsi_cmnd *cmd)
+static inline unsigned int scsi_get_resid(struct scsi_cmnd *cmd)
 {
 	return cmd->req.resid_len;
 }
-- 
2.21.0

