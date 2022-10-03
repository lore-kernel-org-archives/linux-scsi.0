Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41533C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiJCR53 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiJCR5I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:57:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3A93E77C
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:56:09 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOXes015770;
        Mon, 3 Oct 2022 17:53:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=W8LPxGOI81rOGt6qgnUTWKWB9FUN2Sc4p5s3xAAL0/Y=;
 b=I4ysvszgzm0i9GA7OeDGaq4fHST1ax7E6AXeojtfwR5pmvI3Bd0LY30s0KQmLtOES3xg
 uWYLwaospfanCMkvVmDU6X9xggaSa0tswtRhuBkcwkuuQlR5nlo7lLH6uoZMVJAVipag
 XqPHEPlAT9nIslVNl/MCgE0RnFivYrL2GCz5mIl0GP3edGRwL93zrcd1MsXqONUB6AT6
 fqmk4w+pa6XA95i9b6QQxmhFZhxMg1WWAsgxXJvg7WA+Gp3KHcsjqDyVzWDp5UYskR8f
 Y+ZRxEk99LcWpT54TvvRfCuS9hMckBr8QaK3x5fONjboIPYOvI6pXqze4clelDx5nYVc /w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxdea4cw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:56 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293HoXFN015597;
        Mon, 3 Oct 2022 17:53:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc03g3se-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SNvsTKV74hySkBKl9OUyKEMDCfaFX3eRFY5JmbSAXACZEjbEm0AQNRvIhchGk2A8WT5PETkaLigevr/orXX1t6f68YtYMgsaJLkGyGtXbs2BzbY6d+wDyRKaw57YZQOD3eXbg6pbNytcikRRIAHF0RHPOAxPjqMyjJdnIbFcE0W/eij9NjbkPqcEDRKwtVrQtHW/U40WJ57DPCYk8W79JsKm8Ift+tnm2h7EenAgaWZl09Zt53hdxwvKb4CrSnto71avTB85a+hsSsA0DTSS7J+WA/Sk7vFE8cLMVvnvXaWU2uJW/7uROa9Tt3UIvseXzKaUtH15iQx9+F9Z9il0fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W8LPxGOI81rOGt6qgnUTWKWB9FUN2Sc4p5s3xAAL0/Y=;
 b=ZY+ae3jKB3lpkiwXGpMa6VBLGhdZDkhwUSghLMOzfUvd4cDZgJzZ1c2hHgUX2rec+cH8ye05zFLg01ZLRj9Ds+gTjeuIEuBHwyQdsw5mURXoaXSDQaIgkNqX7FELqhC7bbuAbYhZIok8QD/KyzrkttAC3nZXH9DhMNdbJB/fyqlZQX2HLRLLH8IRVEtJLY6Xl2z2O8hOA17kxcwCTHLyXz46sUit1xDgmGS5fv4ch9iGO25gGY+eOkaBf55oeUS1kTop8+4JZYg30nOjxEhKjohq0nYJrMw6jsXthTbyGL3w3DS3gHvXZeh0IXJbKGIGi0hppyd9Ws4ps5eSK9cslg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8LPxGOI81rOGt6qgnUTWKWB9FUN2Sc4p5s3xAAL0/Y=;
 b=mfdfrJvfr4gf/gzo5TU4YpqT5cN259bM+hYn8xZTVs/D/5N9ppwUYZuT43r53l+HcgshVqQiMZzE41VevuwBQpae8cF/vpajTVSAyijVD8L8caJI78JIsGrMboUvUZIMUzKpKT/N1SuvY3k0vlav3Qee49eVsftBfuhwqo7Wdkk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6824.namprd10.prod.outlook.com (2603:10b6:8:11f::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.24; Mon, 3 Oct 2022 17:53:52 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:52 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 19/35] scsi: Remove scsi_execute functions
