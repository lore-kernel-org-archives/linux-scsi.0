Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A81AC433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiJCR5f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiJCR5J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:57:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2603340BD7
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:56:16 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOCpn019377;
        Mon, 3 Oct 2022 17:54:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=ggUF+WZL99n1zc9R98JZCm5Ph0VvkdCJuVdmB0M1+3c=;
 b=Qsw4R0bNqbDmGob/N8t1Z37FPbuXOYXwaIaIoY3OTnrtUML/QRfkOGhH6kYHO2CpKZmK
 XDNLgY2yXTkbqDxIJPvQMjLuHyk8Ux/bArmP5Dp7nPDETkJGyqj2XeRWmbDBl2PqqX5T
 v95vsun5zUjU433M+mGSnGir6tSKNSTU4nyO4xKvAT7dfWYghPylWGMiz3ulSdBDApTX
 qVD+Uij1ivycdWgTUmev3t3OwpjaneTSiniKbAsEA+V7Uxqc43Mebtw6jq43ZGTOrCzF
 xXCkaRniByUu4k471yCIUQe/BrRGE61uCcwRA7CJPn3X5+XjtUOLPU1HbylVQ+/3LhrN Zw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxe3tmewq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:07 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293FU5R0028008;
        Mon, 3 Oct 2022 17:54:02 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc09gda0-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V40sBnBttjGMAQltQQDkRv/bKRz/LGnc7HsZnSIlezb0UteY762hnDIcd5yDo3mtCSSu8OJ9rszxTVmKbXit9ZAlSTm4wluYZkoj++6HDYNiKkF/3YKisQpfE5WU40vbOrAA02RCKixaZW/cgydADdnhO7UCuC24iwbAL/n27IRnwypIB7v7RbQfaIK/uqADziD0psw4LaDHzPd7mDzm67QC2oCUtiyMNi6a03AviCOR8pNfqReP3hDdTflTAAfU0BjM5waE4KOcqiQYzFQrKvER/WKay5H3P3XovbdWymAyxp6GnJEakkb1otU1WVvSdXdrIgDRaGEewsqsb6Xn1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ggUF+WZL99n1zc9R98JZCm5Ph0VvkdCJuVdmB0M1+3c=;
 b=iTJWhlpqIPcTbKBx0r5Aozh9dEElvUmVzF70HEzlJAhv/dUP5oZ140PMF5qAA+yCMAt4NbaUF6hWYS/eEj/DapsxFeEzuPWgcx1aZzZz/hRm3BI51HVyJsShcbSbQJtNuLt2lkOJsHAdod1xLzm64R5leTWjuiDN2/SEvl+rEjVY5xmbjnW2Ai2t748glo47heyRVaC1GXdEWYBMaRqk9ufIuXmk+tIK1BA1tRhZs9Fhgqp99X9FBVbrxeo7kASEvnOUIrOvnk4hYXa6hzf9aLZgvdT84+oXjC3139vvRKTSBZFtjpeuEkRd/cU/79ZPeNy/Kz5BGsNnV8iuasjw5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggUF+WZL99n1zc9R98JZCm5Ph0VvkdCJuVdmB0M1+3c=;
 b=puVRPgDnEhdgCJveBHmIyuLlpVvbDKWi2otsjkcSs6DB9DtXt0BkFCDrjr1uDDEd75m+j5T29GvV04XEVKf/b6Gdjvki8m//uV3Uflw4KZI2OyfAMKEJBR8c/l+PK1WXQXHOYtisPPTw2X3cmgXrncQOyDkoHcaC3xX5WAYGAmQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB4834.namprd10.prod.outlook.com (2603:10b6:208:307::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:53:47 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:47 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 16/35] scsi: target_core_pscsi: Convert to scsi_exec_req
