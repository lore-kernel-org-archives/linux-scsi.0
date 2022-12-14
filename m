Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11378C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 23:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiLNXwd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 18:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiLNXw1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 18:52:27 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9CE167F3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 15:52:27 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEMx7OI000616;
        Wed, 14 Dec 2022 23:50:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=iaPvDD7gszUCyA0JvSDOLLwQteKEP7GgfGXaVHf1rjU=;
 b=tL1VtX/efEYNs5c7rsIDSfuahhRAROk1zh6UaBHTPQgacg9QOLOGaDsOyTmJSM64HFFV
 TEf9MjPcXzwTl7JlkFol/MbrQmV61Q+Np9wfUcFF8869Mo88ecHyQANsgBekibYk+3of
 Zr2M1kYfA75SuL4ahbd/2BQLEjTCb0h4pOPZC+OacWx15vYe6fdYcscxljMfuwlPbEhv
 CSv0oqAxym3mH97joLTK+HBij5tJm3rNwdUwsgiQsBUWsTE8hihCZBQ0OqJUNDOvgZCH
 v0GxtLQ9OPsOX3ub5iFi1C3vQgAkkkBrxUN5Y9sKSf8/VuAkZL9qccrcqLsyImG1O7aG VQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewuqt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:18 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BEN19qb039139;
        Wed, 14 Dec 2022 23:50:17 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyeuump7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C7ibkhqdPO5TlAOR3jfpDvyOsx1klIzTHMnnwSf4snZTFsOloKCR1H0dnC+ISgznYnoo2G0PN6KvaLfLMuoYBBzxob6mczsLAxsXGkkfPnsQOe5tzCrHtFliO5Z06kLLpszQYSFR4dVhG/a1VvdFNiQr28LAWlsamDI/U/naLBFZ9nkTns5WtJ7LK7o62P7FKCL+2hY1qydz72euwFPtWFKZlmYlT6JwHAV0ee3fVjPOFv1EsbNBgS8syDbl3aLrHkz0iZAAuhGnyCD2ZAF/fCQuxWSYRNRUqxuf7ZQXVYAfiYLQAr9sFjUBfBtsbY/v9aJwh/ztXY3AlBMLZ7X49g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iaPvDD7gszUCyA0JvSDOLLwQteKEP7GgfGXaVHf1rjU=;
 b=Ea9YMUV/N6UT4OpUK3HxPh6I8cPXkQw2Eo0ROBN9GotYmLx1RvJPjATorxed0y2k28SqYHRNq3vGjD9BMuh7lvfTN5rKstIGP9YzYWsPgT6pdu9AyW5kVQezH8M75qagGt00ptgISthhizPzNpgXwhnezCTDJgNfxisNV4rMHPIVROUFQo2Zoo2kTCKTonJUI0yB9nbwWynV9/A7Yv0qFePYv1lMG97HHxLhJ95CW01NOFNbtRj6LguhyOpKdsrWOafgxwWNPEeN5eLc0I4fpX/79v1Z/UyuZQRRg0Svk6jd82g2ImFEeDT3fOG0teaNCjCnWOeSfy92/psduB8Yig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaPvDD7gszUCyA0JvSDOLLwQteKEP7GgfGXaVHf1rjU=;
 b=u3bmP7oyY/klpl6yyziw2w3FladnCfOh6ZIDVYIGxkC+ygvFaUDqflo6a8J2lCwjlnwknCkOmUAJjfISq2tAVygFbQGZxUJopk0TA56mucfZ8JQimlpU5pLU1Y2bjVaVHa5pAvV+qHIQZtPLUlnlxgvcwp0Mr2WnqwLp+1zowmQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6800.namprd10.prod.outlook.com (2603:10b6:8:13b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Wed, 14 Dec 2022 23:50:15 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%4]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 23:50:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 07/15] scsi: spi: Convert to scsi_execute_cmd
Date:   Wed, 14 Dec 2022 17:49:53 -0600
Message-Id: <20221214235001.57267-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214235001.57267-1-michael.christie@oracle.com>
References: <20221214235001.57267-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0013.namprd20.prod.outlook.com
 (2603:10b6:610:58::23) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6800:EE_
