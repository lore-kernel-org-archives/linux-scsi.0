Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D0FEB64DB
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234661AbjFNHXT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243442AbjFNHWf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:22:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5899019B7
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:21:02 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6kNZE023133;
        Wed, 14 Jun 2023 07:18:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=JLU7rFNEtQKsVCDOco7IV3BGt6wtju/2xRcZHuehrcA=;
 b=WxjnX275QLgoxUb0XZOnw6PcYWNJltb8T6yM3sKASIEsOkQhiGrHQKhqoWSqlz1W65DD
 wkZTEFKSnybIVDw41BvWfku6hNhpCJDW3RPrRfkEOIe9Ls1PsQzdlnU0mvMtY8VzvYMS
 /Pvfq5vjax1mgrIM3DP/Az82a2x2yS9Dw3zO1mFUcH6MZX0D//HSBqUtQzQKMS75BIRx
 aTnYOPeSsCzMArMaeqxiLKnv54agokb6c4v2SYLHzZmnQRfq0y0avNCg47Mo+lKxuxV8
 aCjl8vBEDSoGK88Nd0ThomXhuJ0V8REeUhzTWI4HWHz2Bj3DFdOJRLH1ZTTn1kg5j/ai pA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4hqupw8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:36 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E5bIXc021593;
        Wed, 14 Jun 2023 07:18:36 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm56cnn-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JyZksM+rLTKmD4g3gfmm0bilVbaodOr7QxiMKdwH2SXUaftLKlTFaaC+TKcbltMDfqw9gpoC1fbyeK4h2IsMgVLVMiYUz75GtLe/qWCXxA1Os8iBnco7ZnFVOVcLCJGSe/7RVABeL4Rdr4QbzkXJTFteVCQgK88sLza8vd9I+pcpCATMgFlahcNohRhRANyWuarr//E/sIJVymKowBQMjyHy+zRQde066vGNaAw90ZHsMv7kzmXYZGfFq3VuHfh0z7zkO86PGT9GfrIMmAUgitPVfJdRP2RwARHpB0fcVpRnDIL3+pz1MEjJAQETnLC3kLVAqMFmxKVZlsrkhXaekw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JLU7rFNEtQKsVCDOco7IV3BGt6wtju/2xRcZHuehrcA=;
 b=QIesYgZKzu9t4G4wdj0OaygSwirkemw+Ze8QUEoW6JdQeUsS02GJ+fWptXyFJGXLCRTgNg7DcjLyxFyTZyH7rLLN/THNMtFCZrz2+9wAwNDqNHL7LPjHOmswv/VTKR9ogSzXOOwdnjn/tLTgRyOgJ4by9bbZFFNj9MX/+mFaDm354L/dQLEtPPEkMA/nTX3w66m6l8lp3JNMAhH9JErVx79gAyPsa6FU0S1labZZQQ51++2CqVKzZM1/G2yPs0lVIVJTflVy377mf6vvLESYOdmOp2gRTmY3k4o+HB37UvPE0JdG8iHku4aTruofnN4N2V9OJwtQkP6n4ksuVIfaUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLU7rFNEtQKsVCDOco7IV3BGt6wtju/2xRcZHuehrcA=;
 b=WJ6dOddfRa6neyrQja4y8GBhm2LO1pbqCXJCi35bM3WNj0T6+sb/+gmEStP9z6pEXwhpNPE9TbCR928kQc9P/6eqXt3jrhBgnj6LCG1Fm/tZ3EuVWQApw0ZUe52L4ap+m+4n9GQqzX6yspPc4b9ujqOY4D4o3hsBvdIhqS4ekBg=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4188.namprd10.prod.outlook.com (2603:10b6:5:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:18:12 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:18:12 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 29/33] scsi: Fix sshdr use in scsi_test_unit_ready
Date:   Wed, 14 Jun 2023 02:17:15 -0500
Message-Id: <20230614071719.6372-30-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR08CA0033.namprd08.prod.outlook.com
 (2603:10b6:4:60::22) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4188:EE_
