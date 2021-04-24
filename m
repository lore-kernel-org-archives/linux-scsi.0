Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 661D4C433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4884E6128A
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbhDXWTD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:19:03 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51948 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbhDXWS5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:18:57 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OMIBig068003;
        Sat, 24 Apr 2021 22:18:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=sZtKNpnhKUcmJnY0/M6obBbjXko1kEOYVNmLXouY9SY=;
 b=wyIOjkgpintem6wNN+swXJNBQ9olDvjsVIgWs7EBTqGWwKhhhiZh9Je/WrLEYilnnsUh
 dFh7scOyTL1Ls8SSMq7yPF56WFuutt8QZSD/PLK+XNcFeJS7BUpLzwSL3BmJTS28M83v
 lYySGrSpM913ft7bg/dsUk4S3qhJvzcDPaHib5KCDR9NA+1T1f2I27aB7QunX/4K01sw
 lO4WomhcC0ErdmtA4MiV3cUa3S0dID7eF1GPKAbIfUw40A8mX9i4a1IIxTagZWYaRkuf
 TwbT4GDH4GZUdA4OfoI/lIdmjbHxE9swEGsRJs8duu3NF461Lsu1uDstxblLsV/UCHeg eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 3848ubrvj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:18:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OMAPiC148236;
        Sat, 24 Apr 2021 22:18:10 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by userp3030.oracle.com with ESMTP id 3848et2ejm-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:18:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FEZKxvvpBu6hLyjABGCXM/Rd2KkGQYiR03J2yRSbLXyOf8jptJz//sCwtzd+UfQmTtH5mkmSZ01aH3cFJ5kPIOsirLVkO9h07kMV+idk7pVGTkl3c1CbaXwhyrJEg1v0svxqCKmGXrv/7mac+gR5eslRIkTCuZKYbecOy6RzsqHi7yPG0q//8vr9j4F52YYgdbQ4HIc7RIEqcQ2fQLE2EU3uqGVVloQMSPPOaBYS50B8EN1brG6dgIzzCEnuBI/nYpdE1lfJ2mg4cK+4pPOadvlzUqmRytIeyTzOb1g/F6aSTtC6OvTLqriEcKHUgmU67qiCGTUFqvgkVE6PWrAESg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZtKNpnhKUcmJnY0/M6obBbjXko1kEOYVNmLXouY9SY=;
 b=S5zZA5wnCj1Inqrb60hW3RIZn+y0ivj+qsep598ehIN/3oOE/J318SJ/3Kzrc5PP7MZvbbO+RbYh0DrwrfiD5wllqhzTMTijRjySx9cYuRBUkDA7ZtAHvhSOYZDU/CV2C8cif4n8c5n78Ze1V4VDpfBi7KhEYaIlqVD3uRKNLccEhbPdw8ktLMeL2X6H6llYzUQ1fgsl4B8YzVrmncfLKlJftCFlAgiDU1D4YbXP6n8Z8guNn6WeOig2x1wFf9YUFaz9uro9C78BeRDJHV0XyWXk2aJwGQb6VCtgsPiwmaKfarQLrnV7/ps0uI/iWmeh0fawO8PA0mOAYerSB/zDWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZtKNpnhKUcmJnY0/M6obBbjXko1kEOYVNmLXouY9SY=;
 b=BUHK74ujcZUmU/1RO3E+AShOUfV8xrefu5yT93XVOvVZAzxzqwH4RnMrjCe6M3KajaPednLSpwEWVYPc75lfGftLTyGAW8GLjo5wtU+Qk905NFKPGJujnJLelPv1TxBnlMVfpx38ZJFndF22G+dx84rXlSuSWl6Hd8+ueY93jvg=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2885.namprd10.prod.outlook.com (2603:10b6:a03:82::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 22:18:09 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:18:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     khazhy@google.com, lduncan@suse.com, martin.petersen@oracle.com,
        rbharath@google.com, krisman@collabora.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 6/6] scsi: iscsi_tcp: start socket shutdown during conn stop
