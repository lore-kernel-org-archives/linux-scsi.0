Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D4DC43460
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B26CE6135E
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236988AbhDCXYn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49912 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236945AbhDCXY3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NJwpS160162;
        Sat, 3 Apr 2021 23:24:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=lqAKfPI7QE+skpJI2H4juK07+TiLg2NEMYaRAD63Xl8=;
 b=i+TZLkBwcslwT7XbP1W0cLKOEN+G09fU/Dq5UQXiZBef88dhrLkkJuqL+xBM2on6SGpE
 TBuCDs+cMfHWVZv+gubU/XQ9OuNHgvc5/k59N4572T+REo59hQ8LXuzTLTWKcGs1a9fG
 7wgnNYBm75UypBv5cILYJd5I+hIH9Ry0Zjq6TzUjPT3y+ii1NdsJnjmZcjColMMGNaYG
 BFKguu9KSg/CwJ8FZy26dnS/3QiWCQT2QDn5brRYHdoQHPA9e7QznoqUoEBbepCUbwMo
 vh9W1PV4UHPTLgnhmVi13++PC8Sn4BsuOUoFb9efV+CLr+20P7A4+I0IV8XiCWnwjGot KQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37pgam8rpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKuMV117114;
        Sat, 3 Apr 2021 23:24:15 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2053.outbound.protection.outlook.com [104.47.45.53])
        by userp3020.oracle.com with ESMTP id 37pfpkbsqx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LavbwoSIChBa1tqNLQLf+YvrZAwZShliTdN9CfpwPrdAjqdkalEIW8dgu0fY8zUBxmHAHF94firHR9lifV4S6E+2hQgHwpYtPowQYfo56qU3ihLrTvKw5iedqTURMfyVs7H5UMfnUB2p8wGis+pn/oxd4kViwpOQCAoxQqCIKe7iK2pUqmjOS6TXoXVKJfW/Gm4QnDeKske11tlFS3+hKkVGlt8m1T4zXeQcw6++oV9ZQEr0KYUtRDCcE+1Yfa5rdUdSz0ocMIjG2MTFxmUHoq2BgMXfsK7KHl3Y2VngX8sMhQDBq7U+cuIcNVTK/1JaTbbvpRpkmeIwUmtiT4QXXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lqAKfPI7QE+skpJI2H4juK07+TiLg2NEMYaRAD63Xl8=;
 b=a1c7m+EsMbIp798QddCyYACXVYEYA1KVb0xMkXxuhrOjkhafJKrbkmwvGhd0SBTyihRTmXsNTPmRks8i1Lmb3U3abwQAGzBL9QMhZszDygWg4e/pAm3AYjILCRQ6AGqMHX8UPwXE4MEuT7R8w8z11h5CnzbH+LnTba/GSx9wTxKbQWg1Ub6xJtsc1zWywjOgTLoR/wOkJDHDnLNn/hJZNWkKlX0JTAiRrfX/wEj51FzADMKDihlWLtLe7uUiK0lGTYHAlDtO25l0CbGPQzc41BgdX53V8rv5y3n7ucCOuCxHdWmdeh0e2WiBr5yrx0bFzMsczk/KtzjqgGUjroTB+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lqAKfPI7QE+skpJI2H4juK07+TiLg2NEMYaRAD63Xl8=;
 b=tLymLs85i/EoYQx0EdFvJfolJuv62hNmAK3fnENmCJrJxLmD3gt7DmxxhqLk1uQrRCX5CpJslSLiLQexTy5jjTCJtXIIoKhhFUyacCciaLM4INoxLZZXMPw/3dLHncrjrO83yC5dT1ao0hZI6nvl2n5MdV1snhMMlPTPGbDDiAA=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3526.namprd10.prod.outlook.com (2603:10b6:a03:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Sat, 3 Apr
 2021 23:24:13 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:13 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 22/40] scsi: libiscsi: remove ISCSI_TASK_ABRT_SESS_RECOV
