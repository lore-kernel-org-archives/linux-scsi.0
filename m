Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9EFC001B2
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 23:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiLNXwn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 18:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiLNXwh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 18:52:37 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D22837218
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 15:52:35 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEMwnkh026698;
        Wed, 14 Dec 2022 23:50:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=8ffsmSpVEceiJ//dJjA2viheiVTnveuV/3Eyu5l4smQ=;
 b=r2vDdC2eTfOrSDPoowi9GP8F5+zgD4pO0M8OVYBW1MXGMDep+D7ec/vqH1j2rzv+b2A2
 v2AFxYnZIZV5k8LCCT3dHqCPS3w2tGzq5dfHU9tvCUraBrSH0gSZHBhDPaPw5lGmf7J9
 9vRfAIxM1ceCeKWkzACTMaC+DkRmxTH5JKHna1RM27ZPQ7nLhbMpTSON5FJrbZdRZbmF
 L5D8oM8/6j9phl4rP9y4+2nERQv3X3/bFzq+hbKr1qzKsHbGA0vNs4rvsSV4B/fRj/1E
 zXPw+A2BifvuB6Q4KJlkpppXvMJJDY5OVL9qUIrh4DEm9QmcW+zBcGGiY8v6Faa9MMfH cg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeruq5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:28 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BENQxcI031216;
        Wed, 14 Dec 2022 23:50:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyeptesu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dotNyPy9EV+R3M6FWApzDwJpveQHkh4e3DwMDcqxTwbjQl88HDjlOOsLnOzV22UNmP+2cHt1+qZSVafQhU9nNZ3nnyX0KvVdrprE1AClP+uc1MekGCNnTaw6V91MsB/R62kl8lvBtoAzzHuM6W/tiMXx0dmj8M1QDLLbXE7btIuibRSolfZkD85Gvw9hfMa1uz8ksJYIDBhQBZAO8e8SZUze6Ce/YZjl9+VShfF9y5aXhSgbNgbTc+nAKMfEp5VpQSB8RHT+Rr9mc114CAmw7WDJXvuswdMMxGiSq2pw9I1r7tH2iCHWXlPdh6BP0S/2LKj2+WniKRNWaB+Bn7/66w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ffsmSpVEceiJ//dJjA2viheiVTnveuV/3Eyu5l4smQ=;
 b=Fz3myowEjwBu8gS235hkBni5VLVtCVBwvg1F/1e8RxahLbS/E7KEGYb3K9KkCya6nZtuioPg6TUKVvQn7bRNwQFtF0Y1Xtscwh605eaLGLmlojoDl3Fp8Ue+lRk14fR46Ti6SeYufe5N8/0qB4lLHR6yr3QSUDKoNpXlHsbUoYVp5dzELlGRIXgEEbJuFu22bfsCOd3gsd3PeQ2UVsO8EzZRCCotJ3S3jxPRJmd8fy0H2Y0EYIXT7+pElx+GPkMpz/PIjk5rZiDBG5wXPlXF6mFcwW5xTk/ZyjiMEqAxR+0vVmsBMhT7eCR3qISBoJ//Jq/Nf2U9PIYYTfZ+0Xo3jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ffsmSpVEceiJ//dJjA2viheiVTnveuV/3Eyu5l4smQ=;
 b=X2hBvRXlOKWUst7GeD4k/qeybg5IHM8U0uOa+m2R/ahlwKFXiu84J74hbIroLj7sVoQf5IbFv7zNJf/+oYEeuPVtAUWu6F4Tg86bDlEKZguYEocad04Z9ufCEYbe6s26P5TArSfrsOjYCS3LkNBgMzVlv9QBcHddkErlSdICsBA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6800.namprd10.prod.outlook.com (2603:10b6:8:13b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Wed, 14 Dec 2022 23:50:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%4]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 23:50:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 13/15] scsi: target_core_pscsi: Convert to scsi_execute_cmd
