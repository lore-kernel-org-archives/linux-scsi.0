Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E8CFC00144
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 03:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238383AbiHDDlz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 23:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237313AbiHDDlk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 23:41:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA93D5E32B
        for <linux-scsi@vger.kernel.org>; Wed,  3 Aug 2022 20:41:26 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2741iE9M016167;
        Thu, 4 Aug 2022 03:41:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=1f8YiS0IHoRRtVmR1UbpvXATYaGv660LunomVT9647g=;
 b=PbVTcZF8hGb8v2MFFTUlI9RcO0hMdFGqPnhSRb6UnzuY/19x6mm6t5ZCmHqD9gn9kOIT
 00Gwr0NBiJ8k3B4TBMSKcdasd4lfKGGH9ZZLD4VMOUsu7wkRM83bJUFLBIHO7wmbbt7V
 7/1FNF36iN4068vIKckYiWmwAOgfPP23vwLIHwzvXRonnTcWFUlUKETJVnak2vku711A
 eEn3OA90jxG80kvNkkb+N5/q2FVNdp6Ta6H81gsSvTu7i9FT/VrdLy52jW0vkIOkQ13G
 PgP2zHFkVArCf+RkNzEgb9SYacbKtvifP2Yki1LqQt6qjpXN8xhswC+b8EI3cr3+Qlqv QQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu813nkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 03:41:17 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 273MYThk031021;
        Thu, 4 Aug 2022 03:41:16 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu33w896-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 03:41:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MC8lCJ+1WommQ4O9YNIJ0MXij0UKIhU00ypegkyrnM2H1rbXrKeJNdxunjZ+gw3HPUvD+DGInc2VgWBm8JmQl5nx3z0NR4aoc+ZPkE+0CvclO6Sar4uQ6h+++lp+AjfhiojEP0rleyM89lvt86hKrOwFgsateUdsLO6H9AXaIUIDNu1IES4s/zLb+jYVT7y8HAzt/zV4H/cvqRK4xn84WwRx4GxrWz/7BqwynGovMDkC1ZV1H0t+XQv5BOgxh3rlKXGQ494hBFDE3Q0q+fV4Om5x/+wLd7XUJsC5kwBB3qplprnTlSCAA+X2PE2D252w/70BMTNyLch9QhVNBKcx/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1f8YiS0IHoRRtVmR1UbpvXATYaGv660LunomVT9647g=;
 b=FHF1u9hBkEVsM24zu3lGYqeW1UlQYcnii5bVmapmKNfjcCVUntpSlYMYBjvFQuMlp85lG2AYKtE7Z/yhPafn49sBKG06RKuLiZGLlGLjBf/svX4AEP8V42Li3IOR3r9gWNcsZXa7bUUL4MStLvET6QolZLnLGfkRAIaQasToKbMe75KkvAZ7IyPqwMqQjJV4E2GRpOCFzENunRuEqmGsfKt6cII6wDExdb7vEuTG0cynM2nM+v0ZxEBngIhzmkLz7NP5dqQULEzz9b9f+0Sjc5dyMuDcPhbR8uik3yQR36pKzZ1uccStS+cWG+l6HZJFSH8fil4XUmaHbjWjKt9Pog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1f8YiS0IHoRRtVmR1UbpvXATYaGv660LunomVT9647g=;
 b=LibufsgLRFJSEVKhTIM8SpbtpMnTLYHHGu/13RUNQIeZ4pWmReG4kfBuXUHY8TZRHMC/wv/g/0kQRqv1vQk03B3yFj5DMRtoTBZsQ/2D4FP9BJuIPwaALYW32U6AyUMfUYIRhNvFOfqNPTQh4JYmQx37AHRotJIsTPrNvuC1C3Y=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM4PR10MB6037.namprd10.prod.outlook.com (2603:10b6:8:bb::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Thu, 4 Aug 2022 03:41:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 03:41:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, manoj@linux.ibm.com, mrochs@linux.ibm.com,
        ukrishn@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 08/10] scsi: Add error codes for internal scsi-ml use.
