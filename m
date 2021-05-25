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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC0C2C4707F
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DEBC61408
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhEYSU0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47080 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbhEYSUS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIF6sc052980;
        Tue, 25 May 2021 18:18:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=NOgpDJ6Aw3GfqZAhTBEOzQc5bvcC5AaU5+1Stcp/swA=;
 b=SvgunPWLpgsH73VuCiOLEY+d8Msb3m6N5rxfVsVehgZf7DCEqnhTSfadu/HcBwX9wI/8
 yVbV/dpdgvjl9QtV3XoQ+i8WfgDf55dUIbEF5Bgj6pk0VVpHfKkmFxxrT6X1webf10Di
 oG6nXQ0EBK0BqpWdh0yf1mFPPwPhZIgXb1cp+38sssxR2xaB34IEZsLvmAxDccqj+Qxx
 dA66MZ3pGTef5s3TSjpb0pt7jbJ7adXQ8YIjJje/e802qyxFPt2JT7yAXhECTod6K4ug
 T9vdIrJQkIhTk0ONbAcYEL0GfsjiTMuBhvon2O9v5ouUrbxwx3riSW4cpEXyYf/9Rdkb 1Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38rne42guc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIGD3I010875;
        Tue, 25 May 2021 18:18:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by userp3020.oracle.com with ESMTP id 38qbqsggxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZMDpgh2nmFXLre+Y4fv0aw1CHr4DVtDZ2qbt4diY3CwMbGP9Ya+mZpv4nFTjTeZzX1h1jmnXaQK7J4W1E0mYm0gjEusQ1KxFdGXBBfB32pS9aWK616R6x7mXHecbGGXNIB1ENBs3hiNVDjFobPqKc5vl0awM6XT3hU8pI2Ru8r15wCYTu+jyEPD9J1gLbHC6MUMR1lQVSOAoK55yKLj7a2c9tbZ9w9JKIO2fM+9I9GVbagsMR/MbBaF/48RXljklpSe1LQGmPMuxfZnvY4kCLcTmlG2xD16x0jId9mcqAajYKWVBLrSIr3+epWc6NroLnGoDUdUs07sHSeK4tRAjtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOgpDJ6Aw3GfqZAhTBEOzQc5bvcC5AaU5+1Stcp/swA=;
 b=jvPCil57yJqDYmASQozk1snyO51ghGSKF50TCbFPzaao7+ZdOJQ7kanmVlh+c2KKqQK2rnolHa9dRggGOs4nUTykLwNiMt8i/5Xo1LMmsN7mgUZEvxjzZX7kvKjMOwu1wEFlguETnLjmTKrhpi/M0WROyU0PiziQ7c1HgtIlwsGOikogM6LslYDCVntLkJsArKLj+9R41lF/UiTBovD3gGZ0y8N5b0cJOA7jYXJzYUvJn1LBB4JjAmVinRerUAu75RuGg1vRV7AVwOI7KV5Fr5GOCBpl/Cfxw/Zm9WqsVrgvvBKRUxWbHq4I5tqRGmZiPBPF91TC8dTG5dXFM7WO0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOgpDJ6Aw3GfqZAhTBEOzQc5bvcC5AaU5+1Stcp/swA=;
 b=KD0mp21sOb+vtnrrvdOg095bcTL3k9P9OGnAhJnrdKmOPGJFfEd/55yiHL+0PBdvOa7NslAftQsqy4WevI1HUKoBceXHUf7vOK+JixsClNsyCV752fwc3dWi9RBOQTpgzah3nbpYUClf5m8DsDsBMBX16ciqYdzOoytYqKMd5Mg=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4767.namprd10.prod.outlook.com (2603:10b6:a03:2d1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:36 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:36 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 07/28] scsi: iscsi: Fix in-kernel conn failure handling
