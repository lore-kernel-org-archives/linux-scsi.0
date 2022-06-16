Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49CF2C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 22:28:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378817AbiFPW2P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 18:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378918AbiFPW2C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 18:28:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC96606E1
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 15:27:59 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GJ44FG005248;
        Thu, 16 Jun 2022 22:27:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=tbP9HBuIDCVNYRj0G1nwWkoLkQ8X/eC/NBiQrmkzEUc=;
 b=lt2tt/pEcg2clTzGn2nWMqspyhSJ3uJL843ifFfNyJFdLLZQZ1eFkdweshNMM5bhQ1tf
 Z/6Si3yudkJi7RPojt81uM/EkPejlBl6t6AK/PuyjNc2wD1fTC6GRs7a9t52R/uvjsFv
 iE2InNYIe7x0aO2D4AmbC6nTRh1UrgsvhOkltQfYZFgTonYwvLxmP+tf06/3cetq937V
 NJD3XwdMu9/prJT8WjWoBsx8qAIx33TISs3sdjr4dfDfGXZw8PQYFFUvyHfSKLMD8qXZ
 Tdjq1M+TYiiI3wqMnPSkRl4Y9Yey83LdGjbdJzvQAwHpRRzICknXIm0EsI7oMWjQMSWQ Rg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmjnscfnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:27:52 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25GMG1fL013371;
        Thu, 16 Jun 2022 22:27:51 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpr7qjfvd-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:27:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8Sp3xaPL7i9fc//r/jWBVbujudndfrJup8674d3HOTlg2C/AZ9rL3fLdOiutI7RjP9QsxMp5QMmw1z3AUAzPSS55FpM4L6lTQu0x8n2A63JYuUgMyigiexI6QLJluvqCJULKsvlkfh6dargkiNSxQW0IJ9MzfXzCNg4N5Mhipx/efmbcMKi09tT5LgPcfK6rU5SDjfKBVJFpclEBsBEoTiHrF9N/bPs6QQcYKHcawWAwOj2rkZxPt5bW+16Hg6gIwE9qN/0VCdNpIozCI1Zufh62H0copHmwyIqhr7wI3XDbM29hoAsRPL7hHrtutO4bjOMYYKrX2KNu1s6KsdHiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tbP9HBuIDCVNYRj0G1nwWkoLkQ8X/eC/NBiQrmkzEUc=;
 b=HhQjKNlO0iSWrob0PwpKgIM+ZSdKoz7szZ1jFY2nPi7UIj3AdANGRHAY7S87v5fXv9m3b2S8uUPvITS12GhfC6bhwiYcRH7F776mEK82MeUUIIxOyiA1jMW0sECSTXBVMD3EXB5ONZ2UevUgQQVm1GsSL+oJUolOxG85O2wt7UfuyNFVBB1sqw6ILJW3BkZVFIF5ebH3W8peWSO1BXfAERyVaXUK085RbYbERGCPJPlVm5ugotM8O8PW+d8hQu/K2IMlbM2xAQbthGJBVLrwBmgexDGgVDQbH72Da/R0E99WxD33lBDr0x2xF4mntN4nD4TkzrDD3cmFzFf2DrvtNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbP9HBuIDCVNYRj0G1nwWkoLkQ8X/eC/NBiQrmkzEUc=;
 b=In+k2V7l1gKgiiMAro4gKNI2gkaMinRzzBjeSJr3LHWVHBPL8/xMIKDwMjuR9UO4Go1g3PooRMf7fBZmRVZBtg1iit4t3hR4bjcBeMbWD2MS/HhqsDsw44kkVGNdJe4+/CORPLhE/8suYeahWv2r8Mnh2F7NjC7oL9OFcjnZM6w=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN6PR10MB1267.namprd10.prod.outlook.com (2603:10b6:405:e::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.14; Thu, 16 Jun 2022 22:27:49 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Thu, 16 Jun 2022
 22:27:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 3/6] scsi: iscsi: Cleanup bound endpoints during shutdown.