Date:   Sat,  3 Apr 2021 18:23:15 -0500
Message-Id: <20210403232333.212927-23-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f912624a-e5b5-4aef-089d-08d8f6f7975f
X-MS-TrafficTypeDiagnostic: BYAPR10MB3526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3526E6EB6A53524C49DBF258F1799@BYAPR10MB3526.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jx+H3iX9fj/BjSX7QvswcxR9ag7gii7iUuOZ6QSwbHIkDA3Jv0dZ3EpEBDSQeyBb7JtMGaeqIh7aNB0B826DaeVbQTzREreN6kGinrLMwO7kbviyQXbCJ1ttgpQ6yGkod9O+kniuvytYltu1QYSA7ukTcBCu1sO3WZZ1DeyrlkJESNWMxYsZLcgrKwHXAmXARDAMBY29P/MuW5CTYJNuChCnS6xS9OOVpIqqA8kwJL4q/BygFNvC+lKfADHwntiqac0q5wJa+Hs27vto+liyFDq22ByZpt+HPYnPHZzL418wwWSNKHPekUlisBKSVDKyNIelDD/47VJD6bxAGcpAAU2HQ3tV6HwES06mwqASwku2leYCP4CL8qr+HKjGlF4eIUqmG0ILgCmzeBL41YLDV2wDe9u4vgbi73k3XNDx18ORR7KA5Yo+yTNnx872xTIP4itmE6f7ZDe4npf92POoeXG77E4a6WhXR1uyLKBWeAe4awCz2/JTqrtcVrm4DSnKv8Bso+yl0bj53EFXZmBd6je0VYoJrKInts48x1XzhtBUoKSswulRfOu7ph5cSOtPxSz8QmKMTiM9Kx9RhjgU1/2nURWkrydITshgVGD4y/GpLCrhAmZn6M9UniqXbU+bF0lJ56sjtXAvpd6suft3u3jzcqndNwF3xNhHk1fCuYubuLTzDjor/BlC5+/TKu9/s7IU4+m9dfK6eDKg3fhggA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(478600001)(5660300002)(69590400012)(921005)(86362001)(6486002)(107886003)(1076003)(186003)(52116002)(16526019)(2906002)(26005)(83380400001)(6506007)(36756003)(956004)(2616005)(7416002)(4326008)(316002)(8676002)(6512007)(8936002)(66946007)(66556008)(38100700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?z/nqr1/zhMflhArq9k84nQY9RSQkpXpuWnTM5F4YxX5reWn32cqoyLYDP6f8?=
 =?us-ascii?Q?/4qmZFvGVUi2+1LBRBQFBeRimb/X3LFyyr7JSJ/7as8UJd+HBUhI/4YfLGEX?=
 =?us-ascii?Q?/q0V1vZnmDVjW1baaGRmnaIPMdqnzmY4WK1g/aYjMCEVB+NBSHZTtqLBIQ+7?=
 =?us-ascii?Q?w8Ss1vM1kD2ZX8xYib68uyEoI4yOcsNO2XYoMrpvZq662qaZo8gSFi/Hgnw7?=
 =?us-ascii?Q?4irQfLf7jVjCzNwlbS2yRunzQYdKsiV3D4w3ScWiRHSyW/INfYZR8PZcJaTv?=
 =?us-ascii?Q?GbT+9+kIR/Rt+LMlNvFIHNGT431ZIHLY08QVT01Teatx3/gVEXaAUd/0Jq5G?=
 =?us-ascii?Q?mO+t1nD8vbWkjuWm2uL+lDBx2aOvywH6hNXi/c5aaL40VCEZTeue4HLDdP99?=
 =?us-ascii?Q?AyjQo6v+8mUxQjQdfowQ89Q3MXBJMPdP4R2nvHZFvPEC+DHI7Tjw//r48ZDF?=
 =?us-ascii?Q?W8wFmc12aIu34lwK3uwjuybuFLO/+0VAmCughzo7W37CQek+Rbg4uWrJyW6v?=
 =?us-ascii?Q?0hsWC4u2mhoft2HnToUPWD2yG5Ce4NWB/yX+8+nTbau3S8ayU+poy7QlG7HM?=
 =?us-ascii?Q?eQ4XOWmUVyCULQCDlw46PX9jfN279sl0sC4lZtakrygXnJR+ub+lsvVZkMst?=
 =?us-ascii?Q?val45lkj8YodvqdARZ00NgHARjsoo9MhW64SosMylxAoogj1SpogKPWAalWi?=
 =?us-ascii?Q?eIldQUpg9rG0mkEQWB1SiyqeyY7my07cPzSArzImNvzibJdAcFJ9buZgfxT5?=
 =?us-ascii?Q?p7FJvvl+HdaS2O4g+JAeLgkkwGawj7qPdrkYPO+VJlA+CqH8dzxlyGRacmX7?=
 =?us-ascii?Q?OP4klQK+C83tiFWMDesJafxma8PdnA3RUcWIjoOeAEG+gN5JEVZv87u1J6lv?=
 =?us-ascii?Q?bXs4Sdvb7AX62QY+hnM+gav5knzPBa2L4zSOQaPNBuTbK5leigDsH3lS17ti?=
 =?us-ascii?Q?UEBhJ2f8alBadArikntsZO1JgH7RKh1A62dejl0MmRmejjls7MHbvqyXtu3G?=
 =?us-ascii?Q?wTQZQGAlN/3rYEQ1/lczXbwA7vLjfPt8Nr/0w3C8ZG4j/Xiis7CrzVUzlwLI?=
 =?us-ascii?Q?0TP63tewUsQ8LPPgx2KSm9VeqyI2yP564dc0YVfxodU3WDDEhGYIFE4YvtBF?=
 =?us-ascii?Q?5Pl9DtliMxxf3cC+F3E0cTjkhqniwnAqErNGLtXcxGz8qkTKP7njxiCU6cud?=
 =?us-ascii?Q?53qk4Cl41opHe/4tQEnxylKGrk4wZWT0Fca13jPk9t5zNHGoxj7iT2DTAjjO?=
 =?us-ascii?Q?+ti0peauHVSa/yfT+1tHCSiQUc4JpB5nhgI+qwRZv+1Mk6hksEW3Vba9U/rl?=
 =?us-ascii?Q?ve9Wc7A6qf2bzyxlkEkA9idm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f912624a-e5b5-4aef-089d-08d8f6f7975f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:13.1616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h3p/VnxjsBQLtWg2XSip6dSI+pHxhR4eREQ9DCijwKKTDWDODDxH15waHC7fKqHAK5v1D87Uw/zOr3CFDEU2dolf2CvA6Io40NBVAkIXtuo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3526
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: EHZc7tul_2sFtkjgvujQ1mXrayrOlhAh
X-Proofpoint-GUID: EHZc7tul_2sFtkjgvujQ1mXrayrOlhAh
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0 bulkscore=0
 clxscore=1015 phishscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patches simplfy the task state, so we can more easily use it to
detect if a command completed without the back lock becuase that is being
removed. This patch removes ISCSI_TASK_ABRT_SESS_RECOV since no one checks
for it and only cares if the command has completed.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 5 ++---
 include/scsi/libiscsi.h | 1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 46ab51e5a87b..e2f3217afdc9 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -517,7 +517,6 @@ static void iscsi_finish_task(struct iscsi_task *task, int state)
 			  task->itt, task->state, task->sc);
 	if (task->state == ISCSI_TASK_COMPLETED ||
 	    task->state == ISCSI_TASK_ABRT_TMF ||
-	    task->state == ISCSI_TASK_ABRT_SESS_RECOV ||
 	    task->state == ISCSI_TASK_REQUEUE_SCSIQ)
 		return;
 	WARN_ON_ONCE(task->state == ISCSI_TASK_FREE);