Date:   Tue, 25 May 2021 13:18:00 -0500
Message-Id: <20210525181821.7617-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525181821.7617-1-michael.christie@oracle.com>
References: <20210525181821.7617-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:3:ac::13) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86cd51ec-b19f-4c8a-bdbc-08d91fa9835d
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4767:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4767573AD2C02C046B576961F1259@SJ0PR10MB4767.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4tzDLgbxRX0IbM4kZhCGaPYN9nAy1CS6r/Ms4TIkTtydI/AHDkHT2s2ABJIm3FnWJRCsbW5fd852MFEojQmjsb/WJajDZxCLCEzic1zyfOpvjg22l9luJzbLnRLLaBrvgFO+YQVzTiN3w6x4crvHlOF8dWjfY1U7iynLgMurx8hC2iqv8QvOeW5P3oxNwLU2nFieQOmUFnRtfKn9C61xndN3qM+91HGOEqNnb1BvKw/qq2IH3ttQf7YvLReoh4l5FVjb+Wx8lKbKBAu6ZnNJVEpxC69OWsIfGi+xjwLmHlkNemNZX+u+YwYaifil1iNQW9ruNmonYx25a/2jXXhe+tmZcgVA/f51tSNUdgNqQQdCIZY9QMPYJ3EunWLLBkrNjrt8dSpO5zIvQ9Zqw9GhZbpeg2rvtmSt1oIZvuTekUUoUbmqQI15Hxgz1Ko3PS93m3YiTLl39Y9dRRpuiYBF0nIIEuLXUF0w6bQaODph1gwo+ZDNIa/Ht14VAjzLtxWeZIFjIrszHACkYknqpZfGlvMKo5OliS09nX5HQYUg5bCSAz1phC5VLEZloDL/1J5lG19UgMfiH5iEDBXvaMTu53Ners0G6CcE2PqyJEGn1GGWk6x2oZm4iZQKYHQcbxJfvreOkc+V1JzG4xVaMMjAM7S+ciWvdqrJYwTfmW/S1MUH2jXaahtKMDI/GZGTpbTp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(346002)(136003)(366004)(38100700002)(83380400001)(6512007)(26005)(1076003)(4326008)(5660300002)(956004)(6486002)(6666004)(2616005)(30864003)(38350700002)(86362001)(107886003)(36756003)(8676002)(16526019)(8936002)(66476007)(2906002)(66946007)(52116002)(6506007)(316002)(66556008)(478600001)(186003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VgjDgxBn47YAUQcPQg8TTyHdv71ebdoRdh3xxHo6l2a4vd6bvJN0U7coqFpw?=
 =?us-ascii?Q?UJg5/r/j2ep6O8DZPSiC1Ioj8PabNpgQ2mpPEfyPt7GrBl/EG6xghBv19TEz?=
 =?us-ascii?Q?/JuCb54CncZYDhadzEZgJ4WIU+ymOqm6hT4eFrleV3xnoki7MCWwDGgtd/oL?=
 =?us-ascii?Q?UCIviDVCAZH0NcHTk77iI2I/KBT2PEOVD9dmD56XmqnnkT4SvLVxmxShAmzl?=
 =?us-ascii?Q?3xMOM7BI5aTgRA4DYPtOgWfb/VWdMUns3X0oJAJ2FygkO4NfFihIDYKUyj3s?=
 =?us-ascii?Q?7GpFE9lE0Wi6x4Q+dFyc9DLyTjEfgqaO/EvNSSvwHs9I7l4rO19MgxcxTBYb?=
 =?us-ascii?Q?n2ZbJg5bo/YcDZ06DDS4Y/6ggd/TMjxbDvznoGJTnrTWtVqcleLb+G4lF7nd?=
 =?us-ascii?Q?KTDZ7A6R7FcjrUbWgPq9ZMI5V5pBZ+sU8Tkdjh3jR7WIJ1KNWXAbzpIk/gE5?=
 =?us-ascii?Q?6PVpWyZEX2+FGsR1xi09ZX6tNiJRVTDqx8vhiLQr0m/kj5fRBYpAJB4q8bKY?=
 =?us-ascii?Q?V9daczU7jnyx3qpIImC1aKgN26NSAjb9ScNcJgSDwiADg759zuLRUmdTdiSE?=
 =?us-ascii?Q?+EnL4X9MoJbJbXIGzSxSzmhggGHLNLcA540DqsIgII4iTe+B+vonR3DKCjW8?=
 =?us-ascii?Q?AcYbnax2kYhJu9wM+0Plrlkp0/qg48LfdwnjmINM077OKrtr11Tcl0Ah60ND?=
 =?us-ascii?Q?NHIwYrV4j3QHN64t++lxNCU6FjPTGuQY6o6gq1RRHsnDEqkkkWT8FGA0jujV?=
 =?us-ascii?Q?W8uL15RQN4p7IC4Vjhw734jym92blV1/5NzWmlPt8MwvvrEtJo2HXM+nMnQj?=
 =?us-ascii?Q?fysQ4WTGACiQa3r8KDqJkd5u4/7dI878YLsyMjdqhVquxrH6tKq+w3LRzPWf?=
 =?us-ascii?Q?7cJgE5X0Cs+9/k2UQerNbITefajDVV42RXuY9U1nW6KYFhz1G8b5+I702IAo?=
 =?us-ascii?Q?W08QpaY/w4SiDOtFLiu2/tGhuidozbPLz9U4uSKaOQbOX5f0R7yvIL9nX8sA?=
 =?us-ascii?Q?18K/KX5JwLm3b7thsMLK3GlJPvUhSjZmJqNp/tkwRWwJcVrLAzH9S/B5gx/L?=
 =?us-ascii?Q?cGokRkWzQQQX12xeggcEbGq5S8yc8W6WIo541fBideU480nPr4STjDGf2GV5?=
 =?us-ascii?Q?aDNfMR63S/NbZtHqPxlKe8XbahF11OlZqNmUKYXaSW1PYerBnd+uRJ2Mws1t?=
 =?us-ascii?Q?TPDS/CKeQbRLzI+9csjhANCvH5yBQ0BVixfOvofSW2gmxNb9tvQCkPlsJu7W?=
 =?us-ascii?Q?58su/uIMABW1tMiC0vKqiOaiwEjYOgJw1iDoAie+GnTbFbJVQX3Kpei5Z9Ii?=
 =?us-ascii?Q?dj7Shgcr/BvS4lLH4123HOpx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86cd51ec-b19f-4c8a-bdbc-08d91fa9835d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:36.5697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DmDhq9pjsBqgQFbPY/bIhIPvBFU072au9SbbccSBoias9bqpG8mHuYGfRGKwRN0RFWcBVFpEznd/s9/HF3hJNeg1J4zgX/pbrjWyos+OLMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4767
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-ORIG-GUID: jD0PmOHX-FZ7wrW6V--j9KPEJplZKKXG
X-Proofpoint-GUID: jD0PmOHX-FZ7wrW6V--j9KPEJplZKKXG
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The commit 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely
in kernel space") has the following regressions/bugs that this patch fixes:

1. It can return cmds to upper layers like dm-multipath where that can
retry them. After they are successful the fs/app can send new IO to the
same sectors, but we've left the cmds running in FW or in the net layer.
We need to be calling ep_disconnect if userspace is not up.

This patch only fixes the issue for offload drivers. iscsi_tcp will be
fixed in separate patch because it doesn't have a ep_disconnect call.

2. The drivers that implement ep_disconnect expect that it's called before
conn_stop. Besides crashes, if the cleanup_task callout is called before
ep_disconnect it might free up driver/card resources for session1 then
they could be allocated for session2. But because the driver's
ep_disconnect is not called it has not cleaned up the firmware so the card
is still using the resources for the original cmd.

3. The stop_conn_work_fn can run after userspace has done it's recovery
and we are happily using the session. We will then end up with various
bugs depending on what is going on at the time.

We may also run stop_conn_work_fn late after userspace has called
stop_conn and ep_disconnect and is now going to call start/bind conn. If
stop_conn_work_fn runs after bind but before start, we would leave the
conn in a unbound but sort of started state where IO might be allowed
even though the drivers have been set in a state where they no longer
expect IO.

4. returning -EAGAIN in iscsi_if_destroy_conn if we haven't yet run the in
kernel stop_conn function is breaking userspace. We should have been doing
this for the caller.

Fixes: 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
kernel space")
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 471 ++++++++++++++++------------
 include/scsi/scsi_transport_iscsi.h |  10 +-
 2 files changed, 283 insertions(+), 198 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index bab6654d8ee9..b8a93e607891 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -86,15 +86,11 @@ struct iscsi_internal {
 	struct transport_container session_cont;
 };
 
-/* Worker to perform connection failure on unresponsive connections
- * completely in kernel space.
- */
-static void stop_conn_work_fn(struct work_struct *work);
-static DECLARE_WORK(stop_conn_work, stop_conn_work_fn);
-
 static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
 static struct workqueue_struct *iscsi_eh_timer_workq;
 
+static struct workqueue_struct *iscsi_conn_cleanup_workq;
+
 static DEFINE_IDA(iscsi_sess_ida);
 /*
  * list of registered transports and lock that must
@@ -1623,12 +1619,6 @@ static DECLARE_TRANSPORT_CLASS(iscsi_connection_class,
 static struct sock *nls;
 static DEFINE_MUTEX(rx_queue_mutex);
 
-/*
- * conn_mutex protects the {start,bind,stop,destroy}_conn from racing
- * against the kernel stop_connection recovery mechanism
- */
-static DEFINE_MUTEX(conn_mutex);
-
 static LIST_HEAD(sesslist);
 static DEFINE_SPINLOCK(sesslock);
 static LIST_HEAD(connlist);
@@ -2245,6 +2235,123 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
 }
 EXPORT_SYMBOL_GPL(iscsi_remove_session);
 
