Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83C2AC47084
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 17:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A626613D8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 17:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbhEYRt3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 13:49:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44842 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbhEYRt1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 13:49:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PHkV0l039325;
        Tue, 25 May 2021 17:47:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Yupj47dUyQe4DgM7DXI6RyaHsJsJwklL7LzJ3Zj/4ls=;
 b=fKxIfyldJ/8jqJiFlOMKDXguxJvToB1ZGR0zdqmTw2lVAjNv3fMAWm0BfzfLC2cpvh5D
 xvLhbRsBlxaov/HJQLjjWURE/Ca32F9dl6vpHkG+QMu+LvzaGIKdWcbaOCewwkt8ZBVl
 6jzevJRIH8vKzmRnKsvgvKkWwpQDYBIlg+gw1FqOT7VEbL0EpNlUJJlZSi7XrtMGmLiD
 a34Cg/x8dLqx+I77Sr4T6c99vcC25cUkRNsRHYvmTL+N0vWCK2nyE2qUP+l4CqVkuMrw
 RS69a06dCWij96tPaCISXMBmUUtithPL6dDvqTYRNZXc07IOZ1gzvC2dJsarsdltUMCh xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38ptkp6tae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 17:47:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PHeDnL133298;
        Tue, 25 May 2021 17:47:52 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by userp3020.oracle.com with ESMTP id 38qbqsfu7d-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 17:47:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bqSstmIXKHlhBglR6M5Ej20zK6VPEQLNi0zp4fsvuBc9RuUYU4HIizdiQdPea5T710T6B5G6dGUQugZZYX5Pgb/lOm+GF3uFb7l8BT3lKWY1IpOBFh8WFC9qFHb4k1erb995CM/tfjIvxVxIp0xfiexkrdljyBQcJGYzTD0geVXDlUiSKl6bSy4m4W8nMCwy6tpufzZme6oOx6shX3gxhKu/Tn77G5AmQMERKZ3fi+v4Nr+ASjNkSPN3/19X8h1zNH1Lu5EMmW9pfHvBm+Oq5sgRt+R2daABBzERXsLk6GxZ9lyHmdjvI9cdPrjmk7Hm6C3ZmukWzXBDatZiyzdWSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yupj47dUyQe4DgM7DXI6RyaHsJsJwklL7LzJ3Zj/4ls=;
 b=hnbNGCZzniu9oYsSB4aGj3VquVkHNDvl5lf2B/il/z1p2aMkfJ6tymWmww7FEiMKpjrBXOXD+eBE7MctvaKkRSuPFRGlsWvnVZDky1t6IZvQPQ7xzqqiy70FUT8w4nA6Xt3Ua452rSz2oWDrACmM5g2FNLp5nlwx7lDiM9T7TKvVE26MbrTqa/O1yy2x60JD5FfNC0tk6rh0k0ra0piIKUoqj/Pt6Urf4HrPwOAWXSs0YkkVIwXNImDIuTjBwzvMZ0O7800ADJXJPAQthFM36pZXHV/rgslX7ST8gOXZVFVJKJLQ/nRfKbSDn5YCb7P6SvFV+CO5rpmL1nC8QDVkBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yupj47dUyQe4DgM7DXI6RyaHsJsJwklL7LzJ3Zj/4ls=;
 b=YD8vPhZu8KyLVqxZ1haC2bGLjdFAFyAnTgw3oBdX3YhTAy8sKWNyYOyI8sAC1QuvlVWmk9Xwqpwu9ZeOtq/SfAPFfCaImheO3I4AvdgcZ0xNdELeRKkswvSmB336upJSS2KUiz1MiDLHCD3qHfDcc1mVcmnWeZPImA9iBmGV9Ms=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4720.namprd10.prod.outlook.com (2603:10b6:a03:2d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Tue, 25 May
 2021 17:47:48 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 17:47:48 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 5/5] vhost: fix up vhost_work coding style
