Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C778C04A95
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiJWDIO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiJWDHQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:07:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390CB71991
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:07:01 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKv6q4032405;
        Sun, 23 Oct 2022 03:04:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=kNhnCtd/bjWJAR7WrKCvn1pKbt+hXTClC1leFeXMEzc=;
 b=ujJ524zPqWnu2rCEZvs2wx422T6efYpPP8qKrP5c5/hHk4gApYWfcXCc/T5Qd4cE/MEX
 8RiutkP844D/HjjMwY/EnBYZVhSS0aeR7c1bC0lB5VOfuThtsWUk6Hzj50T8I5bI+Tyf
 TlZ5qkgfeWnGIeQOSCfmCgSF5ISD5y9WrWtTShbtld9CBEHwjnquljRfvkvdMb8bHHay
 c0PM7eE7lSsUCdCWs+62+kFGd2XAv0Hz15CiIXQzVPQSlZ5n55zhN8Xhs6tQDEtaKJtT
 cal6bMlgjpfzrMp9BAXKjpfIJ2JS4cQ+IMQqhyhcxecftz0JNJB6ScdoZN/P5gWPcxQJ KQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8db95ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:48 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKK0EX002602;
        Sun, 23 Oct 2022 03:04:47 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y8rhp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nAoCUhs0DwX+QudV+tLwftjdwTRSXT8DD9f62Z7bvu5NJP8JkGJQZEe2eMa0cQ0q+qE6zenlu4lSpFtOlbH/A53rmwd3Lik4Gc8KxaC6D4tlv+2fm6GaK3r53MQHo4G0qTOlZoODR9BoMmt4CiTaP7nz3YwIWYZZuu5yZX3R59QEIhNzH3nvTHsEQcvFM1AVIxFjiqorPrlvR1U4LH1ERNZ2NFncgNnBZhfZ5aFk82I5mc+GsUCwwBkRES1er3IGR5JDCSyWYoazo6hHGXYjNHVxPLk8zqzB9ZDqaitGO7sQHJuKmp3Z38DLnWhSl4sADihLylICLfruaAq6yx5HBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kNhnCtd/bjWJAR7WrKCvn1pKbt+hXTClC1leFeXMEzc=;
 b=jlt4JH3l4dzfoVGRGp4aWMnfSXO1hG5WdxJqeQ94rAlqxXavhmbRwygXo0GdfLeeFPuCsAKMzGAkEsuouzMtYNx2R+SNIDdlv7QXk37FwiMk5Xl6a5ky16eTs06/iqUK2cymfxFRp7j77tlLBwd70PF3HlDYvlA+hBYU8KSrHjSO+P7iXEMuVDriFFSLHdKyInnCE1qsZ/RZNA6ozp2+bKI6wElnHT9ntiZZU7q/V4ZeSWe0KjyIZMjYOyEUugANgH8/bY5vy3+q7mJogvucdwR70u8sskJI3BOlXJ8trxHBAnl2Qx24U8ojrnBtnzwOk1QmrywnPaSJuJBM7+9JYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kNhnCtd/bjWJAR7WrKCvn1pKbt+hXTClC1leFeXMEzc=;
 b=yKbIfpNE8vEai+XYSBUF2qJMGofqjVy3yeDiO+YZzHcP4P9VwffmI34EL0NegUJ/GBU3L/rzY1n3HToUEQqqIE9k7MHOucPezkAEJodn5ToKpeYEFt6C1kHo69QsVGFFOKCo8M2eYcKIFjj53A6MYfLu1fr2aN+G50Gk3B/b7gE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Sun, 23 Oct
 2022 03:04:45 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:45 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 25/35] scsi: rdac: Have scsi-ml retry send_mode_select errors