Date:   Wed, 14 Dec 2022 17:49:59 -0600
Message-Id: <20221214235001.57267-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214235001.57267-1-michael.christie@oracle.com>
References: <20221214235001.57267-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0018.namprd08.prod.outlook.com
 (2603:10b6:610:5a::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6800:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f7193c0-a172-4009-69ad-08dade2df7e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M6/1e6g5lWpwSlOAJTnfYm91+womK+cSOys/1ZhuSo9z/uNjy+TYlBIfi5iuuFBxevxdvduYTK3zZzc1sBJ1KQ4bYF7hTupxDTf8SCpHsXsHTi7M+dOKgqpEKxY5MFoOm1ON9F3+FQxrnbWblX0u2vPdZmIkRpKjvsX9SMi1UNxvI0FXpNsQa/1yEHFL78nvt175epFCsUbbuNRf/x0UZH9FguSLX9JeUv4iX4AfyqPXOhXjvoCWZ0GkxfbLFZVa4RdqMcp/rOfIEO3glJ3TdZJCcS4u2nqUIGxEXv6sNCf5hOrkgT0icY5lZ8mIUTvolmTzzd8sgO4Yjj+e2kJWWOnzdQWYnWQeJPyaL970+g6CQvhxeOxeEG5yDga9M+crdMMSbrpBUIvMn8t0aiA2ScVu+dwtPkTC/VAZgYYGVIgW4J6LAHOtF7SfYGTDJB8wLQOTAJfI93i7ZnzFEgByhILRAhhG2X2Rj3IuPfTrXzSl5tszscpTWZvJifeZgcNeJKLHAr9jS/GGtPl7LOZtVIeR1RPAFe+uKtp/sOvCS3QaU4FYVVrbJjG+mxw4lEUYHa2S3WVQB3nrbRORxN7/ZHwirI9r7yUircbrRLmN1DqsorgcJQA/XR4mDZOSvxGCAqCoQGnL5RBMAW65HWOOuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(366004)(396003)(346002)(451199015)(5660300002)(36756003)(2906002)(66476007)(66556008)(86362001)(316002)(2616005)(478600001)(83380400001)(4326008)(6486002)(38100700002)(1076003)(26005)(41300700001)(8936002)(8676002)(6512007)(6666004)(6506007)(107886003)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nVEL1wloVLbeYemMiHmj7vtZtE622bwwNxGSzzEtj7EtuLF51UHqS0f2nT0H?=
 =?us-ascii?Q?93qd7Bw6B1wBa8xbDX1c8CZQsdhQ1XmzlppQVjpPhRYBQmLa0Y3/2Bj86msn?=
 =?us-ascii?Q?I+tV8spjEACnnyk9BEZopoT/UlkBga4zWP9D0Q+RAXggCeJRLTwMfD6oxCEI?=
 =?us-ascii?Q?RmuzEDxy9wvTCE+w7ZXpY0eio5CdZG/aPCIpNQ2bk7UP5QTZa7egyHDA8ftu?=
 =?us-ascii?Q?Dw3hM/5phEqM2XtZhC4Waup0ytw/oF6QRYJF8XHWklyvBnFrTBu9YOkByW9F?=
 =?us-ascii?Q?60vyeyahPzAsEC20hpY3JA04TPf6vVPbTrp+x87QGHcpqYW22Eana9DNVSwz?=
 =?us-ascii?Q?EUFSessK/J7YbHkdGa9ykeKu9zwE3fEuiU8rW6YmS4Pei5yc53S3wJzpCNcL?=
 =?us-ascii?Q?aadM3KtqPT6o4atZg5+c+VnHek6gTownsbR7EfcOuV685p6Lk1brIKjI3r1x?=
 =?us-ascii?Q?MS7a02fRgcXvGmolSKfJWoC0wvst0JbVTqKRFQX60n3Teo/FvkztBBxXYedW?=
 =?us-ascii?Q?kuWpruZ/4RLLqxhnB1wk9T9ZAzogkKqpaefO4IFvvZhZgEkr7/w6g74/ZuJ3?=
 =?us-ascii?Q?U5HuDP2or4sqt4E54DHjMV09mYRA9hBEOUvWAQJD3ZAmxU311MrZFaz2vCdD?=
 =?us-ascii?Q?5uXkUW/nYLAALdmScGffk6Su8gqevDm0u0t1QDz5VhqHqGMRV4Hwq2yapI2o?=
 =?us-ascii?Q?YoeDpEI8Jw51YezzYU6Y1nP4HG1OuXx+VcslfJ+2bA4qByRPqYaGSTyYyPJH?=
 =?us-ascii?Q?mddhqed7DZ1y0QBuJngpUatXcLys3d0PcMmu9/MtR6COoeClpqNSLzkNNRnr?=
 =?us-ascii?Q?sMm8qfbwAn30m3rVp0NeumWTx2hkvJhg+xu1AWAxX4LexWOQYiVYChh/7Hi9?=
 =?us-ascii?Q?0Y4K3WAzdauCcE4gTDovrR+JIdNbM9iC/1Egqila+ODSuoAuwecsJnZmEADD?=
 =?us-ascii?Q?gcDc5BE1xrV6ysKEOBbQcey1l10xhf6J7slsnYykld77sTzUnciqAMM3FeBv?=
 =?us-ascii?Q?d9ui2/8wEgWESFRoZBbV7F376Jhh1dreh7Y/SmCyCohnEE346G4KjamEmaDJ?=
 =?us-ascii?Q?fqej3jvDDx7j/3YGOHV3Uu4AsVYRelQgErHazDwJow2ymXdkzlFNYsvt3LX+?=
 =?us-ascii?Q?ceIgjBcEmFQljJMnFFBme/E+sIv05EHeYogYRsRSIZSOSbmAeFqHj4Ieufz6?=
 =?us-ascii?Q?kxSyEh4a1EXGTvcb9rZG9Q5u/tDNzwYGcNCM6QEGPviNi4BRsRWdVoJjsnFv?=
 =?us-ascii?Q?9hAYx2x32tPrtIj5fPQTCd7wZrEccdhDgQNU8A2WJiJvlupV3Kk53j3uNHX8?=
 =?us-ascii?Q?4oaJ43pNEem0Cb+O1YWb4qzHNtToGk5wFk/Vk1XRNU1Zz0k1YADBCgbfWugU?=
 =?us-ascii?Q?llLv4tOuiPQf+CiyEYNeSMJtpiJcyPj+KsnKkXTy0w+r9m3vfuH0AogOkklH?=
 =?us-ascii?Q?NAGtdKkWcUrwc147Leen9vmAXhCHWek1qRyngGqq6UD9a2GuW51IZ2HRSxnk?=
 =?us-ascii?Q?0krVsRrQl9XszqB0xqN/9tiLqT2joKZlR56ApIaN/ZbcgsIFedyxbSDWKu+Z?=
 =?us-ascii?Q?rT/Y0icwgZSkRuxV1us0KOJ6tW04+KOddRZxAdAjGQwK1A4E4EWH5lNmHDRO?=
 =?us-ascii?Q?pg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f7193c0-a172-4009-69ad-08dade2df7e3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 23:50:24.1523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GXuKh0epi5ndNEMn9MFAKY5Itxr6vDT4H5zb7R7NQ3sjK5XtTJQ+DeDp7Dtf+Bl8jt1w9m2mGvn9yUTjl0mf8MTHIKInHnKonRkIplcE/DE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6800
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140196
X-Proofpoint-ORIG-GUID: OkcI6KW9Zp3lmUslHokkycmV2gSiaxAi
X-Proofpoint-GUID: OkcI6KW9Zp3lmUslHokkycmV2gSiaxAi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert pscsi to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_pscsi.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 69a4c9581e80..e7425549e39c 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -144,8 +144,7 @@ static void pscsi_tape_read_blocksize(struct se_device *dev,
 	cdb[0] = MODE_SENSE;
 	cdb[4] = 0x0c; /* 12 bytes */
 
-	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf, 12, NULL,
-			HZ, 1, NULL);
+	ret = scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, buf, 12, HZ, 1, NULL);
 	if (ret)
 		goto out_free;
 
