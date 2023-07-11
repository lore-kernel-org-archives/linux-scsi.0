Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEAECC0015E
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbjGKVrm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbjGKVrU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:47:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E2D1981
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:47:19 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BID1Mv015322;
        Tue, 11 Jul 2023 21:47:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=pHKNtgIUFHVEtc/4QuNyz0PNa7BvaEIkSWnhqHDsyRg=;
 b=mtHqHvw8Rtrrv/ecEBngnVXgixLmuQ4XSfUsHla/qw3C0rXOuEpqZpMrawhSSCVHDn/Y
 hEo+kLTLFMTcOHWMtX/LFPhbRAGXd0PQg6LjfW3CB1Eq3Iu1PVuiTPzwDZnyxzWIVqbC
 0Y5Visi4Xbr9qv+f/uJ/BdCqgIErJOeCxWah0YgkFLuBpU3Qq4r3lvhXNUi9sJmASfct
 wC4ypHs3b5RbGDXwUBeHrJATNmOpthzopSxfP29+JnPf5cqNMJtddjKFkWdrFbOh/weY
 9+XghlCqVpD6n7vIffdrIXUhR6f9K5Wthq2Gj34MXJ08DiCuVExEIo3canr/DaM/25Sn 2g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rr8xumf22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:47:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BJxGbF007247;
        Tue, 11 Jul 2023 21:47:09 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx85h1d7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:47:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khJrHT/h559GjB+jBwOkwJdYrYfgT08WlyVxLQaQvu4kMw/qkO+O94iY0EnD6D/x5SJGyol479u/PP7qRVL9Q66fLYUVq8fqhcwbuOp9jaQBZqY+w06FtYusfL55kcebQMg6riCkmKVWCjIYAxgFXoXzR1uD4rG9l69yEYrcGlYLWK5nAWXK7lKOBwuIJliAxQCGlLcWjt3W/sUiKZQczeNzeOR5lesqTdPNqtDcYYmbCJUBE0MFQF+hsDHJaeBXzI7q9+ZnAQBZCvqdB2fYeJ+ocnP971nMRhO1uDgGnS0MxKKYPgORjkFgtObJ72dOiqnYJcstGoD2BglwHUEREA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pHKNtgIUFHVEtc/4QuNyz0PNa7BvaEIkSWnhqHDsyRg=;
 b=Wpfk4gM8esWEmR4Be2sRKO0xv3wI2BMFD28JEJyMmGWoiLcq5oqenjfnULsSuGtOpkpf4fpEDw/Zescb3pyOJlYkC5zECMi3a35HCLnG7PqOoUfuMWStpZQ2IUtTs1G9dGSp9DUCf/h0Iw2M007XZlLDpXVLbGIcNsiUx0oJtMVUZpLO7kmNG8ih9NbaQBDxK3qZZs9iEYdARtJHWtQE4PndQqWtsu2n3+kIU/FFRq3B6FgF16GkLwKmW8RFnDuKqBKrmoicoNvdsxdl6rSqMDJlwJ1zv0sxBQQQg8KZTveQS3azN5tDOl5aIbM8Fu+0M6rbuHxyyDyaPQ/MT+1FsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pHKNtgIUFHVEtc/4QuNyz0PNa7BvaEIkSWnhqHDsyRg=;
 b=cTtnpHy+eXtckG7xI+IiHmhegpCku3wR/xXm8CRDYeoFPjlKn34rCS9LcmKSRPwz3Eu8o3ceKRY0bPesj3+z7QtssK5f7R+IyvzZBpm/Tvivz3mLzKQyxpzZJYN5NPotu2bFGMqD4a77dBS1AG2Jm+I3bMe0ui0juaEuJt1M5qk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA3PR10MB6950.namprd10.prod.outlook.com (2603:10b6:806:31d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Tue, 11 Jul
 2023 21:47:02 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:47:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 18/33] scsi: sd: Have scsi-ml retry sd_sync_cache errors
