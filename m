Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 945ECC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiJCRzf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiJCRy4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:54:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9B63ED77
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:54:12 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOJcN006335;
        Mon, 3 Oct 2022 17:54:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=r2ky/VnpqfsVUO1jYDC5N49eG5u0Eb38mr0Ylx4JHu0=;
 b=DcUJkC894JPVCb+CVHFeKiBEa1JZRqmNRDIXwS7s4EVjKPUXd9k6QtjyXsPVmjWuR69n
 Usg6Re8gZSxhpmxpTtu9jhrrRq4mz9E6Zg7al384z/R/n93WkWlhhAYQD2eF/BguuPLu
 yA3Uq1jEIr8x41nmqPkq0EogmXIAyde5HNymKCvc3D1J5fm/ySasdrrf+sqk0yss6Nep
 wvz2r9xXqfdB0loMrBwXjKKQt33562gnbC52FEt+Ab+Kx9AMEiP9aOjbBoWoMEilaozy
 ziMXCnCqTQ6yQEkBuiVYP6QMO5EsqY+SJd3jIjXENCc6FW/vktQDlUSPKp8k2YMOTfe/ 4Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxbyn48uc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:04 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293FFNff028067;
        Mon, 3 Oct 2022 17:54:03 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc09gdgf-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGLUuKGsx5VIk0/CJkUVbJgGr+PVvUZ+v42irUAn2HywG+x8nxcvuJvtHg1npcENcKkISEEBr2LxWkMHhYT4qrfWonhTmwrUG7kOw0ek24bHRIuWj5UmbAiq6gLx/unyS0Dxzrj70Mj8t0QPtuaPPpq7CoYJ3UTP8wg/46BwAFq0P0SBMV8xG2Cg6qoosdjan9mT776QrVHoK+BHcizUcqXy5LFWh7aTxeNgUk/6J1Fhtowi75sunaMbnu1OSY0f9nxi7RhuTZNHY5w2Jj6ddEdjUw3PO1+bfd82pajBdsM1xyGiKBvyXBRi3MYHOvVOozSp9r0y/Fm+v3nKcfI+0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r2ky/VnpqfsVUO1jYDC5N49eG5u0Eb38mr0Ylx4JHu0=;
 b=UqzOTONqNGdsDJz8U0nkHE/L2CmE4/6VnuoTqQm85CYU1JNQDvN0JwkzIGXs3bedJWn+ycnbE27pI6rFk3PSFZEM/Juhg7Y9QERnRxl0w2eugDV0N6WIAyLGKzkYL4NmaD/Lor3LtuKyRSLNeOSxZHq9VuHs0otxhTjWYg17mleuOvw8qlxj/BFrNPPivn9TscnbB5I73R0RkqgWQ5y2jRvuesCA0w7w3iNKV4YHT8bwVjtTD1jNe6orYZq/RrYGNTex5HlZWH9iPJpN5tjyRWwnZHxRryS93+R2Nr0iyegdb7WOnYwdKdarFqp/za7cycC+FFbEhqgdmqVxti19eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r2ky/VnpqfsVUO1jYDC5N49eG5u0Eb38mr0Ylx4JHu0=;
 b=nWMNpIiJgFBwPiZhX38A8sV16x+XLyKkklIy++XMZAEV11EHaRdyViykQH0Ag+DpdVLcy88Oon42pFkv0hbmvRXeP9Tv+OrAhqCqg3qCh1VykofMsnU5UFOLODbNgHnFaKd/YGspkDk3JQCWaSrVGNjTPjddY9Gn5yl+0AVZzMI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:54:00 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:54:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 24/35] scsi: hp_sw: Have scsi-ml retry scsi_exec_req errors
