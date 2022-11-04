Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22ECDC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiKDXYc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiKDXYH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:24:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045BA65A1
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:24:07 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Kj6sC013842;
        Fri, 4 Nov 2022 23:21:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=vagzyVM1BxkbBzp1aoQugIpEA/mf0pDjxNFPXzUVrMg=;
 b=Z3x1f25sttUa1IICgTqx+3e+kqzNwad4Iee1SQi4wFM2XPimpMwzH5kyY4f/YBd7DhU0
 3AbFc/mvin9jDnuNvNW6sgk45dXdO6YZ7WTybvsBqp3UipRQtMUzP0vu56CzCbsBdnsH
 qYvu7jzOzhA/PT6NiSjCYWft++rM3FZXg/3d9E6Jv9IsrLeMDhQrfTA1JSegp81E5LEu
 pSx5bjv/yYeWn22dA7ZDGRN+1TInSHfuwQbH6eWObfT7H0q6eh0LJP+ZctQaUn6aT5i5
 XDLokfcer8JP3XS1oHyRv+NLghoKHVcg2WvxrisuFprQIW6y8N2kNIIzPmxJ3xqYlrUj jQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgts1hgy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:57 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4JO6JV029449;
        Fri, 4 Nov 2022 23:21:55 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpr9a92d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWmn2+DKmNWmIYbEijwTi6Nr7uPjeLOMIEsicxKHhqt3D84etbbk5Z8ygyn/itVilBp98f0FmUHwwtRiefDAqss5JIkrp1wX9kBwqS0opYJ7UqjBWHpCDpJO/LKhEqfYOR1foaQxp29pYaDUtmmVTyCiIAjxvP6liJDeRXm+PMSAO9BG99o5oP60NXrStCdUsCvcOoAuDPqBHE7S87yV0KlreXkOxHdg7Pm6dzHCuERklNgR0zbkJhVE7s8yN0XKdFyFHo+FG0RHiQDyXnTsdy1mvhSRzjPBNaXkIiHUyOOcHNMntDrVdLetNhdWQ/kkAOMNwYWp8Dwz7oUGO+JQig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vagzyVM1BxkbBzp1aoQugIpEA/mf0pDjxNFPXzUVrMg=;
 b=YW+fT12TDcquG7LniqHtqwhQ8cqiiQp/+fVsCwmJqPG6CWnw3q86WoCuNCAYPIIkr3oBSeMuGfjCA9ATC1rRPy5tMZ/qJDpCl0DTZiF6oVjVTPURprwN6qebnYZz5mKKkGwOlfwKwr+I7ihJrKgBNmf1iLvFbYIF4N5WhqUiJkGnEWK6IuMZkWZFBAm3j0Iw1kK96V5OLvNAPisBp6JNDNwRWidU3rgWheqXy+rAqkItjD/+rzNJHeSmT1DAI0zhxM8Bq3DFCWqwGvfanG/05FuikPK1ShvX7xtmFw/KymqN+zmqnzV+nnSQWuyF7jIinkZrhS7yoiSGL+2wK37pYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vagzyVM1BxkbBzp1aoQugIpEA/mf0pDjxNFPXzUVrMg=;
 b=cLfLYv+JsFVV2q9IRNBflmr76R/Q3f/G8w0c6lI4NOxCMZzZaju5tSxSXrxapQd6IwQtXHpdiKO4/Ce4xcyeAMru20Hao6omRdcrhJjEjfeCeSwBnTvfkC3FtK+ec6+yRt/lT5f9yxg6W9hMlt17fsv5Al14MJ5Wh/W+PVZfuzQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4756.namprd10.prod.outlook.com (2603:10b6:303:9b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20; Fri, 4 Nov 2022 23:21:54 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:21:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 16/35] scsi: target_core_pscsi: Convert to scsi_exec_req
Date:   Fri,  4 Nov 2022 18:19:08 -0500
Message-Id: <20221104231927.9613-17-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0065.namprd04.prod.outlook.com
 (2603:10b6:610:74::10) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4756:EE_
