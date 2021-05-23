Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E60C47082
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E44A961205
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbhEWR7b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 13:59:31 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46518 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231917AbhEWR7a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:30 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHujjR164330;
        Sun, 23 May 2021 17:57:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=wjDr2SsPpLMp8I+FDH3uJrKM2jnV+/pPjEyjdN79nx4=;
 b=0DkPAYQifQja7CvPMtVJRpFmC1UWurETMtR1nzdaxu6SkxSzeOA8vhWeoGMQ4NxCRsD9
 CnuI0w6HCeQwjCUUKQA571jSbQQh6ZqCXWVon1GkCBTQF3wg47gq5w4jXY5+eJzGUf6o
 ijoetKfIvU7WZUms/4cxsYdlp9LsVPBfKid1n8A9NVFRV8YKsV+jqObw+VM4sFL7fPyW
 3Ify42r+SV9pI3Usqv0++yGuyKxcC6GLlSTnFSridPq7AiWTXEaEQXqHewK+2bITxm01
 3bX7xzRiRIl+badGWLp2v+jfotzOuyODE11r1VKfat1PxFI1i9xtDw2VfIysp5wxjCbt 1Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38pqfc9ja6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:57:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHu0G8119789;
        Sun, 23 May 2021 17:57:55 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by userp3020.oracle.com with ESMTP id 38qbqqjg5b-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:57:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mCllmoPxG+ijGGwm6DKW+Os9v9VV7Sy12FCu0nj66VQA0+ud2DwefkI3bNCo0J2nrSpcw5ZBG5FaJYoFc+haAfTmGNwpW5m+sqyA++vTVJ3FFAO7nZkA1w9EvRp5nTBH+DdsEgFfHxqoTTavmM2Xtxc9IQGOiae8M+WSQnBTse6guF7vUNmBAaNsNib216vE+a7yaDyD9y6Ou5o53TbNxgk8AIUxuWPwD44LTIbZWC4KhqQoXm5npk4pjh7Yj1tefzY4aLIWV95+tPIgx6fUKkY5mbrr8o1CBgc0wWHqxWEbPMR3qOlTsmc1rwADmIl4FZ3ikWml7bbfHV5/FunXkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjDr2SsPpLMp8I+FDH3uJrKM2jnV+/pPjEyjdN79nx4=;
 b=YiOaTGKOCk6xckp7RSeRO0wX/qwpW+lK+4zmbyxbZ48Y0S7zYdwkG/LLKyOZJHqtBR12vgotYbGaog4hpUNSJIwXLPy+NQCCDKMGhUzbhL2Bg5VnBxdtcUSbBrnA4aSqskwZGqOqtDwMw6xOVQFA7hUSRdB0o83pDr4KFQbY9XqIpsvkXV+k+JX9gev0ecXagJJjvZWRN71QZnSI+FBK6hWsbEIeGJyE7lpUmNqq1IUQIFpxWvt4bqT4Jm+AdAPwmyIRqssWyftp2r1100v59GYT4E+Oogfp+JwQdULJ9mK6pgA3gFZUiY97NKgQKCQeVHy5quB98/nT2mHFYDBBhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjDr2SsPpLMp8I+FDH3uJrKM2jnV+/pPjEyjdN79nx4=;
 b=gdNCb3JqFAYPCqP9dB46jxAypUaXNUVwXhn6syoUVZfZryc56Fkr2Sw5dD44YHBtWBvnJmlpLkgNXISxFls9zGBIQjew14gRyO90QSm1cmo7k9oEK+kfI66KU4uAiJNTPPo8XFeHbW0Eg1oF5M21MJjFu36Iv66DAjYJwBm5ORQ=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4004.namprd10.prod.outlook.com (2603:10b6:a03:1b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sun, 23 May
 2021 17:57:53 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:57:53 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 04/28] scsi: iscsi: Force immediate failure during shutdown
