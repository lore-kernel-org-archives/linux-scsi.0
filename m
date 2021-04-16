Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C986C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D0BB61182
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237996AbhDPCF1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:05:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36140 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237661AbhDPCFZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:05:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G204g3172519;
        Fri, 16 Apr 2021 02:04:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=cEyImvyJHUDcTp32d8itBoFJ3+WXNTwKne8zp3GHllU=;
 b=Pxd9dBK9kgIvuP1RFHhMJK+kwt7KIzC0Vp2nOTNJcRs6xlKcUMd/3c5R3J3BxBlZAv7+
 2AR1WFsN6bE1sfgBRbSDP+VBTOHlYu23Mw5wzaGLnNiDVHXc4/6LqP5Tz43jCZ6BMTBp
 a3RMK2VaJrxH4zugZduxfpO/KTt1KaJ2lzSGA2UKpFCZMBUF3q+aMidb0c3QZQpnmf3Z
 o8mvk5vU0SZQKi/+w8rncuIVFLHotf+1U9qt8wXS9k2PiZS/J/ZH2crxliN7h/ohaSzz
 bx+ALxBOU0Yl9AQNedYOu0KU1N65A/V/o3DTYUozdWQYFmpCddIq/C9174pVy0AJNxW0 XA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 37u4nnqmfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:04:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G20eZG001033;
        Fri, 16 Apr 2021 02:04:54 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3030.oracle.com with ESMTP id 37unktfb62-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:04:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OnXiUb8zBYu3pINeLrhZ4fVfyu3E2fpq4TU3CY9HHA2P+rybd5COMJRddyznMNWmkzPmfMcy9fo+CWMKn3JvlaVK5b6Oc39x9Uu/Y9ibVrGDNw+J947lkuq2sQTnGRJeFJYXYiMZ+Jp7hRPSyXKaoJ5Jki+JcvXL89ZXORA9C87g/aG0W4fT/i1T7vd2IfC0RsXwu3jCdKwZEZTuSQmy6MpxshytK+xMLdgFfYaO+8wCBsurwURuSqwCQ9aD4F6Ze+mfUJB36KHSkvEiDxqwz27XW7nYmLG4aoHhNdUt0YPG2cmjVWkvRHFXqlChJ/RnekbW5O8+8kBlK4yFEoUroQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEyImvyJHUDcTp32d8itBoFJ3+WXNTwKne8zp3GHllU=;
 b=Y4gN4FfPB+HP8eBgwWCsTevo1B1yoZ8yy/D8PxgwduilR0WI+HcPmIkYxeGz/o1jSMw1tXGdLEVnDnUqpeECYoycPIS3BTjgfTFQUS2IpUTh89Luf9fVdUfspPEI2e+bU6RGaChLv69BAi9goKzdlZkh/ID6fpcv391CFCb/H3eUMU40JuUnitHn5DUyTEaA24spMwNSMmfNR95F1TA6PYTQJsm4/Swf/ktdXQ+cF0SIbRXek19/uW43VpHo83iD9gnRap/Q10Cn6LOcHLqVR/VSGkd/El4guuq/bi/ObMPHaZ9e6a7qv8Y4FxaHrQaUuMos2A86MrQY+UTKurf80w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEyImvyJHUDcTp32d8itBoFJ3+WXNTwKne8zp3GHllU=;
 b=m97R+KCmnctCK3bqA9/j+ZdY82fXMpDAINBREqGQrx622mcU59tvONUIMHVqHte5IDPsLwTRxRXE4N9QamzIaNCfCH5mz8+/H113mXwmlktBts0N+FjYcwnswxTYsl/V+ax/G+xojn0aZqxyVtrsMnodTxjIWPobOoVv3NNNIqY=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2421.namprd10.prod.outlook.com (2603:10b6:a02:b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Fri, 16 Apr
 2021 02:04:52 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 02:04:52 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 03/17] scsi: iscsi: stop queueing during ep_disconnect
