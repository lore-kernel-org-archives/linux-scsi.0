Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B8AC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 01:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbjKNBjd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbjKNBj1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 20:39:27 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD30ED43
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 17:39:24 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADNsVo5001324;
        Tue, 14 Nov 2023 01:38:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=vDyZOEPFNJG203eTO6b9kBU68tc5qR8NV//MQ+okcKI=;
 b=EcCl1pnciWHGEPjOlQ6l2YUI6pA61fUKhv/ZNCs58Li+9dz5tbhPvT0OBK/I8DCKiqvK
 bh3qanmwbhnpGhZWm6AUD24LWWSNbXwgwwb96o2KZdqskoVUWQq2DDRs0xIcT86H/7sy
 aMxnZtE88SJlppnWuSa3v8CdJV+GXwFUX8KFrYfjTk24CMyEPetzYnRDkoahxNqySZwf
 Dma3ddTKcNUt1+2LuNm72dzp8P/5x9JVXHajkbnP/sZOzvKtug7Ld9xO+otagPsuNI5R
 XFkO52bjdSMk19tPmNCzi7OGh1hPbIhBQo9/tY3djsLMDLoHty1EDZV0wHJAXPlwkPJ0 Fg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2qd44ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:02 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE1Mr5A029859;
        Tue, 14 Nov 2023 01:38:01 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxqqsc5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6nTwnjSKcPoPkp3a+Eon2msYhSxcmWCH8tQ7C+d9LQ7/7SHLQSc2eLLKJ4UeJqTS+DKOkrQL4Pmx1+NFttFMFooW3cfSgNE06wm4X/naRlnSUc1w0s0axG9EFCxNAYjqoRT+or5DJgrnFsjhN50iuwYQ90tiSK4R1nwNsAnc++6B/Kv4Wli1lnS3+n0Y+PKpPY4NuAwhkWgxga5WoLg+sDDOnh/Z935UqafKNsbnCxIF1doI4njiZHOXX7ws3nE8Za1egvzPboRnHNTgmChcpH6PL32RZsrLpDjlYaVSrhI7d/90ZHAMgNiBO63ya0RFQFnw+XLeyh5nCeO+eKArw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vDyZOEPFNJG203eTO6b9kBU68tc5qR8NV//MQ+okcKI=;
 b=SoZs/7QWQsCAC2q4TcT9lCHGVzeFe8t0QNn9FNTgmALnNp1v2RfkmF86eKr5sd6GIzBCUCxY8kclrOOFvZKMBVQqyuf2EmFH/m1+jrw2t8frLP4INbHQFAr+n5y+GQgIAi6NgjqoNdb4Q259VS26odcg0opkgbf6iuWRYwhJPN4Cm7AoSRGcRL0YJlAUeE0bgSoQ+afbnui3jQu8vAkGAqir/T83z4OuwTTSWcV8pc36qnqcRXlrnikZp2+upEOe/U0bAnpWyx/DgUyT8B4FU/o/gMj6tAbhEVZ4xEUjbrvrDudduoDP+NzdMSOzji3lBrT4EzUAkLoZwo6baxfkWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vDyZOEPFNJG203eTO6b9kBU68tc5qR8NV//MQ+okcKI=;
 b=qMaI6c5YQjph/sZWV1zbo1n9GjkFLIt8gHfoDqjlVtOTEFIeHsHjBRT6FJpKfqk5Ba8Z4WjqX6cO326LtsqeXHDd84sSzEjtDfNwBt88Pa7FHuCY73qCmVeRlk4sniTFZ05fb48Glv1a+1o3/StJnODlZ3bW6mmCJStwmV7/Apc=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4199.namprd10.prod.outlook.com (2603:10b6:610:7f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 01:38:00 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 01:38:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v12 06/20] scsi: Have scsi-ml retry sd_spinup_disk errors