@@ -195,8 +194,8 @@ pscsi_get_inquiry_vpd_serial(struct scsi_device *sdev, struct t10_wwn *wwn)
 	cdb[2] = 0x80; /* Unit Serial Number */
 	put_unaligned_be16(INQUIRY_VPD_SERIAL_LEN, &cdb[3]);
 
-	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf,
-			      INQUIRY_VPD_SERIAL_LEN, NULL, HZ, 1, NULL);
+	ret = scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, buf,
+			       INQUIRY_VPD_SERIAL_LEN, HZ, 1, NULL);
 	if (ret)
 		goto out_free;
 
@@ -230,9 +229,8 @@ pscsi_get_inquiry_vpd_device_ident(struct scsi_device *sdev,
 	cdb[2] = 0x83; /* Device Identifier */
 	put_unaligned_be16(INQUIRY_VPD_DEVICE_IDENTIFIER_LEN, &cdb[3]);
 
-	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf,
-			      INQUIRY_VPD_DEVICE_IDENTIFIER_LEN,
-			      NULL, HZ, 1, NULL);
+	ret = scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, buf,
+			       INQUIRY_VPD_DEVICE_IDENTIFIER_LEN, HZ, 1, NULL);
 	if (ret)
 		goto out;
 
-- 
2.25.1