Date:   Sun, 23 May 2021 12:57:15 -0500
Message-Id: <20210523175739.360324-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523175739.360324-1-michael.christie@oracle.com>
References: <20210523175739.360324-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:5:40::46) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:57:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d8ad320-9dfe-4f1f-137f-08d91e144974
X-MS-TrafficTypeDiagnostic: BY5PR10MB4004:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4004F7BC47F0B82A6F238C3EF1279@BY5PR10MB4004.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EzRzMQoOKwhjj2MQcFGHnQ3pyohQ1KU+8LRR6PbBGuYwvAkiDM8AbD3+1HRuGMPtmWu7gKER9WIswm88hgTnyWp3X8dNa4yTPXCABstWvj//+Pf8ZMefTTaC558u0doIyDSB0EA037ViDqZjl0YOzAOAA25HfjJuuDen8H3r2xTuWTKcsRhI924cEihIWluz4kro/a6CUnsV6W5DQZh7AgaGcI1fmqZU0LqVWmmSb1ob8u5hBCIBougWg8Nh9SGmY66wSAf6DHgeaJeP3AQT2UYgInkH06D/vJtxAEphiAxqLhl/5PF4k1BZTDGL6GlAGLPg4K5Z78vfFD3Y8NTzYc18wVgUpYT6prLcFP//pu2COCRFRuLLYXQhVXELjdnAqCfVCjKhvQDp7jI+ngysEnwJWV1F9FuXFRv7sQx4XnH+3Sje2dt+brwkiC+VD5TAJwjUK8JLtwj6wwqOuA4q2M/ARowqtrBK/y/hg27TnSxcEjAOl4P3EW7eCXBkvviG70cEw2QS8T5okl4quTdQu3N6St4u9rgZLeX8HWr/X9X795Obq+NVVgHqf1/Evf+mpNJBkjXdLyCiShqIK/An9Ahly8eS3YWn4nmv83IM66jHoodwjuG7JMcNbE52BJjFeLmWohwDLDk6fHVHnBIJ5lfBVfLu/zXlv4UlOB9G3OKsb3aTI6TlnEObpWJlCtmHEei/rwvrEAJ3kDzvmO3TZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(39860400002)(346002)(66476007)(66556008)(956004)(2616005)(66946007)(16526019)(478600001)(36756003)(2906002)(83380400001)(86362001)(5660300002)(186003)(6486002)(26005)(4326008)(1076003)(8676002)(6512007)(6666004)(8936002)(38100700002)(38350700002)(6506007)(107886003)(316002)(52116002)(69590400013)(14773001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?fg/JfcsiwOQ6EhKg0RDqaI5H45wkyaxX9zz47Mg3oZY+OyoEzDpE//BuIO06?=
 =?us-ascii?Q?fxRb3X4HWWCjplMR1NkRHZdw/dQmPohw5FyDoUm96xrQ1rTOll+H2crtBnyV?=
 =?us-ascii?Q?vr8wfHYKD/46HWiVqR43XZ7LR99fR4vTGQlOZ9aRvRo46nnEVyfK5tvg8GXg?=
 =?us-ascii?Q?B3YBYjbNdqXzhSjfvDW/nFxnyWe8fGgb/22KTjWK6dhTNu97aYlOK+/kGXrb?=
 =?us-ascii?Q?ilBKeN+F/TvQN6dg3NaCYegW+XRUFqbTaU4a8meMMjMr7oJyGcyk3U922O0T?=
 =?us-ascii?Q?3NU17stFGNDjI0LQbD9dG/usEoPZkzHlNa8DJxaS8rQsO5OFLhhmoMzBZVrb?=
 =?us-ascii?Q?FyZj1EtIWa08of1dGHPKiVfZScvKhALb63nbIriaEacYQr3eaKZ1h7oNqDMR?=
 =?us-ascii?Q?ptxCXVi//FHFKB+ML/J+zb2OpQx9T60Cb60f31EvtANy7CYyiLqak0Wk10dP?=
 =?us-ascii?Q?0Ljow+9dMTTE7I9gsy+sCwOVEnCj94gPYkuxaxaSYXdnc1EdCm9dQGXjDDJN?=
 =?us-ascii?Q?AK3RpAxYCBXkAOgg+RDI/GXtuqw4X6EKQqIpdO1I/t6foMl/xVWT1uwz6k5J?=
 =?us-ascii?Q?cX7HFfVWp1iCX+6gA1g8vd7Anxl3Qydp3LaTiPJkLckoFpdTNcvAMctIeDRf?=
 =?us-ascii?Q?1a59BWjiwNwQk9wjl396/7vb/jPRGqTa0oya4Bob9JeY0ADM77Gj63PeRksy?=
 =?us-ascii?Q?MNnQF6i3GV4gRxHa8r61OF5xufCYx8H4wmAHqxMsXTPc6GtgU8Wl0Ixep7hI?=
 =?us-ascii?Q?y5HLLLxzyYVKC7ZrqiM44SKWfkX/SHu63Q5nlitcUn/j8Qsrv0Yfzr1wMpid?=
 =?us-ascii?Q?ScyeceakIlzU8lPpECrVdENX2iW7AD3VjxLJrj+nG0wejatXzHusbypW20mH?=
 =?us-ascii?Q?AW+AnoyA0lFTt2f8EC/1BoMPRH04A9ilImENDImMpSyoXUq9OcEaOMh5JRHC?=
 =?us-ascii?Q?fvqHxPFr29fOmk/CRi5pDRaTcEjBDOoz3IppkpY1vz+9SiwfbCcS5Is77N/6?=
 =?us-ascii?Q?Pd/oFgBKp9l7QFRYbFkxO7zS4Gp9DMr1D+TL8koJacT8xMz4zRLPisO3Dsqm?=
 =?us-ascii?Q?15u0YGaQOFBqPaFgJRdULN4B5LOzxnJL3/YQGdGMicbrXMZ/rXVDbZ77bG+A?=
 =?us-ascii?Q?u2ktQloEBZ9Qz1VkrbRivypg3o1M2VKt1aVZ0gVTeIP4xnCirKGZIUDRs0nK?=
 =?us-ascii?Q?AYi/boWf/M46umkXk7oz0EPqPruuoUktEepa+PJ1rFN9uX3x0Ut1qQEhmhjp?=
 =?us-ascii?Q?PVSaFKqdce/bSmwZbMacpsN/cqlqvFuudD4t0nnxOH2cmbF4Nq88bV+bII+0?=
 =?us-ascii?Q?e52syA3GhBsX49Zw8bJHOURK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d8ad320-9dfe-4f1f-137f-08d91e144974
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:57:53.1698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JeN6sCaFRhIODErmyB8sE4hQeO6qZoLkyTlEi738hu1zXkJ9AVu+WfsAcbMl8AwcGnet+6LwNUlemGgyYqbajU6eKL4gBd/Yn7QdMIi8Hao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
X-Proofpoint-ORIG-GUID: HnBcGr0gA3p4W7Xbw1jtIucx0StvQcnB
X-Proofpoint-GUID: HnBcGr0gA3p4W7Xbw1jtIucx0StvQcnB
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the system is not up, we can just fail immediately since iscsid is not
going to ever answer our netlink events. We are already setting the
recovery_tmo to 0, but by passing stop_conn STOP_CONN_TERM we never will
block the session and start the recovery timer, because for that flag
userspace will do the unbind and destroy events which would remove the
devices and wake up and kill the eh.

Since the conn is dead and the system is going dowm this just has us use
STOP_CONN_RECOVER with recovery_tmo=0 so we fail immediately. However, if
the user has set the recovery_tmo=-1 we let the system hang like they
requested since they might have used that setting for specific reasons
(one known is reason is for buggy cluster software).

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 82491343e94a..d134156d67f0 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2513,11 +2513,17 @@ static void stop_conn_work_fn(struct work_struct *work)
 		session = iscsi_session_lookup(sid);
 		if (session) {
 			if (system_state != SYSTEM_RUNNING) {
-				session->recovery_tmo = 0;
-				iscsi_if_stop_conn(conn, STOP_CONN_TERM);
-			} else {
-				iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
+				/*
+				 * If the user has set up for the session to
+				 * never timeout then hang like they wanted.
+				 * For all other cases fail right away since
+				 * userspace is not going to relogin.
+				 */
+				if (session->recovery_tmo > 0)
+					session->recovery_tmo = 0;
 			}
+
+			iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
 		}
 
 		list_del_init(&conn->conn_list_err);
-- 
2.25.1

