Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E9E2C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiKDXZj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiKDXY5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:24:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CC725288
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:24:55 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Kj7dY014044;
        Fri, 4 Nov 2022 23:22:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=bv2QDst3SvZ9Om5sDv86682KKPj3G+AqO8+l3f6Ty5k=;
 b=ddBYzrX8+rS4XYhCCn5V/giKYILrr/QaXwFzOXB41qFgMI9vFN8zeu5n/cGWpggSMtZW
 akc+ES35wGsiryjqnjU68Elp2Sz+RbFuc8Pv1WJmFsbTCRE+xfITY2hdFC64PshDBkip
 Q4SrFBWM77knKzu27cdzEgiwCjLiFQR4NMqLFd0YZ/VuT5ALGVdjusG5cN4zCOodPDU9
 KB6THq5wN0Jv5yOYZq6GG4cN+4gTNj+AgyctnIiJ1rPRX9jri9VYg10BkGpzNRbRMKuy
 uKEA70h3B2/ohHrYY2IW1UGutGvp6utIjPrxJlDj8kFoeCDPTHlNRaxwIUvzskLWhYsz 8w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgts1hh00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:49 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4N2Ams033107;
        Fri, 4 Nov 2022 23:22:47 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmq86ge56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=frat4gJnGNWmh0hsqQeqtxOSOZJKn+CPzN7F/Klhlbx21Eq/6zWIOwzUfRa8JBrhQdNeYshku6J5J/Gsds6M2u906InE6DIQ7lRL7d8dFqEsoPQ8G8GmVrJTv0UG1hbGdijqjH8qXV5PB5T9aGKFVZ+FadAJByjI8sE0PXrSxHqwkR08ATkeKAw/tjN73PL1f2KvvA7B97PbgcjBEt1Gf2rFy5BWhs7/gzMASCkCs/seAkpckZmLiAov+RiCzQBW54c1ZEqJ+ByDPAB+9DkMqAJJj1Np4LG0ZgeEeuIzUsw91sOKrZlvi+QHZ+leFulw3ig7LjEBqupxdrI44O74xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bv2QDst3SvZ9Om5sDv86682KKPj3G+AqO8+l3f6Ty5k=;
 b=Vr27Ibj4d+k/6gasfk9nHU2Eoh41mIUkSiOCcgpqDn9MBpC5zfyjFsDiFo2JNcCjk59JrKowDUCffCJ2f94DpjMJgqNUq1r62ZRhAmTBSFr6vKear8yg3dvIVy50E8fxuhw1Snv5S0x6/kXRmP5K9IByr1MomD/0xesK2qS9seLB/zvcF0lmDVw6e/tDly9R7tagRvUFPdLgo+jLUYRkk3oTTxu+eaaP8GjI1PARl/Yr5QlRsGwiQ2Mb54GLV1do1vERTwsuK+2vttGhj5n7/Hmewt6R+Nxkror8AXnACdhMspj5RgaoSpEISUpZSzeboPEUy6MYVbtxciqg1cLbeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bv2QDst3SvZ9Om5sDv86682KKPj3G+AqO8+l3f6Ty5k=;
 b=J9wGr+EP6rGYCbsLCIJ5uttTF0jLPaWHsHipF662lYVJKNMbS/6iys/+XOfRh1FdA/dPHDF7BVU9ldSf6kPTinSoLeQb/Nwc9cR3trwMIfHLdWc0fgDcwhFk8JIFcwldvGAwQdh3Nrs84DEZXiDJeCVr0m5Ry6Jjmf3bdvkCf+s=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.22; Fri, 4 Nov 2022 23:22:46 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:22:46 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 32/35] scsi: ses: Have scsi-ml retry scsi_exec_req errors
