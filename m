Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB832C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 00:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbiDHAP6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 20:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232728AbiDHAPl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 20:15:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0906C129EB6
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 17:13:35 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237KPqpT001019;
        Fri, 8 Apr 2022 00:13:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=34wBEfPdQzUxy7m/ionnlVKAJ0KYEGYR+8FG1SXvDwI=;
 b=DKMbbDvT8rx/6kxI2LCexOeiKSxvKPwtnNyPKsj9w5Gmw7wp1GsH6CWhQqm7K3H43DzF
 Tp+96RdwT+8ROqwg1Bbq1FCrFZ4Fda+IUJdboL9K3j9/9E+KDmBsTsCwLH9qbEKHB4tq
 bppzol7DcfxGlnu70ROwaHTaWvFNZ5LTwmctubaxjHhO2MctaZL4T+szOPk94nmK3JcZ
 PX45e+t742sMiLlEoJG0jnUfkZbL3uuJaOLsiAtYU1kKpQKHojgAhR9k/YnlgMTVqmZK
 M9sbTw2TThtK4bVjLvFgsfDCt38d8ZD50Ct0y9bTEiM7Vfk/NSsBtqWjxs/ZyRiPfz9i +Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6e3swbyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 00:13:29 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237NFHE5013838;
        Fri, 8 Apr 2022 00:13:28 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97tu11q5-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 00:13:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ppx9/vXCdGTa6BRg9hkrwun/CEGm6wsqQj2cgzP6tu/MHOwE1HKLDF8jHpKSM+athJbbKdjCIJXqzSfHFwFQwIzhRzXDmU1VuJskuFik5TloTrjovtwGkGfy+lqH/SDw+QSy4/WW+wRIqwGjKRZU13aSSfuZlWmsylqWb6YlF1FkHjT3UgYiR88pRu5R/1QIaWUyW9uXZmH+OydClSIwBv2FhMFsmPosxKLOpG16XsJ6gQFTDmPatIoqqOAbh+biimCCBkePO0esXh1eiCokfi2df7aUWCL+RIZZBazyfWBl9JIkvwQzcaFBlDkeI4cRI+lZaLC9YIY0+1YCljMM2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=34wBEfPdQzUxy7m/ionnlVKAJ0KYEGYR+8FG1SXvDwI=;
 b=BVrJH/1GIfrqSkgtfpmrKdOJmjK3ALnMNxhH9Ffpf7Kgxn/D+5oXqhQQhoHuO45/xExqG3ydtcZXRGdHJW9DgZJTB07qvIHoUsm8dHbbO2U2Gv+hwkiPCoEstYVex+V9O4Zv2xo3hrW7ZX7ildM76V3Kk/vkFPWR6MzvVJ7/fqoWs8+7aPU7yU69bd2yG7lX6mGzoHTKUr/OBpJ+ltetoiWN3OrsY8tKdUSk4pTR+s9yqq2wFotke3+TbC+Y8ub3TrhRX6xgdpW/Y3qe3fw8nn00nmfY2RASP8FMnz8BRYwc+EB/f4ZBa15KUrjCTu5dBZ5SwDtmMMgt34k06e9SsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=34wBEfPdQzUxy7m/ionnlVKAJ0KYEGYR+8FG1SXvDwI=;
 b=fM1eb/5ZhYZqsdXJYEMe6YS0n+4OOehCdq1OvEFpW5C7TQVaU7pD2/JUnVPMP/H4IHR2XeEp7lp8/NFKNvaFP9MVTk42FQcueOrPkDfg2JNve46a8sDZdX+HwXnYAR7fi6xJaMA0mEBEYIqsrjic6aarOrP5wwltZenAX7JHByI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5550.namprd10.prod.outlook.com (2603:10b6:a03:3d3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Fri, 8 Apr 2022 00:13:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586%2]) with mapi id 15.20.5144.022; Fri, 8 Apr 2022
 00:13:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     skashyap@marvell.com, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 06/10] scsi: iscsi: Fix unbound endpoint error handling