+static void iscsi_stop_conn(struct iscsi_cls_conn *conn, int flag)
+{
+	ISCSI_DBG_TRANS_CONN(conn, "Stopping conn.\n");
+
+	switch (flag) {
+	case STOP_CONN_RECOVER:
+		conn->state = ISCSI_CONN_FAILED;
+		break;
+	case STOP_CONN_TERM:
+		conn->state = ISCSI_CONN_DOWN;
+		break;
+	default:
+		iscsi_cls_conn_printk(KERN_ERR, conn, "invalid stop flag %d\n",
+				      flag);
+		return;
+	}
+
+	conn->transport->stop_conn(conn, flag);
+	ISCSI_DBG_TRANS_CONN(conn, "Stopping conn done.\n");
+}
+
+static int iscsi_if_stop_conn(struct iscsi_transport *transport,
+			      struct iscsi_uevent *ev)
+{
+	int flag = ev->u.stop_conn.flag;
+	struct iscsi_cls_conn *conn;
+
+	conn = iscsi_conn_lookup(ev->u.stop_conn.sid, ev->u.stop_conn.cid);
+	if (!conn)
+		return -EINVAL;
+
+	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop.\n");
+	/*
+	 * If this is a termination we have to call stop_conn with that flag
+	 * so the correct states get set. If we haven't run the work yet try to
+	 * avoid the extra run.
+	 */
+	if (flag == STOP_CONN_TERM) {
+		cancel_work_sync(&conn->cleanup_work);
+		iscsi_stop_conn(conn, flag);
+	} else {
+		/*
+		 * Figure out if it was the kernel or userspace initiating this.
+		 */
+		if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
+			iscsi_stop_conn(conn, flag);
+		} else {
+			ISCSI_DBG_TRANS_CONN(conn,
+					     "flush kernel conn cleanup.\n");
+			flush_work(&conn->cleanup_work);
+		}
+		/*
+		 * Only clear for recovery to avoid extra cleanup runs during
+		 * termination.
+		 */
+		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
+	}
+	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop done.\n");
+	return 0;
+}
+
+static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
+{
+	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
+	struct iscsi_endpoint *ep;
+
+	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
+	conn->state = ISCSI_CONN_FAILED;
+
+	if (!conn->ep || !session->transport->ep_disconnect)
+		return;
+
+	ep = conn->ep;
+	conn->ep = NULL;
+
+	session->transport->unbind_conn(conn, is_active);
+	session->transport->ep_disconnect(ep);
+	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
+}
+
+static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
+{
+	struct iscsi_cls_conn *conn = container_of(work, struct iscsi_cls_conn,
+						   cleanup_work);
+	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
+
+	mutex_lock(&conn->ep_mutex);
+	/*
+	 * If we are not at least bound there is nothing for us to do. Userspace
+	 * will do a ep_disconnect call if offload is used, but will not be
+	 * doing a stop since there is nothing to clean up, so we have to clear
+	 * the cleanup bit here.
+	 */
+	if (conn->state != ISCSI_CONN_BOUND && conn->state != ISCSI_CONN_UP) {
+		ISCSI_DBG_TRANS_CONN(conn, "Got error while conn is already failed. Ignoring.\n");
+		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
+		mutex_unlock(&conn->ep_mutex);
+		return;
+	}
+
+	iscsi_ep_disconnect(conn, false);
+
+	if (system_state != SYSTEM_RUNNING) {
+		/*
+		 * If the user has set up for the session to never timeout
+		 * then hang like they wanted. For all other cases fail right
+		 * away since userspace is not going to relogin.
+		 */
+		if (session->recovery_tmo > 0)
+			session->recovery_tmo = 0;
+	}
+
+	iscsi_stop_conn(conn, STOP_CONN_RECOVER);
+	mutex_unlock(&conn->ep_mutex);
+	ISCSI_DBG_TRANS_CONN(conn, "cleanup done.\n");
+}
+
 void iscsi_free_session(struct iscsi_cls_session *session)
 {
 	ISCSI_DBG_TRANS_SESSION(session, "Freeing session\n");
@@ -2284,7 +2391,7 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
 
 	mutex_init(&conn->ep_mutex);
 	INIT_LIST_HEAD(&conn->conn_list);
-	INIT_LIST_HEAD(&conn->conn_list_err);
+	INIT_WORK(&conn->cleanup_work, iscsi_cleanup_conn_work_fn);
 	conn->transport = transport;
 	conn->cid = cid;
 	conn->state = ISCSI_CONN_DOWN;
@@ -2341,7 +2448,6 @@ int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
 
 	spin_lock_irqsave(&connlock, flags);
 	list_del(&conn->conn_list);
-	list_del(&conn->conn_list_err);
 	spin_unlock_irqrestore(&connlock, flags);
 
 	transport_unregister_device(&conn->dev);
@@ -2456,83 +2562,6 @@ int iscsi_offload_mesg(struct Scsi_Host *shost,
 }
 EXPORT_SYMBOL_GPL(iscsi_offload_mesg);
 
-/*
- * This can be called without the rx_queue_mutex, if invoked by the kernel
- * stop work. But, in that case, it is guaranteed not to race with
- * iscsi_destroy by conn_mutex.
- */
-static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
-{
-	/*
-	 * It is important that this path doesn't rely on
-	 * rx_queue_mutex, otherwise, a thread doing allocation on a
-	 * start_session/start_connection could sleep waiting on a
-	 * writeback to a failed iscsi device, that cannot be recovered
-	 * because the lock is held.  If we don't hold it here, the
-	 * kernel stop_conn_work_fn has a chance to stop the broken
-	 * session and resolve the allocation.
-	 *
-	 * Still, the user invoked .stop_conn() needs to be serialized
-	 * with stop_conn_work_fn by a private mutex.  Not pretty, but
-	 * it works.
-	 */
-	mutex_lock(&conn_mutex);
-	switch (flag) {
-	case STOP_CONN_RECOVER:
-		conn->state = ISCSI_CONN_FAILED;
-		break;
-	case STOP_CONN_TERM:
-		conn->state = ISCSI_CONN_DOWN;
-		break;
-	default:
-		iscsi_cls_conn_printk(KERN_ERR, conn,
-				      "invalid stop flag %d\n", flag);
-		goto unlock;
-	}
-
-	conn->transport->stop_conn(conn, flag);
-unlock:
-	mutex_unlock(&conn_mutex);
-}
-
-static void stop_conn_work_fn(struct work_struct *work)
-{
-	struct iscsi_cls_conn *conn, *tmp;
-	unsigned long flags;
-	LIST_HEAD(recovery_list);
-
-	spin_lock_irqsave(&connlock, flags);
-	if (list_empty(&connlist_err)) {
-		spin_unlock_irqrestore(&connlock, flags);
-		return;
-	}
-	list_splice_init(&connlist_err, &recovery_list);
-	spin_unlock_irqrestore(&connlock, flags);
-
-	list_for_each_entry_safe(conn, tmp, &recovery_list, conn_list_err) {
-		uint32_t sid = iscsi_conn_get_sid(conn);
-		struct iscsi_cls_session *session;
-
-		session = iscsi_session_lookup(sid);
-		if (session) {
-			if (system_state != SYSTEM_RUNNING) {
-				/*
-				 * If the user has set up for the session to
-				 * never timeout then hang like they wanted.
-				 * For all other cases fail right away since
-				 * userspace is not going to relogin.
-				 */
-				if (session->recovery_tmo > 0)
-					session->recovery_tmo = 0;
-			}
-
-			iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
-		}
-
-		list_del_init(&conn->conn_list_err);
-	}
-}
-
 void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
 {
 	struct nlmsghdr	*nlh;
@@ -2540,12 +2569,9 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
 	struct iscsi_uevent *ev;
 	struct iscsi_internal *priv;
 	int len = nlmsg_total_size(sizeof(*ev));
-	unsigned long flags;
 
-	spin_lock_irqsave(&connlock, flags);
-	list_add(&conn->conn_list_err, &connlist_err);
-	spin_unlock_irqrestore(&connlock, flags);
-	queue_work(system_unbound_wq, &stop_conn_work);
+	if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags))
+		queue_work(iscsi_conn_cleanup_workq, &conn->cleanup_work);
 
 	priv = iscsi_if_transport_lookup(conn->transport);
 	if (!priv)
