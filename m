Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36A30C4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJPUC6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiJPUC4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:02:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94238286EA
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:02:54 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GIrcZn019532;
        Sun, 16 Oct 2022 20:00:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=GYBSYyrfzYDZPenkGwyfMrFInG9Lh38VD1BLh7ED/IA=;
 b=F1Kv/1dP7/vTnLUj86t7SJiWJY73++Vv0jwo0P/2bFMuMFgi3pH5STcCIQsGFS64HoRn
 /0WAChCQhH6tQoBdmx/Nc/HB1cmB+n+WRm8A3efhw1vtJyYHoptc3Qi0ugu9pUXtY3px
 p5DHJuoE/kB4vvbRjXMuC62Xs28/6GWksGcMvJRadBWLZQWN3T2YhO5RL4f+SOWxn+nz
 k0RFzc+GKWa4dcAwd/lnXSro9m88IDFye28CXrDwtOIOCyCDm2JpzHcJhDIwCsyhTbgy
 mpZhxBvldgmrDg71sCaFPln0XYH2AnC1KtPCdehJ7azxi9JrCPrjKAPj5ULMXld7f8GW BQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7ndta64d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:42 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCHaIX007291;
        Sun, 16 Oct 2022 20:00:41 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hu44d7n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ax8/YlYxGWuczL0Ixan1BBoIxn1rb5T9D7q7TSqx+3l4AEOJCr9aw6c9+YQCRkTb99PmCPUcJA8SDBivyGcNs3ii/3UPr21KBP9A94nv0V07zgIbrXxBl33w8Uz+k8ttJAUfVHU1B8qSvjdVFpK4BbNaYJxhDAMhMbq4/eP+4kbyu6VEUDBLeg3PSNAYUVHy52vm5ORlwjwHMXXYkIIy8UV7ixpnm1WyeKyJoMzl8OWBc17VRdagpbkOadJMJg7OgpRW2s5WDzOxrzpjD9FZ+02ZyFXX4flsKmSMOcmR5v024BzA2v5HG9RpIIYBbWRw/I94pbsz4zj21Ylbw+88tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYBSYyrfzYDZPenkGwyfMrFInG9Lh38VD1BLh7ED/IA=;
 b=Sb0accucttqVSaB8UpXaS7OFNqg6ON+ycuvVpk+vTarVW0YejIHRcH0AsRHphPT1dWzbyMA/VJqqosYUsK/jmAQs0oRIDU5O0khr/BTUUNhpfw3IS/ZTXyOZeRyWXHF1vtN+fAckxxHUrDuBlssqnz4fRsPHenWWkp/HlNyZp/gklQku9gm9fi95DwolIcceunqOs/KCl7v58R1nK/VZOydJwZuFKqY52KxmH5B+bS6q5+5VUBct6PanNPbUXFa39PFWKiL27yJ6eM+cMHi47kwgaxOJPt4pkym80ahmOOwQ6QXwoj6fD2ET0nPq9/K56JKXCDwsnf164XKF3al9vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYBSYyrfzYDZPenkGwyfMrFInG9Lh38VD1BLh7ED/IA=;
 b=Uw9BEaq/FnkhvqXPJjMseE+psxc1n09+q9huIQufk/7ji1PtuNWS29MBOxE6DL0R9DOa0bskC2y8hRYDXfXK2K1UxkZnaDsnm85af439Y/9KMBZKQ9sLEbb8WNcSRJMtHawyDaKb/P5b8EHs3rV3OmZ1ro95G57w+Sycpe0JAJo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4603.namprd10.prod.outlook.com (2603:10b6:806:119::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Sun, 16 Oct
 2022 20:00:40 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:40 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 27/36] scsi: sd: Have scsi-ml retry sd_sync_cache errors
