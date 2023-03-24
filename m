Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C408DC76195
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Mar 2023 18:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjCXSSc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 14:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbjCXSSR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 14:18:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D7E7A9A;
        Fri, 24 Mar 2023 11:18:14 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OI4JjC024400;
        Fri, 24 Mar 2023 18:17:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=+YR6ISocQSUB00W35K8+OWOv3YgeAE+D53xlwD5jtaM=;
 b=UlzxpFwU5D3w6eDIAzWtC7L9gJxmOuOldrPuV0kHLprlMfz7YhS/vPK4ZP3D+O3McIcO
 r6xitN1ppu+9PS1aV5K21byZSLrbrDKX38stmqgDfvHhuibZyuGgSrgX3S9Zg0+jDtTh
 S1LljJLwyyMjyxGHqmrx7heq9CHD6wCovNLxCwR74U2PUnJ28BWd4v4a+kaDGavf4s63
 26GrjXLzfvlj4kQInsqVuU5JnXL9R+c7u+7qoJN59Q0cU5Q+77eLOMESs1EUqgBb8Pdh
 SC5SXfTad352LtLSBtedFg6zpWIiNebkXclR5T9KxqGy/otdTltYGIwHAuGsj/EZfO3o Nw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3phgtmg0ye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 18:17:53 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32OGVhD1001433;
        Fri, 24 Mar 2023 18:17:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pgxk4bx69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 18:17:52 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OIHiEP021017;
        Fri, 24 Mar 2023 18:17:52 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-153-54.vpn.oracle.com [10.154.153.54])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3pgxk4bx19-4;
        Fri, 24 Mar 2023 18:17:52 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH v5 03/18] scsi: Rename sd_pr_command
Date:   Fri, 24 Mar 2023 13:17:26 -0500
Message-Id: <20230324181741.13908-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324181741.13908-1-michael.christie@oracle.com>
References: <20230324181741.13908-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240143
X-Proofpoint-GUID: ADObLYIwGyF7tHUWWIJ965hhsUAe_wf7
X-Proofpoint-ORIG-GUID: ADObLYIwGyF7tHUWWIJ965hhsUAe_wf7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename sd_pr_command to sd_pr_out_command to match a
sd_pr_in_command helper added in the next patches.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/scsi/sd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4bb87043e6db..00b9b6145fbc 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1742,7 +1742,7 @@ static int sd_scsi_to_pr_err(struct scsi_sense_hdr *sshdr, int result)
 	}
 }
 
-static int sd_pr_command(struct block_device *bdev, u8 sa,
+static int sd_pr_out_command(struct block_device *bdev, u8 sa,
 		u64 key, u64 sa_key, u8 type, u8 flags)
 {
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
@@ -1785,7 +1785,7 @@ static int sd_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
 {
 	if (flags & ~PR_FL_IGNORE_KEY)
 		return -EOPNOTSUPP;
-	return sd_pr_command(bdev, (flags & PR_FL_IGNORE_KEY) ? 0x06 : 0x00,
+	return sd_pr_out_command(bdev, (flags & PR_FL_IGNORE_KEY) ? 0x06 : 0x00,
 			old_key, new_key, 0,
 			(1 << 0) /* APTPL */);
 }
@@ -1795,24 +1795,24 @@ static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
 {
 	if (flags)
 		return -EOPNOTSUPP;
-	return sd_pr_command(bdev, 0x01, key, 0, sd_pr_type(type), 0);
+	return sd_pr_out_command(bdev, 0x01, key, 0, sd_pr_type(type), 0);
 }
 
 static int sd_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
 {
-	return sd_pr_command(bdev, 0x02, key, 0, sd_pr_type(type), 0);
+	return sd_pr_out_command(bdev, 0x02, key, 0, sd_pr_type(type), 0);
 }
 
 static int sd_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
 		enum pr_type type, bool abort)
 {
-	return sd_pr_command(bdev, abort ? 0x05 : 0x04, old_key, new_key,
+	return sd_pr_out_command(bdev, abort ? 0x05 : 0x04, old_key, new_key,
 			     sd_pr_type(type), 0);
 }
 
 static int sd_pr_clear(struct block_device *bdev, u64 key)
 {
-	return sd_pr_command(bdev, 0x03, key, 0, 0, 0);
+	return sd_pr_out_command(bdev, 0x03, key, 0, 0, 0);
 }
 
 static const struct pr_ops sd_pr_ops = {
-- 
2.25.1