X-MS-Office365-Filtering-Correlation-Id: 78512807-c81d-4a27-4de5-08dade2df299
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GtBZIp52c1o8LLcRxKh74NPNp9UhEItzZ2nafOCymLNWJuTMLGpF3a+5jzVWNeJ1+k4QnOOz73hp/n28D5hOs+W+GrCTTXWpkDLcsVjlNXHBNuM2a5C26qmY3gVgwudv6zoUoBGQcqXkn0y1Dpt95NkqYI3YxDDlju0YcnvIypfb5EDGk550CMuINxVq+Tl7snrI+GrkR/ZiMJvfj7UmkerLn1fyiiKByEISorw/uYdwviMVemZVxxmNTvr5xn7tsMTuQYO9bJuVc74lKFawDO26q20+BMGeWSxDpEjG5g3DC87JYBwqN8ArByD55TlYWuX026o9jnFkAkcvrutr8mox1oM1eV2JBJu+7TVI/ihVF9WrxIU7l/+A/Cbym98BT7U2WcsKNMlI6WkOijO6KqhcOQ8vUOvVpNrPjBvhe/XwySxa+wKb0Ug4n86FxDxPfapkALKoJUup0ho+1AvStPpnGZ6Gir2+Ddiuhfv7tLZrKD3WjHaZniVhHCv4qRy4bEQGRERtZVpKV2YtlUd5stoFzfwFXSB2xoZ5KP6GxQ4EsdHdO1cHvPFLU6WGBW1rxcP5lWT/mwGwallMqcfmPotw40v9N8RZzF8VUynsoJIj0l8Dt40Jnw1BxGnXevn+facGKIDwOaLIeJvIT+UgQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(366004)(396003)(346002)(451199015)(5660300002)(36756003)(2906002)(66476007)(66556008)(86362001)(316002)(2616005)(478600001)(83380400001)(4326008)(6486002)(38100700002)(1076003)(26005)(41300700001)(8936002)(8676002)(6512007)(6666004)(6506007)(107886003)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tIdpZ148AGgYOwdMqHKz+g/WBa4q/Pm1f1kyWmMAR+SrjuRhR4vOnR1wqm9Q?=
 =?us-ascii?Q?vH51TB0s8oci9AaW60dykm2LAgg/GkTYP6yAoOW8qXTW1BBHCF/PtcEESZ7C?=
 =?us-ascii?Q?VtkuxHGOZ185z2CsDwn46qhDhOAKtq2CowD8Q00CiagUn2yTya1GCCev+Y3v?=
 =?us-ascii?Q?mwmL6Nb6u7+ksCwPNT43k+3TnBfPVCASxyXHm57+bJyVBwff/xaYks/5j+qO?=
 =?us-ascii?Q?43OvF/4dmpClVTOun2gTlUByviHLG2u0Z2AIhhUkddBAD7wPci/+S8c2PhHq?=
 =?us-ascii?Q?+njeUTQcl5jlIVlzykNC9XG3CVvlEjz0OLfQjcMv08Opxq+Yjg9RUYoa4Obz?=
 =?us-ascii?Q?01x+vOkeY2qS7VehJZX7kSQfd3I81l+S2fIQWQwCZMJj7wqdXMhyFXeUeXO6?=
 =?us-ascii?Q?BDyWX/4RKvdRFiZY3e3sBgv/O1jccgi+pmiFJfxr6euVRkCOTRlDgzQFTa02?=
 =?us-ascii?Q?yPxHkIykaaGFTfzFA+GPvRo6h80djMIP7vnDL1f0FmMeoq4rYkB3yoKoaXar?=
 =?us-ascii?Q?fAkA4Z+/YK/CLvdy2YGXmzNvzqaDWvLQVvGkkp+QwNgmnsWPDcGSoDQjvGti?=
 =?us-ascii?Q?0V54I5sXK0q7A7ujUt5EmJSh8zu2FTrbqpinDev/Edkl9a8SPLUN5B88E/SG?=
 =?us-ascii?Q?JfyNLkLafRFEqM+N2Y8rWDEHu8BmYYCZ2sEmWrKoenJdfagfEAK2dApnJC2v?=
 =?us-ascii?Q?16hhda4lMWM1Dv9gbJXedZg7va38DGOUmPwEztMm5/RmCpji0PsjJd2aap/f?=
 =?us-ascii?Q?RAmtnJqF5o9jd4d3ZjLA+6AuDVPaspul5QAiPkizzTOZP3nxPLt1nALqfKGL?=
 =?us-ascii?Q?MOrw004S7GrHBcq4ZB6kAeK7rbM7PiWXa0hapsEosAYl+k0ZHBgmdcEqxyE/?=
 =?us-ascii?Q?njSP+e0rwmalaSHzPaTt/RE31NBNvtu/hOkC8d+2ZKEQf+0nKsdXyopJiqV+?=
 =?us-ascii?Q?goskfDA3nX/BKtO7WvENdjLcWczjvG88PghAqqF6yOkm1ncE0CuIhsVsnSy7?=
 =?us-ascii?Q?J2LNr1j5/rrjed6DWpwqRpBL0/VwF5zJYCH0naUPi2sGy/MGAQ21A2Nx+rd0?=
 =?us-ascii?Q?7hXeoA18aJ9Xtk+yMFTtYWcijQnP4NJPXuTK8XrRfJVqv68UvNkbhCRdEDYj?=
 =?us-ascii?Q?DoJx3LAGVbZOwMtp+XJZNHrECIObc+1P7wTmOq6XGQ7upYLi6awygjieL/Qc?=
 =?us-ascii?Q?Wtu78UJ9tqzLU3RZydwlTtPED1deev+NA0xGkukRpJD/e93+zKZ0+A4N1y/H?=
 =?us-ascii?Q?iKiZ3mLq38dou3Ki8vRmv3/eg4xVLbqbGZKjVlzrt1Pa8zjjrS8YgLe9GF8i?=
 =?us-ascii?Q?Rih6P8Hz1uHN/WySVbJq1tJamifw/aIkSvxsAAmCpJFE4E4J76TCLuEQdZxl?=
 =?us-ascii?Q?02ZXbM8RAkW1sWaRTtD3c4azDV5+3z8AchkBCZAF0qxiUnNoSnw/8o3v2OT1?=
 =?us-ascii?Q?VmpW9P5Y/wJF7SGH7rHhIgcZr2dLUjYftBS/OvWkmgAAgFiT4xaGpVxcNgai?=
 =?us-ascii?Q?Q0dAFjZz0K1N8LH4ua22iofS5U+mpCci0BJuKH/XoeFdj/ffwX0ojEy+Osek?=
 =?us-ascii?Q?HR7trHMIdjb+1qsyzE1ik8l3c4X1eqo+i/DKB2aOSJ25oPLsmeFwXjsBzcmP?=
 =?us-ascii?Q?4Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78512807-c81d-4a27-4de5-08dade2df299
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 23:50:15.2624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KMlFzfC6HAP+/FTu5j3wEAvljIeQhhIycjINIUHO9vwwUOenwudVa0mYauVosLTF18Dipn+Diu9OscEvAHnF4CLu82plT+5P4WePSAQGjxc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6800
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140196
X-Proofpoint-GUID: LmFGmpq0f2-Nw0Lux95Wf1V3xCCsm56A
X-Proofpoint-ORIG-GUID: LmFGmpq0f2-Nw0Lux95Wf1V3xCCsm56A
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute is going to be removed. Convert to the SPI class to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_transport_spi.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index f569cf0095c2..2442d4d2e3f3 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -105,28 +105,27 @@ static int sprint_frac(char *dest, int value, int denom)
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
+	const struct scsi_exec_args exec_args = {
+		.req_flags = BLK_MQ_REQ_PM,
+		.sshdr = sshdr ? : &sshdr_tmp,
+	};
 
