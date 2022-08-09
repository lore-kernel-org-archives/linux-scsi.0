Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9593C00140
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 00:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243624AbiHIAGx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Aug 2022 20:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244528AbiHIAGu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2022 20:06:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F92E1A04A;
        Mon,  8 Aug 2022 17:06:49 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278NweGG020677;
        Tue, 9 Aug 2022 00:04:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=6kiFhLvS3tqR+lK154i3bxe/bjUaJVEduKlRC3meOyo=;
 b=gjNRoGVEOxulytmX+SIvh2t2oBFv/N1lc6WH1OCyQcq4XNe1gnLvBDoUsbdrdKTLIYdk
 EEc8zskI52/78t63DPr0KxY6wxs2uq+pNdvHhxquKlPbNJAjLg5Y4XHzT4qRmn0oZiDJ
 xv19Er1SvQvkCqc40nyPhqa/Un2jq7CexDuiNaPZuAFOBKO/4OMn17jBrgMUrFIMRHXi
 QjogbVLd6GtN/mPNStQ3wQptyrYOU122XFpZ5NOYK9WZD2qQ9ICV1btiZSODR//bgkdh
 N9RahIPktt/joNajzAA4thp1eFDpLnUgQ+PTalKlBVj6e3JbrUNFiM9OV4U8BvkR6LGp 9w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsgut53a4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:36 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 278M0h90013949;
        Tue, 9 Aug 2022 00:04:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hser8emfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9Q/yiNcCIJPUiAesMM86J7JadTbPwEHRgYTjwfrMkIDg2OnZ5+Y3JX39cVvVhMtNN3q1nnbq3LKxMEZKDno55g5tSEQol8yzTYS071CX5YZtnK9/RZ+jTmOCbjORKh/lTvbKxUoqhzMvx8/LTB91y5Z3H+yY7LB06ZyMMxllCjjC3usJw207Bf2hPAOp73iCKDHnNlm7X5UXQy5lB1OM+Bmgi5UJaasYUu3W5WXq5OJiV8eZWRufM9U5VE4g4PYkR2anPFYZJYqshADImz7SyQLgqUY/tJ26KAc4UwPcTedRZqMgUNEVxcyvFiBWBb5lPjIbobvKR/05KDj11nImg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6kiFhLvS3tqR+lK154i3bxe/bjUaJVEduKlRC3meOyo=;
 b=m20ofc9IvGYAkTmA7bUdRO9jbBsvJyWcrIzUZW7z0QGYScKrGr688bHnmZd8VtgAN87Bu1hAN390LGVAZZXqBBop4u+qWrAXf2v2G1JZ0YlAw6OWqt0u5fw4J2/V0a4LRyWzh+GQLI3mK7FnjwN1oR9VxK6FmjGygmNwq1Kwp4tUMm2CSnnwi8lGIXF8Mzffn9d1vlZY1nUGlN3rrapKnQr9AffjUiM3DjlXy0VgZcF4/YxvHMeK5BKLZYcsowUBzVjK7Ir+PXurkqSTU2QiOTvJA4v6TElWrhjnl6Rk9J5VH0R21XT8UMhRJce50H53lR10BNwbEi01YQmtS3LRIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6kiFhLvS3tqR+lK154i3bxe/bjUaJVEduKlRC3meOyo=;
 b=GVfGrbUBJbKxjJuw6KW87ve9zgcnajqeOAFwJKTPNtcag/cdVbTMn3Kej91+/+Rg0XIP8u6sjjwCc0ZkltWx1M0AM2uOhjJKSnyk1V+n7l+AqJ6qi49A3fw8ZKPfOXQkGv5Lvs8wmomwnMvdjLjAAon5uf2u2bIxprtSuQboC8Q=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN6PR10MB2590.namprd10.prod.outlook.com (2603:10b6:805:45::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:33 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:33 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        hch@lst.de, linux-nvme@lists.infradead.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 08/20] nvme: Add helper to convert to a pr_ops PR type
