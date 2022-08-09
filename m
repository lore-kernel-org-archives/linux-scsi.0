Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC0EBC25B0E
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 00:07:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244690AbiHIAHG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Aug 2022 20:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244655AbiHIAHA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2022 20:07:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D241A3AC;
        Mon,  8 Aug 2022 17:06:55 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278NwfQ2031102;
        Tue, 9 Aug 2022 00:04:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=HWjUi3x3pR0J2NI56B5LRU2aUiMppOApsNHBsj0Ha0Q=;
 b=gtz9QEdsEHYoMEx+qRGiD9xASUxx6jCQlgSvBdTHB5S8vF7GmbUD9CRcYHwXhUKtnXhn
 J4C0x5XYjndoE5hZnj6yAXi0xXv2/8N10zwJm3YFf2LKZPCK0JWmc9C/dh69tts6sS5p
 3OtdndKuZcEshuVbT4wPICSJljir6t7Ep4BCpzhPJ3kMTTBJ0ozDhvzSHmhTpavFlPTY
 8LQL5b3DHRM/NHZug1oekujQmQiJSReSkUq8voahmlByvy4mYvysDLfi5H7poWRpIlEo
 SMkCJVIovFt4a06Trc6PzAIN6H7wjn/A3cMQ9xEOvagOSnRbEgInpjUi20UwKPWyY38+ SQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsew155he-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:43 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 278M0hHn038083;
        Tue, 9 Aug 2022 00:04:43 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hu0n32vm1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWNa/XVtrqH30K+6ut4iLIXhdPe/V9QcKOfIkk21UwsIsPtk3eeQy5/jfRCFhq94OOCYW2eR1DaMvsZuJlCk9izH/jaLGIOzRFWZbRlmup502QJg7xJyn/y+AVs2aafd3Znb1/X53wTko7Mqf9KArkNUVdBiTsV7TH51A4sgPidCpBSd2ZX8Ek1lQ65EMauWcNohHl98xX75K6e8UvQueJ2rxVGd8VCRCcoG/XcYUhVoh4PF0r6GwUDyz+zY16rAKDa0jBXUxLUaqUT+cU0cnp+nYEl2DusWgruSXA1XLJykou/WgoOqZj/ZifSdZbuKMh8bIxSSBdMVIiRK/DHotA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HWjUi3x3pR0J2NI56B5LRU2aUiMppOApsNHBsj0Ha0Q=;
 b=WvIItg5fxVZoBi+3KPaXgzyHC0QE/kOX7LXzXgAdQY8wDM8wMMpwYJ6XrrbVz7s9kiPl/joYyhqNw6ZqHUOr0/mEh54sTzm794IjfxSdHcAnkCV5xEDQF++1u+5HnNbWPM3kOHJVS1XAckLIZQ/h4RPLQOtGbn3JRZhJ5oMKwKtt4Wn/PoNgoNe3sEdzrbNkyN7BgH8Xug4BX4OJXJsYl54hOFB25vLkuqriurZz++pOWAwtz9QX1NGdD9czgWeauw8S2sH1FKWEtniH2ZKqIuvMRybUAW5GpK9j+1n1IzEqCOcbWYcCh1YHBO0hOgmqwaEevIoZXewXyhfKHpWmiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HWjUi3x3pR0J2NI56B5LRU2aUiMppOApsNHBsj0Ha0Q=;
 b=cCmlNl9bcxMkeFYLw2yU8denz3+LaZaYRoWt2Cw9rhFKrHpM08jLKA/FcjP/ml+MoZM1CTLBDC6J5cr/q9AWwbVdsYkMfGnFwbR0zfF3bS1BZcs8JLL2AH+UDCCKSQXHdASh6nqy6e6F33Rccc+VcvFOxFSzyVZZO5J3W8MgzOE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB4907.namprd10.prod.outlook.com (2603:10b6:610:db::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:41 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:41 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        hch@lst.de, linux-nvme@lists.infradead.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 13/20] nvme: Have nvme pr_ops return a blk_status_t