Date:   Mon, 13 Nov 2023 19:37:36 -0600
Message-Id: <20231114013750.76609-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114013750.76609-1-michael.christie@oracle.com>
References: <20231114013750.76609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0115.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::30) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4199:EE_
X-MS-Office365-Filtering-Correlation-Id: 854d11f4-0ca5-4116-723e-08dbe4b25609
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZbJLoGjM1PQczjfn01+8kvYwPk8ug/4SZcBd5PJ3ADc4gonlwprGH1VIf3PkXD8JU4hYcBsiZdAZWgOH4PkI0DqVWijS8oUA6cuvwmwleHqCbZWc/NTeOGLLR0TugvU+qT6NC7kwz3zoPvtxl1EsC+vzNmwe6gO/7psJDzIjxIhsbRGh6iT6SpVszH3BLMnE3jW/1BHTE8cA3Pb9S+Jokhj3MtgaXLPVFxEchvdHPXCvLOrZO0nz/Ck7Xn/Xhyhez9UuxejNoqgMVcTPUTVy/UQh/4uY2cp9EsBaNDP0eKZNQep/VgCHowwZZ34NcCpqedZDI2rQ9IcPLJFadleeOiJ283s7ZggZSJLKzNuogbozMc/7tRTgq6Gi3cMD1eI9xKvJl/AW6yKY4ahEqZKUD+Cv3+dDhXM81YQcMkhGUlQ0wF9dX5KM7K2hEhRsLuBg5A8ffsnusIGc9jZpjWMos2ep5gBeTIPJWzHD7AUovPFLSAsr5N9zbaqAbXmCFysP0Jp1LRuo9LiuLpzGPo4IZ/jsUxN210gNSQR80qnrIgspVLCnQjACFyCnKRn0ytMj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(83380400001)(107886003)(1076003)(2616005)(26005)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6666004)(8676002)(8936002)(4326008)(6486002)(478600001)(6506007)(66476007)(66946007)(66556008)(316002)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ne5ezoJ7q7pO1PLfSRhd7l5pfQacY4uTgX6PKoaV/ewGRMLmSeHizv5UL4xy?=
 =?us-ascii?Q?9RR9AQ3oDvxbbduxjAzDSeGayYMCyawVsoi99iDXIN2vQOR34Pbp+T3T685y?=
 =?us-ascii?Q?KwsG0/z5vBQ173x0p8UiilgOJBPe7GF950BsI8aw42zxBPe6wrB5Ij5GGlHD?=
 =?us-ascii?Q?h27hakx0HkkDuKIY6JbJ6Zr1/NxiELDQMX4wD2Omma/G4Byo31PNH78/SVWn?=
 =?us-ascii?Q?18RwlzFqYYEGs8N5dTT0th5hosfmEuW/jB4l2x9UtK0DPqcUlsU2LtMnRXMe?=
 =?us-ascii?Q?OJHt6kCGOi/57vS32dyFOPQseZpdSUXySqNjYNgaFcWXFOeJ9Vx71RwnQwi2?=
 =?us-ascii?Q?lAC1DgjmvId5T6aHiL4LE6Ty1se/wDf5x/nH4ro9yfrWItCPg8TJY401hoaJ?=
 =?us-ascii?Q?ZjCDdzSbFhielJ9w3x6pJ7v7+7qR5rk39uZmkwFXpMNpntVH9VQHD0Fh57DJ?=
 =?us-ascii?Q?O87q78YMaqJ+/uPtqIhJ8OCoorIqdMMFhZ0chNqRVxuoeymme3t6RK2SCZCw?=
 =?us-ascii?Q?ZFdjfLtVNtYYRsQnDFAZPDGeDT2Dss/1peGEuP88vigN5IDuSVM/+dIjabOP?=
 =?us-ascii?Q?bwTPRhYr4BLW4xl4x1FaUeOTiftnIvROfg35vf1ANvmNF3fduhvIAyurQ+5D?=
 =?us-ascii?Q?0yQOigbfexp415gxDvIHVe6YYg2GCR5GM1eqnkhOaHDxyBRnX9Hg1VdZ/1zw?=
 =?us-ascii?Q?BQFzkNVYqabXOwHIbYV09g9jx6tWUh/PjIMP3lTF826RGLaLC074Hqz3xgEw?=
 =?us-ascii?Q?L0jQa5OlFQxsFao7+LXXc+laSznA/EQFKPz38J3JRNCwn1uOzfKe3d+nYdwk?=
 =?us-ascii?Q?jER+Yfsb9e11SFKBzS+xkLvBj0eLdeFTSXJDwI82xMv2AS6mNh6O1ARunVlO?=
 =?us-ascii?Q?HC8tney2h9BpU1g2ocM8X8z71Xvt4WCuxgyKqETQQ3XPoBKnc810Hxi+knM9?=
 =?us-ascii?Q?qCkqZnl3zhkS0A+z4AQRs/sX20J8/we13p7dHkN6JwqDp1S4/B1ODP0wsuHE?=
 =?us-ascii?Q?MnTl+m8Mmp2gyjAjyjKKIkQMwToH79lklNZuAk8X8PGyTgf5uuzxcOoATJoh?=
 =?us-ascii?Q?TNbBVCsUPVQ8/kgI9+51a3u5G3BMH/0KEKupyCgANqmo5cFGjnK/uMxs7l7N?=
 =?us-ascii?Q?27d8QAmwXBpTro4ke5emeoyNaPZ5r4yOjeygDCekvHRF8UarMBEXwgz2jeZ5?=
 =?us-ascii?Q?4pude6imIJVT4lEdJHJdYjpFwqqn1VN2ikyrCIZlqIwvpbCmo0SGCvbF33HU?=
 =?us-ascii?Q?O7W+76NtWZ4QOTfWdleGup0xEAcUeQ21j/3ELaDxgmz1F/yC/SQS8EQWcOCZ?=
 =?us-ascii?Q?XE/Lv4lruzQVRZXuDw5kI8XPVZzGnn6E7VMSBoW1B2t9HjJWkiMfMY8KXa/4?=
 =?us-ascii?Q?wY6cQuH/lbIa8oUBzXia0XoyEUo/gJcdlefKKQzEFQjnYf32xMhyFpjruLi3?=
 =?us-ascii?Q?ggO2BejTY7DOylgU6hDQ4DqxVnp3XJghcirjFVWbpC0J2Z6hO0OiUO439Li+?=
 =?us-ascii?Q?At6W6/8lZuduevJTRSvSG9bwGriWNMZEXVHEUct5C0uQxTpwns7lBVspH+w6?=
 =?us-ascii?Q?UtcrZgOuQfb0KrmsSSBaodBx0dbciGE2jt7Cr67l+vt/YecP9fHAFzoLhZyr?=
 =?us-ascii?Q?hA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lM/SvAMkBWEVlSTPSCXnii/o8NuSS7DJ6VkFnAoxiCSzSlBqKihf1rGjqrtIcmuIuB6jG94OysTY5gAEUSRSNH+dthRPiKBeBZalvNYoVt3C1LUfmbx8ZvI+lmeLuf3fJtXvMuwjsjly820yNiAjeolnpRN81+fFVjZcYiZ0ymwBz0FQVXQpMOHmJIstM9ts/c94405Z3O9CcQ+pK1E9tjG2W8Ve0BY81nSx8qIUmnaWPXvLNGnvLaF5gPEhA9hzGOashDD0b1UKJ1iVLBrN8/4/B5ol2EWN79wp6NstGGJ9G62LSavWxidRaoYkKb7WcHmsRT7JW6OcushrRVIbDP+cLuuTQbfgN+JVtWxlgTdv8vRYpXa9Dmkin5j+hPK8AG0lS8PVnDEhFY66ufX0WKkRLhp3YT5xjjHLOn0fjSJtnIHQ1r7VRcwKSZUR8UdIFm8ab6bQL2S2AVLdHjbsUt95YTGUnHNavCYwWPLayXbvzGQGVjlCniXx4RDA7kxSooYFMsTYKlilkzT6yTTjQTL16ZHECAq9S9h508xzp56TrAp7nKMwqLmSbqnTdxGzNvu16QVIkCs5uFBsRbbJgkHt9twsFfsIDAkdoTq/n1RptSSgl8J8XCB3KySUTgiTJ7KpihzuWprT37KdKm905MRzGSWTcvOvQneslxI/i7DQP1MSNdqWp8VI2ozdCNCvpzsZLK19WRM6IdXlnMsVbypD2J4sNyzBvEn7SjMOVUfz2124P0f3eJ3N2ExJGakyl62lfTgtv7YNA/SokdLa5hsMnAgcqDtJeUc0lRbZmzKIjzvGuuQ0iH8sC2CFFf2PkiORH4N6EqmraNLFhCWYb6kAvWGuz+Jif5u7HMWcA6GAxPd/uZ+6rXkN3QdnHX+s
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 854d11f4-0ca5-4116-723e-08dbe4b25609
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 01:38:00.3031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I9yoRVf6O5oYwmWRSVC8uPbniY3kFy+eOoOYLa+BwPxyAp2Z6PdPrJSwl+h6aX0aK+ZqNFmnjysZfLFZI6idaFuoP2GIK8/3sut5xq5ZETo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_01,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311140010
X-Proofpoint-ORIG-GUID: 1uUySfgNnvr421a58yafnG4v7GyPHzyn
X-Proofpoint-GUID: 1uUySfgNnvr421a58yafnG4v7GyPHzyn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This simplifies sd_spinup_disk so scsi-ml retries errors for it. Note that
we retried specifically on a UA and also if scsi_status_is_good returned
failed which would happen for all check conditions. In this patch we use
SCMD_FAILURE_STAT_ANY which will trigger for the same conditions as
when scsi_status_is_good returns false and there is status. This will
cover all CCs including UAs so there is no explicit failures arrary entry
for UAs.

