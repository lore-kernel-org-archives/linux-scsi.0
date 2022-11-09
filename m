Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14539C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 03:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiKIDLg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 22:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiKIDLc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 22:11:32 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BE81B9D5;
        Tue,  8 Nov 2022 19:11:31 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A936fms020815;
        Wed, 9 Nov 2022 03:11:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=eZV/7FULtFczOF/nMv7jijDaDxZDD/i9fqv0Sq+HhI4=;
 b=MNrXHKbz40dnIkcq0yeBQORxSB7lpfAYW7OKsKgFrXDtbGl/pQAwC9R+yAHkq290xEfW
 F+ZoicbDMGqhdqlysfZGznO8mFaICGWYsZ8bNdlolfSII9EGD125wHv6Oz+MPPO5hy2v
 /m/5aiGcRXi7Y8dY6P05zN+vvDi5QCgr/2kQz7SXlFixYZVtHKmVozGutka+gdJ05IVS
 zmBebr6tek4ZEelR7vRNM8CQCode9TDJHn5cvJGog5UNgf/UdahQmHdmNHEJBw/slnVI
 HaGUA2dspfaaHhwpD13tm5CPRePRmeetFgdBemYzdItboqblX/1/W9SA6I6bP3qd92mO Bw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kr4000058-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 03:11:17 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A930NvV039953;
        Wed, 9 Nov 2022 03:11:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqgv3qy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 03:11:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VusipMjldN61ei54lQ8sez8Ucxk3kAXW/XfcuZrxDSOT/R0wGCB+bu+HCjaPIpXTpua+KKe1L7da+CnNf+22viaYHv+tRMmRvXSEjLt8oV4llj+yIsvQnimEO/qBfCyJJHmFgR2qpe67xc91UHE6sBwF3QPCYcS/8CV4BM0RKkqVWfFmmZoyKMp6vMGINzFPVxvOyJUE9tyt/mr98MNl7IVsSkIy+bA2gTqKUqskolTO2ooxI7LGc45LNcvqVPdQTsX32rpwcVfAW5R5g7ZofN/b/cj8SKmc1PZ6UmJPD2284iWfcjjHfTNtM/gAxJixyPU9PMEEGf0Ko3bUuvvQ/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eZV/7FULtFczOF/nMv7jijDaDxZDD/i9fqv0Sq+HhI4=;
 b=lko+pktXM8pBGE/Ui8e/ZRWUwdQaeAnRH/0PvTiXliibC6CqErGbTzyeMduoOFjgbFVWzL8l3h28I+1JiYkNE/d0Fj2imPKg+VmpAyM9F5pBvfOc2u3bcws0eT33VzDJdJ0lrafXvs9vdFUDXXEt7+bINdPZCVN7h5gWx+kej6kVYGYeERRW2SkRldh0dIyJnvp6VDm0vJAsYJ2B/G049+9E9vBzXUvaD8rMtCU1UIWWeGHn3etTCklq4fikfbmsyn7/X5OZY7f85RJiN02OvfvNJZNlSG0nrBY0CcTqkCi31ZLtaO5bYLhm0HqmX09xY1gjWI0GetmubD8gJwFYIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eZV/7FULtFczOF/nMv7jijDaDxZDD/i9fqv0Sq+HhI4=;
 b=h2HNFIHvpdoUU7INDLasjst+IKlYWz+OF3WVMF+ixAQnZHKpM8GDjd5gUxYolMDZUOjczJ+UL+Wa7uxbG2ACJPar1lY2wbh2kRMT2mW4r0FbSma00aNYl9WiC8UpNsrU1H9peTvsiAwenwvv9UkLrW391ZOR0dNR8RM0lOMeQDY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB6033.namprd10.prod.outlook.com (2603:10b6:510:1ff::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.27; Wed, 9 Nov 2022 03:11:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 03:11:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     kbusch@kernel.org, axboe@fb.com, hch@lst.de, sagi@grimberg.me,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 3/3] nvme: Convert NVMe errors to PT_STS errors
