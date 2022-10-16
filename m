Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFDACC4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiJPUCz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiJPUCy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:02:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C12F23EB3
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:02:54 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GGLn6i007234;
        Sun, 16 Oct 2022 20:00:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=06H2zVYeAsVKMHrknavrlAA1PQzNf3cQ9LEgbZtA/uA=;
 b=WHQ67LQ+Z4eBY8kGq4AoBEnF+EczvEZz9X4U8gcfQ5vyqudexmOwKvgG7agl6E3SKWzq
 118OuVOpgiMiac+NgPTEFTxjF+T7FoCSN5laBtC8/nG3EMOjVR1ri7Udh2XBs5D/fmB1
 mrWdR8mxo2wJpA9kVAVzAsTf2/afHerAzXSfQNgWzD1m5MfaI1jTsQqOh+aCFr+MtRZ2
 KH+I51KsjKMDSy0cYi1BcgFJtbMZQrGAH5k30K1b91meUBt5vokwtX+EU0uTVledIhGg
 Os7ZHdCViRZD2ICjH646PKGQwHnAkw/kIePStDejL0+wBswCCRD0hYfHqvUiHj8DMjwP Yg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k85mfs5rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:41 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCHaIW007291;
        Sun, 16 Oct 2022 20:00:41 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hu44d7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bdwQKbDra8WM5B/FMtHu/0FkvlLk+wHCVeYuzBI/wwLGXxBqahbw5sW60rC7tEAusJpxf8CfYE7cSZWVkSEAKU+W0pN7AIK6mblXlTt2J3fE0gwVD8EwvYsnrqyxpnNQrLUITdp0oF8hkKAlqnQKEFPqxUx5D1SnwQmIPcr+jo3Y17vzuBlO1kLLzIsd64mVAXYQ9zskF0iod3kiXz11nFHZY9vqNpPRZGlJWi54UckWuI6A+BHFKd8JRNidOhDL8pStJr8lgkkWh8go3YSgOfk1bP2hC0OT4m9OijJNzFS/fHeMahQCYs0SrqGBbJVSjS0El/16k41JlyzumdEx1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=06H2zVYeAsVKMHrknavrlAA1PQzNf3cQ9LEgbZtA/uA=;
 b=fWZxWlVf2/utQ2FPK5j+Ow50ACS5uKJlqMMdKHw+dVtYNdJZvPylCYydOHxl8qXIfDnY+p7jrceAoyp6OGmPfNUr1joAUGyMVSTR3yza822s3Hxjtz6rMtCru/gBYOIvSvCJSgRDvzyU7Xqz15+lhzIpfm71upPSVWrB4tYl3A1f7IFqCNjkW1lmhUhhGej3yqVMCbIgpVARNoOjnsPNhyAU71JoYM4Vg3K2hb77jzBpklzKoVfT5MpSLQ0ufskBvvKg8t8Dy94gsXSunBCVliRHJqHQjPBz3PI/astGM+m54ICfOXavqpf1mV6zn0+dxBqQxhdbKWyEKK6VJbLeHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06H2zVYeAsVKMHrknavrlAA1PQzNf3cQ9LEgbZtA/uA=;
 b=sLTku5CwFyYUWcqhrdVeT6Vs8dPNqrytg427VjyWMV+GrCJEyP0xbKtLkS4Pt+5ClHk//V2trrjyeWKzhk+jJ3+nJ3+Q3lcHl7wEpALebrhiDN+xxgEi27HnIiVcRz4ybCUQ7IAXG+UFa4lhFlftCfS1opR2Ct7qMd403tKRFYU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4603.namprd10.prod.outlook.com (2603:10b6:806:119::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Sun, 16 Oct
 2022 20:00:39 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:39 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 26/36] scsi: spi: Have scsi-ml retry spi_execute errors
Date:   Sun, 16 Oct 2022 14:59:36 -0500
Message-Id: <20221016195946.7613-27-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR19CA0008.namprd19.prod.outlook.com
 (2603:10b6:610:4d::18) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4603:EE_
