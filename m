Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D6CEB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243404AbjFNHWV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243395AbjFNHVb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:21:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BD22102
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:20:34 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6kNXf015669;
        Wed, 14 Jun 2023 07:17:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=xwBsut8nJxCe9OU7H1Ote3aksv63jRE0lqFzmAOJN28=;
 b=XMp1lAePxLhl4dllfukikLoo3Bdq21POKuGVvsepioWqZNCuVyVRgF9zu3DcKbCtM2kA
 AHWe2ZDgv9OIA3KwoW5dlIEG6as+xZoWyEipX0Hzug5fgZe4yXnrGb/HeJZ0c2nS59Hr
 scbw3boXXryRwuFM4tSwopOKwzmY5RXDorixbfUAbTfZSClQpx/cBqadvFIGFyMGLXVM
 PmH+PbXS/oMJC7HTJrZe+100mLr/pSq0rM0MziYnm6du2WPbTPyTmq7f5/UgLQb2/oIm
 o+OlIPb//mV5rb6jjkfrBCCndSHygI2bECy6GVvOi3E+SiDo28mL1rBJ7LErS6yjaaDM 8g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4h2aputm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E5ZBp7008322;
        Wed, 14 Jun 2023 07:17:49 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2046.outbound.protection.outlook.com [104.47.73.46])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fmbexh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQKLfom+srkW4T+lY/dU2goAHx04bs18YkM6gZU9LPiYkBnZFfBxJoq8QIWPOFmZFes/oUeho0maHTIbeAIo8F62oHZ03u+WScq2SwYk5WUw9k0Hw+S0a9kHRJIHjxKlx35Gp1Kxw6iVGmjdqrqy8PZhIwyOL4t2j6Us+5cU3nPO6tjc1ZKpiCMbU3tepxVHLgP3wKC5ZV1NpSkNgqw5oN59+obpj7WgqMUoJTXvuf2zwPfIrDmncHdLRg55i5P8/onqX1LH0Rg/YEdw1Kfvgb3aaMFITvuUScrV98aTUok7mDqG0Hf0ZfF/5pxNV4IIv65q7VW1PxDS9IwUS7vPdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xwBsut8nJxCe9OU7H1Ote3aksv63jRE0lqFzmAOJN28=;
 b=W6aIATmKDHKIAA59I1Ce4BQlmAIGPdc3JuscsOHdVd7W5KHiX/qNQzKL+4WKnuEk9IBkDXt7b4geKkI4BaLLrLSVZC209nStFt1Y+FF8Yk/3EseSmsYn3eQd/5XUjQLSMu4DldhTjs/1sPbuCAJWDFOzYldXGqiwLPctzOC7q9Px7wt+XydPzbKsHxmqgSevsytIOnLCvnB47+fjhcK2X6nWrV0wPWm9xuzJg4jroakSHqwzyp3IWCHWwxuiWFVmNk36zN3kEzwtf9k77pKvale0wbWYD8BoDA7GqE2itwA+LPCPIGNi94J8YNErQnhRnDUB5DFg2J7Vcu0f9YcHAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwBsut8nJxCe9OU7H1Ote3aksv63jRE0lqFzmAOJN28=;
 b=Ntb7/9CShqgi/UP2rfio2VIx01rXsBd6o+SXfa3HpObB8PwDy5v8j/SYUb+j+IxqB97krqtQvWBxT7/TWPBsJSs2SMsgm6Z9sePO0XwoM6rQpyvo9cm1VV+xTTnq1F2zes9F0jowh7k5u7SErm30MCT5AlI0BpfDrVxPaDo/D88=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB7030.namprd10.prod.outlook.com (2603:10b6:806:349::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:17:46 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:17:46 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 14/33] scsi: rdac: Have scsi-ml retry send_mode_select errors
