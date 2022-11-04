Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48DE8C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiKDXZD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiKDXYb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:24:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4121E1B1F9
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:24:29 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4KhrQ9027173;
        Fri, 4 Nov 2022 23:22:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=06H2zVYeAsVKMHrknavrlAA1PQzNf3cQ9LEgbZtA/uA=;
 b=hNaDodTtIFaK61yFrLuZX2z13Ft/ESf4FomCUpjULJv2tEOOmImdZwayNHY7Uia1Ue4t
 AtPthZC+BlKFnbX/w1GfHjfzt8vknerLxTDIVjdviyMNAY/QZLsiSqY7py1iVa/1iIgD
 VqpCvU9sCX1Z763LhE8hZCwdQSOu4rYJK3WEKj3KQ5elmrKk76aVVLAhViB1KUHRkTj1
 N9okgxb6NPSKu8ChYH88yqU8XgqukjTArbSK6WVrVqEOyLr+Yekx81j0CQnGzeHSq2FB
 u8i6wOltftIRbJcraSZItL9pKsKLRBXc/I+FuvSOzc6ihS1nvJoBoC1lWZleQQkWSxxD iw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgust16ec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Kfewt032301;
        Fri, 4 Nov 2022 23:22:21 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kmqb6rah2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ta9WDsBRqfKkCndkJbaEiwgGzUu2mlmQRTeigog/G96g/rPgkYdOS7r9e/47XrTq5PV5XTh42+nTKNklS31DskBLcR5WAlRD3nCSUNX27+wU9hwcRIxZCcRi+51LoQqfRCUZafY4UvxH7oRyuscXYCn1VESBxi2fv7ZODRrwfS2BmeHWm4Q7TFKc3QImggxdqWdBGfDwGwGrX5RGnNTPkVF/YPG8xGw6d5eepvxeGFfgtIpzVtUjn8M33ZWK1ZWgERWH5mesWGFwPYuLuQA8CPfc8+a8kdSf6zE3EWbrMJV2yva2fPW9MZ4076LSUbpWSDQhKG4Nl9BcuwhXDc1o8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=06H2zVYeAsVKMHrknavrlAA1PQzNf3cQ9LEgbZtA/uA=;
 b=LL4rVHUMqGejuhw3xS/fSOJ9RGJlVBVfnDLI8jtAWdqUYBuTKiH60Mfl9K6TFNinTMc1kwfBXOwjVsrjiUMumGrngylgwkxRA4TMmHXdjk7ioW3u5ygAurEZwTvj7jpdfp4hdrh7sPe2x3P3q/U5VEKPYW8OmYCPiHHQjfuX1JBz8xTUChfvQAGK28clM2opb9TZbQUCOwvdaFKbpa5mLlXrcbpIivEa5d9BVlxRJ8pT6uM3jCYRg+MSx3nvB1I0pI89XRBtLS7xJ9cS0a1/9C1WOIAo+qQnevN+lK+b/urWTh0KRSr87hNgsN+sc7WedLywYIpgOOFXDWv6gun0Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06H2zVYeAsVKMHrknavrlAA1PQzNf3cQ9LEgbZtA/uA=;
 b=g7p1mwKZIa1USUEVLp/9kPoH2N5gW//kwaG7ri6X5JCo7KpIDMeCvQYa5yyBoT4Y67cHWA+YlHmKPR+XgaJQ1CEMN8VjBMu5wEYsPkGiGAu88CEw40oGlGdZVcZj3NM1lP8AyVwjI8a/zMZFlX4Ij3fB2CzHdmUq5YF4YfIKbUY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4756.namprd10.prod.outlook.com (2603:10b6:303:9b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20; Fri, 4 Nov 2022 23:22:19 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:22:19 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 25/35] scsi: spi: Have scsi-ml retry spi_execute errors