Date:   Mon,  8 Aug 2022 19:04:07 -0500
Message-Id: <20220809000419.10674-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0187.namprd03.prod.outlook.com
 (2603:10b6:610:e4::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d056eec4-709b-45c3-a8c4-08da799abd3c
X-MS-TrafficTypeDiagnostic: SN6PR10MB2590:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6gK8004ju5ayGXYBsD9z74FRAKm2tYkS2cCC1KEzTn/CkBJ6p7vn9oC77hOEvQ8QgV1H2rzSN8dsuffqn3sHQc1n+RpJlPBRUnmzfFnYknxrDX0p3yW1qeE1S1Njf7is+98yKCzxqLCGQMLuuXMbilhDzy2hF882/LBdKCU3budcLR/dPmdCDXOX6VGJKHB4AyC5bZx4n9VLJ2uMNeh2RPPzFMm67LmwLJJOaigL0buKamImKrM9S7bCTKTuhlurS0NntNRfVRjs4pwuGwa+unmHfnfWxPs6O/gjntqHE2YYfJp8KOhEqPJ6NZR72b8RtuNm/RZQJeGa/WwuV1yLRmNr6rUIsuqxSw2LN5AWLFmhS/j/C0bImSSiNANdhiKAvgBzZAdgr46a0+5vbZh3ryR12pJTKGDVUjLPMgUwe1Tt4wSuAljS7qWgbyBTC2swPbLdDYBmL0SbPhlLfRCMDL1fcsc8/oTXYxSGVG7gt+GkL/gR5cmYlwFcAcxPWlXEdnOo6tAO4GOR3CCzQeG8Xhq051DTgTsOQRBpjFKFkI/z3QEOLZhFeXj1J9iBEkpln4PwfaHRWR6on+o8ji/oCnLXf+oBSMDZ/AKNr2oT1Pz5JgFa7wD6mwS81kxZOHT9iBCFL+8mal681cKHtYPgiyeZlHeQX4tqirqyIF5IXCKQOjWJN/h5gmWxW700M55lxb9ZtCwBmpza4mlaUQA+WaUQGSfGaz26gIxYoH55yPTfuTNe4sGBiHtF/nL98Yf89tuznagcArKI+MUJ3AfaZadVze6UTjWSHyw41m5Jlzc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(39860400002)(366004)(136003)(376002)(2906002)(83380400001)(6512007)(26005)(6506007)(186003)(1076003)(2616005)(36756003)(107886003)(38100700002)(86362001)(921005)(66476007)(6486002)(316002)(4326008)(6666004)(8936002)(66556008)(66946007)(8676002)(478600001)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Votud9S0PXyelVsKXD4y4LZ7XV1DONTI58JrlOC+/mxEkHpiK5hSZAmhBlDj?=
 =?us-ascii?Q?Hpw/O6+nzFhAXkwpAiH4ERlkQgAClrjDTsgVhpmphr8cdhXZhImT4zVykb2T?=
 =?us-ascii?Q?ZzG1jVp5yeLfJgQQtAm9nFtu91Mq4WCJ3JteRCxl5WarxvNTdO3Qvet0rMLz?=
 =?us-ascii?Q?ZqOG5jYaHBiB4F3hdvcSiWd+9Nr1BO7EyAL4yGfBq5+SaRWUbMgFoMpp4mp8?=
 =?us-ascii?Q?rIRtfCVyjhnKefYsjJfxgicO/R2CkXWcXvZmENRhmSsl9gNflpfF4pscuBzk?=
 =?us-ascii?Q?Rha+NTJMtBnGudBI9ZuxaN9orzNHgo7uOrL/XWM33m9XyzRW9tiSq0lvuQ8u?=
 =?us-ascii?Q?Yx7YDRBn7qKTUZJozwpbcWj/RhlT4J+YAazNwM25Srb1R0K+kbpVTcKN61fH?=
 =?us-ascii?Q?gnta9D/QAHWAOkirNiOnBEmfxCeB3vc3mrYAvy6JUFHwrd2vmNj4FmedacX0?=
 =?us-ascii?Q?yZs5ax++/hMhNLWsJK4cvi3m+dS6zSg5FlsctS/T8J1GFhbinfLjeIqH7uIp?=
 =?us-ascii?Q?18bzEyz9RDEbm3SpzT+8EGoiEiJB6vbvqV1qBduJGVFoR85P/935Ox64a5UH?=
 =?us-ascii?Q?GvF7wj2rV9EUOipI1z67cN8jQupBVOzfP8IoGHHcresFPG3NaFR9fKYW2tKo?=
 =?us-ascii?Q?JgqgG2rsc0+sheBxzJx4yFWSObcvHR6Jg4JiBlmPKGfsGZRQXPLpVV29POG0?=
 =?us-ascii?Q?o9NgfyIHj25+cRVodP46OlxZ86mOQAU3YXGNVLRNzs2XSqunnT+re2bT+Q31?=
 =?us-ascii?Q?3xgUqFIWDUzHhkNFSOAfLnjddi4cMb/i3vdkSQN88TJL2e4QHxZoorpg/iA0?=
 =?us-ascii?Q?LpJJ1ZA0JG2c9n0DyV0wJH3Pei8nKEHORcyOG6+JOaOO0lhZgyN/y+uhsq7r?=
 =?us-ascii?Q?8Rhq0yqqQ68LGqSHe4M0q727u5OZu6Qs2LkDdGHtjq1y8x1lN70BJsuMTD25?=
 =?us-ascii?Q?JJQj/2AVMVzkFVEBd1+EqOggkJrfSueZ9Tl24N4mG1LA9qWrpyYeG8NWLa9q?=
 =?us-ascii?Q?ZoDllb9tIqr1FDX7X5X2WVQvxrz2pYxzrxLx4ci1ti2FnEX1lQxnJepFB94E?=
 =?us-ascii?Q?f33HhwTFqoTTeQIZ7Vkz5XuQKEEpn5I9r+P4kJBbJo7ayUTDamE0M1WRE93W?=
 =?us-ascii?Q?Xb+x3KMRe+Ed3Xf8Tyk0IQcz+7Q+5Z0BLoros6jUPI/nxVScA+56ZliAAFi/?=
 =?us-ascii?Q?afNINVGTIHQoUTaFsxXRY9xGEgq/s/C86j0vLoP9WTtmupDSgm8ckvPdXJqV?=
 =?us-ascii?Q?VhAddElfERII92sTbGCxwPUeVWmwd5GjEoy+i3SBNBigOx0J/fyFoXQx1K7t?=
 =?us-ascii?Q?Pvhruf2nnqodHrxioU0+yv4GcTdfT7yRz9Q0K6CvF569Zm6yt41OmA7XA+vZ?=
 =?us-ascii?Q?48ivxnLy9dkjvLUG7yf5aXF7kvwPqwutro85Ejh8ZEPMeIGVuy8T7jQ1Kn/f?=
 =?us-ascii?Q?W/xFsPRjYMZouFs59dPtXxS6FozK3UaOOIl72kpEUAHflsEJrtEBvewRyucf?=
 =?us-ascii?Q?UwuI9jzBWqfXcUvfKKqy0cp2465YobyRkabjkKG6CatYklohA6vVzeko53Uh?=
 =?us-ascii?Q?EhFYMwjyMPMu2BPHM1aRQWD/UqJ5LY/GCmKMVXmIWvVfWoIddzh0qtRvegI6?=
 =?us-ascii?Q?LA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d056eec4-709b-45c3-a8c4-08da799abd3c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:33.5015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +hTokK0iXqj83/0h83VxSnTTY7GClIqGHV7X2PXB7CInEaDSRmIXeuXGTReuGixGqxbjstvO+wq8BJFkUzRmTTsdZZKTdzd2TANnxO0Ga6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: GYO9T0WwwwTr_637bGbSW-W4N6RMW1Yd
X-Proofpoint-GUID: GYO9T0WwwwTr_637bGbSW-W4N6RMW1Yd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds a helper to go from the NVMe spec PR type value to the block
layer pr_type, so for Reservation Report support we can convert from its
value.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/host/core.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 3f223641f321..0dc768ae0c16 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2064,6 +2064,26 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_ns_info *info)
 	}
 }
 
+static enum pr_type block_pr_type(u8 nvme_type)
+{
+	switch (nvme_type) {
+	case 1:
+		return PR_WRITE_EXCLUSIVE;
+	case 2:
+		return PR_EXCLUSIVE_ACCESS;
+	case 3:
+		return PR_WRITE_EXCLUSIVE_REG_ONLY;
+	case 4:
+		return PR_EXCLUSIVE_ACCESS_REG_ONLY;
+	case 5:
+		return PR_WRITE_EXCLUSIVE_ALL_REGS;
+	case 6:
+		return PR_EXCLUSIVE_ACCESS_ALL_REGS;
+	default:
+		return 0;
+	}
+}
+
 static char nvme_pr_type(enum pr_type type)
 {
 	switch (type) {
-- 
2.18.2

