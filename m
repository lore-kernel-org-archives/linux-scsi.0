Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 207F6EB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbjFNHVj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243367AbjFNHVZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:21:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C77294D
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:20:26 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6kNXd015669;
        Wed, 14 Jun 2023 07:17:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=r3W0+djsfkUxKXbg0Lv0wSGTZTT2l7EgNK3we2NG1ag=;
 b=xFuBqBAKjyr1tXGnGYUSwukEi98jGAHEOZ5Ho0/wzNCfhGkc/3vpLtuv8gtXPgUuCxFF
 S/HFRL3In7Bc0OrqC7j/8HjyiLML7LXWLMwEmJxwZFf9Z0Y+q7LdRjlCDzCgrLlNEzUM
 omOtp6r7g+K0sQnYlnnIb1MUrDwE9UsAjPsBQOeQ1Pgwd+lGCxzvzSFhAr2Pf17T540d
 zTi8wTyWdY4DBRvBdzqB1RTWdQr+os2FQ8t+Ux6ZGubgeO3IlmGOeF9LOvX5D0m+oA5p
 A08CeHBXPR5BgxCucxXCFar3Vc06AexIsPe+uobaTU+/NoqcMM8E9ccP9ensCpaOpTu3 hA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4h2apusx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:33 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E63X4i016344;
        Wed, 14 Jun 2023 07:17:31 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm56pag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jeRT6xg+2JY9d3SZAc+Cnk5x/5qktYezS4VqChMe4JOuJeHAMqbwp8fxMurYdEAdmYBxOptoJc3hIeM+/BScYyQ7XDmTJAbDoWd2LEsfEAi2+iav7gntKAN88aK1+sZi54Q4VT3qklTOp571YV50tsjgOe1tx4xzK0xfOkXRkPUYT3LjkbVNU0fmMV879LKhlgRojgYMaWw/Z4WUqRhj8tPYrquQx4EetuL0m9ZD3tHPL+kOs52CiO31j9+Xl3mLNbe9P/lctY4gv/4JtkTPuTwW1ldZmen7cZ33PlY50Pf3unrk64Vfe/w4RTXBaLp3fs5N5fPZdxFO1683APw1LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r3W0+djsfkUxKXbg0Lv0wSGTZTT2l7EgNK3we2NG1ag=;
 b=VeWbVqp7OLvg1R1cMye9s/LwDtA9rv8uHyxG7yWZlbgLUUEILojW9bKh+OT5qg/pzDC9yVScM0gx8+pjAcUr3j09Rb6aYKJ+H3NFXS+ciapC90ZyN4ohNs7MqgsGU/zwDGUrDCTU4ZVWpd2F7YPRV4QyRlQLC5i7C9OgpAhe9VaB5It8c4vxQkzI+Y1M6PaGHwAEcoSM7yJqgKH7+4el8XB6ISxh4nepyhRXdPnVX+4UYYo/7K0niNUUgMwFP8n2SxP93Ji+QRoBiaYUQK5ij6Hb/VxMmgDhDSVidWZbZBS9/fWUapJY+avifGKbZkHhkAsVnLvu3gc3ToVKGkhF4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r3W0+djsfkUxKXbg0Lv0wSGTZTT2l7EgNK3we2NG1ag=;
 b=cxA4B4AwMHrn6nZIf6ENY0ZrHtfzvOhjbHE8wj9uDKB6jhxvE92ypaGXkLoyAfZSDbYhoy/x4IErv3cfZ3dZImTe18vAJ2gncOVMj1Ft7qEijVLeWmOi4bzZ1k6tjp8kZ12/ZkFPTjU/uirpuUSIU9/tjKojopbxrlBI1qScSQw=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB7030.namprd10.prod.outlook.com (2603:10b6:806:349::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:17:30 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:17:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 04/33] scsi: Have scsi-ml retry scsi_probe_lun errors
