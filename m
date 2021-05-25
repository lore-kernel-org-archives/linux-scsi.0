Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00514C2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 17:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD0D461186
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 17:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbhEYRtZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 13:49:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49786 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbhEYRtX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 13:49:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PHi3a7085059;
        Tue, 25 May 2021 17:47:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=40r5UXMjjGCU3jrDH6dCXBSaWNHwdXwynqwaEpEbwh0=;
 b=ehCzQimBdpKKhRWZRfvHy/6+AXjoT2sucxuVEMoFCbTHdDxlMdBT30W7H9N7pZTRnjZI
 8KNa92zzDEHubrR3LewgFp0l4pyYSupcW6HCvI+Sx+M2d8rF0LFzSlgRLgdu1uODWEkL
 RMO68Szz2Jsy7DLAhngsnZtH5THTUI5AB1bL4uMhjcqcAYOB1Yt3Zfa132WaZjNenNb0
 68xv/Jluu3+E5GwjI+dC+K4eiPNa97qXDz4IjiIa8Vaj2ya6cYqvS1Ke938eYybBGofF
 rsFhfBIpaUf8iFJYDaV3pWU5EfXOTQy18huaz+mJwB50mhnLFthRu9cdEjTILiPbPxGD og== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 38q3q8xaku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 17:47:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PHe47t042965;
        Tue, 25 May 2021 17:47:44 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by aserp3030.oracle.com with ESMTP id 38pr0c0mdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 17:47:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aeO/7VLAFcHdtIlASk9ypAVWd5hF+4BEoT2Gb0vzfzMF0nc0kutR5ZEVZ/Je9qdzVFNKWsPW5A1Mz+2w6A7TxZ/WLyC1jlQUuUCu1jJ+3FMhs3ypqyBqNh5SD5duQfOSoatNAZaH6mpJFmKm4MHvS8PtqOxPuP3sRtAsfF/mIy1YSHFzPcNgOt7S/amvfaDOvbeqj8DC9bmJ12uyPgIq9UZ0EAJ5ygsVRrhimncYvwrH8sXyVCvSHqkyl+suUStITV6nvqpd5kPFVlBG4H8T/LOsIJ7GD3eH/xSrwltqce0a+6uoTxoPbPtBu2syNBaEqsF2jLR0onHVyxVqDuw+UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=40r5UXMjjGCU3jrDH6dCXBSaWNHwdXwynqwaEpEbwh0=;
 b=EvZ5zkwQH7sJb/cEzfl7H10ydFvRTTktVco3EOkvp05s5JrEODZFfeonW0tOgDzN3JbttM5baw2AlBG4+6etluFyMJCqjg6S3GYCHxZklo4uEDAy7GY/9cPl5Ggi9Fgzanz8Pm25E2nzJYaKFBnA/iWHlqZClSXJA3FqzYkuRWrl4foMI0MWYvVwKi1I/19A5AycLhO2tC2+7VPSLi5bIRNEskIpj2nUgUdnd2z0dv3p5Ag5oZZSchq4HLUiusHZVvXz0MxgDqJ+jqncv/x+vueFFjubuT6SIVN9TW9WK0oTdz1iWH//KpQt5iwfetJhal3FbQv6h0jusk+wrjpZgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=40r5UXMjjGCU3jrDH6dCXBSaWNHwdXwynqwaEpEbwh0=;
 b=Bn6gHZ+AFgDhU3Uo05f40XWu0/GHW8gP83Df+tbuBU2Jt012ICuIuPXb9B/Yu+YwM+FIsAexmm2oVvSzyYC/85dI10uEbbaYU6mxqIgEO9kNj6tvuvFh8JwqdJ9gGdNfDIcoPpcMO1cvpeY0SMgxF16BjS+xoLw2zL7/RGgIlhs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4720.namprd10.prod.outlook.com (2603:10b6:a03:2d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Tue, 25 May
 2021 17:47:43 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 17:47:43 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: vhost: coding style and flush cleanups
Date:   Tue, 25 May 2021 12:47:28 -0500
Message-Id: <20210525174733.6212-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR19CA0009.namprd19.prod.outlook.com
 (2603:10b6:3:151::19) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR19CA0009.namprd19.prod.outlook.com (2603:10b6:3:151::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Tue, 25 May 2021 17:47:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b580eca-5003-4194-c326-08d91fa53275
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4720:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4720883BF9B416A62D67A01CF1259@SJ0PR10MB4720.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CzASSXBs6mKpMI4llL7uPwoy5aEmasx9nPUqhW/xIH0zo3iS9d+nnM4DULXPbQeOBG0VwQoRDPuBtHGW5XgcS82gX/R8T7HBPR5IHps9q4v0xsKhacy6DFZUa4/PEG8Dki8HYFyQz0XT3m8lwqzDzSTyy7ln1OYRX9PDGja6huF2QW2umEyhNZW9ywQ/0aDxDycdrB/LNhrsDJNLG0lRpuNok1ir/YueMkXjHQL5u7X9+FzHmClc50xKyeuhgx2mGl+qxowZMm0nZdZkLwK8BcdlbtXMKBvfXrip1NTyrQVK5HZ0nrfIGzZ4o9iCdey5wKcF6gX1Axna85/f8lAWW0kQeUeXhKGiGC/l40Zi76MoWxsQL1z6HmrC9yTR/YC0CGiZC1jC7l8E4+2MX3Pf0sJVYCo2yGY5XBR1Iydoef6H3vuFzmWoeQqdeKQwXIYvxT2Cp1/vx8z51+RswZRKJg8fkNsvExxsAQAd0MPrcw72pSMllJdEupVmA5Alf6avFwhIiicHwA8FqIM49Iw9kLPfbDBxy8goV9msKIrfFfreg/Uu9vjjGmHiK2addWJlh1E4OaH5QaKyiWLtZY9/dcec/Jt99EFdZY/v4WJgK3w77GmWrhPAfmKBihVJGZpwJj6QEOGRccVfAQo98+9uOK9Rdu9CL0QOGWyTHu7Wr13SplHgQ+nZTgF63QFMOpp9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(366004)(346002)(396003)(36756003)(6512007)(38100700002)(52116002)(26005)(66476007)(478600001)(38350700002)(86362001)(66946007)(5660300002)(66556008)(316002)(8676002)(2906002)(6506007)(1076003)(4744005)(8936002)(16526019)(186003)(6486002)(6666004)(2616005)(956004)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EBli6rGM2QdYYNQVBttS902v0LT0IvdDLJY/BqLubdi2d5ZieSbi8iZruaAZ?=
 =?us-ascii?Q?+d7YGxgjCr2RHqcqa38sALb4v29jej+5rY0ujHUytJ6PwoOdbcusYXdgBSfu?=
 =?us-ascii?Q?oyafNEfmLvE1NR1T4Q90FzhelThitZlN4FpbPUX1Z6ihmpk+HNECSEE6HvxR?=
 =?us-ascii?Q?IcJ5COMemE+52mcRK9oxwry0ovSRCb9dNZktrVS+9mLwCVUjuLijRixrI2gj?=
 =?us-ascii?Q?hSsZUejZCFIsLk5xhuidTqhZY3TXX4XUdXZ1wmvip7tyy75hWEUgBJ4ySKsi?=
 =?us-ascii?Q?uNY5eGhNIpTk1apdDrE9OGLw6m0bIjCKVyUpGtbc47hF6eD52Xqj2XYdZmEJ?=
 =?us-ascii?Q?U3qfzCjGwYrIsUIjcPYxVcTA6bxwwMMj/HLCMSXLWeoaMWDyaBLnBciXxJ3r?=
 =?us-ascii?Q?1Hv//ZpnRTYifLyEtm8SLLjxRzhiJi+lTnpdE4qX6LapLojAjqzTArEvMFpf?=
 =?us-ascii?Q?rcVqucMlA627EiNZNI2cmsOznMx2aHEeJPETYkuo/t/cfoz39xd0zd9Rumt4?=
 =?us-ascii?Q?gPDqIaF2sCtzaga6z69wvHfS9ga08EaaMz1/KPxSi/YAkeelRD5oxzjZybw7?=
 =?us-ascii?Q?b7Zh0CPQOSdWq/TBWamGH5bafqiD6hHj42zHxbQwgdC/xvReu/IhnDQiKjbP?=
 =?us-ascii?Q?Uc/fhZUDleJTqyqqJOPhQM6ekZRFN6gYsIO7gxcTq52RQtZ2fqZp6vpSFqAi?=
 =?us-ascii?Q?yfWnxKMaL60c1aRuBvYLG+QFS4yX6aqwGheCJ8UpbJOaCDOQy1KBOniKJTNy?=
 =?us-ascii?Q?fpFIsdUBdjCLA5BbNFSUOuMREKGEBZp9pmI8EnjdbMeHnKWixzdlENUIbIbX?=
 =?us-ascii?Q?QXoreUC7MUwuxR4Mv2lZMo5r+s/M1xyr9RkPt/YJA/359tk8FMiAIDvg6nzg?=
 =?us-ascii?Q?zEY36uBQ43VOavoK5wx7HoFRpCQSh4bdRvLG4iff7yWP4Qnu45DSFSWvfA7z?=
 =?us-ascii?Q?aBpbzz+xuMDY1dnBFvjLUt/1tYWUc84Pxr2NMdRojcgH+t2GQznGIiBmiMb6?=
 =?us-ascii?Q?Fpgp6i+cPzuP9KILjXOIYMe2imFxTUU6YhxJZbNqGB3W+ZlIZ1124sEpIsog?=
 =?us-ascii?Q?6Ly1Fy5dydwNBesS3YLdFqsHur9eWaTr2wyiYDF1vijZdEDOQyVSDNtOA+wT?=
 =?us-ascii?Q?WEleoGB9NSerbl5YbZBitxvGu7tTQBHNIitjbY9Dvl1NJ/KtfT0l1zExfaef?=
 =?us-ascii?Q?wGsOmwWZPJ9PLw50ak5Nf92Jh1b58sPvg0LA2fjLMI+nlUNzs+u5hQCsre3C?=
 =?us-ascii?Q?hO8tR7MUTljLpV3pJfiIMJ4b2anI+6WVdAYtNJxtyooW0D9GTSpQJ14EdH00?=
 =?us-ascii?Q?KdsUhW5ivlBKLOuLVf9KqQNl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b580eca-5003-4194-c326-08d91fa53275
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 17:47:42.8457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z2MgY3X0hASbT++uyoqf/kqFDoans8KClhX30kTsnq7ywWgw264wt3XlfUX35PcI7rZvL2+PkgE0YIvRsfFF3I9o4u3swO6dVQKiC0INP6o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4720
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=858 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250109
X-Proofpoint-GUID: OAuJmTjLAQeLHKCqWkQKQwEcZpcSBeVr
X-Proofpoint-ORIG-GUID: OAuJmTjLAQeLHKCqWkQKQwEcZpcSBeVr
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1011
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250109
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches apply over linus's tree and mst's vhost branch.
The patches are just some flush cleanups and a patch to reduce flush
calls and some coding style fixups.

My worker threading patches are built over these patches, but they seem
like patches that would be ok even if the threading patches never get
merged, so I've broken them out to make the threading patchset easier to
review.

V2:
- Added vhost_work coding style cleanup patch. The worker threading
patchset modifies that code. I thought I would clean it up since my
patch that added a new field looked weird using different styles.


