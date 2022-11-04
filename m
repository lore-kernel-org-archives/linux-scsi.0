Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BD9C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiKDXZn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiKDXZH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:25:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEC860E7
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:25:06 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4KhrQC027173;
        Fri, 4 Nov 2022 23:23:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=QEuLKIm4P0f3UA14Bsh/4CQLtOg+hMunZ7QEJvmedL0=;
 b=0vXljBNnZiFY/FUoPqQd2jKcSQpdLiewyNH4h3hLM6+Vz6BDqq7r2i4Kwlk47ErkadCm
 SWikBM/xP+w4Gw99dovlpV/1JuKhPlzLPnvQKPuR7MPf6782r8r4dhIYkrTnhcHY85Yl
 6a7bRfPW4ylIBhu9xwqeeGPApw1ut8obtp3cKr3dIBq7Bic7nvgLvN21OJ/m72x3LkAu
 TI6nrh1DHt4d/ZpA/fO6d+GCiELl+5N5t0d8a8itGVDy4xV7dp1jU4MJVl0QKzT6mhfx
 aWhiocSVMYB7clvPUY4KRbzuuRkyh2moKjqpx0AWPwJeO2UON1xlbgaOhUBIj6zIlx01 QQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgust16eu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:23:00 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4JXc6o012157;
        Fri, 4 Nov 2022 23:22:59 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpwn8ddu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QKU6gv9k4geLE4OrOjsvXxjGxrotymZuai8dudkk9zNAIawLZhM7qTLVTW5dWFHwycKpunSsj6vDjMg30VKfu994h5scEN4qOp3R7EyliMGsVQN75GSbcxCwXB75L5lCgTr+WpqqIU3OAkeAwLGRQ/qqiNyiNP019NsnKTxwzOvDdQrANgKHYX8m5gWsliK8TTP4YeU30vwvycwa8YOT57fIdaLJJxPYx82Iwy8J5h7+ASkkPpstbLPMlhoBZPIeVS6mFmCUotD0NyZTqN2MIfLx9CPaB9Cb76iYUIQiq90DKygkIKZUMHIfngaXTnE0x6+oSK/jv+UCsQtd+xfQAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QEuLKIm4P0f3UA14Bsh/4CQLtOg+hMunZ7QEJvmedL0=;
 b=Va7q19hhDfnBc13sX23K+n2VC6lRrf+Fc7deOembwepkqlGyMP4x/WweU+gHVkV0MdATxB7FyfYmLubGKBYfVHAmgG/DxXch6/HChYkA/xRK8o2un0qATngIHf3Z4DviJU/B50An1kzWpNRZ+ckYOUgnrYQfzxsuLS6YURWlTewsXKUy/p6Vmq1r5dzLL+CY3BqW20SCmuY42VapCl2RJsON3tsRVCT7MRKVsRnMDx+imZQoQ2hWWPAycJsbqxUHQUG3CQRdHUmYlEB4oiX0SdTmK+8nszt0OsZkOghq4mrKaYpCQNEZ4hS2a+ILLC6ko00xaJJj4fRSqjlH/2o5QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QEuLKIm4P0f3UA14Bsh/4CQLtOg+hMunZ7QEJvmedL0=;
 b=uvqHN1oNgGqw7eNUDNrWiMzWzyrE8chiTWbVtnFg13N0gQWXALIu++XghlOdrgSWJagc9UNLMabrr4lJDjDsamYQheC/3wiflDjFRuc/TSWp3PlYJYPXtdkeKOXgJl9tLahGVH5r/yeM1DR1NfTqxY2BIRJJMfI+rhjYN+PbrWs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.22; Fri, 4 Nov 2022 23:22:57 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:22:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 34/35] scsi: ufs: Have scsi-ml retry start stop errors
