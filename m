Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5104AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Mar 2022 18:05:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240411AbiC2SHX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 14:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240410AbiC2SHH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 14:07:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68668B18AD
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 11:05:21 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22THsKkj022181;
        Tue, 29 Mar 2022 18:03:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=8fMIAcODqcsveROeeAasOfi0KX01uuN+DK2VguE3psQ=;
 b=kIAJ5YV2aXrxS5RUQg8VKgeSeEunDmIL/G0yxuJH5mIqvADfNUc7lqZF0Y/APdx1AkDA
 TjYilRgl2IfQQsJFHOt4vlJj9sQX1stN9eKbN2yFxeej24SXBon0fH/E0n/pu5OUz3Zo
 5cu4yxbscELxaXz6jOPyVLwVru4kumz1mK2MfEvzAEjqOO6ptJ6Ya+1YyOz8nE1cDz7Q
 JZwkagiQwN+FGeQEcUw3xXAq+OAeBrVQjZEWQvyRycUIZ8zVkOdvJbV4ndrxcY2sbzDK
 cBAhHcINoghnt4Cme1c4aG80qkmjD1YAtjpF52MQr1SxzO7vnlFr8vKBKfTU4CW0bTnV Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1tqb78tg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22THvFJI048570;
        Tue, 29 Mar 2022 18:03:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3020.oracle.com with ESMTP id 3f1v9fhge0-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MvuCQlwA9G040/Usz5QyOQHEHnwuJ0JRi7nNzkS7Rdcxd/UGYl8IcFPHy+S5EzE4IRS+Z/1uGAq0i67RqPvhXBoUwEXfWVVK6BVXwh0Vk2WZdqd0XjsdA1rCpyaG7TrFLY8Io6ltLyBzzW9RpVcXVtG6LtIwVnWxbN8pf+BYYsOIKbjSejCOEYtoA9p5OniqmAijGfxbYylJQQNs7FteOVyd2D/r997CJKSUW5uVRI+d3xumddzl+anjo34EjF4R4UlKgq/ss0SY6ypOCMa5MX9cd59jxvSSWa2+MUxrcrattF7lietykYIOK2qc9+WzpOYgoiUPmZcXbjxghH8ZjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8fMIAcODqcsveROeeAasOfi0KX01uuN+DK2VguE3psQ=;
 b=WmZ0L9S7//FidGAh3yHZmRkv79+uA7IjsO2ytsiDByzgy/kxeAkTlPcV4nEP+qPr1hdivtW1Z0HW0qXKIYYTHeTd8jFcqBSSV6vkmgGS9Sa4Pz6aXS7QLA9O5QD0Vze1FRP0NElgr1tLp5ZApTPUdNdnrIDmHW/yF5/T6+CruKChXvE/AtsZKWndG9fbL4FjD1npQsyJdBVNCIJdI0R31dQaE2Oh4BgcQ6H9duJe+LPJKSUROwcY8XvCZZRA3232V6VQwna5bLwQ3FyYWrSN4onXJQCOmQFGEYOYMOYygcni/gbHd7us1AbzjvOmPWeIrOpw5/5Th0Ji285qGxJcDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8fMIAcODqcsveROeeAasOfi0KX01uuN+DK2VguE3psQ=;
 b=lM9zBQqqDrEFOFTyLfI6Ywk7iRVVNECqRkgNRqZd1AhZ3BVFvE7iEqYswMWSFRbtywMj+scSmiwHBmuLcYdaiX+BzCXxgUEgxIZSwxoZoYwJb5it75xdl2n7plCUaKtSM1rBZ0h5+MmsWUS2wEZqI7NISIq39VhpZyYyBFabzgo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB3584.namprd10.prod.outlook.com (2603:10b6:208:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Tue, 29 Mar
 2022 18:03:38 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2%10]) with mapi id 15.20.5102.023; Tue, 29 Mar
 2022 18:03:38 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Wu Bo <wubo40@huawei.com>
