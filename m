Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AAEDC433B4
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FE4561360
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236940AbhDCXZR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:25:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55230 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236949AbhDCXZN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:25:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NOx4S088089;
        Sat, 3 Apr 2021 23:24:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=wYvshNF/mLhV9GmxZg+Sej7WB7NIEbBAqM/2I6rCus8=;
 b=uL6GOigt6GmtHN0MKrM+LnEFIh99m9l5XX7LyAmyH1Gj0Is9DPrHHMV4f0+ghb7OTRTc
 cvHykvDz8gvkGKoa7VOOv5XNLC6Opzi6svFkPU3oKdyNsGpW3vfRlvLwqnZPS4Di3b6J
 inw18SjQqDsc9OJ4hXln5oQxItGIcMQAJdyq8IMbVbbvN+1FnvC8EIY8akHfvs0x5/rU
 6ONEisoip5p4qeNDerwrytMTbph78CncRNZOoFBZFJhz1q5UtS/T+83jI8+CgxQD4OhO
 sIflX2VRt2v3WFTAzIc5JFxXydhLtSyi/8XbXDHUbMu/DFIVjmoG/m9ZtLdmlEXAKE81 Qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37pq66rcvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKtBU117020;
        Sat, 3 Apr 2021 23:24:59 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 37pfpkbt0w-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hK0XKoM7rGsIoVkqBkuAklJ0ALEf2lX0a2OWpBFXOj83jAx92Zx701fzJa1CLGmNvzmxBKV4nSDtol/HDlRk1sEdTuPnjmuh9KmrgNqLvFp17YIgVDBiZUhj+cgkYBIZ40vXw96iUP9qw5QkBdHfKGzbess6FgVx3a8OGPwnP4PqEP1oORPLXi2EdIoNu5TSX+Wq3JAsmnB1BNK2yRYFbr5NT4USnzGuS3bjav6r8WGHwsfV3RqxnopJI8cEqfzC4TDkYdaeHIRvLQjvr+j+Uk2MWlQJbyqWKLlRoYwxWOsznThrXREP2WLz/B+JECyxuxbswSOA2iFRewQa2DzEdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wYvshNF/mLhV9GmxZg+Sej7WB7NIEbBAqM/2I6rCus8=;
 b=NpziM2Pyptt3qogbbbYmdlfb/0/ZYRvECVpSagqcNYQAWHC+fMZVsMKOP3aVikgfJaTwN2hZbSCF7iiuw2kJ+WzQIyQgMEGOCAuyBowR+Nndp2ytJ6bYPikjKyS14+lrxEOK/6AFV0O8n4nzfbdR6LZ+lQu98LhJiOTHwjPjkKI4A4MAUlnNLuAv0OvdlU1yTdwdrkIQfSJFOli8lfxf7UVWm6nYSHS5kyfdQ9h0LQ+rwxy/MaAvIkSG4vqObXu+qJXrvrZSNLqnoJpwMjzwwoMzYs0r+35t1S+5JQ37ciE11LDU4Isz1QPBGe74PgVWmgj83rJmv1FDpqVKVabetw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wYvshNF/mLhV9GmxZg+Sej7WB7NIEbBAqM/2I6rCus8=;
 b=y6Rm5loSzk7i5+sWWqbHQzHqlIDzMSAZclRSxinsL9gfTWWT70hv69IJi7b0je+MR6mgtWlK66FeZOLdFsuv8qvhtXZKK2Wi8/CteG1C7B2EOksX4Vueztp2K5yB8FMryi5SCTP3DnCRaGaLPwkxv0vxGiWNoaMN6f7aPX4jPQ0=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Sat, 3 Apr
 2021 23:24:55 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:55 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 33/40] scsi: libiscsi: add max/exp cmdsn lock
