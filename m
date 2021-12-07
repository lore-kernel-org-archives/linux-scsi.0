Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 565F5C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 01:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344350AbhLGBKK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 20:10:10 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:30173 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240641AbhLGBKJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 20:10:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1638839199; x=1670375199;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SbfNtO3YKArSv/48E4z1usUS4fmjGaUlyx/z3jf2EUY=;
  b=QI5nNgZeYkM9NkUhnx5JA3+AQaQyKBpArhUnNsEA8PTFUPj96yiGWlFl
   hU7FmUv06wGKZBhr5AOdW/QMT+AeTXlRXr6P4UBu/flPGjblBlF4Iak+G
   zrH1rfphD4lqJQD/B/eLc8Cj49qZhILFV0h3b1pHam0bQ7QbK2w9udn1/
   fNI0Vi5aPeZjSjVoGFnrJSm+5Q9u7GBV3+VVIB9YvqfRnQeoM5rAg0jYS
   EJ7pR5pzv9XWMpOhb2VT8HT7kubpB8rQybe8WPhUYHpK0dgpa3JKlI6ET
   RBJxxdyzod6XWdVumVPGyPfU46NCMb6mY+VxuUCVRjBKnYQ4RTWZzyDYw
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,293,1631548800"; 
   d="scan'208";a="187605857"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Dec 2021 09:06:39 +0800
IronPort-SDR: Yiz+hifXVT0HDnoEq9J1vyFctBYZuBg1hsOIJvwRImhmFVottDYpOop5P5VWNWgkWABizCZesF
 RSAIjFNbFKiXYWhgR1k+Jm02kzGGhf3zK5mF7uCOoCw/qhmqARBlr1CGcdLb4uTa0sTQmEDLI9
 H6Sl+Kdaqt97nsCr/dPPgx9ZUkwC0GDRXAeLbGeRC6toFDKiWxYSUiqZ5KgLKj/r+5EXBpVPnO
 2P4zYPThz819+6rYzVhZF24U7EdlVKwqOYdMqPEm450jWjYiri2C2/1Shv9Ix5JF34mQ6xiaxM
 FPUf8KisKuHkPwdEI2LwdM4Q
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 16:41:16 -0800
IronPort-SDR: BkFrljzY78hU+OJonosaKQsm5wU6Wgn8LDvvKyMY88gKcP6K6MNOO7/DK/3eXFNcv2aqFPQzlh
 OGw9SAdJwiwN9B3UAAIdgI5OPbiPmVjsSQ+6ReOBMBxWvzw80A0VAu4U8nJwkzO8mxDXOLaC0m
 WES9r9RL2BRD0EwWzS5pDdPWRy4H/diLu9KQ8IGWD310IQL3bnxG5uAZDfeSMjDP46Pc392BCK
 y4KtMGdnu9HKwNG4xZtsZMBob1H0GLV7fjq7lz/Htj4HIHb8/kkDCrXpefmsykJnBOtq3Bqw9Y
 u9A=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.173])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Dec 2021 17:06:38 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2] scsi: scsi_debug: Fix buffer size of REPORT ZONES command
Date:   Tue,  7 Dec 2021 10:06:38 +0900
Message-Id: <20211207010638.124280-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

According to ZBC and SPC specifications, the unit of ALLOCATION LENGTH
field of REPORT ZONES command is byte. However, current scsi_debug
implementation handles it as number of zones to calculate buffer size to
report zones. When the ALLOCATION LENGTH has a large number, this
results in too large buffer size and causes memory allocation failure.
Fix the failure by handling ALLOCATION LENGTH as byte unit.

Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
Changes from v1:
* Use kzalloc in place of kcalloc

 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 3c0da3770edf..2104973a35cd 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4342,7 +4342,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 	rep_max_zones = min((alloc_len - 64) >> ilog2(RZONES_DESC_HD),
 			    max_zones);
 
-	arr = kcalloc(RZONES_DESC_HD, alloc_len, GFP_ATOMIC);
+	arr = kzalloc(alloc_len, GFP_ATOMIC);
 	if (!arr) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
 				INSUFF_RES_ASCQ);
-- 
2.33.1