Date:   Mon,  8 Aug 2022 19:04:12 -0500
Message-Id: <20220809000419.10674-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:610:59::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e269e834-feed-46e8-b865-08da799ac216
X-MS-TrafficTypeDiagnostic: CH0PR10MB4907:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /gBU3888B5l9SwWMOsjgyf47OE5b2UVx4IDjQUk1Aumpw+EWIKegXNblHnII542wERDv5VZuQAeozpCYhuW0haiL36K2MOJcmQ4WdzZVJZHQIWCRHSY8Y64Aele5OzcY+/wuK32B4jMJG87G5PT7JKs2tTJWIyM4W4rJGHZLowvegrz0pYfImyxJ9feT5rK3zkC1gRX2OjwPUi2fgN990bz82onL8KBtTPSmu/pPWzQDyDw9zCl1H1FrsviLCnB6L1M2S02C2RM81agCHwGhIfsSri+mDqvSwr0p0/fmZAMszEHLQEKFFa/CABhQ3pQ5eZO2adoanoit5Kvn9ihJzr07F3ZYm6zfmHEfqOP/SMZ3le8G0bfYgI/uL75+hXFmFxkQFatRsYxgkzQ3QFeXAvePMVMwG6SAPNUeHcXqdxKER0C/iwEBgfYFWgf3RoyMxCy5cRGG7hq/ietMXWcYeVjOHV8Mfyxl/bkPBzH6uMgZw+ykLqSkAnkTQnHUTt1tgfFW3hq5+iorhHHuFuePEn4BMpBjM+YHFAjgMBmlb5FZgfgHWDWbtb0M7yDcwCZsSuKz3NPuPwgymt+UtMQXLyDsMK5M4F9yDGVdZ969DIYDSK3lIZTc06xKCEDfU9CwQenE5/Nf7X7E6IboJ9c1OSoVpNGWa7Y7Ykq93RYdfdEBMdyS0ZbW62BJhTE6zDEMUzHR/Goyjtl12p59KZrwMGQFuyahvhsw/X+W4LfUd3qcPTPxpzUp3EePaOzLzuYDlbHZBhasLqjZKPbek5dHRUqsa0oZ+V//p1AFdCKFBUA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(136003)(346002)(376002)(39860400002)(921005)(6666004)(41300700001)(6512007)(26005)(2906002)(6506007)(83380400001)(2616005)(107886003)(38100700002)(86362001)(186003)(6486002)(1076003)(316002)(66476007)(66556008)(36756003)(8676002)(66946007)(4326008)(8936002)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+HyS8pSGXQuNg4Bi8v9joHGp1owqfy7JjY6ruZLC4Tf/zX4L2mvg74M0tdkT?=
 =?us-ascii?Q?kgKSPWF5RzOj5gXON2Cr1dRQtO7rH+1I5zLqRUig/3YGUtxA6QFUUgPeb1RN?=
 =?us-ascii?Q?6ac3qutbPv5SkydiANu9xPtcPE3uh37Hg9iqcw3S2HtB8UN8cgmo48m0M02j?=
 =?us-ascii?Q?0Miaims6/kxn7JRlUW3ty0QiXZP2bjtlA7Qkh6vw1icACbHyvmY9C4eNY00W?=
 =?us-ascii?Q?JL7ojYHSHsaFIB2thOzoANgiKb1TmQalddcmUTMre9iBluiVZkjDFPcbg4Wr?=
 =?us-ascii?Q?dHlV8NWTo2WRI/Tt6/8UrJeIFkXxqIgf1TCUkcynPcR7fxpGhYFWKcseqlR0?=
 =?us-ascii?Q?3SCv+2jlLslPcOiN+/CvVwk6W35cCj1mMAX+Yif6TwfIEvpxm4de54Vz82Ju?=
 =?us-ascii?Q?H05L4N/ImaMazDZVYlqA18HykxnHi6Ok59vFzSmyCIlyMQIqCpRnhgRI5me3?=
 =?us-ascii?Q?k+IbC+LX/7drKEraHevk5ExiSOOMonWTlB9AAHlJspOSNokF+KUpsQM8GdBj?=
 =?us-ascii?Q?o+1434j3kEAutM8op/VusGvB3ORfbaenADPK2vxeRMB7z5qY2bzPi6TK3jve?=
 =?us-ascii?Q?UGjCar5oCBTiTbUShUKn8qjzMW+GE5MAWC1KfQgbgfQpYqOoRXZq0gqBKRfm?=
 =?us-ascii?Q?hB4s5lcfJ+NIYLNGs5ZBVZWGA6Z1PoHE4YQvKD3QId3hLJob1kz9kpW3jb4T?=
 =?us-ascii?Q?is5E50vivmx9aztOfBIoL3V0DOD3An0TlIQJy2IkCtuRSn2bn2+6sfVtCHK1?=
 =?us-ascii?Q?SSmAH3/+YIFy1Ho9Di5wbDO2dc7bPcWlSp4c/QMMd5WRzFriK/bjZSNpr36r?=
 =?us-ascii?Q?Iwh7seqGG5liewvnoygqEoZmZD3dD5w4bIGmZFf7Syde7QKOr+liKRzqC5H1?=
 =?us-ascii?Q?/Djl+TpgSw4zVeGf0GoOnEBr7cU8RCtaZ3iDMG5W+ovV6M57xldo/ZdVqwpF?=
 =?us-ascii?Q?dCtZeQ8PyLpJtY7u54k3CB6d81r2noGRwgWPRtsC9/HVPnCsYxtSDDgeffia?=
 =?us-ascii?Q?PDSct8GaHtLGPYpHptuk+SkYjTKHDst4Wl4zoJtF4m8jv9CqKYxiqe5GTtwC?=
 =?us-ascii?Q?jQtsglEPHDOH7A2KFImmPP1939AL0BB/hcA0mtgb7wMFSR9slyKnvWnQB/P3?=
 =?us-ascii?Q?4Tio6alaOcaBHe8NF6ggRgFYrdIdTmfqC6gTnjXUN68DA272iCMBx/Z8joUM?=
 =?us-ascii?Q?FMKw26miK2sjD/59QgT7FjGaEFnXc6pqxOARC4hGY/nPwPeyl4rtSA43H7ya?=
 =?us-ascii?Q?5mlqoregiHQTN8ie2jK9a9O8iWuB5mRXXhCKIG6PLxB7nbTaDSh4v2pU0Lid?=
 =?us-ascii?Q?r1mgdcJ6ziNvhqz66B35rFt/dn+hpoN5biTf/AywHXfbyJx2Gy/z/P5UdufN?=
 =?us-ascii?Q?doUnxB/TxCs1vZ9iDe6kTaeqHGTXjooZw5Og9OHmok+ON4CqY1ZbQDEArUYB?=
 =?us-ascii?Q?O3baum+pjmL9Qftm4pAU0rUpgvPNfjPXoTpZ95Y+tLW5uDl35AA5LZP+Qeli?=
 =?us-ascii?Q?UCc4AgBjrlQl8Ik3dA0zciYd6NYo2noQXYfE31PUAX1SvTK+bckP0JL/JGdf?=
 =?us-ascii?Q?TPsJN2fslaru6VuQBD49u8A0XjIK6WqXrtFudsY7+E26+HqOxaiMhVx1bqcK?=
 =?us-ascii?Q?+Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e269e834-feed-46e8-b865-08da799ac216
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:41.5946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /fIZWQSPZxJ09X568Uh5tLLOvZ7lM/kqp+WUvIxZdS6igrm1bg9Ey/wpP/he8PSTp7SNAiewnT/Kl1pfL98GSgOAzgDFUanpdz99RSetTwo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4907
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: iyKs7l8dH-6h1VKOxmJ8RCxmKHj35kHJ
X-Proofpoint-GUID: iyKs7l8dH-6h1VKOxmJ8RCxmKHj35kHJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch has the nvme pr_ops convert from a nvme status value to a
blk_status_t.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/host/core.c | 54 ++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 18 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 49bd745d28e2..46188b3d9df8 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2105,7 +2105,8 @@ static char nvme_pr_type(enum pr_type type)
 }
 
 static int nvme_send_ns_head_pr_command(struct block_device *bdev,
-		struct nvme_command *c, u8 *data, unsigned int data_len)
+		struct nvme_command *c, u8 *data, unsigned int data_len,
+		blk_status_t *blk_stat)
 {
 	struct nvme_ns_head *head = bdev->bd_disk->private_data;
 	int srcu_idx = srcu_read_lock(&head->srcu);
@@ -2115,20 +2116,28 @@ static int nvme_send_ns_head_pr_command(struct block_device *bdev,
 	if (ns) {
 		c->common.nsid = cpu_to_le32(ns->head->ns_id);
 		ret = nvme_submit_sync_cmd(ns->queue, c, data, data_len);
+		if (blk_stat && ret >= 0)
+			*blk_stat = nvme_error_status(ret);
 	}
 	srcu_read_unlock(&head->srcu, srcu_idx);
 	return ret;
 }
 	
 static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
-		u8 *data, unsigned int data_len)
+		u8 *data, unsigned int data_len, blk_status_t *blk_stat)
 {
+	int ret;
+
 	c->common.nsid = cpu_to_le32(ns->head->ns_id);
-	return nvme_submit_sync_cmd(ns->queue, c, data, data_len);
+	ret = nvme_submit_sync_cmd(ns->queue, c, data, data_len);
+	if (blk_stat && ret >= 0)
+		*blk_stat = nvme_error_status(ret);
+	return ret;
 }
 
 static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