Date:   Sat, 24 Apr 2021 17:17:55 -0500
Message-Id: <20210424221755.124438-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210424221755.124438-1-michael.christie@oracle.com>
References: <20210424221755.124438-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM3PR12CA0079.namprd12.prod.outlook.com
 (2603:10b6:0:57::23) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM3PR12CA0079.namprd12.prod.outlook.com (2603:10b6:0:57::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Sat, 24 Apr 2021 22:18:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55d5c9c9-032d-494f-9c8a-08d9076ed740
X-MS-TrafficTypeDiagnostic: BYAPR10MB2885:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB28858524FE5F2049CBE905C7F1449@BYAPR10MB2885.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:506;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 75/V4AEJudsx1On+2oUnnzagDzhuUm+r3+0ZWrPhtpZ5ucdBCV21NrI2Qg5A8W6BosuCR9MFv18ul+d+nifvvI/d3d2N+WKCnp/Mh4Tu2Fd/gNjxzNj396s0iJgTQnnUBXWvoIi+YXIdNTmL6xhXhX583lI6JpHpwFnl0nBK3VWnU81NAgjvJ+uvj0bUSYDA/sk9OVo5BYmZ61rGCo4N7K0T/IyiVxBUnM9QR8XV6C2BzVbNWM/sdMcMnmrjwnC7+7/cfZUWCRCyLUa5Uhz4bZlSKq4v19cATfy5p6PmakH3Op03vXxanaXVgvTh4Wh80OORmgjn3LOUlRtSO2CWvslqJWfF542hYeIer0XkevElRSXlalzefFnnwl3U8jb1TGNBnLTRjblL8o3DadbWf9P6N3IH6lPDXbltW3EPpdouMV8eukksHxLH5v6z2W0G0Xy5A+unWsIhRLP5cFOLQjCv5zMBnLIao4ROKPel6shPLRVC3q9JO088irmhdbIaJeTZ2eIHSWVxHtOJFXlQWNDHa3pPUXrsLLPQX1VwS7D8NFZ5yc7c88xier0OwO520UxT+MuVCd8ehmqFeEQBz++qqTspUN86HdamflGoHuEHsW80BrxXZxaAT/1G9QJfXiya5REDp9QOIMxQGX2CEeNNbCtGpDfq1GwF3OeOW3/0o82uHqgzROk+H7WIz4nF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(376002)(396003)(366004)(83380400001)(6486002)(66946007)(66556008)(5660300002)(66476007)(38100700002)(6666004)(4326008)(6506007)(478600001)(6512007)(107886003)(2616005)(186003)(316002)(36756003)(52116002)(26005)(4744005)(86362001)(2906002)(1076003)(956004)(8936002)(8676002)(16526019)(38350700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qqYbtJES+1hgnn3aMkAgTTRVfxJ9I8axdOG5IoNiIAKOCF0nvhwVLCz/qg53?=
 =?us-ascii?Q?Ut3C7VVqgJVUM7ouo6CN/FQpA6GKYjees38DqGsCDkliiOeNS2gdNSRkuLr9?=
 =?us-ascii?Q?01DYB/iZBlRpqMGd9FVoFSUSUNGdTFM76VAmTeTjD3FpNx4O6Xdi2J/gN5vj?=
 =?us-ascii?Q?E2JyMNgBLZaVBMYoP4kUvG+zrB2xr8iWSeDrYenYP9kAMVcgV1UX1DXuSbIh?=
 =?us-ascii?Q?hqn5v1GpwEOnhICvYhxC0N0NcrJKsImy4YMN0AYgNz/0vFZUB41dICb42J58?=
 =?us-ascii?Q?pqmooqzezJhwFkSRvdHLAdSbUTkmiTXS2tIMkKQj4ckLtkKvuZ+jjuUZdsKC?=
 =?us-ascii?Q?69DvKKL/ZNK6Y10FGBb11wiD0/QMJswrMmgycUBVQEcxaoUW8zJORzp1f4Am?=
 =?us-ascii?Q?5CFqSr18/MO9NBzdxwgKoQXossspokC23rqwuX5RTWZyMB71b0TvAgKS8ejM?=
 =?us-ascii?Q?odGnmofct6Q5B3XeI0LrWYnkYMSace9jnFIBmzLJ4FtYaOJL45eh2daOaZr9?=
 =?us-ascii?Q?prXt1bW18GyM98Wmv0R864PXMp/reDDGU3O1AniLj/KG3rEOnj4EWinr9cSX?=
 =?us-ascii?Q?Mty1xZAW7wox4p85Pt5DWDrP0tUFubBYo08Nxni0C4+1a3kh5B6BWnX2vTQZ?=
 =?us-ascii?Q?zNPutCQcfrlS9zZPjfdTZRQpYkq2avVT9s58GTpvIB4ecCL/jK9XPXnje3H+?=
 =?us-ascii?Q?zX7vLLykDYa/Ds1/uTBYm+CKS/OUmlJWZsnOWZcwGfxD9M7kgw6cDGwEchwo?=
 =?us-ascii?Q?w4bmc/SY/FMNjRX7lWKxOZNSAe/hhRkhqwDCxkP+Yn4/U/Z4+R8Q0QDQNPFY?=
 =?us-ascii?Q?RpI77MhMPNQLlid8u1zdd34BQTwsziXM6HpM1mZyzHQdJfrROaNQ3vWoxhVB?=
 =?us-ascii?Q?8jXlt1j7fwvrICbaGDXmHqYzDAEpOAmwAuRqDDs5ATno1FhV52BdZErD+nXi?=
 =?us-ascii?Q?KrZT8MQY+kBwWyE0zgnd7ZEEuRSNHzOGr6/1MRtCRPTME3/yfjJZprs0EJ9P?=
 =?us-ascii?Q?kkiaKI/HYUxVG9rMc6uEhM6aoRjqI10g0Yoq7kP4elNLKWTDxrlIGFdgsuhP?=
 =?us-ascii?Q?ik3EyexRoxKBVcAsNP1HECzn9BXPcJqJeWBNd6zKR30ZeCfGHWn6zRlM8/kx?=
 =?us-ascii?Q?W8fUt1Tym1MmxbRUU9KNHNEEgAzGKq34xqRbhTo8ETQqiZxqBaXTMlrPXuXF?=
 =?us-ascii?Q?tJmqm/aHFBwqXuhmbnTGd5+BeMtIA9tP70cvMXGVOJebUgYYsGit4lOQC5uD?=
 =?us-ascii?Q?1hLBK3PN+E/EFY8qPBlkRUbRTtjuB3cnktjrlCZ1nraMRLgiDKdbF7FFmYJc?=
 =?us-ascii?Q?ugx3ijpMZlFubizS7P+SvI81?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55d5c9c9-032d-494f-9c8a-08d9076ed740
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:18:09.1047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0MtjzyJriE+ZY6G9jVsLKSwcmska5jAfMxbWhG4XTuQZKu22PFFys+KDbgVjDaXcaU1SNIHcMBdBXhh//Vo6a2DefHWMwxasSqWjTRByPsg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2885
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240169
X-Proofpoint-GUID: 7PTA6ndceTmvoBHbAitMVzfVZ3qfPBkd
X-Proofpoint-ORIG-GUID: 7PTA6ndceTmvoBHbAitMVzfVZ3qfPBkd
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240169
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make sure the conn socket shutdown starts before we start the timer
to fail commands to upper layers.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 553e95ad6197..1bc37593c88f 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -600,6 +600,12 @@ static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
 	if (!sock)
 		return;
 
+	/*
+	 * Make sure we start socket shutdown now in case userspace is up
+	 * but delayed in releasing the socket.
+	 */
+	kernel_sock_shutdown(sock, SHUT_RDWR);
+
 	sock_hold(sock->sk);
 	iscsi_sw_tcp_conn_restore_callbacks(conn);
 	sock_put(sock->sk);
-- 
2.25.1

