Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF4E3C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 23:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiLNXwZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 18:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiLNXwX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 18:52:23 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B38187
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 15:52:22 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEMwnkg026698;
        Wed, 14 Dec 2022 23:50:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=yRqW49R3AX2G10zBW7QJuOU8XCppKlme0z2np6hl9Yw=;
 b=i9QZGEfXu4ruFLHBD4ICo4VdrBHsrc/rMMWglIpyerU183oiuqKUK/DlM0OTmOSPBZ+Q
 rzg1/WNfphiXfxKtY94TGyxqJ+FnZL6QZa8qS3pRfugj9kPl8/6PZi/2JIroaWqY95VF
 n2Z9mAAzWyJkPOXrDR5XWzy6VaNUiqeCY1au0f4UhSr8Qf4ZHVpjgKTd/kPmw5k1irXD
 p+I0TCyIQaUKjXxEnhfU1yrvdqaEKHqd3Q6nni2vYQOdDzbuAnqNic2Cl+rHBuJXTdel
 2c6eHxaFW4LuCpm8QOp5o8U2cTqSwknoPb9qYzUnvhMlNrxwWgmhXnXCX5KaIVcVIZoS kA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeruq5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:13 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BEN2QLg025131;
        Wed, 14 Dec 2022 23:50:12 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyen35kh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tjc4eMc7VpXZ0B4fEOvq4L4EXavuyFuOqDMuwLZRda41W3ahQ9MPzjrMcbkvUNrzt/LOz7N0Hf9vhmjc7Y6cuoWbc/Q8n8BNEkuUFG6ExAyFzaQSR0VZbAYDNUL35TY7FW5DhZd6eNFoCfwYD+AcShVEsSwVIaw2urld1xXVB2HRsEvsKUWiQoCgxwxAULqe65M9n7a2AvO3k5WzgDcvBByh4g6auioGlEHQlrCIunUWnT+sI5Wo5DzTgIr5uVcvmykNUi6xauNz33Q454m15IdIdikGvww5MgW4aIuK7HVwsYr/PE3mpJXE86eoMpHXdyvLiK3u6j0RVWcLXnQzDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yRqW49R3AX2G10zBW7QJuOU8XCppKlme0z2np6hl9Yw=;
 b=ZMMaJKHCVnEvmIhokXOUCbIsWf0eLMuWrQiy8iwXpIVPJ5cgkvBAQYP1OkWABGspHqUchxo/AUUI75kwi68LPidF1Ym4cLpKduQPPMqc/JqbpyL6bJB4kGirejMHtKZL7Y+JwhpKKKg8uPRGa2HB0sRkqGIzE1HA2yKV2rY/7DpYs9w+ReR15G9K2b/w6LukLcs59svBFicEJtxI3xjymEdaVYpnFnls6rWlM+ET2Qx319FioO0BT+fmxa9S3T/CXj7p4EAaTlNXcxcB/tMyEPuhAnHKVbAR552OSv7X7UCj5WX1gVOAlMwoNidT7aaF7VWIFCv3ItJAPYa1Ig9QOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yRqW49R3AX2G10zBW7QJuOU8XCppKlme0z2np6hl9Yw=;
 b=b0uQhgXKyiLLMvvxZ/0V/JynkI0mXzg0r33ngQ8u+wxA6b+fMqHJB/zyfB6k0sM3g/KwQFXdKknJycKi1VYdTLlBDKqKbB+XOpECD/u+2NSMaglV2ge6CRFSgrZ1VeyUUwjJsSInFXBz1Sg3eyHFqOQHE+FwVHtw3n+Nr4+R1L4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6800.namprd10.prod.outlook.com (2603:10b6:8:13b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Wed, 14 Dec 2022 23:50:10 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%4]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 23:50:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 04/15] scsi: ch: Convert to scsi_execute_cmd