@@ -2875,26 +2901,17 @@ static int
 iscsi_if_destroy_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 {
 	struct iscsi_cls_conn *conn;
-	unsigned long flags;
 
 	conn = iscsi_conn_lookup(ev->u.d_conn.sid, ev->u.d_conn.cid);
 	if (!conn)
 		return -EINVAL;
 
-	spin_lock_irqsave(&connlock, flags);
-	if (!list_empty(&conn->conn_list_err)) {
-		spin_unlock_irqrestore(&connlock, flags);
-		return -EAGAIN;
-	}
-	spin_unlock_irqrestore(&connlock, flags);
-
+	ISCSI_DBG_TRANS_CONN(conn, "Flushing cleanup during destruction\n");
+	flush_work(&conn->cleanup_work);
 	ISCSI_DBG_TRANS_CONN(conn, "Destroying transport conn\n");
 
-	mutex_lock(&conn_mutex);
 	if (transport->destroy_conn)
 		transport->destroy_conn(conn);
-	mutex_unlock(&conn_mutex);
-
 	return 0;
 }
 
@@ -2973,7 +2990,7 @@ static int iscsi_if_ep_connect(struct iscsi_transport *transport,
 }
 
 static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
-				  u64 ep_handle, bool is_active)
+				  u64 ep_handle)
 {
 	struct iscsi_cls_conn *conn;
 	struct iscsi_endpoint *ep;
@@ -2984,17 +3001,30 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 	ep = iscsi_lookup_endpoint(ep_handle);
 	if (!ep)
 		return -EINVAL;
+
 	conn = ep->conn;
-	if (conn) {
-		mutex_lock(&conn->ep_mutex);
-		conn->ep = NULL;
+	if (!conn) {
+		/*
+		 * conn was not even bound yet, so we can't get iscsi conn
+		 * failures yet.
+		 */
+		transport->ep_disconnect(ep);
+		goto put_ep;
+	}
+
+	mutex_lock(&conn->ep_mutex);
+	/* Check if this was a conn error and the kernel took ownership */
+	if (test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
+		ISCSI_DBG_TRANS_CONN(conn, "flush kernel conn cleanup.\n");
 		mutex_unlock(&conn->ep_mutex);
-		conn->state = ISCSI_CONN_FAILED;
 
-		transport->unbind_conn(conn, is_active);
+		flush_work(&conn->cleanup_work);
+		goto put_ep;
 	}
 
-	transport->ep_disconnect(ep);
+	iscsi_ep_disconnect(conn, false);
+	mutex_unlock(&conn->ep_mutex);
+put_ep:
 	iscsi_put_endpoint(ep);
 	return 0;
 }
@@ -3025,8 +3055,7 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
 		break;
 	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
 		rc = iscsi_if_ep_disconnect(transport,
-					    ev->u.ep_disconnect.ep_handle,
-					    false);
+					    ev->u.ep_disconnect.ep_handle);
 		break;
 	}
 	return rc;