Date:   Tue,  8 Nov 2022 21:11:06 -0600
Message-Id: <20221109031106.201324-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221109031106.201324-1-michael.christie@oracle.com>
References: <20221109031106.201324-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0046.namprd03.prod.outlook.com
 (2603:10b6:610:b3::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB6033:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ad6bb1c-7b3f-4838-53e7-08dac2000ecc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t+nrxTJ6FVJEWRzYck1+Ho5DIQnfPolTc9CPPlciz8NQkmgviuyvWm7aBw/x2i4xW3+6bdvu1GgvxyB53sBSpMY3qQtOX59AIaFbu3/FZEn+onnTlTC2MT17IqFkatJIM0LkzDS5iCICFhcJX6moArOFR8GqzP7uKxChQUVIrEhEEVfYlA5UXF3qLYETIUJHqzMwVRI7oIZ39PsjQ2UtdeHz0qQWYOE/hrwC3FKKuUVnWCv7oirYoYtAO4X9qEvD9DDustkIfqAZJox0gDuELCrOUbFGZmbeXU7XfxORVteObXlsSSQ+i0pgMeWGJ28QRTsdxCdZbrdXOXJOg1yQ+O61V/k6iBKvh7akyTWhf6tPFMaGiElYq5/uj+XVl3hKRLY9oJR19XReAv+ygj/E/KNTXqRMejkUTkUOdB5JNxNrB8/S25sVtMLxXQNJVeefsYAwG534j/HuVoyjMCnZPAhRPXmpHpyufw24Hc4sKY3bb6JDuM/mv/Wb7bCSGZt1Cmb7kE8nYD2bh04e/BHmUbI3WU45XC+e1PFWf6wMTND9vAOdnekhsijcYPsziQz9o1vSWBJeM4aPArVPayOVx2gphAH1ylhYs4FuW/cymMW27+jjOPyllRw5jjZOLuIiWRyrwFklnNLNW4l4AfLsa0ZHN/dPXUbNANvKNkbOxHANwmwOaeiK72Z3iGQyn/3EcOTc3sGB2FAL3PXu42Lvhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(396003)(346002)(366004)(376002)(451199015)(5660300002)(66476007)(66946007)(8936002)(66556008)(478600001)(41300700001)(36756003)(6486002)(86362001)(2906002)(83380400001)(186003)(6666004)(6512007)(26005)(107886003)(6506007)(2616005)(1076003)(316002)(4326008)(8676002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HgkI3X5DEK4PyHdfvaOAgCrGZ9HdRtOB9tf5uc/U3Y11vesH8jLRTeOGYPTg?=
 =?us-ascii?Q?ycvY7zWgzqUJyWyxGWLP1orBKGfbPxOHlDY+9b91DraYZnR3Erqu1VV/zATB?=
 =?us-ascii?Q?MmUDE/339zcU+7NnvN5HYy1Hi3krkA7+pAUCWPICl3ua3PCZXMldmyM7AqAS?=
 =?us-ascii?Q?SXYKntnvIL/tq0lCaO4SKSmPSVr8M33D3Xddvf0/Q4EXN+ZVSrkh1jhsN7Kb?=
 =?us-ascii?Q?kiJ9YOgdzEIQOofRaD4tfrYrsSj1s5FSiN30hDJI66BSZyzo0c7nVdB8O0tB?=
 =?us-ascii?Q?NUpuKxDFSEiLJlLcysLyjMkcbHx4kiT+i995Q4XixbDvKbJNchWPRLpKc2Ux?=
 =?us-ascii?Q?QCAKyN554oCWZuxZJu5tJxzF/UH/eJTl1POf/PmB2mGdDMFIScuyAmQVM0CO?=
 =?us-ascii?Q?fV4nAi5qbmHYap0/wQPawfhbmcr+jJkEFEMfMP47g0t6009VQzkT4oZZeu9e?=
 =?us-ascii?Q?aBkSmbWXQIuDKiz71jTYb+5Ii6YBpfw0Yi3KYUcqJPfURD0Ul8TFXl+MhLbl?=
 =?us-ascii?Q?L9/oX+zu86hItJAn5DRB9wgERYwD3y2oRkaL83imesKMCwd/qdZg3kXPBjje?=
 =?us-ascii?Q?ZRY7R/3ycKGXTVYLCFNYc/qOfsPbJE1ZhO34h7y8UPFIL7Nf7oDOn1jSrPXU?=
 =?us-ascii?Q?7o+zHPOT3ZeUDfxAz76kYC8rBoh4A+RrVVSWhILiyXJ535PO73VSIcJ/h6cq?=
 =?us-ascii?Q?juIxOHbFKlGWLGjRbdWkLkv8R0Gf794eeYFBnnIMd60Gdw0BvborcXkohHHm?=
 =?us-ascii?Q?mmiJswgbujnYtU+txT8lXQ1Zh4cCPo35pesiCldEQdNA8p2NTbqs9AcHfRx7?=
 =?us-ascii?Q?hc4tg7LGgqPYtCFBFTPoxiTmkNUvRBpIafTBF/2IC00MMvlXzzci8alUsoBL?=
 =?us-ascii?Q?nGxb08XUwzW2EC1LTT3Qud+uAazanws/CsZRwny+WcuuSwauRboWEbed87kq?=
 =?us-ascii?Q?T0fL7kdEDc648GXpVXG8/nFJ9+Dy0Y9kXRVRpMeRLzFy+trkrtf6fanJPpn2?=
 =?us-ascii?Q?3ahyseY5WLx5RNoVAK54GjxVOjFgx+OKa5CM1keAKnOxv8f8EZLUiAAPs8Ed?=
 =?us-ascii?Q?NLkevBYmSIVRC4NZMm3ceFIcg53F+IY3lwnVyPH8J3+19gCgbOWg6EpPCDoT?=
 =?us-ascii?Q?lMuHwJH9+DuGToEtxwZ7u0TbiU4XL8mHrDsueKwF7v3ZkKFo/B4vCmfy2iQR?=
 =?us-ascii?Q?GaIG9jNoCxJYUlORSk7ODK7GWHZ0ev8xY3Vs8iXHdl9UARwh0pyYgq+8SgV1?=
 =?us-ascii?Q?eVUhY3/haDgIf8SJemV4y5JsQVfqjMLZCkfvZFOrD7SSL5n5mjgtLbw94gub?=
 =?us-ascii?Q?/X3y8/UnTJfBEckZZSoQmr2a+XMAt1BTZbBPTOTbT9l/lYnJXNwonUT0fBHz?=
 =?us-ascii?Q?33DfZIGFwOm02X8benBgxPYVAtr/Cyt1Z5qMPALaUSlQClnswYsBpSYbpCbS?=
 =?us-ascii?Q?0DYxfmkG0PhnkM5r529ic3L8JJ9jOn9Nk4GUssl1if2aAcN3T8dyak/Sq6Dp?=
 =?us-ascii?Q?Nq7M1zj8Ur9vwNUk1rsWOc8/Kezd8jEvfEa5x2Et3Bbhylai5BCvLlUsc4D+?=
 =?us-ascii?Q?c8cB3T8/BLI06/PQgFB0sUk/n9bUDTzmv7aPcTuZmToo+WHNtSKck6uEpUfx?=
 =?us-ascii?Q?9g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ad6bb1c-7b3f-4838-53e7-08dac2000ecc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 03:11:13.1813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HnJlmcsIOYKD/3IVTJp0yEe9ZTpDTNkc6vrEz2mIaoNSUwo3TsUNheGYSc0SFf/Aaxy9cCY7HVSmXyrnZkMh57EDimTCuZFfmjkU0OrSwD8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6033
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211090021
X-Proofpoint-GUID: UXGBI9r19G-gXfKIvk0DxVJ_aWMonquj
X-Proofpoint-ORIG-GUID: UXGBI9r19G-gXfKIvk0DxVJ_aWMonquj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This converts the NVMe errors we could see during PR handling to PT_STS
errors, so pr_ops callers can handle scsi and nvme errors without knowing
the device types.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/host/core.c | 42 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index dc4220600585..8f0177045a2f 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2104,11 +2104,43 @@ static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
 	return nvme_submit_sync_cmd(ns->queue, c, data, 16);
 }
 
+static enum pr_status nvme_sc_to_pr_status(int nvme_sc)
+{
+	enum pr_status sts;
+
+	switch (nvme_sc) {
+	case NVME_SC_SUCCESS:
+		sts = PR_STS_SUCCESS;
+		break;
+	case NVME_SC_RESERVATION_CONFLICT:
+		sts = PR_STS_RESERVATION_CONFLICT;
+		break;
+	case NVME_SC_HOST_PATH_ERROR:
+		sts = PR_STS_PATH_FAILED;
+		break;
+	case NVME_SC_ONCS_NOT_SUPPORTED:
+		sts = PR_STS_OP_NOT_SUPP;
+		break;
+	case NVME_SC_BAD_ATTRIBUTES:
+	case NVME_SC_INVALID_OPCODE:
+	case NVME_SC_INVALID_FIELD:
+	case NVME_SC_INVALID_NS:
+		sts = PR_STS_OP_INVALID;
+		break;
+	default:
+		sts = PR_STS_IOERR;
+		break;
+	}
+
+	return sts;
+}
+
 static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
 				u64 key, u64 sa_key, u8 op)
 {
 	struct nvme_command c = { };
 	u8 data[16] = { 0, };
+	int ret;
 
 	put_unaligned_le64(key, &data[0]);
 	put_unaligned_le64(sa_key, &data[8]);
@@ -2118,8 +2150,14 @@ static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
 
 	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
 	    bdev->bd_disk->fops == &nvme_ns_head_ops)
-		return nvme_send_ns_head_pr_command(bdev, &c, data);
-	return nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c, data);
+		ret = nvme_send_ns_head_pr_command(bdev, &c, data);
+	else
+		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
+					      data);
+	if (ret < 0)
+		return ret;
+
+	return nvme_sc_to_pr_status(ret);
 }
 
 static int nvme_pr_register(struct block_device *bdev, u64 old,
-- 
2.25.1