Date:   Thu, 16 Jun 2022 17:27:35 -0500
Message-Id: <20220616222738.5722-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220616222738.5722-1-michael.christie@oracle.com>
References: <20220616222738.5722-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR18CA0070.namprd18.prod.outlook.com
 (2603:10b6:3:22::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94c5a2cb-4c0e-4ce1-52ca-08da4fe77217
X-MS-TrafficTypeDiagnostic: BN6PR10MB1267:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB12675F61B296B5C89B611135F1AC9@BN6PR10MB1267.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yVGrQbKtmhq00ZNuyV/Oi2OT2Nod+PZbm1/4HQspKAd00ddSUv4UyCLg+nxlj2P+5M9Jxcm0GpvHd7Gd8IaUMF/PqSHVrFWtHYvxobiHGuMMmUpi0XExQWAZGNagdn5zKe7KCltQ6t8qr/jzwuo1MB62dRLGawg43cP9i7Kd0ewRrkhkSarSIJKrOzc7vrFAGLQCtL2rtR8HohBYyHt1DA4Wirt70tBZjziRMaFF+2j/nL1I16GgWbP3oFYTMdFS/318XKLvwx5tntAawBVqcS9qW63sT8O3Sb1mzma9onXxHPcG1/mj7lxwOuAlJ4zQO1lIoQYNY5jaIQRQdxbTRPQX9TitW2VN5+DEyYXOSyL0dznSeu97HGRsTZaoWeSb/4zw6WZz5DrYiGqiZ+R5c3XJpPqAAvQdWl04/NHjXIXiJd3oZhbnvXhsaJACSHceytuUdcdHHtzDlXq4JG9pF3sZjhdeT1ghQG1/OHk9QGJlIKM3YkEC4atNOLvA3enq4vte1l0FGlaegRJJpeoF2mAKCPBoB3wo/w4mYtRJEGB7QNcOdPObLb7AptO4jNcVlYxrytbEa6ZLpAeAeoVtQROBN4wEiTBZ/tgeV2KVuhnK5ns0uZMi2b7rq/S8UbSRPF93IbtuxsFZi3LH+tFXN8dm01/3r5rqjPgEdY7JONCtLAGSyBhMplYt0zAoh73p9gd3hWT7Ujq9BfO3eZJqcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(5660300002)(83380400001)(107886003)(36756003)(2906002)(86362001)(38100700002)(6506007)(38350700002)(26005)(6512007)(6486002)(1076003)(2616005)(508600001)(6666004)(66476007)(8676002)(186003)(66946007)(66556008)(316002)(8936002)(52116002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7V6MRrgkJA3gIlTH97LcnZn0IKLbCDrI1G4wIMqA36eWNcxwB2l8UFoXAwfP?=
 =?us-ascii?Q?VemnI8YdEF/JTxzOzZMGOmDh5FZoCzaHU1plEC8MUIqZap1bmcSlfkwiHfGr?=
 =?us-ascii?Q?FKy4tyDlXRPXgAwDr9oygt5aX1VIRYEfpTWy4I/vk5XQ4EjG8Vpp9iem1Goz?=
 =?us-ascii?Q?KjNbeqzVOy01iUMrR3NgsBHucC02P4HaGcijvUUClv13EO+iGOOTTKfdj299?=
 =?us-ascii?Q?1Qu+a6hFRyuoiHeAG1G+B2e0nAS0HNousSjD+sJCGo/XXke78FqTtuiqHigT?=
 =?us-ascii?Q?KN3jtxmsemdctO13rlrzpCKvvatWWbyq7QrTbBD+7fYK8DlSuYprCFF1samk?=
 =?us-ascii?Q?krgCtzyz/2BOwywp3rYBebxJi8rsGWL1XDSVcohTRBTQVB0zpK8MygueNsZJ?=
 =?us-ascii?Q?wGMowUioIEH2lkfwInbh9A/sN739RGxH0EbO8gt1w53+jfe50C80xB04Wjqg?=
 =?us-ascii?Q?IJsoOPBvdGL20SFMPKqT1xJu+xNbRmXfq5f1wbR6PRPEzTT62/8IOXhHNnyO?=
 =?us-ascii?Q?h9O1SGUCNcGHGlo1H+8dzFlN38ZZB3UDC9chkxYUF8lklbsOEzpb3ql/kVP5?=
 =?us-ascii?Q?YoQwaMybsC0CyeaIaTHuaRKdlEOf1ceh3k47c5G65MgwjdHz7BvoI62xOHUC?=
 =?us-ascii?Q?/vYCtXyovQYvfvQkzQvbqCu+THn8adi3cV7CH6vLPBL9SEofTQkQit6eYwOR?=
 =?us-ascii?Q?vMoFfAoOYTvX8C04SIou1l+CqH3KlrEPCsWMKYhM/k504i9dt5ulazg8vpVD?=
 =?us-ascii?Q?Mc/aOy9F6FBBg2fruFnpTTBLvCMEdOBn4pnbeWqLUr9ZAdouz/7XSMKSccn3?=
 =?us-ascii?Q?M1yWiTtBCRUdtZvY9+Q/daQhAyhEgX4TXXirkLkaURNSSGSEbzMHhgC4sGsq?=
 =?us-ascii?Q?5NDddVFW4s287+OH8pWXKumW9+MRGINsM+mgVdz1lHPKpnm1XHtiGZ9c7qfg?=
 =?us-ascii?Q?PujysmLnyvjqFYjUadGDkidrjC1bl/9TbaR5SUWB5eg3sa6Ej3u/RxGfbDWD?=
 =?us-ascii?Q?a4TdK3jwEi+Nbmbl0UGuSRwbz4yd6qB+YFbQRZ9v8EbisUhM53atwmoPXQi1?=
 =?us-ascii?Q?HplYi5twlToLXlUP2ntcVdTL+q0dgn6p+1LEUgFMgqHyAO7wLP8/F6AjzY6t?=
 =?us-ascii?Q?nVJSXsR+wN05db0J/qXFqQVtrhGd1PirsVMQ28q4+6Ry75PMSEQDI4sIqMBW?=
 =?us-ascii?Q?kmF1209C9uKHOkZPJE+wR3JQkwpoTEMDmz8kIQUrP8eFwZro9bMjQ+6BrkxO?=
 =?us-ascii?Q?qubCpNH8/s8HApPwi3uPcFWBNPAe5qLjNLoFQrabBPNtoAdkOOBAAS5XvIQy?=
 =?us-ascii?Q?lajffvGlRBhBBL3P1fgf/FW5Azcx6KR8cLnqmM3Kri7oKS90osikE0wYglZ3?=
 =?us-ascii?Q?f0IrMZhVLYc7BI6YVPq492hPAlSab0uwUUuiAxm18FH92TqGotS24J7kfzfI?=
 =?us-ascii?Q?rqhxN9Dkk5Bz7je/TwHjNQvXngf9XwLJnJjcsH1f+pIc8FKrmROn+ScCZW8i?=
 =?us-ascii?Q?gKU5mBtttKVBNNMA8EoA9poDiOhRadGreSOEVHOdUrbx/W5tUwrRUzVEyC8V?=
 =?us-ascii?Q?8uiaJCI3h46ZxMi9rpd/vPMYJ75Vw8KeK6fFwp77/3ULpyA7ldL7855AZfB9?=
 =?us-ascii?Q?2mEu/B87O6xA4C8zhxGIvzUiFkUJwKCTeS8lncQoRMKKg34dWTaytKxL5nsw?=
 =?us-ascii?Q?c4puFfCN9moe8ZzAG47qoNwjznZBAF0bBB5KLOPlnOOd5y8qmd6qkKW8Rle1?=
 =?us-ascii?Q?0Dokayysu0UnBrC33uZExwPCYK1e9V0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94c5a2cb-4c0e-4ce1-52ca-08da4fe77217
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 22:27:49.8079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZG+XlHjcEvhitlSIvdFmgYQPgPk7QZPrcHPc9Y+Vcd+H8x46m7/pwffG2TGYlugwcrt4fRlTpx8UOZ3XgHyN1eMfZ47KFMAnevwqkzupfEY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1267
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-16_16:2022-06-16,2022-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206160090
X-Proofpoint-GUID: INWCaJMmhLvbBkIVn2gl3Zhgd3DOCiD5
X-Proofpoint-ORIG-GUID: INWCaJMmhLvbBkIVn2gl3Zhgd3DOCiD5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the next patch we allow drivers to drive session removal during
shutdown. In this case iscsid will not be running, so we need to detect
bound endpoints and disconnect them. This moves the bound ep check so we
now always check.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 0d83b6360b8a..e4614dede7e9 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2260,6 +2260,16 @@ static void iscsi_if_disconnect_bound_ep(struct iscsi_cls_conn *conn,
 static int iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
 {
 	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop.\n");
+	/*
+	 * For offload, iscsid may not know about the ep like when iscsid is
+	 * restarted or for kernel based session shutdown iscsid is not even
+	 * up. For these cases, we do the disconnect now.
+	 */
+	mutex_lock(&conn->ep_mutex);
+	if (conn->ep)
+		iscsi_if_disconnect_bound_ep(conn, conn->ep, true);
+	mutex_unlock(&conn->ep_mutex);
+
 	/*
 	 * If this is a termination we have to call stop_conn with that flag
 	 * so the correct states get set. If we haven't run the work yet try to
@@ -2269,16 +2279,6 @@ static int iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
 		cancel_work_sync(&conn->cleanup_work);
 		iscsi_stop_conn(conn, flag);
 	} else {
-		/*
-		 * For offload, when iscsid is restarted it won't know about
-		 * existing endpoints so it can't do a ep_disconnect. We clean
-		 * it up here for userspace.
-		 */
-		mutex_lock(&conn->ep_mutex);
-		if (conn->ep)
-			iscsi_if_disconnect_bound_ep(conn, conn->ep, true);
-		mutex_unlock(&conn->ep_mutex);
-
 		/*
 		 * Figure out if it was the kernel or userspace initiating this.
 		 */
-- 
2.25.1

