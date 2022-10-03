Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD7A2C4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiJCRzl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiJCRy4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:54:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964513F1DC
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:54:13 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GODGY015434;
        Mon, 3 Oct 2022 17:54:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=XHorkvCAFdxIIzvrb0khpju5p5HUsW1CYxx2TKvcL+U=;
 b=0b7nXAvoa7i5IZ93+xxNwhWZaHv3viLu/JmDbx2qjAO8gFkNZC5yr1w1o3+Y1qlSBS0k
 WT22ap6jp/isPUBq/6oYi6p/qT4NNLczEBx1ZFzg0YdHDvt2tUqxRdQutjs1xzOvqMD5
 D8qj1+aM3FryTamU1vPDRJfX7sVY5a2bhG6qJKxl4l/K8ZO2qTaQuhXN0pzcI0/tSw0h
 oTSZi0Nt7DZRc7c6uk45JSN7zctqGDigHzASBLDo3HkCGnNGsPhjUZyt9+FZecrZhisk
 AN8y858vRo69iqrfq0nl95bFcQmlrAw2BIz2+YDF5w5Ixon91FA5LkaBGwB8NmNr5PwH Tg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxcb2mbn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:04 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293FFNfh028067;
        Mon, 3 Oct 2022 17:54:04 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc09gdgf-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GoRW6Mk6bn7lg67Wq8VP/HqrE8lF1dN7HdZxZdztafjrMd3gYRKW+yXH0VeM3OfnZ3bYnfxEsAZDaawJT7ZEWicNrB/poPTeJ9WqCAeX0aAXu5WISkUtqGIZPCbbf1C7dYzGX8QWeuWV60kePZlDOA5wyQ0sLJq/9Ot4iyruYTeijdLC5O7AxQ7XrMiD7t8ZQrkbSFJYXPDMk2Oyl3dRhO2HtlNnl9t6/P9ImAy4mS/gArdzXPBdi5q3j33NQQeueUu1BMVGmBItgKJkF6bSVaXQQKoxKCiNu5LwV/cF5oT9ECoCERoSKK0Mn2Xr9+fbozMIOvOwFAOZ0jtLlNNsGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XHorkvCAFdxIIzvrb0khpju5p5HUsW1CYxx2TKvcL+U=;
 b=nIEJyYQYiJ2tbuqlZLxRXPVik8/6xIzyxPfnaNpPF9PdBkblECwau9UBog0BBR93k+OnedPLGR0iSMquiiqm4TcGqVZdzE0A8M5/6264byJGyMMbigbF2Gz/6uhTDEE3wnGzERswvfAggfkQI8Lvtn8ODPmXCeqbDa1vpmOY5aFHTAitKlafNdNayOduGEC2HA7pU+IotpAcftAqoDtdFQYIeQIqsa+eCEp0NYAVmEnfgqvQ5qgBWqbF8XQkEXpnp1qB9D+Wl1nvxikhC2NzoxfUf/iQrQIg/HxHNp5cB2kB4c5XvrkEmwAy+Z5woRDzkh8myi6QzWkWYRC35FkZyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHorkvCAFdxIIzvrb0khpju5p5HUsW1CYxx2TKvcL+U=;
 b=EUWv8ccLyaVgsn69rMvIq7mGbftdcYAD3MzcB250RU1cKqqET/N7KDJmJKuaY+gcL0a0gbRYr0wyrnkBzm6848ZM1dJ9SB/MHgHSqz741f0prXh8Wk7MY33YuZDxPRRaHt938FGaXtYPgiK7zSm5Lj7vc50tENquaR9J+iXYvEs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:54:03 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:54:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 26/35] scsi: spi: Have scsi-ml retry spi_execute errors