Date:   Sat, 22 Oct 2022 22:03:53 -0500
Message-Id: <20221023030403.33845-26-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0336.namprd03.prod.outlook.com
 (2603:10b6:610:11a::8) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BY5PR10MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: f835d307-6f81-400d-b2cb-08dab4a356d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5f+3UdGnFFYtp5ZaZsuymHET0g73mMv/ta9YQd02t3hZVTgUehz+OfL3AiWUtw6IvsaePhcifiS8R5Cc78cHLpVjCjN0zMAOe+Hi1epyt09CjT+XD+NG8Hsuygks5WgNTQDeVXMpov0txY074JgzVejgQMMsMAw3MFOFE8Idyi98xP7qQYV3bRI4KklEGm/XYmw9vorswcr93fVb46OvjyOGZfU7mpTui9uwraXSWLwyGsMtP7GwVgma8kO1MDJbpwz/BYt+D9ZI+xuTW96sB3yD+Arw5ih5Fw030dnIAiHoIZamcUJ/YqyhGhA78yzoWBRk/juDQ230z6mEF0ojD4j2pu+iGbgHqToSz3O68L2c2XNZ9dr+ECRmrHt6Hz/S4V8VQO/jQGw/V9klHmqYmYJrAAiLQpwGQWk4RmJLLSu3kYu/U48Xt0BENnHLJkUtNo+3LQ6GSkvFwj/D040BUlm0iFe2lLPMdVMhEoVZjJinU+27Trzqf/FL9o/D6/kyqPHA/6c15pSgZ27J9VJoYVxiybMvoczOcDVlDjXGClL5ucgUPJzH87apTG8aVMI9g7Mo3dF3qOLMbXm5erfFnrWSGTK/1cXxEC4n83NG9FO9LYpfbIqlv6snTdIZD5eJCc8VFGVsd/2Iel7rRe6UuioctGTs+OfO60EPUguabuRXhe8cmCxxN2101veq9Sd/C81DaQBGV8Ky4Hg7BIR4Ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39850400004)(396003)(451199015)(66946007)(8676002)(316002)(478600001)(6506007)(6486002)(6666004)(4326008)(66476007)(66556008)(107886003)(8936002)(6512007)(186003)(2906002)(86362001)(1076003)(5660300002)(2616005)(26005)(41300700001)(36756003)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zA0F26ihcuxJdGET/pCB6/nieX/rgOHjdkBMDZEPE2ZxHIL/AuIndbTz1g98?=
 =?us-ascii?Q?vcQdNwO4RQO6jG6XyWK5bcOE6V1zeoXMlzOwAdpN1hZOSmWH7eRUxt3dd8f6?=
 =?us-ascii?Q?1Esn7zZvGsNt3N+VKGPXGQwKX9OVQPyS2SW1iMz61HVI7afRDvbMvgVqsqF2?=
 =?us-ascii?Q?0OC3ippG7Sm+UmNwk1WxDZf5V1EIwNsu4c23zX5mXX3Yafc9jjzFyHyRLVpB?=
 =?us-ascii?Q?opbijiBubDkGhYl7p/4jdiFgDACdX4NMg0V9H6mqaJ7OspPBBFpDw+z+PoDb?=
 =?us-ascii?Q?4ma1vgnOgaZBemdbzd2pEmohj7+5ikgOQ5sUt1oH1OLD0yuxaoTkB85DLpJh?=
 =?us-ascii?Q?OeHEazlllgpiZwGAwkJjrtSQvUEFmvhsz75Za/mKubwA/pMYZOLFnNz/Tfkc?=
 =?us-ascii?Q?mYQbKWe3Fu0GD0hjbCrC22UUnauBRc8HcxQ8JdVUtDUIGAl6gD7E3XsMR3kP?=
 =?us-ascii?Q?3KLSSrVhkdjbawzvzKxo3Ch8Z32SEG6PK+mMzeGlQ2f4c/qIuDPC7EIZgQpF?=
 =?us-ascii?Q?uU+j3UmJB6lN4W+LDmSgi5Kn+FavWYw5rIjHH1zaIT5y/OFRrKvwLd66CB1g?=
 =?us-ascii?Q?1XsfQ6oKmcF6n+XmMbN7TI2ntZtUjYEjbW/OaTtODjinoj3ZH9hnNAWbRuO3?=
 =?us-ascii?Q?glyHIbbUVhsOQciOy6bCw0hkpsYACc1g0vsFmNqYLR3GPld2UsBl/rOfOHwB?=
 =?us-ascii?Q?qvmaW3HmCEDkb/nEJqflggs3iOsjKp5FuGXqH3b3aN70FwnWfeeHvc+QbaJX?=
 =?us-ascii?Q?qM9uRF8l7qEjN5oSxfvCWPjwX0BWMaar0TEDzWxLJWxefBQAZDfy/hmrrFHr?=
 =?us-ascii?Q?RsZZaAWjZ1LCgBk5gp8yuFVmo/Rx31uBCmcfbKp5LAgXml0TtB699bfxKU76?=
 =?us-ascii?Q?IvlnORsUeORTMeoAV16xjQTNYqJPRzFZ+0akzGFsXyZET2DM5y+PqaIsCCBg?=
 =?us-ascii?Q?WSwp3eVhM1cpsFL0FNMLF+c0pEyleGhPeG2t9JRcvmmeYT32jbQAOROituhh?=
 =?us-ascii?Q?RcdW9OdEPL063dJV+WMjYFwo8Jfr6YdikopYSF8Vf28AS8jqkFW+MiSzxgE2?=
 =?us-ascii?Q?RUIdpMg7uoOrEkBuEZgHm/tQNmfqiX0+lI5kK/z5/r6hxGBeQ2h44aBlIf/U?=
 =?us-ascii?Q?iOQAsoiFWMG0J2GNvo2PgbG8aJDOKDmkgX4i/fhfvXVveg8Q10nQNa8rP9vV?=
 =?us-ascii?Q?Cg/+sAU/m2qtpvSOpLkJNhjbhoAXjtGkWjbt1o/+Y9SFpo4Z0QKA1p1V11n+?=
 =?us-ascii?Q?6UF9f+J0LwhK1P8kygoyDVEzBK4DkuBF+UH9WWyI6ohPxwby1ZqS1SfUDuIx?=
 =?us-ascii?Q?XXjClwSnEz/dCUjZeN5zeu0NVfbVog6hbIRrlSozdttr5cGK4tQhahSGfcMj?=
 =?us-ascii?Q?FxHwOWHs4M3NGfTC/oEo89ZDUWCXyJKIFu6aG9AyPY13bg435UX6uJ46peNH?=
 =?us-ascii?Q?mo40SeaCXvCI1+irjf5KnbgIB+T62p9s/TlA5hzIDiQQWwCDT/Kum5Jw40sq?=
 =?us-ascii?Q?8mrhuVf2GFiMRFUYBgkcphD6kN1EOVwXWe8pE2djdL7yEbr9DS8Y1SWA9CgA?=
 =?us-ascii?Q?qLOGuRdKmqsW11kEik6Zb26Jp4JhaWffeWf6E72C2kPnOKBkSL1ScOpS9/aI?=
 =?us-ascii?Q?Ow=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f835d307-6f81-400d-b2cb-08dab4a356d1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:45.6692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Fi9JqllLOteRbOvg8deNH/OdgdhXDMWtj748VrDPUcLLtt2T0fbpZf0wI1wk8YhYKmXrvAuz0MRrpF+zjJHsMyk/dPbEgvUyrsOSSJFqbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4337
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210230018
X-Proofpoint-ORIG-GUID: _B7pmvizdE8ty9QYUABAci0brkx7x9U7
X-Proofpoint-GUID: _B7pmvizdE8ty9QYUABAci0brkx7x9U7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has rdac have scsi-ml retry errors instead of driving them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 109 ++++++++++++---------
 1 file changed, 60 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index c4d1830512ca..953fad6ddd66 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -485,43 +485,17 @@ static int set_mode_select(struct scsi_device *sdev, struct rdac_dh_data *h)
 static int mode_select_handle_sense(struct scsi_device *sdev,
 				    struct scsi_sense_hdr *sense_hdr)
 {
-	int err = SCSI_DH_IO;
 	struct rdac_dh_data *h = sdev->handler_data;
 
 	if (!scsi_sense_valid(sense_hdr))
-		goto done;
-
-	switch (sense_hdr->sense_key) {
-	case NO_SENSE:
-	case ABORTED_COMMAND:
-	case UNIT_ATTENTION:
-		err = SCSI_DH_RETRY;
-		break;
-	case NOT_READY:
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
-			/* LUN Not Ready and is in the Process of Becoming
-			 * Ready
-			 */
-			err = SCSI_DH_RETRY;
-		break;
-	case ILLEGAL_REQUEST:
-		if (sense_hdr->asc == 0x91 && sense_hdr->ascq == 0x36)
-			/*
-			 * Command Lock contention
-			 */
-			err = SCSI_DH_IMM_RETRY;
-		break;
-	default:
-		break;
-	}
+		return SCSI_DH_IO;
 
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
 		"MODE_SELECT returned with sense %02x/%02x/%02x",
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		sense_hdr->sense_key, sense_hdr->asc, sense_hdr->ascq);
 
