Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73DA9C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Mar 2022 00:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbiCTApq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Mar 2022 20:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244474AbiCTApn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Mar 2022 20:45:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E614241A0C
        for <linux-scsi@vger.kernel.org>; Sat, 19 Mar 2022 17:44:21 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22JDkuxP027768;
        Sun, 20 Mar 2022 00:44:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=M0TkzGY5+MJtiXFLyv+LtWAf/ptGUWbNj1xWQLaDhFk=;
 b=kljowxSniM3nnavovOJWAgGO5J1ZMq9Mw5b2Wfbh5eRoyuWRrbXTWitsmlWja/sarNnb
 dApKBUlbVIZWGdy8k7zgkEDSFbWoDSrHfXQmvFBw9IVA+0iFmPB99lDxFnMeOQybbnXw
 GTCzN6+/+RdHR1Xmj9wBmjwGQ+/qnrBH+aZZ10Vgr7m970i0LB5YCzXUQdZaT0d7bEjp
 EC0/lDfK93EUKKZiKhnNFSw69VzD/dwMocpu+oTrYZ3ekl9hgJddDiLLkvYOm/Y/b9ro
 kVW/BFMEAxGeyLEUGVehu0cepD4SUu8Z0rLkoTilnOSFaC7XQYX4eBTqGwQGyoOZWJl2 6g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5y1rw2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22K0ffai137063;
        Sun, 20 Mar 2022 00:44:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3020.oracle.com with ESMTP id 3ew8mg6mq1-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBKqJRhWPeEWfc3RUULNVWC3xmoodYCY70kYOvYA2c3HXfTI3wWlLNqypi70wXIwdjt9Nq0I16ZlO5upwQrHuotnKQpXU8DUimEC2kgmYURPq1eNS5prWsTAK5AJwoFrqcHInsqjvrvM/bgng4dpebn7cx8sXUYaNLyA04LJIO2RBhlW7k3H1lnNTZQTQyk/hEuzwzrdz7zGOou2cVsxRK/RHa9Cc1ijGgREHAy75ZbLg1+lE+bHvEywdxiLOzTp+fGsF28L89Vb3rkTe5Zl9uNLjuVj5qY+zpyP+951ClZZ07UGyMQQU4R5XDcKYmnRUC0RU1+LfJcKnPJ5b7jb5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M0TkzGY5+MJtiXFLyv+LtWAf/ptGUWbNj1xWQLaDhFk=;
 b=RTMq1tobKFAbbQTHzEOWC/bJS3yBfcFoh1EBLQTv8P589na/uzk3Wrx+YVOa5NZBKzkescZfdLXUJJax8DcOTX48xC22Mtrg05V3ZgxqZUn2Fn+HBr6cxWcLIjy2pK8Fxl9h6L8DMgXgAB8gWzbLIvV6Nqy1JmIEWhYiFyPKwMETvL2DTc5nHXggMqkIScOx8g44jIQ+wLY8fJ30VBzGcsHO2d7kyU/H0unajARuRH3dMRMTWd2f92lTTUKVfWHPAoMvPWT1SArhb6k8HwrncymSvPaLcjg1xwxreRRrx1JgIwv0i7SYFWTi61pqmJrF9yWm+XggkMHhln2izxwLRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M0TkzGY5+MJtiXFLyv+LtWAf/ptGUWbNj1xWQLaDhFk=;
 b=teroRakhDIMnX0IsNyJSj2gVSb6txdfTCiMJRZXp7lwLCw/idYaE8hpZk2sOAtRlEFCodnot9lKMMlx8IBG9lh+TYG8D5GruXJFPZ8kpcnkG8Sj4xq9FVRYxyefnMqm2Vc6o83gP8KTWyHlNpY7RhRZnnO3s22rcrtVAux1HL3c=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH2PR10MB3992.namprd10.prod.outlook.com (2603:10b6:610:9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Sun, 20 Mar
 2022 00:44:13 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f%11]) with mapi id 15.20.5081.022; Sun, 20 Mar
 2022 00:44:13 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V2 03/12] scsi: iscsi: Add recv workqueue helpers
Date:   Sat, 19 Mar 2022 19:43:53 -0500
Message-Id: <20220320004402.6707-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220320004402.6707-1-michael.christie@oracle.com>
References: <20220320004402.6707-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR18CA0065.namprd18.prod.outlook.com
 (2603:10b6:3:22::27) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2950706-2048-4189-8470-08da0a0ac10e