@@ -614,7 +613,7 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
 		/* it was never sent so just complete like normal */
 		state = ISCSI_TASK_COMPLETED;
 	} else if (err == DID_TRANSPORT_DISRUPTED)
-		state = ISCSI_TASK_ABRT_SESS_RECOV;
+		state = ISCSI_TASK_COMPLETED;
 	else
 		state = ISCSI_TASK_ABRT_TMF;
 
@@ -3310,7 +3309,7 @@ fail_mgmt_tasks(struct iscsi_session *session, struct iscsi_conn *conn)
 			continue;
 		}
 
-		state = ISCSI_TASK_ABRT_SESS_RECOV;
+		state = ISCSI_TASK_COMPLETED;
 		if (task->state == ISCSI_TASK_PENDING)
 			state = ISCSI_TASK_COMPLETED;
 		iscsi_finish_task(task, state);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 7a78f8c5d670..589acc1d420d 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -97,7 +97,6 @@ enum {
 	ISCSI_TASK_PENDING,
 	ISCSI_TASK_RUNNING,
 	ISCSI_TASK_ABRT_TMF,		/* aborted due to TMF */
-	ISCSI_TASK_ABRT_SESS_RECOV,	/* aborted due to session recovery */
 	ISCSI_TASK_REQUEUE_SCSIQ,	/* qcmd requeueing to scsi-ml */
 };
 
-- 
2.25.1

