Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86FD0C47081
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A5E2610A6
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbhEWR7h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 13:59:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38864 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbhEWR7e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHurQL155892;
        Sun, 23 May 2021 17:57:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=ilX5dcSbBylgPZkS5WHSZzC6Y2p79IQNH+ZVqjPKU18=;
 b=IBlFzo8tJZ+qu+85m+bkrfTk8ObiFKo395BSOolyZOwnEcGGS7SN2BebZoaBE1GC8PsS
 BAeyQ3eRN9EfdJaG7EzgLEjmoTTak86L8a/tQLWZK5n2r12eeSkAmBFa7gblENI6dbvt
 DcjXxnehOT1UZckRHxADhHlUmviwczPJmz8PtXnwQnSXkhyROWzBcCMA4oFjYKxsU4GP
 55CZMFkPDKRAPRx7cqgEQtwTvrJu+2aqVDK60AAO43fbBmN3TVThp7q7CpRcYQpxV0yX
 Nrutex8GH6ivGqQcGhp6lm7XCcnM2wTKQQXVuYsTdWTzSAmb/QCZQQLSmH96TmOR0RrR oA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 38pswn9fq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:57:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHucLS161902;
        Sun, 23 May 2021 17:57:59 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by aserp3020.oracle.com with ESMTP id 38pss3qbd3-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:57:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=di7PeG+ZxXwBYgjSPO0Ikm+y1EFHnHAxML5Ta1r0MjyXsq00DNQdNupaqFwVUZDtWMHhcXIn8g94s/6U2g7rxHxy/2HdR19sk4AmByOsghXVvKEm22xjn8jYTwGBTgvWolGCA7drOQYL+Wru5ca51HOBwIm0XfSQ/QJ03/grmp+oCC8NPcz5lxC4FhZu04KCdRIddXojUKQ6MOObyJd9lc+SXM0cWcJvsGAftYqB+k0n5nn4cVlSX+kd116IdQkHOOzReCgl+H3ZTPjljM6ffMF10CNJmyR7qBUW4azlGoeDG9OoK+lEtJsBQ4iBspc4KSPH15s1qs+WRdkx3/iWjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilX5dcSbBylgPZkS5WHSZzC6Y2p79IQNH+ZVqjPKU18=;
 b=Z09k9ggOS6924LEckix800TF1q+HVCmmLaJFP5JNf9QvtWYJljFj9s2ZPY5KbWrPJncT0rpHhxKIVAWLuBp1g1lovoGlJ4FFaWUsvEifljCgy032JWZKNqLeD0+dlEIch93FaPza4VcWizWt8X+maLlZg4PLFtvKw0gXsVrT6LWETIw5CUJkj1N6o5TgsrE7t6dxkez54IM+Jt5OwIZw35E2v+Hz14kcaZSppcywQirLa8Jl1YOOkR5PWYP5BlkvKieUI3GbV1/TDGS4XBR9iItZXbJoC/jsCQHRig3/Xds+9dedtOtiPZ8BB2bBEgBt5WsoIHQFBspwJsdHlcB/cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilX5dcSbBylgPZkS5WHSZzC6Y2p79IQNH+ZVqjPKU18=;
 b=P7cJrNWInUqnWm33XFTxZtjUvxeVCnY6bCiDPxi7gbGXrgHxcQ3A73l3cOI5ySiJFX1jiIFNlPV2Dq29alJ2q+16Wpi8TQGu4RC4I6dGRHDT+l2PGYuyevJxNqEG7aelS2oFezczvNFdWCSnQ++I7r7asH0gt6mdUuI7/aodSUA=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4004.namprd10.prod.outlook.com (2603:10b6:a03:1b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sun, 23 May
 2021 17:57:57 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:57:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 08/28] scsi: iscsi_tcp: Set no linger
