Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC1F8EB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbjGKVst (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbjGKVss (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:48:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1001704
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:48:46 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BIDEr8025054;
        Tue, 11 Jul 2023 21:46:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=qhwHVQ20eGYLKhZewPfxIlKCGsiziiLeIvvRVaXWH+s=;
 b=gUKhVG8Un774fSlQhsOvdkEUEb8Yoyy+hp9MA2QUNweLYDaOn4nmMKnxy4VjDhg678Ih
 L5gyt7lNg1aJvZzimI8dj3m82/YnCwFeXKzmFmylBGTfNqkzn4Wpvo/5lJcnPwJ+nbuG
 zyx+PVu1/o00xKqAqlpPz5ecRINfa23M2JAQsJV7CAhG0uKOgsNCHKnfFfy6wUNE66Ye
 gXvxDj6plp8+NtZoa+5SKpWQLZSJFCIiZ5CYFpegzr7kNKWoz29vTPX6NFSs/e5K+qoH
 p/3Kb03S1r/sbfo+KlAb1zqv5saDh5ixGY8dnKoYdx9D3TdrIr4WbL2UsK2AEz7+me76 Lw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrjmhbhbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:37 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BK7N0m007107;
        Tue, 11 Jul 2023 21:46:36 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx85h0w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OU5juQ5RDHe1VwqN7hzJJF/r3Wk87FEFXVIgHPt5XZf44M+1WiE2HnTMXMUk2Yiebk/93u5SFcfy4bEgE0yQi7D4ebMOMogd6La17yIuRgPmx4m8ZpIK7ACKKIgV0EA+cKMdaEnEeu8v89l6nj8p8o2BmKPAJposfDthQBqiG47SdZFzrGTXyeDr+g4Z8Skdzr3oe0zT+Rc6FCfWsv1ZFfBQw2nKvY1LdnucnqoYkFaojDMPASXQPzyQN+sN1qIgIx5q+0taoDzBEy9NppI8n4ysLFtN3TIvpbZOCxtY01seAVnE7bSdRhIhI0dBtgtsykFRCqyWt8yAeFq4lVQDHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qhwHVQ20eGYLKhZewPfxIlKCGsiziiLeIvvRVaXWH+s=;
 b=Bklyu95/veeNjx9upIs4GAoS4WUXllouP8ozjMZ5RfeXSv85aWXLPNrEkHIloRQH7Ok0wuDBt0epmPqgJ4ElPwwOnaQ6grwaoV5a4XO7C4Somp1WbpoBHQy8+CCmEaxwDttBlORt6LPgwNysQ5XdwvxvlmZ7PTQUBEJG3hREH/7mmIMpSqT8jk9OgVsr6N/4TwpA6aSl3MVmzrUm7YjJ2DKQ+gndgsOA+GnE6hqPukij67fy/icINvt0mX/ew5Dzvn9FAWXY3xlb3LEPFi7iTKg0A05c1f/1bOBjWHqS4BIbjKApJokzCw80P0A960kz9sd+d+fEzpUbwHyZb46/9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhwHVQ20eGYLKhZewPfxIlKCGsiziiLeIvvRVaXWH+s=;
 b=naPSekpfCHQt2SftQyElQjX8qjgcE93E8ERxCJd1JQJA+6NIM5S54TD8xhSm6+XWo416Oa/rCq5BgkAjBcDO78iPHqAt9XK70op2x4tCTgNEYlMbQMHmXgG7f3iX/SECW97qahYjsIA1Yw92Y69mUAxpB7V0wszC1fyZ5C2mglw=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CO1PR10MB4450.namprd10.prod.outlook.com (2603:10b6:303:93::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Tue, 11 Jul
 2023 21:46:34 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:46:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 04/33] scsi: Have scsi-ml retry scsi_probe_lun errors
Date:   Tue, 11 Jul 2023 16:45:51 -0500
Message-Id: <20230711214620.87232-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR06CA0029.namprd06.prod.outlook.com
 (2603:10b6:8:54::29) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CO1PR10MB4450:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b3eebec-402c-49ce-b634-08db82584b2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VX4mJi4pxlOMPH0JsM53KkvtnybtBeRc6E3V/aD1q7RTqJQSGR5IHCFU4DtCXte4KDcNFD28fdA5DKrM/E0C1+gg43aR1/tiu7bYa+nloSAHB99YkgI56kRj6qXlb7lgfnSGrIE17kuuFPR0Ty3iC2Dtf0WWhzJejRcFl/MDL95++FrW1NDjjPSKncN8cmEISbYw0ARZBap6R/OiFMinZ6dSieDva5vMphD55P3QewpAxCYUj8Kb09wPCYIKWRGStj4MFWczOGe2yR/FFu+0jSJawcF4nZaxABXscWJd8PFal/6zV+UPk7J994UUqUa2oSTpHyj+vhZkntWUyeD9zkQpBITHij2jSZsw0l7ou8FEq5tIsf+5uGYaICgmF0s1dx4CCFQ+I2+kSM+Q4CO4MZI/R7xqFuOUN1/bb7esGFLdKcCr3rf4KdmcwqRXmV/o1CZTyNjsjU1WB7K2taooiYwPWPr3yTXUHH9zKBtOw0xSwEVLJ/qmDbChk1Py9lssma+paT+AsBLDUMeIhVp36KdOul5TpkvchPIzu8yHQdK4mLKSey8xqVDEo4EYuF8K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(83380400001)(2616005)(38100700002)(36756003)(86362001)(478600001)(186003)(26005)(1076003)(6512007)(6486002)(6666004)(5660300002)(8936002)(66946007)(66556008)(66476007)(8676002)(2906002)(41300700001)(4326008)(316002)(107886003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oG2J0YB05U7b3NMLk+mDkQwmm+mXXVuqh9EqwKzPgd8oPTvf4VTeFBD8wfSm?=
 =?us-ascii?Q?nc2TJSZCiDN3QEYc5l4YPMmRaZ5VTxTBV2ZWkQU+KS0qSALH73sWP2Aw0g/J?=
 =?us-ascii?Q?zL+XovtrmzmJLYWwSV2HV1Dz+eyfvSZxLzPPQqzy1+QK+rbbgYWYhMgjxgFQ?=
 =?us-ascii?Q?1tpngINwgh5IhDK5lyvyLICydyXWyx8ibVZQMPzgldz1mxDK7KE4sW7gOqCQ?=
 =?us-ascii?Q?y3ziF++EQmgwnssIp5LigcTETPrOn/UUm7p3yAgH3bfNfYK1/TN/qFLHtsYb?=
 =?us-ascii?Q?3mIPieZ9JDLPZr99Lt01A289TvHESB0EmM3HULtz+zFAQcsc2AAtkjSWw6G4?=
 =?us-ascii?Q?tfvQ7G5lyA+k8dJQnNcvuifPbutTfuOTtPw0n+DQzM4BMLKpxobijHDMh7iu?=
 =?us-ascii?Q?OHhOzuWKKF7bX6P2Ehym4Gcv81mdQwbWQCZWH1Y28qEXs2FXv6eMsatQxm6N?=
 =?us-ascii?Q?VIqimYJHj6lGpnz6A3MidyRiPbs9Y2rqqXBSfJJ6phdsbN0OnKWaJ61jGN5c?=
 =?us-ascii?Q?Q3f1aqLTU0o/pFh0WuYZc9+lxY3iyIcvtmj/uIDltCZpN5Ja2bjqqwN9ZxaQ?=
 =?us-ascii?Q?p/kTl9aTWP+IAyW3i79Vn+2M/HgmYHlJB3Pc4CZhwYTtpMtt7H1+pQArmONN?=
 =?us-ascii?Q?MSsz1baveg7ji/i5n1LHMXDXp+QSHiLZZGIqmwtmxxP6++3AE55Jp32Dbklb?=
 =?us-ascii?Q?O3t7FXdbOzS05afMJGTN5ff2Yvc/2a4tus40NdFIxe4v0g4x8hU8+Tm0glqZ?=
 =?us-ascii?Q?zpdyunXdfVjtn1e6g3zl3ScfTEorAxtnzlXtxQ8n6Qz3/U8z98WHoFKUH16e?=
 =?us-ascii?Q?M1iN8OYFW+H9VZChUK4es5RYbm0dXh4/9/8S26ds5e0JsWY9XN9E8AEQ5DQd?=
 =?us-ascii?Q?kY/riYYW+5nb6bZaM1etWoqKrdAq/e0L4qV2oV4zWGTYtGrLEdSVjvIIrsOA?=
 =?us-ascii?Q?7fwMUzZIDdd6zJMZi+N+PP3x41D1xs1pwGUi046nz3uvfbkhzwHVHLOHJx2/?=
 =?us-ascii?Q?lvGpUOkKtmVgzpRLbvNZJZSuOOzYADEHpV3Df+X+JO3SPMAqM1HT98+fyGFe?=
 =?us-ascii?Q?uocHwdeYAx0MEFs86hrdOC3LI3Th3GjEYnPkbjkYDEy/fS9etd8wlWjPlywv?=
 =?us-ascii?Q?wUdwb88FoMK5OIPGMkWrDK9UnSjVP40J8QHXa1/pFkFOuAD3H1qqSeH0AKcy?=
 =?us-ascii?Q?2+ws+V11EuQuU31/13TIzP88tkam7blFeUiaBu9sPog8U1C54wg9RKN2vC06?=
 =?us-ascii?Q?SjfCNt4FIhY/ceFFbCjeQq1cc+VqcIilCqQ7bOaDS+GDeXm1j89wwWH3erIy?=
 =?us-ascii?Q?EVayTQEoV7/hVFY6YVsaiIiDj8mexYeW3ecuAn+aZZSryIt3/LG+Mgfy+fR8?=
 =?us-ascii?Q?s91aAU3M5Xyy3SaX01FjDLAwK2q81c1cskd0f+CsSmxCOVYheWCyxZKwOral?=
 =?us-ascii?Q?ZjrfU9g72SSiiG11UStSqyi2OJiZEI5lGqmmsOji616/XNO1iXCDLUlfMYRq?=
 =?us-ascii?Q?cFMVBNB5YZPzrsq6ekUwMklYuInamDHFNzH0E0uS2sURbN3WjAsfS8+lQb38?=
 =?us-ascii?Q?JH5Jh/nAXmWSLeM+pgNvEH0EIfCccUUEmGWj5eUdUjXb7jIVdowD2O5PnId2?=
 =?us-ascii?Q?4A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 9gsEb0L8beEQX556bXQJSNUAghtQoGCHMZ5Ynvlt2qCebzcgzALblJCDkjArBAyqlnQCIatAFTzytkHojZMlj/YmZO32jjgTXIU5P/YmkWPuPgC02zLIvctGNlbYhMFmTzZxly+GDioSLoeRPRjyd5tOgQ0ZHsXMm76nZv327H0/kmhUClAotvXClgAs9zP0RGJGz0SrM85kk64q/7Vtp3lf+N4wXxMGGMOZu7uZJ/QfBOS2eQvxdsqXNGaYauUztw9zDAIkEP2xtvG3Pn7vvjfEG8YYCQ9MDrMCogbB3l+m9Ka8u5bNDzWfy0KJDdzYR6Nu3FDOhHVUDz2d04ZL3kZs+6NZIr2YVlSJBua4ODcwv84/SYjAADSTnd0wY3tptsn88fCmFjDFCgeI6IDn1M2Qg4YopSl5gYW/27jitMNHo306jJc/6KoYLWcnlUk76mE9X91syzgVufTXK6V30imCkZ8bhdNkegC9qUrJLpdce++6nCtES2xPw/W5S04AYLSLUrZVT03EVPvtPaXye0KMIOZr8Fe0V7EGNatbzhQJBzg2LVHwbGNl0ZbfCJMMshH41UgEiWuwdcuXUDqhtseSVdEkzqGrKIOSbXa2lKYdNQpwnlzgL9AMQYt3rnxqwqCb/wgRDJM5yN+tB5GPIjGK0GDv4+FLiuaR8V+GrCf4bhKUbshbVhfokzJA7wi48Swc6ghr/MEOxM2Jh3mm+YV0vgBaPMLRzivYhiO42Jgz+yvXDpaEub6CeGK4ropoPo3jedWYAPDO+8paUYRQ6P1+RDVDn6Q++srDQYJTFTzo2TwAjPwyBUsCcre/NzvBhCVu/5CEAIdL2hlKfj8PiTOsDrlOLsAmTwKD4OXNmCp5GJP72AIBGO7yGTKkIFRG
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b3eebec-402c-49ce-b634-08db82584b2e
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:46:34.0851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WGmAyBUNkGErDoDzgHH+SK6tI4OtcaujQBYVQceMfrzRTX0UUMRs8QfiXAapuTmyTMzsWJ1wEU4R4X2uajBXWR57IofdJMoIuBiVvMX5SnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4450
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110198
X-Proofpoint-ORIG-GUID: X5BELW86DQGJjNeL4FHCFqrRImy82KDu
X-Proofpoint-GUID: X5BELW86DQGJjNeL4FHCFqrRImy82KDu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_probe_lun ask scsi-ml to retry UAs instead of driving them
itself.

There is one behavior change with this patch. We used to get a total of
3 retries for both UAs we were checking for. We now get 3 retries for
each.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
2.34.1