Date:   Thu,  7 Apr 2022 19:13:10 -0500
Message-Id: <20220408001314.5014-7-michael.christie@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: daafeca8-2751-42c3-b6af-08da18f49996
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5550:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB555050C8CF69E83AD4ADCD32F1E99@SJ0PR10MB5550.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n0exNtxyF53PYXJ+D704hN7dswzbDELhBnJc+crbcSM03VbgrZMsmJFRT2qpWFS7QrHQciAZfsx1b/6p6mNf6PuFl/W99G4Q46ijrpNOKOz+5tkhsGPvgPdS709GYbmux2GHadfxL3j69j5rPdu4BjwCWDSfLyS6zbwtMiVKAFfIuyi3+ufRadv/wJAmB+F8cQMIWYI3wp+hfBlD1s0gPeMeIwp9wpJdi+c12x+jsR5OVbWJf29QNEbOBFGOl7qm5C3R7iBiUzohcyAtmvdcQ+ITSBz+TnsQHZdlrtqIERpXkARhz8PlkV+Rhi9Nl9Ptw9u9HtGmeAxxam8s0CvkKxUOHCk4MD/+hz3JwYsMkv+kWF/atukjpyOro3lcZvWfXUMkZahBdlSnz8UqujRdpUuFHdewLluYwX0pwCN+HfM8oAyvacYiZbBuKKn3a3fCdYP3RxNm+93YH07RQ/NicycKwuMZZm0icaA414YAV7RcHMx3VJlfAYsCCgi3lwVuzc8JA0vmL2S7qu62KH96ttd1gujwAmDlt9JIh2AUBgT1aRI2nH8ffm1c2l7IqNQWJC20gY07dGcXFZumbjSlyKgDAkNPjQqzR5sItfV+JJyqiVOKlu2GPTTeBnkz8+ESUDk0ZYOYqYQ+1coxwXVy/FJ9Z338ppfPz1GkWW2/eKtRiXSDA0OH0jt5dIXJGXBxo5OYnrvMAHgyYp5t5inQ8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(186003)(83380400001)(6486002)(86362001)(316002)(2616005)(6512007)(5660300002)(6666004)(107886003)(36756003)(38350700002)(508600001)(38100700002)(4326008)(52116002)(66556008)(2906002)(66946007)(26005)(66476007)(1076003)(8676002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J+jHb9CMvoxSvJ0YCQNzBvq+5399YZbwXJxkOypFZ/1OJkd8eerIwyZF9NUs?=
 =?us-ascii?Q?BtHHU2IytAtdSmu9aklHXtbrqcNpnCu86EVNeqny4nR4wgm80ANlHOOZgZj/?=
 =?us-ascii?Q?Io1xQFEnLiL+pf5Jjgcrx9j5hvvd6QzOyMFTUX/6OBas15b0ZZzq5u+Q0E6P?=
 =?us-ascii?Q?mw88kJGaQ2B9d6Cfw2TOEDtA45dwDCA+ndcJe7DcPRSGVoGLEYpXfA053n4y?=
 =?us-ascii?Q?VMYkyGx3DatG15qFlOLB6PowI+h99wSpwgLXBBsRBoa+Lj/SBUiyN1uAbIoc?=
 =?us-ascii?Q?SQJK7J6LxO9c5td0FJFvDJzpuFGNQonsZGpt7o8E3/QO8JaAbsihGXW3zJdZ?=
 =?us-ascii?Q?cNJ1Inz2+NTskS9kY1PqcQDBW5h6Cqb/KDXU/5rIdKBgpK3EAu6q8hOIRhRK?=
 =?us-ascii?Q?up0lnjDgx+BvlPkxtEuIR1o25YPOjCXnO8DEdPZwv1f7DYi9Wn+2q9FGYZhM?=
 =?us-ascii?Q?BDuxOfOMQUdLGxj1gQJ2qowiEv0vtcAiSs/mhw4eAxLu+z2/zqeO7TEUtdJl?=
 =?us-ascii?Q?zPTX8P3vjKMAQd+QjpFkBpb0gZCwNwcIFAjDYiEC/CJdYxkXkyUVfp35tfia?=
 =?us-ascii?Q?6084WP1iucf5mwdYN/6dAWTnBoGXi96dyCvly3J2CT9Zz4Y6OWvXXO0LvRIe?=
 =?us-ascii?Q?r+nqq180ewwV+tnC/JAvE3GPdfeoUKY1apNb6i8eSn+FUn8du6IP1CEd5hI7?=
 =?us-ascii?Q?yexbLwkkdqfEk8GBk+8eTTgdtCkSbe9/Gj1H4M86niw48MbpkcXaab3Hu8HY?=
 =?us-ascii?Q?N4jkbmDdM4Yb0NDOt62ZMlqhViDxUyBcah76ItfP+pjXuvrLp5JFbfJvkwSp?=
 =?us-ascii?Q?f4xzpsoo6HbnRgcJRggVaRwlwGcikJH9tl8m4eOpVTB2AV6/QD/ZCtuRPp7j?=
 =?us-ascii?Q?/6G6djmPGHNMOasQxKABh5IYJRa+A5vD921GUt2V45vf28hs/bL20QH0NsPn?=
 =?us-ascii?Q?U2Jd+kRmRIH3BsRCIjuzH/F+qjp5NUk+Ocuk+iXMLkAtT4Z28jKx5DBZK/N9?=
 =?us-ascii?Q?5f+p960Vir9fxxH5E1xrrvOCVsO7X3zwv0sAKR6LG4yrv/fkKiJv2yDRyBPZ?=
 =?us-ascii?Q?IrOvvHm3cb1RFRehx4IE32t06SLzxitjfcFAys81CRTE5Mu8f2du5Mklt+8j?=
 =?us-ascii?Q?4U8yjKMIlYPXJpm96rlCkfi4pdzWCz2PLqXu6LSVJlV7Esy3Y789EBu674my?=
 =?us-ascii?Q?UBfeu2MksSgiK/8Ip0vi1T27pWE51ABsDnpFdejZbUnDwRSfcvFlniKT56jX?=
 =?us-ascii?Q?0bruKMSJCK+BGyAgcY1Nz+B828s8GSP+B+iLTPbUBWBc7SVwNFBBVUPLsuQG?=
 =?us-ascii?Q?lBrLs1fCB9xecwrPMMDdp+lkoSxX/ubo0zhHgzWDR+3VQeB71Q5xM3wo1KND?=
 =?us-ascii?Q?cma5sMQBA0eYR/OlZ+R2JFZX7cgskoKFdCEhDJeoosr4VrncLc74s0PCmHjY?=
 =?us-ascii?Q?3KEc6Kj0X5vLhRZxyVDECJR/ZJDxjxv7g6X0t9/uaT12J8sGUlUdA8I8Ne7u?=
 =?us-ascii?Q?i622vaqeA324Jhnpa7okz0Ds+lp+ELJlW9jEhvozdZPBJDUlwOfCk6cFdg/w?=
 =?us-ascii?Q?l44csNxZ++ACDk0cKfJ6OCV357T6QErsnzP7GGQhQTHErgdwM9/XnCXe1/lF?=
 =?us-ascii?Q?O7V3Tb7xEReY7ClLtXVpccVsNRnhO2YpXpCALmsLByYYZHFYGHumdqkfRF8f?=
 =?us-ascii?Q?hE1ae1biFzlFHEPELnLk9VL7zcNUoWbYnXjNHtLYdmwAcSk8IKYCozDYpSz8?=
 =?us-ascii?Q?7OOahtxM59GzQfJ5GkAGUVKkTdlK6RE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: daafeca8-2751-42c3-b6af-08da18f49996
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 00:13:25.5943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2CqGZ8XNd7+250FbyFA1yV2nKib7VUKA9g1c1slzUVN7qWZsdAz6Izsdh48VIBgz8MEbBsdokwQGj2k3fctLHCZC9PeHhjkBy8/KbFOM+Bo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5550
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-07_01:2022-04-07,2022-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070064
X-Proofpoint-ORIG-GUID: Annd0k9x_pLJNjjNxOAA6X2GMp5hEyWH
X-Proofpoint-GUID: Annd0k9x_pLJNjjNxOAA6X2GMp5hEyWH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a driver raises a connection error before the connection is bound, we
can leave a cleanup_work queued that can later run and disconnect/stop a
connection that is logged in. The problem is that drivers can call
iscsi_conn_error_event for endpoints that are connected but not yet bound
when something like the network port they are using is brought down.
iscsi_cleanup_conn_work_fn will check for this and exit early, but if the
cleanup_work is stuck behind other works, it might not get run until after
userspace has done ep_disconnect. Because the endpoint is not yet bound
there was no way for ep_disconnect to flush the work.

The bug of leaving stop_conns queued was added in:

Commit 23d6fefbb3f6 ("scsi: iscsi: Fix in-kernel conn failure handling")

and:

Commit 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
kernel space")

was supposed to fix it, but left this case.

This patch moves the conn state check to before we even queue the work
so we can avoid queueing.

Fixes: 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely in
kernel space")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 65 ++++++++++++++++-------------
 1 file changed, 36 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 63a4f0c022fd..2c0dd64159b0 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2201,10 +2201,10 @@ static void iscsi_stop_conn(struct iscsi_cls_conn *conn, int flag)
 
 	switch (flag) {
 	case STOP_CONN_RECOVER:
-		conn->state = ISCSI_CONN_FAILED;
+		WRITE_ONCE(conn->state, ISCSI_CONN_FAILED);
 		break;
 	case STOP_CONN_TERM:
-		conn->state = ISCSI_CONN_DOWN;
+		WRITE_ONCE(conn->state, ISCSI_CONN_DOWN);
 		break;
 	default:
 		iscsi_cls_conn_printk(KERN_ERR, conn, "invalid stop flag %d\n",
@@ -2222,7 +2222,7 @@ static void iscsi_ep_disconnect(struct iscsi_cls_conn *conn, bool is_active)
 	struct iscsi_endpoint *ep;
 
 	ISCSI_DBG_TRANS_CONN(conn, "disconnect ep.\n");
-	conn->state = ISCSI_CONN_FAILED;
+	WRITE_ONCE(conn->state, ISCSI_CONN_FAILED);
 
 	if (!conn->ep || !session->transport->ep_disconnect)
 		return;
@@ -2321,21 +2321,6 @@ static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
 	struct iscsi_cls_session *session = iscsi_conn_to_session(conn);
 
 	mutex_lock(&conn->ep_mutex);
-	/*
-	 * If we are not at least bound there is nothing for us to do. Userspace
-	 * will do a ep_disconnect call if offload is used, but will not be
-	 * doing a stop since there is nothing to clean up, so we have to clear
-	 * the cleanup bit here.
-	 */
-	if (conn->state != ISCSI_CONN_BOUND && conn->state != ISCSI_CONN_UP) {
-		ISCSI_DBG_TRANS_CONN(conn, "Got error while conn is already failed. Ignoring.\n");
-		spin_lock_irq(&conn->lock);
-		clear_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags);
-		spin_unlock_irq(&conn->lock);
-		mutex_unlock(&conn->ep_mutex);
-		return;
-	}
-
 	/*
 	 * Get a ref to the ep, so we don't release its ID until after
 	 * userspace is done referencing it in iscsi_if_disconnect_bound_ep.
@@ -2391,7 +2376,7 @@ iscsi_alloc_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
 	INIT_WORK(&conn->cleanup_work, iscsi_cleanup_conn_work_fn);
 	conn->transport = transport;
 	conn->cid = cid;
-	conn->state = ISCSI_CONN_DOWN;
+	WRITE_ONCE(conn->state, ISCSI_CONN_DOWN);
 
 	/* this is released in the dev's release function */
 	if (!get_device(&session->dev))
@@ -2590,10 +2575,30 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
 	struct iscsi_internal *priv;
 	int len = nlmsg_total_size(sizeof(*ev));
 	unsigned long flags;
+	int state;
 
 	spin_lock_irqsave(&conn->lock, flags);
-	if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP, &conn->flags))
-		queue_work(iscsi_conn_cleanup_workq, &conn->cleanup_work);
+	/*
+	 * Userspace will only do a stop call if we are at least bound. And, we
+	 * only need to do the in kernel cleanup if in the UP state so cmds can
+	 * be released to upper layers. If in other states just wait for
+	 * userspace to avoid races that can leave the cleanup_work queued.
+	 */
+	state = READ_ONCE(conn->state);
+	switch (state) {
+	case ISCSI_CONN_BOUND:
+	case ISCSI_CONN_UP:
+		if (!test_and_set_bit(ISCSI_CLS_CONN_BIT_CLEANUP,
+				      &conn->flags)) {
+			queue_work(iscsi_conn_cleanup_workq,
+				   &conn->cleanup_work);
+		}
+		break;
+	default:
+		ISCSI_DBG_TRANS_CONN(conn, "Got conn error in state %d\n",
+				     state);
+		break;
+	}
 	spin_unlock_irqrestore(&conn->lock, flags);
 
 	priv = iscsi_if_transport_lookup(conn->transport);