Date:   Wed, 14 Jun 2023 02:16:50 -0500
Message-Id: <20230614071719.6372-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR07CA0001.namprd07.prod.outlook.com
 (2603:10b6:5:3af::10) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: b4841dd7-c10e-40ca-953f-08db6ca76a11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QrFcubFt5W7rq+caHGaCEC748uj85JoqE1AXVCg8M4OsmOyK++8UyKhgseUuw0D2GZ7EWoORAy8bC/BmrkqJnT09HDQFTTdR/o1MXnANgXWrzG1HHlfyDotjDS/31GZon9UM+2dctb2Rsc6hMrp39RTn7+lygoaAuFkIbfaTFQXNAgSLlZI7Oc8OeGVWwC8jXU0OG8HK2wGflCDqXMBj+ateHHSoOC8KfYp9WLqvctG9QusGDRC3PKRh0FfpTQfq/c4gEfwfJX8AO9h0Q/G5SalTKQio7Kt8KI2Ze55bJketxOHzWbJ/Gn434uK19yZDN5L4EpRL1X81vG1MPcIq4avSfEgUq/+Ndlu2pxpLChHTdFu8AwGn7gbtsjNUHT5IB7DH6wTLj2Ws6kl/CvT/ZcTpul9SwgYxJDbLEwY0238PfwaF/5SLr8Q0qWk8YeCcn8ewmJhoHuqWkQcQDfVyVCjIKuAuXzhUuJXgLrUtKkM5dICgN5JfaEmnAAgyKDquqeyQEM7Iw55ufIC3yp5Tc9Tf5TQwhNq9xdvRnvmCw8ludb2GBIcetM0jzqtP2td5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(66946007)(66476007)(66556008)(478600001)(5660300002)(8936002)(6666004)(4326008)(8676002)(36756003)(41300700001)(6486002)(316002)(38100700002)(107886003)(26005)(186003)(6512007)(1076003)(6506007)(2616005)(2906002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SxmV+cwP6DWZ3gJEWlxkype1yd1DAYLcazqUbUv4mSioLr+ZvSg3rhnN013k?=
 =?us-ascii?Q?gFSX/ENI6tDqTZ8YkGpcOryQBaZePWPbzg+1XOZzm+rsvKukuuW3RAxi0y8o?=
 =?us-ascii?Q?mBaV+xpHmXoQFyqWqu5ithU31URY5RgrpPeOlB4WwEP6+/wvKDVyfpKK5HYz?=
 =?us-ascii?Q?lNjUkb2jZwTQq+zQLAKiCzhBFh5Z1bZ/6wJAacUTgK/+4cjuI6Gzr8Vy+YID?=
 =?us-ascii?Q?sya3rXRfURMcfIdxXEsES2E8XGBDtLM5avpOY6/6PZKFRQ/VwpnLkhMijO8E?=
 =?us-ascii?Q?4ufPUux9qKHlFxNxx+jgD7eQXwGw4H1tmTpbRZb3/Y71DhOUu20Jp56f66RU?=
 =?us-ascii?Q?SK9LEQ83jVANGYlzIZoIdcEpZroiThYAtZAQtG91rKKAsQ2XT0pEvs3CHnCj?=
 =?us-ascii?Q?CJnNGuD5ZegkKK2Ili7qApyr5XO17DyHw7TONFR1QCKBzdfhoxK5uwsdmSR9?=
 =?us-ascii?Q?y2GvPBOc45yHhvyStr+xJhm6ZB4G/loOqsYORXYHZLm4IUBdfrWWNb0P07a+?=
 =?us-ascii?Q?ylxhN9gVLv7LlW5cOfgD0m6Sz56yo0q2DmCikHd762WB/2Og6gxyvSYt7OEv?=
 =?us-ascii?Q?JwLJ8qTFdWwrUUuegjGReKcntF8x4ICorZQzLIABfryZB05w4UPAhWtsZjkn?=
 =?us-ascii?Q?/euZnRINDhoFYb9NNOaW5b4VhemnUo41/M4F6PIc+AARIREsewiynhxNn1GW?=
 =?us-ascii?Q?ZJYcyRaIHK0bE/Gead0iIoie/HHZIYyx4vyR8PcrvjSQnvPChgRKXot6znLa?=
 =?us-ascii?Q?6XmJ7LHUaXlSZa4kH8xhyxT59TM3eD27QEi3sMsnW6K7D5OtICbYXWvqwdAH?=
 =?us-ascii?Q?34kTSu/yboFTRBiKOmnM5AcjQNyiUsHBsXlnUG+QYMTMvxbXVGvTtzhbysvG?=
 =?us-ascii?Q?uZDNNEDazS3OGoXYOVS8kVHumGUYAUVjUcJ3Z9LKW32sbkOVCtRw5cmAaqgY?=
 =?us-ascii?Q?lhBVYhI7Q59fu1ZkdTlznAIRZ5gxV/YIO9E6mZzT9Wyod85Qolws/k4MdiF3?=
 =?us-ascii?Q?JUR3GN1Ur3pCMk+pGB/sdnvntUcAr/3n03TPt7Z3E6ZWr1CofRds4NshTh/e?=
 =?us-ascii?Q?yzritaCCZ7L6vY4MPQ3nNefiO2QW/lU6IT7LhZ1HRcRXg6X8EVvvVEphJMEZ?=
 =?us-ascii?Q?zmoQDiRwIXrNLtlaYLGQOn2OdI2m3cgulOWAavp2pLjgsVRKZpHk3p/nfSae?=
 =?us-ascii?Q?7JNMIdYbhW1qkqptR2UlBw8W2MAw2SaaUFmKyNDT7enkMlLwjVG+1pAVvZAj?=
 =?us-ascii?Q?Mi72gTWG9/w4tcE4fZ/YhTJlKDk4bwHqHAA1sHxCCLHH0x9hKoYvc9rfE8tu?=
 =?us-ascii?Q?lvDfPJ/jx4Kl82bLt2kxHGbPHAWCHNe+VN4Z36kCULSHFvps+skDUT/OIuI6?=
 =?us-ascii?Q?RRecW33K3S/yVaY7b0WOlW1DG+c+BXF2KRszef2MmP9/nhjkHwuyCzh5yS2l?=
 =?us-ascii?Q?2L9sL+xY+dtNMoxxvTBm0I4rBKbluCEbZmNnyP4vzQUuq++RGxxD7ZD/3On5?=
 =?us-ascii?Q?zai6M2xagdkeTTMTy8pUgSGNtcW+uB73lXi4Tau4QS1UlSt88ubmIfGFgrvv?=
 =?us-ascii?Q?hrHeXZY6jpblNmMWnYomMrVknDTY08jMx4DqAMPtCuK+1aEmVh09Xjtb/nvU?=
 =?us-ascii?Q?xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: oSVzio+vdxwgV806pmDqgO6gG12ZStAyxO8V7hdIHZJUodQO3mnYl63vfqzWLTPk7qLIV7OLrVzhLk2evraMY1mzl4mEPvJgr3BbbviNjCNrOUlxkZ7Tkrhrbl2hJ2wviCFkvnzUDYWzU7MjVbR4WUUgUlHI8j/2V05dFwpDS2XdrGwkYfoXnu0DfkUiKNjcaraW9y4GlYY/196iegxcLVXscqNYfQSBZ3UNN7Ph2CigYld79IpktjYKZWin1srmvpHbhzNRFLN8dT3xHDDCKiUemY6JV39sFJUFcA2KbrlC6GLd7QmKdz/4bxcgx31BV+bGbMPbVy8idAeNCSZ+gVfzV2ZW4bYv+0OAMRMIBIJ9/TAJYwkGpl6UJf+lXqz9wzO6IPb6XWvk5BeASvLag8rTqzfboT/gLSGLqn0rvzAkwbyD3WKgon9LbgD1cXdzu72JN06iO6kTk32M/aaZRKBUjNvICEWwkkbHXdRqhzwD4KKR6fqUWaApD//cEBQqtVZfajU47KM9zEU4ONRnFmdpIdYNqI17/nSM+KdzVq0bTxwmyfmqHu+Urz4p59SggFNeQMqjjNXu2xZO23r/XLFIJj2Pl1bOZMhkPYjgA74JLLZOyJQDGLKVN7iVq7egPiiHx/TpNVTzx+XwLCO3U5hymkjcpxrshCz3pnGXGQSpFNuu6wREr8BY+cK9NrwKmdzJvJRj+Q7P8AS0NNCwjbgWRucL8buCFCBScK7GYmlQzZIrAUfFeQjnCJD/en5UwVvJ6XfZu+U35MtnxjfJ9ABW2tv5IFQ/hYI6HkXMs53h7kC+ABrjmHrS8Gn63s0N1rcyf96YFN0C4fTJ9YBiIDGiNyBAagHXxfCjR2zjKpIJrpngYh3i3p74kDih/JqM
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4841dd7-c10e-40ca-953f-08db6ca76a11
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:17:29.9003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tPi2F1YN/NPkX2f0VaOSm1lsEpLxL5xdyESs++L4nTPocla9PljknJtYX8oXG9ZbgCq8ngRumqyR9QIzUOnjO3qYhY59lj91p5m7bcK2qh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140062
X-Proofpoint-ORIG-GUID: nbluJhNH4JCpzkmP4_b9QGEiNhG4NqPO
X-Proofpoint-GUID: nbluJhNH4JCpzkmP4_b9QGEiNhG4NqPO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_probe_lun ask scsi-ml to retry UAs instead of driving them
itself.

There is one behavior change with this patch. We used to get a total of
3 retries for both UAs we were checking for. We now get 3 retries for
each.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_scan.c | 42 +++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index aa13feb17c62..519755952254 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -647,10 +647,29 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
 	int pass, count, result, resid;
-	struct scsi_sense_hdr sshdr;
+	/*
+	 * not-ready to ready transition [asc/ascq=0x28/0x0] or power-on,
+	 * reset [asc/ascq=0x29/0x0], continue. INQUIRY should not yield
+	 * UNIT_ATTENTION but many buggy devices do so anyway.
+	 */
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x28,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
 		.resid = &resid,
+		.failures = failures,
 	};
 
 	*bflags = 0;
