Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B2DC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiJCR5u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiJCR5O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:57:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA998B82
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:56:24 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOI69014329;
        Mon, 3 Oct 2022 17:54:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=LnBXgQTAP0cFbwPIFO58PWG3HtwpcODZWYDe8EZR0jM=;
 b=ev5cts+TXhufR/1sZG1d4caWEEArZWH/1yM92TLYNlJoqLffTRtzRhBMOjwOolTdv2HT
 b2Ie8bcu2OQqT2vg7wYOuBqC1ZWkz3oX48LgwaGzz2CLn3eqtqimF3PCFMduvJS3a3kp
 moZgHPFCDabWAtkIHcmtHvvltj77mQJi11NMxEwBJsGRqclF5hhYuPUN6hEOS3EbiWRx
 1Ux0SNSl1JaqeBgRpxmObFchoEAw0TjaExX0cm25z9EvUrFb1qj19WkApEav17ewXz8A
 6N4wkT2QQUVtN7mqzjuOuON7vJb/dl7wg02SZm9zOBDsgol8H0ZnGXrs1Pk5BNmlOdlK /w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxc51vj44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:17 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293HbkH2028118;
        Mon, 3 Oct 2022 17:54:09 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc09gdnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GztEI40xbUcTpnrqvxzWwk4qPovgPuTNFJXiwRjroKc0dd6IDYBmJMezct+vUB7gnJ9LpKlxTdUd2mpwrqUOxFnF8DGNVS7soEJoMpiEqJithKY0aESaeiswP5MNfSD3PqfYLxVi+Tn/7QxXu8WG2v2DLH5lFO0KZBP2xWFBmZdvPtn128VidE6TEbV7ZUaLxBBazLQm79Kz4TXTl0z6jrfQszzS/Gdhr9tEiw+6xCPCd5Us4GZ2IELbJuLPxMaSOqxzUGmTJwwSaKpKjxFTlVsIITKZwc/AQ3DLkRT5qXJcb00EFTpQPcjduKhoSck9gdnjvBbcun16Nxz/+c/isA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LnBXgQTAP0cFbwPIFO58PWG3HtwpcODZWYDe8EZR0jM=;
 b=DHgO4vEOavpsDxLUoeUbckNMosU+Dc2jWQHXL2wlcr1WV+QKpIPowOJvvGeFMUc13A/TOO0L0RZ5M9wj6MzNbEgnt/Lzx5UrmO0KpRF7hezGt/Bmc4rTp+MNi3jB8qX+hmqz9Nswfh8S/w8HDtFXD2r57cPWlZidOac1na9xi1YLJxbrLxV01fPflQexjz8sueUisoX3AXeBxvSb4cwS+mG0vLK0A8ZeodTOaohREBMvI/L+DOwXN0b7zI6XSTO4J1Xos8LjXYGhnRVwtXnyXBkxI+vIzsBcWkKwivir4yoYjo/qb2fWR+M3w+34vkVGyxzrNTXyZsqsuP8bdvJ0mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LnBXgQTAP0cFbwPIFO58PWG3HtwpcODZWYDe8EZR0jM=;
 b=zTb8o/isoJEVK/w6oioPdINJD2LtBEC8Bhy+Fcv7eC/L1t15nGhAboNdH/LQUor+6vf6epGTU3jBJ0Zq596SRwnpSXTOqNch6TTYNNSm+ycwmcXo0+rnahYsOQ6Y8fdTcOS/KpqpTFCzUexD2Qls2Q5Z0J1JiLpVxVaeLMddAC0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:54:07 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:54:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 29/35] scsi: Have scsi-ml retry scsi_mode_sense errors