@@ -3653,18 +3682,129 @@ iscsi_get_host_stats(struct iscsi_transport *transport, struct nlmsghdr *nlh)
 	return err;
 }
 
+static int iscsi_if_transport_conn(struct iscsi_transport *transport,
+				   struct nlmsghdr *nlh)
+{
+	struct iscsi_uevent *ev = nlmsg_data(nlh);
+	struct iscsi_cls_session *session;
+	struct iscsi_cls_conn *conn = NULL;
+	struct iscsi_endpoint *ep;
+	uint32_t pdu_len;
+	int err = 0;
+
+	switch (nlh->nlmsg_type) {
+	case ISCSI_UEVENT_CREATE_CONN:
+		return iscsi_if_create_conn(transport, ev);
+	case ISCSI_UEVENT_DESTROY_CONN:
+		return iscsi_if_destroy_conn(transport, ev);
+	case ISCSI_UEVENT_STOP_CONN:
+		return iscsi_if_stop_conn(transport, ev);
+	}
+
+	/*
+	 * The following cmds need to be run under the ep_mutex so in kernel
+	 * conn cleanup (ep_disconnect + unbind and conn) is not done while
+	 * these are running. They also must not run if we have just run a conn
+	 * cleanup because they would set the state in a way that might allow
+	 * IO or send IO themselves.
+	 */
+	switch (nlh->nlmsg_type) {
+	case ISCSI_UEVENT_START_CONN:
+		conn = iscsi_conn_lookup(ev->u.start_conn.sid,
+					 ev->u.start_conn.cid);
+		break;
+	case ISCSI_UEVENT_BIND_CONN:
+		conn = iscsi_conn_lookup(ev->u.b_conn.sid, ev->u.b_conn.cid);
+		break;
+	case ISCSI_UEVENT_SEND_PDU:
+		conn = iscsi_conn_lookup(ev->u.send_pdu.sid, ev->u.send_pdu.cid);
+		break;
+	}
+
+	if (!conn)
+		return -EINVAL;
+
+	mutex_lock(&conn->ep_mutex);
+	if (test_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags)) {
+		mutex_unlock(&conn->ep_mutex);
+		ev->r.retcode = -ENOTCONN;
+		return 0;
+	}
+
+	switch (nlh->nlmsg_type) {
+	case ISCSI_UEVENT_BIND_CONN:
+		if (conn->ep) {
+			/*
+			 * For offload boot support where iscsid is restarted
+			 * during the pivot root stage, the ep will be intact
+			 * here when the new iscsid instance starts up and
+			 * reconnects.
+			 */
+			iscsi_ep_disconnect(conn, true);
+		}
+
+		session = iscsi_session_lookup(ev->u.b_conn.sid);
+		if (!session) {
+			err = -EINVAL;
+			break;
+		}
+
+		ev->r.retcode =	transport->bind_conn(session, conn,
+						ev->u.b_conn.transport_eph,
+						ev->u.b_conn.is_leading);
+		if (!ev->r.retcode)
+			conn->state = ISCSI_CONN_BOUND;
+
+		if (ev->r.retcode || !transport->ep_connect)
+			break;
+
+		ep = iscsi_lookup_endpoint(ev->u.b_conn.transport_eph);
+		if (ep) {
+			ep->conn = conn;
+			conn->ep = ep;
+			iscsi_put_endpoint(ep);
+		} else {
+			err = -ENOTCONN;
+			iscsi_cls_conn_printk(KERN_ERR, conn,
+					      "Could not set ep conn binding\n");
+		}
+		break;
+	case ISCSI_UEVENT_START_CONN:
+		ev->r.retcode = transport->start_conn(conn);
+		if (!ev->r.retcode)
+			conn->state = ISCSI_CONN_UP;
+		break;
+	case ISCSI_UEVENT_SEND_PDU:
+		pdu_len = nlh->nlmsg_len - sizeof(*nlh) - sizeof(*ev);
+
+		if ((ev->u.send_pdu.hdr_size > pdu_len) ||
+		    (ev->u.send_pdu.data_size > (pdu_len - ev->u.send_pdu.hdr_size))) {
+			err = -EINVAL;
+			break;
+		}
+
+		ev->r.retcode =	transport->send_pdu(conn,
+				(struct iscsi_hdr *)((char *)ev + sizeof(*ev)),
+				(char *)ev + sizeof(*ev) + ev->u.send_pdu.hdr_size,
+				ev->u.send_pdu.data_size);
+		break;
+	default:
+		err = -ENOSYS;
+	}
+
+	mutex_unlock(&conn->ep_mutex);
+	return err;
+}
 
 static int
 iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 {
 	int err = 0;
 	u32 portid;
-	u32 pdu_len;
 	struct iscsi_uevent *ev = nlmsg_data(nlh);
 	struct iscsi_transport *transport = NULL;
 	struct iscsi_internal *priv;
 	struct iscsi_cls_session *session;
-	struct iscsi_cls_conn *conn;
 	struct iscsi_endpoint *ep = NULL;
 
 	if (!netlink_capable(skb, CAP_SYS_ADMIN))
@@ -3741,90 +3881,16 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 		else
 			err = -EINVAL;
 		break;
-	case ISCSI_UEVENT_CREATE_CONN:
-		err = iscsi_if_create_conn(transport, ev);
-		break;
-	case ISCSI_UEVENT_DESTROY_CONN:
-		err = iscsi_if_destroy_conn(transport, ev);
-		break;
-	case ISCSI_UEVENT_BIND_CONN:
-		session = iscsi_session_lookup(ev->u.b_conn.sid);
-		conn = iscsi_conn_lookup(ev->u.b_conn.sid, ev->u.b_conn.cid);
-
-		if (conn && conn->ep)
-			iscsi_if_ep_disconnect(transport, conn->ep->id, true);
-
-		if (!session || !conn) {
-			err = -EINVAL;
-			break;
-		}
-
-		mutex_lock(&conn_mutex);
-		ev->r.retcode =	transport->bind_conn(session, conn,
-						ev->u.b_conn.transport_eph,
-						ev->u.b_conn.is_leading);
-		if (!ev->r.retcode)
-			conn->state = ISCSI_CONN_BOUND;
-		mutex_unlock(&conn_mutex);
-
-		if (ev->r.retcode || !transport->ep_connect)
-			break;
-
-		ep = iscsi_lookup_endpoint(ev->u.b_conn.transport_eph);
-		if (ep) {
-			ep->conn = conn;
-
-			mutex_lock(&conn->ep_mutex);
-			conn->ep = ep;
-			mutex_unlock(&conn->ep_mutex);
-			iscsi_put_endpoint(ep);
-		} else
-			iscsi_cls_conn_printk(KERN_ERR, conn,
-					      "Could not set ep conn "
-					      "binding\n");
-		break;
 	case ISCSI_UEVENT_SET_PARAM:
 		err = iscsi_set_param(transport, ev);
 		break;
-	case ISCSI_UEVENT_START_CONN:
-		conn = iscsi_conn_lookup(ev->u.start_conn.sid, ev->u.start_conn.cid);
-		if (conn) {
-			mutex_lock(&conn_mutex);
-			ev->r.retcode = transport->start_conn(conn);
-			if (!ev->r.retcode)
-				conn->state = ISCSI_CONN_UP;
-			mutex_unlock(&conn_mutex);
-		}
-		else
-			err = -EINVAL;
-		break;
+	case ISCSI_UEVENT_CREATE_CONN:
+	case ISCSI_UEVENT_DESTROY_CONN:
 	case ISCSI_UEVENT_STOP_CONN:
-		conn = iscsi_conn_lookup(ev->u.stop_conn.sid, ev->u.stop_conn.cid);
-		if (conn)
-			iscsi_if_stop_conn(conn, ev->u.stop_conn.flag);
-		else
-			err = -EINVAL;
-		break;
+	case ISCSI_UEVENT_START_CONN:
+	case ISCSI_UEVENT_BIND_CONN:
 	case ISCSI_UEVENT_SEND_PDU:
-		pdu_len = nlh->nlmsg_len - sizeof(*nlh) - sizeof(*ev);
-
-		if ((ev->u.send_pdu.hdr_size > pdu_len) ||
-		    (ev->u.send_pdu.data_size > (pdu_len - ev->u.send_pdu.hdr_size))) {
-			err = -EINVAL;
-			break;
-		}
-
-		conn = iscsi_conn_lookup(ev->u.send_pdu.sid, ev->u.send_pdu.cid);
-		if (conn) {
-			mutex_lock(&conn_mutex);
-			ev->r.retcode =	transport->send_pdu(conn,
-				(struct iscsi_hdr*)((char*)ev + sizeof(*ev)),
-				(char*)ev + sizeof(*ev) + ev->u.send_pdu.hdr_size,
-				ev->u.send_pdu.data_size);
-			mutex_unlock(&conn_mutex);
-		}
-		else
-			err = -EINVAL;
+		err = iscsi_if_transport_conn(transport, nlh);
 		break;
 	case ISCSI_UEVENT_GET_STATS:
 		err = iscsi_if_get_stats(transport, nlh);
@@ -4827,8 +4893,18 @@ static __init int iscsi_transport_init(void)
 		goto release_nls;
 	}
 
