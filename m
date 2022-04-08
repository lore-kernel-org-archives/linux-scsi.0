Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B520AC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 00:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbiDHAPo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 20:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbiDHAPj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 20:15:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B8D108575
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 17:13:33 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237Jv8ix005378;
        Fri, 8 Apr 2022 00:13:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=eh2FIw1qtJmmI1n37a4yxA3fO27VVWVvalpYDin9MeA=;
 b=UrvhzqXs5s5cGmzMP+u0x5LQSAmFgW1lA6RfhfvO+G1bnLtYKpA1L4RPICzpPD0crpQl
 SXc6sTrV6WxrVnnyA4d0E7bIZ4HsRJrGwjIGw39va5AnfYph+A21LFthhuLYOVW19NRq
 I/Ft8AKOrF8Kmbi4AJ0Yjaqjx1DqJdHSWzAQSQ0dT6NWajNrNsE/ZcUUlP/fQyB3bIj6
 Gckip47umiC+Ccs1d3YWXXWK+7DPYjZWKSIm854wZhCM62NzRLdrPoEAgjOX4eOniAoL
 htGmXK1Kaoy5JRqOnh2BB4xFBGs9Sil/+PNITOhoGj7Njs0VrbmMQDpYNqgLAw74PUZ4 EQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d935ens-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 00:13:26 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237NFHE0013838;
        Fri, 8 Apr 2022 00:13:25 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97tu11q5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 00:13:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVDvvW885pN/CgGO+usJPMfTU1OHcJ7PCyyJkdscOp3MRz999AyfAFbZPqNJWyQez3tdSVETt4ZJkk2I680+oNWUOIqzPGj/mhYfOEtJO8IbM6XuK3gNmh6VQYfOukURq2aJ+zEkZ+Dowq6cdc5g9dIpWgegSSX6g5nfgJ2evhp1rdQeojJsI1nC/A9gnIT8utZ2KleKzbKcN8Vlrt6NPI8HAIwmH90rjdj4EhMwx8nPEX4BPY57WIDXsnp+POffralv6ZW/3CZDSrg5Jrp5l42Kp46GpzsdK1doDaGUYAmhj7M5DW7YgZJmzQyPLEdBSW2r/sn1SJavlS8ATh22wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eh2FIw1qtJmmI1n37a4yxA3fO27VVWVvalpYDin9MeA=;
 b=DwZMc1LZOIhJ8jv/WmMC93pKkQyhP+k7KgZT3QjY9bm4CZs68Fn7paNN2QUIwRESmDtAd24UAY8uYNjmdi98ppKlF9wAmDAI+pIGoXG4TZdjEUefdt1gHnsefRkttsWLgJhlejKBp9+3C1zObNn9F+8s8TjE3q1ATRRNMF+Ms9Elabh4DV43jsQfWfk5viTddqRenttgmsfWFSArh8W8GRtJSp3TN5aqzUfPQRmX7A+rmOu6eQDprWD3RZVrMYABPBRuDOdbeVyIKJ72uxoGnOgJaE5gebVTjYtTwyGEKH1J6IZ48oWCje+IMa6a4dxxBMnaHjORA5q3bHJHFci2OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eh2FIw1qtJmmI1n37a4yxA3fO27VVWVvalpYDin9MeA=;
 b=aUKOHxpSO3LZ8lBzsnwFE0WRmTPCVpTAk8wKOBIu1b68VhJfc9YkaC83zv+BRNGASSuAk1Bce6/y23OJ2DzxdVvT0iAxhsKU5PB/oi0p0ewy7BgF0qhnPDmdbv4xz9S7x7BRfkA+BPYEsnqHaJRYad64aElZ72HTWuVgUmFwRDM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5550.namprd10.prod.outlook.com (2603:10b6:a03:3d3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Fri, 8 Apr 2022 00:13:23 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586%2]) with mapi id 15.20.5144.022; Fri, 8 Apr 2022
 00:13:23 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     skashyap@marvell.com, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 01/10] scsi: iscsi: Move iscsi_ep_disconnect