Subject: [PATCH V3 05/15] scsi: iscsi: Rename iscsi_conn_queue_work
Date:   Tue, 29 Mar 2022 13:03:16 -0500
Message-Id: <20220329180326.5586-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220329180326.5586-1-michael.christie@oracle.com>
References: <20220329180326.5586-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR11CA0002.namprd11.prod.outlook.com
 (2603:10b6:3:115::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 884000b1-12a0-4e17-f7ee-08da11ae729b
X-MS-TrafficTypeDiagnostic: MN2PR10MB3584:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB358499BA669AB3A3C797C957F11E9@MN2PR10MB3584.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OSqyPeJQZ4LUohmTMdnZ0WgGj83a3kgw3k9wxiP9SGIwIPtOqrETS9jArV/8FXGEYNXQ/O7GuvVVBdPRmImyXoxHTujIZlIPP3NoyPon1L0w6204B35WYavKL/KEzwFwtt/g3eJYya407W6urHp+YabXCY4Sy2CC33WyNbnT15i9dqbU6iOhmvw8sq9B91q4H22ZdV+Os20lq+p0aM+0yh4mUk3VjK3rAl9sw3iwfKnQsQo0JecjJOPth9iEIxYX9PQz8qwWlj01DbyUoRdBBDZIDRmtq5joVe4K30OeipMUw55OrtGZ65rgUcp9tEiYFfQfDHFB95bsHPjfSjMQGhvRAjEzoCPV1fgTXO8iNcJ8P3VX/MRzgjsM4Gm3OtQFnfqYXOufGI+eEj3aUNJFrxfCUq6vzUlCmZyJPWHgbeJy06cRxE5qr7SBxOHyfUhWlvm9RP7rY5IUaREXmJyvAI6eTzfUjO+VB/1oMZXxoFYu9340VrlAcC7D7CMGuFnD4hgZbIMKcDg3VXLeaqsoQxQcAkPEINoYNR/Hm3s/RvPpbCrCZyyllCzqVWatzJsGy0OjRZ5SPIZoAgCc3++iwd0fTskOA2a2SCtUCCCwKZUSDq8rqmCdsp70S5I3u8BX+mS5vuBeYlP3wbBNqMAoEdd9dLsd9WqlduAAoCcYTaoqQvbLcrdn7EOQGLLbDBQtm2Jc9yCeNhEXuiVneiROHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(54906003)(316002)(8936002)(8676002)(6512007)(66556008)(38100700002)(2616005)(36756003)(508600001)(26005)(6486002)(2906002)(5660300002)(6506007)(52116002)(6666004)(86362001)(83380400001)(4326008)(1076003)(186003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rKFdi6Vf74mP7GZ5qGRZYWoxj5M89OneqXYenDsIg17Mph3Cs3b9uKegnLN7?=
 =?us-ascii?Q?3degpCXLp7ganIgT1JL6+wlvjeX11hA2vanhnoYT5BqVb6q4jrfFXb2mS0VZ?=
 =?us-ascii?Q?9kUxy/NTf85rRP61ZxDR/wlUoq1wc3eqHUEXh2ikmxTIpa3E8TO8bdNH/zx8?=
 =?us-ascii?Q?OMBgOadB6uJq4UmnBwCVGnYWqx8Dt+ZtAf7ZUSi3ESnvqnCO20/jnPWPfd2L?=
 =?us-ascii?Q?4HlwNTNpwo+hBVjylD1fd8/3EdCcOA+ftzVnKJlY12OSHATt0KcT9feynvVC?=
 =?us-ascii?Q?WTdVCcruNMpc8LLvW1WM/yeuzTeGEI+vaaI7BKxmfe6D80iWa4NKjBCa8bmf?=
 =?us-ascii?Q?bus47+OqYXUfUrgn6gtD+CQ+Hsv3yOrHdXzmilrhoVou8GtAdiByQh64Ykcn?=
 =?us-ascii?Q?9NSoe5lRxSiCU9CRo4Cq+9sYnbxd+SMwcAkXkTG7mxBo/RLdNkop3GLiRTDK?=
 =?us-ascii?Q?7u8jZP8GQXojkPLoFuXJIkzsGrO7/ZpSvI0Sbi/7Kz3452ZrUy+4tCzK3WC9?=
 =?us-ascii?Q?hm4JET9GH8tiIEtlmjKlzmDKDYQJ6v3zbIZgmHbShNcDkIL3qHG6RZbj38SG?=
 =?us-ascii?Q?q3SeVcfLrxMtIJ6+oTLmZ5CxN6I6j70MtEZ7YAlNpfVnwHe94K0D9TMoA5va?=
 =?us-ascii?Q?Gbb605O/0WMQpNt+3fImqRR8SgsIEX7sJ/MLi+GdvlxajAUm/oSpMWcne/Df?=
 =?us-ascii?Q?b+IPtJeS8sEteSJ453v1zKbTfMV+qU1Py/ixc80ghAbz1FHQ2v8MPKJhU6iF?=
 =?us-ascii?Q?h0ciyXStZjCdtdmreM7Vn66btuBVOkobSDr0cCecOROHFXkDd/sQzPFPkLmL?=
 =?us-ascii?Q?koBeOciHEMXEMhFQnpDQLuvFmzrznN6szamzPknmVN2ux3wOcyCtbeV2n68c?=
 =?us-ascii?Q?zVK2Mf58iJoIbVG+eH+qY25A7kb/d8Vquxp28RNLVEWSCtrVNHjqMYi1TIHj?=
 =?us-ascii?Q?o5S/zbpXdkS4HOP8lG/DvKvp7PfQVLy+LCJOaSLSXa8QG8PZYuXFedoufbPd?=
 =?us-ascii?Q?990/4oWvMzo7/G8BPEGNiUu6OeMRRfjxKqNpPSCg470XXQR9p93W65jj30pu?=
 =?us-ascii?Q?Rgdzjvo+8ua4MxCMiXcJ3skrLB2wlkb1ReV8U30CLFjlN99xeqoS/+CnIXKi?=
 =?us-ascii?Q?A8jp6wjUTY8/FOzibXUJFiKZG1Bd2Jt+tYh2TPfw11kmn4gVdkp3BHLYTFIv?=
 =?us-ascii?Q?FSgeA3O33ET/HN8VADmyZg7YUJ6/dVM2860qMI7BhB34V8NkYZ3sov19rjFP?=
 =?us-ascii?Q?IlEttHAUgblyIzReIbk6pPkuCas/Q0UB2CO445hNWyCr7UeWjGMEVGAVZjgR?=
 =?us-ascii?Q?HlVtHvMDltdbc5m8WNTXaoqhGZyx5lC+aACSAoPk+rWrO716T0MQ6JUcCzUV?=
 =?us-ascii?Q?Q+elrUAfnNXEa83rU8O7p2vGXMBVXNxrm446ijwxOrqQglvTUnJyQhyV4CFW?=
 =?us-ascii?Q?QRYNpGQVTo8h0LRE9M3uvdUS3kxKi6m0D2eHbzMLaSEU9QxPK964uAEkDNwg?=
 =?us-ascii?Q?fwh9AZQh0XWLy5EpzLpkZqLbLAB1K7jvBOIWP8BZxuHE1lno69xkiaXcn61i?=
 =?us-ascii?Q?wTMlbKY31ZOSAKFQUbLOf/s2jF1z1xUb8Z9y5+0M9QS+m5i9502YqLgaPWrk?=
 =?us-ascii?Q?BzFOjNLezLZyu5l9Quu7/2L6ywafclqcRm2QZSYQtUzJ31CjKK40NsamTzjl?=
 =?us-ascii?Q?mj376z9BIFsBkDTfTYepmjGrPCAKmHm2+qHTWxiiunAyN3uAQXOTRbuHcVMY?=
 =?us-ascii?Q?V7xfpXy7nLzGPeRRBk1yWATM5Yll/Mg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 884000b1-12a0-4e17-f7ee-08da11ae729b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 18:03:37.2558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +vkopJR+f604BWBcwV/GxTmJ1+mHij9D1Q+AcWM1Pb6UVrux+J+hcvcBDQeh2wS5vU/VN+/AegxEdR4RSpwll4qbCeQVIo0vM2aijLlfJ4E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3584
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10301 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203290101
X-Proofpoint-GUID: MHVgRu9sa7h5UZ_zaV8U6t3ekbrWwvtu
X-Proofpoint-ORIG-GUID: MHVgRu9sa7h5UZ_zaV8U6t3ekbrWwvtu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename iscsi_conn_queue_work to iscsi_conn_queue_xmit to reflect it
handles queueing of xmits only.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Wu Bo <wubo40@huawei.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/cxgbi/libcxgbi.c |  2 +-
 drivers/scsi/iscsi_tcp.c      |  2 +-
 drivers/scsi/libiscsi.c       | 12 ++++++------
 include/scsi/libiscsi.h       |  2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 4365d52c6430..411b0d386fad 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1455,7 +1455,7 @@ void cxgbi_conn_tx_open(struct cxgbi_sock *csk)
 	if (conn) {
 		log_debug(1 << CXGBI_DBG_SOCK,
 			"csk 0x%p, cid %d.\n", csk, conn->id);
-		iscsi_conn_queue_work(conn);
+		iscsi_conn_queue_xmit(conn);
 	}
 }
 EXPORT_SYMBOL_GPL(cxgbi_conn_tx_open);
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 9fee70d6434a..c775acc5208d 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -205,7 +205,7 @@ static void iscsi_sw_tcp_write_space(struct sock *sk)
 	old_write_space(sk);
 
 	ISCSI_SW_TCP_DBG(conn, "iscsi_write_space\n");
-	iscsi_conn_queue_work(conn);
+	iscsi_conn_queue_xmit(conn);
 }
 
 static void iscsi_sw_tcp_conn_set_callbacks(struct iscsi_conn *conn)
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 0bf8cf8585bb..f86cad75a68d 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -83,7 +83,7 @@ MODULE_PARM_DESC(debug_libiscsi_eh,
 				"%s " dbg_fmt, __func__, ##arg);	\
 	} while (0);
 
