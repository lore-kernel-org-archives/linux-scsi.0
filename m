Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 442B4C43461
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E95D6115B
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237987AbhDPCFZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:05:25 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46198 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237980AbhDPCFY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:05:24 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G206Z6179689;
        Fri, 16 Apr 2021 02:04:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=A8BakktgdJusWiYfRJki9vRpDbBs+P/MJ2IULwrnIyg=;
 b=FXAo1G7/uRBSeN8349AZ3sERo2mwOyfRgv4TzDKm3jJPTPnWMKJq5W5yChBsbcJi1YXO
 eEFQ6ZjR4IwH8/aUoC4m1jVXGTF8S8xR1uphq9j0ooVdoRQYdRIczSc0TeP7eUbAkRSk
 6aIhVb1qQ1lRcUbYO0QkawYHZ32SW4Bzo/9fO/NU9/kfL7NmN/ODYkeJbJyx3nvEqkAa
 obdPu6mLdXIXuRCalpk3jsGn+bjAdyDZOCVEi08CeAXSMZPiCBReQgPmLBWpzo/9iPlQ
 +eekrauFwKt4A7+5EJvxjKc1oE23kjIX67zYPsEBrmbt6lWlXZ3bQC1N+63Kju8Pmc6h Jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37u1hbqsbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:04:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G20eZH001033;
        Fri, 16 Apr 2021 02:04:54 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3030.oracle.com with ESMTP id 37unktfb62-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:04:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJk8EHW7mycrHsJFdmqp+i7TKXuCCUP2MzDT2UJL7cBvZU+PuVArdMbpVu3wsPzz8JBumVp9AcjJ3+YZoSP99/75Xqla3R0TKDxb+Thn/qw7FsBtcY/WqVoF1xAJlMA54fmBWox9azC2bWirtTPvcA6ExTuJh4V+C3tSf71T/MTm54nx9i3DVA6FQqTddEF33Tjz11K/UGU2XanuHRyBBlNt0VIdh35GcOQKIo680BJMNKks/zyJLbS/wvHSzM3J+S0xHAQVsjKIErlDJg2gKEl31k/ddAG1/uApJh3qaIJPs8PqNvikbfFv1PsPDMTTvj89ZxFiRhBNNeWLdikP+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A8BakktgdJusWiYfRJki9vRpDbBs+P/MJ2IULwrnIyg=;
 b=jO30PTpyfx5KXRWuCygeKTTfVCel9GZsFFgIhpXsOXtBC048NNeoAD+PPs0C9ZWbqdwvbqIuHjR/xuO5mYTMpawduZcjG1JFkOnn/iqRsopTEyAW68pklEhQ7LGMQU8ID3tvZLQksm+6Vv9kxo491M+vR+az/xQPf/VvoAxmMNUOVnm8Ai4mdxPY+Pg+nJ2fzxju8y1UsLYc+xVO6miWshO3pOz+yxbDWpIYCB9vkZneg/30Qtiulwi/+Sm++5Lx/Z+mZ/eroMljc03v3Z0Yg8i+xt+jueA0l0TLaTRQSLx8b6ZeGf5ZXpWlesc5cPSoDCkN4zhUxyhRuzeb+DODNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A8BakktgdJusWiYfRJki9vRpDbBs+P/MJ2IULwrnIyg=;
 b=toCxGqOVyPBFKkWvZUl6xr1QqV+eg0PoRoQzfSUDGM8nZL2Zls4BvHnAQRpmexRGwzXOjGPMmc8NrauAKVvdTKdfS+xYwaJq3z2lDj9NJMiNHUc5WLh+15QA6+4d/ML8XMM/LG2Txh0SnO3xyQUuroOYFeae6Q6l4NtbtEO3gJs=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2421.namprd10.prod.outlook.com (2603:10b6:a02:b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Fri, 16 Apr
 2021 02:04:53 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 02:04:53 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 04/17] scsi: iscsi: drop suspend calls from ep_disconnect