Date:   Sat,  3 Apr 2021 18:23:26 -0500
Message-Id: <20210403232333.212927-34-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210403232333.212927-1-michael.christie@oracle.com>
References: <20210403232333.212927-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e659933e-159c-411e-668b-08d8f6f7a02e
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB34310F2BC2ECDC06AB5D84A7F1799@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qJQCPiIx1/I4gIHX98XfKvycuJ5xeIP4NZB9ElQK1owPxn9qyTgBJNaotbTb0+qJq13koU95KzVYG+E93b+nyFeUwMtquM+pO41duM0oZ7GIf+1KN6sqpTTAoNQDbRBebdOSsNEZ19cCfUaIKZpqkrNxjsA5HUCQdi3zYtmROhlU/0wvo+FtzaBJDraLqrlrDi+glstN5yFhZQFErJD7lb0hVwMXITU5hQPnVnFMEiYX1XNVoXQJhuSYvLqAjQDXsL8rPI2QBVnuoC9ZGJED69MqVvQtDWtMA/43KarBLen4DmMMRUMLvfKWSgBGKs8RMzfKWnqPO6DmpCSQaYK0gZfTgDJOSs1J2pJwuwTQD775WTD/vo1tU+cuIQa8kGf7Ssun8orXmAoM3MGYuyhu7kKWELiIGH0rOIpwnGf6XAE34WJwY8IIMpQfLpNykyaQMBhjC6RuYPTp09V11n4SlzfVwyI1vOJ2Hh/fhr0GUSpjYDaEF4EWi6IpCN6U3u2yO/zqkcvXpZ54tObWoGzMQi1uTe1wg5vciOz9y2v3aoXG6QnWIUUfZNk8BP6U4jhD8mSA7DT5fM3qUPF5drFIVgECFJjr2+8TxrfT1gXsJxOoXRk18dCczAjVdtUnJSRL+kRmfej/rmOLsxFYfq14SUNaEQ0xQViW8pVcodd3AzzZqd1TTvegB4KcK/MfosTqDq6vXJZKogpPwZLSTMyeyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39860400002)(8676002)(186003)(8936002)(6512007)(2906002)(956004)(107886003)(66946007)(1076003)(5660300002)(26005)(16526019)(83380400001)(52116002)(36756003)(6486002)(7416002)(86362001)(316002)(478600001)(38100700001)(69590400012)(66476007)(6506007)(66556008)(2616005)(921005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3Fr5bL+YYKOaBvv67LFvvOSYoJViwt1oyA/LY2DwZPP1krWiqoVf1Wf1tG1V?=
 =?us-ascii?Q?LzoYgmFmASkQeVYEyzQUe6Bb8PVsg2yDDqvemcO1yNxm0qimST0PVr5qWpdW?=
 =?us-ascii?Q?rVVqK4iF/13ieorh+9TYPtkKu0/dY4kN/3INW5b0nGqttXvRYn0dmci0ONNU?=
 =?us-ascii?Q?Z1uLleo1Uh5mG5VrMFAFisZvO7Apr1Jhe5zp4oWFhxgH83X5KIZKLWUdfT6U?=
 =?us-ascii?Q?nwCc6GZuCQFMTGEJZPpn1zPO7jQBGI/bPdtrbx8ZxpONKXpPssnNrROwvln9?=
 =?us-ascii?Q?799AjbB5YNrPLrfpXwPztA1DkrLH9Sts3At3rIMeVcRVt1tPhe3PWnzbZ0fX?=
 =?us-ascii?Q?aEfuDdtPXcWCf3q1MqfyyEsEPGwu1T+SzOfbAeG3EUba5+OKzkXod0OAv0V7?=
 =?us-ascii?Q?EiYJ7e6ehgj+5sNb2ovMLDdygwMR2O6nY2/8eqscPMS3eCkWB6yHbpFqC26/?=
 =?us-ascii?Q?XaJ6JzO1vhoGGMxtRGtyxXU4yIHzQFbBGxxZwtnWnnosJ5Bd+bxaOnCkA44o?=
 =?us-ascii?Q?Krm9CA+KOPBHt93ssL3SeHod4HPFnGscrb+3F26ax8yYA9a2tU4eve2tYy4Y?=
 =?us-ascii?Q?dkQWB1y6TdaA0KVfYf1yiHvKnEC7UovNVitPFRN/VexkyLiKqYJk1xDd1ftz?=
 =?us-ascii?Q?9/8kyookArOTentrV+Yo8a2WcLniYtDxEThQB0IVtisEsetv8wB2Z46mCnwf?=
 =?us-ascii?Q?HP+tVxjdqPpL7rDncM1RbfVrc/nHF535MUgDwFvdteq6q5n47P/+j1WVGUpX?=
 =?us-ascii?Q?ycd/I76X407zgAizTv++QOcsCARuPfO2yhNnYw4vD6p42B5RqBZiZxlzKLuA?=
 =?us-ascii?Q?EDShFx1gtDgd+qbgYy7zESayv5Z/xs2K1i6IjCuk1uvssT2/VJ+7euaLdjrT?=
 =?us-ascii?Q?GJAaec1a88iiWtzFrRK2UddAHjhyGBoIxzXhV6xPev3sdENtGWPTlQrEyOTA?=
 =?us-ascii?Q?TKpWUekE1ICZDpGRX32MobVOEPpTEdaqgiFzmcnGrcK2agU5B4eqQ5E0nBAq?=
 =?us-ascii?Q?vsR8YMM+FIyfxA4fofUNMEzAkBCqa4s7W/lZPJDyqn/PbiZ9ol0+/X0H69Et?=
 =?us-ascii?Q?AS/cFT27MYMCs85ZtRG5nvz6XhO03myJpF+4JdyrTImLWkuj73Hmb0AvQuCY?=
 =?us-ascii?Q?ea6sT5BCpiBrb8BuFo2xBZJ8kLXFM07QXgloPnYmgxG6vo00W561p0Iw3D8O?=
 =?us-ascii?Q?BOeCTGp+bfcqxzz1O6niw4fkaG0mrb2+OjsdMKgJeSjSjUhHeV+jROKfFqq0?=
 =?us-ascii?Q?AgnPWY0OMfLnTXFiYSuT7QmgGzG/GG7LkN3CV6U35PrN/BcohvPNrjgy8Gm3?=
 =?us-ascii?Q?IIDpqf7yI86x3q4osHsj/Vhw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e659933e-159c-411e-668b-08d8f6f7a02e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:27.9354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LdJvHdMvijSl01J2yLtN8UX1u+WSZbYRni+F2Ef9Tq64oKucTNVm7mAb9QiTVYjxA7AeP44KiEExanP0MTMrSKcuKr1lbD4n94e0+nReCMA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: r23y9ayJwIFGIA51G1uTd3I1DroRGq5V
X-Proofpoint-GUID: r23y9ayJwIFGIA51G1uTd3I1DroRGq5V
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 phishscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 impostorscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds a lock for the max/exp_cmdsn handling. The next patch
will then cleanup the back_lock uses.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c     | 7 +++++--
 drivers/scsi/libiscsi_tcp.c | 2 --
 include/scsi/libiscsi.h     | 7 ++++---
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 33f8702faedd..dbff0ed10e1f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -103,6 +103,7 @@ static void __iscsi_update_cmdsn(struct iscsi_session *session,
 	if (iscsi_sna_lt(max_cmdsn, exp_cmdsn - 1))
 		return;
 
+	spin_lock_bh(&session->back_cmdsn_lock);
 	if (exp_cmdsn != session->exp_cmdsn &&
 	    !iscsi_sna_lt(exp_cmdsn, session->exp_cmdsn))
 		session->exp_cmdsn = exp_cmdsn;
@@ -110,6 +111,7 @@ static void __iscsi_update_cmdsn(struct iscsi_session *session,
 	if (max_cmdsn != session->max_cmdsn &&
 	    !iscsi_sna_lt(max_cmdsn, session->max_cmdsn))
 		session->max_cmdsn = max_cmdsn;
+	spin_unlock_bh(&session->back_cmdsn_lock);
 }
 
 void iscsi_update_cmdsn(struct iscsi_session *session, struct iscsi_nopin *hdr)
@@ -3067,6 +3069,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	spin_lock_init(&session->mgmt_lock);
 	spin_lock_init(&session->frwd_lock);
 	spin_lock_init(&session->back_lock);
+	spin_lock_init(&session->back_cmdsn_lock);
 
 	/* initialize mgmt task pool */
 	if (iscsi_pool_init(&session->mgmt_pool, ISCSI_MGMT_CMDS_MAX,
@@ -3470,9 +3473,9 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	 * The target could have reduced it's window size between logins, so
 	 * we have to reset max/exp cmdsn so we can see the new values.
 	 */
-	spin_lock_bh(&session->back_lock);
+	spin_lock_bh(&session->back_cmdsn_lock);
 	session->max_cmdsn = session->exp_cmdsn = session->cmdsn + 1;
-	spin_unlock_bh(&session->back_lock);
+	spin_unlock_bh(&session->back_cmdsn_lock);
 	/*
 	 * Unblock xmitworker(), Login Phase will pass through.
 	 */
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index b1399ff5ca9e..92e84a19b100 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -559,9 +559,7 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 	tcp_conn = conn->dd_data;
 	rhdr = (struct iscsi_r2t_rsp *)tcp_conn->in.hdr;
 	/* fill-in new R2T associated with the task */
-	spin_lock(&session->back_lock);
 	iscsi_update_cmdsn(session, (struct iscsi_nopin *)rhdr);
-	spin_unlock(&session->back_lock);
 
 	if (tcp_conn->in.datalen) {
 		iscsi_conn_printk(KERN_ERR, conn,
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 6853b1dec0e3..3715b3d20890 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -296,10 +296,12 @@ struct iscsi_session {
 	struct mutex		eh_mutex;
 
 	/* iSCSI session-wide sequencing */
-	uint32_t		cmdsn;
+	/* Protects exp and max cmdsn */
+	spinlock_t		back_cmdsn_lock;
 	uint32_t		exp_cmdsn;
 	uint32_t		max_cmdsn;
 
+	uint32_t		cmdsn;
 	/* This tracks the reqs queued into the initiator */
 	uint32_t		queued_cmdsn;
 
@@ -356,8 +358,7 @@ struct iscsi_session {
 						 * cmdsn, suspend_bit,     *
 						 * leadconn, _stage,       *
 						 * tmf_state and queues    */
-	spinlock_t		back_lock;	/* protects cmdsn_exp and  *
-						 * cmdsn_max               */
+	spinlock_t		back_lock;
 	/*
 	 * frwd_lock must be held when transitioning states, but not needed
 	 * if just checking the state in the scsi-ml or iscsi callouts.
-- 
2.25.1