-inline void iscsi_conn_queue_work(struct iscsi_conn *conn)
+inline void iscsi_conn_queue_xmit(struct iscsi_conn *conn)
 {
 	struct Scsi_Host *shost = conn->session->host;
 	struct iscsi_host *ihost = shost_priv(shost);
@@ -91,7 +91,7 @@ inline void iscsi_conn_queue_work(struct iscsi_conn *conn)
 	if (ihost->workq)
 		queue_work(ihost->workq, &conn->xmitwork);
 }
-EXPORT_SYMBOL_GPL(iscsi_conn_queue_work);
+EXPORT_SYMBOL_GPL(iscsi_conn_queue_xmit);
 
 static void __iscsi_update_cmdsn(struct iscsi_session *session,
 				 uint32_t exp_cmdsn, uint32_t max_cmdsn)
@@ -765,7 +765,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			goto free_task;
 	} else {
 		list_add_tail(&task->running, &conn->mgmtqueue);
-		iscsi_conn_queue_work(conn);
+		iscsi_conn_queue_xmit(conn);
 	}
 
 	return task;
@@ -1513,7 +1513,7 @@ void iscsi_requeue_task(struct iscsi_task *task)
 		 */
 		iscsi_put_task(task);
 	}
-	iscsi_conn_queue_work(conn);
+	iscsi_conn_queue_xmit(conn);
 	spin_unlock_bh(&conn->session->frwd_lock);
 }
 EXPORT_SYMBOL_GPL(iscsi_requeue_task);
@@ -1782,7 +1782,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		}
 	} else {
 		list_add_tail(&task->running, &conn->cmdqueue);
-		iscsi_conn_queue_work(conn);
+		iscsi_conn_queue_xmit(conn);
 	}
 
 	session->queued_cmdsn++;
@@ -1963,7 +1963,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
 static void iscsi_start_tx(struct iscsi_conn *conn)
 {
 	clear_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
-	iscsi_conn_queue_work(conn);
+	iscsi_conn_queue_xmit(conn);
 }
 
 /*
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index d0a24779c52d..91672c89a794 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -453,7 +453,7 @@ extern int iscsi_conn_get_addr_param(struct sockaddr_storage *addr,
 				     enum iscsi_param param, char *buf);
 extern void iscsi_suspend_tx(struct iscsi_conn *conn);
 extern void iscsi_suspend_queue(struct iscsi_conn *conn);
-extern void iscsi_conn_queue_work(struct iscsi_conn *conn);
+extern void iscsi_conn_queue_xmit(struct iscsi_conn *conn);
 
 #define iscsi_conn_printk(prefix, _c, fmt, a...) \
 	iscsi_cls_conn_printk(prefix, ((struct iscsi_conn *)_c)->cls_conn, \
-- 
2.25.1