Date:   Tue, 25 May 2021 12:47:33 -0500
Message-Id: <20210525174733.6212-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525174733.6212-1-michael.christie@oracle.com>
References: <20210525174733.6212-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR19CA0009.namprd19.prod.outlook.com
 (2603:10b6:3:151::19) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR19CA0009.namprd19.prod.outlook.com (2603:10b6:3:151::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Tue, 25 May 2021 17:47:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f9c7160-00c9-446d-dc88-08d91fa535c1
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4720:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4720C47F531735BCB8E1674BF1259@SJ0PR10MB4720.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:462;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AgeQyRpSge++XnTsbj2lqhFsChXKHY6Cr+LKHZesb3koBsf4nTkWQUXfATQ4lnk2wZ9cSV9jPeudRNqIj9ya1e7GMkFIzlnnrqaJKXxd2XmLq8jLU0RiSp1wyDI8K9aDWU/GXuTbrW2qUftWWicwV23VXm9i6fzwpQXbZKLw4/3Uj/xURdXXwQCRq+39jSRn0bJIDEVUl/FwxdeZyLFP2sr6cnGf+HkBWhX9MIXQYNxDbQrtacBIOU2kZQoCuSt9FNWElEOMpL1loAtsMrg+ZcFrVKy9pqNwTnUuQa1EMS49Ha1o3YS2YHLrfQezV+er0rR+4UdeH2XxvjAgO6PQA120crbBxpVCNys1pMaBeSDfvNRG546aSEniWMjJu44PohzNXAeXpWqwnn8yoKkKGXaeT46Xg1cTG6/Iuze0oirPVR8pDhJBMWl/dXDm40HZefXWTmV2UXBdTWyAL9TDz/Ry5ksYG8cxhZ3tehmhMRsbeZue9qd79AvQ9S3VkZWzkr8NpkRIJzbvGrkNgzD4toLqRuRCEQIWyScvgRHBZ2gbWW/oBOzXZDIP9BvhzAkUdPtpWKWauFjIU1Spk6aRBFNtFn4SSWqtLHGRUljZgiAZAhFf/T5Nnm/OhtA7O07CFXW0vHimfWk0XUC7A5Lj3nkuMTycuMsJUX3Sgo4Gz8b8pmPx93vdW6GiFXh7t9Kt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(366004)(346002)(396003)(36756003)(83380400001)(6512007)(107886003)(38100700002)(52116002)(26005)(66476007)(478600001)(38350700002)(86362001)(66946007)(5660300002)(66556008)(316002)(8676002)(2906002)(6506007)(1076003)(4744005)(8936002)(16526019)(186003)(6486002)(4326008)(6666004)(2616005)(956004)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?S9NWkEBFH2l8AFBRe4lICctr3IvjE5HiJ4Q+eONncE2HTHkDrge5CRXWtu5a?=
 =?us-ascii?Q?MQp0QzlzT9Qk23leq+l/Am6a7dRbwl2ilM81d4SM1OR1VVbGrqvE0mrBtOsW?=
 =?us-ascii?Q?pz4cxLNfKrBeJ1AFOr6CVfqD5o2pg5w1QAFqPFasAaTFeV/RiZJOoVYV4rDg?=
 =?us-ascii?Q?fjnaHcaH2XjMHlu7i/881r8MAOoNv/LrWYJynaebfvDJO/HwrZVEhIMxCU2o?=
 =?us-ascii?Q?xuvVS2uJQ4YXTDWeno4Nnnhf9uRbNn9LIOc+qmz6Rirh6nE39m5HAf+5SDnl?=
 =?us-ascii?Q?PqP+1Mqma+dHS+3RcOay0esUYHeFcwGSGHx4IX45XFo5onmX+dKhuulPAYS3?=
 =?us-ascii?Q?+JrTsSq9skWr1dTTTorV/92Supvsk/wADCtI8zQs4GM02fKe6F2+VU20UT6k?=
 =?us-ascii?Q?MkfH27f3xvY3i4h6MV2pI2SIAKZ4hPpfHXzDYglFmtP9hzgsoOMvCCVdbkDV?=
 =?us-ascii?Q?yt/b1oF/sFlaDjiJbo62LpuLHfy5v9FUSKL04DNaoHk0nT/xKk2pZ0IwGmM6?=
 =?us-ascii?Q?3fti7Pf4eU7++09IK+cMn9VKmNmfPLRaxKL8tgtXiWX4QFsMYzvo+uqZHVYZ?=
 =?us-ascii?Q?B0Wq5RDalnbkdi6z8M8KQfA1gIunyEZ3a3xNECmw3F5iy4YJDoe8yRdN+ST5?=
 =?us-ascii?Q?FXpqLNIyR9qklNK61AB6iVlSNYz1JWkdMxt0fTIYx2Yu6/eJlKcsTp25okla?=
 =?us-ascii?Q?QtRjy4/WhmCTDalAv0T39Uvu/5pvG67dHl0z/HJzZOM4lY0fhoXvZP1NfsU8?=
 =?us-ascii?Q?yByNItlyhTZGNe6MTkhKaVtRBW1kEw6bLGrIq4BtK0jcD2KT/0QoOwvmMsga?=
 =?us-ascii?Q?dMSVlMoO3qUFMXoNXt5aDd5XThzEI32idTT7e6F/mB3DQEh+xWzQGvtkaDrq?=
 =?us-ascii?Q?JmC9gfTa3Q5eaIPmSHcKWrGMcpZ8PS106IFeukBqnBD2jv7XuOwpfSTlDk9A?=
 =?us-ascii?Q?C9IKt9S9Z4+W2hU86ZH5s7RNSOWBRIiahxIQbTa9rht3YTWJNt/mUvThvwq+?=
 =?us-ascii?Q?Th4lLJgZEQY2swGcoQKv18KQ5uxxcsupxOg8e4Up/rKghxABlEQNfJ2izjWz?=
 =?us-ascii?Q?uIJG1p68rBQwVICrCmc3N+GBhzUYw3D2gSDDpnjWputOShu8DzSsRq+xffAX?=
 =?us-ascii?Q?6/NPKeeGc2dZiltWheOq4z5iSN0E9rP30nCakwgD2YFEkmlVe+SMtAqG9O55?=
 =?us-ascii?Q?uTPYiW94E0itiLHO1JAEOuRALYv34tdXs9bSI7LpGxqbEQMOt/BPZ3HVJrYL?=
 =?us-ascii?Q?qknybrqk1354DBneQBTM9yT1hSjb6jxR/o5dkFqf15tqRRTbwqT1ExF76+9W?=
 =?us-ascii?Q?3pKOchV/OwycG9LbK72kCIEd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f9c7160-00c9-446d-dc88-08d91fa535c1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 17:47:48.3247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BwbccXqGfpdv2J2Fn2t/KOcf5xWOZWpS+SracGkJ4LnvVaJcHMyVNMR070xzex1L6OQclRcTiIFP1grBmA7tb2jeVdQ1IzI+BcMkeupRMbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4720
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250109
X-Proofpoint-GUID: mxIaxnYotdfpPZ1FrokR4WYTVAsGcoKY
X-Proofpoint-ORIG-GUID: mxIaxnYotdfpPZ1FrokR4WYTVAsGcoKY
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250109
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Switch from a mix of tabs and spaces to just tabs.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 575c8180caad..7d5306d1229d 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -20,9 +20,9 @@ typedef void (*vhost_work_fn_t)(struct vhost_work *work);
 
 #define VHOST_WORK_QUEUED 1
 struct vhost_work {
-	struct llist_node	  node;
-	vhost_work_fn_t		  fn;
-	unsigned long		  flags;
+	struct llist_node	node;
+	vhost_work_fn_t		fn;
+	unsigned long		flags;
 };
 
 /* Poll a file (eventfd or socket) */
-- 
2.25.1