Date:   Tue, 11 Jul 2023 16:46:05 -0500
Message-Id: <20230711214620.87232-19-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::10) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA3PR10MB6950:EE_
X-MS-Office365-Filtering-Correlation-Id: e60c40f8-cef8-4283-ebc5-08db82585bf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b9kJVlYjb69uqTfghsUvcBQHYWWMHRHLWOVmsApt8xMVREUp4NOEbp8/4rJZL/MTj9qBO6RWV8Eba7CeYHqxsPbMBMTbakq+3NMA8NCyjVvteeekWEEs+i3uV1njdmDd4eqKM1X86i4MY0yriSK854xBRdAXDOKOP//jEr1a+YfUyGTi1IeDsiOg5pYTE2t+jlFkY79gns7Z0arMVPpYQ50DneRrXICwolBAmvR74lWcr9t0g6DZtyG4zcBeolnFmTxq7wGjOllH+FriD9+TjmKyJgevWwR/o+yoJdl53/Ht4762RXG/rwdDPGhxpcVkA92dYFaoBPsGMXbaydKZCP0hRG0j47ygIti3VGGFGc1JYBTjjUzMuy+ve/EBNsBbZAkUD8VmC3WAwSWh25bZ/6dGLgoFOQ2Dn0oA6VIAZwaSmcA94YzEZcgalnzl24pjw2Th+5oqYURjns+oF8D+l2aVNLks7Qjxjz/vNZ2TgBF5uKPjDNePjQj67hwqAyr4+4r+WoTnHh0mg8q+zfpnOV8NI6/HQdvMQPJOyh9Mc28TVQqwYA6NjZitadD+2MXu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(396003)(346002)(366004)(376002)(451199021)(186003)(6506007)(2616005)(6512007)(478600001)(26005)(1076003)(107886003)(83380400001)(41300700001)(4326008)(5660300002)(66556008)(2906002)(316002)(8676002)(8936002)(66946007)(66476007)(6486002)(36756003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kMDynyxkbGbvYDw+Y0JSrMN+lYjds+nnheY+i3/JOUBMUnqKZR1EQj3R8Dkd?=
 =?us-ascii?Q?FCe2r54GWv7xy0ePahpXsqOqIs3OdyRr2WMknGD0zGSvOX8C7tEoft+65koo?=
 =?us-ascii?Q?a2xH9XcqkqikvJH5QuODT+4dDE4ew/jwvFjBYWwUPg5y4DLxz/8KrRPMbL72?=
 =?us-ascii?Q?42xOiigxHllsUNuFkdb0xsOnhnQaLyxoixjRORq4zwQm7o8NlryrUpb+euSV?=
 =?us-ascii?Q?hAO6pV9dxii0mRL9rUfEyebLVte+J608OfFkQ+/gXYVq+Dw1woyhvqatVSGf?=
 =?us-ascii?Q?XiBwWD0EzrkdxzUstQ3X0hu9oo++eJ08szDVWFkjMleo1ntXjUxoKNCW2jTQ?=
 =?us-ascii?Q?tTHVsUHYEQRor/V3hG2MTFF69Nth7+L4P+jCbr0t1W+lyEZkpiVTNqWn6Lk2?=
 =?us-ascii?Q?cD2qa3JNv8/giwu0aeoFzK2TS31His95y1gh+YIN7lUuL67rPUerhHpPgnmm?=
 =?us-ascii?Q?Ezd132rJuapab+d7NyxjsZgXrLq+fQykdnx5g2VMEhZDpifOSbo1psDJQd61?=
 =?us-ascii?Q?SsAgcG0lsvgK27d6x9ohx0/ENg3r1dhnPVGvvcxJAgXjwnWi3VHSIFIkCevy?=
 =?us-ascii?Q?7kC1rwHpl9+ortBOHynVa9qhcOLFJigqJyW2AGpUL/R/bq8UW5U3fyNZArT8?=
 =?us-ascii?Q?0JWW+RFvexCVQ9xzSxPJeqPGozBJJZKOKNYi8ngjnWV1x+u2S0WZ7kkHTouI?=
 =?us-ascii?Q?+shs7Pjzsaa/0t9Dn1i7uf72zalIc8bdT++t0AKW8u4VHZ+k+Vf6mwks1wF8?=
 =?us-ascii?Q?5cv7+NPmJxiGo9yK/pUZWT8Lw5nxoZPZxTe+tPibg5Q3B02ROxbKFzfU/ThP?=
 =?us-ascii?Q?b6LGie4L++XRBTTDYFJQQoOYTNt2I4XuwGVE47PvHo6sGVB0YTCb5JKjkihh?=
 =?us-ascii?Q?zAQWaoItTIOOf+0eAnXlfz1Jniy5RV0obwu/NZf8eQNqVPfOPEgegGCFQJiK?=
 =?us-ascii?Q?LnaxVvf/Ce2QtW/NnaXCgKSx/IN9XgsENu9om9EnmpiwbZkPQzV6M+X927Wx?=
 =?us-ascii?Q?CviXcjQf5xPqp3pRsSwmMD9yPEHFmdj9xmOlK5/bmMv3+So1R1TWdUs5O6QV?=
 =?us-ascii?Q?lqTycgxeK//WV006VpilOH0HBAJyJNKlgKBWXLwLzmhX7bAXpZxqQDU7UvVi?=
 =?us-ascii?Q?wlWRqw9+CoOUHfHNoXnwPw8K2a1xywUHyjNXBwT0zBKANuAph2NWNxiGmVAv?=
 =?us-ascii?Q?VKLrAfxYidJLyUCIB4RIFW32EXb8cXnXrVZ5v2QALA+YXKDBjEeANNwerIxg?=
 =?us-ascii?Q?9Y4VjSkwR454JMcHWk8mI9nkqNM7AB5tm6o2ta/8EPY+5R8JWf6kud5ezBwF?=
 =?us-ascii?Q?RB+UX7dF8Zmn3FX8NQkv2V9nkoNN0dUyTpaCKmITInnUK4V6Yu7sB+S33SD9?=
 =?us-ascii?Q?+RUuJa9rK6+3G1lQgaIKh08Qh9dHTzCjYhyF+4XYgEWqCGEwhAs2iOvPygu3?=
 =?us-ascii?Q?hc89AFbJRIObeOegB53W1oX/VJklYAvnZEGiCj2D2xkSaAUbVD05jrYTxc4/?=
 =?us-ascii?Q?ka0f1utY36qJFtUSfp7UN7sMQfVx4LfaKDUqAKWU7q8zH7S2v0VRUVU1AXvz?=
 =?us-ascii?Q?Odnp4mM+X9zcP7u2Vgr3Pwrliz/Liec9DgQMdEdw/lcM0JtH9otQBgj/mWVb?=
 =?us-ascii?Q?2A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: V2ZQbSDjPl7tvpOVZvSIt+DJRTEk01FLXfjW2frLBHp6Zrl0SbkxbxSly+SJJE3AZAOXjcZ10foTNmmqVRF2xH09AsHEaundR/y4Gd7fMlu8aG+GFSHK6VSDw52CM8HjlMT8cXJblshKfHzcNXGjiu1wYWGulOZapkuCWqZ8CG9YZ/5owif+bwZgLIKVa3AQOUMhysidO5PBvAN/iLFxQ9VAYk/5Xrngvo9S6tGHVRkQZ3CJ9v+uxPybPysM7G5fAvYfDNtxy/o8Xrv4dY84o7B4s0Oqk4tqIzoY3svUGki0dJf9dAl81PHO0YI+ciYjdY33GFFe5zl1KjJI/aDJp+9XzfATZTcANwQ0wfB4/TFiD+Fj2z8sV1tUi7F6vUS5Ix3mlAeK3VfamhNZx69xIXEdTKmkl3X3L0MEqp6HGpOrAh2QUGd6iD6G6ZshYW3PgjgfSwdxJ6jt+LB/HNaVWLyG1FWkemtjveenxfReHocIkhiCIuFKhNxQI6vx0DruCuEH/eGugED7z2u3eauEcoC2mPtTd46Vl7UZ7+NtsTiNMd8Fmmvx2cVRHKovq7P6XP+VCAy9KPvgPcWemq9f0vQD4AdhpI7+JniA0MCYmDA1BqaaYO1PX09500TX6waZH8X5ibGGYvM55SfNXOQeDVMUdxj+b1bHGSgw7pcME5JEhkRv/+rwTJMNH6OYA60MoqCfZfDAhFvuh5yiJSxboi1S5UZrMjuDBWxFMh9A5xgim2K5I1PAQhj9fgPZOE2kBOF+6DPVqgjrDZJL3j4FVSnM+/cgLjh4oRpsxaLxJ+AP90xFJVHpvbxY9hzoM4X8heV3X0x5knbNvb54XLSqH/3Y/S34HFZHcdiyoE+JvTMLA5zqXhztF4mXl2lsNP76
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e60c40f8-cef8-4283-ebc5-08db82585bf9
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:47:02.2089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zKhf4D0HVO66K2wpD2p7FsHpBy0yNlxR6kDjtWDnM0P6GFtA2+Kz5t2JFR6gXJuVyG1maV8OQozMN0JbaWHgr9SE5ZDY/ingnl44L8/r+lU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB6950
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110198
X-Proofpoint-GUID: RVmV5a_h4axNhS_4_9JomeOy3lEFuwCr
X-Proofpoint-ORIG-GUID: RVmV5a_h4axNhS_4_9JomeOy3lEFuwCr
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
---
 drivers/scsi/sd.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bb2e5885e41b..ab0d6b1835be 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1606,36 +1606,32 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 
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
+		{},
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