X-MS-Office365-Filtering-Correlation-Id: bb81f597-6955-45fe-28a2-08db6ca7833a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oxq4ukao7eLKGva5HqsecKf+TFs+5l75u+I5n27PzziZjIWySLFtS83F2qeX19ePQMXLZAgrahkI7fvonyTDAh2mwOqjdwH+HP8ncdW4/OAqxsv1TDPmCZs2rQ2Svaa8WiyL76LNYDoz7FoxWd+42xE5UukqlhLoB2VVOoTuZV+stVE48Vdq1qEUEj8uliYLKutc0kONXPdESK3hKBjkx4pFb1iPG3KmpAEu3WLOEu8uO8tbiVftOJij35wnxaGiqjzbui/osYUTFxvBpuFpnTPQKizwI28vmGElXiTIB7Keb171COCFH1hz4JPzqDh4tYHTSyxo8HBXEnW/llhyvOZhc8DERQ9ePNAh0De5hT2mbRUduGM4/NN9FpkpnfIiHUBtAgt9Cuw3Mk7dCjkTcnLi3hgwgwOEnOMdW4JxiOnzJ7l8Y7EwDJ3N6zU9qAsQ2kRqVrHMg4barOInpYsV2OvvDzlvIIzywUDlyrQzTWuUlTunujUKgDg9Or0dEyaTcbv6WvQxSIrOQ4zuEvTUV5Vek8791HrK+xaucxBzwo83D9utWDbXYs1LcapNtJFb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199021)(2616005)(83380400001)(86362001)(36756003)(38100700002)(478600001)(6486002)(8936002)(8676002)(2906002)(4744005)(4326008)(5660300002)(66946007)(66476007)(66556008)(316002)(186003)(41300700001)(107886003)(6512007)(26005)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FZJPuYDpPKpg58/Pn9tyDwH12iF9kHArFpzjibSPyHo1eSOZqD8XiAr1Vi/q?=
 =?us-ascii?Q?r2OUHVlbUbJh1/JQRlZ8Sh64+3gh7FUbGmuPRa30DEbVS9f/Et8BttEmzaVu?=
 =?us-ascii?Q?sD20LLT0/A+QUgjadXgpSi6ELKccjKs3nE1AlEOSz1zbjBFMFlo8lX9MCe6S?=
 =?us-ascii?Q?a8cApTFX2q2z2oRpFkpXIBckiqb38plJcX2zpxd/Uiv+eQVbIoOPLb4/LWeC?=
 =?us-ascii?Q?tw2vbqC2chaDmCTLvtI/NHlj4zXdxXHCqQl9FrW3aU5RdGxU+LB7MUamKrba?=
 =?us-ascii?Q?McT4QJyguc0+WoIz5jpZeA/xwM1cwLawEX8gJ2NrFCQ3o2WY/Z89ZtK6YWCf?=
 =?us-ascii?Q?LsCkI5xRx1aaQmQJz88z+mPhYMhNdc29V1fpiBfAVkAASESKiusDH1tw3yjI?=
 =?us-ascii?Q?xFle02Y1kW3pLFcezZ4aMkhgyfrY+1KQerCZePYpbk3nqVkKHQ7bMO157fTB?=
 =?us-ascii?Q?9V4uh894pJo1+03wXRWvkGTJQoLrJ5B+U57H68AgDkDQYyVP1oObqDaifEvt?=
 =?us-ascii?Q?8Qu3sRtCZHm8be2o6fDIhaqRx0YuZB89KGv2s4mM1M83LQcQLL6zYY9KnoiO?=
 =?us-ascii?Q?hq/+zFJAZAECPQK5LvX+b0DupEpPJd9n20nnSNNmsuOgIfkdKJ8psmgMhJUU?=
 =?us-ascii?Q?84GRCibMTYiO2tDca74PUqh6kOIWLIMNPlweLBnyWmbANPj6Q7Y0p11DfxfU?=
 =?us-ascii?Q?1Ezp72cH3z2j0r5D+vKznN7ixNx4XXfBSRWkBfMW3qdayeapU5bBA+j5zbth?=
 =?us-ascii?Q?txaoQEjSRpczJ/rmwtUnnqBHBD8fMB9q+FN8wz5z8r9Edy0RngrphgqdxHSi?=
 =?us-ascii?Q?W5ZTio8o3kQ6cxnBkvE0bZ5EIyZu3vyEkfpFrzkhiRlfGrNyCBOcB9IMBAfb?=
 =?us-ascii?Q?6jwFEczR/hGk3FHDFzABIzjBrITx+73PxJsUSUzxjOjpbcmyt9cm39m3EDT3?=
 =?us-ascii?Q?E7QTglR+wrnjvS9+/Ef0jEzKtmX89lwM+2CLwIbMMa2bND3+w/1AR/Cs/yXd?=
 =?us-ascii?Q?qnqIhr0DVloz/IJ7YIUYHljC+GHYibCXeF/QYAGaxBK8r/U2HATJrElZtAMh?=
 =?us-ascii?Q?z35teybkzZnTUlLwbMbXXBE4NIg2hCdyw4d0aanJVIDzkjbVXe2b0+rCi4KJ?=
 =?us-ascii?Q?b48aHC95qpssozdZurr/mbFqYv2o/kAgmDZd9b/aIvVCNokd8BlRtVCu4Dct?=
 =?us-ascii?Q?qgL9Fy8R8HOUoDTjoBalmTqo+pXzKbBiGDK4tOaaQBKi5VAMvYWclE/ISflH?=
 =?us-ascii?Q?NvNHNfAk0ixjnUJf2igPcRnNioUXFrSNjR8JaP3fV4HVai442a6vuNAebBkn?=
 =?us-ascii?Q?t+zibzJ9vA7bJeFdTpFvgqN0HJAhjfArwUWIqAW/VnFa3qQ+cm5Ypn3//rYj?=
 =?us-ascii?Q?M27yJfQOuXt5cBmzlMFZVybF4u2gfmUk9AWcLb8dIsZrHZzqj3Q52Nv1Gn2R?=
 =?us-ascii?Q?nU45Aj2P2EZTWrr/oixbeJhs1LHYprMdhO0mzeJezdWKd15y6g0uabJb7Dlj?=
 =?us-ascii?Q?JRjakABkWeG6utuX+RiOTdQZznuFs918s9t5qJj3Yo0AonIta5ug7WaBAotD?=
 =?us-ascii?Q?YlKZXGiy7BLX9ZX5aQikD31cptNHklFERuayySGV2vEtIipzF26LWq6Qa+oL?=
 =?us-ascii?Q?+w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 1DvF8Bq316obTClkvCfgL00861wWAJJSVOWk+AwHfRrvg75UzbDxgZOL1aPcuyk8kGvrWtDwi3c0rD08PDmbNIq94bf1CqOjrHKRXbZjrhPSLixhxfaggauRGwlu9+1QMGtqb59TrKTDIzIgDxvAuZoMMdLN82zrcIHVhkWpKuzu7lvqH3iSnRe9CrpdOe8JwVrPWnzOuIeANrXetvXsHp6lhBLCuflHzhdjHAFaRFcNBAvknBr8sXea2wJpfxlgWFzT+pHniuNOYr+EAobWi4ddK6bYk8v55VXoyRln+lLG9Qx9e51huHMzjW6Ybcbz2s3x19kRTn8n/yKU0+N+doHqNOQQvEslcw1vDXHJSzjin3RUXVQi45HxWSNoxVQlBKGeigsbhjd+2fUE7HiXgXtEGRlrJZbLzGpyG/OyDK4Hxhu2ietsQwUMz/HPkrZ4Zy2h/pJo1GyeQBkdFlhD+n1XzYg3cXgRa5LyeIIjex20+Gw6+d6t94m2V20+PQj5i85cHjCssDIbWEctPCsQebDn17PDB9r7+DhrX9hSAJbzNnLv1+DEcBr4fsD2xxSxxouLbVehd2y3/Ptwkhh9AdklimPPyvG2aeiFyDOTWSi/lkC6GQSL8t18pXjubHgon5+/SPiUyNFlPUMblnJhh4YBk4ioS171UTWO+DJKiRp6NgTCYp+Vvy1FXZbkX4oxxKlBQdb8pasM20Z4Q2piBhW0OrhrDiVVWUyNZgWRnoKFPy9pFKcE5qPXLJkkUgE0FFltGOJlME4iXh5v8gqP3r4yiqpKzinM6X43b8fi2VT6Hd2PhIDW003osfBZPp0zaTvdgQfqvXxfKs6MojF10QKb8I8Zpivx9V+1EgiphK5H/rSi/wjwwN7DsL9qxmHh
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb81f597-6955-45fe-28a2-08db6ca7833a
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:18:12.1272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /XCV1QnIRR/EIjrqvM8z3zWL6TBLWFgkou7vxA/ZeBwUd3RdHYwzZpyxBi0UnZ39jJoSIZmpeyTEI4hRaqeSKedaVxXWPdgaXPnqXQXFxYA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4188
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140063
X-Proofpoint-ORIG-GUID: V2f1glBAfi9KsE8FIGUZMQ2lBqw9ovqC
X-Proofpoint-GUID: V2f1glBAfi9KsE8FIGUZMQ2lBqw9ovqC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0 it will not have set the sshdr, so we
can't access it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0d28920d088c..f57f928f267f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2319,10 +2319,10 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 	do {
 		result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, NULL, 0,
 					  timeout, 1, &exec_args);
-		if (sdev->removable && scsi_sense_valid(sshdr) &&
+		if (sdev->removable && result > 0 && scsi_sense_valid(sshdr) &&
 		    sshdr->sense_key == UNIT_ATTENTION)
 			sdev->changed = 1;
-	} while (scsi_sense_valid(sshdr) &&
+	} while (result > 0 && scsi_sense_valid(sshdr) &&
 		 sshdr->sense_key == UNIT_ATTENTION && --retries);
 
 	return result;
-- 
2.25.1