Date:   Mon,  3 Oct 2022 12:53:05 -0500
Message-Id: <20221003175321.8040-20-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR16CA0003.namprd16.prod.outlook.com
 (2603:10b6:610:50::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6824:EE_
X-MS-Office365-Filtering-Correlation-Id: 8529741a-8638-48d1-74b0-08daa5683bd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GmZw9qbpF3FoaQU7OLbB2p1DdcYSpgoIWLJX/5W4TJJihoXPjalDIDti7jNZTQ0oy2cglcFBQRBHuOHfDmuO4us4OxRflJscPegnRt6Y5nz6C9a+Go4L05b3LHNGBXCFGYmEf5lJzpUo+CnvEGFmi4ze5OB3K7VZYdrxiKRmmxFNwmAzqJRkfIq/VeNrIqnK3BvqONsVVm9OGW93tf1vExqRggmsm753/yDQwF3aCBimzJzFUaAn6itKD5TLCkXje0LRgx9Etf8gIPOFjdu2z3STbJNylSwicDPDCZd4VpJ+PMcQTZ9Mlr05eGi4NgMcHBFQJAgayv+9kfSxYvkCOdOA9hPDl9p/ulNjTmjpUi/csoOYuXlPsOzC63hPl23F9RC+pnX89exJNW3/I1GqLG/YqfzXhSM0SuIYOClHNqFRq/T1gqc6KrWWouZR9y9Jcp09EPNaDPUiKU+FwaCt6GjFx1MkFLc4V01B0xiD7+RwQc6b1tnmm8rkJrvXBDWQ7XjgWxBDj61YEl+M98z6/mpRHHF6MA9u1B3pEXPjE9U85uTAvc5VHYIwKYGGVxW7vLbxJk5TlGyDr6aETv8rdnsn+DVg6AqxV0KnIEggPApXrr7UQlRVNkj8mt3kvDTPepJ5kgLtUudMKuks2MKkyiiA6gTGdoaFoWqYnYIYVQ/JBS82CRYKnFEEig+MUZzkT+SFLaJBP1haW64sMDmzOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(376002)(136003)(366004)(39860400002)(451199015)(6512007)(6486002)(1076003)(478600001)(26005)(38100700002)(66556008)(86362001)(316002)(107886003)(6506007)(83380400001)(6666004)(186003)(2616005)(8936002)(8676002)(66946007)(41300700001)(4326008)(2906002)(36756003)(5660300002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3u6C2RZFVml3OkkU07npeqWKrqXU4OnQDD5FwJIjAxZF5R8EYYGSMCDjcflW?=
 =?us-ascii?Q?m7CBx6qiQE8wWFuJZ3F3Aw7MbGj2FPWG4zDlz0P7N+K25qVPa+CvVK2Cm3ru?=
 =?us-ascii?Q?Z+mOIf81DfbLUoNeWpH4EyCGxDSDRSTSUSb+6deIpxBNHdw+hBp5stCwparX?=
 =?us-ascii?Q?rxT/k4NOy9MOHkPo+XVZVBJld7StCwVJImTrgEOfDU3Mm6j90pCkZTKs+GlO?=
 =?us-ascii?Q?pTlsuY46p82rxxEx6MFNpQJ8TKxYn4sgDXyMzzv8xTwo4Cgq6wp4rgKLRwDL?=
 =?us-ascii?Q?4gHpaO4HD4VPZYZXx8Lgd8qJQ/4gGmIT+ivMxYCp/y1Kx72TXaSD3u/fqY2a?=
 =?us-ascii?Q?61hQlLGpxVl2lZFe3wLYC6vsiXqXt3XJLv4nZhmcPX0DTHamPcXtdgsxdq1T?=
 =?us-ascii?Q?phuj3Ayx1CggLtdqseTjZRDWVfmIFu5yD0yhRkGaPUh61DDBwF1BoTkhgjHF?=
 =?us-ascii?Q?hkJQZtWYWKmvP9N0D9B16Mfqc/aEshDjRMcIitMZuiPJG2jx+X3HFyV9eEIw?=
 =?us-ascii?Q?EAZxyS9gkSkWnSHdR49kV/WdI7voLcFJ2kbAtuVrWtyxptnTf7wiR74Kz/6U?=
 =?us-ascii?Q?Uh+3x5vSQDQtD3iEhByjlfukD+PDKQuN1G2CiWfGEu6EW3ReDcdhtKr8Cwmi?=
 =?us-ascii?Q?BtD0BWOZ2UvjwA39gbLQydsnsBkSbSxAv/X1yPgMojaIKTYsmxL225+8YsOB?=
 =?us-ascii?Q?7w+ZSGA9UUfJ8/prptotBnWG0MGK9yzUbOakQ7NQg1a/24dfw6E2m13amQlz?=
 =?us-ascii?Q?Mv9hLC0y49Ue4o9Y0gHVeUNWRhP5jog6SSyCaNs0ban97NLfAlTmqzesEVlb?=
 =?us-ascii?Q?qAWryM/riVXEJPAxmWu6mnqgDAUfcwG9tHkkBuw9xQfO7mf3yXPD9sajtzGz?=
 =?us-ascii?Q?q+A2nKxiXiP3BggJLp8uc6IcoDOK2AoizNw9R6mXJ8jD3gCrcQgh9NTSOC9x?=
 =?us-ascii?Q?eT6C27uWjm94e1l8KV3+R+H8pyi/PAeJP8oTNejvWMGFVNC3vxiI/LyufEpW?=
 =?us-ascii?Q?i3ABKJZc7qxKuaPcRTQYNOyxLKtyRMt59/QyBkYFbq+5QeCDjYTo+aZPPsF6?=
 =?us-ascii?Q?DcrzOXpDLROJc63aWEwK2HXl2LOqn+X87FSpCFT20UMOGNCnP1Q8pT90Fy95?=
 =?us-ascii?Q?m9eGFBV7CC/6rJUXdgF9bD8HZy2eCT4a9YjifrKMBUpojZSu9W7oZ3OE8DPw?=
 =?us-ascii?Q?cjTVhMP4tFT6PXYcgzMGvS0aFbPXCjdGqfZB7tFCssnKgvY8RbSUGkIjDu3h?=
 =?us-ascii?Q?pAcaqply0OsOfMaM0jyn33PpDnOnWVogta/33dd1bFq3YRnmZwSP+GtuQjZU?=
 =?us-ascii?Q?R/iDuhiReWnngunZ33SyuNmXMQMy9XPB5XtyQzDJZE1m3Kla6Ekb61QjE0Fq?=
 =?us-ascii?Q?g59DEG4HwNn/UdmS2byGksr3ZCacg/n+ASe/vVvVWNPStHvkFQHmt/J1Pmox?=
 =?us-ascii?Q?Q4U2XARqCw9lot7LEC3kajJ4aIRF7Rr2RqzMG0B+qqxQHG1ObeiqPCDQcWPx?=
 =?us-ascii?Q?dm7k4pgGtVBOwF8c7XHQx72znmu7OuGIrwbar1+n36isOn+Jfb4rEftLGQDd?=
 =?us-ascii?Q?P1BWYsLWdGSirrhOXGJ39E1rlbGLxm0aV4XHVYUMzIm2RrlwL4CcADlQtsRM?=
 =?us-ascii?Q?wQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8529741a-8638-48d1-74b0-08daa5683bd9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:52.6572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zJoJf+F27LeFjqj3dSPbGgXXMBXJq+N18F7qybcqn2H7w5XR1A3qCzOPnxNcEG+HTctzaokuXrBxKrqJmje4sPBoSntYloIHSlbX5qTeBHA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6824
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: 0DWyWJh3FHZ9svdvoxMAK6Wk2q9gPx2d
X-Proofpoint-ORIG-GUID: 0DWyWJh3FHZ9svdvoxMAK6Wk2q9gPx2d
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is no longer used so remove them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 include/scsi/scsi_device.h | 39 --------------------------------------
 1 file changed, 39 deletions(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6d91c14527aa..986decdeb725 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -481,45 +481,6 @@ extern int __scsi_exec_req(const struct scsi_exec_args *args);
 		     args.sense_len != SCSI_SENSE_BUFFERSIZE);		\
 	__scsi_exec_req(&args);					\
 })