Date:   Sun, 23 May 2021 12:57:19 -0500
Message-Id: <20210523175739.360324-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523175739.360324-1-michael.christie@oracle.com>
References: <20210523175739.360324-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:5:40::46) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:57:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5a3cef2-8e6b-44fb-96ab-08d91e144c1f
X-MS-TrafficTypeDiagnostic: BY5PR10MB4004:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB40046BA3F695BB6520E4E6AEF1279@BY5PR10MB4004.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SZut/tO7ch7Z5tDzQ0E3R39xsqyvhu59QNh+zQX+8xn74cWdycp7vdVDKVgGmYPRrK98oMwFnlwHHpULbXenTWnd7AytJw9yWkQM5NQ/SW4tmmW2Slc8VSWa3/0Vpc0EOaFhZJy9mOJFnCQ4CUavSHMd3A97+G3jHXcbW8iV5KqHsAPPAGrsHkFGq2/aeYzG0JJ+13gFaLn0yGGHTp9sbI73A1ZIzqFCiiSpgcrF/aIdIbrpsNEvRtD5NMiIGCvQLEnVUFZhYPcnS0jnwO64DOJiwlB4sP2Qsks8CTiHw9uYQOQwuc6v0JUDVeUCB1ecmH4ojKPmka0pcEPRr4QoBTDYtRvG5iguZRGy0+xqfkmhzarmRDoshgSHEpZziG3dKIExd3K8/T/vDiLyS4lBzPb/XTpvjYS0XDa62uKMlQDcaoCQrJ71xc3uM5l8A4Tv2kDYCGjBOaaXBlvwkM4RQDrO+Sor4OWSt2I10GdIG9QVU4cNwbwixvqa/7HcjxTxUICBG+KSoVrzYvLYiykQd8dQwyYO0E85YmyqR4hwgiJO6vYx5ADnKMPs+ppCEdkf0ypmNZ99oVq2US/rxj5g3w2SdZM0DxWOcRTGmH5RBw14aojgc5/lrF7h1JqdFqzLdpcJeSR6vzenA/LuafhxBSfFjUn3uxQbgiMJMZq2k2UNVUOcJUozrogR7X1W95wl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(39860400002)(346002)(66476007)(66556008)(956004)(2616005)(66946007)(16526019)(478600001)(36756003)(2906002)(83380400001)(86362001)(5660300002)(186003)(6486002)(26005)(4326008)(1076003)(8676002)(6512007)(6666004)(8936002)(38100700002)(38350700002)(6506007)(107886003)(316002)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?k2eH5IJjwaAGedcjyqsVPYITXrmXevXdKWkdHPn7hldzfskEaDB8RXUTeuw7?=
 =?us-ascii?Q?tm2eIw8QXtp03gjwm5op2duKg5ypzlwicHRvfEl7d14F3x3/B8zK4ae3Qofx?=
 =?us-ascii?Q?IIrROHmNH8BVIUNnxUbxBZSgW21nAE6o/YPJxHmOkQ9sSRFhqMLlovx/P3b2?=
 =?us-ascii?Q?F80wZzrsIEYl5LIIcXmcFehEtyWEyK/Lww/Nnw3cjn/3nDZNQQWNkBLqLKCx?=
 =?us-ascii?Q?ZnAn+pV7ZVhs8g9hxkDoLN6LNX0sV5isjgLVCCVR/7LlRzB1c2BQOREhhTmo?=
 =?us-ascii?Q?n94qL5m4h7I+2B5jMmzJBa+dmlE/YhBGBSC6QwR9vfYkJsUcNQMwKMnIXKYe?=
 =?us-ascii?Q?LJmXFitlhjnCMbCB+c7mkvJ/q5I4xDHcjbDDFWg92x7NWcdE/6VjALLKLsxg?=
 =?us-ascii?Q?jUR04e20ZbbJDr+r3C0IiqE0LEEa/QMVr7g5NfjI1J3VbkawY/TNtPEssf7T?=
 =?us-ascii?Q?qLlY+JaJ95JGuSJ2gsgHz4NEuOjWXZ2GBS7mDTJOjrEIY5SnVazmO3zwG5ed?=
 =?us-ascii?Q?x4Dq9zRf1tggYSWnIIwfUJILCyhsfa6R3VB10cqXVMg7upJh9W6UlVGNic2x?=
 =?us-ascii?Q?UkX0HTQXFJY/a3+1A7sYjNrawlboXPTqQ38P2Wz7WjF9wazkZrwnh0pmq8qG?=
 =?us-ascii?Q?W45DRjyvZ9XqYK2wkO63uVavZfyFI3Bm8ou+x/BQyKUTNNHj8RWg23sfcM9b?=
 =?us-ascii?Q?ebjCbhZ8D1hm3xCKCvH9fpuqgZiXzXXJvqng46hpMin55eUeIXhzIk4/FWIG?=
 =?us-ascii?Q?0fL47VaGLMtlFNKw+K1mawLEIZqIFvigUlqP437ktLrOC9BRieGCoiCRx+47?=
 =?us-ascii?Q?wgAsNuwk1wvAegvduBQYTlky6soAe8Ht6p0Zj3OBhEqPm2pnAhEQuUWLjy2R?=
 =?us-ascii?Q?INipj+NDXTMeVnyE9XhbXlm1anGCHQjhwZZF/rLKBMIDcEjCydsxiwm7PavL?=
 =?us-ascii?Q?Sv27UWndnTnwJxffLURD6rd/S2KPvwzVqWioH1HsbW2gdCNMiHFxY/8dD4pM?=
 =?us-ascii?Q?GTIW3euYV+R2iRDqS8+8b0CxbZ57ts5XrcwWx3T2uIllmqrqgIyhw/0XjwQ7?=
 =?us-ascii?Q?GAtAcUYA0trWJl2o1Tko7yc65A7MXGXIG2TYe/DdFpTsySm6OSLlJs370CA7?=
 =?us-ascii?Q?6eWTvO2iZrE8ENZ9MDUDAeR7+2Wi3pjGIs+YCtPtb2Bvk0aLdDQ6qofATpBz?=
 =?us-ascii?Q?/Q73u88rNIXDfP7HJqjWu9hFsHZr6TZ9K6XGJpJgksaM93bBIrD1VRtX9HIG?=
 =?us-ascii?Q?vCAn/4lnIpZmZpJxyKLbFHnYbMl1EPQRchLr1hjV8mUNngveoy/GVeo2S7xV?=
 =?us-ascii?Q?NR1KHvXLzjJIMhP8wcffIFFu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5a3cef2-8e6b-44fb-96ab-08d91e144c1f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:57:57.6952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K7mqT6RGhocYiM3uiEwZBcZfmo3dkfogSjvh10EVJvnH8AnvJPGGQaFxH5xfO4G9xSINMqTIcA5JDQ9YVzU0awDwXYOYJHbkXgx6Kv+bDRQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105230136
X-Proofpoint-GUID: -dzpgUy2E3Dxtoq0kqoXfiwQtmDlPd0p
X-Proofpoint-ORIG-GUID: -dzpgUy2E3Dxtoq0kqoXfiwQtmDlPd0p
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Userspace (open-iscsi based tools at least) sets no linger on the socket
to prevent stale data from being sent. However, with the in kernel cleanup
if userspace is not up the sockfd_put will release the socket without
having set that sockopt.

iscsid sets that opt at socket close time, but it seems ok to set this at
setup time in the kernel for all tools.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index dd33ce0e3737..553e95ad6197 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -689,6 +689,7 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	sk->sk_sndtimeo = 15 * HZ; /* FIXME: make it configurable */
 	sk->sk_allocation = GFP_ATOMIC;
 	sk_set_memalloc(sk);
+	sock_no_linger(sk);
 
 	iscsi_sw_tcp_conn_set_callbacks(conn);
 	tcp_sw_conn->sendpage = tcp_sw_conn->sock->ops->sendpage;
-- 
2.25.1