X-MS-TrafficTypeDiagnostic: CH2PR10MB3992:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB39921ECB914B57F40B32945EF1159@CH2PR10MB3992.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hk2ajOv8nIXqhK/5jihYTnqB/rVKnNuxVOnkpUq3pmT7//h4g+VYSoFaixAH6CzgeZi+8vpEkNy6IHCsC++/AST6TILxlfd+fB4xUy2vQ+WeVo5Rmf4nh1n7iXWEHUfRwbS1cWPmCmpWOUGY/8mI4UcKMNuOUBw7vlxoLwS9AxNoWKlvfJzkV7KGWdTMbKC6A9AhFgMPX3gAo5HvGTqUhdu60Gb5nd8o+bW7/W4s9VYRY7ntE2xbctejno5ZkHG7LfONdC7N1yhVH9jX68D8DDqJy5zNJM0rqHJVayCU7JBmqd0PliuxQQqehrhxGK0NvFVrmxej4D0Ur/K89Csd1oBKotmoBlwpI8P2x6he/ksDxCjZqF2TTw2TF4KQdZkAoILhTdGthd2GhvFZkXZjjU+QThO8EeZ2wcUI2j+iIAOvADIBFgwgtYP88FsEkd0QZTe2f1R1qorX/jaNTpJ10wkiQ/WsB/+HnauHt8xcu2+IAqpG+WUvOFDka0r2KEx/2fTIxFkPdSebqF4nawjFsI0+GNOLW/kt8bfCoUcOcgjUwIpWzi2wS1qMu1jmfqGaSpoPvf/WajtLbo3z2lnBAb4ioZSoVoqzRhpEtnot/gHzb9K8lBQB+wz1c5HgjtVVRMSrvYL/GLJyM3lItcsObNnGkS1IkftnotMnYFWz527i5SY6RKxao936sTHp43w0XS7gapKOkHt0kNTU5zg/xQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66946007)(66556008)(66476007)(4326008)(8676002)(86362001)(83380400001)(5660300002)(6486002)(6506007)(6512007)(6666004)(107886003)(36756003)(26005)(186003)(1076003)(2616005)(8936002)(316002)(2906002)(38100700002)(38350700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WZqoAoskioWn2/u2XvHUqtsH8Xl40+zH73/gMNusBSkAaAFhC4WylGdYtTcl?=
 =?us-ascii?Q?5BZKtNMF+lHh8HP4iCx4nyRJhyrxo3oqEAWKyNTPJjrVehgGFVwrxNecnW73?=
 =?us-ascii?Q?iV1qBsYXh3iPzeYJjbf2ugH3ayr9EXWA5V3tm9sZRrDprBu4M5PTTpdfZltv?=
 =?us-ascii?Q?BWKTGgkJsjyoNzSMHYH6mef1sU/QChICjfjb7upg8o+NxaZGY2j6CrtCSVTz?=
 =?us-ascii?Q?Q9NPo5DgsE6plo4DHc0Y1YbRC8pvX7Xl5HS1SPvDOVCW8x9YZ6uJfMqQ4xI8?=
 =?us-ascii?Q?zWzsUsnxTIKfyY0S+W3tlERXlgFYFwkPY4U/hMbFdHE0Ot7WV7li0wZqUSxG?=
 =?us-ascii?Q?8vr0/B/WDXYFQqvXNkX2hZJyvUTXrXVCSzdbVm8v1PoKfRJT1a9/6nQxLqs/?=
 =?us-ascii?Q?SFjREoegd0vqglrK/dQQuWThvpajUiIVyN69EUjp5xOqIjuPdASruKhIzkfi?=
 =?us-ascii?Q?TNFlxqPXOqObUnz5StKCx4a1Ub72EFJ+mVULAYybPU4q/LHTUVmh6LStEWJB?=
 =?us-ascii?Q?Zq+/ZBozZhyD3NpAXBBcXANT0QlcT39+sSA+Z4S5GM7vruFbDrheCQddIw/m?=
 =?us-ascii?Q?OAsZ7+80b2SQIDah8/RxeeglzYohiqJEP4UQgbJtijNGoC9dkmm0pjwYyEJp?=
 =?us-ascii?Q?+pRGJ0C+rI17IWIXEUbSb4cDSbatl6ljGfytoXQT/IDyPwDX9dXFP4B+rT/h?=
 =?us-ascii?Q?IhQoUj3rIYs1SajeWGSHPZNvkhvf6ph3QtR2HeXwU9T8bl8XLRdqqkT48LTX?=
 =?us-ascii?Q?mRsiSkYNUGwcIDiXEiTvGjjPJnVHdOye5DFASOg650+noVqUfZRz2cfR3pz7?=
 =?us-ascii?Q?xzuyPS8zW7hvyL54E2EjOe735tANhVQD4GAAkb1aqZd4CcuRSYqn6d4nZ3m+?=
 =?us-ascii?Q?Eufw5MpOsjrtY87exkRhQfNujgiSztbJ6ivgl02hXw+OUX0324Ba9lir590M?=
 =?us-ascii?Q?1+8J5GhRu9SwQgFz8F5grtlVerSSpfSuaBAxH0DZ4kyjAXgPNSBNOMrzjPzY?=
 =?us-ascii?Q?sE9weQfcSA7nHOavNW3/dfDg9l5+n6/+BYfApM8Aw0norSpnbSTf2Ruq7A+2?=
 =?us-ascii?Q?LS0bBZxp+XMHnPBbFbBXkPSD2XQqbtnELAxMY/hiYjxQ9w/edtkq+wUf00TR?=
 =?us-ascii?Q?7nb9Yotstk3PbaRrBj4j3aqcmQMSvjlOdNpbvJj7oL9SDQ6hKQ7dOIyVfCoJ?=
 =?us-ascii?Q?zeYqx5E3bvTjVFC91tgjkgWbOgphF/1PfLxZ+H9pL+8K3qB0KtrhDouiaXg3?=
 =?us-ascii?Q?FD/6ayviVlJS5o6Lhk3gqo83w6TuaePs9QbZZ3OmD0A3+sNwprwBmzmb0+Il?=
 =?us-ascii?Q?YkqG1BYut/bdj/idrikmKYEWH5hj3qJXQnyBJrdSoHd6txDBPm+f8fvqmB4/?=
 =?us-ascii?Q?Ad9RSolTewJdDOzTY+dcVIjQKg2d9pypa7IOGgbyUwvDpt2PlC5ITU5yP4KQ?=
 =?us-ascii?Q?iPzqBy0XVLxUwMwLgbmZP0SyloHsk9Cyb6JCCIqlVJJ54rXYA8/AqQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2950706-2048-4189-8470-08da0a0ac10e
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2022 00:44:13.2657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UDCphVaYT0Z0ND9LvErwSKyimt2cI9iejvdYQK0WPmEkoMinLWUdjTOewWASxqeiexF1gMgP7hGcdpb8KHNxohB8djVtB/MnwjTZoBgOMXM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3992
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10291 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203200003
X-Proofpoint-GUID: fwr_hJLOpR8l0q-kt-HX6Y3a-SfrK4fd
X-Proofpoint-ORIG-GUID: fwr_hJLOpR8l0q-kt-HX6Y3a-SfrK4fd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add helpers to allow the drivers to run their recv paths from libiscsi's
workqueue.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 29 +++++++++++++++++++++++++++--
 include/scsi/libiscsi.h |  4 ++++
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index fa44445dc75f..fec64cbfa4b6 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -93,6 +93,16 @@ inline void iscsi_conn_queue_xmit(struct iscsi_conn *conn)
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_queue_xmit);
 