-				u64 key, u64 sa_key, u8 op)
+				u64 key, u64 sa_key, u8 op,
+				blk_status_t *blk_stat)
 {
 	struct nvme_command c = { };
 	u8 data[16] = { 0, };
@@ -2142,9 +2151,9 @@ static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
 	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
 	    bdev->bd_disk->fops == &nvme_ns_head_ops)
 		return nvme_send_ns_head_pr_command(bdev, &c, data,
-						    sizeof(data));
-	return nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c, data,
-				       sizeof(data));
+						    sizeof(data), blk_stat);
+	return nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
+				       data, sizeof(data), blk_stat);
 }
 
 static int nvme_pr_register(struct block_device *bdev, u64 old,
@@ -2158,7 +2167,8 @@ static int nvme_pr_register(struct block_device *bdev, u64 old,
 	cdw10 = old ? 2 : 0;
 	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0;
 	cdw10 |= (1 << 30) | (1 << 31); /* PTPL=1 */
-	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_register);
+	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_register,
+			       blk_stat);
 }
 
 static int nvme_pr_reserve(struct block_device *bdev, u64 key,
@@ -2171,7 +2181,8 @@ static int nvme_pr_reserve(struct block_device *bdev, u64 key,
 
 	cdw10 = nvme_pr_type(type) << 8;
 	cdw10 |= ((flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0);
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_acquire);
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_acquire,
+			       blk_stat);
 }
 
 static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