Date:   Wed, 14 Jun 2023 02:17:00 -0500
Message-Id: <20230614071719.6372-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0278.namprd03.prod.outlook.com
 (2603:10b6:5:3ad::13) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: 11871bcb-961b-4351-f0de-08db6ca77433
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kLjjDCGs8jmrq/oDqwJ7T/TPH/H9HAlaNmouosQzGu7kGKMGeVASFrvrm1u+6iMnLbpRIzRNgyO4PlwTDg+hk5E+clfX0k0PSLkfKJ8UUl1LXwjysz4S3gwPgpaxjhHKF5hrcf0h2B6oH+2Fk95kY9giHAFrhV94HNVBmU00NONsnk2MRJ3TC6g30hinOWjw0yLhkS728+RAzZGbbtaDXNZCcspGjKXidWnhz5Nv4KoQkgGin6mJGkxBj5sWvfeSew+e7i4GsJn/KeYHb6fd0G9wV0tEipLaiZIWgfFNILXxIog159/J5ceDFcJr+7/M+PKLISssXCTSTIDzTFo5DEjHogyGR07FhEyIGzQaIvBn+c/hmsy0N8OlkSSy4TK4NEBYHZ6Qa/DeVuKbbtao8MqVcAVMP12BudyN1pA/l0iw9a1UExyrPnzoymvOcgQ8v78EO1bHB7L4AC0wyWr9ndH8v2WiXxUyQMKHfV/2aNzIpoLEVlPG38B1PfTc2RPZYiCHv6729iNnVId9BuBgqbdtVMpmWrhOsPTKz3a5MvtFNLFUlumFknjLUiBkayxM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(66946007)(66476007)(66556008)(478600001)(5660300002)(8936002)(6666004)(4326008)(8676002)(36756003)(41300700001)(6486002)(316002)(38100700002)(107886003)(26005)(186003)(6512007)(1076003)(6506007)(2616005)(2906002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IBMbZJlzq5VM7InBMms4JzstQxAf74Rq5kTpol+fKbJzNWrHdEW7ALgiCnKZ?=
 =?us-ascii?Q?+tJNb1OZwh1M89Okozc/CLP3tWSdH8WmaUGytUqM6mOqvTxW28EUZFgfOsWt?=
 =?us-ascii?Q?e6d2zZnuFX+iKiGbQAEuudvQe+/XZ1UvS8Od2fB2B//pZitwJVAvdPuGkLS/?=
 =?us-ascii?Q?nFBajRN0Ff72uuKpyWIEUsLWOCtvThwleSTqr7Sayzsz7IX+hFJzyia4Eojn?=
 =?us-ascii?Q?1H1G0/8hiV3eCZoG0Mk3PrKYxNA0WRaFqI0WnXGyJrxLSHBEkPMPUMfDh9uL?=
 =?us-ascii?Q?4gDojHuc63spnR0hjKSGAJu5b9d2f1OsbdeSEvajdxKp6BnyAU3QHd58vTwm?=
 =?us-ascii?Q?08iAJ4IcXErdYZnOo6qL3RTO2zu8i4DjIzTS5B9/Huf0L68Rvygr93AdjdGu?=
 =?us-ascii?Q?kOBueHfY/4mtazOrNZFi0IlFW76x6pL+TyqQm6LNJ2vsTnYrvbfhFIQnQNpA?=
 =?us-ascii?Q?ZMC7ZcpyV/84RvUewkWSzfLOf70xquOvVsThI/RJbdUG2MHuL4UoC6Dp8i6k?=
 =?us-ascii?Q?w/LJmK7BF8HuR/llvwWySvrZKgO0qy6loKOoPHcFuj6MwMJbA9kNxX6rDYc3?=
 =?us-ascii?Q?lpDMmZZVOD2EM2Q1jdYWBIBK8PcN+FpjBg9wznKgt8mLHxXeNlgEsvXDIViE?=
 =?us-ascii?Q?fgBSbEfMGm2rlHaN79dc8PJ0LgJ60dbGeDfPNn7wnV+qW0BhDBqRrI5skZac?=
 =?us-ascii?Q?ba/b73Ups2JJ+HRmHiAm84UsB8lnd0X/AlgWzp4dfLsthZkd1pZRnwQ6chPm?=
 =?us-ascii?Q?WUECJkkztNuClZYKZdED6N5W3VdX/02Q7c1wiJw+6kHOVXUNISUT+DsFkLPE?=
 =?us-ascii?Q?FZHbk2EFOkk0eDlFnKNlsLf4JMjK9uw2i/MOu5II54TrN3HUmy4HNu5jH0QB?=
 =?us-ascii?Q?y18BBHY614DiAnINExV5taHyI4iJdJ4x54Xs7fpLHdsmE/KWZHeT8YnLZj41?=
 =?us-ascii?Q?UfssrnQmMlLB1bGzrfM8OiUaHPpGgvQDDs4+tXrI3NyL2ziL0pG6Tg4cui6N?=
 =?us-ascii?Q?k7tptByJ8R2o9JFCgubcV2Sh5+g8Vs/+SoyAigX6uoiv5CTZUFVc9JK26bCm?=
 =?us-ascii?Q?JmMB2n2XfqbjhLHNxh25PbzsaNtSkU2e7ip+08NBSJ3zLxAtAqFXnYWerTrO?=
 =?us-ascii?Q?yZ3powmb57sTQmgI/VOu+JqeVRpouYZeU19EonAqLXXSRSl5ICc7xVppaw2j?=
 =?us-ascii?Q?F05wxuTmsJVff3m3AoTw1TVPheuFwqlQ2gp3aGGfqFZptSyUqa0n/xm48O4u?=
 =?us-ascii?Q?Xz1zdvqLbwbZPPMiw0T82JcenxS++pXS4xBdcjL1n7Ekm4GIpT56tVQaexQ+?=
 =?us-ascii?Q?XXJs2+LtRwlPusw6m5uLZr4yhkYPdr/m+Jn/tX5UWIkxe8m/OsvnN9Cq5SKm?=
 =?us-ascii?Q?NxH90/s8HoM5pELyJpbI5wlrSgLUwELWcO2hpbrArx0Jjz1dvpnb4D/vExOo?=
 =?us-ascii?Q?fZ29KQ7f8AXbLi/g33xfHXzRmWytqsnspbz8mIdPfGyo43sFu+C8ctM8/Ycg?=
 =?us-ascii?Q?clmswwQdfhmfTikktIvEqyjYOcmgi1al9q9FTixPic5PlZMT8NyGKNNG3M+G?=
 =?us-ascii?Q?9DvPLahFtLLCRAPxHBWzglYF8ZjPvo3eE6Y34QaN3W9cbMTw3F8O2EJVtsbl?=
 =?us-ascii?Q?sA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: /dsb44Wz3T0Mn6TbtNWMjWwVzfAzpilypnAm63DoLvWQF5PoeHXciWdH3AlCPUBYic5PtDm789KEln8rlEwNQunWuv16pA7GnigU5A35pkE9R44GTsU9o6nkU7rJPywSkvSg0FGk3VJAOYpERdQDW9VMU3X4MxVIvzlNKYV5MZ4E4zxyHQuwxiy+X6G2RC/LRg8a2/6A8N2ULD8QO3GPmFjt5xfGtRvbyZUK4k0m1QfkX8DGtRPqLG06oVFXfn/Z46yEnhu4l2xBOrfenKMjY1wOwchkVcYlngS6drNLJC13scq9D0ubZC+6eOP3YKllo6bu3HyEhcj2hUO+SlMK8IRcXgLS9V+KRdx9FzSlLrcBC60Bzq0EMBGDoKPiQj5JrTagW0zrCfeopZ3ggS16cuZhkgcKQfnU2vTyS3Gi/3t8afT8UmxdAp6uIm8vmgvG17i+Nd6shgJoO6rJ2bubbge3/HFhv2iXKivM6nTCwhCev1jPSo6N4zh0fpSDO+hHKNSersVDXtk4JLZabtNxPUijRtbUnbfVI3g33+Fhwco+D5Pb0qZ1i1bZIzt4sZXQHs2c0iER2F5MKSjJUzqzzu3HJMu/vX4pFVSGHr1VHLaW1xeS2ssKoPPJlrpgANydI7qAWXAqUkbrBXlrNYa0RZFk4i5HuPI06vYz8LKyZEd37Hu5b56lPcrJaV4aQvoOX2xzDKmPMCo+mANbfNTXAkQJkJqd34+HFVQFlOj2zz7QeLewlxvsRlnMkeNnvzsquxRTVSv4xYPQPv5v7Quxwj9a6cJ9wPi6wZFpUqo94pnGR8JSdbyif7iw3HAc9mHjFwGCgDwDk/eH7q4M0nYNPq5PTJDMAVfup0HvFqBeDetllgyMLd3kxZfsi4/Zw74i
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11871bcb-961b-4351-f0de-08db6ca77433
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:17:46.8853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BF7ZG8XONGwkcFGr5PbwlPoT/RMB1wXxXzBn1W7+5LyHp/rvS7b4svAkeMHPPjwL5k3ePa0Cu7QI8G3ij/kDnMPzGvTqptChvqNtLM9a4vo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306140062
X-Proofpoint-ORIG-GUID: 76CQkn6luX-jHBq2NX_9DFUTKBGBNJoR
X-Proofpoint-GUID: 76CQkn6luX-jHBq2NX_9DFUTKBGBNJoR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has rdac have scsi-ml retry errors instead of driving them itself.

There is one behavior change with this patch. We used to get a total of
5 retries for errors mode_select_handle_sense returned SCSI_DH_RETRY. We
now get 5 retries for each failure.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 92 ++++++++++++----------
 1 file changed, 51 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index cdefaa9f614e..9811f9788432 100644
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
+	int err = SCSI_DH_OK;
 	struct rdac_queue_data *tmp, *qdata;
 	LIST_HEAD(list);
 	unsigned char cdb[MAX_COMMAND_SIZE];
@@ -538,8 +512,52 @@ static void send_mode_select(struct work_struct *work)
 	unsigned int data_size;
 	blk_opf_t opf = REQ_OP_DRV_OUT | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
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
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 	int rc;
 
@@ -549,27 +567,19 @@ static void send_mode_select(struct work_struct *work)
 	ctlr->ms_sdev = NULL;
 	spin_unlock(&ctlr->ms_lock);
 
- retry:
 	memset(cdb, 0, sizeof(cdb));
 
 	data_size = rdac_failover_get(ctlr, &list, cdb);
 
-	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-		"%s MODE_SELECT command",
-		(char *) h->ctlr->array_name, h->ctlr->index,
-		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
+	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, MODE_SELECT command",
+		 (char *)h->ctlr->array_name, h->ctlr->index);
 
 	rc = scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
 			      RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args);
-	if (rc < 0) {
+	if (rc < 0)
 		err = SCSI_DH_IO;
-	} else if (rc > 0) {
+	else if (rc > 0)
 		err = mode_select_handle_sense(sdev, &sshdr);
-		if (err == SCSI_DH_RETRY && retry_cnt--)
-			goto retry;
-		if (err == SCSI_DH_IMM_RETRY)
-			goto retry;
-	}
 
 	if (err == SCSI_DH_OK) {
 		h->state = RDAC_STATE_ACTIVE;
-- 
2.25.1