Date:   Mon,  3 Oct 2022 12:53:02 -0500
Message-Id: <20221003175321.8040-17-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0052.namprd05.prod.outlook.com
 (2603:10b6:610:38::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BLAPR10MB4834:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c38a9ee-97d7-4c96-6d30-08daa56838d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: laqPJz96DQLpbCjurA9VQV4B7W/nnOQ2Em4Zd4CjZGvgSRyT3/cm/Ink/LjRU2h9Vw6s5lMuJQ0atyJQgaDxqDdP3bxZGFhysS5EtOPYT5VfKyFzPsK7mHTF/0j4l87rwaESwB/XqDjRnIpSpbja7bMyq7I+YeC5TrEdkJufbjPMlyaohpDJQuriJI3ySljQOZh5Rqfb6Jm3tPleR1gerCFm+iElVnMn5cqIgVM9Kj3YdgAxSKDDMmbpcuVOKE3yXBmuCPvcK/uzCCSotjQkBNZQ5+7AuyQEgUUojFxzmOU+txpPjzreHxmzK607/yQMAPSy6R9Jz/Ook5o3eySeYVH2RdPULHv1dD99oUThd/jJVETyD7+vuO+lhule5Iij7vohpxMnDhJmCg+I/ntK9hRpjLAOGKOsWGEXfe0CIKMspVn2noOjHLSrcrWbd02EWZ+hlcxVN6NW2+bCzdhFV5qH81WAFFyMyJPRDhWvCDC9N0hhpD+30HxEe2q5g9iO+rIchmrDWGGLX1JkD0mV3fNjkZmQ5A49JkCdGP+3br4dF5AkFDe1e4wC0aTrd9wlSVj4Ur9ZtN3Sd4m792MgHy02sWJDQM7q0p936RnvEf7bQTsAbSTZDkKzK+qVZYqQ9Dv3cq9NG02RYGAoJfKujO2/iaX/AuktsWIg3TLxnlztlCgYAmaLKXf7POQ/DqWylUHe0OSUJ41gJmX58QTXGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(86362001)(83380400001)(38100700002)(186003)(41300700001)(8936002)(5660300002)(316002)(8676002)(66946007)(66556008)(66476007)(4326008)(6506007)(6666004)(107886003)(26005)(1076003)(2616005)(2906002)(6512007)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NZNAwGTcpMAQQdeFXMLwtHuvjmT05EfLWSnUtt63wFlho+PUVXuifOCw5faj?=
 =?us-ascii?Q?ei2r24xOBRFnGlZDmW3RhfYSLPGMCZgwwo2f+knLe9jUMf/DV74mRipMK8ja?=
 =?us-ascii?Q?jl0sgNY5MBMxEK04J6vvGFYQWuWNE9KQzDi6BJF5mMssA7TFH6PHhUiRcZUa?=
 =?us-ascii?Q?DvoTLhDqjb8oi3WeQ5tEBjWcgktv0pZshwlDJezp9E55mYIJ7x+0N4Yjf+fU?=
 =?us-ascii?Q?+UjL6DRnA8AYxy1397ieThq7q80aU2dfDP4NIPq+AbKx2f0NHBHk8hHCmQqp?=
 =?us-ascii?Q?lfVhWbJrbHhEERmAimfpwGEdxIFx2QW+bGARaXEuIhb2iCasWzkSoFXLHRXu?=
 =?us-ascii?Q?D1mj/FYx69r9q2k8M62remsnBm0CcAVjHwSbucC0rH8CZoYKu1OLFHRpjAsK?=
 =?us-ascii?Q?WoM0qQ164HAEFvVgBd4L/X2Xxah1npCeNCM2y2hJghMZD+f3kCxxqked3eLY?=
 =?us-ascii?Q?uXU4wJBSCK/OJ7z4NmbDffqo1Z7JMhIRgwLPCnae3p6D7as/CNg/a/k0ZrfJ?=
 =?us-ascii?Q?i7+1y8trKGY8+QmieTn8jeE2bFB+CEh0cLSyc55JBPkaUMurldDOjWDAr9pR?=
 =?us-ascii?Q?x+/PDERz3E2iq8NYfu6RnaKnhWELG/pi2YCGtUbURiq3KsUN4BJmyBfBBgsn?=
 =?us-ascii?Q?sPqIzGBCFUI2DSLW19ubQQ9Pc2wiMiufTDRqJs2DVRNiCWGqXc1mLz0LAHU1?=
 =?us-ascii?Q?q9k3TXcNX25AttYDk21uzYzw7r88YjxNnjySQkMIkwAsZ+qF1JRLc4lUMhU7?=
 =?us-ascii?Q?EWwzVJlOLWRK2aTk+DvJrcwaAqSUfdFmztWAnQWHIoOVHi+h0UoEl7sxsbb1?=
 =?us-ascii?Q?DYX5gg6/e+4nhBVZCZEbPHguhUrl8LQodQ2f4y8A6PUQtGrBPotebDOlRQ0Y?=
 =?us-ascii?Q?FmYtxztBPJCHe03704deGtLQODNSwMZ3skf1jrikMT7SuC/chxo8MqmyCFc7?=
 =?us-ascii?Q?R6ng/J2/be+hQQutTxl6XJacwl8ktikH+4IbcLb+ekvEJhmWwhjatukbdEsj?=
 =?us-ascii?Q?CbcbTu1QdK2RDhsFMERXLPhg0NKPB8CAn26WyXKhLnE0nTj8mw1CnIrtrkLe?=
 =?us-ascii?Q?yns3FtWnDb/eD1KzPu7I3Dn1FeLPhi2PKMP9qPgrBSEoKi2KlnI7SYxafDz3?=
 =?us-ascii?Q?UaLgHj8c+X93WeFBm9xpa7oiJ0ExRP9i9Gl2ssvwCe+oBoIIKP8NS6iRdjBl?=
 =?us-ascii?Q?5BECp+eY8/ht7YcGGlH7HBD7Xbc9Ef4wHUi+VTx/Z3XnRyu80i3r+2N/2HqM?=
 =?us-ascii?Q?94V+iDLH1VNtJPTxqdq2pfOaKcgSwjlA5OL2odZ6Z8FIsmRnU75MpNHdUac0?=
 =?us-ascii?Q?W7BwVUmwnctU+RYMYDK/OZAZObqMBiKsOebrIjPt88Xq1ilKqR2RZb/IvpAo?=
 =?us-ascii?Q?nTm5hfzxc5VWIfrM5AY7YZPBJQftFvbdr4moPy0zr0QGwanPkjphn/Ax960O?=
 =?us-ascii?Q?vAMdMNKuvCg896krQi3Z6tXAfT4DpllcHogWfijZCrU5qt+LgCSVuBVDDUHL?=
 =?us-ascii?Q?8eb0U1bYhYccPsPAJb8n34RVBawqj9si0ZAtpU8IVxy3+ulIOHWCjI3fYJ98?=
 =?us-ascii?Q?ybSNTeVr113/QFUicbPDuS8q5qvp9qo/f9oZ076ytcUBE69w09qZA3gTfljp?=
 =?us-ascii?Q?9w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c38a9ee-97d7-4c96-6d30-08daa56838d7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:47.6420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sK6u5si2zUfcDuxueTlcIvOhkwfEmQ3rkA30x6EBqx3LnxLs542KjABtw9tTl/PBFWmNWvHkJCjMIqoOq2bBF26/qRp5AJLEA1PKJ7vPBS4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-ORIG-GUID: Kr4QRZN2nNs9fq42sGsOvs7SaTZeUAM6
X-Proofpoint-GUID: Kr4QRZN2nNs9fq42sGsOvs7SaTZeUAM6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
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

