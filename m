Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 336B4C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 06:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiLIGQ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 01:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiLIGQC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 01:16:02 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5D8A431B
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 22:16:01 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B8MIknF028591;
        Fri, 9 Dec 2022 06:13:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=0qp+CJ31+UjcgAmjHqUQtuxTKxcZib61pZWKBWl64HQ=;
 b=Q4biHWCEADaeNVLnLicNNfdabhQPKTDRsnayn+qjYJDMWvzK8WRtLXPpCQoXfQ1WY2jL
 oQLW9eKt593qsYKVkvzwLWhOgqDqhO/r/NHevZM3CxFFHywModkLHHeAXZn933M6AIqE
 1GX47rw77LutlFrWLr7NHpXvGHgaV+U8rP8fH0L/Lpr2JisZxS6ToffjWB1DPUJsIQnQ
 72wRc+iS34scY7NXf+NEz2ptEOrxqjo+C5qMYq5zoTSchUjSq4R1MpwPxw8czAKba3su
 Ml11KmFw+xxGtRlWOnzTJaLEPtHWwaAFta7CImx4oxbQv1TVT2EnORsdsE17YcQ0+doS iA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mauf8mcpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:51 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B930jFl008326;
        Fri, 9 Dec 2022 06:13:50 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa61ymsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OYTBoOMh5D6QcWnUFFjeO3ug7Uk7fqgSdHqC1FpNMkoKFxvUSqAuWWwNWYF57Zxv5yk8PVyJ4rvyDU7jgcLkHLqgVAcmeNcqHn2l67HiFI+xUXWtVvpJNxX2yVBMXc6X0kQ+QVuLvAGPnTGK7Q9YdZNOWMayfLvVcq7+qG2d4NDUnwakKe8hR733BxsSDqMEiYWPeodSzAbuj/pu8p8TSvHcWQrMz5L6c0C0YMc66S1vFB91gVFUUmk59BpA0C5v7uj/7y/wFGyes4yUC1eQgHMLGvTkLfwjnPzcKBdUppiCtLeMSVmb2FvMuOqAdrwIE/UVQZP0Iadi9oxJ8zQi8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0qp+CJ31+UjcgAmjHqUQtuxTKxcZib61pZWKBWl64HQ=;
 b=i2RPj+gBI72U/GE1+6U8+6yAN/L9eQqgvSsBGNOyZsFXvAbY+ZgEzeHZGzOmogwVO0ybonSQ+6QUh2tJDWyup1kJER2sqmTgFuAoWMXZjbMIj6/EoSwRc/md5t4k+xjDZsigao3aGRauqwEVYSpsUFi6FnSmat5Z3BSLmqlrbXaEiIiBejrXbDPyGaaM98noArJLpxhTPAQwiWBVrX7A0khMk432V4NB4IkpgR+8lqu/TKn3iuegA7N9UfJQ0829leWNXniN1apoc8x/AM6yO3nCRLfi3rwgt7RtvjQVqk5DVPkQpf9UkPu6G8tFVHDcoTCIRLwK6eFc3WIgcXVhWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0qp+CJ31+UjcgAmjHqUQtuxTKxcZib61pZWKBWl64HQ=;
 b=EIC/pjPAZ9NTZajjx/zKXM82TUQXbToiewQ3u3x/BJREUH0q71lQS5vEzsVoaAiLTAUO9xfO0QDZAICc02c0/VhQhGLh5HMzf83hSYPc8YtdFtQaBnto0KohGLWVIu1LKMoomWXoxBJzOzGbiF17cmIMbWXumm5rRgsMCPBKmUw=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH0PR10MB5066.namprd10.prod.outlook.com (2603:10b6:610:c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 06:13:49 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99%6]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 06:13:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 10/15] scsi: ses: Convert to scsi_execute_args
