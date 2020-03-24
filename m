Return-Path: <SRS0=zrch=5J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57FC3C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Mar 2020 15:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B1B720774
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Mar 2020 15:50:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vyCLMxsm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgCXPuA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Mar 2020 11:50:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53868 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbgCXPuA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2020 11:50:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OFnDc1141498;
        Tue, 24 Mar 2020 15:49:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=GicSy3c2iWgzistQTNRNF7Jq/HJK4u2N+F2RC2dFlbU=;
 b=vyCLMxsmWaPkG98eG7UYv/y3MbYlOYnTMp33MXSrpKyFXQm66MBKKj5kNZpNcx4TnjDW
 XS46jNYER3aHO+A6wOTZmisMhQx7xJeVPIFjLCvDdrDoHNfGdm/Odjz8uvZxFkSunatQ
 EVY3adss9Zlm5mJmJM8tLmFcvpeW5Qtk7cKwGrrDJ7v6gy+n5bRYk8wQMDnHoOF9O/HA
 0anbBWrVN8IfeDn9rVk8QTB+Fgk07KFXpLcdsSeTkaFia4GHjfUFPf6NO/jovZmcN/WP
 cAkEU/iAX8sHSOhIn3vTPdh9pKGHyBAtfvSFmOVlQqXWElrboE7p4FoXQUht/L/EdJuv 0A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ywabr550a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 15:49:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OFlrcd182872;
        Tue, 24 Mar 2020 15:47:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2yxw92v9gm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 15:47:55 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02OFlmDQ013618;
        Tue, 24 Mar 2020 15:47:48 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 08:47:48 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bryan Gurney <bgurney@redhat.com>,
        Bernhard Sulzer <micraft.b@gmail.com>
Subject: [PATCH] scsi: sd: Fix optimal I/O size for devices that change reported values
Date:   Tue, 24 Mar 2020 11:47:47 -0400
Message-Id: <20200324154747.29295-1-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <4f6eb89d-57e4-a229-2e95-29fe4a691381@gmail.com>
References: <4f6eb89d-57e4-a229-2e95-29fe4a691381@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003240086
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1011 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240086
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some USB bridge devices will return a default set of characteristics during
initialization. And then, once an attached drive has spun up, substitute
the actual parameters reported by the drive. According to the SCSI spec,
the device should return a UNIT ATTENTION in case any reported parameters
change. But in this case the change is made silently after a small window
where default values are reported.

Commit a83da8a4509d ("scsi: sd: Optimal I/O size should be a multiple of
physical block size") validated the reported optimal I/O size against the
physical block size to overcome problems with devices reporting nonsensical
transfer sizes. However, this validation did not account for the fact that
aforementioned devices will return default values during a brief window
during spin-up. The subsequent change in reported characteristics would
invalidate the checking that had previously been performed.

Unset a previously configured optimal I/O size should the sanity checking
fail on subsequent revalidate attempts.

Link: https://lore.kernel.org/r/33fb522e-4f61-1b76-914f-c9e6a3553c9b@gmail.com
Cc: Bryan Gurney <bgurney@redhat.com>
Reported-by: Bernhard Sulzer <micraft.b@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8ca9299ffd36..2710a0e5ae6d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3169,9 +3169,11 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
 		q->limits.io_opt = logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
 		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
-	} else
+	} else {
+		q->limits.io_opt = 0;
 		rw_max = min_not_zero(logical_to_sectors(sdp, dev_max),
 				      (sector_t)BLK_DEF_MAX_SECTORS);
+	}
 
 	/* Do not exceed controller limit */
 	rw_max = min(rw_max, queue_max_hw_sectors(q));
-- 
2.24.1

