Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898FDC43461
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57AEF610A2
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbhDJSk5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 14:40:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41850 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234831AbhDJSkz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 14:40:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIY0V0007846;
        Sat, 10 Apr 2021 18:40:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=vYo4C3opuKKE5Qt3NDdqY+DbOHJfWIVjc2DsL9eT1PE=;
 b=gu/RvQ204itY7cU7AWPWJ57bHBhrubNsDSMVAO9xtuUZ8rEjlUCYGFGQJZRn28t1a3gI
 V24hEmgmtzIr5a2DFJrfeS2ZdVF1qzvMXZ+cynomnwN29grBdl8dWDUFBD9vDOstPvW9
 RN1REkGauk5RYytP1uvNwX7VL5stFCBXpPYrt1MfzyQOYmBjFAA2KrmM5xsIddLdeHzl
 LHU9ZpcxFDAS97w1dboCDGMcbz6Ju8eaqi9Wt//NHHx5+ug6Ejjh4be//C/g7euXhS2s
 s4acQ3IzpChV0WW2q5elutzyk7AiGbEz4o2p48MQPBlU6Uw2rnRmLJogEPWiTVWX5to/ kQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37u4nn8r83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13AIThCQ176756;
        Sat, 10 Apr 2021 18:40:27 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3020.oracle.com with ESMTP id 37u3u1q4cu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 18:40:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lkD9NXyfeh+48GKFsjD3Z9CdyCTtfvPTcLHAQaqBbKHSmwSaTcmI5uF1JjzERcE/kOnKSFTBLbzinVI10U6ZUqtIXgvM1l5AcVQ+AgvnU1gJaRhU6kcqYHNDfS0cHJ4Wt2NfGFnNTdaeLsSf09gFXR9YwvXoh++4jxSlJCIyVp3DctgDCzSQeF5xmDLvWt2KPVX0c2eeMvcvWD7cmDODlQza11wT7KYm6Z9SHg+ApRxp7ujTUM8rxQzeC23m0J/6/wa27UcbNWAlCJ2K993IlaNezYqMyDHCL+zbmSbMtw0fqff2IVNYdVonBIK7dXA6mW8lrLjyESVDvqmbyrgUiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vYo4C3opuKKE5Qt3NDdqY+DbOHJfWIVjc2DsL9eT1PE=;
 b=Xwo0rsuCM/zatmUbMIj0JUQLqhDrCXG1RdEw1qLqdIAFOY0jT5q9LBGR8yoP2RakDo6JZUpnr4SEL6UIWklpgW5Eq/C/K5Ejl4vhmbvgITBS0hzjkW4hcIgbSPBkCnKf8tc1vwu7dSlXUFRrvGYA6k3pqDmeWjBGhpP/gzdCyJsU+rnGYLdZjFLh5r6ifwSSW6SFjbKi11yHHoUAIxbn2sO6JZbdePj0YsjyF9VVm9U7DlkXQ5D3vV/upZhVU2PqdC2K3avVfuRte8FwVHXVjUBGZAsEdF3QUKgR58cHIK5ooOfIqFf11BRmKQTODm4Y9XJVnmUQvwyQguNxckUePQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vYo4C3opuKKE5Qt3NDdqY+DbOHJfWIVjc2DsL9eT1PE=;
 b=fkTGVQQQNyIxJ9zmF4zVL9yunoJ2y6OJirB6+tkFVd8/1clWAeBmG9J8/zcGBJWK73XQH+SykBNSFN9R9jDYgZ5ouEB9dvGDc+RrqFlsUYc0IKVX2BO0G4BjwefZdVRKiFil1gmbiXfTA7IiWDVZ6Pl0qy+puM/iuqRgMc/UEtc=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4324.namprd10.prod.outlook.com (2603:10b6:a03:205::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Sat, 10 Apr
 2021 18:40:25 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sat, 10 Apr 2021
 18:40:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [RFC PATCH 0/13]: qedi tmf fixes
Date:   Sat, 10 Apr 2021 13:40:03 -0500
Message-Id: <20210410184016.21603-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR15CA0036.namprd15.prod.outlook.com
 (2603:10b6:4:4b::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR15CA0036.namprd15.prod.outlook.com (2603:10b6:4:4b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Sat, 10 Apr 2021 18:40:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c580e896-3de1-4c3f-1a29-08d8fc501ad4
X-MS-TrafficTypeDiagnostic: BY5PR10MB4324:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB43244E81D9D08BBE8BB78A00F1729@BY5PR10MB4324.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Ne3rV/Y2ckmi2BoZp10Pyoa89R9ZFP4vqVXpp1zBENNmIzQMBt+LUQ+yb1bBLQC49BCnkVAxb4xDMvLVvZ6sNtwIY0sYZrNnEuE3monqaw0HjcKtZmnNOj+uXdKp6EMvyyf5fGAXvYN5yz8bvWjPKa3371MMGLdcdc6HpxJDjb+HqzGnePOUTFxkQ0EILlce9pUVympu5k623cGsWtANwP/hB9iv7pCxhF7fzpJD8moy15J8sA7O34/+uuE+ydB9S2V9/rqGHMHJikg169FYM8pZKIN1PbQ3Yt5BYYmO1IJnPejfBDSftp7v1AfW0o74NxF8nm/QppJpQ++TLXODe9LqDyI2gtHfkcx3KpsX7KZVCgnllO8M7cA0mqX9eY+VMn9/H2Q2QHjBgEwcI2YEOhnLzIrpolW7wgTqnhkcp5hKSwO/txzWHE//xtonpJheAhFPRJeetLHVKdfoBD1zME4BENL4XJw5usf04UNjL8o0U6Zkbsn2pGs/NUXaS2WRlnRzAMvqxnBxvbbWytP32M3OgqtdgYExS49uH9aoC0Hubnm88ATopPZ+G76IhTjI0blejRxjRtcG/uxg7O3MVb0/CKDVz6AFhApQpVuR+yP5d+7FRe9sXdhoI9wx0PNoz1F9XuO/lAAoLpsvYAsU+M0JlgWy1cXEL4bZ+vjjV/eIWPXscUqEbHzkwhJHObd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(346002)(136003)(66946007)(66556008)(66476007)(69590400012)(6486002)(2616005)(8676002)(8936002)(16526019)(186003)(956004)(38100700002)(38350700002)(316002)(6512007)(1076003)(478600001)(52116002)(4744005)(26005)(6666004)(86362001)(6506007)(5660300002)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+atEhMcOenliWKo0712pibkMM2hB/r6jKEOeiRGqdKpbTEiWD+ooEvK6lTWp?=
 =?us-ascii?Q?PjscgelP9xwn96c38/8IybN693G3ja7OJiPG9yXmrFMn6a4hPWeNk7bGRDUb?=
 =?us-ascii?Q?79VG4mzkAE1GJVEUiMVo9c1msQ/UAgkt6ju3o0WKaNOEFOCjZoeUmjfq0czY?=
 =?us-ascii?Q?Pu1JViJPk0F3JmF4POPy9q40K7JdHhA5pARLDjP33ct2KHt79Zu5rZqSTpI4?=
 =?us-ascii?Q?vnQIBszmDDwXFZMrrolr6ITUeARhywaYzYk6fN3fllWpoNQVYClTn1kj5vYj?=
 =?us-ascii?Q?1dl/ruaTSOdD2xbNuHv+paFPXT1WjAVLLwWVs6HMHD8l1X+giQqacYm9m/AP?=
 =?us-ascii?Q?2NPad8pax3OF4oAecv6eLMXJ2awiv1u2lRMWi/EIfDTj5J8ooip6KuvLNR8D?=
 =?us-ascii?Q?C14RXO9qlr3P9RhffNPF6GbVi7nr/Hg3rFiAkc+5SVozO5K+JuQIh4c9khEk?=
 =?us-ascii?Q?9g0m0KguP52Jy59AYBe6tdOaQS824VMbQLlnFW3aHRzBqSIbarDmLWf8mqTG?=
 =?us-ascii?Q?Ej8CnMKFmP41UVnHz0baS8G8EFMa4SwgevP1dW+RXE4jLLmnBCLWy2VDB83K?=
 =?us-ascii?Q?fk31GwqjrjdlHqDRCgT6Rk4Js9Edgp183MozAbGnL3ZNFFgJEWe7XsvLroiX?=
 =?us-ascii?Q?n6NE8W2cxSEM/iMJVpu6PJ1B6Y1qVGK2h2f3xQR1roX0l/ZD5XKQBjxxrUqv?=
 =?us-ascii?Q?I6KmlMrmwSSQ0n9XR0IDVTSzMxKVe858YYruGN3T0hbq7jTH1JAAcSBsBybz?=
 =?us-ascii?Q?btgDhJ7zpRHtAprIxcwAW0LBP0Cd1ZQSspeMJ+bD3R9tPBbinzS2xd3U1Orf?=
 =?us-ascii?Q?Hz9SFsTH6+ds+GJYY/ZhCRS8H2CM3/zcxoAPAlUfyhSRW6mgZ7WI4O8HswwZ?=
 =?us-ascii?Q?qkt3frORQpEysLQrfKRrO9XGMWaljUy3mnbWlPZL4KQX2yfx0WvrTPXoZd/U?=
 =?us-ascii?Q?HqZnMwbRw7fsYimFcrs/Qc+AlgvaK0gte/WDkycXlWnY7LkD7bRq1+0ILnDC?=
 =?us-ascii?Q?Zc31fcFDFFyGtqdihHbN+4VnnxLGd+fKUshfJ6y6goJh01omX6MCK1rLICCi?=
 =?us-ascii?Q?OF9+pUqEAsBioZaG2gut6RcWD68fn1QRq5TxyOEKraH40WlV23/goXhFYygD?=
 =?us-ascii?Q?6h4P6TLFPUGYYd8fogP+b485ypNA87j4LSteQ7Luz9ZFEa/PhCcqPLXaJrCR?=
 =?us-ascii?Q?ASIr33hbmIurXaeK9TRwF8zLS+TFF9055IsyKTbdNbrEq+aBuq1WNJL6jzC/?=
 =?us-ascii?Q?rdcPbvZtUJOX3pV7xdA88pyzK4BkjrEXNkC3ZdumEyLl4dMI5VyoX0NAeAik?=
 =?us-ascii?Q?Frx3O+23pKjiFowTy9SMnUW/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c580e896-3de1-4c3f-1a29-08d8fc501ad4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2021 18:40:25.2985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1vT9UMQ/DudCbgeuA2DEBB/1lqCrgJphktKKUPuypYr13koakfnsXf0ZlU0x1E20UE/T0aux17+BKCOkVi2MXLKPbtFQQ6tIpB51oihCeV0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4324
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104100140
X-Proofpoint-ORIG-GUID: Pzxgb7jwO_mC9z7aNSfEnJ-Dx3rXzwxu
X-Proofpoint-GUID: Pzxgb7jwO_mC9z7aNSfEnJ-Dx3rXzwxu
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104100140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over Linus's tree fixes a bunch of issues
in qedi's tmf handling.

Manish, I did some tests here. Please test it out and review.

The first patch is maybe just a temp patch, but assume that eventually
those issues will be fixed one way or another. I just reverted it here
to make it easier to test qedi and not worry about if we are hitting
issues in qedi or with that patch.