-
-/* Make sure any sense buffer is the correct size. */
-#define scsi_execute(_sdev, _cmd, _data_dir, _buffer, _bufflen, _sense,	\
-		     _sshdr, _timeout, _retries, _flags, _rq_flags,	\
-		     _resid)						\
-({									\
-	BUILD_BUG_ON((_sense) != NULL &&				\
-		     sizeof(_sense) != SCSI_SENSE_BUFFERSIZE);		\
-	__scsi_exec_req(&((struct scsi_exec_args) {			\
-				.sdev = _sdev,				\
-				.cmd = _cmd,				\
-				.data_dir = _data_dir,			\
-				.buf = _buffer,				\
-				.buf_len = _bufflen,			\
-				.sense = _sense,			\
-				.sshdr = _sshdr,			\
-				.timeout = _timeout,			\
-				.retries = _retries,			\
-				.op_flags = _flags,			\
-				.req_flags = _rq_flags,			\
-				.resid = _resid, }));			\
-})
-
-static inline int scsi_execute_req(struct scsi_device *sdev,
-	const unsigned char *cmd, int data_direction, void *buffer,
-	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
-	int retries, int *resid)
-{
-	return __scsi_exec_req(&(struct scsi_exec_args) {
-					.sdev = sdev,
-					.cmd = cmd,
-					.data_dir = data_direction,
-					.buf = buffer,
-					.buf_len = bufflen,
-					.sshdr = sshdr,
-					.timeout = timeout,
-					.retries = retries,
-					.resid = resid });
-}
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
-- 
2.25.1

