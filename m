Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C11C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 00:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbiCHA3G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiCHA3F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 19:29:05 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C46625C6A
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 16:28:10 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227LLAiQ031932;
        Tue, 8 Mar 2022 00:28:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=/aUaVSFW1sgk3Um1U/BACf35FQIvYysrPU++CR+h9OA=;
 b=ho8kILWQjwNPNEjjgM/UrTK2rBJItyAjYfzszBat5Twl5hqY8pexJQKGSdngG2D+tJxC
 O5MZyg8wOQzJh8KfjIqr0BGg+4TM7UDnAQhpU/fHXaHqG17jEUemkhBvAfwQsbRi8NP2
 VxE/HWO8zoGtjNzsHGcbjXa04aihuzJZIPtdVdWdLzWyYRgnGn7XMI0gRR1NAyeaZ2FL
 DrmSldrvEwzg4D8LUxeOie6DbLsMBxY6tpAdFA4YfqMsx3ayBcsQ6qbTknODs6vOQTcl
 5L3vP6zWM9hXWiEHQh/Rt1r88MDfzd6Ytr6MEFRxYng5Am44jIYbWjo5BcNJbr1EuGri Ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyranbuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2280AJ97134548;
        Tue, 8 Mar 2022 00:28:01 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by userp3030.oracle.com with ESMTP id 3ekvyu3hrq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kj1ucEijP+0FWYAoCEi2Xwm8iPrOu2DfgL8RYrbHDsaETEmsTQr2IRx2d1OXK1mdr3xjJNnn4y8kmK+25WOiDaWaSSpzLLCCbugnImiyVWpz45iabcNwtOPaa25lMah+7w9nbAbTGueN5adBYdiM1YuxQE/j3d0J0MwnTgEjIPzkgNIbmL0/A4fBCYr8wsQvbnoTHjjfHJai7gYl8JE52o/Hteg0OBMegAgP6zkWvFlRjl9Nvw7ykL3CdAR4lF8QroLKX2YahzXNSitmyT+4TuKbzOTQ/YrxeblIdgYcTvuUK7cYpZcegxr7Q1MaU1uFNSxBw4aWhpAL3+CxNilpNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/aUaVSFW1sgk3Um1U/BACf35FQIvYysrPU++CR+h9OA=;
 b=M0ljmxMiv6wU8fRwNMR6hiHUHBaleII+Q+Je4+HD6dCULyl3Hdw0n1zjxsPo7KO+jaOpRRs1NYHwlTJ9TW5wzWFWNsfuhvdzdlWr8GHJpCAbAn+5BtnJng2DURo2gjqoLg93lS65GEKorb2K7u7AfppTImLkz4DHGsFjN/5VXepYBMGv3mDLKfFGFlBtO/0xcGODmravVSKUHa+h2+mQdrFwW+rrCK9bFowvWqRy6NoKHkQK0JPBV2IePean9Vpxd8Nse977qXVV7V0CsvARdmOxbkwQyMygElg+p/+iOtqnGeZBNHzUUProkZ3iDVygYM4yxOJPfvXrmqoFLspm5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/aUaVSFW1sgk3Um1U/BACf35FQIvYysrPU++CR+h9OA=;
 b=FlcElwT/wo9XbbdboEa+REBokrNMBCAdPmRL7KV3pK+DNuCg4Tn+rLSE7GRsNC1tXs1RZaLbCoQkdEL0toQr9XrbmNFWUe1o44u5GkNyRuvDaobO7o2uZIOigCRQ4iJ8x/M8rJLNOO4LucNiZ/t0MB2qBqZyoRZs/ezH1zaIYCw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4361.namprd10.prod.outlook.com (2603:10b6:5:211::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Tue, 8 Mar 2022 00:27:58 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 00:27:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 01/12] scsi: iscsi: Merge suspend fields