Date:   Fri,  4 Nov 2022 18:19:24 -0500
Message-Id: <20221104231927.9613-33-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0010.namprd04.prod.outlook.com
 (2603:10b6:610:76::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: ab1c77dd-53de-4ad3-9066-08dabebb6bdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wm1I4zQGPl3p8rHPxBNJ9bDKCGL/D/+XvIqWfV9sY9I8GurQqvTlAdL8oPaFNPeYuPTCi/gfKU6Jni7W2OAG5XNcbe3E1lL1smMyO7sMa7YqBygsP+tyj5bqHBs1XtHUiv2W0d0AEiqzi/oAkKTBETimGpGYGeG6mBr9xLK1vlIYht6DP6cfSRkP3m3QR+C0RXVdKxMnOVPf3cS4X0nv7dN9xBxVSKeFR5N/q79+8WLGgG2kH1tqaJU31vJSf1EdNnGx3CYYwGdtfVTQKjG410wdWagXRdj7npaUuRdMU3HrGTwAinv6XTAWK1d8HQozB1jQ1nHJhw2x8XWM5fR5RXt9ccrDWXV7gSvqTJQ/12/e/MPbf6C93fxaKZ+VZBwG1XUX51B/gJyQ0o57TP5MIrj4/SpSAFpNJ7PWb/fljUm0ms3d9Ar/TXb/t4fasx6ntwvmQ0mkeWerRrAX349KzTSzXQeC78IgvlpDN9OucMZU0uc8x5wiTPi2Ety12nNpEYhvvVhDFIHLbXcaIhsvHm/Qk5sxoYRRuQX1vs9TJKNuFjJZBP/hAxvfUA6U+iugGDegdDpR5OqLBejaaMu3IotQi3/PWd4maBy3F0rFBI04FAONUx8O2LaMJmU1b1pF/DMc7bVNagYkJv1aO1+5+3Zmu906ogAi2PtYhH5rx2X4YWEzbH4I75QVkOtBHucP4bVvnFP8KB4jI3UH7xOUtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199015)(83380400001)(8936002)(41300700001)(5660300002)(6486002)(6666004)(86362001)(478600001)(107886003)(8676002)(36756003)(186003)(1076003)(2616005)(4326008)(6512007)(26005)(6506007)(316002)(2906002)(66946007)(38100700002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yIWt09E+B7ZBV5P6mRS7USKQccx8DSokS6X/cK2Jav8AK4HaXb/BYD0JvRne?=
 =?us-ascii?Q?9VFRVxvfJ+iw46eUvof7xOJ1ePw/yAPrJHaldnUKll1ehCg4XDS2BOvn+T6g?=
 =?us-ascii?Q?+B5uHNm9ObbADy9VJQDxapKBkSm3GSwp2cWPrPqPhNx1SWXJHS2ekYdau7cm?=
 =?us-ascii?Q?oenCZ5NDKGiu7wnZ4/ch9PKHXGdgOZciOnTfk300F+FSgO2eyNKhjOIMlcvb?=
 =?us-ascii?Q?QEqoG61rlwp0A4y2zQltGHlzJmmJymLErc2K1grGdFYA/oDYJYgbeyBMJL0L?=
 =?us-ascii?Q?sYsyX00TYJplWSoOTpnBbltXJjdiBAF9A2ohBPC8mO7l2dUbn8uwSaC1/XHr?=
 =?us-ascii?Q?z+8wcgdypJhvxRqZkJX3mUXSkFHPfCdKVXGpNZSrGHBqgJE8OvMvd22sFg+W?=
 =?us-ascii?Q?TUN6d/A5+rc9ySAm7M+8rZ3AH58EvdCYDDuAMBeVC+bDQRVkmebMsQfKh9a+?=
 =?us-ascii?Q?Yhgq+URwfjjD7USx2TDa5JuXS2Koe2AChpub7+PH8vsXT+9/0eBZE8C2gU4T?=
 =?us-ascii?Q?e62o4U4+ba/NYsvatZDw5kUMNZE1S4TBvH+Au1fQYP/G/hQb4ZERzfCQtMMJ?=
 =?us-ascii?Q?zif0uPRdbSMS7A3ZYQY9pKWeaYZFT2FJVQ8D2ISj5ZUbk6dpioTcCfkdqmix?=
 =?us-ascii?Q?x7uTxTXAdOe+3xjaO3ZMcaKlICQZ7Uq+PufgnO4vVv2+L43lTEMqyHDu/LYl?=
 =?us-ascii?Q?Pg+CT86KN/tHcVhMXuy1olrKaMPV5lbhsRuFyDrbaG4SyJdyXEnEK7qz/a3p?=
 =?us-ascii?Q?0lpSDYyffw2FiZtvRHGncpk9JfrTOfS/N0x5oyETdAed1kZAL8gMKthZuvW6?=
 =?us-ascii?Q?N5SMiKNJaVRS4B3IF3+NUMJJJACGYH64bSgZEnuwNqVOF0Ekiw2SKZCk3jq4?=
 =?us-ascii?Q?2rtvknY3oKory/RU9bs0Y0vYw1JOept+6uAwvPG4LLppanq9rFUoJ2fzcGus?=
 =?us-ascii?Q?sQcHQ1bExDLj5bv3EhNEzU0q9NxWMUGgFQW6NPdgB07qHoDYE9Mz19ppUnqZ?=
 =?us-ascii?Q?Dp1cmuua00fi/hF+lraplb0cSZyoB6epV2bez5W7JQIXI46r/r542oH00l12?=
 =?us-ascii?Q?diaO7Bn8smRsu3WoJTPRXTpX20PTWPOlZffzYC9tGd+hkg7AKexa0cpJyl+b?=
 =?us-ascii?Q?iFK3RfoB/Sf4el6auo0yKVkW2hzdjnmXZo/MOMeEqxoGA/ZkCxc0hVTqGb6M?=
 =?us-ascii?Q?q4rZE7kcwm+gnIVN2QkRxnbVHEqkWsQUbqM/cWa5WxAKzWyQu6Hb1ZqTEkEL?=
 =?us-ascii?Q?AAe/5khIL5/60P/QM8r2Vwp+hUyxlHQUi3RaR/FdmeaNq0GWJ+Ms9qSEkJev?=
 =?us-ascii?Q?/WPspYzWc5UqbkPniI3Cawyt/lHJ+G1z3Ri720S/UENMtUjFiSXBqwWm8EPS?=
 =?us-ascii?Q?aVpUFQfZrqEX4rW7YvoZnuV2/UyR6wWK9cnBLFfuZzVTdbohJ1Pi0vjh3Dmx?=
 =?us-ascii?Q?XiMgUWxhxwk26b+yS0/1tDs8UCe2TxqHTJmpFeNIzRpUFkUbsoZODPYeEzzJ?=
 =?us-ascii?Q?Q2Bm6J3tNBVHjEpEPW+eeQaC69HqMDOEqc2wEoYvpX2a8+0CeH6qoAWQsdYd?=
 =?us-ascii?Q?oUvR99u410EZhhDeGubmSzit0Ik9VbR98QpXxecNwIMQXKiK0Ipd4MubGrpI?=
 =?us-ascii?Q?Fw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab1c77dd-53de-4ad3-9066-08dabebb6bdc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:22:20.5218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DFLG1YnedBlYGjsb4GHzDRHLz4KV6MHE/RqEjmr5U0iNGMD/pUfLl1iADmrm2+oabHvujvfZxMPwqkyh4gUJOdkljs/1Na4yYGNW8XkWWIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-GUID: LxW9tEtDgX0nnmtAycMlH4qgr4QzmH4L
X-Proofpoint-ORIG-GUID: LxW9tEtDgX0nnmtAycMlH4qgr4QzmH4L
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has ses have scsi-ml retry scsi_exec_req errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/ses.c | 84 ++++++++++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index c90722aa552c..d8b31c0b0125 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -87,23 +87,33 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 		0
 	};
 	unsigned char recv_page_code;
