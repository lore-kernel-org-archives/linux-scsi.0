Return-Path: <SRS0=YGqw=XV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 247D7C4360C
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 22:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE33E2054F
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 22:08:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VNKstinH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbfIZWIt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Sep 2019 18:08:49 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:22768 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfIZWIs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Sep 2019 18:08:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1569535729; x=1601071729;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fpIdmWGLT4lVuX83Jehf0Ov/+RkktFWqmmqFhvuJEJQ=;
  b=VNKstinHU4ASJWGF4mDPRK1OkX1mxuUc9BIstjf8VlK+jW7XbI/xrluj
   QSc490w+q/AxZ3Ar3b53MBBcv6h0bIeR6+IccLG9hU+eAzX4WOuA3losP
   K0e5Yg76yya3BgqX5eedkQwRXLKsQ2z5GznD56ZUHHT+oLubL1IALBXuv
   SbLotuNg8GZmw4ZxmSU7wd9pEq95UalcdEXy/TXGNwf/EV1X+OUNaTOQX
   pi+f0zDhgGWysSPfG0v6eTBT/iKZ3CJf7pjtVTO3S4rb0vlnQ5sxYmI+g
   uBesLz3JONcpyNS6gpKBZkK0RVpXU8AV1PCATTnvykuF1DJlk4yYv3PMZ
   Q==;
IronPort-SDR: st/MgvfaXZegJaL4tea+wVJfll8g3/r5Je7iCqpp1NG3SucIE76bnKEMvRDEu6a2F1ynUdcVvp
 EnATfgeZH1k5cTG5j+/zg5LmgJlydDf2Bjm3k2Zl/wFuy53wg5nWNEkXNRAQt3QTS4iBLAdaQH
 u3Qeq3aRDdvIz4ox4Gg0G2wFg2haRnXQ3xdCmrAlH0LYxpq8UuM/MmPX8cQFv7uoFGoEtstutV
 vEw4vVe2BNmCY8pKpK13VYlUToW9cgTNejecc2dS3B2XN000sqfoHusgO2aUTwxGltLtZcpwl+
 yMs=
X-IronPort-AV: E=Sophos;i="5.64,553,1559491200"; 
   d="scan'208";a="123681605"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2019 06:08:49 +0800
IronPort-SDR: vQyytvbnssVcP/SXKSn3fsRHUTHkkVmWMHHPnkjdws2ROPY2A5Rumrb/VrOhoCtjhXa5F+cohr
 F+kD6FNiwQJvdPRZD4Jv8AKHnztTwszQBWnbBRUztB7q5TMz/seN8ljiKFE0bYg1/9dmonzUeX
 up4AYmmKD3BznFWHssWKbmI/ivcD6Et9FeDCcRW81mZUr3qqBuwSZPn1fknz4u2qyFI8iygPkU
 aPLuzKTDG0dw1HE5lS9GhH77kdrT3B6scPqC2+OaeVQxNmPhHmCvqCp1s+KHJwj+2VVOuc/kbD
 oW0aqXQz4YMhBviDXt6wz7oN
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 15:05:08 -0700
IronPort-SDR: tRuZ9Xynn8r91aS1Aj+ik+1pQjbM3ZIZszytaF6ADgah3rsHCJYRXMpb/WPZW3I0tmwtNAxZqJ
 9u2JTcWM26MyKpt1U/ZhE1pWzX5eiSNF36RFt2Ra6uWevVSSfkf+bkNnJVM6rc6C7A3CaQl24A
 NRHL6LGQdkDynGQabtv5WEhFIflK1LnDy5d4p/r8rPHoPVfvdMXP9y3rIrH/r1S6yu/8B+vozw
 vDNN+clHEhRHNckbcuXrURr/wm2e/KgF6/wDGWRWMJUVSqP5toKee2+MJ+dwFJQZNMHv47U5zK
 L2A=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 26 Sep 2019 15:08:46 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: [PATCH 1/2] scsi: save/restore command resid for error handling
Date:   Fri, 27 Sep 2019 07:08:43 +0900
Message-Id: <20190926220844.26631-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190926220844.26631-1-damien.lemoal@wdc.com>
References: <20190926220844.26631-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When a command is terminated with CHECK CONDITION and request sense
executed by hijacking the command descriptor, the original command resid
is lost and replaced with the resid from the execution of request sense.
If based on the obtained sense data the command is aborted and not
retried, the resid that will be seen by drivers such as sd will be the
resid of the request sense execution and not the value from the original
command failure. Make sure this does not happen by adding resid as part
of the command information saved using struct scsi_eh_save.

Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/scsi_error.c | 2 ++
 include/scsi/scsi_eh.h    | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1c470e31ae81..d4ac13979189 100644
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
@@ -1029,6 +1030,7 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
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