@@ -668,6 +687,8 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 				pass, try_inquiry_len));
 
 	/* Each pass gets up to three chances to ignore Unit Attention */
+	scsi_reset_failures(failures);
+
 	for (count = 0; count < 3; ++count) {
 		memset(scsi_cmd, 0, 6);
 		scsi_cmd[0] = INQUIRY;
@@ -684,22 +705,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 				"scsi scan: INQUIRY %s with code 0x%x\n",
 				result ? "failed" : "successful", result));
 
-		if (result > 0) {
-			/*
-			 * not-ready to ready transition [asc/ascq=0x28/0x0]
-			 * or power-on, reset [asc/ascq=0x29/0x0], continue.
-			 * INQUIRY should not yield UNIT_ATTENTION
-			 * but many buggy devices do so anyway. 
-			 */
-			if (scsi_status_is_check_condition(result) &&
-			    scsi_sense_valid(&sshdr)) {
-				if ((sshdr.sense_key == UNIT_ATTENTION) &&
-				    ((sshdr.asc == 0x28) ||
-				     (sshdr.asc == 0x29)) &&
-				    (sshdr.ascq == 0))
-					continue;
-			}
-		} else if (result == 0) {
+		if (result == 0) {
 			/*
 			 * if nothing was transferred, we try
 			 * again. It's a workaround for some USB
-- 
2.25.1