Date:   Thu,  7 Apr 2022 19:13:05 -0500
Message-Id: <20220408001314.5014-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220408001314.5014-1-michael.christie@oracle.com>
References: <20220408001314.5014-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1010ff7-9be4-4c1b-46e6-08da18f49819
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5550:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB555003E9FC8DA9BEC4B1A9DDF1E99@SJ0PR10MB5550.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AMc65co97umOaVH8cCcH/87MUgJB7eX8wkHLKZNAJKAPkocnDbhe086u+0ipTSt7QZetMrABxB/3Lke2623kgm+hCC5nXh0t4gUIya3BecLs3gkjJ0Ziyz8BjJKdlVi64mURmtPknWRzWU68JWipJpnGIvb2hRXPYqCyW0NRUfZv+wAa893p/u0zz1A0XExUhnOFohZ21ZzF0C+3dVwYaSBzuCjQp0Z9BMMCX/kTIu6Aeu5aTGrYAg3jrhAaQfTtG86Dd05MB61kKig5GViXJJU+BfcLHQRok2ma/t6csAxBAnrVzPV1rqYfxTI3F09/jBmqjv/f+BjsSuf3mnD/Q+BEDmTQlsyEbetAnw8hO5O1OSz8CuK6WrN80iBrN15gYcU0XNydZKRBFwMwTz5MZHorVbqWniIf1BQnks/sKbYrrhjSSd+nDNRJPtJ6lsSMKbHj/EeerQAwOeY113iCNoT9H4AEmQfAbko0P19HR4VZwX8sR/HZXmS9zVDVq9OCo2A8clYSf2gJzSI/p55PL1+O6fh0SrzW6+vHWuO8w5qSPfQlZ+0YabcoCvOrF2dEzBE7kTIoyhXPwdATDC/54O1ksECUzuJYyJi/kVDq8ynG4MSlnUlNk5LeteC6RqFt5QEO95AwRVqMII16C6CI7wiUoHlcsQ/zsTflhefZtH4/zTIimz/M/ALICLK/jQxOn78nCr/Tv6bXrLaj7Sr34A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(186003)(83380400001)(6486002)(86362001)(316002)(2616005)(6512007)(5660300002)(6666004)(107886003)(36756003)(38350700002)(508600001)(38100700002)(4326008)(52116002)(66556008)(2906002)(66946007)(26005)(66476007)(1076003)(8676002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hp1UXYN+EDLd1W6FceZmNJUlu2TxLPKHZaNknMemdUNO0vGYJJcsPVtDuEIF?=
 =?us-ascii?Q?OP9bldmIc8duVDiU2a6MPLt7i3LsElqJyCd4Yl0MxeyGpOUCIL6SdntYx0Vo?=
 =?us-ascii?Q?WFgNJidfxVmWvVmIRE7HTkMg1C4NLC9LEjqrt5wQFrwCC3OX7SSDfGau7sTb?=
 =?us-ascii?Q?FIh1VkOu4LrLCx5L6Y3VXkY48K5X/PmSIkctKeMLlo1r2IudgzHQIPhT8FZc?=
 =?us-ascii?Q?ufEkukDy5nDhn0m+31pDKiJnsYZmXp4+L8Cl5Cc/EqwiR+W3IWJ4tjxd2P/i?=
 =?us-ascii?Q?fElb++qwflVR0qV7IwxtyG+NS17xfCUG3KrfpIr64FstZ1eMD00oiHHVvpS2?=
 =?us-ascii?Q?OcKbAC7D76XMyiaON0brF4uENj7tVcxiR585E5h8G0Y1V8tm5YtovEEP/3K0?=
 =?us-ascii?Q?vIIQiiPBPs/+eEpZBMx9VXtFr5+k0Ufw6DXRk3GHuM6cUCP+7eIsDZaRB5Kx?=
 =?us-ascii?Q?4OPYaZdkHiOvj5rUk1Ur5g7t+5/xir+iMJZLErBySSpQqsoJnV8Y6br10myL?=
 =?us-ascii?Q?Qk2uMxDOwMTj0k421nIZl+rHVRA9G/N5j/xvm7Di1wi/KuQMWAQsdDVcR2Dh?=
 =?us-ascii?Q?BzepSvws5ZDC8NuLSDlOgy5NC/lYg7ZkDaBmm2/Y8Mp7Xc95PQKVwXJ/nWhm?=
 =?us-ascii?Q?Elf1mYgSZ3oGJRAq+zX0YYOi5dmaHvVEzFOmrHOKUlPFjAlLQ6DFG4tQs/dZ?=
 =?us-ascii?Q?cmESRUGtrjj4TIrO40GZ5EXHL9NTxEc3H8g2r3f/WFIU10d7UBWFQ4JSn/4L?=
 =?us-ascii?Q?gKF1Q1WFxuTbdsCjh7q4fLtsP9UxLmFR3fVDcj07iFdWrgJNL8jp2IexjfKP?=
 =?us-ascii?Q?OQVmBmz7aUP+JdC3WiHf8EJUwx+G826VB9Ii23xIfrcAzWs3p01XQ+MFenHF?=
 =?us-ascii?Q?gsgUQxEhpTcZbcNaPRpCPWnDdssoFU86ou/FUStYeEXd/IHrw382TamHtM5n?=
 =?us-ascii?Q?dljuPfM3vfBE6HfrQM0OFtKcyD8cQxduTXZSGLFvy2UeFQbA8Tmptuuu/X97?=
 =?us-ascii?Q?42Y58r5qxH+6ClpwrbajzkRmPqtARWXg4cVVCN9DgLgmq/V1xZcK44FWWRdK?=
 =?us-ascii?Q?wXDzt1/fsJ/tFfg89slxFD+z5uYvldlJtU4ZRi45Cw/c62hsRh4UW7VmdBX/?=
 =?us-ascii?Q?oTko2WRXrPDsOxN99MQRDZvQoaZOX2cJSiGfS+dQm+Sal6iEKB7gpW3K7L8x?=
 =?us-ascii?Q?0iDr/zFquIqcoMd+RBf33UgLfY+U8WK8Fk9Eut3JqbHaVKkhyXqqgKo+R1xR?=
 =?us-ascii?Q?Sq83TLSFEw99QQJKSWh+oOXx8/MuMbEf6HeLVXO43ZBYH2SVirdhnJc2z/4J?=
 =?us-ascii?Q?lugj7B0Z8CfdMwhzMZmlqdQfedno8DvyRbg9ephkZ61ACIQRsWkIAwJopb/8?=
 =?us-ascii?Q?wt4CcAfpephiR3Mpv7oN7N344tluP4JRU/S6tnlUhPc4724CXz3RrOy7Q8+b?=
 =?us-ascii?Q?4tyKwJkyV1VqJcFD/I4711vFxB41Abl5yNdR4VBb9Jv3SK0PRXJIZkcwlXjy?=
 =?us-ascii?Q?8v9+/GpwkWIwtMZr1jSU1nammAS+2/7Vj+11R8ztpceJfJgQe3SGJWJA7W88?=
 =?us-ascii?Q?7pB5R1afIgViyNmgMnGr4JQmIYVePULWfr5jAxptWB2NMiHKuU41Pj3hCIAX?=
 =?us-ascii?Q?ogBVi79np+fdkF+fHY+pQpSWAG2WxvddIVf6Xg3ubDUoZSYQVrtMa0HZPBBH?=
 =?us-ascii?Q?tPJ9GvEoyXy4eoIvZQ5EJXiG+6tkn72bXPxkAZ6bl+3+oGfWmYABJ/lR2PoW?=
 =?us-ascii?Q?dmEvg0hYDZfUP8+elZi4xgGxXBHpTTM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1010ff7-9be4-4c1b-46e6-08da18f49819
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 00:13:23.0476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K5icfikfNI+4Yqdh/1KR7FYxWckIdudn1z0H0dHSolQiipQsu/1fsNRpAtqYN+PAdFP7SJWAxYWdGudxOwp4vqaSXxKeTSQMOtripTZCtqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5550
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-07_01:2022-04-07,2022-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070064
X-Proofpoint-ORIG-GUID: sSMkPlWYAsMmaUWoSisU3squBjmIP1B9
X-Proofpoint-GUID: sSMkPlWYAsMmaUWoSisU3squBjmIP1B9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch moves iscsi_ep_disconnect so it can be called earlier in the
next patch.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 38 ++++++++++++++---------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 27951ea05dd4..4e10457e3ab9 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2217,6 +2217,25 @@ static void iscsi_stop_conn(struct iscsi_cls_conn *conn, int flag)
 	ISCSI_DBG_TRANS_CONN(conn, "Stopping conn done.\n");
 }
 
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
 static int iscsi_if_stop_conn(struct iscsi_transport *transport,
 			      struct iscsi_uevent *ev)
 {
@@ -2257,25 +2276,6 @@ static int iscsi_if_stop_conn(struct iscsi_transport *transport,
 	return 0;
 }
 
-static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
-{
-	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
-	struct iscsi_endpoint *ep;
-
-	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
-	conn->state = ISCSI_CONN_FAILED;
-
-	if (!conn->ep || !session->transport->ep_disconnect)
-		return;
-
-	ep = conn->ep;
-	conn->ep = NULL;
-
-	session->transport->unbind_conn(conn, is_active);
-	session->transport->ep_disconnect(ep);
-	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep done.\n");
-}
-
 static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
 {
 	struct iscsi_cls_conn *conn = container_of(work, struct iscsi_cls_conn,
-- 
2.25.1