Date:   Fri,  4 Nov 2022 18:19:17 -0500
Message-Id: <20221104231927.9613-26-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0189.namprd03.prod.outlook.com
 (2603:10b6:610:e4::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4756:EE_
X-MS-Office365-Filtering-Correlation-Id: 889447b1-e2ff-4a62-5c96-08dabebb65b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /iJbZhF+6DlsZLKiuSZwQtUkR0How1CoZoanGIeIU426HXWl420A7OhlZ+9Ag17Mco+BdakqUPmbON7z3ebozpwHdaxMKzdJAL1+UTusTMG8eQBvXLdhqn3bMefsQq3F/8IIDIrSHtDgqHNkjrplrLS9Tbh7x9oADhSpokdJBOHdd7q1Eq+PgQndPR/y1u3bZwPza1McLwYXsUALB6YJpMHybRku8Gy0SmNdrAZ9V8d8otRB9HiRgw6XngekY7w8wS8LY111yO1429QkQt67IEqgjimR3EoH8Qa2LN5CedlcwdAH56a3B8m8DSgtkPkldjaQEVPAvxzJUw0zS9QkJAH0LrNgxdf8CN6U+2m9T+YlQHQXU0SywCYCfE257w/L2LW7yUOhx9I1EHn0El9owUk976Sb5zzRjg4JHyEWJgQ96G6HjKVd2NCm8vxPPrnP7kIfLDkKFK3bdhMS7kZZcc03qILSkG7ekKClfX7Ck1Oh5iiNzBkoLnhmNGB9HtKJT6BS+I15hP6YThkYqn/PFs3EnM2O8os1bNHqD6gHx6KSTfqXDcRh9h1kA5ZGMbDhmp6dvcZg/7RhBm8u5+ntNi1dc1nqtU3c5N/BqIchbgQHBNfsQImdcaJbB/rlXz4Ay8ZsE/B6Xf+J4DEOhA/A1Ju/iRK9v8utGt8SHfsd/bvpHZiwkare6VGeg+EyG2JzqbsFresYlzzkIPr/LHZ9iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(41300700001)(2906002)(186003)(1076003)(2616005)(6486002)(478600001)(107886003)(6506007)(316002)(4326008)(83380400001)(66946007)(38100700002)(8676002)(66556008)(26005)(36756003)(86362001)(5660300002)(8936002)(6512007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m0u6Hu03gXcDvGL9OV3IfcHr/f0tE9F4nTOxazGVJMYrgfIMZAm3p7/OqGuf?=
 =?us-ascii?Q?YxMpQIv8R/asSRnRdapl1GHkz8Mu/tPp3fZTC9ge1qKsV+BYX/j6EL3VwJtl?=
 =?us-ascii?Q?QJ5elpKmFdZWRtgpbcw8G2E9NcxXDO2CNP97sySPy60W93u+58y6lFKcrqFd?=
 =?us-ascii?Q?7i6hIlGH5vjc25YEHghT08zo0c1k6audhDFrHqL6kw07ggTrTsL9o5uGDZPR?=
 =?us-ascii?Q?qqW/7zGrRY28OqjqWeQYXvJ3AQ7WBXsJWHe1dYFTU9pqCZcpcKfmetQAgG+2?=
 =?us-ascii?Q?7VrxezLBAbk1fff5rPssOMTgGm6Jc3TSeLfZVwlUReg19Ah5bjwhsvlNwc5F?=
 =?us-ascii?Q?raAYFEoGVDwU7D6THUbJjxoKYcE0QXFj118NNj1o08XHocRFPsNqUjzE7cWA?=
 =?us-ascii?Q?yZwrbUHe3CgPVHH95XEn6SOE/w4RPFyOmDlrYNQHO1B3saK3PB07MN7JZmGi?=
 =?us-ascii?Q?IXb/EoD+1QXGFjCy/vVt47cjm1m/NU1Fcxcmsvnz8KchXmoQYw6aX86y49lq?=
 =?us-ascii?Q?pUPsIML5f9J2mPj9c1LHFofv+BAP22RNMDkQxX2cc4Wf2GeYJ5dG78NWRxTl?=
 =?us-ascii?Q?/yNp6DKquVjl4Q8pO3C0JxtVfJcuqcPAX7zbKdbs15uNBfNGlSjRj9zgoXvW?=
 =?us-ascii?Q?Tx1nLBpT5PrEnXElBtzW2x6P0Gkvh6bfIo8JXxdxMjIyBn56CvP6t2RTAbFn?=
 =?us-ascii?Q?p6f9CPwb4oikN3Qkx1gDJb0mIFn3K1AIRxwkCJZMEZzbjLUsaWIdof7fqKkN?=
 =?us-ascii?Q?z3qlmABVdFUWyn9ezYPw8iDGg84Iv/b0Qpcr7VoyMKkVclghMhkb46IvqC5g?=
 =?us-ascii?Q?Q5DOIrARr7sx+wNAWc1XPSNmEisAg2l0f+Q6JmE7IlEIxl1oz13uwp5sG6rh?=
 =?us-ascii?Q?VXOYVUB3GmauD1A05zXYeqx7lCsNM4MCJs1QeLpGf7jn9S6xHgpv3yt3aEYe?=
 =?us-ascii?Q?arEZ2KOPgnxZTA3lvVoTWMJ5vL+pZcPt7M5eLugJIf3/ReqiYSabgSTB6TNU?=
 =?us-ascii?Q?1M0qIkN7+mHrmJ30GDmXmutmqDfCE6rRtwvRmoG/zZMwtkf6GdnrypzDKLri?=
 =?us-ascii?Q?iYJt+h00tzRt5OX/xELHiCf1aCt4BGwz6Q/fT/8OdDlPgKKwjfq3k06H6G3n?=
 =?us-ascii?Q?qlIW4ekOmko0ICHQPNAK8psqu2liyVJ0APdwFFMTPsjmaz1s3LW/VIswUHc6?=
 =?us-ascii?Q?t6wxPejmqJhNgrj8k8GO5RPHA07KH0/MD5SODXLJJwt1XCQCui2xn0fG/YTo?=
 =?us-ascii?Q?HWBunSw+N1C1Erzxp2r4Cu4kK2mXh8gMIZ7tSUEgdPSPH2Oza1fQicoO9V/V?=
 =?us-ascii?Q?jePMRTFscOe6R801N6FBLK3wXwyIwfrCyaK4eQ2iwQxOyqtJD5rxIwPAPUjP?=
 =?us-ascii?Q?tJfPSaKaY/KLFKygKBz8xP4OLwwxVz9URCHuUAYHhAhrAN4xokG/kxBmMuLx?=
 =?us-ascii?Q?7F2qXYLYr+gvU6FtQpz+rwD24EcEIc8eEhEWy0fKDLwSGfWw42fX0Jv8M6xg?=
 =?us-ascii?Q?kDJ4BtWaodlJM/jY0ByeW88dXLeYh3kdz/n0LKBxIwuFTvKyEGX8klVjgVnJ?=
 =?us-ascii?Q?KoPms4bU10CZLmoTgDj83sSE8D/tfU271Bmq90xJCz370R6AAqsiPP98ffUQ?=
 =?us-ascii?Q?Lg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 889447b1-e2ff-4a62-5c96-08dabebb65b2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:22:10.1789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wYEg8tnWIe3JUYegDXM795iQAEokS7AkdMrBe+mvGiSI3MjJ46IfbJ/udXvA8wqpcbv7g2nfbngA+lxMOYk2ocC5+DCOwA600oJBkrF4nPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-ORIG-GUID: aSOZBBFfEC804nnXuYdaeXQtJH7N5J7U
X-Proofpoint-GUID: aSOZBBFfEC804nnXuYdaeXQtJH7N5J7U
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

