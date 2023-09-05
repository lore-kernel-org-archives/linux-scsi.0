Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69DBBCCF9E2
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242166AbjIEXV3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbjIEXVZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:21:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F1AB0
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:21:21 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385KnmDk009395;
        Tue, 5 Sep 2023 23:21:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=MBtUJ6Vg/raKLNep8lIYlMHaGAUCM1BhLTT7ygXBe00=;
 b=SYkwZIhq/u98XPAn5aP4pVXOp/upBr/0aOJLyng0O/M3uFCdKzbaTHoMwHLCcu7MBwPp
 k/f7TcyCxP25pAyXtInKZROuIJg3i5ifQHXTVkJ977yh+IDuzUF3/ngeIeAIun7K+CzJ
 CNXzrvJJ8e+LTSiv+4Ja5z8cJ1yIllRC9HAXRC+/MUgCD7W6FnGYj1BhVea9x6A5sSWA
 HaZIBEuRs2eg5RQrgc/6b1+fbV19uarfUlGaRy9CDF6f6Q8UvUVbg15DY3F0NQin5Vdd
 Ajg+A8OozKd38vkAIFi7s2fDSlJz3qBQbX6AyCGoHpSHZ0oFnwJFqJ/E8XG5QeJOOqEA Sw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxbq389bu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:21:12 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385M44fv037052;
        Tue, 5 Sep 2023 23:16:27 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suugbpct3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8GBa/kxOWvTk5IopVOPjULLgwli0VQmgi5l5LGL7YqF8syOEYJc6Opo6D8tFvhBov/hel8m4cVbBZIUZVaye8IPmJQsW8aNoZW3wKkjzpBKwQoHBOeCuRmtgicDL+h65HOQWZJTxxPTCdVzQsu6Qb6TjR3j2rNqVrKYTxJBaids3oJHcJqc4aoX+SMfYxGrU6goIhBQk+Y5WzLmL/+5aI5NQBWMEYkL6KsPZFWqN4TleXj4isMrNhtBmCE1t9e6pXibvOeUYjWlHAnjTm6oRTAcoO/Hm8SVps9PMDRHeuYr+s5ZA4KdWAA7XN4etkE142Eks/V4j0/NgsJ+yQaq8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MBtUJ6Vg/raKLNep8lIYlMHaGAUCM1BhLTT7ygXBe00=;
 b=XJouLChoS4/4ELP/7qQU2Ry/VBs0DyVB5QY2oqHr+srbrfUU621WPPAr0f5vuGpwxYFnGRMvkP8l8BT9zJ359WvYRTNonWyszkingA8hZj/PM2fp4AfgLtbxb7cuYfILhoO1WQLMYMw62ZcR87ocskJwsrRlsDcHQynVCNaFV+fF04s6fVFD8jqj5j9EUITXg0e70ryI7SkNkg2luT2Jiqs+wgw2iZoCGZok0YOrFHsraMCyZRiMIvC8aQGF5HLvE3xx7QFamF+KU8OkDGfY/wx9ljhO/fowgxE9C9I0MVXaZ2uHedMMCMmjA176i7y+Yle8FOYf+sJv8voVrv0PmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MBtUJ6Vg/raKLNep8lIYlMHaGAUCM1BhLTT7ygXBe00=;
 b=rjnkLqvsng79nkgN01Xu2Wcp1XMNQmQLKdnNZYL1c5QkM017hiMWSGURw4sw1dK8a2KbruRcrSP2fKGECHOlDJeOXfzjr72jIyWtVpPRoaeE7GXNcXz2LrcF+lfeFe78OTIRxndLO5o9FpV9AwYpjaXPWyWLvmAzktBdXGc2AeE=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6109.namprd10.prod.outlook.com (2603:10b6:8:b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:16:25 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:16:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 19/34] scsi: sd: Have scsi-ml retry sd_sync_cache errors