Date:   Wed, 14 Dec 2022 17:49:50 -0600
Message-Id: <20221214235001.57267-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214235001.57267-1-michael.christie@oracle.com>
References: <20221214235001.57267-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0001.namprd20.prod.outlook.com
 (2603:10b6:610:58::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6800:EE_
X-MS-Office365-Filtering-Correlation-Id: 75700287-62ee-4c30-1b20-08dade2defce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BekB2UUQaSLYPbJbbkC2wO7F8Zq/Ga+umKD74yOiv3fSCqk2sVEC76YoNSsUlGLlKJOLPBVVu0diniw9LR/rSaFxjZ+BWZmk1s/OdaxCCEgT2ZIhSpGKoeGQPqH0UZhRDtVku84XkgMpcHQq/J0aUS+6RgP2YX/CpJQf4hh8s+LwLuGFWbLTcYEn65J3Hl55OSllaKkzduBzRa0BFRqGN1a/ooy78ewAlFJM5dn7LBuKWYILq2qSRob2D52fjhEBN/M0EZZYAlNvxRcUsxUIzH/OUDi50YFpgFeC9fqOhxlld3Ezila0YJq9YVz6PTw4f+7gSByWQJExZ3M72OSjYML7JxF+T8MGw1/BdGPX5Kwjk1+vSi05yvZZAvFiAzZIxJYPBEcGxMYymn/mjWHD+EZ6m5gK+1P+Ur61rqG5pCOSSlPYhzDru5Pex3wxehQxwjm6d49xECvDiltP8hMemQwNYMT3OUuGfsJsdpPY8yeGQvbUoBHCpvAAHmG5Xdn3jqMQI7RcorHPgDT3SohNSTxid/0t1X5Nfj2DS8cKwIeeByz5EG5C1MJCub9ShPGCkQU7S69qTr7BsuCPdxhMHDmh72tdwKCkyGEfPywfL4ZUB/dd0AGIRQiOMVL7xnVwzPo+3/jkeemHhRWnESAfww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(366004)(396003)(346002)(451199015)(5660300002)(36756003)(2906002)(66476007)(66556008)(86362001)(316002)(2616005)(478600001)(83380400001)(4326008)(6486002)(38100700002)(1076003)(26005)(41300700001)(8936002)(8676002)(6512007)(6666004)(6506007)(107886003)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6CCcZ38/C/3xvq6q4MdEIOnV0Kj+7VkveBnaqz23sol/D414Mp0oFOLt5NnS?=
 =?us-ascii?Q?M5XyTWr+Vecu+i6D7iMWRORukB3dVaYUFz48evWJYtt2CW42Ii9a6OFGX875?=
 =?us-ascii?Q?u0cLkseF0Z8Op40Ex7grWDP2IPlatm8BaqAAJMuaDHckB+zPnVVNOuZSi8cX?=
 =?us-ascii?Q?aaTdf5wMusS7DxsdZilq0bW31O1k0Z+8o5Gwsp49/U1STSXcsSnyzKDQHqYg?=
 =?us-ascii?Q?3U73WBoJ4gmtAweziN/MmdB6H+FhYvKlFigwWJiT3FjKmsfRQISBg+uIZFm/?=
 =?us-ascii?Q?LfoqcPSb/yutXheGmtufqjFnnAfpret/OW97M4QVDcM7yFxwzsNY2e1ZPqlX?=
 =?us-ascii?Q?CoNAWUWTvDkp+dcrdCC7F6X37z2MZrIICedmlCfebVBGhEqIVZCduJgihFfH?=
 =?us-ascii?Q?lBv8jL49ghdpjCS108wMKnKSWyusiMNtPeQALgSS5gL1dJ7zQVm+PrgiPAGJ?=
 =?us-ascii?Q?LoBMLhBT80YpyqxMcTAHELy2Cew4oatqUybdZ/rfJopSEqR1plAY85XcKaSt?=
 =?us-ascii?Q?Vh3Q1oZRZgRQuFcIqLWqWQ7egKeryU6JjYnI5AKfXdsSyRTm1welMy28I0+Y?=
 =?us-ascii?Q?S2l9vCWefT9CxAaDSyIu9eAT/XocVVi/hZ22H7QMkC2F9D4lDQ+pjJebbRQt?=
 =?us-ascii?Q?+8a56jtjHXPAr4Z89H2XKCqnaw4W0T0jyA4shbbHn1aZWQmkgb786uF6+jh0?=
 =?us-ascii?Q?Pq6p9oNvVgFfyxy3lZUWOE7mWb9AACfoOIlWSQ+9sDrx/I2t1lPHygBHD/TV?=
 =?us-ascii?Q?d6pb/CMWJy776OypMNlwQbBGB2xyHB0A5uWzxhC7OiSP6kEuLAgjLsWKkswQ?=
 =?us-ascii?Q?Z1nIijxA4MC2IO76ex4bo2wYNocbx+kcPoSoeJwoUrcJkOiAnnKJfVEVpAte?=
 =?us-ascii?Q?Imp4lprOoRLGR06Mixsk8/go/Uit0c9kdKs3/5GR3AV/31avbowidlB3gSCG?=
 =?us-ascii?Q?4Cv/ViAqah9w9cbnHHo90+8lVTFmPAK/aYfwgd70WlwYe0WNxq3WfkjyqQ83?=
 =?us-ascii?Q?t5m7NsPVq6xCnhn69n6zeFO8S5zD0Ibjv0d96+25VsarmE4kbHsOPeHcbobC?=
 =?us-ascii?Q?zpBiE3pBOCTN1Ko2Nk3Pzh+yuYrpI8xZKtw+kebXnc3sZWBzkGb/morG7C0Y?=
 =?us-ascii?Q?jNuOeTE0iwCaGYAmwGsf6AlCbOarKQu/scm9zKthRP5zEWqM4SegMHfpJBBO?=
 =?us-ascii?Q?KtnEXiJKt1DEOOJOXpWLp9eCM0wyBlXa+RSOZL5wHTblJryo5wQH7tSQI5xI?=
 =?us-ascii?Q?Kv8marmoIuQIEHfaopMU8Itp82TIRpiLXoyruAN0DaXn0siFCnyiToMjPAz7?=
 =?us-ascii?Q?7j0xUiJN1EngTUQf+KRDg/zej1azkrJUelQGpykeLJ1pPW4X0jQQejdZSyZ6?=
 =?us-ascii?Q?MGNNrWoZEIlhSkPTrI8mf8ytxOjgihk4mGQNph+FaVYhGvIj2VQVxvf7Ustg?=
 =?us-ascii?Q?gdxjVV1KdBRhsbawhCTMJ4rVRwBN8X7zgmhSPAM7EPtnJnC1bJ+22J3rsPLB?=
 =?us-ascii?Q?RFQXt0BwjfsM10c1zasz76TXNIXHfF+WeOm9VLAWzmbk1qXZ9/TilOmoH74B?=
 =?us-ascii?Q?OajAWwav3MFs10QXyxc5VDe/f46PAJK08VxzRZZ22JQyUc+fBHFTG+Bdm0uY?=
 =?us-ascii?Q?+A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75700287-62ee-4c30-1b20-08dade2defce
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 23:50:10.5909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LZsUExJ3JMSS+f8wltJz7vRcqfgGnUJpL2t+/OIS4pl6wVDhcUv9VUynEjzaeQevXXHxByEnEebEBcsFiYRhgM5BbTtigWUq4ZRSVA3+MLM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6800
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140196
X-Proofpoint-ORIG-GUID: 1Y2MTnWXLfIYmFckaj6LcYLSE9OZmP9X
X-Proofpoint-GUID: 1Y2MTnWXLfIYmFckaj6LcYLSE9OZmP9X
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert ch to scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ch.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 7ab29eaec6f3..72fe6df78bc5 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -184,20 +184,21 @@ static int ch_find_errno(struct scsi_sense_hdr *sshdr)
 
 static int
 ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
-	   void *buffer, unsigned buflength,
-	   enum dma_data_direction direction)
+	   void *buffer, unsigned int buflength, enum req_op op)
 {
 	int errno, retries = 0, timeout, result;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 
 	timeout = (cmd[0] == INITIALIZE_ELEMENT_STATUS)
 		? timeout_init : timeout_move;
 
  retry:
 	errno = 0;
-	result = scsi_execute_req(ch->device, cmd, direction, buffer,
-				  buflength, &sshdr, timeout * HZ,
-				  MAX_RETRIES, NULL);
+	result = scsi_execute_cmd(ch->device, cmd, op, buffer, buflength,
+				  timeout * HZ, MAX_RETRIES, &exec_args);
 	if (result < 0)
 		return result;
 	if (scsi_sense_valid(&sshdr)) {
@@ -254,7 +255,7 @@ ch_read_element_status(scsi_changer *ch, u_int elem, char *data)
 	cmd[5] = 1;
 	cmd[9] = 255;
 	if (0 == (result = ch_do_scsi(ch, cmd, 12,
-				      buffer, 256, DMA_FROM_DEVICE))) {
+				      buffer, 256, REQ_OP_DRV_IN))) {
 		if (((buffer[16] << 8) | buffer[17]) != elem) {
 			DPRINTK("asked for element 0x%02x, got 0x%02x\n",
 				elem,(buffer[16] << 8) | buffer[17]);
@@ -284,7 +285,7 @@ ch_init_elem(scsi_changer *ch)
 	memset(cmd,0,sizeof(cmd));
 	cmd[0] = INITIALIZE_ELEMENT_STATUS;
 	cmd[1] = (ch->device->lun & 0x7) << 5;
-	err = ch_do_scsi(ch, cmd, 6, NULL, 0, DMA_NONE);
+	err = ch_do_scsi(ch, cmd, 6, NULL, 0, REQ_OP_DRV_IN);
 	VPRINTK(KERN_INFO, "... finished\n");
 	return err;
 }
@@ -306,10 +307,10 @@ ch_readconfig(scsi_changer *ch)
 	cmd[1] = (ch->device->lun & 0x7) << 5;
 	cmd[2] = 0x1d;
 	cmd[4] = 255;
-	result = ch_do_scsi(ch, cmd, 10, buffer, 255, DMA_FROM_DEVICE);
+	result = ch_do_scsi(ch, cmd, 10, buffer, 255, REQ_OP_DRV_IN);
 	if (0 != result) {
 		cmd[1] |= (1<<3);
-		result  = ch_do_scsi(ch, cmd, 10, buffer, 255, DMA_FROM_DEVICE);
+		result  = ch_do_scsi(ch, cmd, 10, buffer, 255, REQ_OP_DRV_IN);
 	}
 	if (0 == result) {
 		ch->firsts[CHET_MT] =
@@ -434,7 +435,7 @@ ch_position(scsi_changer *ch, u_int trans, u_int elem, int rotate)
 	cmd[4]  = (elem  >> 8) & 0xff;
 	cmd[5]  =  elem        & 0xff;
 	cmd[8]  = rotate ? 1 : 0;
-	return ch_do_scsi(ch, cmd, 10, NULL, 0, DMA_NONE);
+	return ch_do_scsi(ch, cmd, 10, NULL, 0, REQ_OP_DRV_IN);
 }
 
 static int
@@ -455,7 +456,7 @@ ch_move(scsi_changer *ch, u_int trans, u_int src, u_int dest, int rotate)
 	cmd[6]  = (dest  >> 8) & 0xff;
 	cmd[7]  =  dest        & 0xff;
 	cmd[10] = rotate ? 1 : 0;
-	return ch_do_scsi(ch, cmd, 12, NULL,0, DMA_NONE);
+	return ch_do_scsi(ch, cmd, 12, NULL, 0, REQ_OP_DRV_IN);
 }
 
 static int