Date:   Wed,  3 Aug 2022 22:40:58 -0500
Message-Id: <20220804034100.121125-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804034100.121125-1-michael.christie@oracle.com>
References: <20220804034100.121125-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0392.namprd03.prod.outlook.com
 (2603:10b6:610:11b::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b35a2ced-06e5-4c5e-aac2-08da75cb2e54
X-MS-TrafficTypeDiagnostic: DM4PR10MB6037:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H0ynLu2cf+aO+0IjHr9b3SvkiYCvOyiZMZdHMuTdzXUmrL+wA08IWQpKo9D6vbeV8pTS7nU5uYCi0jRcMRfWIRAN/Y44dvsQ8q57n1jiZEyh9DBFcwv1cVA797T+qDV+Komh+hzqUg2rI9cw59NDuqlIag4HmCj7+T1UuKcjau2XUJRwIdKYZVgV1cpZKOy1pA9ZC72GTT44s2ckU30biBWmoYa+UcJnKVoLEj6ezucP09QhxArbGz9o+t7x4xVknAauD8AvlodUkqY+E91nLSIP1BvrlUmQeoXFlU8LVAPE3Ll4dfBcefF4gKln5iOz1oycMWMAbeg3pmxAK9rAG16KbdZvK0AnxlqubV1Lib32ZtImTF6sy7yMXr3Hl5Vf2JHc6e0BVSRsuPuNEOwqKDMby7vwAXgryqoDwXdLy8qpsckaAhq94nP1FeK9OhZtyj929G/erUp3fZBW/ZM+Yj9gtneO4dt/ZbK/IyV4UvDDPYLzt4HRkvC/+RNdUo9CVmc7w8y+Ml2U2MOpe8g9wYxVkvDEMks6jytmaJ0QVe8T21w9qNr945Aac6jRX9+0HVvyfu75pNDzR3F38fis0IBm6eW6iA9R28lxDcTIvKakCSF4/S1SIkoSroaVCvozdigs9kKdGGoAupMt8arAk/pxmF1t4GDYXevr55WVxV87hzkvfW7XU3XUuWeZamQy4b+70uK47fp0Z2u2ntQc5bSAh+uwG+rqp2mxubgVZ3EaklXVafusHWUh3j5+PbSZmE34TOvgHmsUfqSS+0sylV0xfJ+q/1QxiQ0DhPc7b6c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(346002)(366004)(396003)(136003)(1076003)(107886003)(186003)(2616005)(41300700001)(6666004)(6506007)(7416002)(36756003)(2906002)(5660300002)(478600001)(6486002)(4326008)(66946007)(8676002)(86362001)(66476007)(8936002)(38100700002)(66556008)(921005)(83380400001)(6512007)(316002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fWwBKcgW1D2DL9zTcb/LMnUAqCiBL/f68O13KglPr72JXp1pwKf/oqr8AxDx?=
 =?us-ascii?Q?wCFTKzD1DTwlJfAred3eWDYtJjx7jt53rmLRVjjv+8kThgqDdA1sPhTSzp7W?=
 =?us-ascii?Q?tQ2MAoO42Awwp3tYXTTcQrlXMVLZaAufONo6IPdt9cUMDip5bbqPbx2zUYAM?=
 =?us-ascii?Q?OIbnvfT0M1Nxv0970ig3YOr5ldwqyfwBUDx7ID5DrkuDiTkfpTwoQLFIrPX4?=
 =?us-ascii?Q?4UnQKgcK3QueGPIMJ0c8OMPRpNMxlAiKGcRxjOuJV5AbC8NUpqu5ydz6bJWn?=
 =?us-ascii?Q?t4yQSJMyWwHsfbKtr6z3mtjwLL50wYgNL78sJJa1nqb9rTeLKqSEojlkiWU4?=
 =?us-ascii?Q?P2N1hTTL3QlnahfULCbDEekG3ll/kxnw57JLjL9L0aCP5EhFfJbTzCkeMEzo?=
 =?us-ascii?Q?jAXchbmNLBL2jIXzA5P1Z4IUB6ZBL7792dMoqh4QQpDIFtpZMql7N8rQnA0N?=
 =?us-ascii?Q?gzwBrzUnb0ZNSxqyVfkO+oahiXgAlLCtAtugKudzz0KP7n6HGLFjOtN+4UqS?=
 =?us-ascii?Q?f9pIXwHmEw9Nw6CKBWoNBXLoF/CaVVlKyuyNghu1LU1qUncHdwUgFm4Z7zFu?=
 =?us-ascii?Q?LE96O4BHS0ELYpESuBgAwtXO9M5VOG/d10VOZMu2mFaFz7JG0B2evooe8rAX?=
 =?us-ascii?Q?Ak8r6bYN79XPzd8E/fOWzBCDadPB44QBs3HqgOUoQTww78D6/SWXGMm7FH3w?=
 =?us-ascii?Q?Ttkzvj0bomDZr/Cak3Ns5zq7mAT7MahZANazTkc3+ERzWJP8dA7dsf3kHj8O?=
 =?us-ascii?Q?BZ/Ss0mWlCGZ4P8O7R9hLQRQpU8tHKv62MgpQko8QnbsVz6z6GFst8d+1Qwt?=
 =?us-ascii?Q?9A+wkgusU9Xv+GW3pvQrt9JLzoXIOP0gnzhtD1vttkFx/AfN7ThaORTeHT8b?=
 =?us-ascii?Q?iaAe0rwBK3JFvsZ13T1M/cM8r0MxY0ckjw7TwpMH/Am1mN414xQVvKWBN697?=
 =?us-ascii?Q?UzXQVdCN2tOaoISr1Fum8s0U+pV/xZP0E+22Jpi34rg6YeC7omj2SdqIQVFl?=
 =?us-ascii?Q?okNY/Es4wUypQ/5TGSiOnku+Ul4yqF/z/F9ND/5diIOcmQgNLtOmHgAQqzOB?=
 =?us-ascii?Q?kG9Wbn9UNR+2W+FXRMbTtMJhCjr/tQwToZaL+FpP42WfH6iRUnyex0qYedad?=
 =?us-ascii?Q?UEoWp5+Mox0LZVIdm/ckR7fVCY+PCAAuX6AszazjRPgw0h6RGOG9hk54d+JW?=
 =?us-ascii?Q?U5seaXFrwhl5suVRrb10R5fgWQcJ/ik8xsfwtzDBoRxmim0V6ec9v5gu/N/7?=
 =?us-ascii?Q?LQcAiDs+xs2/j1bSsn/+cDL3KRu6F2c82f1xDOWfW/cg1jeiTre6NrQxjgvc?=
 =?us-ascii?Q?G4ckqVqTIHjN4yFARfzkNAh3KcUzYru9rJuXNQ/CUPEAOb47HoZrFdptzGx4?=
 =?us-ascii?Q?yCTyE/5jS0DzYGkjnhbmKiQx2Hx4NSOdNUlSAdCBSbaZ8qphYkpf9iv5+wAw?=
 =?us-ascii?Q?UxrdaAlgNPii7c4yAD0lTYuc6RuKYxogIBRxmgygu5VblJ80RLWL2uX+4CjV?=
 =?us-ascii?Q?gRrO16h3c+osDrempbeQ/6yss0G7638fY17PNA6khzWi60ga8oHkUxLgIUhP?=
 =?us-ascii?Q?zckzxzp/WnSSBaxmnzw+eCW4H+0iIUdZ9aVnTGQmUn6TJB8gndNpbD3lcDqv?=
 =?us-ascii?Q?Ww=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b35a2ced-06e5-4c5e-aac2-08da75cb2e54
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 03:41:14.3395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vdK55Vdqfevc1U4iS22hi5EC5nee4jz96ZWxuBvcfTvqiNVWhuTBGmp+jZxuhx11oFEMIdCJHIEZo+cIZVO4uJETgvZr9Aps1dqnGEwuFz0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6037
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_07,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040015
X-Proofpoint-ORIG-GUID: NxoWHU85HzEzApnWyiW_Jnm7hk6CBIDh
X-Proofpoint-GUID: NxoWHU85HzEzApnWyiW_Jnm7hk6CBIDh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a driver returns:

DID_TARGET_FAILURE
DID_NEXUS_FAILURE
DID_ALLOC_FAILURE
DID_MEDIUM_ERROR

we hit a couple bugs:

1. The SCSI error handler runs because scsi_decide_disposition has no
case statements for them and we return FAILED.

2. For SG IO the userspace app gets a success status instead of failed,
because scsi_result_to_blk_status clears those errors.

This patch adds a new internal error code byte for use by scsi-ml. It
will be used instead of the above error codes, so we don't have to play
that clearing the host code game in scsi_result_to_blk_status and
drivers cannot accidentally use them.

The next patch will then remove the internal users of the above codes and
convert us to use the new ones.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_error.c |  5 +++++
 drivers/scsi/scsi_lib.c   | 22 ++++++++++++++++++++++
 drivers/scsi/scsi_priv.h  | 11 +++++++++++
 3 files changed, 38 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 947d98a0565f..4adadd3fb410 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -514,6 +514,11 @@ static void scsi_report_sense(struct scsi_device *sdev,
 	}
 }
 
+static inline void set_scsi_ml_byte(struct scsi_cmnd *cmd, u8 status)
+{
+	cmd->result = (cmd->result & 0xffff00ff) | (status << 8);
+}
+
 /**
  * scsi_check_sense - Examine scsi cmd sense
  * @scmd:	Cmd to have sense checked.
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2aca0a838ca5..eaf4865a2cb6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -576,6 +576,11 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 	return false;
 }
 
+static inline u8 get_scsi_ml_byte(int result)
+{
+	return (result >> 8) & 0xff;
+}
+
 /**
  * scsi_result_to_blk_status - translate a SCSI result code into blk_status_t
  * @cmd:	SCSI command
@@ -586,6 +591,23 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
  */
 static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
 {
+	/*
+	 * Check the scsi-ml byte first in case we converted a host or status
+	 * byte.
+	 */
+	switch (get_scsi_ml_byte(result)) {
+	case SCSIML_STAT_OK:
+		break;
+	case SCSIML_STAT_RESV_CONFLICT:
+		return BLK_STS_NEXUS;
+	case SCSIML_STAT_SPACE_ALLOC:
+		return BLK_STS_NOSPC;
+	case SCSIML_STAT_MED_ERROR:
+		return BLK_STS_MEDIUM;
+	case SCSIML_STAT_TGT_FAILURE:
+		return BLK_STS_TARGET;
+	}
+
 	switch (host_byte(result)) {
 	case DID_OK:
 		if (scsi_status_is_good(result))
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 5c4786310a31..9d2d32bf0171 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -18,6 +18,17 @@ struct scsi_nl_hdr;
 
 #define SCSI_CMD_RETRIES_NO_LIMIT -1
 
+/*
+ * Error codes used by scsi-ml internally. These must not be used by drivers.
+ */
+enum scsi_ml_status {
+	SCSIML_STAT_OK			= 0x00,
+	SCSIML_STAT_RESV_CONFLICT	= 0x01,	/* Reservation conflict */
+	SCSIML_STAT_SPACE_ALLOC		= 0x02,	/* Space allocation on the dev failed */
+	SCSIML_STAT_MED_ERROR		= 0x03,	/* Medium error */
+	SCSIML_STAT_TGT_FAILURE		= 0x04,	/* Permanent target failure */
+};
+
 /*
  * Scsi Error Handler Flags
  */
-- 
2.25.1