X-MS-Office365-Filtering-Correlation-Id: add87bc3-db6c-4d3c-484e-08daafb118ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mQLAUh6b+xytSyNs2kizYKWJxcRl0Ea0q96sj04mT3Jn1d3ctu4R7r0KeI9T50iG62gtp2Jjn877v4c9TcBj++pmasUC0ITVd9oGu/EiRW+wL6k9PKWU0BpXlewOIHsWi7c/+EVENiG1QsZMtwcL3TbehljmTW1s9LVSi01qQdkp3RIuXzjLO2zHPhWmD+VCbzHQBYe36KhDyh5mRP0m9TMO4NfznO6awZ50KnV/z3nyVAdCZDGRc1T3ejhfNhLxZ6+iaERHSqE2IcmzyIPLctP9WzJm7JrXw10CmLHC0CTDE3srq0ufrRAd5sUD4rJRdEzgQW5ofzO68tGDKTsaDqvCipViAs4BArBIvmremj0QE0wRMAXkS4oGa9VDVeiXgJqVEim2OSpldlqYtj72lCFQaTIkqU8KhWqBuXV/q09qtvpPT8QfHg3yXGaL2eZKyz4kYhN7sMozIDYQF58rmDyOzEvwm7c8KwGTVn+MssycaI0F9hn0I+0po65xg20Py660SpWzd5GXKRQAaU3btF6yvIMV3it4IE3KsF5kX074Km5EPWc2Y6YgdrDXuXmWj8BZ+2O3Qfc1f3Y4+7PXBoVlRpFXC4IrkqB/c/8h35FfgkWinQaBbXlPZny+7CQoinL7YYnxH5mEeR8RAbdsvvKQiX7xEMHLEVmKYIQJPmrXBcTQGKFKb5OXeAAUaZYj05BngHni18IffdqAxTmLgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199015)(6486002)(4326008)(6666004)(316002)(478600001)(107886003)(66946007)(2616005)(66476007)(8676002)(66556008)(1076003)(5660300002)(2906002)(6506007)(186003)(41300700001)(8936002)(6512007)(36756003)(26005)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?um5OBIw84eb6+R7nBvcerKzntwL/cW5yA28OKjkiyroD7tgJe2UmTc1WsFMo?=
 =?us-ascii?Q?mSC7SFRWhN0TkQI4KcJwodD0+y7kTrsEaf77Zag/izqPxuB11arBmk+U9Q1t?=
 =?us-ascii?Q?89D7YFQKBoIeywrljc34m740XrwcoCq0lGjIRo/HX535TJKY51RyYMXQfIS8?=
 =?us-ascii?Q?il1GVGWax2oftaYJbMe8n/SiFxpATm0ktdRZ7wMetJkUx7n6HaMswSgMcfDP?=
 =?us-ascii?Q?TjE5X35YLMrtuQUtBqLk3Kj6F6jCSCsKDCO4jIOp1NWNGfalVJL322pwViEY?=
 =?us-ascii?Q?g7K1kfv5JwzUCf23l4Dz+PR07z/VQhV4Ke3nOdgFUCTybG8XNNralSa8zXpc?=
 =?us-ascii?Q?BwGKqVYYKOp360zrf/+ijVnasT8z/xUYGVY8AtO5a87DJxBySSYjhHQIXxnq?=
 =?us-ascii?Q?NTWbByRmF4DLfKR/DmluoGIGGMecdMHQ/J5AtYsPH//Y6wKfaqlDvqJtGFL/?=
 =?us-ascii?Q?Pkk6/rex9Fd/gxjeqi2q0Z2Dr3svCAyun7vLWe4+/4vUcBdtSMZU0hFozWiH?=
 =?us-ascii?Q?2CSxi5eBbfG8k4xXHKO3R1hzoThTVnR48gz8r0MIKtc7a3IuCU/bhPFPvq9s?=
 =?us-ascii?Q?637i3A/7KfXevxRFR7S3nFnDDKKWGgnLqSuueo6HRyOz+IxK5pFzrPh4Esp+?=
 =?us-ascii?Q?RQ0apjsylnZ8a2pWVVJgT0ds2fDbYe34KGLzQgZa0n5QGFM3KZe3d0ImzuKh?=
 =?us-ascii?Q?ObPhnAM1QluMK76oRvmQWQ9JioMfIDhZOEtUfuMT0RF+ugYyzdkTVlaGIF1D?=
 =?us-ascii?Q?46GWKgWmdAEYvn3JxWXoRQD2aFlGA2vyGZsO9sOFW8N7cQP+auMLNehEazpe?=
 =?us-ascii?Q?bSOGg34nrWNt9MR7Yi4d+mlNHnUl8MjfGFPRak1WR3rXyM/UWYb9agXTJmPO?=
 =?us-ascii?Q?nKPAhnfezmPfZ5qT7bD6QoaC5skGLbtrjX6ULxt+ue9sRXEZEy4siBk3FLuL?=
 =?us-ascii?Q?gkviE0C9CX95E/rS/r5dXYjdbQSC+mNI5FCVYkBk4TMjv/HKNIRu4nHr0her?=
 =?us-ascii?Q?21nb7D3xxuh+tHPjjedv8luUJLmJfpxmcxX2itjagkbgl5iJiT8BAlnvtW6k?=
 =?us-ascii?Q?fTRJF8Lz2AfFlzDQ38OZRLX+27mtl5Q7/wZIkZk6Zv7hcRr6rFLNcSsajWN9?=
 =?us-ascii?Q?w2rRcm7hCbpogta5XLOVtIFkZ/rz9mDMkEdkVEOItpXZmWMECEbvwNvL+iB0?=
 =?us-ascii?Q?9evQH8nXSHm/5GLiTL0JE1+7KloCMZOgP1anF1prCmM4h/HgInmJR1WKkkp7?=
 =?us-ascii?Q?Ia51ROLY6OXHWIxFw1ZYcoYjcjjtpsWNofkMmotODXZOKw923W4VmVp+66VG?=
 =?us-ascii?Q?i9jMwQGTUsdBbuPNa5E01HhnFN/6QkAnKCOTpKq/5h73avJDN0ujyO5YjThr?=
 =?us-ascii?Q?slurVry6tB8Us2K4UiEJ5WHe3YKWYwIaqLVIfEdTU1bmA1QL1pi0XAcSa3YY?=
 =?us-ascii?Q?XRbplIm62eWPj0HcVfDwIoKBj8ZjFM2KliWD7Bd6VWRL6895Ac6vzB7q4mkx?=
 =?us-ascii?Q?FnOnjhRrO6cEgbfcbWm5Lh3MMpEuuP+4Lu70OEiSCCc9pl2Ac9g7fcotKF/M?=
 =?us-ascii?Q?0ZI+2nsajbZ7zlXm8fQf3iZGS47+Rm7vx+wiUHs9vMqAzuwJHEsTofUIwA8n?=
 =?us-ascii?Q?6g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: add87bc3-db6c-4d3c-484e-08daafb118ef
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:39.0003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mt+P2hD6sAIajd+U9h53UN1+W5so6OFhQkMkRj3vAUdFfF8wX/p4H3h9ZHoaY7segFW6yeGmnVxWe3qm9HrLpAtrS6SKnXFY2PQjbUVebYw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4603
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: fzOWSErQ7fWDocTg5hd7skmZRhXJkkGS
X-Proofpoint-GUID: fzOWSErQ7fWDocTg5hd7skmZRhXJkkGS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has spi_execute have scsi-ml retry errors instead of driving them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_transport_spi.c | 56 +++++++++++++++++--------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 18a365c577ed..b172dd0205cc 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -109,38 +109,42 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		       void *buffer, unsigned bufflen,
 		       struct scsi_sense_hdr *sshdr)
 {
-	int i, result;
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	struct scsi_sense_hdr sshdr_tmp;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = DV_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	if (!sshdr)
 		sshdr = &sshdr_tmp;
 
-	for(i = 0; i < DV_RETRIES; i++) {
-		/*
-		 * The purpose of the RQF_PM flag below is to bypass the
-		 * SDEV_QUIESCE state.
-		 */
-		result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = sdev,
-						.cmd = cmd,
-						.data_dir = dir,
-						.buf = buffer,
-						.buf_len = bufflen,
-						.sense = sense,
-						.sense_len = sizeof(sense),
-						.sshdr = sshdr,
-						.timeout = DV_TIMEOUT,
-						.retries = 1,
-						.op_flags = REQ_FAILFAST_DEV |
-							REQ_FAILFAST_TRANSPORT |
-							REQ_FAILFAST_DRIVER,
-						.req_flags = RQF_PM }));
-		if (result < 0 || !scsi_sense_valid(sshdr) ||
-		    sshdr->sense_key != UNIT_ATTENTION)
-			break;
-	}
-	return result;
+	/*
+	 * The purpose of the RQF_PM flag below is to bypass the
+	 * SDEV_QUIESCE state.
+	 */
+	return scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cmd,
+				.data_dir = dir,
+				.buf = buffer,
+				.buf_len = bufflen,
+				.sense = sense,
+				.sense_len = sizeof(sense),
+				.sshdr = sshdr,
+				.timeout = DV_TIMEOUT,
+				.retries = 1,
+				.op_flags = REQ_FAILFAST_DEV |
+						REQ_FAILFAST_TRANSPORT |
+						REQ_FAILFAST_DRIVER,
+				.req_flags = RQF_PM,
+				.failures = failures }));
 }
 
 static struct {
-- 
2.25.1

