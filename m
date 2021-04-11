Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E3DC433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 07:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33FE7611CE
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 07:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbhDKH41 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 03:56:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33464 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhDKH40 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 03:56:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13B7oLfe044432;
        Sun, 11 Apr 2021 07:55:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=AdrLeK6jS8cVeWXrn6bZE5v/0JnyCRbGcv1sxBaB2lY=;
 b=kIrVu24HXq9KWjufsNz1svKOikpMHwkaqNq2ebLeJkpnQjt9VbX4ZviQfqrD3D1N9nDX
 tcE3ZmF9+lsocAFAa0BZEM0BYtoKzq9rwxa7a+cl27Ca4xx9PDvDf4H8qOjB3U17oiAv
 rIJkcwljmUu0+aDYBw7dNi1X48qvUSIHUDzDi/a+KYhDCCpvT+bXo1uI9lN9/Bd1/0MW
 D2SbkjlvBbGbObEB2oIwYbYPLnZeKSeK7brjBIB+yLvQHRTDVkfFXvbJXWNRx1xU1c4w
 ZCvZWhxyabHlzTZ8nGLuRIiR6RFgb4lMzAg2CKQBr5IYWryKoIZSWf9P4dtz4wJcqv2G kw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37u3ym99ss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 07:55:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13B7tXbO017877;
        Sun, 11 Apr 2021 07:55:58 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
        by aserp3020.oracle.com with ESMTP id 37unww7qm8-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 07:55:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sx3FT2VngPCxSmYH0/gymUs0O+5s/Rt3YsydIrQ9uKRWKDsNBH8AdJYNyplp7Wz2CViNVt9I4YLyE3fnxfVKb0LyazUTFofQF4Imkj2jTejEn9x/Ou1VycR119UGWLtpo75fI/aygSAowA4Y0GEdVLvDUX9EsVoj+vMKAHZE4UMUrX2CryBJH0uZ4TLwBn0L6iE3VBNWUSvFEEvPwJdmGlQVitwb7VjraYags56tjMBtSnnd9QsSitrY+7mMVfKd4B15Ka7FkljIMMg44xmNeAgisefMTEaHe+eA2Co04eJPVJWM6lMkROFJaftHzAZkMBMq2vQ+TFKfuAJJWXo89A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AdrLeK6jS8cVeWXrn6bZE5v/0JnyCRbGcv1sxBaB2lY=;
 b=ftrOOMvFpHL7+A8j7oHG6GckXINUdwL3ZuEPZoyun03HkpLDjVwwgZV82x13vu7kMHUFHc+0vfOToKOJXKXOMfxcFjdOBg/US4xlb/WAy6yRXyy3I7M3ywFD5XwCRY2RdyrAO39mmzcOIKrvw9VOXqJgsenw9L9aD2JTwSp2OnUSmo1ggXGUL6bmccewcJ6v/zMXMMJThXvISQFz6VNsrEk34mPXBAILCdA+aWQKfI/O00ehkhjwzFdtxxAxGITu+9dftE7r84gxZ7y2QzoXaP+NRHSBI6f1vgSxiwNFJXV/dQMmWw1UBGkVA92qSsuGTk1iS6Ui/46WRLAsxWyX2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AdrLeK6jS8cVeWXrn6bZE5v/0JnyCRbGcv1sxBaB2lY=;
 b=C50kvoh9suzun/xUst7dIPyjuJ8NWJOV6CCrZpxqXWO2V7EmOjxNyms54F6QeC7o7cYtbzbZlniwQyPrwNpGOU2MNOofyNIz1/HQx4VQRkniIWv1JjWc3RifIKw+qpe/gAbADfdXdbcqAU6JfX5sn2LUVM34447A/rnewdZTYfE=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3842.namprd10.prod.outlook.com (2603:10b6:a03:1f9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Sun, 11 Apr
 2021 07:55:56 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sun, 11 Apr 2021
 07:55:56 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com, rbharath@google.com,
        krisman@collabora.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [RFC 3/7] scsi: iscsi: make iscsi_eh_timer wq generic
Date:   Sun, 11 Apr 2021 02:55:41 -0500
Message-Id: <20210411075545.27866-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210411075545.27866-1-michael.christie@oracle.com>
References: <20210411075545.27866-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR18CA0010.namprd18.prod.outlook.com
 (2603:10b6:5:15b::23) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR18CA0010.namprd18.prod.outlook.com (2603:10b6:5:15b::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Sun, 11 Apr 2021 07:55:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 947bf6fa-f96c-4194-8549-08d8fcbf3cff
X-MS-TrafficTypeDiagnostic: BY5PR10MB3842:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3842B6C80DDF4223962065CFF1719@BY5PR10MB3842.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eiQnzXLQkA1g+X5P4y64D4DGNk0wJSCwotUHfGDbBw5lc3wrheb6UbjZSxghTp6h+3ezPQEJloc3JjORaV68KKPI0YhW5SMNbsQAtA1/JNvdxad0FSatNkWGzOl8MMuLai3BN9dabLUrqRYXQ/z7PdOW0wKQySWA+nJKwJUC0/eCt9L6llgRsbXUk+zSGkufXLXcVOchfjy1HbUWXuTgk5Tm/iWAbYTRCOYXHFLPau82naVUamO73al25xkaR7P1iTjzQl3pdXj4qpc5uLqpA0v+sViq0/OTfrUOqV66Q2PuzgfcTaCiFNXEn7UAWg8d0XB9D/GHAFoOL4uJylgtqw9gBI/vCKzvCqjjChs87Tu1Pr5CCdhThxhLZXtOsIjqAd9TWb8I3ToMCgXpNbValUVPbuC5XLVmMHX4r4jr88uOnwO3PVGKqQ0VZEStLoYuYb7aXdlNmMIDc455nCMTU0Ov4xeTbDkNkxHaw/ZJUIyvMxDtrDe+ipOEz7JSJRZyNVJGul7oBtu6f6vhU/ZK6tBCmGOy/nSI6edk8dGvRi3bz9uzL+53VnouVTnpEURviL0H1eyoaF9NR2sfbHX1hIeaQYvgHE82DoF7k8RSOuf/l+do1LTY4+Snn8ZpWaZB8K2ItM03CNfULJJOkZs3W3jFi17LijnZXSXWuYeFOJsxUsVltDuzc6dC129VYwOQw4ZOQpZQ0xc+yinPhfzoOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(8936002)(16526019)(6486002)(316002)(66476007)(6506007)(956004)(2906002)(8676002)(2616005)(26005)(5660300002)(6666004)(86362001)(38350700002)(52116002)(38100700002)(69590400012)(186003)(66946007)(1076003)(83380400001)(36756003)(6512007)(107886003)(478600001)(4326008)(66556008)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?eNcZQrwCJSHysyYfMs46amAj/TDP269GUxY5H2S65ePF4CemS0INwVOqhUX3?=
 =?us-ascii?Q?jgk4RFKoeHCM+qM1bILBta87zjtRinMEG3EZ2xN9xBURLLe/GGrScXF7qZbw?=
 =?us-ascii?Q?6SRpw4D90xjgU1o6gjg/+27kzE4da61Hgqg6X8tZoJHSsqdTiiVhm4mHjC6S?=
 =?us-ascii?Q?EklPYIRylcPcE/QcMc+LoCmQDsARAtSlFQfnB3G9oCS4q/3fz0IT7btJgd2S?=
 =?us-ascii?Q?eDXRmcEnPkKPPDH9cMDfTmVdR7Zl3XHu4m4vQmjl/6pgJF7b0RNm1FhU2fKd?=
 =?us-ascii?Q?mvJpCXm5zJB3ly4giMUH2O/bT4E5Im8hZY5qZThohyUXh2L70Rbw2/+qJHQD?=
 =?us-ascii?Q?BOHx93zgO0wjlzPJTKRy35+YZ+YnYHUfvChSx2keYFYokD1tl/YBpezm69Rj?=
 =?us-ascii?Q?/ctzBz6SvwdnUdVIYJUpWKsTWneGeQLOidMoXl6Hi8SfGWkC5uiIl514k3OJ?=
 =?us-ascii?Q?uRvl/rZoabuqP2yXN4JQkhhBHyan2APBxhpQEsAVWVNH3bZuBl112RvbHLMY?=
 =?us-ascii?Q?r6j00cCdwajiZmF8ch1XyuYRcEVilDJGPZb6/oAHeSDb/gfIgARaXLeddQYD?=
 =?us-ascii?Q?rx2DCpKL+3yFZLTXYhvpgkm4Ha5w8sD2QrXt+Z2+1bsKb9T3HtlSCNIijFaI?=
 =?us-ascii?Q?v2PUyiMhtwumIjWqey5LyoW2TsMqrrxjLRDg29pAwemLgxNRFwDEc/M/s4/W?=
 =?us-ascii?Q?6/doaY0nSOCE4pl+/47bdB0yuG2QOXhGt0rQv63vecM4jTzk7VOFWVR11vWz?=
 =?us-ascii?Q?jZ2e6VD6y7TW076gEyc/d+6lfUP0ye7uqXGAwQuTxXwJA66uPwiG7xkvCGG1?=
 =?us-ascii?Q?bno9mneC7owleRuAleTwxpAXva5FWcAIIrpP8GVpQAIDNlFCpIijwEUY7/5v?=
 =?us-ascii?Q?jlf/gst2pHl6bnBDruR01//3w3kgLcXDVb8LMYxDYsN2IVN8n98kt5p8czaL?=
 =?us-ascii?Q?wVOlGOepHmGKvVdqucfnrKx8UvWuigH3QuDvrnDdT3UgY3dwtmP4QTnrxtXN?=
 =?us-ascii?Q?lUt86+R5bQtW/4C5awC4W80s6ceuXummHNoigcMfdqvv2Q9gap4W7pTtLCDT?=
 =?us-ascii?Q?PXhEGXKQ5uSaYOegholFw7PDbfR4HojCvqBeTY+45zNYFrlgrkDHevkgqlLP?=
 =?us-ascii?Q?1JG8xrekyzbsDgHNgiIVWhLjN31VbanOZnph8ZceNRYPHJOan8Sv5CQT7nF7?=
 =?us-ascii?Q?dL9YCKJ81WNKwMEwf0RzvjDtHrgGXqORuDxdPJSldBYiDWlBJ2Ckz5A6wPXk?=
 =?us-ascii?Q?782K+aCmNzMCOc+In4ulrScEnZkT4hQEH266obIS+OtuBH1TBeBUQEzYBij3?=
 =?us-ascii?Q?3OumCegbf8jer3SOwIzhy/O0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 947bf6fa-f96c-4194-8549-08d8fcbf3cff
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2021 07:55:56.7165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j6i9qatyh5+FbPfcClOosmuOEZTRg+71PM5GrCu2PttWt75NZFOM3hDFF+M29xgeLH2OVp7Tn6B8GwXIU+QrZ32ukuYe48NZNgb3hGEoR+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3842
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104110060
X-Proofpoint-GUID: NyU5V0EAA1zn8RYt-FkCb605UdtW7Z34
X-Proofpoint-ORIG-GUID: NyU5V0EAA1zn8RYt-FkCb605UdtW7Z34
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104110059
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patches add more management related works for operations like
conn stop and ep disconnect so this patch makes the iscsi_eh_timer
workqueue more generic so we don't have to add another one.

This patch does:
- Allows more than 1 work to be running. There is no need to limit
this because each operation will flush/cancel operations it has
conflicts with. For example the unblock flushes the block which
sync cancels the recovery.

- Renames the wq to reflect it can be used for any management
operation.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 168953cc0ff9..0ea8ed288f54 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -93,7 +93,7 @@ static void stop_conn_work_fn(struct work_struct *work);
 static DECLARE_WORK(stop_conn_work, stop_conn_work_fn);
 
 static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
-static struct workqueue_struct *iscsi_eh_timer_workq;
+static struct workqueue_struct *iscsi_mgmt_workq;
 
 static struct workqueue_struct *iscsi_destroy_workq;
 
@@ -1976,7 +1976,7 @@ static void __iscsi_unblock_session(struct work_struct *work)
  */
 void iscsi_unblock_session(struct iscsi_cls_session *session)
 {
-	queue_work(iscsi_eh_timer_workq, &session->unblock_work);
+	queue_work(iscsi_mgmt_workq, &session->unblock_work);
 	/*
 	 * Blocking the session can be done from any context so we only
 	 * queue the block work. Make sure the unblock work has completed
@@ -2000,14 +2000,14 @@ static void __iscsi_block_session(struct work_struct *work)
 	scsi_target_block(&session->dev);
 	ISCSI_DBG_TRANS_SESSION(session, "Completed SCSI target blocking\n");
 	if (session->recovery_tmo >= 0)
-		queue_delayed_work(iscsi_eh_timer_workq,
+		queue_delayed_work(iscsi_mgmt_workq,
 				   &session->recovery_work,
 				   session->recovery_tmo * HZ);
 }
 
 void iscsi_block_session(struct iscsi_cls_session *session)
 {
-	queue_work(iscsi_eh_timer_workq, &session->block_work);
+	queue_work(iscsi_mgmt_workq, &session->block_work);
 }
 EXPORT_SYMBOL_GPL(iscsi_block_session);
 
@@ -4802,10 +4802,10 @@ static __init int iscsi_transport_init(void)
 		goto unregister_flashnode_bus;
 	}
 
-	iscsi_eh_timer_workq = alloc_workqueue("%s",
+	iscsi_mgmt_workq = alloc_workqueue("%s",
 			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
-			1, "iscsi_eh");
-	if (!iscsi_eh_timer_workq) {
+			0, "iscsi_mgmt");
+	if (!iscsi_mgmt_workq) {
 		err = -ENOMEM;
 		goto release_nls;
 	}
@@ -4821,7 +4821,7 @@ static __init int iscsi_transport_init(void)
 	return 0;
 
 destroy_wq:
-	destroy_workqueue(iscsi_eh_timer_workq);
+	destroy_workqueue(iscsi_mgmt_workq);
 release_nls:
 	netlink_kernel_release(nls);
 unregister_flashnode_bus:
@@ -4844,7 +4844,7 @@ static __init int iscsi_transport_init(void)
 static void __exit iscsi_transport_exit(void)
 {
 	destroy_workqueue(iscsi_destroy_workq);
-	destroy_workqueue(iscsi_eh_timer_workq);
+	destroy_workqueue(iscsi_mgmt_workq);
 	netlink_kernel_release(nls);
 	bus_unregister(&iscsi_flashnode_bus);
 	transport_class_unregister(&iscsi_connection_class);
-- 
2.25.1