Date:   Tue,  5 Sep 2023 18:15:32 -0500
Message-Id: <20230905231547.83945-20-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0029.namprd08.prod.outlook.com
 (2603:10b6:5:80::42) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 25d76134-0065-4448-fa92-08dbae662039
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tPSGQK62rPCXO6cKA4gjXxAsPgsiGtA3Z+ldyUyprBaT8TmqMxrxoSQMBb0XdBN99zANN6j/dFLKxBfhG6+1OLqHGaKTJ22xY9dVGkCnj6L/9F7sij8YOzca4lYsV05IbydBuKgBTMZV4BMWBhcP6w7M63olg9Zos5Cq3H+WYGaI4/YH6ZM8Ni9stQ3xnwfqpolzPLWmVkMTn66DemEc65ZOeThqeXBKpvPlSYfNajpQYvARL6UK2Tzne2f8aUy9xhkEKqJNyp6+BUcyeY2ShZGVCujc883rD7C5RS6tD+rfeXAoDAwYnMZW2oFiPt5S+rc6JOLWSX2olyhyCO9Ok/KJtSF6Dq+8f3kPXbyZwkJUNT9qphp6BQ5H+vhIVwczFPBHVNC5Em2V+xvdGXPpjJg40qv1bweM/QaDW+om9Qngv8J9mM0E/t21PzY4nOcLlX4vU/78ijxX4Hugt1nNHFBzZ1AE0kI8rMq5T03J4hbY1+VE6RtepyeFFqrlXM1N9SGhINQ+a9OEzhhOgdFBe37Adyf8WewS46FM47EhjyUyJiL/KjQL0h5RVUBkzbic
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(136003)(346002)(186009)(451199024)(1800799009)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(316002)(66476007)(107886003)(66946007)(66556008)(8936002)(4326008)(8676002)(1076003)(2616005)(478600001)(6666004)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e79WF/LdDVYhsdyXZvnql6LNxtT4qSSM3gfwwFP+OoGgiuPq86uOjd0+ESUz?=
 =?us-ascii?Q?y1tDDwMUZA2aXYLW3ZQzhwXlF0IpEr7+MEL1EUZIaBQ1HHtgUvbVx3IVeqH1?=
 =?us-ascii?Q?O6BnYky1noGFMFlMuQY2YX/zN8Er9oSGrKGS4gpcrd71ryysselySJV9C0NV?=
 =?us-ascii?Q?PCUq1TWQiYtO62Uq8QYc8MHXieuFTCXKIcWG6dXEBxkpviTVQNMLiOQelYaE?=
 =?us-ascii?Q?G1tmnvDCIPNwUWhdPwhk943gNVMvWdDonaSW2dE5BlRHIjufciET78i7F/GA?=
 =?us-ascii?Q?xEIiNpegXYfbd4Y02Wg09EEggXcYoiKl0ZmuCJJtlWpY5JnZ4HWevVcRAlju?=
 =?us-ascii?Q?g2Ao24Bvdt6rnFNQfAKsZ7otCvXNqgSCkYRlSESjtFnkA+tJ6gvu8oc6KSBv?=
 =?us-ascii?Q?xk82z4JtdlvtmlZcpKm6CIIR1GL8pn1GdzXoSYGcigS00tkjqzzmRUmiVrmm?=
 =?us-ascii?Q?zO3pAaXeMng/+4oDvMSoSrIYxmeIf0VZAVo5K31JtRiB9flQMIMkxg7qJXbY?=
 =?us-ascii?Q?1qK8FyQWgYoPmkrp7io4kJy/ucrQG0ARMdd6FOJi63Rxj9Rd/P1ZGAqVFp3P?=
 =?us-ascii?Q?u5UGxmIRCAQXVmsBq75yA6q3+fNTscIeUlbxGoiWIWx8Q9XuD9LVh2Z95p/b?=
 =?us-ascii?Q?K5Yndi0jEiaHiD80Y3eULcC8nx3fvG+hyPMeLl4l50rXwFYnq7M6jUaWSTLX?=
 =?us-ascii?Q?OZTu8dZ6x0hzLYzonzdwXJ64OJDoKbPepBesCkWIobtHK1WX6hdBHD90zli1?=
 =?us-ascii?Q?c+stNhypnq8MLO7QOApBEf55aLPkEOe9vtTDESOug15CwJXoDsCObR6IsO9N?=
 =?us-ascii?Q?uedy4Gdkk7xcVRoc5yV5HhimslJDZ3N9xlLGqEmiM2T+OKZ++dzY6FkusZqr?=
 =?us-ascii?Q?iBgqeL8lEpg4b7JlMHbN8cpkc17Efd7B0q3fkG1twgB0cmK4n/R6orAA0aVC?=
 =?us-ascii?Q?V4++cAna09xWLJEhgkZzN3D9oEDSbj2nuQWIkBVlROolj4OuqfQtIvycVASn?=
 =?us-ascii?Q?es8OShoHFsvtlpVYC45LeU51ECUUm2ei5igmiIpAp9QrX/1oIk6vxLxuOK2X?=
 =?us-ascii?Q?EA9hE6HDZY+E431ukhBnsiXZRqVaWlp9UUK3NfkCXd4wKKXrvqrHMQZg/CsP?=
 =?us-ascii?Q?1SwxcyeKMYfenMFdx0I85Yz2cf/IGlOD61hVc8Q4LhpSSMUFNSTdYcB+7mfO?=
 =?us-ascii?Q?upRNWJa4EYkAFb5yyn7gaA4UD24RvUbqiOOXlhx5h27JApDVz12jQssI47Bi?=
 =?us-ascii?Q?E213mjxjY0LhJYAxJ3YbG7roLXjwV/cKp1ivdqa8C5dSjrNPaUj8ze/fGhM+?=
 =?us-ascii?Q?AK4j533saF0zsxTVMlDS5D8XwsMVP8/0CEaNOBbKmHLrwMXYjHS7Bn4yUROg?=
 =?us-ascii?Q?5qWEtPAxN6rxlP4B/ZdoqPZZNoFYR1P9Soc7vz9/qUGnC4M5HuV7/1foO6Bu?=
 =?us-ascii?Q?Z9cUTMhq0GqmrZqsWtm7M+DzDZ7mhPDWmHATSgII8Getc0msXV2gVDCriPEv?=
 =?us-ascii?Q?1H0DzZBFv/TVkAHrNlVxBt486l0eu/pmTVGOIY9i3e1jN7uem/rHaJKwsCFp?=
 =?us-ascii?Q?WA+2BXK6I0DvhQ2eCgmW8Pe/vIcyHul0XqsPwvURz3ONeNLaLlWC39M/HmFh?=
 =?us-ascii?Q?yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: iIpKzppMSmT6HUuRySpwqwWlMO9tz8jIcfVFaU7WQR5Q+NEXjCpGGVD+0iXQRYMYzqUPx5JPjTlktzui3ywcPKb64V4XyLAvplj1DDdSnmYd11j/dyPedBncl96c9Q0JLYX6tbpeTbr3SS6b7I5QB32uYgRlb0/YBH+g/hFnytGGuxCqt71wKKs2mUGpEFKNW5Sk6WNzOsS7ETyTrmMNF0rZ9ZagIvyXpSvTN6hP5jr5UYwENFrrQdtFci9L2cnxz84J8vB/44KirHuE6N9vzmjBOu45IGIu2WfxsaAQJvLSb0I6M0sCsJqTZB0dHD7+YXfdon60HZa3cF2rUSxjTUIz8PoBp1wOLja/9I8a0s+akNm3KJ6GVkADeFx+QGjTH/LPmS27xZUNngpdKhE+e0sJSU2ngJj9tQmpGLPsUkUfzDaI5rdXeLEkZbB8fwGIX+FdD6/aDirl99S8DbARJdGiM+IudS4nOH8dhkSfrE3oPwsSl2M9zNJCZxsyEQM/7p5Vhn7e3p8Bhd03oA1qf2/Ty48PI0jCYNAZCPmcU9cR/lWBlhod4S/LbDBrUu0aGShQ4sjt/AE7Lkr9wSPzvWJQCF0OoDilXNHWLrC1PCZ6Ak9800ziC4RXYUtqy/lhxUWLodn16yUuDr3L8czVpWxrsLjmIPgAqmw/NGvi/Kn+Qx5R8mH0qsPKavGssMkdGRfYeYIWUwPesFATTtoCS9MYDau/Airaer55hghPgYTpttYUb8fYZOdx9rP+OPsLVECTC/LqQdVsEUbnKwbGc97DYLzdeg8Q/28jrJFaChbTqI0iG7mYkiez7boFPAaxk/o6np8Z9o+ZQ7WrmjAffThqSpj7xnwmT2NRBuDZzUwgOiGPL+H43qCT1ZCpQ2lf
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25d76134-0065-4448-fa92-08dbae662039
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:25.4786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 79BoyWW3xyoOqRJ2EcnHQhuM/4uAlkfKeAj0eyAkBFCEWfHAcebDwXSnmQveeY4raqDX1gukJSvBBa5kg84F4+5yhecW7St67bumbN3KbZM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: GqtbbSm7eK32tM7Aspue4WYQr2Tu8lb9
X-Proofpoint-ORIG-GUID: GqtbbSm7eK32tM7Aspue4WYQr2Tu8lb9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has sd_sync_cache have scsi-ml retry errors instead of driving them
itself.

