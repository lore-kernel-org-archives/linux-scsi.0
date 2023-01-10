Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7648C54EBE
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Jan 2023 01:55:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjAJBzv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 20:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjAJBzp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 20:55:45 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FF121BA
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 17:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673315744; x=1704851744;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wW+KssJAu8gxTpF6QvSsxjg7SpGp9UJec9248/IUPW4=;
  b=rLn1Nie7njwTIDic6yngvf5kEIZdtwkCdxgFESJAPgh91fqncsWQng2V
   be0qAricYuuUXaglv6jao3s8OPeK3BZ3LPIvIhPjl01njXLGsI9FJjbj1
   7j9VDaz6gqNYagEI95OtEGVVkoKi+8VnZsPo+YivRS//JxCAFwdo3Whvz
   Yye68rx/HibM6XT9lFST2j7O1GVWjFBfEOwWYbedzQzPX1j4+VDwqdU5l
   B/UoJXbB9ptmgaheYvH1i2xSQ1vgLkgj70OizRk94Ud01bnZUEifNvpmW
   VAtFOUphlTOPHXIPYKdl3WAO2dW2dsJeX/qVjmqOb2n/8oyEgtyOqARLU
   w==;
X-IronPort-AV: E=Sophos;i="5.96,313,1665417600"; 
   d="scan'208";a="324698284"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jan 2023 09:55:44 +0800
IronPort-SDR: dzS26NABok8eVEoTV/UdNGx0d1iAvVg8CYW7WoWDodNvq34fcXTFLxbE1+RXDZDYmv2boEVsR1
 7Z0aUYrnO2dP3pae/7pTPh4Z02AJZYBgU/r1E8uQMnwXvhX4PEbpIRHsY4IDWUwf/KoRt358fO
 MUFc85kTimF+TlJ4U68fCBGmrg9bGKGVgPCGvjNx1J5+Io8THyIAGC6d5xuxxy7nVK4NDPDpcJ
 cHKW87AuPlGBW4Ymc5kq41L8MYDl0NGpX5RFNSjKq99qjQqsmzcskdCGjuO9jRlHfrhGlvBneD
 wSg=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Jan 2023 17:07:49 -0800
IronPort-SDR: /STikF90tjRXR0MiaQUdtldNm27j2mB9YkyvOpsxg6X71Fm96pTEDro5/GIU9g5M4kZsgZcEpS
 bYFJK8AMQTpNFNhCBcCWZ3pgsG4mPHG+It9GEdNQLsFLSyj4AqJaawIRMzyEfgcBunsjMSIzrb
 n1tdjqeSQ1zK4b3fwhnwQH/97/zf87niQwuakyoVof5jhwBp58+QxmQWwiaSgPSlEyTLftaIzU
 JGtb6keqeCzzHTpNaqp+QQpOOmrCGzak3xHR3PPkYBHTVfwCc/Fd9MR5tvbe0+QJdHXk5OrzRQ
 n/k=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 09 Jan 2023 17:55:43 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 3/5] scsi: mpi3mr: fix alltgt_info copy size
Date:   Tue, 10 Jan 2023 10:55:36 +0900
Message-Id: <20230110015538.201332-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230110015538.201332-1-shinichiro.kawasaki@wdc.com>
References: <20230110015538.201332-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The function mpi3mr_get_all_tgt_info calculates min_entrylen which holds
the valid entry length in alltgt_info. However, it does not refer
min_entrylen when it calls sg_copy_from_buffer to copy the valid entries
from alltgt_info to job->request_payload. Instead, it specifies the
payload length which is larger than the alltgt_info size, then it causes
"BUG: KASAN: slab-out-of-bounds". Fix the BUG by specifying the correct
length referring the calculated min_entrylen.

Fixes: f5e6d5a34376 ("scsi: mpi3mr: Add support for driver commands")
Cc: stable@vger.kernel.org
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 239cb5e07b24..3b4ae044f4c0 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -352,7 +352,7 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 
 	sg_copy_from_buffer(job->request_payload.sg_list,
 			    job->request_payload.sg_cnt,
-			    alltgt_info, job->request_payload.payload_len);
+			    alltgt_info, sizeof(*alltgt_info) + min_entrylen);
 	kfree(alltgt_info);
 	return 0;
 }
-- 
2.38.1