@@ -481,7 +482,7 @@ ch_exchange(scsi_changer *ch, u_int trans, u_int src,
 	cmd[9]  =  dest2       & 0xff;
 	cmd[10] = (rotate1 ? 1 : 0) | (rotate2 ? 2 : 0);
 
-	return ch_do_scsi(ch, cmd, 12, NULL, 0, DMA_NONE);
+	return ch_do_scsi(ch, cmd, 12, NULL, 0, REQ_OP_DRV_IN);
 }
 
 static void
@@ -531,7 +532,7 @@ ch_set_voltag(scsi_changer *ch, u_int elem,
 	memcpy(buffer,tag,32);
 	ch_check_voltag(buffer);
 
-	result = ch_do_scsi(ch, cmd, 12, buffer, 256, DMA_TO_DEVICE);
+	result = ch_do_scsi(ch, cmd, 12, buffer, 256, REQ_OP_DRV_OUT);
 	kfree(buffer);
 	return result;
 }
@@ -799,8 +800,7 @@ static long ch_ioctl(struct file *file,
 		ch_cmd[5] = 1;
 		ch_cmd[9] = 255;
 
-		result = ch_do_scsi(ch, ch_cmd, 12,
-				    buffer, 256, DMA_FROM_DEVICE);
+		result = ch_do_scsi(ch, ch_cmd, 12, buffer, 256, REQ_OP_DRV_IN);
 		if (!result) {
 			cge.cge_status = buffer[18];
 			cge.cge_flags = 0;
-- 
2.25.1