-	if (!sshdr)
-		sshdr = &sshdr_tmp;
+	sshdr = exec_args.sshdr;
 
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
+		result = scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen,
+					  DV_TIMEOUT, 1, &exec_args);
 		if (result < 0 || !scsi_sense_valid(sshdr) ||
 		    sshdr->sense_key != UNIT_ATTENTION)
 			break;
@@ -675,7 +674,7 @@ spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
 	}
 
 	for (r = 0; r < retries; r++) {
-		result = spi_execute(sdev, spi_write_buffer, DMA_TO_DEVICE,
+		result = spi_execute(sdev, spi_write_buffer, REQ_OP_DRV_OUT,
 				     buffer, len, &sshdr);
 		if(result || !scsi_device_online(sdev)) {
 
@@ -697,7 +696,7 @@ spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
 		}
 
 		memset(ptr, 0, len);
-		spi_execute(sdev, spi_read_buffer, DMA_FROM_DEVICE,
+		spi_execute(sdev, spi_read_buffer, REQ_OP_DRV_IN,
 			    ptr, len, NULL);
 		scsi_device_set_state(sdev, SDEV_QUIESCE);
 
@@ -722,7 +721,7 @@ spi_dv_device_compare_inquiry(struct scsi_device *sdev, u8 *buffer,
 	for (r = 0; r < retries; r++) {
 		memset(ptr, 0, len);
 
-		result = spi_execute(sdev, spi_inquiry, DMA_FROM_DEVICE,
+		result = spi_execute(sdev, spi_inquiry, REQ_OP_DRV_IN,
 				     ptr, len, NULL);
 		
 		if(result || !scsi_device_online(sdev)) {
@@ -828,7 +827,7 @@ spi_dv_device_get_echo_buffer(struct scsi_device *sdev, u8 *buffer)
 	 * (reservation conflict, device not ready, etc) just
 	 * skip the write tests */
 	for (l = 0; ; l++) {
-		result = spi_execute(sdev, spi_test_unit_ready, DMA_NONE, 
+		result = spi_execute(sdev, spi_test_unit_ready, REQ_OP_DRV_IN,
 				     NULL, 0, NULL);
 
 		if(result) {
@@ -841,7 +840,7 @@ spi_dv_device_get_echo_buffer(struct scsi_device *sdev, u8 *buffer)
 	}
 
 	result = spi_execute(sdev, spi_read_buffer_descriptor, 
-			     DMA_FROM_DEVICE, buffer, 4, NULL);
+			     REQ_OP_DRV_IN, buffer, 4, NULL);
 
 	if (result)
 		/* Device has no echo buffer */
-- 
2.25.1