There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs the block layer waits/retries for us. For possible memory
allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
will probably not help.

We do not handle the outside loop's retries because we want to sleep
between tries and we don't support that yet.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 77 +++++++++++++++++++++++++++--------------------
 1 file changed, 45 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 641f9c9c0674..cda0d029ab7f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2235,55 +2235,68 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 static void
 sd_spinup_disk(struct scsi_disk *sdkp)
 {
-	unsigned char cmd[10];
+	static const u8 cmd[10] = { TEST_UNIT_READY };
 	unsigned long spintime_expire = 0;
-	int retries, spintime;
+	int spintime, sense_valid = 0;
 	unsigned int the_result;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failure_defs[] = {
+		/* Do not retry Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x3A,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Retry when scsi_status_is_good would return false 3 times */
+		{
+			.result = SCMD_FAILURE_STAT_ANY,
+			.allowed = 3,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = &failures,
 	};
-	int sense_valid = 0;
 
 	spintime = 0;
 
 	/* Spin up drives, as required.  Only do this at boot time */
 	/* Spinup needs to be done for module loads too. */
 	do {
-		retries = 0;
+		bool media_was_present = sdkp->media_present;
 
-		do {
-			bool media_was_present = sdkp->media_present;
+		scsi_reset_failures(&failures);
 
-			cmd[0] = TEST_UNIT_READY;
-			memset((void *) &cmd[1], 0, 9);
+		the_result = scsi_execute_cmd(sdkp->device, cmd, REQ_OP_DRV_IN,
+					      NULL, 0, SD_TIMEOUT,
+					      sdkp->max_retries, &exec_args);
 
-			the_result = scsi_execute_cmd(sdkp->device, cmd,
-						      REQ_OP_DRV_IN, NULL, 0,
-						      SD_TIMEOUT,
-						      sdkp->max_retries,
-						      &exec_args);
 
-			if (the_result > 0) {
-				/*
-				 * If the drive has indicated to us that it
-				 * doesn't have any media in it, don't bother
-				 * with any more polling.
-				 */
-				if (media_not_present(sdkp, &sshdr)) {
-					if (media_was_present)
-						sd_printk(KERN_NOTICE, sdkp,
-							  "Media removed, stopped polling\n");
-					return;
-				}
-
-				sense_valid = scsi_sense_valid(&sshdr);
+		if (the_result > 0) {
+			/*
+			 * If the drive has indicated to us that it doesn't
+			 * have any media in it, don't bother with any more
+			 * polling.
+			 */
+			if (media_not_present(sdkp, &sshdr)) {
+				if (media_was_present)
+					sd_printk(KERN_NOTICE, sdkp,
+						  "Media removed, stopped polling\n");
+				return;
 			}
-			retries++;
-		} while (retries < 3 &&
-			 (!scsi_status_is_good(the_result) ||
-			  (scsi_status_is_check_condition(the_result) &&
-			  sense_valid && sshdr.sense_key == UNIT_ATTENTION)));
+			sense_valid = scsi_sense_valid(&sshdr);
+		}
 
 		if (!scsi_status_is_check_condition(the_result)) {
 			/* no sense, TUR either succeeded or failed
-- 
2.34.1

