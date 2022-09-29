Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29CD2C32771
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234828AbiI2CzO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234838AbiI2CzA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:55:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFBB3A17C
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:54:51 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SNiI2d023216;
        Thu, 29 Sep 2022 02:54:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=+slA+0ujzknxGPvZF+6UT1OfWE9CgTqv1t02yTp5m5g=;
 b=tCve1JtsUV1dAggEEZ5j6D0mazmgRX08ur5aqg5ZcjbmOWjKRLFEc1Q+jcUpkmK8+gY3
 nmVmReewpyjDmMEC8wYWowZctY77tQjsD9j+qfy3tTq/KhSs5f5qlRMea372EW8DISq5
 cHvRr0wReLaorWosh+v5yTB0CN5uKXbTWsFcisIT0sBP/xg4mSaB32ktgLc9O5ZbnwK7
 /Dgtvrd0mEdvQyn5Nj5oNlT2XGKPKSDTBzeIlb0cedqmBlQstHVxsfQJyPPoAl0tsvD0
 3ju4E3S7KjuC32tKibiCxHV/9hKU/sNHVTiX0OLT1hnSl+Ml8wP9q5hfsGHowjCjsQoX Yg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jsstpu2x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28T1aFGO036988;
        Thu, 29 Sep 2022 02:54:38 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpvfv4tb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R504XbgWVThoNNRp0gC8Y2b7dV7VMxtE9HkNqMm70Mb+TQ0vHkWcZB7+UWsvSoGw4aWjuDtPTZYgfRy+l1w73OZdQPj/FGBDkpS9BKg15naLCUC/mXSjLST6WXzEJhJuJzKN42B+7rXVQf36rUsrzPI/A8xE8F0lmAfDn4QmvaP52FllKb6tr47QdGgmRMrZLOJPsELfS2z9dz7tiKDQYHJkkSXmyHPjsujRix12WMEJ9AhN+kixXG5N+V43dCHIM28dH/8+pIeVS128aXlWjScqqrYJoUkuLCQGDCiR2TetD1OGjkivYGP/UWZpe3LN/GEYUpVf4r4cNoIt/DA7Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+slA+0ujzknxGPvZF+6UT1OfWE9CgTqv1t02yTp5m5g=;
 b=FZPtbFdQ4vpVy13e30aXMkdDrD1IOn4+xrQ30W1BmGxleR5UUXbJRA/u/oevI3QoCSDJS/D3ZLIZl/OnRb68e46e0yKGeOP3Dn/V7g/36am2kbCyNhhP3BwZbCiil+UFLyHeqLH0d7aUdhP3quajnDa7+eB2/Ke2jaSboIBa19pJCwGpVu7YlSdchq8PpVWvDe/rjTVP21Tv3cSmQAk8UcpbRn6s5pH119I1mfgFy4YArrD/FU1B5rO2sk4LdHdriDB4NMbKY6BJHVXxc7bZCVPfLnXuhwcl2rQPG+WpUenWeI4K5bybc+V0FzH4YuwLG14GviohRcbI1I020a7+NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+slA+0ujzknxGPvZF+6UT1OfWE9CgTqv1t02yTp5m5g=;
 b=yghWWYyheIBuy4cMW1Ud+a/ERgj0sw5wYH1g7pimADAKW8BWNpT4HybIGvsc8pHd7DKr90KLKEZxCKNFx5oqJo6aqdqGmLMAkoJFMDAqX5lD0pHWSEOLJHVzGW9w3DXed6iFI9H/E2eQWSSn3THv1eV9z/Z051Sj6J4Ri9qkbLI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.19; Thu, 29 Sep 2022 02:54:37 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:36 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 16/35] scsi: target_core_pscsi: Convert to scsi_exec_req