Date:   Fri,  9 Dec 2022 00:13:20 -0600
Message-Id: <20221209061325.705999-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221209061325.705999-1-michael.christie@oracle.com>
References: <20221209061325.705999-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0054.namprd04.prod.outlook.com
 (2603:10b6:610:77::29) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR10MB1463:EE_|CH0PR10MB5066:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c86e3f1-4b13-4e33-7d37-08dad9ac8950
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QJrWoy5XGAg/hXyHpv8CNW7dwWeqPeiqjzdIUD8fr/IjAubGwFUyoCXVByl3yhnMBB9u93npUhv3+1Kd2idWPkrG1SlChRmepu2k6bFSx75tMnOrhxjeGzUPGb3b4oK13e+jSIuTq6gFgriJxnIg7yUcsB2QurEXWGqFuG09kJ+gGcJwvP5wRDAi/Spsgdtm2ldIIHtp0XzjdGhhv5jwIlv7/aJtzREPbkv3nZfQFnBpHQkQSnq0JEB/Vqr7tgxPE1NpbWnmPImskil0ZRrDxf9fcZPpYRm2+3WNcdX8NIOqJ43xfa1w4R8SnYlS3xPLk+SinT0VkzPZFSiM3ZY16aeSNGhRU48wusMeMG3AbG7naNr58WIZ/cXfexZvfLGvshDfd8oo0EhO7o15pA+c+fKXu77jOGLe04r1zVzKOyKJUQPkucRit3TacIvQHlcF0rEYVh396hvAFM0wqnuL9+JJ76b/CjPtzWK05oHE/q1CP2Js4HIEQY1O52tueg4ZDyxxctACSdWj2tYQXrlEjDXkyXmVA8ZtqMH31jfkKQyKr/gbws1RUE7ke8kgaIekGiw7AvnKd3KkmUA+ekOakyHAex0cPWiP3nsD/zybjzjRybkPVbd+D02+pgC2/7krjWPf6mnSl5e26f4ivN0JkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199015)(478600001)(6512007)(26005)(2906002)(36756003)(6506007)(6666004)(107886003)(41300700001)(86362001)(8676002)(66556008)(66946007)(66476007)(4326008)(316002)(5660300002)(38100700002)(8936002)(6486002)(2616005)(83380400001)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ytce5ggO7Kyw0XdUpnSiHb+ADBOUAZYiI5BXWRcXkZTkYobZp6K075rf8Ksq?=
 =?us-ascii?Q?L+vpHaG8ZW99lKU47r2IEMdJHISEhn0O1zB79skG2vY2Wv1bYwShXFiRNCIL?=
 =?us-ascii?Q?C/rjTJxuRquHldoDyK6stLF7W6hSuGFnNByoqPLKYvY8RXyPFdgZvG6aTtOf?=
 =?us-ascii?Q?sAZY9Ted5+zV/RSQ55eJOoC/GD+HivUZsudG5+PsXrgwK7YToGxY3jN8NkrT?=
 =?us-ascii?Q?76ujLfiGlEYhCYs7mEiuSki3Vm1vt0aO52Imx5ctMmi0g/ODV50h250qZcTf?=
 =?us-ascii?Q?RMV0cN9ZICA1MezB24jMpJc7lVUSobWolcPvFQNXiBxhgIvb5ymvhSPJTjLg?=
 =?us-ascii?Q?IhX0S15TUzXVFP54kUMJ8SB+7WzXI1mICcpVob8bUaI8tcR1ewBtkwSABKxp?=
 =?us-ascii?Q?WTkWZbCbWTKyjiWfVaYsQDtBRE2FLXNh09bW23HcMe086j0MzvyvGzzITUPy?=
 =?us-ascii?Q?vfgDHyl/P4Vytm/+XY0aj420TuoWrhc4dVYknh4Srzh8dmDjjiaqO6BdGLXT?=
 =?us-ascii?Q?0Dcd6l8gAieDvPvh55aquTBfpcxozcAsouz62+k0Ia1uGi4fosFt6MRUdF1U?=
 =?us-ascii?Q?jzofkFN0Dj3af10EwXvOTXzXOoWswXjLwe8vYhPKPLZgGWhbI45lPcWa34rY?=
 =?us-ascii?Q?J2R2pT7JdurvIx99yKVazBhOEfsJVDzbmw/Q9UY+jYih+hyY7Ln1v70JahGz?=
 =?us-ascii?Q?X0VScsI1qBMAseZCW61blaITwaibTfWF7t3nOO+oFdh8N/iz6wTny9z8fLpL?=
 =?us-ascii?Q?dH60ilhyjro/Gy9COkqYPWN4U4zELXIa1mqinWUTNMxRZPG0SErpdRDTA/B/?=
 =?us-ascii?Q?r+70RFG1me/hm/59EkYQmvT0Opz0h5HmxAVpEJk1ROPPDHvUdUi2+N3DHc5P?=
 =?us-ascii?Q?Ky5LrvX45SynNlQgESiGWK4yDhlAZYOZaXnleycYCznWRHzmv+AcGNLL2p2j?=
 =?us-ascii?Q?nR5yiVmmw5PdjJvOm3qgjkYLVFVt+i3PbIAClTbUT9MMd8T57lVUvaNPcv0t?=
 =?us-ascii?Q?C34rxojWC0szNUtp/NPzAFbi8SgOuXs5A3TSqrWoaJykRXE6HQG3qjZ4QA97?=
 =?us-ascii?Q?u/dBHLBcV/sMd2RUNz7nv4URpSyIYt4cJ7u2Qrq/2Qnr/nhyMduu4rMUmrGw?=
 =?us-ascii?Q?ixkxpRLWUMgPG6g8y4voz9/uDASvi5/p1Tq3p4B9c5jRBrXhe82kVojQzGaN?=
 =?us-ascii?Q?M9m61ogJxE3JKg5ynzc3SB+35tCIYaXdr/OVC3Yr8Fgp+o2ZevgODXd2LgTN?=
 =?us-ascii?Q?cFa+SSX1XAR/DTQRR2IyE5jIq1okxe5KS4UEMDNyY/Id6ACmvMwwGV6Hu1S1?=
 =?us-ascii?Q?qoB4zOENwlY+FSSzF4he5qiD7wKnskBCANP4bNBQFxBwe8hIgSzVYAc//JbN?=
 =?us-ascii?Q?Gfragwa3SIEHqedYvYgvMV+Vub8pkqMItqT5CsMpA0wVh1OZkK1EG2cq7Z3/?=
 =?us-ascii?Q?Ww4Z/7U/Cb3b3QI/RMnN7EpdRvX5mT93CngxO8JaVrS/HQU0dC81XpMUUH8h?=
 =?us-ascii?Q?WUtRPVz7S2TW6MA0WYQ7El/Fu6dxrY1OF4C5FHBYWD/aOa0GpxQHlV0Q/V5S?=
 =?us-ascii?Q?r3hWEIR1mXfnMXcN14b5P7NEQF/NkOBESeq73aRCRd2CgpY5ORVTkFtXjtEu?=
 =?us-ascii?Q?dQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c86e3f1-4b13-4e33-7d37-08dad9ac8950
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 06:13:48.9577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5V2izUZhhCr+gexee4UBNpL8osarRtrC9yjPjVj1ljs+NXt2sFeLdFe+BRTxJkSOyHCw7NngTSJCgGFl+1SajJuFBPzW9lfr2AfKfs/fIEg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_02,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090053
X-Proofpoint-ORIG-GUID: 5JCdbPyvsJF_BGcvRTuZ4X4Etz5nceYB
X-Proofpoint-GUID: 5JCdbPyvsJF_BGcvRTuZ4X4Etz5nceYB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert ses to scsi_execute_args.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/ses.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 0a1734f34587..7f944bbdbf61 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -89,10 +89,13 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 	unsigned char recv_page_code;
 	unsigned int retries = SES_RETRIES;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 
 	do {
-		ret = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
-				       &sshdr, SES_TIMEOUT, 1, NULL);
+		ret = scsi_execute_args(sdev, cmd, REQ_OP_DRV_IN, buf, bufflen,
+					SES_TIMEOUT, 1, exec_args);
 	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
 		 (sshdr.sense_key == NOT_READY ||
 		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
@@ -130,10 +133,13 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 	};
 	struct scsi_sense_hdr sshdr;
 	unsigned int retries = SES_RETRIES;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 
 	do {
-		result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
-					  &sshdr, SES_TIMEOUT, 1, NULL);
+		result = scsi_execute_args(sdev, cmd, REQ_OP_DRV_OUT, buf,
+					   bufflen, SES_TIMEOUT, 1, exec_args);
 	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
 		 (sshdr.sense_key == NOT_READY ||
 		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
-- 
2.25.1

