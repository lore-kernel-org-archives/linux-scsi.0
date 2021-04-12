Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8087C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 00:51:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A36696120A
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 00:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236073AbhDLAvW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 20:51:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47202 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235323AbhDLAvW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 20:51:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13C0YBhp119565;
        Mon, 12 Apr 2021 00:50:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=AdrLeK6jS8cVeWXrn6bZE5v/0JnyCRbGcv1sxBaB2lY=;
 b=Egxx62Mpunb07fdLSx2Df90eb0Wwh6Zu9lM0psaOLMXBH0DZnUzHKfXwAlnm3k/63x+d
 ImPJItyZSMFqO/3GmsaJm26skmA22TNOzq2oCG+pWdnPTQKkb3a1e/eVdUFwcxMEeAs4
 qYDTjGKwsMDoD5dfzBsyk+b+gE9LlvTdOE4ZryWXmV2XSTUkWzRNnlP9kb+TjkLOLGOf
 GqBTu2FxLD4nQc9w2vOb89OmhP6il6ivRfq5TiiC6IgtGVJ12I0afzm62KCkAOlDkKf7
 xY/dtaxQnoEgvIddv8K1rbjsogrSduosc5A+D4uMr6uW+TfyJt5i/lw0GsTYyszLiYxK Vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37u3era14f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 00:50:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13C0aNPB051826;
        Mon, 12 Apr 2021 00:50:56 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by aserp3030.oracle.com with ESMTP id 37unkmf7xe-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 00:50:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zj/eG2IGw3QdyKZWVkRPy8Nqfrd4U11o0ybhClSHrfvD/QSIuBLqqGSdA36ZgKgFSPNpfY4XQxw32VnMo+L/ZYlLuI1yhJ8MBlxBcFj6HxUOdtCxs4Jptz3umjnB69z21dgS8CHrnBzDq+h7sUuxF4CzkpeHdf49rjgJgpssMYT331KtK7Wu4fsVsuejLe5REc4FQPuni3XQb9jWHV5NeV3bavKfwZYZ7/EhIXAAcv2OVikyFqXwWkKq8O2DCP8UCiH5lSUJuVlHwit/67Kag1U2ot4f0tUMfTL2MSme4g6dOHbjkBgzYZI/q+HpqNWgtnAgitp98+17JkryCZ0aHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AdrLeK6jS8cVeWXrn6bZE5v/0JnyCRbGcv1sxBaB2lY=;
 b=c8g4z5xGiEXEagUNX16sFbmcIbQUdb6GIPkhJvzBH/Qcy+RgNYWKg1mhh/ZX+xq+Q6r+UMSm1aM/xqjUIl3kCXnjMEfgDhHCrGbBkQbUp2VbNtT9Cbp5jBkqCHIMZHsv3Tpws8WYpzNJsIZD6ZxdEwpPLOCrMzaU91QzukGcMgmQU+9JiADHTIwejxFSDf+iiIjGWuEXO5DOL6SbNdtqxxAyJJsAU+fxmnkCN2IqTQZnDJTJlH2iMRPx/yBq0NSCVavUE7jgfcP/yeh5q7lS/47uTgdMCCTMI3Q7jQjsq4dEaK7edcmvamG+dQjopShjkTVbrfZNTQQjrbHq6PZh9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AdrLeK6jS8cVeWXrn6bZE5v/0JnyCRbGcv1sxBaB2lY=;
 b=tC9kxz0z/RwalNmDxZmZJoDPOOd66YkPLPUrZ9xX/aZxLFHPtEfqrChprefufRSlObgwyqGKLgbWNJMzcVMMohWZmByJvHZprGey5kNN+y3ekY8jT0Lyu2PMuQqo2wJHjtOmWFWRee1OlZOMA13fBXWpY1jReI8Jx33Cv/fUbd4=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4307.namprd10.prod.outlook.com (2603:10b6:a03:212::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 00:50:55 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Mon, 12 Apr 2021
 00:50:55 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     khazhy@google.com, lduncan@suse.com, martin.petersen@oracle.com,
        rbharath@google.com, krisman@collabora.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [RFC v2 3/7] scsi: iscsi: make iscsi_eh_timer wq generic
Date:   Sun, 11 Apr 2021 19:50:39 -0500
Message-Id: <20210412005043.5121-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210412005043.5121-1-michael.christie@oracle.com>
References: <20210412005043.5121-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR06CA0062.namprd06.prod.outlook.com
 (2603:10b6:5:54::39) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR06CA0062.namprd06.prod.outlook.com (2603:10b6:5:54::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 00:50:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbca2c0a-4004-457d-4cd1-08d8fd4d078d
X-MS-TrafficTypeDiagnostic: BY5PR10MB4307:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB430700398B844AFC7A9CEDC6F1709@BY5PR10MB4307.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VOwKYuFB+eKA+mfiUnSWXv9rYuXJ1FkUUTsJdqCBHTaTbLBWdmEN4Iufu//PMCLrMQfiJjUey2MhJ8StNDiirT4DxboMpG2m/E8V+GWBbHqtlLfnjyEhMyfkqf7HHYYmaDahB4YPANJBlgp6rvGD9SAxyVDhKMrueC5lkfIInMkWLdm3LrjOddRCSx7cwpRv+KiftBLdo/wDh6qegCWKIpBka1DMuhvlke3hSiIY54cU1Bbzs0p/DJsNvYetdFhRM3Rp3UWb166xEgli3crMjK4MQmMCRUjeZgfnBnQ94HbU+yr5htpmzIQtDQ7JIU7o39qLyQ7i9P6U6OLPOeEI0lw7MPcBTO7IrcC115DRHGth2zUnRg0d0L1hbdnwk6ttFPQueZX+iNUTpdyqZnLkNcT+cBDz7NGVBJ067DR70bkQUt1BCtEH38+wXym5y/92wxNBrV3J9FrQMoJCdJ9cgRO0V+N9NGPa/S1RXEHnCFv8y2QIAGnNo57/S77rGcVaqhLqP+lkr2X2YeoGDSqSHXPYiQYD8o1Uxy9Ue5bBu3on4A343tjj0EZupFh6mSv4niR6CE1IeknMrCPjyep93jyM912Gh2BgZpwZTJdqTxFVMLqB/c6P3SryakSao0PLDjBSd+KFqZRSUpotiy8edjeEhuwdcRZsBt/O9PkfNeTLg6FbHQWeDts6VYi8z+UN2awV1denRHBPNhgSFUwoQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(396003)(366004)(39860400002)(26005)(316002)(186003)(16526019)(2906002)(86362001)(83380400001)(1076003)(4326008)(107886003)(956004)(66556008)(478600001)(8676002)(38100700002)(8936002)(69590400012)(2616005)(66946007)(5660300002)(6506007)(6486002)(38350700002)(6512007)(6666004)(36756003)(52116002)(66476007)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Yz+otmEog1EH+to5BD9d7BWKFsM/Td0eSnXerRMiuYHGfai+pOkND09h0oV9?=
 =?us-ascii?Q?mu/KqWT9BFXvDQPfCV95yswnrVFJAXSwpm7PVFGxAm5pUEfkSNhn/pMnKPHE?=
 =?us-ascii?Q?MtuPINHbe/fXG3tWgtDlGkQa1MLcwGu5ci23wrojM7myOkrTMWLmXkerIM1T?=
 =?us-ascii?Q?z49xiL+9Wt/vOpUkdBguYODteM2jAf8HjfZffGEiKV832IWtbybaMZGmKl49?=
 =?us-ascii?Q?5isr2WHuR9AXhjOaLOKhKUuQa2ImcyyJNV32nXCQDoJ9qknrjffQyq5pAl2N?=
 =?us-ascii?Q?Xmbtr2Z2Gx/KZBf9hWgjPsGres4B8rD0salwPDrbzmTa2Y4rqy3M8nC4hzfY?=
 =?us-ascii?Q?JiFos5nfYqgYyZRIMQuLifN+5hqC/eciBef8MmmvJVoG7FNxencso3RrSeGN?=
 =?us-ascii?Q?NmHfCKTk2YJMKy7ayprlI/6c1eagNMkmrzeIB41T2VypY7/u2LkxbQK6fdWY?=
 =?us-ascii?Q?+Z/PhXHtkatvvW0/cFY/bgjQihk8a3oWMbPjc9zWbZMxaE7nDcFDDVeB+Hkn?=
 =?us-ascii?Q?myxBMG6K4l4n9gifMa9LLZQoKb9zjegBuQZbMNkIb1liBQSWyrxoO9dqvKN+?=
 =?us-ascii?Q?EZQpucqfFDzl2TY68tJE959s4sDg03QmUln/mdFPI3wiamjh1bFzu/Vl3aDx?=
 =?us-ascii?Q?LexZEvAVl19KXYs8lzHvTlRSADQqcSt63q4fB4RlTgISXU7Jlmf+gnE2z6K3?=
 =?us-ascii?Q?IiMiT/pMwOLiFM+nybUdAG2S2tLDZMAFdcUt+6drsMpD54u04pqYIdtEx8qB?=
 =?us-ascii?Q?63MMZFznjJJYcKgii9knb+o88bbQNu1BvP+umT2L9Av//Y8pNvo6da6icAYx?=
 =?us-ascii?Q?l861EEIVfX2KZuOeA36rhAMSl+msizph1crfDtsUkkjYG3wNSwAtml05Jauo?=
 =?us-ascii?Q?Tja/dhxu/fdbepIX1UJls9BaabJxZsdVc2+5DNWuOToBHQM5zsmPXxhTgvQk?=
 =?us-ascii?Q?EAeSBBLYanvqwS7EUqiD7r/rKDSEWDlQELKMnNNjv3S2oYm2dT9kTvMt08sb?=
 =?us-ascii?Q?EvFW1WRLfKTjf8NXA7thVO2NeQQjWcu/YD680gz8VI3fY24/Vzryfmp1ziQs?=
 =?us-ascii?Q?nEgygUHPohx3kihO5AQCYgkccajr8E00PKqFa9CtJbMfzR5KzGguETOXnaBZ?=
 =?us-ascii?Q?fTSsZoM5oyYK+/agt+0UxPE7GmOoN2F9JJ5ibDiPBh4HhxbbII0DnMtGjB2b?=
 =?us-ascii?Q?rYAC4c9ACmLbakeIBwvK92uDUBjnSQDdjfccCYxzjRo0C+hqKO80PtIAmW6w?=
 =?us-ascii?Q?HGOEa1AS4o30KymrXKm7/LHTSHdKQC63pD2QYj67GlrUCbByOOY6ufvEzs0W?=
 =?us-ascii?Q?/39IL0FjTEUIM0VxM707QqFV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbca2c0a-4004-457d-4cd1-08d8fd4d078d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 00:50:55.5594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DHF/8eQvSXM4nT7fFZv3XlaUI9vNOks+umwSA2UKvkSisD0qAkCZ+06n+e+WXxb4/eo0rt8KX6pzhe7y4Ji6ZHIlWxQ/pOZ7DdSe+Vl1kIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4307
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9951 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120001
X-Proofpoint-ORIG-GUID: HGdMF1CL8hdNekaJLbglaIarxyEVieKy
X-Proofpoint-GUID: HGdMF1CL8hdNekaJLbglaIarxyEVieKy
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9951 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104120001
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