Date:   Mon,  3 Oct 2022 12:53:12 -0500
Message-Id: <20221003175321.8040-27-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0226.namprd03.prod.outlook.com
 (2603:10b6:610:e7::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d8953a2-c6bb-436c-484f-08daa56841e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kUtBBIcNP1+NJsSoCX1wo5JqfduozYMUQSKH+tqsAe4jjgWw0JeTVF3EiYOIcHSSFjaaGb4Tw0W8Rh/7rLpe0a+blmRO8EF66uj0wLsxeyMZbnqI+R7LmBqEZgBTmdHVgJFs8gBgKDjdokRL40k7FQbqO0Gozv18ur5TNhbdmq8yoCK4PcUwZqBmSb5eXD6fyl5B2o4mGIs+vJdZhgqVZQfkn/6eyGr9VoT9nKMOjR1pbASYvJrfs45v+ilhSgO3gsHFOhR49YDbkT7HNNV+wj2OKIEggmanRU0/QeQwVT+dl9Ijq2wzMxuisS872uIW1KnNF3Yd2dUa03kX3OIMWxtp808RGgsa27CUHvvO9w2DtkjaQIfHuaJUbZA9q9HUQMpkfN99qgp3BlVquSCCbTIxI70G9nESikn+28R8MRIvFfmKlffQXIP9CDnr81ORfY2Gwr69bvITsf3Zt9TyhK89CyLQiYdYcLvlkcRNgx6FOG7Cw1SVzwACaUPip6noK5c+62mQNUWSZYtMadCmTSH2/KjIvBXRvX7lxCDmdYgb2tWf69lhsXHn0PWPo5o5vqfnr+k9mT/9qOlQeewikA7ARi2fsBqf7N2sFXolr8V6mRImNR+XKYcfx4kxED8Srw5NuDUmq4ussjGyryihd0QgFPa3CBjfthuKGw92vpJ7zC7HPsoClXtZBewTrUwYp/5twzFNrotyz6xuJzMhIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(5660300002)(36756003)(66556008)(86362001)(4326008)(8676002)(316002)(66946007)(8936002)(41300700001)(66476007)(186003)(1076003)(2616005)(83380400001)(38100700002)(478600001)(6486002)(6512007)(6506007)(26005)(6666004)(107886003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zb37tNgiW+3iJuo77+6MI05abT/DwWwgD9CRHOKll2eGiJ58pjcN1zSdFY3s?=
 =?us-ascii?Q?Ue/kzsQ0ahBP7b5iookGyHcAdB6lFU5UrjQQDWDl6v2giETRYzhU2uAuVCp/?=
 =?us-ascii?Q?cwvsrk3fMnnKhNQkxOubX490aZbXgsuE7r4OOyaD3cy7kQrKe9szkJyO4xH/?=
 =?us-ascii?Q?gddJDsMiJ37/+hBgEit1fnjr+hSmEMxE5dlBcbOuycpAE5y4XWX6W1b3aydE?=
 =?us-ascii?Q?W+xglfpDv2O/CHyxrh/pFaIr0VwgEb6s7hXKOs3WomrQd9slaNZhbdvE7tII?=
 =?us-ascii?Q?zorfsEo0dF8o0S5whzlC7npfZav1LEJK9HMGozw/fwm2cHnUrkFGTA8UJtHe?=
 =?us-ascii?Q?EQCYFkDb0Lle/Yo7gmGN37K4WettsNjggyGpxIrDg1HKOCrlzg4nepa+hHF9?=
 =?us-ascii?Q?lCwm38rCB3gTYT84L5FqzFjz8k9bFNi+0gbVGZ5vpjZcGc9T9EZNy69wqPWD?=
 =?us-ascii?Q?EOqGshRdihvveBfRlLH7dIevA0udhAsM21uEkr6qqnCoagcImUpBw6ZT03XS?=
 =?us-ascii?Q?Sut/wnutYSl29A4Io8mnMFNYvCVorcg+4SEOi7ZfagPXlZrcGNQLQsGgMhPv?=
 =?us-ascii?Q?jgPjIbECGN3j6JCBAitkshiZ4TWnrxd+uSS0Twzy8ydI1oqlMsA7M7K+rL1y?=
 =?us-ascii?Q?+1Kc+edhSo8MFxSvTAjG8Qf7IG6Acy9UGft7MJfjmQmHraczqg6x0kBOzz20?=
 =?us-ascii?Q?5t4ngFh9DG4Lk1ysbMAYd5GqRokENju03E7v2AOqn3y8rK4jSrwRs0Qa5029?=
 =?us-ascii?Q?1ybS3Cf4ftSl2bFMJeHPf63l3631wuXzGhjYwTbQTpQHJY9m18+ychnTFhqb?=
 =?us-ascii?Q?KGUJzOvckHK4QlobdpaugdMjYvlydk+4lfmb7vCVttVINMxjDqLVN4tK4iTl?=
 =?us-ascii?Q?1ckN0IsFLLa4WE9fPs34eoSo7f2Eh8aUtzxgiCTNxXwuNGap1/EvRpjHhX5p?=
 =?us-ascii?Q?rjdgaZ9vfCNB7as/qwKlIPvuaO4oEByc/LnE0XHbYqEMtuovHLmBnZAhlJAv?=
 =?us-ascii?Q?bKxNdpSduy0vWwLJ8S7eR9VfF4LQ91SWw5ZTh/zFJcSvpTyS6VSEz2vbHoAV?=
 =?us-ascii?Q?qHmdJiExhzCRJ71rSpIwMUE0vi4zhwl8TTgJCRoX/l4VaBxcF0lH5kY/ka/B?=
 =?us-ascii?Q?ytcvbrrMJFF3VhP4dsi5w7ShKIxH1w9TNO0tt9mpBu/zxaz+H44vCGfFoF1i?=
 =?us-ascii?Q?iHvs0q3/sqADnuUbl087dBQP5GhI4icCXeevnNlMizT0H2Pl5RR5hP9HBbgh?=
 =?us-ascii?Q?ZMbbMscjxdNvYR4q0qgntPejFC5lBBzJBh/9MPe07rmY/GOFEZbulZIHGSNb?=
 =?us-ascii?Q?2TeIJTJdOfbi1dBFydXL4QfQb5Dv4u04suE59WjSaop9jsSUB96xas+Sf1Yg?=
 =?us-ascii?Q?VOlRMICKiQgATJnAuv10jAkWWeL6Sc7N/V9cTvsiWILKmLO326vaSGGw2sbd?=
 =?us-ascii?Q?4BmLrfq5qECq/p8r1umhntVPeGgnNnMca8KaU8JrmgvK3NZtG8WG5a912wmk?=
 =?us-ascii?Q?47ssoiOMjMAlzBOD7bAp16XASeuG6jjWFTy1FJdrmr5D0bULeokMCYuAatz5?=
 =?us-ascii?Q?4LBMiYUIbG+WgnOb+DYcvbN9wAgfFeP04hC3So1btFRp6jYAtwxBiAXXF+HL?=
 =?us-ascii?Q?BA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d8953a2-c6bb-436c-484f-08daa56841e2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:54:02.7970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Bh5Vb7HowZjQqijV4T/1O8wunzoE0xd5ptWVICi36GOMpdtjEIMImpc1+qNbByXnpknY6BeceXbxBuLNo4JJbfhE7wowJ+7zohoqvQKpNk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: vQqZRHOLa3VsPVTzZWuY_8d963UgfnVZ
X-Proofpoint-ORIG-GUID: vQqZRHOLa3VsPVTzZWuY_8d963UgfnVZ
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
index 55d9b13b2f8e..ec5b0f562cf2 100644
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