Date:   Mon,  3 Oct 2022 12:53:10 -0500
Message-Id: <20221003175321.8040-25-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0048.namprd18.prod.outlook.com
 (2603:10b6:610:55::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: 9df7e659-18bb-4aea-50e5-08daa568403c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uotQxdqeEZE6Qh52/OeJf/K1obnUSG1TJYGx8k/SC8I2KAOibfuJCfM9dwE20Hsc0JnLmI+4ywFrW9vX97xTFOlJ0ZSogCchhhE94fGkOVnjYL8+Iq6I7MrwCy9TkSU1iacb34BPxUgw3NiCYgS1f47q+D4iAMfYYq/GKTn99YLyOHX2yxWYTc0ry11HQMkRzPPLachjHoctxjmm14dAalOs6NKcgmXF87FaHfu/YcbgYmBqWFG0Pqxe8J389sPBkSCHSv/pPGHkB2XAkoDQKugCErGmoSuVXO4JMuKVJKXVSAdVpl+KNg5L8ML4Jmtu4zwdZV4CBUV6VCqO8R13wZ+c9Orz00YfdpmBIpsObOWbp83GX1pY4M3LezrS9S2UE2sdnQoRYrQ+mWqMM7BFpgxAeAH7N+oGThQsLn0cXrrrGJG8WDh1/wQkHvibsVdFUkmFYos3JY4D66RwMIhYOvdKsvIoKWUFxn5EXq1Rtf7MH/Gebjom4XVLfLE5iZiiSsBB4auDU9dt21lD0ZpuWx9tqQUny3xUmZbg3XoJ3NuW4jO3Emj7emC+XY9mXAfLvANKAiioo8DVyBoz9MAGuKWM/SWNj0fSe1DobGGuJbmBM3pIthWDpVDU2tLDCWJBdQCxfHEBhJbJz8S0elfHV4rURjNFwqn81KMBfOGSf8KO7irDOxF5pBPInphDF6wtCe498y/IYS/H8VUNF1uiIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(5660300002)(36756003)(66556008)(86362001)(4326008)(8676002)(316002)(66946007)(8936002)(41300700001)(66476007)(186003)(1076003)(2616005)(83380400001)(38100700002)(478600001)(6486002)(6512007)(6506007)(26005)(6666004)(107886003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zvS1XQahx163JZdTm+u9IRzuCXy75qVl0H8DCBm+ktmxxrz/gcUwtWXaY6Me?=
 =?us-ascii?Q?S+b71zi/79BMvEY4hu6p5789PWUV+ITP1UzZ4e38p0st82rLmWZ4lhAQq6us?=
 =?us-ascii?Q?nwljkR3k1gy9xeYwEO0SHWhg9I/Bq08ZxMClNhGfsD/zoDAPmZBhZdDhdibw?=
 =?us-ascii?Q?BBAdxXT2PQHHqOvBEPnkYtUDYNO3j1H0IBAkqQiatq+LQ02B6hdOPJxZvzxF?=
 =?us-ascii?Q?MTqoaCwTDxHL65d7mmdWzZQX7NfR4dEE1PAHjGmbFxhyfQ8NPSfSd2sMuwm9?=
 =?us-ascii?Q?BSM9F1Chz6+RYomAxD+iwJmpbD4nLO2HD/vmBOaYgL5gnjUXl0TRBtFOPzio?=
 =?us-ascii?Q?L2luYD4g4b9UgpOWlJ8fBJc3r9uPjJhEdsuL16Q0nPHpRaYOG8zcXQaRFpYJ?=
 =?us-ascii?Q?SwusI6I8Tooq5vyPwh30SQl3MsocYZQzRMMW3qTByXkfgI7lMYsNjPulGkDO?=
 =?us-ascii?Q?LZ/hDfU/uoYMxf4b4wI+lv0VlIeKg4BZd1hqFbWmitq/sb5r2VO28rZutfvM?=
 =?us-ascii?Q?gSlc6lYFZYE6+pVmr0JyMf3hp4Nmygz30o8iHmhsDyxEhVYogEozLiTprBjw?=
 =?us-ascii?Q?RImxH9OwdRIDTpIo/KwOBHZu4PNaJYfAmWuMiQ5ZrMs1DcM8NNoz7WavBCga?=
 =?us-ascii?Q?vgSSwYYabQPSrHSURcmQafyqNuITyoZ1cgXMq60WwQBNmOWD0PAMOFnOGvOf?=
 =?us-ascii?Q?idh6lfcXmYh/dmvJvAHseE/eRL6Kze1UAi4sdRWHtwZKje/zV2GBCLha6YIc?=
 =?us-ascii?Q?iFyJo2c4B0id3FvMcNrV0v0eLeVgRy8/MCJ/2X4lDNSUk9RKZWzW0TDkzQIt?=
 =?us-ascii?Q?d2eChmznrdEIswHq+KJWHCU4qaWtMjw/OrA62SwPSZ4JoolqsNpoRqwiPiRb?=
 =?us-ascii?Q?lZ+EiMVX2LUk+pEKI5rad8OMB+jTJ2kv+GA4ePxiIzCDEGvd5DlQYrH/O9wi?=
 =?us-ascii?Q?sJuccUT88LMmKo5Jpo1aLOjOyWNNwmQjg72AcMqfgKDAygJO5VE2PFNDx4mW?=
 =?us-ascii?Q?Ybci+IOgwNFtVZCoQmt9wvD3GVUm7zsNQAqDYMnQsGmvC840RsR7OWwtGJqH?=
 =?us-ascii?Q?EA1ftdFhUr98R1ITsqE5O1zx09YIsQX2gBgKuVy+bfyc62e+GHwGhSQtJsLJ?=
 =?us-ascii?Q?nqJmif2V1swUD/B3vWdwy4pEdUeC+GqxAGPWINj6NM45EnbSMKTb+33o7kVi?=
 =?us-ascii?Q?6GQ+stSE+B5V4m3Q9AJ63WqCdagHnKus6i4u+9upXrkgdHZR8B5S41H7y5FK?=
 =?us-ascii?Q?de7hFa6sA7TeusrjDMC9Mj/w2YbTl94CGjeQKzyj50Wns1hsQQtdQg0h6ZMB?=
 =?us-ascii?Q?BCWPTDeipU8tnZ2DXA7C0KVO85HGsc1/dUlpNB9jkq5YmwgCNlxRTIXXTnw8?=
 =?us-ascii?Q?c7+5iFQa4kJUKA2BZFxhMGBAF19x8MXObS3dsZIAO4bor46BR6iy86tVlcvZ?=
 =?us-ascii?Q?OcjEyLdYsxRfCOMfDShsJlDSk8zS2oHQCOO3rBkAYOlygh9aWgR6MA2se6FF?=
 =?us-ascii?Q?ymoUsxxqFdmrSHx9+RKkzoSrJtMsuqefyirifvqvujUJWCb2Z64H0S7K03Y/?=
 =?us-ascii?Q?jU3ixeurtEkfcLwNKKBu6j3EN1j1PA0NTrsUDilxRr3zHSI8YlAkyhekp7ag?=
 =?us-ascii?Q?hw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9df7e659-18bb-4aea-50e5-08daa568403c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:54:00.0629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O9+cWSghUPAwUmvIk7MBlrMuz1zGg1sr8SgkIyzvRM+7DjEXBhy5yMeRzQYLrKrbSCXG/2yTEivKQppEGiPzHJV4Ze/LbS4ySN0myRM6fMo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: 6l0jOLThCOynyVziSVQxwZyKgTceoRJK
X-Proofpoint-ORIG-GUID: 6l0jOLThCOynyVziSVQxwZyKgTceoRJK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has hp_sw have scsi-ml retry scsi_exec_req errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 46 +++++++++++++--------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index adcbe3b883b7..8c09d512a415 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -46,9 +46,6 @@ static int tur_done(struct scsi_device *sdev, struct hp_sw_dh_data *h,
 	int ret = SCSI_DH_IO;
 
 	switch (sshdr->sense_key) {
-	case UNIT_ATTENTION:
-		ret = SCSI_DH_IMM_RETRY;
-		break;
 	case NOT_READY:
 		if (sshdr->asc == 0x04 && sshdr->ascq == 2) {
 			/*
@@ -85,8 +82,17 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	int ret = SCSI_DH_OK, res;
 	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
-retry:
 	res = scsi_exec_req(((struct scsi_exec_args) {
 				.sdev = sdev,
 				.cmd = cmd,
@@ -94,7 +100,8 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 				.sshdr = &sshdr,
 				.timeout = HP_SW_TIMEOUT,
 				.retries = HP_SW_RETRIES,
-				.op_flags = req_flags }));
+				.op_flags = req_flags,
+				.failures = failures }));
 	if (res) {
 		if (scsi_sense_valid(&sshdr))
 			ret = tur_done(sdev, h, &sshdr);
@@ -108,8 +115,6 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 		h->path_state = HP_SW_PATH_ACTIVE;
 		ret = SCSI_DH_OK;
 	}
-	if (ret == SCSI_DH_IMM_RETRY)
-		goto retry;
 
 	return ret;
 }
@@ -126,11 +131,24 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev = h->sdev;
 	int res, rc = SCSI_DH_OK;
-	int retry_cnt = HP_SW_RETRIES;
 	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			/*
+			 * LUN not ready - manual intervention required
+			 *
+			 * Switch-over in progress, retry.
+			 */
+			.sense = NOT_READY,
+			.asc = 0x04,
+			.ascq = 0x03,
+			.allowed = HP_SW_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
-retry:
 	res = scsi_exec_req(((struct scsi_exec_args) {
 				.sdev = sdev,
 				.cmd = cmd,
@@ -138,7 +156,8 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 				.sshdr = &sshdr,
 				.timeout = HP_SW_TIMEOUT,
 				.retries = HP_SW_RETRIES,
-				.op_flags = req_flags }));
+				.op_flags = req_flags,
+				.failures = failures }));
 	if (res) {
 		if (!scsi_sense_valid(&sshdr)) {
 			sdev_printk(KERN_WARNING, sdev,
@@ -149,13 +168,6 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 		switch (sshdr.sense_key) {
 		case NOT_READY:
 			if (sshdr.asc == 0x04 && sshdr.ascq == 3) {
-				/*
-				 * LUN not ready - manual intervention required
-				 *
-				 * Switch-over in progress, retry.
-				 */
-				if (--retry_cnt)
-					goto retry;
 				rc = SCSI_DH_RETRY;
 				break;
 			}
-- 
2.25.1

