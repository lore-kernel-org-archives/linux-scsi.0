Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 003D1C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 06:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiLIGQL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 01:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiLIGP6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 01:15:58 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AED941B8
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 22:15:56 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B8MIruk021284;
        Fri, 9 Dec 2022 06:13:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=muMdYY12NOlv/RuQs6Hx4JZHDL2N8P4PYQRSqeUfujU=;
 b=wKG3S0CoTYGaa3q4hLISHejlMxVtzA5aKxOPdWGK2NfxOa8NUaJE/Ko4Pk7Ucdmt+GNI
 kFrriQwMvbqeyuLBAFRCjHUnD4O/qSs87dpv/QGYbFM4bKeYVfyyKM2ATqKTFhGMH2wa
 5WBMqDG3rE/YunEgqoBxjendP0bFlsUmPY0S89rNCkNacdiNlI4v0qOVActBCJGOdpKg
 5cD1wh1jMG6QCdQuE8qba+0po/VMvJHXbG4tV0imAqjHqF/29NQ5mpDyrE6zo0RCzU+4
 oy5zM1flzAYMUyNXVKmMbEERUNAp3kYz/0nfo+sHOLZH661xetAKNJuU1oN9Rem/6d1l cg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maud74jcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:46 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B961aTO033827;
        Fri, 9 Dec 2022 06:13:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa6c65q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VIu9eVwqHMBXY7ZEhYx9Mc68sZUVDoC+EpZbMZ3pGN/nhnn8zTtjH0Yuinv7nczjx+rH6weKu7TkcNVxSVbKIdvPCgiDyyuvknjRIWteI8SOgbZhQhTo1cFw9aaejdXhTS9vfDDeRmMX6Y1ga6M5EptcaEPVnJCkONtIpngLU3WfORxK4jVWXuNIwhvjA04AYvkNwLAfpyQ3ocUvnpQY65DV4HpyU5hkgE/aHWnce9Py6sBb22LQQQP63g/D3fEC+g+v9X8WsxRBj4sTKwQ/h1RarHxGN019oZzIb6fVkjOxDVIRsTRzOnoXXTdK9aM3K0nZVWYoVJS48wX/CBapKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=muMdYY12NOlv/RuQs6Hx4JZHDL2N8P4PYQRSqeUfujU=;
 b=Vja3xL8qWi9bMqd3erySG/mBA2i5Il8gMoeilbx9z2hfxuS96WoJzswLS3I1HSRl0lkHANx6O+jpN+b3toEbRibTnjztrfEnWgF82WGa9sEF0KzpWWP+xcKr2zpo8bxoAiXA8Ga81L0G5ObzV0gDrZngYDcAIUUt18gv+fEmzeveRslkCIMcrbtbNNm6S2D8HhAsuuvoLGT5L0gPybfa38wmD+kxAhPbobaLPLjz8EqvMN3IInrTAd5gJUYg+chXfUhHdl4FjU5smp6H7C50KJMijYpscuBs0t79ROABSBfVBFnLzpvcVcl8BPA/Be3/mw42cUt86JQGjzrZk6/sXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=muMdYY12NOlv/RuQs6Hx4JZHDL2N8P4PYQRSqeUfujU=;
 b=JGhydOe5lCmM0eHUQntQOZKG+Ry26j6FdTpUDLDXufnUJ1UNOcFHAZ9RHlzyR8pr3BJxtRqrFhVqkTRd4bJOQbCn0nm7po13pNfFV6cGmbiDfoMRYG28dPlPL7frHCyG5gtWQC6IKLhRnji0UFTfIAhiUxGLDDKOA5ZIwYNmfI0=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH0PR10MB5066.namprd10.prod.outlook.com (2603:10b6:610:c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 06:13:43 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99%6]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 06:13:43 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 07/15] scsi: spi: Convert to scsi_execute_args