Date:   Mon,  7 Mar 2022 18:27:36 -0600
Message-Id: <20220308002747.122682-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308002747.122682-1-michael.christie@oracle.com>
References: <20220308002747.122682-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a865575-a0fb-4206-01f8-08da009a7df5
X-MS-TrafficTypeDiagnostic: DM6PR10MB4361:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB43611C47EACC7EDB5F373410F1099@DM6PR10MB4361.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qZiGv4aXjKHxQG6msQZGC3g0SjlTEvSYIPjRSbLEFxWbEAXdoHGi1rjx0Mlo/xknkHe7P2Zz5yYPNWn+qHhiogrE7nem4uPIJyTxKeM3ipaGqXBPgpgebk3pTDNhw0t7m0ZMGU+XknFUOfWrfvA0CjVkx16pxvhNqWkCFkJ/E37RrOEKrEkxMlcmDIZ5pg+52j5DrR+9j/7g4jAPnIWsK7UNfHLatphcD5HnhZYMi1CWqhmsvqKoHoDopiyMKMg49AZoHjpWqVwIPALkkQgIWJqi01EqmV9WOdeMSvZOon8epbktJf/Lr+uWiMcy73/nqQyeyBMIoiY7oN+e+YCGVOW3dQT3I1FeQn+PZLfl/xMkPm7WSsItNVQpy9dbORjn3c902KtLH67P2jxBpR56QVNNUc2lJDZgBG0TGDBi96BBqlgApgWGmP/G2nI3bPio4PfNyxSvqGmzaOrLr86Do0b/NfUfgd6/sKE3fmcuDsdWANZCJfSw32UXbJOYU14mivCP1q3YxNUJsop6VPmxx/ozgRAGR+vm+M1eJ4ArMFQwcY/CDntZzf3SfI6+TrJMwYJ1IUxa+VArezObONya0DXs1WPdpkI4lvH6lfonrkx+y+cK0T1KP1pF8Zp0xMHZTtqEr5AuYuSH4x2d0Ht0hq/lCUW823Gc4Cp6xNehucFJP8zTs54cJo3pcu/R/g/4N6zsLoS0u2iqsT+cL6b3yQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(508600001)(6666004)(107886003)(1076003)(186003)(52116002)(86362001)(6486002)(6512007)(83380400001)(6506007)(2616005)(8936002)(5660300002)(38100700002)(66946007)(8676002)(4326008)(66556008)(66476007)(36756003)(15650500001)(2906002)(38350700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hZ+9dY0kl0MGSwWH6DpA0NpOd/lM+6xAJkkZs9gitYWClh3AmDhA37ju4huJ?=
 =?us-ascii?Q?H1L/agsx4ngwFYaKojPkqTVDpMONWJGzPJU8wQruPzEBeTvAPvBCIzPzHwBO?=
 =?us-ascii?Q?7yGeHIBOHg784JAABtcfrIhaKV/JQEoo0qBW74Vdye/Kh+hlcolOsbE5kaF2?=
 =?us-ascii?Q?17uhE5a72thu3yV/RtLwzv7WrL09GQt5ci1wvWik8hmcaD7mw2PPW+fg1e3n?=
 =?us-ascii?Q?WLTIh/Y5vA2XoWvrIFEaFt4+kFReIGbx1ADereESMrYz71pfxoa5lIQtBX6h?=
 =?us-ascii?Q?zpNNhlnYYSF1R09AmRp1m2r6GkghI2PAMs0k6LlJj5lzrvCiVXuypBAqOxPs?=
 =?us-ascii?Q?agM/aB84MmTs2uunkhptF4pO8qeW/B2sTh1sCXSXvaAP2fN9sEjWLDLzKp+T?=
 =?us-ascii?Q?ANjX5t27b0fQq/dycqquP/MNZZHqThb8VkPeVk8DPkI0XSl7D19V05t8I2MH?=
 =?us-ascii?Q?u197cRp/d3iaHmvb7Ije6wCsLhOvLc11PeTgg5gWgruvhTUL3ewHZOS7dG5v?=
 =?us-ascii?Q?capjG77WjrdDgJvYA/AXWElqHBEV2MDjcfV8iaIjTWOxJ2W1xV8b+/X4aXd5?=
 =?us-ascii?Q?NImqDnHR6pTCOb0X/qWo/olLtuWg7T1Ajc+DMJA4DyOIq+B8oHxyK6vAXa2T?=
 =?us-ascii?Q?BDq2UYlhBeYUIm9I4l5dqm18zxdGVSgkuH1vfxp2d+VgKOtMJun8SJnHTjaW?=
 =?us-ascii?Q?1K11We/BpL0JF7JFNoYIT6RL4BbTWjc9NrpLczPYfgA1rBGHokyjxYbdHfaT?=
 =?us-ascii?Q?LNjJXw3bSXJU/usgZOCFWYMd0e4o0wZjG+ffe5kH0zXyAv3ybLVZP4MI1/WE?=
 =?us-ascii?Q?BYzivinb9zfyC0TMODZXnPaqZSiXwU7Hi9ICBG+bpJKsWw2YcdHS5jSUW8W9?=
 =?us-ascii?Q?RHE15ghaOgWDzr7mH7wdPpkHlje4knCDOL9M+IGu6kyFW5Bdgz10sH9MUbnk?=
 =?us-ascii?Q?ffAr/96nWrCcsf1tjIFxFMQs0PiXl6lWy9a4k0ADa3nTi6yDU7ly9ZZvH15j?=
 =?us-ascii?Q?UzyzR0pmHhRmHDT6l+pUHjZk6TZYxEDLuWDKYpqUqAa9co0eDGBS8MFsBHVi?=
 =?us-ascii?Q?J8SeRXp2Ra/OjNST9FAIu/xBs7zgNT6mLyXnm5ud4QLiZZ7EgZZD3q9iCfqo?=
 =?us-ascii?Q?uW6ic6iWngz65DQNvCUcACRPyu1Kg2nBlZ4j2n6HNdAXf2W2zU3Oap+e82LK?=
 =?us-ascii?Q?y5BDxQZOkJqO+lMp4v1ugBoCCdd5OzPYUaNhwfQ/LDj/qRX0BBjozjJgOP4G?=
 =?us-ascii?Q?Sm0RsO1pP6OeUvQWpC8dwpXRM9nXq0i5pYCEwevQH29EIRfDmKMsbTOApqSr?=
 =?us-ascii?Q?PpOYq/2lxVjhIFGf6xoOkcCgPQVZYd4NvDAueBgeSa4uJEmb5/8kXLXUW7iM?=
 =?us-ascii?Q?0qna6vWj/fzoTdR6oIQx101go/zWkxgnykydYhQ4PICgSSxSudBeQecUdAac?=
 =?us-ascii?Q?0RzhVpP+Xk6wr9aoQg4bwq+07Xsq6QrsXoA/BVi+5tXsgRg/pfu6+0zUrKsA?=
 =?us-ascii?Q?2rEFrCjIKRWkoQDdOMhUMgMWdZNbbyC0pUUfrAKFQb+UHRxoVrnmz6UvU2e3?=
 =?us-ascii?Q?1N3ACwiqFjBRMLHmGxPqGe9nFMjjKGWw62LZ5HO141TZ98iV/LcOcAt03BlL?=
 =?us-ascii?Q?mBWsxMqIn6L5MR7YMinHK7TJjzb86E3JCPUJo+qPXOahlb/iCcPCRr1sxG4T?=
 =?us-ascii?Q?UfDkUA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a865575-a0fb-4206-01f8-08da009a7df5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 00:27:56.5768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lzm5zYBI1LGMVT0PYoLGZJJEWFedDjvaugKhg5VcBJLuMyCdbMJpLwYsVUfjavvJmQHFd0g21eZUf0OAHGHF//KZFANhMTUSb2F9YzJRug8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4361
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070121
X-Proofpoint-GUID: XfZCml9KL9_7KQWHOlSJPmw5_Q6fABf-
X-Proofpoint-ORIG-GUID: XfZCml9KL9_7KQWHOlSJPmw5_Q6fABf-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the tx and rx suspend fields into one flags field.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c   |  2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c |  2 +-
 drivers/scsi/cxgbi/libcxgbi.c    |  6 +++---
 drivers/scsi/libiscsi.c          | 20 ++++++++++----------
 drivers/scsi/libiscsi_tcp.c      |  2 +-
 include/scsi/libiscsi.h          |  9 +++++----
 6 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 5521469ce678..e16327a4b4c9 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1977,7 +1977,7 @@ static int bnx2i_process_new_cqes(struct bnx2i_conn *bnx2i_conn)
 		if (nopin->cq_req_sn != qp->cqe_exp_seq_sn)
 			break;
 
-		if (unlikely(test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx))) {
+		if (unlikely(test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))) {
 			if (nopin->op_code == ISCSI_OP_NOOP_IN &&
 			    nopin->itt == (u16) RESERVED_ITT) {
 				printk(KERN_ALERT "bnx2i: Unsolicited "
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index e21b053b4f3e..a592ca8602f9 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1721,7 +1721,7 @@ static int bnx2i_tear_down_conn(struct bnx2i_hba *hba,
 			struct iscsi_conn *conn = ep->conn->cls_conn->dd_data;
 
 			/* Must suspend all rx queue activity for this ep */
-			set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
+			set_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
 		}
 		/* CONN_DISCONNECT timeout may or may not be an issue depending
 		 * on what transcribed in TCP layer, different targets behave
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 8c7d4dda4cf2..4365d52c6430 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1634,11 +1634,11 @@ void cxgbi_conn_pdu_ready(struct cxgbi_sock *csk)
 	log_debug(1 << CXGBI_DBG_PDU_RX,
 		"csk 0x%p, conn 0x%p.\n", csk, conn);
 
-	if (unlikely(!conn || conn->suspend_rx)) {
+	if (unlikely(!conn || test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))) {
 		log_debug(1 << CXGBI_DBG_PDU_RX,
-			"csk 0x%p, conn 0x%p, id %d, suspend_rx %lu!\n",
+			"csk 0x%p, conn 0x%p, id %d, conn flags 0x%lx!\n",
 			csk, conn, conn ? conn->id : 0xFF,
-			conn ? conn->suspend_rx : 0xFF);
+			conn ? conn->flags : 0xFF);
 		return;
 	}
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index a75b85f0a189..14f5737429cf 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1392,8 +1392,8 @@ static bool iscsi_set_conn_failed(struct iscsi_conn *conn)
 	if (conn->stop_stage == 0)
 		session->state = ISCSI_STATE_FAILED;
 
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
 	return true;
 }
 
@@ -1454,7 +1454,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 	 * Do this after dropping the extra ref because if this was a requeue
 	 * it's removed from that list and cleanup_queued_task would miss it.
 	 */
-	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+	if (test_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags)) {
 		/*
 		 * Save the task and ref in case we weren't cleaning up this
 		 * task and get woken up again.
@@ -1532,7 +1532,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 	int rc = 0;
 
 	spin_lock_bh(&conn->session->frwd_lock);
-	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+	if (test_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags)) {
 		ISCSI_DBG_SESSION(conn->session, "Tx suspended!\n");
 		spin_unlock_bh(&conn->session->frwd_lock);
 		return -ENODATA;
@@ -1746,7 +1746,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		goto fault;
 	}
 
-	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+	if (test_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags)) {
 		reason = FAILURE_SESSION_IN_RECOVERY;
 		sc->result = DID_REQUEUE << 16;
 		goto fault;
@@ -1935,7 +1935,7 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
 void iscsi_suspend_queue(struct iscsi_conn *conn)
 {
 	spin_lock_bh(&conn->session->frwd_lock);
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	spin_unlock_bh(&conn->session->frwd_lock);
 }
 EXPORT_SYMBOL_GPL(iscsi_suspend_queue);
@@ -1953,7 +1953,7 @@ void iscsi_suspend_tx(struct iscsi_conn *conn)
 	struct Scsi_Host *shost = conn->session->host;
 	struct iscsi_host *ihost = shost_priv(shost);
 
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	if (ihost->workq)
 		flush_workqueue(ihost->workq);
 }
@@ -1961,7 +1961,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
 
 static void iscsi_start_tx(struct iscsi_conn *conn)
 {
-	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	clear_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	iscsi_conn_queue_work(conn);
 }
 
@@ -3321,8 +3321,8 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	/*
 	 * Unblock xmitworker(), Login Phase will pass through.
 	 */
-	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
-	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	clear_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
+	clear_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_bind);
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 2e9ffe3d1a55..883005757ddb 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -927,7 +927,7 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
 	 */
 	conn->last_recv = jiffies;
 
-	if (unlikely(conn->suspend_rx)) {
+	if (unlikely(test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))) {
 		ISCSI_DBG_TCP(conn, "Rx suspended!\n");
 		*status = ISCSI_TCP_SUSPENDED;
 		return 0;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 2d85810d1929..10a9b89b7448 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -52,8 +52,10 @@ enum {
 
 #define ISID_SIZE			6
 
-/* Connection suspend "bit" */
-#define ISCSI_SUSPEND_BIT		1
+/* Connection flags */
+#define ISCSI_CONN_FLAG_SUSPEND_TX	BIT(0)
+#define ISCSI_CONN_FLAG_SUSPEND_RX	BIT(1)
+
 
 #define ISCSI_ITT_MASK			0x1fff
 #define ISCSI_TOTAL_CMDS_MAX		4096
@@ -199,8 +201,7 @@ struct iscsi_conn {
 	struct list_head	cmdqueue;	/* data-path cmd queue */
 	struct list_head	requeue;	/* tasks needing another run */
 	struct work_struct	xmitwork;	/* per-conn. xmit workqueue */
-	unsigned long		suspend_tx;	/* suspend Tx */
-	unsigned long		suspend_rx;	/* suspend Rx */
+	unsigned long		flags;		/* ISCSI_CONN_FLAGs */
 
 	/* negotiated params */
 	unsigned		max_recv_dlength; /* initiator_max_recv_dsl*/
-- 
2.25.1