Date:   Thu, 15 Apr 2021 21:04:27 -0500
Message-Id: <20210416020440.259271-5-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM6PR02CA0100.namprd02.prod.outlook.com (2603:10b6:5:1f4::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:04:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22ac513f-22f4-43ea-b1e8-08d9007c0674
X-MS-TrafficTypeDiagnostic: BYAPR10MB2421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2421ACDB6F79BE2EB965F472F14C9@BYAPR10MB2421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:663;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c+MJ8rpxXZa8a1KCdro26KqYiAI6lRNOpb5cbgcaUUd5mJ+qS9s5KgKV521Zr7R/waQj5yWl8hfVSJFvxR+yex3kSvBkE77ALlX3ZkgGmg+sraBr6E+HAGnQ41CH3PHYuwBgTfScEdwEB3iRPV3w5Un5Jm6uD1NmTVEyUpAL0W9BXEoy0H862nukOfnNDYiBnPlNscXuvaE4anVJwJerZANhsa0xDxRp6ZiZjs9N/OqClQ8n9wink9MdRliizhk+dZgnsUXQ/aO/jdLLNJl+CpDHE3OdmzNx1Rrb6KT4dV25neQZ/1zwNvA2zXiZMiG1B5EzbTWBybtA3E/6tYzrB0o4RWmlVnhfhj2zibJ5Vnl8nyePL1t2RGUGjmZdPUAlQ7OB8HCQFoFqs+02I/t59m+Vet8PqysrafAXeKch2ysqHEMYzE4kDtOhFjrHftyepzGutUdD2fCVTayMjO9pZo/QA2Cv48i1zcB926SsBWsZKt/3XgRqE+L3HdD2w2yFh7yaSFOVm1+nNF06S8sHmELdUWGJQpJJtwpOeuarNrDej1W3i4LwuJIq4W3AC2y89N60BPoitT9eUt+XFc8aSdhtXV1a0ieE3LOVml2sE+fMW6N4tXMrDn6KJF6TPoXWwNLFHNOtf5JCae4ufBY/s9cAY1GLxZwQT8jLRkC1fN+QVcWOeS/PrLrlWjf2Ws7W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(186003)(69590400012)(16526019)(5660300002)(1076003)(6666004)(36756003)(26005)(107886003)(83380400001)(4326008)(52116002)(2906002)(6486002)(2616005)(6512007)(956004)(8936002)(8676002)(316002)(478600001)(15650500001)(66556008)(38350700002)(66476007)(6506007)(38100700002)(86362001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yL0QdoPlROAXDYGCcdzqxIW2G/LL5+FMkqa72M406fsyeXifmTD2ZHzLTl9H?=
 =?us-ascii?Q?DNzErZZhNJ/sCfba1+0UsLlvhq+rwQv5fuPId7Phr3IqcNekPYCkQPZMwyOp?=
 =?us-ascii?Q?vEDNWpjczqZtJtNAy4vmISQSnGduk1Q3nZsbSGss3Z32ZaDx8y09vbvkXFRt?=
 =?us-ascii?Q?RbMuRjyw2RzNIT9Sw5mNnBBiDEk7L+K9e3HhRTtVwQJKmTR/x6Dw/qSZyNBz?=
 =?us-ascii?Q?kLczl/1LOSCKlm3MqgiGzTRO8iLUKnhJyRVUEQzpzIaZWX80PvJ0sNJzGg7e?=
 =?us-ascii?Q?UzmQtlf6ZtscEI0JjprkWqvO9ZpT8Ya9psvk2zM5PrLQnnTIgF72n5ZMfYKt?=
 =?us-ascii?Q?Eri90HAJVjDAb/BbXFTkZkRoCzl4H5nCmYMAramKbrMKhA05zeTyL9rUZoXE?=
 =?us-ascii?Q?7kb6RX/tiZOs1DfPdk3vy64xvmQ8ST2GzsFxJWvM+e7AkYa0xOSHrSJkX3zi?=
 =?us-ascii?Q?vT4A/d10txvh0iCFqTuTDDkVukFzQ40hn44/50JR0OurQnsOsU5Z2neDaTPZ?=
 =?us-ascii?Q?6CYIRLNrwSOr0mv8D6ndEOhz8upCfegE8rWOLZAQ3odmRP3gf9ZSuTjyaCkY?=
 =?us-ascii?Q?0MFNswU+8O5aFZ4fx3bx+zbGLcfYD3a060UJV8OK52TNYsQJNli9TYwD3Wy6?=
 =?us-ascii?Q?z1xV7AnuVfP56YFN0qwdUuxNUL41KSEf4eW8u7usaE4Tv9nteWFDwcyiKDrP?=
 =?us-ascii?Q?3rs3hoKUmiax1TcB9QjX8K789cS0zI5YaQ9oKTerA4ZQUqqJ337wbufMqCZj?=
 =?us-ascii?Q?r7b0ZWwxoVnxaQLfiT1ZJe6OAXhqJ3vmtwYRpJlsZkEL421F0L2adp79YDE5?=
 =?us-ascii?Q?FJhoarAO4HM0wAts2VrAke9Qa4CWxggKH6AZyRvE1Vf8jFB8BUK+GCQmeBlm?=
 =?us-ascii?Q?uDv6EHU1FvCodiJDeF4MuGFNqw8C8t298rkmVpzm1yjwMgIsNRCK79EtPlh0?=
 =?us-ascii?Q?wnL6OmnNQFs0Wrn0F5iIfZnnI9oxRFbFbkMnT8j1m8Oa+GysqtuMe3o11HFe?=
 =?us-ascii?Q?KAx9FvZ4PQDJCUfHdzIWlgp9w8RfLBF/H+VxABB7JmdduZjvID6NYopQq/UL?=
 =?us-ascii?Q?SD6FaOfnGiQJPfzx4q2jmlYcd/0i6osvvvfkvT5Jm3KNo634yaLb7rSySAku?=
 =?us-ascii?Q?vwygLtv/gqsSuz9zqua+NUzRoq783sOsdhuGyTmzWH+vbE4b66yq7W74jWS6?=
 =?us-ascii?Q?ZgZHe6Xv/0PjazgqcwXoTXecJVToZAnlURExM6by/j4OC3Wi/iBnCn2JUnLN?=
 =?us-ascii?Q?x0YLxMTJpNtWrBnqDUfRqbSiwDKfEe9B5zK9YcRD1GK3ON+GNuxRWEWY8I+w?=
 =?us-ascii?Q?Bi56lrnPc9zpTEeKzsfMYRSC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22ac513f-22f4-43ea-b1e8-08d9007c0674
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:04:53.5800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CpOMnDw7eLuwjJOyfqGEfmnBVFC4Ek87L29f4QuP6idObEOjqQlSwpkx69kcLI8/fBOEA7DHtDlhkaKvzK/IlqNsUl7I5cqjwply2r3J6zg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2421
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160014
X-Proofpoint-GUID: scYfaFAbJ5gdcYiKUB0gOykQwZCM562I
X-Proofpoint-ORIG-GUID: scYfaFAbJ5gdcYiKUB0gOykQwZCM562I
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

libiscsi will now suspend the send/tx queue for the drivers so we can drop
it from the drivers ep_disconnect.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c | 6 ------
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 6 +-----
 drivers/scsi/cxgbi/libcxgbi.c    | 1 -
 drivers/scsi/qedi/qedi_iscsi.c   | 8 ++++----
 4 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index a13c203ef7a9..a03d0ebc2312 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1293,7 +1293,6 @@ static int beiscsi_conn_close(struct beiscsi_endpoint *beiscsi_ep)
 void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 {
 	struct beiscsi_endpoint *beiscsi_ep;
-	struct beiscsi_conn *beiscsi_conn;
 	struct beiscsi_hba *phba;
 	uint16_t cri_index;
 
@@ -1312,11 +1311,6 @@ void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 		return;
 	}
 
-	if (beiscsi_ep->conn) {
-		beiscsi_conn = beiscsi_ep->conn;
-		iscsi_suspend_queue(beiscsi_conn->conn);
-	}
-
 	if (!beiscsi_hba_is_online(phba)) {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
 			    "BS_%d : HBA in error 0x%lx\n", phba->state);
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index b6c1da46d582..9a4f4776a78a 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2113,7 +2113,6 @@ static void bnx2i_ep_disconnect(struct iscsi_endpoint *ep)
 {
 	struct bnx2i_endpoint *bnx2i_ep;
 	struct bnx2i_conn *bnx2i_conn = NULL;
-	struct iscsi_conn *conn = NULL;
 	struct bnx2i_hba *hba;
 
 	bnx2i_ep = ep->dd_data;
@@ -2126,11 +2125,8 @@ static void bnx2i_ep_disconnect(struct iscsi_endpoint *ep)
 		!time_after(jiffies, bnx2i_ep->timestamp + (12 * HZ)))
 		msleep(250);
 
-	if (bnx2i_ep->conn) {
+	if (bnx2i_ep->conn)
 		bnx2i_conn = bnx2i_ep->conn;
-		conn = bnx2i_conn->cls_conn->dd_data;
-		iscsi_suspend_queue(conn);
-	}
 	hba = bnx2i_ep->hba;
 
 	mutex_lock(&hba->net_dev_lock);
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index f078b3c4e083..215dd0eb3f48 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2968,7 +2968,6 @@ void cxgbi_ep_disconnect(struct iscsi_endpoint *ep)
 		ep, cep, cconn, csk, csk->state, csk->flags);
 
 	if (cconn && cconn->iconn) {
-		iscsi_suspend_tx(cconn->iconn);
 		write_lock_bh(&csk->callback_lock);
 		cep->csk->user_data = NULL;
 		cconn->cep = NULL;
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index ef16537c523c..30dc345b011c 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -988,7 +988,6 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 {
 	struct qedi_endpoint *qedi_ep;
 	struct qedi_conn *qedi_conn = NULL;
-	struct iscsi_conn *conn = NULL;
 	struct qedi_ctx *qedi;
 	int ret = 0;
 	int wait_delay;
@@ -1007,8 +1006,6 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 
 	if (qedi_ep->conn) {
 		qedi_conn = qedi_ep->conn;
-		conn = qedi_conn->cls_conn->dd_data;
-		iscsi_suspend_queue(conn);
 		abrt_conn = qedi_conn->abrt_conn;
 
 		while (count--)	{
@@ -1621,8 +1618,11 @@ void qedi_clear_session_ctx(struct iscsi_cls_session *cls_sess)
 	struct iscsi_conn *conn = session->leadconn;
 	struct qedi_conn *qedi_conn = conn->dd_data;
 
-	if (iscsi_is_session_online(cls_sess))
+	if (iscsi_is_session_online(cls_sess)) {
+		if (conn)
+			iscsi_suspend_queue(conn);
 		qedi_ep_disconnect(qedi_conn->iscsi_ep);
+	}
 
 	qedi_conn_destroy(qedi_conn->cls_conn);
 
-- 
2.25.1