@@ -2944,7 +2949,7 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 	char *data = (char*)ev + sizeof(*ev);
 	struct iscsi_cls_conn *conn;
 	struct iscsi_cls_session *session;
-	int err = 0, value = 0;
+	int err = 0, value = 0, state;
 
 	if (ev->u.set_param.len > PAGE_SIZE)
 		return -EINVAL;
@@ -2961,8 +2966,8 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 			session->recovery_tmo = value;
 		break;
 	default:
-		if ((conn->state == ISCSI_CONN_BOUND) ||
-			(conn->state == ISCSI_CONN_UP)) {
+		state = READ_ONCE(conn->state);
+		if (state == ISCSI_CONN_BOUND || state == ISCSI_CONN_UP) {
 			err = transport->set_param(conn, ev->u.set_param.param,
 					data, ev->u.set_param.len);
 		} else {
@@ -3758,7 +3763,7 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 						ev->u.b_conn.transport_eph,
 						ev->u.b_conn.is_leading);
 		if (!ev->r.retcode)
-			conn->state = ISCSI_CONN_BOUND;
+			WRITE_ONCE(conn->state, ISCSI_CONN_BOUND);
 
 		if (ev->r.retcode || !transport->ep_connect)
 			break;
@@ -3777,7 +3782,8 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 	case ISCSI_UEVENT_START_CONN:
 		ev->r.retcode = transport->start_conn(conn);
 		if (!ev->r.retcode)
-			conn->state = ISCSI_CONN_UP;
+			WRITE_ONCE(conn->state, ISCSI_CONN_UP);
+
 		break;
 	case ISCSI_UEVENT_SEND_PDU:
 		pdu_len = nlh->nlmsg_len - sizeof(*nlh) - sizeof(*ev);
@@ -4084,10 +4090,11 @@ static ssize_t show_conn_state(struct device *dev,
 {
 	struct iscsi_cls_conn *conn = iscsi_dev_to_conn(dev->parent);
 	const char *state = "unknown";
+	int conn_state = READ_ONCE(conn->state);
 
-	if (conn->state >= 0 &&
-	    conn->state < ARRAY_SIZE(connection_state_names))
-		state = connection_state_names[conn->state];
+	if (conn_state >= 0 &&
+	    conn_state < ARRAY_SIZE(connection_state_names))
+		state = connection_state_names[conn_state];
 
 	return sysfs_emit(buf, "%s\n", state);
 }
-- 
2.25.1