Date:   Sun, 16 Oct 2022 14:59:37 -0500
Message-Id: <20221016195946.7613-28-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0059.namprd05.prod.outlook.com
 (2603:10b6:610:38::36) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4603:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a5af23a-fa51-45e0-12c9-08daafb119c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S7h6UmnTuJB96l5cNkeX4GRvy1xJP1YRTWR2GuOcpKUoKWdY4L1cE/yRx4i0/lQdi3Xq5DiEeuNcwlAvLr9uPNHAT6XoXVQjQ13xjsJB0XaWk6Kh56oO8T0mqAVZTBAK8nwELpiiYJmftw0dxqG9RD8Sb8jgjlxsJ3M4+EUkTPuf9gknWLLG0QAK6u+cWby8pwFV1G0cI8Eje3dfXgQuMoyR/WlXG+Odmn6RCLE1h4Qo1rOmzOXkbR2YaJ3B6TSCI1yqu/WHlNaAkrTlBQ9AELQxgfw8jeKOqUzqKB6nFgRba+v0ehG5J3SNzr3z5TFc6p43LA85RRsZQ2BQBaNGZ7eHSc763meCTv6/l3FTd9edbOuy/mRHIB+4KPR4hfru1349K1muTq1rl4YpFBM9RCuVUcWuULmUr25gidamnB8W9ElA7mMQW0jtMHP1K7EPkmAjNJ8uXZoytVdTBmj5fXwySw+XPtmaDD/bgraSelV2TH3IWMTMMmv9fjU7kSjqfL+SjRHVkoZId/CDisLSd/PQfAgtorPPKcbseFdkhkqJiqUJgTLlEZWAPN4jfp9vRsOT77Dp82neQFptnUTDKpyaVTjZFqAXuPQIUy9fCRyaQk986WQ6eS/XnOPhTq1zRtk1MYI8M6DqHCTJlyG0CjbuX6vtiB0G5Wk7iGkKH+Jp5AJ590+4nIe+QuyaMgl7ZNzEn36U+QQIplYIjOBx3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199015)(6486002)(4326008)(6666004)(316002)(478600001)(107886003)(66946007)(2616005)(66476007)(8676002)(66556008)(1076003)(5660300002)(2906002)(6506007)(186003)(41300700001)(8936002)(6512007)(36756003)(26005)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qUlp8ewhpgF1BjW0jLrXIpGeMa0FnGmsCdSalfU0Y1TUaY1hFJLYdE307QsX?=
 =?us-ascii?Q?nXsxMdKdI5sTyyITnf230QBnASgfaWrJ2o3dEd9+SU6Z3qLypoEb45oQxKzU?=
 =?us-ascii?Q?EDPpcl0qf3znK0HnD1MtMexYKiEVP7Nh7nqwjcYXdO3KxpFgrjmYryDJEYu/?=
 =?us-ascii?Q?ZyAnAMaVleTxOPpY98hHyBZNtNW7k/6nw4e+1twBNQAjwNz0G7b2RZowrA26?=
 =?us-ascii?Q?UBnBefy0R4VNgprXntXTeK9s41YEmnId2ioqLWB8FCzIPlzzJdA8z+DdcS5i?=
 =?us-ascii?Q?1c3vicM8VODcbemCaG9XcQC0hwTJ8tbrThLk9oZOy5jPH104msllemQss9CE?=
 =?us-ascii?Q?S3trkJWc5TD6As4KZN6pcLcn6AePsf422CnLMBA60JfGdaOjhp67eBZND93y?=
 =?us-ascii?Q?T3mDaWfYftUYjzTVIlAqRuSceF6xc2wT/X1/YMSgWSIKE3B7bkR4HnrRfxXa?=
 =?us-ascii?Q?CK5jldUN9DFwp04mln6GU97ZKarP8KosCVBfTNiKgw5K54Gr/1PQVu7uH7xL?=
 =?us-ascii?Q?IcQGZr4g5HLzpDXIhCxviwwnShxVMHtAH3hdCdZBlSGBwy83MQOfaQsNmaXx?=
 =?us-ascii?Q?MMKKWWlbxWK398Vjd2VzZoZzeGcgMvckM+9rIDkP9GdhlUZ3rR+ec+PV1LNO?=
 =?us-ascii?Q?IgXAjv84v3HdYe+cS8upA9EDq2qfEXScQPrfohXzO2vYZcCojvYZ+b5JsZNY?=
 =?us-ascii?Q?TaDFq3fCqY8WgaQvhd4hd+g7tVrQmdC7zfccKx8Lf6IY6Mg6bJ0Jv7Ddckdr?=
 =?us-ascii?Q?Hopw6OI1KEff7PDnEOk9Mfj3RKSRFNRIATrTsZ+NwYIGlXYgpXq+dfHLYe7/?=
 =?us-ascii?Q?coyHOdC7nsE3DrDzpiV4A6LJdk6D09KlMpKXFlCs8uti7zz/7xfVsIEHdSex?=
 =?us-ascii?Q?2yu/dTejEoqgCGZq6RztzjfWckdEhrx5CnoAxjrTrl/HuJ6c9F2NozbqIw/+?=
 =?us-ascii?Q?wPHnZjMrRZ0SYvAS/96bF8GF7eYv7/nIkoc18YpjeefHfCALR8dZwjoJaHtN?=
 =?us-ascii?Q?nBaOCfN9NA8ZbrdeICDX8WAwev64eRUtoIPxufhH+NMgb+Bl55mAzeWv+Plp?=
 =?us-ascii?Q?Rg73s/Ok43Vt3h3uKF+CuRxHzEJm5z/1l5R5Sok50uvH49WzeSeLvaRyD9+4?=
 =?us-ascii?Q?/iHvG7GMpqO8A6GbQJgNdu1iW+/ru6RDeHhfkhyGUc22swdxyGSb6X6I4uTn?=
 =?us-ascii?Q?QGK6Usmc7T4liSt40ZH30oL2N8/EY4YfkQVTsDiEmyYqe2KLkoddOSWK2ycz?=
 =?us-ascii?Q?tT1RPWEtEfKlmU+Zet5EA/QKp0JK7SpgMANpTV/ttl5xneGZJvVl+4LxaPlo?=
 =?us-ascii?Q?lv2aHZXESUdnahfCspeE41ZJWSE8IGITNb44DDz2YAZzqs8Pd6c0oycV1hXG?=
 =?us-ascii?Q?g5TJMcBwltp13cAd4tLyGPywD9qUFDw/RYi5SRgAjorciqS/D7YDOu0dtmlB?=
 =?us-ascii?Q?2CsZxFf/ky/OYYjQ3kOyNmAADAXkMDetRmswTiAX7OrHxX8lxxNmH0gcM6xa?=
 =?us-ascii?Q?ZePLNnSsL09vEdvt3FjwpVuTZLlGjTHLTXQjeI47QDqfgF3pF6AGnMyU6fZC?=
 =?us-ascii?Q?a1oyTEcFbQTbbWwZHS6A3J+RaQwg3gBZyc5bITajBpDc1F+OfdNOYep/P9dt?=
 =?us-ascii?Q?yA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a5af23a-fa51-45e0-12c9-08daafb119c1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:40.3596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: roBzlpO7kUTS2QCmxBStfulSTUlhdUwHhWIOfKDFrtXBVDttJpyPZz433QnlDF+ZAOXBPkb+1KqsnvIbYv2iXp1BEGGcPIHzw5ZoMr/it7E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4603
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: LyTGSApaXzTLnBoKuDy4JNV2Ojj7NpJB
X-Proofpoint-GUID: LyTGSApaXzTLnBoKuDy4JNV2Ojj7NpJB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has sd_sync_cache have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 690884efce8f..c0c29b948476 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1580,11 +1580,19 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 
 static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 {
-	int retries, res;
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout
 		* SD_FLUSH_TIMEOUT_MULTIPLIER;
 	struct scsi_sense_hdr my_sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.allowed = 3,
+			.result = SCMD_FAILURE_ANY,
+		},
+		{},
+	};
+	static const u8 cmd[10] = { SYNCHRONIZE_CACHE };
+	int res;
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
@@ -1593,26 +1601,18 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 	if (!sshdr)
 		sshdr = &my_sshdr;
 
-	for (retries = 3; retries > 0; --retries) {
-		unsigned char cmd[10] = { 0 };
-
-		cmd[0] = SYNCHRONIZE_CACHE;
-		/*
-		 * Leave the rest of the command zero to indicate
-		 * flush everything.
-		 */
-		res = scsi_exec_req(((struct scsi_exec_args) {
-					.sdev = sdp,
-					.cmd = cmd,
-					.data_dir = DMA_NONE,
-					.sshdr = sshdr,
-					.timeout = timeout,
-					.retries = sdkp->max_retries,
-					.req_flags = RQF_PM }));
-		if (res == 0)
-			break;
-	}
-
+	/*
+	 * Leave the rest of the command zero to indicate flush everything.
+	 */
+	res = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdp,
+				.cmd = cmd,
+				.data_dir = DMA_NONE,
+				.sshdr = sshdr,
+				.timeout = timeout,
+				.retries = sdkp->max_retries,
+				.req_flags = RQF_PM,
+				.failures = failures }));
 	if (res) {
 		sd_print_result(sdkp, "Synchronize Cache(10) failed", res);
 
-- 
2.25.1