Date:   Fri,  4 Nov 2022 18:19:26 -0500
Message-Id: <20221104231927.9613-35-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0005.namprd04.prod.outlook.com
 (2603:10b6:610:76::10) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f6fcc42-0d81-40cc-3a07-08dabebb6d74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H/lSqmjTZC2Ngppq17V9vGkE6a6Sj8PzfWCWZmZKUzvq31K+9h5Az7LRxoC4AWi3UE8P5VX4/1soF3MeAXcv506NvW0ZgMlJQvS8aU7zOUxJORuNmUIOOzmmV1ONDuRT2dWdZgG4Yx+0dFw6LJ0wDE7+z0fGzJK4QKj0MaMhEq+ndfGVXQhf+CYkwYN66jdMvfE8UuhYaTtHwEfXHRmFDpZMgmYgQacGKHnrI//AtVgbPhDvRA8l8Gf7rNYpzvqVfqTBGtmXuYmVAJ8a+wrwMN8vp23Vlqz5L3SG1BGiapN5890dpgpwEHzw/WemYDGbAmSguMsCnK7dOQ9gD0SYQdSXUJ8iX961HBzPCLk7omUNr/uEMlo6qlmTOLffpL0Xf1jTj/t5eGBdjwGbFuo9VFeORwmMX0AQm/r9n5vnDXF0OWSEstovmAnxATn499tOc83RFfLENypsE+3VkVB4V3ZC0OX1OhYfzJi3kfB/4zeZXFBP+DoawU/BMdzp8aavKjP+TCqQFWs8uuF+XZypQml/jJrU0oDsTWNoMqF8zvR5WzQPFTYVb80c1QnY7n1oHOa2jKWgAJTag+5k4wx/d0lHCc0v8erMHYmbVtDduMwfPaN2pF6ZLcwL0MacjpYUjaWj1IaREFn6DEcIDSNDNIETPM5s0vBFY3o4NkofGchzIR+qqUWCCVsK6OeA20jDrXK99ESY6zty2O78FpUz3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199015)(83380400001)(8936002)(41300700001)(5660300002)(6486002)(6666004)(86362001)(478600001)(107886003)(8676002)(36756003)(186003)(1076003)(2616005)(4326008)(6512007)(26005)(6506007)(316002)(2906002)(66946007)(38100700002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6NcMgra0tFIChu8aIIA8NRQZR8e5pyT5nbo5xGu02M5l6CszU+VM5C8RqLfz?=
 =?us-ascii?Q?sF62uPEYhTu7HaJHgHMQWO3iOGx3V1PYYKj3VVoH5Cq6juRvEFTp1dAo5Gwr?=
 =?us-ascii?Q?azLv2zKin29K/NxttoN3T8rWp83IOstoe+F3xHjKWg+E7DU7z70FDXz6bELi?=
 =?us-ascii?Q?khFTqFGtNZUkF4I39DraMM+AAWE1Mu5DsNq85WCT+AqXOFKScv2J/DWTn90R?=
 =?us-ascii?Q?kjmNo/G+FmvbUUr9Ad8IDHdG/vF/bHXjrE3m1rnRy8TKIisbNventrc04zWC?=
 =?us-ascii?Q?2a5dm0r/U1iT/HrP29TNLZuiShFxWk7rV/kfyopa2naLll9+kxtzJvn4nf3m?=
 =?us-ascii?Q?6+sJ+3ZdGMq0cb1EpY6izjUJqQv2/yXbSIqCyiFOtQRXNol1c9/9ddmlYTLS?=
 =?us-ascii?Q?I+gGYgsYsmV0fmg20UiC6yelfirFUvGtzrgFyNn550d07azHeIhe5VkLpqPr?=
 =?us-ascii?Q?bAZ/OJ5gKUqB81OSX7fiPHH+6S4h2lEeNynX8TA3HOJKxlqxW7wZTNaJHhAF?=
 =?us-ascii?Q?33TS4jKFvOJ0XK2+1P3NFUh8iE0xd/X6HjxTTpNlOCSsUN2LDHrKSFY3KbCG?=
 =?us-ascii?Q?lHDFX+5WKOEKnU11tFgx0bQhhmHwULvnQ6uYIcSV5G3/RTg3eij0Vob9w+0c?=
 =?us-ascii?Q?x4RverN0ULT67cU2++nLRJKrUaA72H8tavb2MWPpJdC2GAPZJ4q5rEjLYMhg?=
 =?us-ascii?Q?rxdJkNpMfHmkJF6zXufBUYBEZyfqryp1+BkfOWKiiQHEKVM4DaK9bOarQSt4?=
 =?us-ascii?Q?uNs+FkAy9mUn3W3f4n7bWm0WeDFg4jcPAd379NVWNlC9AD5lvDsNmbPHE1LD?=
 =?us-ascii?Q?yJfEAXI5scVLwTnr744+qBCepmOLmkEysGrz0kifMHykbxE53mFIjZt0u7Dt?=
 =?us-ascii?Q?DA53iV2HpiSsGFKb88QuxMQOjK0g6u0yJwFSYk5qdhVgNQYRN1vQuTzUgkLh?=
 =?us-ascii?Q?41uGlE92+ABGvK6MolWa7jK3QR29im0P8ScyQk1x5nzfoeIz6bxWcMqedoIy?=
 =?us-ascii?Q?xlouFUaDkS3atCFer9z8a1dFqjUebjkuYH8D55zUNre0HXyRv1PHlMIpwp+u?=
 =?us-ascii?Q?BEFexwZwXjm51AoJRjiusH+RBLtbh0ZVVEbjGzeoht7H3xKiAoeugabL9l2D?=
 =?us-ascii?Q?mji2EPep/yLbCgt5C9UbbWMWhDVn4AIIKIPL+iFymnOoAZuwAu/mXtTShU0d?=
 =?us-ascii?Q?xRlKPTudTlCfFtOhGfavf+pAmkeVTsc2f4Up2o3nGktMuqgJppSM+VH6Shur?=
 =?us-ascii?Q?mcSMCzQYKCf6K4uTcANUtKlonG6gLzUNETSa6vVdgsFDR01ukRoeGv1hhoLw?=
 =?us-ascii?Q?6MHX3Cnfd1yTJ66TpKaNfOyHFmssgtg/v7ffaltt+SkCTXRJmkLTLBdVeNCo?=
 =?us-ascii?Q?XcMjCHNhjM6nylibUZArzJCYz9MyXHHsCzVFAurvVJQh9E9BDt/drhE7AiK/?=
 =?us-ascii?Q?Ly0hhWnffr+rCEt8kn4xwWW5Awvmlts3YfJyj9YPaDNnck43HSWg+d3wGxF+?=
 =?us-ascii?Q?5s8HRreXiQjwiHRca/1CYzbnAAUhu438VpjCX/cR8LqSm2/1ffSVaZAhdz5C?=
 =?us-ascii?Q?VmtEpP6MOLAO9A4XVXQXyREEU1Wsuqek74keDckQm99hKAUMkrV4MA3/o/if?=
 =?us-ascii?Q?Vg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f6fcc42-0d81-40cc-3a07-08dabebb6d74
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:22:23.3029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A3S+lbcdZjy43Hi8jqsVej96QY0Axy2DSEU6E9+ZuOcDD22pzqN740mGPOCeNfLECybitMeG6BzKvCihHSJMaqIZnYKOFcVaEDFpjIMtE6c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-ORIG-GUID: hf9CkMryURXazf3w7-D7H3941xMNAjst
X-Proofpoint-GUID: hf9CkMryURXazf3w7-D7H3941xMNAjst
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi-ml retry errors instead of driving them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/ufs/core/ufshcd.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index fbd694bc4ef9..a8415e1b8a4e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8719,6 +8719,12 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
 	struct request *req;
 	struct scsi_cmnd *scmd;
 	int ret;