Date:   Fri,  9 Dec 2022 00:13:17 -0600
Message-Id: <20221209061325.705999-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221209061325.705999-1-michael.christie@oracle.com>
References: <20221209061325.705999-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0022.namprd14.prod.outlook.com
 (2603:10b6:610:60::32) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR10MB1463:EE_|CH0PR10MB5066:EE_
X-MS-Office365-Filtering-Correlation-Id: ca000b9f-8464-400e-9269-08dad9ac85c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WCNhI4JboJTnWAn7XbZ0+ii9Q3ybnvEGqzipn8Jwl1sgc4OcqECtxaS64nC51H/kQtvLIevGo9thiLQBYu4NgsLfkUxGnua0JUyHx/AFjGEBOK1xk8FXd5NLurd5hzXQtbq2j+3PdfT4eRBPyG+aekdIp0vGphBERPVz2OtGc69yrvXptQYuQRVsjbrhSkaUx9WgMY+4jLkI7VSPWQ9G1qoioshQ0XiFKnIC4qhAK+3YiBk+9Lj11J/LCtUdHpq2S871/uqB2dV2UD12s+/smRGjI5GGu1IRxjXMq1g27kk6zPvn9Bxbk2Ux1FacuzEo29ZGslRAKytt11DKy20bfgcZ4JFfGGZIRbkTup0HxX6EF+aHXZLueHLmdhB1NnBD9qHozL3EHAFZYVCFiJ+7tWwv/vN/9OjLILRwBbPI2sEO2saWJlpzb5BDJ2NY6F7hSle8JHqQC87P0F6oME9QMIhSBcAShaObeyz3oE54vU5KKMExwyJhSq9uTSr1F3JevsOL73CXqQMNtDASFLvuFwYyPCpb8ssXObR4hJtfMw88VGcW8+/NGhqpN/XHKIxLHFUeCrh7FPb5jh32ILB2PhN5/k8Koe1hVRp8atVeipUv7mYBcrvTqxMhH2RKjDjL9tuXQReyZ6pC6D/shJzgUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199015)(478600001)(6512007)(26005)(2906002)(36756003)(6506007)(6666004)(107886003)(41300700001)(86362001)(8676002)(66556008)(66946007)(66476007)(4326008)(316002)(5660300002)(38100700002)(8936002)(6486002)(2616005)(83380400001)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j/9VRPkFKM8m+j3RjlGyZm6d07Byxtb+mHbYDAopAOB3UiRISR07AjOBLw86?=
 =?us-ascii?Q?H0TRnST/YIr6q3t3YcPT6B4k80cqamD/1CMV0V/Q986lsbGcolaMMG1gDgfw?=
 =?us-ascii?Q?OkGkkeoc652UI4nVooAKSGyn/Sgw2/SjaQ9fxJ2oQrTL5bzCxsI2gzw095/p?=
 =?us-ascii?Q?HbfRw0WHGp2E+Fwhxh+eZh4M9ha8wofDuMC3f4sllay4WAWE8iY8BdLhjalc?=
 =?us-ascii?Q?lOYOHY8MrytAfuArRzkz40OA6MpBzrtNz97HdwLknX0EqhrQWdgquriU8dOF?=
 =?us-ascii?Q?9jEA4B4nU3wFgaWv2IEesVLU4fM6sVRj8UFmTnQ9eyjW3IpeHSGdgT+vQEQD?=
 =?us-ascii?Q?JW1SgsZQeCk+/hvig7/N5wzrHDfP1ImW+ViArb27z7t5ZqeNjFXWfWIIUI31?=
 =?us-ascii?Q?hrnHYk4jddwGzWApnxajJ8A7Z+5l2r8YdvEYdc+wd2FkSQc6w2UfO/m7CTxt?=
 =?us-ascii?Q?6pMMifJqQNRpNWgxbn0FxEkKvLrmXtVeidgmo2TQ06YG6EqncwyuFA12+kQc?=
 =?us-ascii?Q?HAkrP2Gt9oP0oF5cazfInQj2puSZnmZ003MxjNixCz5psoEOfPJ7nC47VFkg?=
 =?us-ascii?Q?DKyzaqg4KT4OiPEu6TpsMzN81XiYEoPXO0uHEHz8GBO41u2TVSgxQ6T1eCYY?=
 =?us-ascii?Q?9XIJWQpDj1H5Coc6ritdXl8nLxQ39M+OQ8iZZeusR+Yyli85uGEaugW+curT?=
 =?us-ascii?Q?6YAwDkhl4j6UhDaWJn+fYieJkOTWn1gbAnMBw02PmMCmndrv5uYrikV3gN7I?=
 =?us-ascii?Q?An0P+zKEh5Z0+neAv0G7Yx6aNPRm4fInucZzHw7OmlMOEGJhKoXucwMjzpCi?=
 =?us-ascii?Q?5JYNlYdM667AItgbFOrG1NPE9uTwx+oO1pYqbFrR7lY6kVAfHNX6oIc35lKU?=
 =?us-ascii?Q?/so+0SmUr9elG3dLmnYmMqZRAaBt3rt6eYHCC8Q4oe7rvqbd/KCqNJifjQuk?=
 =?us-ascii?Q?kyc+ZMAovKj4+zUx1EFA2lFFltHfwYPH9rWFgna4ULfQ9He8BEDYL8KsmNOv?=
 =?us-ascii?Q?Lwrk22oZoJNLk27IO0wQUviHeb19JeWNyNOacqJ0qgp1BZT61kag2qESwqM5?=
 =?us-ascii?Q?HXxZ/KvrPcC/Ri/WcA0tAmoqXwuJRHMtmRqpJA+Y3+BjHB+veyqoIReRrpaj?=
 =?us-ascii?Q?VwMqxbuO0msSaiNjYj41ZonsVhPqZRBPnnc3oxqB5R3zjKHPBiOw/sgNlht3?=
 =?us-ascii?Q?t4rqloddWmR72nQ8gN4rShCj7vWDkxilWE/5w5RJ1N7KS+5djqTeXHGYok+M?=
 =?us-ascii?Q?y6gxYOesq1z1Mswj4SvMmSwiB48kONfNC3WdumdHU0ZwojjbWCNcy8FB1Wcx?=
 =?us-ascii?Q?cULLyixKKn10wPp1QCrywyJC3jhlxU2JUdjH3YGev78AN4XbrZOO6jkveiFA?=
 =?us-ascii?Q?ccEkeBjXZXVPdIIj74QAE/EtAHjnx4of4Hs/Em8ZCrYiMlPocxePyUInhRnm?=
 =?us-ascii?Q?kwG6lfjt3AKjNxMd2svqjCh9X+iC21xDh3WnL2dAGpLUdtqeBmYfF66lnX4q?=
 =?us-ascii?Q?BnRPS/pz6kq0AiLjFvN0hKtJVwaUl+l7WeUz7KLeP3BJ3m+/bql1ABNo95gu?=
 =?us-ascii?Q?ukw0vx45HClCeOUcAR2Ku4G6UjnmGy4TaJvz2vpy+l+i+o7alPVvZ31MEPg0?=
 =?us-ascii?Q?dQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca000b9f-8464-400e-9269-08dad9ac85c6
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 06:13:43.0050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aHaAi6KeYQlSP+WXkHQt8knpi1kdPIkNp5DGnk4QjUXYvaat97q9jSILZ8jvPmgOIJMWiYYbr4/X7XuJLpL2AOzjHlm199xjDdV1pGnRUZc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_02,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090053
X-Proofpoint-GUID: isXhjBnagKfUlKU9xJLAD9D335Jto7E5
X-Proofpoint-ORIG-GUID: isXhjBnagKfUlKU9xJLAD9D335Jto7E5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute is going to be removed. Convert to the SPI class to
scsi_execute_args.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_spi.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index f569cf0095c2..fa06821f3cb6 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -105,28 +105,28 @@ static int sprint_frac(char *dest, int value, int denom)
 }
 
 static int spi_execute(struct scsi_device *sdev, const void *cmd,
-		       enum dma_data_direction dir,
-		       void *buffer, unsigned bufflen,
+		       enum req_op op, void *buffer, unsigned int bufflen,
 		       struct scsi_sense_hdr *sshdr)
 {
 	int i, result;
-	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	struct scsi_sense_hdr sshdr_tmp;
+	blk_opf_t opf = op | REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
+			REQ_FAILFAST_DRIVER;
+	struct scsi_exec_args exec_args = {
+		.req_flags = BLK_MQ_REQ_PM,
+	};
 
 	if (!sshdr)
 		sshdr = &sshdr_tmp;
+	exec_args.sshdr = sshdr;
 
 	for(i = 0; i < DV_RETRIES; i++) {
 		/*
 		 * The purpose of the RQF_PM flag below is to bypass the
 		 * SDEV_QUIESCE state.
 		 */
-		result = scsi_execute(sdev, cmd, dir, buffer, bufflen, sense,
-				      sshdr, DV_TIMEOUT, /* retries */ 1,
-				      REQ_FAILFAST_DEV |
-				      REQ_FAILFAST_TRANSPORT |
-				      REQ_FAILFAST_DRIVER,
-				      RQF_PM, NULL);
+		result = scsi_execute_args(sdev, cmd, opf, buffer, bufflen,
+					   DV_TIMEOUT, 1, exec_args);
 		if (result < 0 || !scsi_sense_valid(sshdr) ||
 		    sshdr->sense_key != UNIT_ATTENTION)
 			break;
@@ -675,7 +675,7 @@ spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
 	}
 
 	for (r = 0; r < retries; r++) {
-		result = spi_execute(sdev, spi_write_buffer, DMA_TO_DEVICE,
+		result = spi_execute(sdev, spi_write_buffer, REQ_OP_DRV_OUT,
 				     buffer, len, &sshdr);
 		if(result || !scsi_device_online(sdev)) {
 
@@ -697,7 +697,7 @@ spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
 		}
 
 		memset(ptr, 0, len);
-		spi_execute(sdev, spi_read_buffer, DMA_FROM_DEVICE,
+		spi_execute(sdev, spi_read_buffer, REQ_OP_DRV_IN,
 			    ptr, len, NULL);
 		scsi_device_set_state(sdev, SDEV_QUIESCE);
 
@@ -722,7 +722,7 @@ spi_dv_device_compare_inquiry(struct scsi_device *sdev, u8 *buffer,
 	for (r = 0; r < retries; r++) {
 		memset(ptr, 0, len);
 
-		result = spi_execute(sdev, spi_inquiry, DMA_FROM_DEVICE,
+		result = spi_execute(sdev, spi_inquiry, REQ_OP_DRV_IN,
 				     ptr, len, NULL);
 		
 		if(result || !scsi_device_online(sdev)) {
@@ -828,7 +828,7 @@ spi_dv_device_get_echo_buffer(struct scsi_device *sdev, u8 *buffer)
 	 * (reservation conflict, device not ready, etc) just
 	 * skip the write tests */
 	for (l = 0; ; l++) {
-		result = spi_execute(sdev, spi_test_unit_ready, DMA_NONE, 
+		result = spi_execute(sdev, spi_test_unit_ready, REQ_OP_DRV_IN,
 				     NULL, 0, NULL);
 
 		if(result) {
@@ -841,7 +841,7 @@ spi_dv_device_get_echo_buffer(struct scsi_device *sdev, u8 *buffer)
 	}
 
 	result = spi_execute(sdev, spi_read_buffer_descriptor, 
-			     DMA_FROM_DEVICE, buffer, 4, NULL);
+			     REQ_OP_DRV_IN, buffer, 4, NULL);
 
 	if (result)
 		/* Device has no echo buffer */
-- 
2.25.1