Date:   Mon,  3 Oct 2022 12:53:15 -0500
Message-Id: <20221003175321.8040-30-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0009.namprd07.prod.outlook.com
 (2603:10b6:610:20::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: 870f32cb-6643-4b3a-f1a7-08daa56844a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MfB/QTbrX5r2mF/xFGjIfHDgqhPt891GN5Z0oWOs27vmqICcR4w/fH8MeSesv2J/emvmHLQyegM7v8Ivosy/Rw2xXbcwE/VZZoZXaU+k17VqNGNS3y8e6zYaOxomb8xuj98STtBQz1jH22iAbeNwhlvGiK2IME+BmOhUoznVtmeXmcGf27HYsxRuskc78bLr76NSoBbKmyPxBR/sNVnJArgijOw+hxwqBQYXtSxlo4IOc5OBgYroHNNlFAATWSyyh2D8TT/DTgyGxC8Od+Cje9ehqWKUCHisCCO8W8ITrIjCKYkBMoBzh+afi/B9r1bNWQf+SjY1mTtL8eg9hgKEawyknJ5tn+bWeHwHjDZLZazJNrGtmd+81VPv4chTyn7dnOvdcb5WDS++HGy6668KWQZvvprTapCrtKMwMCuDCxKQ85a5DgOLY3F7lDh6ZagehdGulBTU44W2ZsQucfsdRXy6XzUW2IPwpGjXqDviprbzemyMv+BeLeLHpbPMcyrq37QqCZyCF0piO7U19Cj6n3AhKvKrERJs3Mu5PqmpyE4puFF7WfJg6tin9sTIo92TadnsbSQIsR9xCfkRnvQwnDhuc/p3b8JdTKFSyz0snoBa9C8oz6UXqlb1pZdPupmPJNjxJyubPuC1xET6kAbnxnQVcTGyc8blwxmsA7UYPqAMKPhy4xGIt78j7a3bNE7SBCJKfLnAHXUjaw4yqAX2aQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(5660300002)(36756003)(66556008)(86362001)(4326008)(8676002)(316002)(66946007)(8936002)(41300700001)(66476007)(186003)(1076003)(2616005)(83380400001)(38100700002)(478600001)(6486002)(6512007)(6506007)(26005)(6666004)(107886003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y8TZwzMRRdFO/pnWWignxLjy9IL6KGH+ZIFrx1c4WNMD53tF4fZYX/0/YMCu?=
 =?us-ascii?Q?YTR3izeyB6RV5hRhkDHsrlnCVhSPhScbqaytOnc7QC+rqmqHE2SJNPwD4Bpo?=
 =?us-ascii?Q?rTVn2x8E+VqryW4MBJo8ZNph10Q+QV8YlK1+uRslefeKzrF2b5BmSVRehPo0?=
 =?us-ascii?Q?lcd/aIAvNOzZXBKYoiBPti2zrJGsxwkuKN2Xvvwi0qMjTiVHf6Soq1zA0pxT?=
 =?us-ascii?Q?LwDj4wt2as2rY1lcrwNLqZmKxeWjcdDKM/YQFL3CSp1dnJQPQ7KuEFCV6Vzy?=
 =?us-ascii?Q?CMx8h+tYs9Ac2QMDI63x51UbupBpk2E/05Z6TQ1NfxrTJ98DWj/el5qqeh9m?=
 =?us-ascii?Q?lYDTzm6/tEhP0i9gcjZuHn25xLjPEl3CAP6WCne1eylBSU7Gyq3O+r4Jab5D?=
 =?us-ascii?Q?TD2gmdRaFyYpctmrSfafywS4zlr+rMy4EIo2eZjDGZZRShAVVOPxAua2vIWq?=
 =?us-ascii?Q?IbACIFPFpUb8xxoFBxSCoLL8+Vj8eOL0MNbUnQ6wUdfRzrUmJg41vSDRC0bH?=
 =?us-ascii?Q?VcCcFf2lCyhtDkG0hjPQ6TkPIPqz3PCPrcidT2PAtJH7Dcfufvm/Y63Vimlu?=
 =?us-ascii?Q?na3WMgWkOurwsxVfOYJxu18S6eWHkGeftKWNeGhBsGW+hpad6CpGHZ0FDjdV?=
 =?us-ascii?Q?q6lD5c9MUbEwaNp0embH0f3mm+1YccaqyI8010kwNDhIUlmlU7hS1rbSO/Fw?=
 =?us-ascii?Q?gPW31vxWzCvCQdOAko7MstyfwPl7pgjXoQtWHsYDfHV6lu/uXxXK0sLPeVUH?=
 =?us-ascii?Q?8+wMil7E0m1qr4EtEYH1fU0mJ7XziFbS81W32klx7dVaqScdtgbsOY4+FNpP?=
 =?us-ascii?Q?5NUVOndhmL2W/kKfMiMYrcZZMbc3gO94tjrctjecGKDF2XRA/ORaOZS3IU5p?=
 =?us-ascii?Q?lCLfr0348fla6c28V68pLXuRUFwhX1xDzvFxhPWnzVvu1CToeh46WXPv6EM4?=
 =?us-ascii?Q?0n3k3RVjTCNn4lVP/yYt7XBeTfHWUoSNs4NuyYQ7Vf8lgQI804ALonb6fQzM?=
 =?us-ascii?Q?crv2oZwfBAKkIwHnpZiokY0yiuCO54q1dLXsMsKlIHgQFYfIH2En4oBC+AMT?=
 =?us-ascii?Q?F5fbEZO8pcnCF3seogocWZdk9w50mA4j8JfO+2N19qJltL/sNvQLVUmQFM9M?=
 =?us-ascii?Q?vVqr/6YYrECt6tCdNnjwoAQB3O+6L0mtuUb80/Ea0Nzls99WxD8juFFl8xkR?=
 =?us-ascii?Q?vxm4IiYRuAWh++nfxc9YZRFtjaBpNgOL4XAO9W89xOqiiqDqL/nkeX3OcpGo?=
 =?us-ascii?Q?7a849ZZT2FGfTkuF0zWptnDG4gTSeuiDQ9Eg99mldT2z/sHtdIBwdZZy7JIj?=
 =?us-ascii?Q?lI8QTd+qSTNMgo9R8hQ2hNBQsAtwt9NYEAzvLpMqU/v5qZ/WNr2qDIHzRVXM?=
 =?us-ascii?Q?qREVY9ZhUNY1Z85Jx4bqY+fb+iQntTMSOsm1kXyeOMpEsp1tUQ9KrqyOC96r?=
 =?us-ascii?Q?uKHZ7LjTwO2KS4KH3V7yzZRrOEMPuKsLDhp8yYwhX4RoLUS4Pd6h7viCYhSX?=
 =?us-ascii?Q?XBKt2zafKnUZ23wnBjRyQfyzjP3pHP5L9jLo7tjk521+UAYBacYysYZdg/O1?=
 =?us-ascii?Q?tuUn1pUTbdEBhq9CWctRHA1qUuAPm6LBG0Tnm2i72jWNcOTOpGvTO8OC4CKy?=
 =?us-ascii?Q?Pw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 870f32cb-6643-4b3a-f1a7-08daa56844a3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:54:07.4373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tirfGkt/+09XM5iJ1qMLzPObmdDBCH2T1Fd9aChpyfHdLfeD211SWGnocq2u/7XOV0o84uKJynXbs6gR74REPbSf/Qnom/xX2UYOHGkgyS8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: ewwQpK48vcqujbAT1wHuqmpdU45NF_gS
X-Proofpoint-ORIG-GUID: ewwQpK48vcqujbAT1wHuqmpdU45NF_gS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_mode_sense have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_lib.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2f36b65fe0f1..c2a899e3d158 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2160,8 +2160,18 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	unsigned char cmd[12];
 	int use_10_for_ms;
 	int header_length;
-	int result, retry_count = retries;
+	int result;
 	struct scsi_sense_hdr my_sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = retries,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	memset(data, 0, sizeof(*data));
 	memset(&cmd[0], 0, 12);
@@ -2203,7 +2213,8 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 					.buf_len = len,
 					.sshdr = sshdr,
 					.timeout = timeout,
-					.retries = retries }));
+					.retries = retries,
+					.failures = failures }));
 	if (result < 0)
 		return result;
 
@@ -2230,12 +2241,6 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 					goto retry;
 				}
 			}
-			if (scsi_status_is_check_condition(result) &&
-			    sshdr->sense_key == UNIT_ATTENTION &&
-			    retry_count) {
-				retry_count--;
-				goto retry;
-			}
 		}
 		return -EIO;
 	}
-- 
2.25.1