X-MS-Office365-Filtering-Correlation-Id: 73a86a77-ccbb-4d8f-40ee-08dabebb5861
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JUElEJYTNW1kJJiDi9eIokjShitdYXR2ZIgAjUwATQCozFdraRbZQ3FwEjA2I3bTwTbqDaQ2CNBMb8GutLFa0cSvEO1xJKZj8PyeoBWJiQWh0jkPZSsSacayfh5sRvHgr77m6R2nphJRY6pCu4sqkfEQyZOw9NoDesnHa/YKvHTH9eWJJNzHtDZ/4H10wNmId67tDPDvQUx7Xi6+xgxUAVh1Ekn57ODo+eHvqrHi7yJEyqFFYIqhK1rFHPsjRRKBO7l6a87V6zN3GJpHRu1GaXsjC0yGdBCiQ0RXO84KtSHmcYhjms9RjRw0MXvi/Q7vHNuRK9yiEYTbpJwDxUxeODkHHtEsanL1Vbmu0undug0/MYJMTrtsATcXNGi7HLkeRmuf33y9Qf44YPN5zfyYbfVgYpmOQ84Xqg5ln/jxy511DUOJ81zwzJMGbO6TrlRYEawCquPEWBRAcK3epEFWpjLImKpYxOK6PoOiqurDHFRc9wxp7gzE9I4YnJPSo7IHI+z/NKw+IoAaNg4/aHPivtxPN7edPwlcMeC/OIlp/d0FWx3L5GW0pR6O9KJ+bLZdu2qhlSsulBUTbuIQmvaJUPZGJirA7UUXmSEoZ17DqWKm+5CPCqQoaPWzFz7PosMJteicOx2cHhZCOFaO2gzNKVS8E7/iSzuqMHtb+6EGfO1Xmo+kFmfB/2Bf3kJwJbYkVbRNwKi8abxoq8Ed41fbww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(41300700001)(2906002)(186003)(1076003)(2616005)(6486002)(478600001)(107886003)(6506007)(316002)(4326008)(83380400001)(66946007)(38100700002)(8676002)(66556008)(26005)(36756003)(86362001)(5660300002)(8936002)(6512007)(66476007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+tM7vUD7lV3yOEQoqJnEhLwqEOUssolvs8x/358tR96l96srk0LJ0TYQ1EYm?=
 =?us-ascii?Q?56uAfAf/8a1qj6zsYBNlq66K5kWNeKHuglm5cVTy7sHOMkB8vpZqLVCltme8?=
 =?us-ascii?Q?bw/pvvKS8pnuqmDQ6qRnFuXED4a1+Dn0JhSGj3Q5A7Iqok0MpbBqWmF0DoCt?=
 =?us-ascii?Q?JIXq1suwCUQeQTcRDigOvPDhW18iYKjMxbsGbg3kFW502n/AZ1zmEAqPKgT7?=
 =?us-ascii?Q?i4nWQ9cJltC8HFgXCPLmxJkDPIbfgXP/xGypUrJjAbOg43PFgasD/WfKnAPZ?=
 =?us-ascii?Q?VfM8kURXPG6UYSF5jid5M3oFIxzONzkC4705IICxz33rNIJZDiy8U74l0HjE?=
 =?us-ascii?Q?8AqllmGSjbtA2nlghBW1Jh62w0cwVVMWGaqJIM2kXC/4ouKEzcQW58Ml+jl9?=
 =?us-ascii?Q?RBF3kMDiuPwC+gvFWHVjIiwH4Cm7cqk6c8ZiqWF6I2iopMWk+2fE/ENtsN/2?=
 =?us-ascii?Q?GrJaWzu1ckPA02ZMSQTwmhGcPo25NnlXhANAwSVxqKqqDuTt0yG2bQ9rpr5p?=
 =?us-ascii?Q?cCDGvb/nFTMu3Izpi6gkA2js+cuZp7qKiMvTr0toKxW7ZlV2DNdLg9QcYIuT?=
 =?us-ascii?Q?pkQS65ZRVZfmDR6RKANsLVDY9BndlZa7f/TOEhjv5vIh/p57Vdr77sBlhF0L?=
 =?us-ascii?Q?Avl4bRnELPO1bKtph4sPXZwnHoKy8czxkK4rMRU0caCLpxsGUFM6RZc2vD1w?=
 =?us-ascii?Q?8E6dy8tntdLj1GgWnKFBzOltHxAEz4JH2ITMv7bIehHtqNBBol6/DQD2juHS?=
 =?us-ascii?Q?xV/2RlPwlUfDewWrl08zLi07DpOi5u9nBTWv6VDhFupC4VJHQuJkzV3GCIk5?=
 =?us-ascii?Q?buaHHHPBxl0HFndH7pewyZiZI/Hb2hxDgUHW6T1x99LcRN+rrYIM4mALxiGu?=
 =?us-ascii?Q?bJiUfThDt1xbeoXT9F/JSDhkLOdULIQgcrfqhoqyGFx3imOEsbDDnuNxSyWC?=
 =?us-ascii?Q?X5jjcON5yeY0x/D7OyHPVnOFCBRn8P4qQkeZ1C4cgvfBmKYD/ob8DXx8Cl8x?=
 =?us-ascii?Q?tVvoJLkIJK6Ujur/uNZgVgV4RK7ZRQlbOmMy7iFgyQOCsLzy4G4dYhdQHLOA?=
 =?us-ascii?Q?PgfxHQQDGURczP9qwCM5acSbgpX1Csr7bE4hm+fvU6i1B3AV/xxG7ppJ55oT?=
 =?us-ascii?Q?zXfAATDKbtNGCqoSGVKZio+iyjP7+/pZ06NMHHCXzs4HDalXLzxgsLaps40T?=
 =?us-ascii?Q?KRJ5Mp78FrpknyrmN6WqApn6Vc/LIZIKx17iyZo1R0MEgXvcg+rAhw49KHlc?=
 =?us-ascii?Q?XXDo3xY5HC6AzXJViEC005/RIWAt80h81rKQpGJnVcslxbzdjR3ejbTnsbIz?=
 =?us-ascii?Q?k/LQf70WFhTh7u5+lDzyOuRRDBvZO8LjOrqPfKLRQnmou+4tIvUoKNk49GK/?=
 =?us-ascii?Q?uz/+LcWLfjUW3UgFYp1ODF5/0ZdP6n/bptvW+z7vGxP1+sPRZ+RwAlEWKqii?=
 =?us-ascii?Q?r0RvPmJ6URBA7KHymBbPnqK/OknClrH5w2TauOsiHZGJChNAFVb5A/9h7LCf?=
 =?us-ascii?Q?WoQnVOUE+6BDk9nDZ6Cg2fppJteXFm1s8Fn3q0T4cuCa2vxBVJEoTEQW/Aa2?=
 =?us-ascii?Q?kqxnvI4gfdExjuI2x7QxRbSyC2Z2woVmYZof1NbhQ+21IWVQnrqKxx8++VeX?=
 =?us-ascii?Q?PA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73a86a77-ccbb-4d8f-40ee-08dabebb5861
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:21:47.8370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nvUO+a9qWd7gcjNeMcRa0ykwqgXcqgJuGtSQGVUER5lnPxx3vPi2eEVPBoXNhpnrI9xgV9PBUmK4U96aBMxPR3/iGnIRRbkZ/PjQymVUme8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-GUID: jiwnZ7l78RoAbESbcnrYDBThimDHjqby
X-Proofpoint-ORIG-GUID: jiwnZ7l78RoAbESbcnrYDBThimDHjqby
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_pscsi.c | 31 +++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 69a4c9581e80..f2f4ff0b53e1 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -144,8 +144,14 @@ static void pscsi_tape_read_blocksize(struct se_device *dev,
 	cdb[0] = MODE_SENSE;
 	cdb[4] = 0x0c; /* 12 bytes */
 
-	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf, 12, NULL,
-			HZ, 1, NULL);
+	ret = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_FROM_DEVICE,
+				.buf = buf,
+				.buf_len = 12,
+				.timeout = HZ,
+				.retries = 1 }));
 	if (ret)
 		goto out_free;
 