-	unsigned int retries = SES_RETRIES;
-	struct scsi_sense_hdr sshdr;
-
-	do {
-		ret = scsi_exec_req(((struct scsi_exec_args) {
-					.sdev = sdev,
-					.cmd = cmd,
-					.data_dir = DMA_FROM_DEVICE,
-					.buf = buf,
-					.buf_len = bufflen,
-					.sshdr = &sshdr,
-					.timeout = SES_TIMEOUT,
-					.retries = 1 }));
-	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
+	ret = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cmd,
+				.data_dir = DMA_FROM_DEVICE,
+				.buf = buf,
+				.buf_len = bufflen,
+				.timeout = SES_TIMEOUT,
+				.retries = 1,
+				.failures = failures }));
 	if (unlikely(ret))
 		return ret;
 
@@ -135,23 +145,33 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 		bufflen & 0xff,
 		0
 	};
-	struct scsi_sense_hdr sshdr;
-	unsigned int retries = SES_RETRIES;
-
-	do {
-		result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = sdev,
-						.cmd = cmd,
-						.data_dir = DMA_TO_DEVICE,
-						.buf = buf,
-						.buf_len = bufflen,
-						.sshdr = &sshdr,
-						.timeout = SES_TIMEOUT,
-						.retries = 1 }));
-	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_TO_DEVICE,
+					.buf = buf,
+					.buf_len = bufflen,
+					.timeout = SES_TIMEOUT,
+					.retries = 1,
+					.failures = failures }));
 	if (result)
 		sdev_printk(KERN_ERR, sdev, "SEND DIAGNOSTIC result: %8x\n",
 			    result);
-- 
2.25.1