+	struct scsi_failure failures[] = {
+		{
+			.allowed = 2,
+			.result = SCMD_FAILURE_RESULT_ANY,
+		},
+	};
 
 	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN,
 				 BLK_MQ_REQ_PM);
@@ -8730,6 +8736,7 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
 	memcpy(scmd->cmnd, cdb, scmd->cmd_len);
 	scmd->allowed = 0/*retries*/;
 	scmd->flags |= SCMD_FAIL_IF_RECOVERING;
+	scmd->failures = failures;
 	req->timeout = 1 * HZ;
 	req->rq_flags |= RQF_PM | RQF_QUIET;
 
@@ -8760,7 +8767,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdp;
 	unsigned long flags;
-	int ret, retries;
+	int ret;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	sdp = hba->ufs_device_wlun;
@@ -8786,15 +8793,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
 	 * already suspended childs.
 	 */
-	for (retries = 3; retries > 0; --retries) {
-		ret = ufshcd_execute_start_stop(sdp, pwr_mode, &sshdr);
-		/*
-		 * scsi_execute() only returns a negative value if the request
-		 * queue is dying.
-		 */
-		if (ret <= 0)
-			break;
-	}
+	ret = ufshcd_execute_start_stop(sdp, pwr_mode, &sshdr);
 	if (ret) {
 		sdev_printk(KERN_WARNING, sdp,
 			    "START_STOP failed for power mode: %d, result %x\n",
-- 
2.25.1