@@ -195,8 +201,14 @@ pscsi_get_inquiry_vpd_serial(struct scsi_device *sdev, struct t10_wwn *wwn)
 	cdb[2] = 0x80; /* Unit Serial Number */
 	put_unaligned_be16(INQUIRY_VPD_SERIAL_LEN, &cdb[3]);
 
-	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf,
-			      INQUIRY_VPD_SERIAL_LEN, NULL, HZ, 1, NULL);
+	ret = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_FROM_DEVICE,
+				.buf = buf,
+				.buf_len = INQUIRY_VPD_SERIAL_LEN,
+				.timeout = HZ,
+				.retries = 1 }));
 	if (ret)
 		goto out_free;
 
@@ -230,9 +242,14 @@ pscsi_get_inquiry_vpd_device_ident(struct scsi_device *sdev,
 	cdb[2] = 0x83; /* Device Identifier */
 	put_unaligned_be16(INQUIRY_VPD_DEVICE_IDENTIFIER_LEN, &cdb[3]);
 
-	ret = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE, buf,
-			      INQUIRY_VPD_DEVICE_IDENTIFIER_LEN,
-			      NULL, HZ, 1, NULL);
+	ret = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_FROM_DEVICE,
+				.buf = buf,
+				.buf_len = INQUIRY_VPD_DEVICE_IDENTIFIER_LEN,
+				.timeout = HZ,
+				.retries = 1 }));
 	if (ret)
 		goto out;
 
-- 
2.25.1