-done:
-	return err;
+	return SCSI_DH_IO;
 }
 
 static void send_mode_select(struct work_struct *work)
@@ -530,7 +504,7 @@ static void send_mode_select(struct work_struct *work)
 		container_of(work, struct rdac_controller, ms_work);
 	struct scsi_device *sdev = ctlr->ms_sdev;
 	struct rdac_dh_data *h = sdev->handler_data;
-	int err = SCSI_DH_OK, retry_cnt = RDAC_RETRY_COUNT;
+	int err = SCSI_DH_OK, result;
 	struct rdac_queue_data *tmp, *qdata;
 	LIST_HEAD(list);
 	unsigned char cdb[MAX_COMMAND_SIZE];
@@ -538,7 +512,49 @@ static void send_mode_select(struct work_struct *work)
 	unsigned int data_size;
 	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
-	int result;
+	struct scsi_failure failures[] = {
+		{
+			.sense = NO_SENSE,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ABORTED_COMMAND,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			/*
+			 * LUN Not Ready and is in the Process of Becoming
+			 * Ready
+			 */
+			.sense = NOT_READY,
+			.asc = 0x04,
+			.ascq = 0x01,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			/* Command Lock contention */
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x91,
+			.ascq = 0x36,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	spin_lock(&ctlr->ms_lock);
 	list_splice_init(&ctlr->ms_head, &list);
@@ -546,33 +562,28 @@ static void send_mode_select(struct work_struct *work)
 	ctlr->ms_sdev = NULL;
 	spin_unlock(&ctlr->ms_lock);
 
- retry:
 	memset(cdb, 0, sizeof(cdb));
 
 	data_size = rdac_failover_get(ctlr, &list, cdb);
 
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-		"%s MODE_SELECT command",
-		(char *) h->ctlr->array_name, h->ctlr->index,
-		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
+		"MODE_SELECT command",
+		(char *) h->ctlr->array_name, h->ctlr->index);
 
 	result = scsi_exec_req(((struct scsi_exec_args) {
-					.sdev = sdev,
-					.cmd = cdb,
-					.data_dir = DMA_TO_DEVICE,
-					.buf = &h->ctlr->mode_select,
-					.buf_len = data_size,
-					.sshdr = &sshdr,
-					.timeout = RDAC_TIMEOUT * HZ,
-					.retries = RDAC_RETRIES,
-					.op_flags = req_flags }));
-	if (result) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_TO_DEVICE,
+				.buf = &h->ctlr->mode_select,
+				.buf_len = data_size,
+				.sshdr = &sshdr,
+				.timeout = RDAC_TIMEOUT * HZ,
+				.retries = RDAC_RETRIES,
+				.op_flags = req_flags,
+				.failures = failures }));
+	if (result)
 		err = mode_select_handle_sense(sdev, &sshdr);
-		if (err == SCSI_DH_RETRY && retry_cnt--)
-			goto retry;
-		if (err == SCSI_DH_IMM_RETRY)
-			goto retry;
-	}
+
 	if (err == SCSI_DH_OK) {
 		h->state = RDAC_STATE_ACTIVE;
 		RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-- 
2.25.1