@@ -2179,7 +2190,8 @@ static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
 {
 	u32 cdw10 = nvme_pr_type(type) << 8 | (abort ? 2 : 1);
 
-	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_acquire);
+	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_acquire,
+			       blk_stat);
 }
 
 static int nvme_pr_clear(struct block_device *bdev, u64 key,
@@ -2187,7 +2199,8 @@ static int nvme_pr_clear(struct block_device *bdev, u64 key,
 {
 	u32 cdw10 = 1 | (key ? 1 << 3 : 0);
 
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_register);
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_register,
+			       blk_stat);
 }
 
 static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type,
@@ -2195,11 +2208,12 @@ static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type
 {
 	u32 cdw10 = nvme_pr_type(type) << 8 | (key ? 1 << 3 : 0);
 
-	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release,
+			       blk_stat);
 }
 
 static int nvme_pr_resv_report(struct block_device *bdev, u8 *data,
-		u32 data_len, bool *eds)
+		u32 data_len, bool *eds, blk_status_t *blk_stat)
 {
 	struct nvme_command c = { };
 	int ret;
@@ -2210,12 +2224,16 @@ static int nvme_pr_resv_report(struct block_device *bdev, u8 *data,
 	*eds = true;
 
 retry:
+	if (blk_stat)
+		*blk_stat = 0;
+
 	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
 	    bdev->bd_disk->fops == &nvme_ns_head_ops)
-		ret = nvme_send_ns_head_pr_command(bdev, &c, data, data_len);
+		ret = nvme_send_ns_head_pr_command(bdev, &c, data, data_len,
+						   blk_stat);
 	else
 		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
-					      data, data_len);
+					      data, data_len, blk_stat);
 	if (ret == NVME_SC_HOST_ID_INCONSIST && c.common.cdw11) {
 		c.common.cdw11 = 0;
 		*eds = false;
@@ -2245,7 +2263,7 @@ static int nvme_pr_read_keys(struct block_device *bdev,
 	if (!data)
 		return -ENOMEM;
 
-	ret = nvme_pr_resv_report(bdev, data, data_len, &eds);
+	ret = nvme_pr_resv_report(bdev, data, data_len, &eds, blk_stat);
 	if (ret)
 		goto free_data;
 
@@ -2286,7 +2304,7 @@ static int nvme_pr_read_reservation(struct block_device *bdev,
 	 * the response buffer.
 	 */
 	ret = nvme_pr_resv_report(bdev, (u8 *)&tmp_status, sizeof(tmp_status),
-				  &eds);
+				  &eds, blk_stat);
 	if (ret)
 		return 0;
 
@@ -2302,7 +2320,7 @@ static int nvme_pr_read_reservation(struct block_device *bdev,
 	if (!data)
 		return -ENOMEM;
 
-	ret = nvme_pr_resv_report(bdev, data, data_len, &eds);
+	ret = nvme_pr_resv_report(bdev, data, data_len, &eds, blk_stat);
 	if (ret)
 		goto free_data;
 	status = (struct nvme_reservation_status *)data;
-- 
2.18.2