Date:   Wed, 28 Sep 2022 21:53:48 -0500
Message-Id: <20220929025407.119804-17-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0014.namprd18.prod.outlook.com
 (2603:10b6:610:4f::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a5f7cdc-ce4b-4abe-dc46-08daa1c5f209
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TR+XiqeE4F9dKjgEG53z2VuxgRVAI3qWl/H9HXp2P1/fAtyxMNxUonFrvZ+0OhzX/hMjdpb+mlth7GfN6qaBmcYs5bA+blFUO68K5IQmvAALM8zk7HXuADnNOJsXxK4oV+xw1MobBSwoXFSK9Nj/4Oef46d0KBLu93/D+xJ2aOb/pkpWc+rv5y8FTIc3bJvOnVwlOrDnkvzvxwPksz7EPuk4tx4NkRmPQRjYkuIuOewRjmsOnbr2HkJq+gc7+e6G9AKaGlUl3ltKIHFW7jIT9KniiHcZsV/uXMMjV+SMMcWVr4h89aqCdKj8mm+ylXNk+typz6Hu0jrwVBe+Jy0N6uVp/nT4N3pZPyKr8nbeKsRAzE3yhOWtvMcd+6Uqpvf/nFE3dEsSphm/mL28EtOkG6n5uIuclNmU6ANT9XT41pYpXrAfJi1+gmTBc1gwyrhtu2MWcy/Ys2oB2iKc4O2IIpovwX3frnNdgJu+plD8EN5yRnn004g4hkwUIbZ89BzdG/lvOf8lAKwUKv2NhZacM6NbVA+K5mgqy9Lwfhp57H3g6i1TzSlw1r37jG7HzL5O6Jtad35F58t/lhbAi72lx++5bf5gcekG+vIbQrE+1BsxzA3i1dJJpDC2TZN3POuRzHyI/DwHCQ43BmjTdwCU1u6i9vlEZT0w2RGc568ihYS5pfA7YDb0vgL17IFJXdAwCyLlhKUi/Xqs8WOkbwDcXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(66476007)(26005)(6512007)(1076003)(186003)(2616005)(36756003)(478600001)(6506007)(38100700002)(316002)(83380400001)(2906002)(6486002)(6666004)(107886003)(8936002)(5660300002)(66556008)(4326008)(8676002)(66946007)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eWYiF6lbtVJl6Ea9kc/HLQ1IycyFPQaw/+I+74xXOxI09OOFFmhXAiNFDram?=
 =?us-ascii?Q?Adk6uhTw21AD6XroKImKynDNNi++9d6lkGrjsyIbKNy+T8cmcuubBeVrvIqw?=
 =?us-ascii?Q?JWOC8EkaD9haMw4e498of5ZOQfrw4yJfjuxPZJysrShsut9z6v2i+a1gMJoK?=
 =?us-ascii?Q?asrwYleB1cBuQUwtsNy051I21pnccTRIJg1ZtajOcaCHRIvlIAeMpXoUR817?=
 =?us-ascii?Q?oFBjrvxF9MRqB7q+U4lFEUXK+fGQfRrGI0FbZhoSVlOufXCP0xV6trcd0xrZ?=
 =?us-ascii?Q?Kw7dhJoj0SBqG66s/qk2NGNA3tW8uzP8ZhH6jM/SNY4d/Muggo51v2d7xPmQ?=
 =?us-ascii?Q?bLuCfs2TmXxjy5ujpqUAj1I/d+S8PJiRNcFuWoK2JYHwtVdbvdt9WRX6+5MG?=
 =?us-ascii?Q?lm3lZUbPBFxgZ6FPQVR5Ji2ThsjjlxNFJrLSzfibC4n7XQuIqBpHFzo70cSA?=
 =?us-ascii?Q?sYjBtxPGJ+m2bcD4oM1YjZN9GaXY25Z8BNxS9lSzhcd+JViFcIrasYYxDZiY?=
 =?us-ascii?Q?mgVA3+2oXPj6NZJqKR5mS6nevrMOD4bNiAqiUdDTjBA/z0cx1QASb02Rdc3R?=
 =?us-ascii?Q?Mcl5F2FGSLpd++ZN0Xgxp5snrTd/y/msw0j3dhicCwJ4b4Osw1OxXJLHrIwD?=
 =?us-ascii?Q?DuL27vIH2wjbj3Rg0B/k/KRXZVW6PKlV32t50+AMZIprSidzZiHvCVH4Br0E?=
 =?us-ascii?Q?4nven6c34CT5R6uLYTepzxP0hqZOJ727BMeL1k4kvIvmskQahyIjKNKPqxWY?=
 =?us-ascii?Q?WtW1eP11elqBopyN/+2xJ/P6eeWZeExHLuEoSiiWpYKbPxza5eV5XXq9YA1z?=
 =?us-ascii?Q?3L3RXrcDzWAU+dq7K4ZvQN3D7DCOKuKRBHfORCdsYI01gHQi65hjuXK9ODMj?=
 =?us-ascii?Q?9nrUa32qMb3OeUrIqb+c58VjLtkScQ+1G44RtemndXmkAogcUIfTjiWdHEde?=
 =?us-ascii?Q?mqFh9fCQdU4TRxsC8XWmo7hBMC92gfIdN1Uj/o507/MdnBaOr/xCeLLkZTpA?=
 =?us-ascii?Q?+Fn4MCZd8EIB3Gyf4P4M2Vqo/ztDfewMNNnog36KP/01SH0Kb76z5WdsEZcC?=
 =?us-ascii?Q?ixUTGlHcArjt5Cv1oXAnAQFDHyj951gs9G3IuIxw/DlCr08MfFVHnWGIB43r?=
 =?us-ascii?Q?FrweVIvSycXJeIQ6d5DF3CpH8RmQHVeKtFDLHi+0o8XdXRbJ6HulsmesaMIr?=
 =?us-ascii?Q?Ho8SZ2Pd2aEDwM9zHl2dg5GjTLei0YC6GBTgy0USuNjG5ByQm2lx2gXboQv5?=
 =?us-ascii?Q?7qZYVycuAfW+DIuZvL+0Gqa0O57u06C2uFQXq0wgjMIPgJDL4oqBPkY9XYfz?=
 =?us-ascii?Q?U49LYdWNn1xpmbpe1vHXpq23XTx+dY6+k8KrJSGFR6hnDOt1QKBkvWPhj+MP?=
 =?us-ascii?Q?ilUhaIs/6epcoRNA6gWsRwIt0Z3UlaFf4leVPGKRdJMzxNNP68ChwTFllCPG?=
 =?us-ascii?Q?Y2s/GWTEm6etQpUdcCpIDf6pDUTc+f3MFiNXfsIROtXiZ5XLTrfU4lvR0wKy?=
 =?us-ascii?Q?PYunClasOKrr8kpfITOZPhQc+/fThgeUObPFMvLSibpWb4xzJehsrj2Bvk7a?=
 =?us-ascii?Q?XMc0K3yfoHW+HvGseFYJ06yi+ANVl6Vil3t7lxZv8cZ073br9jvvjhE4bB/R?=
 =?us-ascii?Q?vg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a5f7cdc-ce4b-4abe-dc46-08daa1c5f209
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:36.8645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B11ojzHaXjexmCiEvBUZPSoEkKHqRSQcskdkLIC+XdsNwPzqIF3WRK8958C7sqR6ZyYtr9CESERs7T7GeTqMCehh0eCL9oaZWiAqJbt+eco=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290017
X-Proofpoint-ORIG-GUID: 9ygZxQhV-ipT4H8o4DTkLPp6a7dyRK8h
X-Proofpoint-GUID: 9ygZxQhV-ipT4H8o4DTkLPp6a7dyRK8h
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_pscsi.c | 31 +++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index e6a967ddc08c..83c00343155e 100644
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