+inline void iscsi_conn_queue_recv(struct iscsi_conn *conn)
+{
+	struct Scsi_Host *shost = conn->session->host;
+	struct iscsi_host *ihost = shost_priv(shost);
+
+	if (ihost->workq && !test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))
+		queue_work(ihost->workq, &conn->recvwork);
+}
+EXPORT_SYMBOL_GPL(iscsi_conn_queue_recv);
+
 static void __iscsi_update_cmdsn(struct iscsi_session *session,
 				 uint32_t exp_cmdsn, uint32_t max_cmdsn)
 {
@@ -1942,7 +1952,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_queue);
 
 /**
  * iscsi_suspend_tx - suspend iscsi_data_xmit
- * @conn: iscsi conn tp stop processing IO on.
+ * @conn: iscsi conn to stop processing IO on.
  *
  * This function sets the suspend bit to prevent iscsi_data_xmit
  * from sending new IO, and if work is queued on the xmit thread
@@ -1955,7 +1965,7 @@ void iscsi_suspend_tx(struct iscsi_conn *conn)
 
 	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	if (ihost->workq)
-		flush_workqueue(ihost->workq);
+		flush_work(&conn->xmitwork);
 }
 EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
 
@@ -1965,6 +1975,21 @@ static void iscsi_start_tx(struct iscsi_conn *conn)
 	iscsi_conn_queue_xmit(conn);
 }
 
+/**
+ * iscsi_suspend_rx - Prevent recvwork from running again.
+ * @conn: iscsi conn to stop.
+ */
+void iscsi_suspend_rx(struct iscsi_conn *conn)
+{
+	struct Scsi_Host *shost = conn->session->host;
+	struct iscsi_host *ihost = shost_priv(shost);
+
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
+	if (ihost->workq)
+		flush_work(&conn->recvwork);
+}
+EXPORT_SYMBOL_GPL(iscsi_suspend_rx);
+
 /*
  * We want to make sure a ping is in flight. It has timed out.
  * And we are not busy processing a pdu that is making
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index b567ea4700e5..522fd16f1dbb 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -201,6 +201,8 @@ struct iscsi_conn {
 	struct list_head	cmdqueue;	/* data-path cmd queue */
 	struct list_head	requeue;	/* tasks needing another run */
 	struct work_struct	xmitwork;	/* per-conn. xmit workqueue */
+	/* recv */
+	struct work_struct	recvwork;
 	unsigned long		flags;		/* ISCSI_CONN_FLAGs */
 
 	/* negotiated params */
@@ -440,8 +442,10 @@ extern int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 extern int iscsi_conn_get_addr_param(struct sockaddr_storage *addr,
 				     enum iscsi_param param, char *buf);
 extern void iscsi_suspend_tx(struct iscsi_conn *conn);
+extern void iscsi_suspend_rx(struct iscsi_conn *conn);
 extern void iscsi_suspend_queue(struct iscsi_conn *conn);
 extern void iscsi_conn_queue_xmit(struct iscsi_conn *conn);
+extern void iscsi_conn_queue_recv(struct iscsi_conn *conn);
 
 #define iscsi_conn_printk(prefix, _c, fmt, a...) \
 	iscsi_cls_conn_printk(prefix, ((struct iscsi_conn *)_c)->cls_conn, \
-- 
2.25.1