+	iscsi_conn_cleanup_workq = alloc_workqueue("%s",
+			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_UNBOUND, 0,
+			"iscsi_conn_cleanup");
+	if (!iscsi_conn_cleanup_workq) {
+		err = -ENOMEM;
+		goto destroy_wq;
+	}
+
 	return 0;
 
+destroy_wq:
+	destroy_workqueue(iscsi_eh_timer_workq);
 release_nls:
 	netlink_kernel_release(nls);
 unregister_flashnode_bus:
@@ -4850,6 +4926,7 @@ static __init int iscsi_transport_init(void)
 
 static void __exit iscsi_transport_exit(void)
 {
+	destroy_workqueue(iscsi_conn_cleanup_workq);
 	destroy_workqueue(iscsi_eh_timer_workq);
 	netlink_kernel_release(nls);
 	bus_unregister(&iscsi_flashnode_bus);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index d36a72cf049f..3974329d4d02 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -197,15 +197,23 @@ enum iscsi_connection_state {
 	ISCSI_CONN_BOUND,
 };
 
+#define ISCSI_CLS_CONN_BIT_CLEANUP	1
+
 struct iscsi_cls_conn {
 	struct list_head conn_list;	/* item in connlist */
-	struct list_head conn_list_err;	/* item in connlist_err */
 	void *dd_data;			/* LLD private data */
 	struct iscsi_transport *transport;
 	uint32_t cid;			/* connection id */
+	/*
+	 * This protects the conn startup and binding/unbinding of the ep to
+	 * the conn. Unbinding includes ep_disconnect and stop_conn.
+	 */
 	struct mutex ep_mutex;
 	struct iscsi_endpoint *ep;
 
+	unsigned long flags;
+	struct work_struct cleanup_work;
+
 	struct device dev;		/* sysfs transport/container device */
 	enum iscsi_connection_state state;
 };
-- 
2.25.1