Date:   Thu, 15 Apr 2021 21:04:26 -0500
Message-Id: <20210416020440.259271-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416020440.259271-1-michael.christie@oracle.com>
References: <20210416020440.259271-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR02CA0100.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::41) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR02CA0100.namprd02.prod.outlook.com (2603:10b6:5:1f4::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:04:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 694313ff-2e41-456f-17cb-08d9007c05d6
X-MS-TrafficTypeDiagnostic: BYAPR10MB2421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2421D9EE1E7569FA4BE0B348F14C9@BYAPR10MB2421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tUALTP1xQFQXSg40o8jqFtjkbweaHGRUgBKpc0WI+/ozUhdf2EKF47ejPQgBmrwJnpRS98px0k/dlJibqoha2/eYs4x/nrcOw5BlAKkVWmGb4nTiEx1SlxsJumU/HXS5/7e96jbjkLoMidrlIwK7Tp3akWVOlT/yZe7bvIaHc0AgRG5g1kwqrUmMkfoDd2hkT/S+tICwvriFLmYO0d3EGtueLjNvgW81fYIR62NKZAYutudLCSEIW2wpGt7RZLg18UhWE/avYzvxFNV8ev7S2++eY7NUhubLm0N4PvoHAe8gVWrWxLTQl1Px3dTWpkZZx+ay4YvXY0pb9hWXIbaiK54TVUh1Q49Q1HtRJIqXHbAOC0SEHcF4AIf6B4TX55SECGzPC4JSIU/ydBbxNEwOhDknnpK+CL/r8Kl0O6260UFq+pvmvhgWagID43cmMgqIfUbw2gH5OjNmc5XMaZDk71e/v5oXXlzSoFBpiuz2Ys1M+2U1F+7vSXEPS1wKdD7w4pYI7SJ7hR8YGsQ8MOW5T/fNGxFW2iqczqNNT7Chn8jN14mPNsh63A1W2Az5s4JG1IP4X4B3EHY3MojLyYMdwADeHdUdCSoopn+GSYkn0UdJfeN+uK5bW5lDxcsG0YDXJa3iuxXbezaNkOA3/hR362aJAPw4qGSaXPZyV6ZIFLW5jfkCMUckeYYgYHf6vFR2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(186003)(69590400012)(16526019)(5660300002)(1076003)(6666004)(36756003)(26005)(107886003)(83380400001)(4326008)(52116002)(2906002)(6486002)(2616005)(6512007)(956004)(8936002)(8676002)(316002)(478600001)(66556008)(38350700002)(66476007)(6506007)(38100700002)(86362001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0Jo63ZB6c5ZpVM2+DdYThaYnaj6gu0hJdMz7t+yARrt93yDIDUaCDgkXvvMD?=
 =?us-ascii?Q?gX+grKzrQijgTpts+Bp3I2IU1IO43ZXd+0EPzhtNt2qPIqI7mGnyI2Ck1oya?=
 =?us-ascii?Q?8aoIonErZ8h4luHjzPgO2FsEeMKor0ywZW51tuxnz6/Qe791QDaKYEy4w9SB?=
 =?us-ascii?Q?PDkjy0Nf3aBy2gBzcK9YIcfac7pAwdCKyxSCCcGnAIlrQOfyjCKdHLZS3jCI?=
 =?us-ascii?Q?7GJqjSXNTMv/bqvFTeEjVHtuSh2wKNyWz3SWUoMm7xLwyn4ZdyZWKGfORbaZ?=
 =?us-ascii?Q?D7ui8aSTkAEkGaxRUvlxTQIDN8nwzDAwT1FNKr9ZDJIkNmRUmG7SlgJBii6Y?=
 =?us-ascii?Q?80p5/iBdu+O0gLWb30S5S6wQsdgnfh9AqbYb5Za48/A0Pefrahp64PahfU2j?=
 =?us-ascii?Q?uoXObd3RjROKtNFKuJ0/5FOaecdH/M62A8oBri0LnTduWmnDm0YjiJJnN/28?=
 =?us-ascii?Q?iKNCx8YPNiVtjzg2zkzVUoVRrjuvxrYm8a/nfpoMAj/HA0XXZjv9fAtQUPC6?=
 =?us-ascii?Q?eEaE+7MOpQPLjhB7nT77aeYXsZZv0hj0bhKMo0AaHVeQ2S8FXiC11v5xdSpP?=
 =?us-ascii?Q?sQj0vbxB3MRzgUMiM87UUvSMZfcql+LO202fg1SrmEcFrFDYnGnImmsf8L+/?=
 =?us-ascii?Q?8M5PdbPh5SAjN2cSmtL9UlPUpsO10KUBhACgyyUZZXvW4cPm7gvgK3Lz7ITY?=
 =?us-ascii?Q?N9DK1zok5d+CXSPnGfBKWgNxP+6J7E5h/ZdxWl8uRIrgPp0RHgmPL2tEND6j?=
 =?us-ascii?Q?cB9fERhhU3YgvLa6eS7k6LXvQGYoEMFXATbnQBI8Pjm6xzDvvdRzSilc5oxu?=
 =?us-ascii?Q?lnI454NgLEUIy0hATrNKbhoEmxMSi0ZKHBXFMjDhZE4KYvtoy16oW6Ok4SQq?=
 =?us-ascii?Q?A4gEEvVSFTJovPyJPzYJqfchNJaDVxXqISkNN5sWdFUt+sxsIviYCrq8bLuo?=
 =?us-ascii?Q?ArZR8fHShpyl5gEx72SoDq+e8uCxhJa2fXks/gOdbzDneHbilWkvVqqEyW88?=
 =?us-ascii?Q?BrRjRdw6FzD2KpqJkzDDK8gjnTLf3oJEiTXk7cQTJWBx4ATG4wgSY/rWL4WB?=
 =?us-ascii?Q?c8i9hZyCGi5BSIAP0JMdIzHOl/N02mxcFTGqkXw8mP5Uhm1ftROBb5CtnFtL?=
 =?us-ascii?Q?pXIfxR2i0ZrFLf4jzxcsyko1ya2siZjgR9jSyQbn/K+tBhLaEgSXTBmP6X7Y?=
 =?us-ascii?Q?YAMt6FcLWCscHBch6DciCrHTNrFCwnlQhQopd3+BFFHgfz4Xwz3T4PLcItW9?=
 =?us-ascii?Q?J7Vf8G4aS+F4iCJTaj+88xA2A01jCeBva3h7rb1xyBW7HvZXpofinMHIf7rz?=
 =?us-ascii?Q?62bwqTtl7cJXvHUlzeow2xFi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 694313ff-2e41-456f-17cb-08d9007c05d6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:04:52.5826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e4KX6KSC8NwkE2ybfac16pzrxtF2dgtaQ5TtLGRJbuY/cG75xCgdNygDRoj2U3hQ+MMSncDgOb6QQmS2HviOkkG2ftv25qh+dlpkO/SaKWY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2421
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
X-Proofpoint-ORIG-GUID: E3Rvyc0UtoCt6DlxddcmDUVAH9V2MnNa
X-Proofpoint-GUID: E3Rvyc0UtoCt6DlxddcmDUVAH9V2MnNa
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During ep_disconnect we have been doing iscsi_suspend_tx/queue to block
new IO but every driver except cxgbi and iscsi_tcp can still get IO from
__iscsi_conn_send_pdu if we haven't called iscsi_conn_failure before
ep_disconnect. This could happen if we were terminating the session, and
the logout timedout before it was even sent to libiscsi.

This patch fixes the issue by adding a helper which reverses the bind_conn
call that allows new IO to be queued. Drivers implementing ep_disconnect
can use this to make sure new IO is not queued to them when handling the
disconnect.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |  1 +
 drivers/scsi/be2iscsi/be_main.c          |  1 +
 drivers/scsi/bnx2i/bnx2i_iscsi.c         |  1 +
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c       |  1 +
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c       |  1 +
 drivers/scsi/libiscsi.c                  | 61 +++++++++++++++++++++---
 drivers/scsi/qedi/qedi_iscsi.c           |  1 +
 drivers/scsi/qla4xxx/ql4_os.c            |  1 +
 drivers/scsi/scsi_transport_iscsi.c      |  3 ++
 include/scsi/libiscsi.h                  |  1 +
 include/scsi/scsi_transport_iscsi.h      |  1 +
 11 files changed, 67 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 8fcaa1136f2c..6baebcb6d14d 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -1002,6 +1002,7 @@ static struct iscsi_transport iscsi_iser_transport = {
 	/* connection management */
 	.create_conn            = iscsi_iser_conn_create,
 	.bind_conn              = iscsi_iser_conn_bind,
+	.unbind_conn		= iscsi_conn_unbind,
 	.destroy_conn           = iscsi_conn_teardown,
 	.attr_is_visible	= iser_attr_is_visible,
 	.set_param              = iscsi_iser_set_param,
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 90fcddb76f46..e9658a67d9da 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5809,6 +5809,7 @@ struct iscsi_transport beiscsi_iscsi_transport = {
 	.destroy_session = beiscsi_session_destroy,
 	.create_conn = beiscsi_conn_create,
 	.bind_conn = beiscsi_conn_bind,
+	.unbind_conn = iscsi_conn_unbind,
 	.destroy_conn = iscsi_conn_teardown,
 	.attr_is_visible = beiscsi_attr_is_visible,
 	.set_iface_param = beiscsi_iface_set_param,
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 1e6d8f62ea3c..b6c1da46d582 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2276,6 +2276,7 @@ struct iscsi_transport bnx2i_iscsi_transport = {
 	.destroy_session	= bnx2i_session_destroy,
 	.create_conn		= bnx2i_conn_create,
 	.bind_conn		= bnx2i_conn_bind,
+	.unbind_conn		= iscsi_conn_unbind,
 	.destroy_conn		= bnx2i_conn_destroy,
 	.attr_is_visible	= bnx2i_attr_is_visible,
 	.set_param		= iscsi_set_param,
diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 37d99357120f..edcd3fab6973 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -117,6 +117,7 @@ static struct iscsi_transport cxgb3i_iscsi_transport = {
 	/* connection management */
 	.create_conn	= cxgbi_create_conn,
 	.bind_conn	= cxgbi_bind_conn,
+	.unbind_conn	= iscsi_conn_unbind,
 	.destroy_conn	= iscsi_tcp_conn_teardown,
 	.start_conn	= iscsi_conn_start,
 	.stop_conn	= iscsi_conn_stop,
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 2c3491528d42..efb3e2b3398e 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -134,6 +134,7 @@ static struct iscsi_transport cxgb4i_iscsi_transport = {
 	/* connection management */
 	.create_conn	= cxgbi_create_conn,
 	.bind_conn		= cxgbi_bind_conn,
+	.unbind_conn	= iscsi_conn_unbind,
 	.destroy_conn	= iscsi_tcp_conn_teardown,
 	.start_conn		= iscsi_conn_start,
 	.stop_conn		= iscsi_conn_stop,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index aa5ceaffc697..ce3898fdb10f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1387,22 +1387,28 @@ void iscsi_session_failure(struct iscsi_session *session,
 }
 EXPORT_SYMBOL_GPL(iscsi_session_failure);
 
-void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
+static void iscsi_set_conn_failed(struct iscsi_conn *conn)
 {
 	struct iscsi_session *session = conn->session;
 
-	spin_lock_bh(&session->frwd_lock);
-	if (session->state == ISCSI_STATE_FAILED) {
-		spin_unlock_bh(&session->frwd_lock);
+	if (session->state == ISCSI_STATE_FAILED)
 		return;
-	}
 
 	if (conn->stop_stage == 0)
 		session->state = ISCSI_STATE_FAILED;
-	spin_unlock_bh(&session->frwd_lock);
 
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
+}
+
+void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
+{
+	struct iscsi_session *session = conn->session;
+
+	spin_lock_bh(&session->frwd_lock);
+	iscsi_set_conn_failed(conn);
+	spin_unlock_bh(&session->frwd_lock);
+
 	iscsi_conn_error_event(conn->cls_conn, err);
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_failure);
@@ -2220,6 +2226,49 @@ static void iscsi_check_transport_timeouts(struct timer_list *t)
 	spin_unlock(&session->frwd_lock);
 }
 
+/*
+ * iscsi_conn_unbind - prevent queueing to conn.
+ * @conn: iscsi conn ep is bound to.
+ *
+ * This must be called by drivers implementing the ep_disconnect callout.
+ * It disables queueing to the connection from libiscsi in preparation for
+ * an ep_disconnect call.
+ */
+void iscsi_conn_unbind(struct iscsi_cls_conn *cls_conn)
+{
+	struct iscsi_session *session;
+	struct iscsi_conn *conn;
+
+	if (!cls_conn)
+		return;
+
+	conn = cls_conn->dd_data;
+	session = conn->session;
+	/*
+	 * Wait for iscsi_eh calls to exit. We don't wait for the tmf to
+	 * complete or timeout. The caller just wants to know what's running
+	 * is everything that needs to be cleaned up, and no cmds will be
+	 * queued.
+	 */
+	mutex_lock(&session->eh_mutex);
+
+	iscsi_suspend_queue(conn);
+	iscsi_suspend_tx(conn);
+
+	spin_lock_bh(&session->frwd_lock);
+	/*
+	 * if logout timed out before userspace could even send a PDU the
+	 * state might still be in ISCSI_STATE_LOGGED_IN and allowing new cmds
+	 * and TMFs.
+	 */
+	if (session->state == ISCSI_STATE_LOGGED_IN)
+		iscsi_set_conn_failed(conn);
+
+	spin_unlock_bh(&session->frwd_lock);
+	mutex_unlock(&session->eh_mutex);
+}
+EXPORT_SYMBOL_GPL(iscsi_conn_unbind);
+
 static void iscsi_prep_abort_task_pdu(struct iscsi_task *task,
 				      struct iscsi_tm *hdr)
 {
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 08c05403cd72..ef16537c523c 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1401,6 +1401,7 @@ struct iscsi_transport qedi_iscsi_transport = {
 	.destroy_session = qedi_session_destroy,
 	.create_conn = qedi_conn_create,
 	.bind_conn = qedi_conn_bind,
+	.unbind_conn = iscsi_conn_unbind,
 	.start_conn = qedi_conn_start,
 	.stop_conn = iscsi_conn_stop,
 	.destroy_conn = qedi_conn_destroy,
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 7bd9a4a04ad5..ff663cb330c2 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -259,6 +259,7 @@ static struct iscsi_transport qla4xxx_iscsi_transport = {
 	.start_conn             = qla4xxx_conn_start,
 	.create_conn            = qla4xxx_conn_create,
 	.bind_conn              = qla4xxx_conn_bind,
+	.unbind_conn		= iscsi_conn_unbind,
 	.stop_conn              = iscsi_conn_stop,
 	.destroy_conn           = qla4xxx_conn_destroy,
 	.set_param              = iscsi_set_param,
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 441f0152193f..833114c8e197 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2981,6 +2981,8 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 		conn->ep = NULL;
 		mutex_unlock(&conn->ep_mutex);
 		conn->state = ISCSI_CONN_FAILED;
+
+		transport->unbind_conn(conn);
 	}
 
 	transport->ep_disconnect(ep);
@@ -4656,6 +4658,7 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	int err;
 
 	BUG_ON(!tt);
+	WARN_ON(tt->ep_disconnect && !tt->unbind_conn);
 
 	priv = iscsi_if_transport_lookup(tt);
 	if (priv)
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 8c6d358a8abc..ec6d508e7a4a 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -431,6 +431,7 @@ extern int iscsi_conn_start(struct iscsi_cls_conn *);
 extern void iscsi_conn_stop(struct iscsi_cls_conn *, int);
 extern int iscsi_conn_bind(struct iscsi_cls_session *, struct iscsi_cls_conn *,
 			   int);
+extern void iscsi_conn_unbind(struct iscsi_cls_conn *cls_conn);
 extern void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err);
 extern void iscsi_session_failure(struct iscsi_session *session,
 				  enum iscsi_err err);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index fc5a39839b4b..afc61a23628d 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -82,6 +82,7 @@ struct iscsi_transport {
 	void (*destroy_session) (struct iscsi_cls_session *session);
 	struct iscsi_cls_conn *(*create_conn) (struct iscsi_cls_session *sess,
 				uint32_t cid);
+	void (*unbind_conn) (struct iscsi_cls_conn *conn);
 	int (*bind_conn) (struct iscsi_cls_session *session,
 			  struct iscsi_cls_conn *cls_conn,
 			  uint64_t transport_eph, int is_leading);
-- 
2.25.1

