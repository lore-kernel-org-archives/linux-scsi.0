Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94986C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Dec 2021 12:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243071AbhLFMdK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 07:33:10 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:13780 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbhLFMdJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 07:33:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1638793780; x=1670329780;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Vd8hS2fH16ktrDbGZXSTQLfRjUmLwwkGlb6gaXF4mxQ=;
  b=eiezTsl+SDvYK4H/xXZ6xzinc7aqKJ04ke8afwJ0SJEfu/taiF/noPNa
   Wh6RwNriOx2AKmqfDrIejt4nwyjPHfI+bzpKDqHRWwwoReDAj/T4oMKZj
   EDNFQgm7jKSmS0VThqYjpjoEFO6v2U+q/hdpZKIgZjCAYIdIjljdRWV48
   sttmh/HtTmVN90OqKnuChWJOSmp6dxNZpMq0FD/4+Rp0tscoeH5WyPY4l
   cxGlDRvhdDuUTrzPJuRw9CrZy+ee/ZTQ7MHzn4QQR2DgiULb1SoeAqlyn
   6BqjqatSYH6y291iiGAbRUPXLMXAgtH1oPz5Fp2DpGCNmHAuGXeVsvJQh
   w==;
X-IronPort-AV: E=Sophos;i="5.87,291,1631548800"; 
   d="scan'208";a="192337307"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Dec 2021 20:29:40 +0800
IronPort-SDR: +7B+pGvoDjdmfkTHOE3ZZRMOTfc2dAM+Bx9WukDAPPTWRggnObEJ4fEcsDBJYXal67lFRmcAlA
 6G5WK11Ftb3jnj5AzE7uMIW8EbQ0tucsaVgSn+jkoqh+2bZciNry47yvczs8aYeyZrfuQtpkPE
 kR2xaxhaUSwQ3z4207eo7iaR4bbJfnu2ud/auFblo7oiSkOy3+8EyH0bxRqua/lKWnhY8jVsJE
 epabdQSVrKvYuTIzw5s5L73HwrgVBu7X9gWEBN141tGpXLFzLGdouCV4a0VGwAmr/xntxT2oM/
 f4ubiCcKQG561ERlEEn1GAXf
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 04:04:18 -0800
IronPort-SDR: s1r29rEL211xuHaVi+F+O0Fd8dwxkBL+29wYWPGQlUYf+/oYiDzCSRVkTiMf7zMTrNgNWLjPMv
 yLh37Zd9T4p+sj55hhA1W0qODj6+zt6AZHPtWejFUQjRn6+Klx9XD2DcMB+rx+ROJiGXiYk7av
 UTsQYNplgERkq9l4L3feIp70AaKqqhfUvx5aZRUdvz5mf+xBPxlSuiutpva84FpUlvRoVzEQmn
 p5pu07xJL8Hx0qp+hKgnWX9eQKN0BpWRIkqlzsJfIBlMwL/Jnw71jfpgfMJxm9FKH2OENwFzac
 2Es=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.173])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Dec 2021 04:29:40 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] scsi: scsi_debug: Fix buffer size of REPORT ZONES command
Date:   Mon,  6 Dec 2021 21:29:39 +0900
Message-Id: <20211206122939.105942-1-shinichiro.kawasaki@wdc.com>
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
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 3c0da3770edf..74513129b36d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4342,7 +4342,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 	rep_max_zones = min((alloc_len - 64) >> ilog2(RZONES_DESC_HD),
 			    max_zones);
 
-	arr = kcalloc(RZONES_DESC_HD, alloc_len, GFP_ATOMIC);
+	arr = kcalloc(1, alloc_len, GFP_ATOMIC);
 	if (!arr) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
 				INSUFF_RES_ASCQ);
-- 
2.33.1