There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs the block layer waits/retries for us. For possible memory
allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
will probably not help.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1f6cc24d633b..8efd5d8e46e8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1566,36 +1566,32 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 
 static int sd_sync_cache(struct scsi_disk *sdkp)
 {
-	int retries, res;
+	int res;
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout
 		* SD_FLUSH_TIMEOUT_MULTIPLIER;
+	/* Leave the rest of the command zero to indicate flush everything. */
+	const unsigned char cmd[16] = { sdp->use_16_for_sync ?
+				SYNCHRONIZE_CACHE_16 : SYNCHRONIZE_CACHE };
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.allowed = 3,
+			.result = SCMD_FAILURE_RESULT_ANY,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
 		.req_flags = BLK_MQ_REQ_PM,
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	for (retries = 3; retries > 0; --retries) {
-		unsigned char cmd[16] = { 0 };
-
-		if (sdp->use_16_for_sync)
-			cmd[0] = SYNCHRONIZE_CACHE_16;
-		else
-			cmd[0] = SYNCHRONIZE_CACHE;
-		/*
-		 * Leave the rest of the command zero to indicate
-		 * flush everything.
-		 */
-		res = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0,
-				       timeout, sdkp->max_retries, &exec_args);
-		if (res == 0)
-			break;
-	}
-
+	res = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0, timeout,
+			       sdkp->max_retries, &exec_args);
 	if (res) {
 		sd_print_result(sdkp, "Synchronize Cache(10) failed", res);
 
-- 
2.34.1

