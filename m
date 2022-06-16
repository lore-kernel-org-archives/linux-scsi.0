Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32583C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 22:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379133AbiFPWqg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 18:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379155AbiFPWqV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 18:46:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71D062207
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 15:46:20 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GJNLVl022339;
        Thu, 16 Jun 2022 22:46:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=xAH0fWq0MiEG/RRAMmz5Fy8/aXlzVNJ6t8P8ObwRJZg=;
 b=FVmzc/JemWB6alpi+0/7k0dpsNKQv8OLQHW/+VlgDGh8iEeUq8CpYiK+igIWxoaOARz2
 enuCYy6Va/bsWpZltf9Onkc1YP5E+TVMJEQMtYyLoTs1jVkjGr9dMiPp87vQMjBXNsS8
 s3ZU4CHhJ1iLbd4dTFbVNZLxSi3S35fj7Che+7g4Abs8JSAJGgBB49y2dId7gdlGotpU
 Swa4j/Gb9lUUh9UzPPYKjOAHXQJSdBufc7zxEmnduhk9Ta7keIbxQrvWWc6OWgbl0VSg
 /Crp4Sfyz10aTXyPl0CQT/nlzbAgsNRbmmFq0BmxPcrWO0CR1/1SIvu0QRWoIl2G0KMM Hg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhfcvcfs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:46:08 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25GMaQMZ003820;
        Thu, 16 Jun 2022 22:46:07 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gprbtax08-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:46:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kn3Ik29FcqLHlBNLuGYIre7RdWYF8KsMahvUGgjdQJvO3VRwVzlAZsYCBfdARrxBeG0kWnS+abkp5TR9oAk7N1mCCbjF7Bi6teNpM3qbmZV3yQjrdLnBIwFPz7T9Kubs0ncobLfKfc33FUODmh2WgP7t8KKHOGXaawOe7wLVogzE/dcMMdXBQMzg9HltKCAsi2eZ0tiabR0o+Y81RhvTBTyA5X22gkQOgyFfAVTdMDAowOueQpq//yc+JNUA2gEkvDILETqMRm4LaczJU7dP0Z2XhIUvAVGtMcqP/eY40A6qsQBxJtpsUVaRCTyAHHdOzY0FALjFHwPRsgC1Y8sMVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xAH0fWq0MiEG/RRAMmz5Fy8/aXlzVNJ6t8P8ObwRJZg=;
 b=Y1gnqXB1W6XFMPevDD2qFzck/8SbU6QdV+WTQxBPsJ/JIR86dhFI7N4ZkrdKg13YGZs8F4drFYiD9xxNh98Moxe8OD6SZwzKXWUzWHbDCqR7+r1LY2iD4I+Zp7FnLJzSU8tbsF7rugwaBHJRjCYehzD/W4xXmYQh4hhbw2axISdB0+ygtGz4jFwKrQv1wZ6HWyk7RXJSmpiraQzC+4ex25wdacATJqG6XRNo8ez14ayzImv2/FNPbmDO7Mdom3RvAAlSudFFxAK0ooqCa0MxRlpqhrp5LCV2i/53hIJSzA7IFOpXj8F1A/xZPItNdwkRmnEbkOT5JIh8lEF7g3GO+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xAH0fWq0MiEG/RRAMmz5Fy8/aXlzVNJ6t8P8ObwRJZg=;
 b=spFVwPI9tMrt2gwrtDIHRKIIPsI/jps/6RtcNnmMXV96gspViVR3jULY3zkCu3WroEry6+uEV+DBDlhpep3Xf1rqzQJ9zLvOn9j/MSz1nBIQrWu8KKO6RLRbzlHBhIJTesp2qfVjNZchgkExSisLg/NbHQfS697J9vBdEOFuDlw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB3597.namprd10.prod.outlook.com (2603:10b6:208:117::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Thu, 16 Jun
 2022 22:46:05 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Thu, 16 Jun 2022
 22:46:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Wu Bo <wubo40@huawei.com>
Subject: [PATCH 1/9] scsi: iscsi: Rename iscsi_conn_queue_work()
Date:   Thu, 16 Jun 2022 17:45:49 -0500
Message-Id: <20220616224557.115234-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220616224557.115234-1-michael.christie@oracle.com>
References: <20220616224557.115234-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0264.namprd03.prod.outlook.com
 (2603:10b6:5:3b3::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74f1629a-7b5d-431b-b707-08da4fe9ff4b
X-MS-TrafficTypeDiagnostic: MN2PR10MB3597:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3597950AE12DDCB205DA90B7F1AC9@MN2PR10MB3597.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ameCtmcyHz+Ts1A5d5YeB7/VQeJv9nB2Nf3aVf641WwarBWnx5XteDUBXwf2erQBDQj9ASk3Z6z/gpUVaq8cKzgSjOfsK1zoCixevIfGsKh96KdBFKpPoLgRUTtdli3nuWIc/USn2EhX1Xkgdg0oQNcDzs6UPGOYgqh0Zb5f/U+mPouGIeSIoCfUX4IXcFGHrsx2erV5D9qZqM/t4k9ZJy4FltsODNO3jFnmrkPSX5ZDh63vSwFwUZ3wTVXs3ElJoTRybe6kiqgJuDU6M+LJ2iovNYiq4GHl3TKD1XTfiJKrMvDn2kvKSbRfsJeIvDrrjOsk4mLc1ln6Y2XAIeuxQ8QenoJozEZNA9V3k3sus077kbphorKAqEOaaQmoJDNE3YGDQZVZVfa8PdTfY2iS+dQN+HoErVkVB+ezRL4s2111DrVScSeSC1/g3xFdFjLeo/1I6IEnQPRETY9ZpYSkr99/LNeSrebFHSZsEFiFTB+/qC/3hpFQgzvjTJGbM6mgk+/UidAEIfqKP4QxLl2dZX6IoLej2iy/5XsARc5+W0CVgz4txnKWCe1DuWLz8BBUOOds4O5g0kjuO+Z6t/Amzx/7WLqYbIyhV6f8UdJs0nJt0Yw083FDHnzIY1xdNRJIOiV4PozzsaiyHcSUkn2eFI2qq+cprkFDHp+VO+LsOpzleKXkDa/5lniup68M5L0RHZk87X0IJz/JV7B2bHbJiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(66946007)(66556008)(6666004)(4326008)(66476007)(8676002)(2616005)(54906003)(26005)(6486002)(86362001)(508600001)(83380400001)(186003)(36756003)(1076003)(8936002)(316002)(52116002)(2906002)(5660300002)(38350700002)(6512007)(6506007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xI5xax7YnDVuO3cnOxCuRUGJBFh0tevRzC1TC4dTz+LJ14aC/BfFfOOhine3?=
 =?us-ascii?Q?gmjVETL2kDLuZfCbikVqVQv9Vf4PVwBaIE3WMdeoTrrgggbPER1Ctx5aMlfS?=
 =?us-ascii?Q?PaNkUbRjDg914wzN2iKA0N7ibfHvH9Eh4AxC+UPj2wzWdneQVj7oI2+FaDop?=
 =?us-ascii?Q?z6JyMp4+13/PV3f+1+yom25RUjLnRHSS+gcHe7zR6vHNzttbJYT3hq8FTDIO?=
 =?us-ascii?Q?H6FGOIxeky9LyQ39UI64KRb0S8OlAq7g7LOVkYIE6a9Gzk1uYlUVyTThC9MN?=
 =?us-ascii?Q?8HTsCV4V7RqaqWAscmS916dfBOmjSgFQNtjiyMZiiN66t6bbKOaNkbNS9Ghm?=
 =?us-ascii?Q?FVZ2q97tx/NKWeQkY8B1GB2IZHLMnZ7k4dGZBz8pQBGct4uFXXQ5FzDbUR6e?=
 =?us-ascii?Q?t3ZEnHsThT4VZ8fqXTPHiQ3tGCrB8+gkvvUi2sAeInN3DmYd/CKdlNE7ccYs?=
 =?us-ascii?Q?MIKWjYcKnlNFtimtTE1ee/TsbZGeLyuNPIEipBrgMt4Wzq7YqeupV7W2etzz?=
 =?us-ascii?Q?teB2sEM8oVw4I/M5v9SpZ0fcyrIKhprgn6nwSbTRSV7IVyyWtv39Fm8ul3tZ?=
 =?us-ascii?Q?mmXAQbeaQCQq04vr0a/lQOVS9eHFktb9xGidZ+vBSjEtDREY4BEaa6CqqBSi?=
 =?us-ascii?Q?5FC/SUrQkyTe3klkAtBx0LM8Oz78NfWa+3qyjN/3iuT9JOcievgz1gZhCCtU?=
 =?us-ascii?Q?PopeGJk1NQX0PGBuc7wZw6uO5+G4VPSLP43/KohgmwuzOLSQirYffN84YhLH?=
 =?us-ascii?Q?lwZ27yl20cAmycyPJztUZ1PNq5JLptxBETGvDPc1CQDfkx52WwdLYAz9BIum?=
 =?us-ascii?Q?Hc1nIHAqC98cDcJ9U0z6h12vbtVg0ayId0VF1UdFHGTBF8WqyH9bu6F2BOZ6?=
 =?us-ascii?Q?ps0HIK+ThZya2jTrUH9X/EHxAWgs3y76tC9B+iPpbrlkgJioeYmbRxnV/a4a?=
 =?us-ascii?Q?Ga3VSOYUqRr/p47p6ki9JKcvrF9CfigsBeun8rb7D5gipqZy9KxAaWp/x/eD?=
 =?us-ascii?Q?cxToK99O5LtfHtfmFrVqk2Z5MROmCCw9dE9orw6QZY/yxKpQgKaJphW6sfUH?=
 =?us-ascii?Q?8fL1w2kfbLQZa2HzT8oYbobQypAVs1C4k2qVL17urJPpMZESmbD2GYfrdjBg?=
 =?us-ascii?Q?FRRG9pd22FOOMmFiV2Me3wc+opLsxfkRwBYEio13ccEBo0lbuTkeOCfe7+co?=
 =?us-ascii?Q?XZ+sYhMtkGlVhvfF4H69WFuCIE1QdphjGyGLE9XA0u/6+9QhO7ktHdzS/iUv?=
 =?us-ascii?Q?+cQVFUsDtrfZOfqZ2dwAGTt8Hgl96/wAnbwYrbVO3Ry1zrJqe5uWrXLN6cxi?=
 =?us-ascii?Q?0v331UuferR7Nd8rDvA3T5fSld6MROc5crZWfyvZRTu6ec8LQMDvijMvuvjI?=
 =?us-ascii?Q?E+UyiI72pxB6bVjz53HQntMuJB3yIQboygpo066l2o2/pZ4ua4GPBQbcDf9r?=
 =?us-ascii?Q?nQgje4GW5jzi1b+FzAmCBZCwyG7dNxkA0t32IHeIN0AxRcHAri3aB9aEfNyp?=
 =?us-ascii?Q?hzgen+hVpErS5GQw7Mx2F7q3dptOFiwT33X2uG9s6wlFRmJYlxU9VXnqHqsu?=
 =?us-ascii?Q?QnuQCHhAgYB/Lno0oWGCgG7zNh8aGxvpvk/nqpDTR0+gxBZkxeExd2eGbJIv?=
 =?us-ascii?Q?0NxJjgiEeMmo69YCpHGBzjLZ/cLqs/AK/ybgEbA2rHfFQm9EwlqA0TKdsCoU?=
 =?us-ascii?Q?fxcnnVPC3w0XlQl4AiCOnTHF5UDlLmORK10sU0BuLviYmylVHrFz33CbD242?=
 =?us-ascii?Q?Pf81Xu4pHJPcifCkFqYoyCspEXk9N5U=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74f1629a-7b5d-431b-b707-08da4fe9ff4b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 22:46:05.7347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dK4IY32R0+6MHmSc98fLozzzXzj/YjxzKKKD0aJjYeJ5IoM2Ib35lToLbe+ad3jh07S7ELKWDuALubbULqJtgrQbJVs94RN3C8mamgSg5RI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3597
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-16_16:2022-06-16,2022-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206160091
X-Proofpoint-ORIG-GUID: hGvkhKJJ1lE6agtLAr5NKU3s_RTeC9gx
X-Proofpoint-GUID: hGvkhKJJ1lE6agtLAr5NKU3s_RTeC9gx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename iscsi_conn_queue_work() to iscsi_conn_queue_xmit() to reflect that
it handles queueing of xmits only.

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
index 8d78559ae94a..3a73aadc96a4 100644
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
@@ -1786,7 +1786,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		}
 	} else {
 		list_add_tail(&task->running, &conn->cmdqueue);
-		iscsi_conn_queue_work(conn);
+		iscsi_conn_queue_xmit(conn);
 	}
 
 	session->queued_cmdsn++;
@@ -1967,7 +1967,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
 static void iscsi_start_tx(struct iscsi_conn *conn)
 {
 	clear_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
-	iscsi_conn_queue_work(conn);
+	iscsi_conn_queue_xmit(conn);
 }
 
 /*
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index c0703cd20a99..4f4be93aa0d9 100644
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

