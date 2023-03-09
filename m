Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08368C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 22:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbjCIWeN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 17:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbjCIWdt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 17:33:49 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4E4F2203;
        Thu,  9 Mar 2023 14:33:46 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329Lwt4S021591;
        Thu, 9 Mar 2023 22:33:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=WRPF7bvaG5AJfX6yoPP8u5zd5rpHMkxjLLFA+gcFJIc=;
 b=GsY7i4PXmSQjiulSORy3o/9WF0ND+wi+4aBYMOghxW7ShbzLWU7sNGm7bzWF0/agkgU0
 qD4hMW7dgyLpEiNxEp1e8sSW43yndDGxwVfBY93ClonI1QPMudKOzaI8gbYuko52+6/x
 vjJV95tdQ/DGx/PGV1RSaGuV7qp0eXm6uZeUZW7n2Y2Mlcz2r4ltACrvQibJ8M9bpvDq
 5BJrUELzUGEBBR3sJzCOup/WWH3aBwRyPFa5YqlsK6H7anNil7bDgj5TsutBzQ7uvohr
 1iBR/RpD8RJPVzhFd21JgANJ52MxrdB+wSXZlLpLO/96qWsJ1D0MFZfcA0lLpFXeOBWD eg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p41813uxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:26 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329Kf86A007359;
        Thu, 9 Mar 2023 22:33:25 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g4hw9r6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PyVHbv+fzNOqI+Rz6/kk+PrnADnEkbYvBDWNkcLLCrT4t7Ugc3kLtD3RXBeLcZbISUhaB6/reS+fjJeg2W9Bpp24ZpL/kk9zzqLJUTAVVoBRTkG9PrPQHhPdJVhbut/VOht1M2tBwKixxC35/fhORyEvkLLOKsXttxdi0n1yJjgjQj6T5kL5n6aKCVIPc5Qdzg7E1DRt49LcM1AgLMyYvTVQN5MvPrlqIncYU7KKpA5Tl1kpnU35p4kaaB1JB/3U9KkiOXfZ7wB7ZTMQW1mPwsFwXf3QI5wHWkjoFFzmTOqYPRdTmyVXgBFS6IriX3Fp108i+z1tmQ1vjxkdrT3+bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WRPF7bvaG5AJfX6yoPP8u5zd5rpHMkxjLLFA+gcFJIc=;
 b=cpGGh31VKMq/uvS9DkbuzswVyJ2VWiklXObhFY4TNWkjSZBvyUzOU8zaZOhhTgvA2Zvz5DfT4Erm59CrExhIcc4I/1ItrWYUHQD3xOSe1aVAW7Jj5/Qx2S3tW9Q/lOhBi7JRQF/8Lrpn25UP/MVfV3AvhS95mVIS7T5JZZcKi8oEyXhq11nYHZhZLlbrO03ntxdZns1CPHz4ZJz/Ut7pJx0z3EQEC7/4d6SmAsfZiuVjNbHzH/7OAjrB1Oru4mPp6PXu3hoI8I38PNq4eBRftzCa8N3DsyDKcvIArC3xOhINH8YTNENb6nU5FQ62U9/alEto5oqbqtS+txg2GOL0+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRPF7bvaG5AJfX6yoPP8u5zd5rpHMkxjLLFA+gcFJIc=;
 b=ym8bDml+5za2McN2l5I6Zp3DCOXlo0D4khBb9bDVKk9FKu7oAlqbNcZxux1m9G40w9drdI5QENQaHJr05HI1YQ+o2YsZyfdMyqVZQeZeVBVnoOJegKLrL2Qo+mM/k7BatYKsji89voT4ZAcR/y75nKa6N5WBuGgo/8mG3HxIwQQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6479.namprd10.prod.outlook.com (2603:10b6:510:22d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 22:33:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 22:33:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 01/18] scsi: target: Move sess cmd counter to new struct
Date:   Thu,  9 Mar 2023 16:32:55 -0600
Message-Id: <20230309223312.94595-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230309223312.94595-1-michael.christie@oracle.com>
References: <20230309223312.94595-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0237.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: 63c1fdd3-5108-43cd-392d-08db20ee46a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9lBslgSA0rCQHeRvge13/5LmaW1ATlL+vSNjNyBo4nyJDAKMK0cJlpRokzvYu5Ff3JrTkZlw5bqyjTMTDNDbDRg2mB4oAcfi59DCY3vHfkO84Fyhk7G0ML2PZfcvFOnHvNQEBQ1GzLvW23grmnc4DSwbrAojr4+g5KWNiNsb75Wo+KsYXlAB2CoLbE60PhoM8Ng8rDeDkFTYt+nty3AGFoRTCyoIz14g8KC4B9Ew5BKw1BivyFXTE0MGJMHLmRj1MhydaMmpNrS182rUtG0pAOe1qTLqtpR4yZ05c7JHEUfb1MDIXNPTR49e/qgUGrl+Jtczn3i1XFNfowYCNpxKmGCro0bFV0ypvUfw3WlCN6kImiUH/cOhddQ+QJzcTOfWFSge89yoZ3HMmHg5BSc/C9PdDfUWsDuMuBtx3mrgnRg77MilBuAYRXQsUoQTu1CK2o/alT5hU5rcwQX2RqujwlIoDCi5RjIw9fzPtSp0VT2RF1C0N+6iCE8/ETJzGd+8vDHAskWYQuC4L6NwaIn9vALw7hlPKcQyQUMnB3rGyI4G4nW8uGJ7QKopP1EyuaAav38z73L5QA+b46j6O23bA7KRcQU25IshmqT7zMbnQvO1S6ChWukSDWnqFIplTvDoe1+Jgsm5UBl/xcJxZOjsaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(366004)(396003)(376002)(451199018)(2906002)(5660300002)(36756003)(66476007)(26005)(8936002)(4326008)(66556008)(41300700001)(1076003)(8676002)(316002)(86362001)(478600001)(6486002)(66946007)(6666004)(6512007)(107886003)(6506007)(38100700002)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dI7SNSsYXVRN0fT77zoNqu6mhHKMlzRfF7bGlHouh4L88+YJhH9gEkdZkhdb?=
 =?us-ascii?Q?Im/X6xeFfRLaKkfeWd3Aps4lczDiclN7zjuHLbwGLY3qyxFtjomSZ95/XRgE?=
 =?us-ascii?Q?GxpOx87D1sk7OSfSZuVH3faOADeAZzeIam4A2ucWDtzrMLpacQb+3+ExRbVN?=
 =?us-ascii?Q?K4ADRZ8riGfZ/xNePyK+ZoB4/ghp8KtXVa+pUDIuJdceeX4PwTrbYK2P9/yz?=
 =?us-ascii?Q?ugAUoKDTcPOkp96WX3f0gr9vRGqZRs1sUqLbckdAy/V/eTFm/N8YBY9bE1/o?=
 =?us-ascii?Q?G0NzNpstvvKaMUZTVLOC7R+ahcs/f9GphcdmmN6eECndH4fUXVOn156SV5xK?=
 =?us-ascii?Q?0/P+UZaIgDUXtEiAydldIPAZhyM5b8zop33pOHZfoK1e9oCQNmO3BecVaHEb?=
 =?us-ascii?Q?hJQQJ1rzoucuBTyCjlWTVsliTIOmv86lb4e87iYTrp7nDxcwza0PXkKsmgOj?=
 =?us-ascii?Q?AKEGtc5VJqf3PCVozt6OCrC+p4EgKVTJSbDAHWLP4CnystBLsnVy8h4O9FX6?=
 =?us-ascii?Q?Q912GcXaoQkrFLzyIwl6IzGK/dh4tsnD5NQHb98s0LkVDgYjJgC7d4/4P5mV?=
 =?us-ascii?Q?J84vxRtpH2TT56ONoEpzwdP97rL1H1TfrHaWwGOUKuvmUD+bNmRbaxgvTRyS?=
 =?us-ascii?Q?yNH41d8n64xFObaWwV6z1bbQwCDLnK1x1vZVSWils2ajQB36S1ggApMVNQZk?=
 =?us-ascii?Q?qiJ8+v4RwXCUKobJJY7gneR3tFhngnokau9AttGh/NJHGt6L5frsMlAxPel+?=
 =?us-ascii?Q?0B0O60okgbbABYZoa1gNRf93ImJkOz3HQTIgE9Uf9rsLeaSbQ8gmQu8NsLWA?=
 =?us-ascii?Q?HtPzP1IW5SQdRmt3RN0cTWpspvr2CVxbrTthp1PDL6Y3VLlLOM5s9L9YFTNh?=
 =?us-ascii?Q?7SFwFVrMftIw3FHeLe5X2n4R/Eyk1QYXK7XxSfJ48ieFp7AkwQ6+QaSKeh+X?=
 =?us-ascii?Q?zgYGMYbkta5B8lKYdznSKsiGGpEw4hhVtap6IuuqfEbV4mjL/yvoq6ibLieD?=
 =?us-ascii?Q?jAntL/kuoYWiJNwvlirLalyaOrf72za08aMfogBwlJ4u8vn/4gJ5G7gkej2x?=
 =?us-ascii?Q?0VLMnQ0NQgBb/pWQuDEg1npUXnar+X7Qg9cO2WgkUzMBgtgw1HR3OUrY+MoO?=
 =?us-ascii?Q?vu/AE5SljKGz0k/0VcoylvLIZ+Mu3gsS62Q6tyrsH82BhD2v3zXBN7NZUG2m?=
 =?us-ascii?Q?HAnRWrFTdSQkZTrYHkKmjzFQKwH8uQdS2BCY/DhnQgzOFnhtkEJpY5hL8Tvs?=
 =?us-ascii?Q?oi8yPAU7vXDOdkqYFnNUIkhNJfP01VOHmLZaUn0NDbRzBW5SgjoIdwY0sZMK?=
 =?us-ascii?Q?cRJkBBFiRQL94Pu0ImelRCQh95Y6v6mF42py2vU0vbFxGWTnZx7uNgzbwcTt?=
 =?us-ascii?Q?DdY3S3CTr8C82GTc+xoZEC6kBX/bOj+oavypuCSrFxDERVZn9ORDYJT18Suv?=
 =?us-ascii?Q?vXTPD7DPdTNA2fKsnkcRlGkEwdrYnBopYMfQiV8mqV4AIDjpbCQYeerVc3RI?=
 =?us-ascii?Q?YFNguHIWWhUOjAJ2YBOgN96awto9ElYa/RXVHz48d3RtvcRT/vn/+TeMiDDo?=
 =?us-ascii?Q?jInfeMBuvl86kO+kIJh3WPpQRGqYMjDNh6OWcp/2JvQGpsoYAoIbypjzVCME?=
 =?us-ascii?Q?Iw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: kuqW8RzbfVWSl7Cg27mTnGer90GSIW102qpz4IU8sPP0nc3FyRBZ/Af0XeFw/SHtNYnRQAHYPLBuEk2bzcu1t1TSamsrPU/uMpw3UJlYI22+JakfcFSSp0WV5xF23m1xWNYdTJo2euxBwYadRiA0fXYgkGYq3V1UJgavWe2C0k7tS5fxwDK1MzxdDlzvI6TQJTmHEf0iqSqxjHKUzL7EHo7m/Q+fZZDvHjO0wN1rau6NLl5Pg56dCl4aMBiF8G2jJxZQDhr5fucQAX0Pt0PGr2mYNZw9mahphCyup0bYl+LPOeFWSaY74SIymUZXf0vLI/T0aFwb5N1tJy+jANYdLl3/O5YhiTlHHR5svd5tikCCzwHwAF2LLmo8iQfiu6L/8gP2jY79j9k0BLWT+XLJ3ZzhY7W/+r9UH7QBAub7JR7LFtYYi234K33ltyWNjmcjZ+1dQzabhQY32jXsQG+PSO1VzeE+cMAzsPjz6FlaepjAZYBx86JIpyovSHvx1t8susxodUofT2tpBid5LZghH4EhOMGQHGGNhIByZZSOvLe+162jaNyxodO60Gm+nUAXiNb+THJgQDoiYrXcrsKUj7Q4+Zl2VLz4LvGsWJI33kJFDtdP8A2Fx7yPu0CrsQXoKmmXn1IiGPhVTZdH6J0oiT8IvgylVLXKVoHCorOAHKL0ksORbUAisFBzBSaMawdSU8NYRA8ulcI2ZxUUeDqU5kJtC+fYfo/pJmn/13wYv1dUftYrvHoMv99btxeHPxc94D4qcq3oD6XrBIg+Vl2A9ASQvcbB4ThMc1PitKtsYp99lHgfmmnKQBeuSKBbWWlIkWbcwOvQfllQBazaTtKCBuHjGbfMhhcXzosh2sjcJ+VfDm/PwEnmg/rsR6Tv8/Sr
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63c1fdd3-5108-43cd-392d-08db20ee46a4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 22:33:16.3936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1/BKu5OMUK2msPG4bikbG5XW8ejApD9SGlYseJW1L175vpcC1uLiotdJhA00aoDe0PjKGpzG2nk8dDwhsir8O4jVhSzZf2AeJsE4MwYaICE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6479
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_12,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090180
X-Proofpoint-ORIG-GUID: DakQs9P1B_b0ncvY3KTktnuYLCA_tEkR
X-Proofpoint-GUID: DakQs9P1B_b0ncvY3KTktnuYLCA_tEkR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iSCSI needs to wait on outstanding commands like how srp and the FC/fcoe
drivers do. It can't use target_stop_session because for MCS support we
can't stop the entire session during recovery because if other connections
are ok then we want to be able to continue to execute IO on them.

This patch moves the per session cmd counters to a new struct, so iSCSI
can allocate it per connection. The xcopy code can also just not allocate
it in the future since it doesn't need to track commands.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>

---
 drivers/target/target_core_tpg.c         |   2 +-
 drivers/target/target_core_transport.c   | 135 ++++++++++++++++-------
 include/target/iscsi/iscsi_target_core.h |   1 +
 include/target/target_core_base.h        |  13 ++-
 4 files changed, 107 insertions(+), 44 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 736847c933e5..8ebccdbd94f0 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -328,7 +328,7 @@ static void target_shutdown_sessions(struct se_node_acl *acl)
 restart:
 	spin_lock_irqsave(&acl->nacl_sess_lock, flags);
 	list_for_each_entry(sess, &acl->acl_sess_list, sess_acl_list) {
-		if (atomic_read(&sess->stopped))
+		if (sess->cmd_cnt && atomic_read(&sess->cmd_cnt->stopped))
 			continue;
 
 		list_del_init(&sess->sess_acl_list);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5926316252eb..3d6034f00dcd 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -220,11 +220,49 @@ void transport_subsystem_check_init(void)
 	sub_api_initialized = 1;
 }
 
-static void target_release_sess_cmd_refcnt(struct percpu_ref *ref)
+static void target_release_cmd_refcnt(struct percpu_ref *ref)
 {
-	struct se_session *sess = container_of(ref, typeof(*sess), cmd_count);
+	struct target_cmd_counter *cmd_cnt  = container_of(ref,
+							   typeof(*cmd_cnt),
+							   refcnt);
+	wake_up(&cmd_cnt->refcnt_wq);
+}
+
+static struct target_cmd_counter *target_alloc_cmd_counter(void)
+{
+	struct target_cmd_counter *cmd_cnt;
+	int rc;
+
+	cmd_cnt = kzalloc(sizeof(*cmd_cnt), GFP_KERNEL);
+	if (!cmd_cnt)
+		return NULL;
 
-	wake_up(&sess->cmd_count_wq);
+	init_completion(&cmd_cnt->stop_done);
+	init_waitqueue_head(&cmd_cnt->refcnt_wq);
+	atomic_set(&cmd_cnt->stopped, 0);
+
+	rc = percpu_ref_init(&cmd_cnt->refcnt, target_release_cmd_refcnt, 0,
+			     GFP_KERNEL);
+	if (rc)
+		goto free_cmd_cnt;
+
+	return cmd_cnt;
+
+free_cmd_cnt:
+	kfree(cmd_cnt);
+	return NULL;
+}
+
+static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
+{
+	/*
+	 * Drivers like loop do not call target_stop_session during session
+	 * shutdown so we have to drop the ref taken at init time here.
+	 */
+	if (!atomic_read(&cmd_cnt->stopped))
+		percpu_ref_put(&cmd_cnt->refcnt);
+
+	percpu_ref_exit(&cmd_cnt->refcnt);
 }
 
 /**
@@ -238,25 +276,17 @@ int transport_init_session(struct se_session *se_sess)
 	INIT_LIST_HEAD(&se_sess->sess_list);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
 	spin_lock_init(&se_sess->sess_cmd_lock);
-	init_waitqueue_head(&se_sess->cmd_count_wq);
-	init_completion(&se_sess->stop_done);
-	atomic_set(&se_sess->stopped, 0);
-	return percpu_ref_init(&se_sess->cmd_count,
-			       target_release_sess_cmd_refcnt, 0, GFP_KERNEL);
+	se_sess->cmd_cnt = target_alloc_cmd_counter();
+	if (!se_sess->cmd_cnt)
+		return -ENOMEM;
+
+	return  0;
 }
 EXPORT_SYMBOL(transport_init_session);
 
 void transport_uninit_session(struct se_session *se_sess)
 {
-	/*
-	 * Drivers like iscsi and loop do not call target_stop_session
-	 * during session shutdown so we have to drop the ref taken at init
-	 * time here.
-	 */
-	if (!atomic_read(&se_sess->stopped))
-		percpu_ref_put(&se_sess->cmd_count);
-
-	percpu_ref_exit(&se_sess->cmd_count);
+	target_free_cmd_counter(se_sess->cmd_cnt);
 }
 
 /**
@@ -2970,9 +3000,16 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 		se_cmd->se_cmd_flags |= SCF_ACK_KREF;
 	}
 
-	if (!percpu_ref_tryget_live(&se_sess->cmd_count))
-		ret = -ESHUTDOWN;
-
+	/*
+	 * Users like xcopy do not use counters since they never do a stop
+	 * and wait.
+	 */
+	if (se_sess->cmd_cnt) {
+		if (!percpu_ref_tryget_live(&se_sess->cmd_cnt->refcnt))
+			ret = -ESHUTDOWN;
+		else
+			se_cmd->cmd_cnt = se_sess->cmd_cnt;
+	}
 	if (ret && ack_kref)
 		target_put_sess_cmd(se_cmd);
 
@@ -2993,7 +3030,7 @@ static void target_free_cmd_mem(struct se_cmd *cmd)
 static void target_release_cmd_kref(struct kref *kref)
 {
 	struct se_cmd *se_cmd = container_of(kref, struct se_cmd, cmd_kref);
-	struct se_session *se_sess = se_cmd->se_sess;
+	struct target_cmd_counter *cmd_cnt = se_cmd->cmd_cnt;
 	struct completion *free_compl = se_cmd->free_compl;
 	struct completion *abrt_compl = se_cmd->abrt_compl;
 
@@ -3004,7 +3041,8 @@ static void target_release_cmd_kref(struct kref *kref)
 	if (abrt_compl)
 		complete(abrt_compl);
 
-	percpu_ref_put(&se_sess->cmd_count);
+	if (cmd_cnt)
+		percpu_ref_put(&cmd_cnt->refcnt);
 }
 
 /**
@@ -3123,46 +3161,65 @@ void target_show_cmd(const char *pfx, struct se_cmd *cmd)
 }
 EXPORT_SYMBOL(target_show_cmd);
 
-static void target_stop_session_confirm(struct percpu_ref *ref)
+static void target_stop_cmd_counter_confirm(struct percpu_ref *ref)
+{
+	struct target_cmd_counter *cmd_cnt = container_of(ref,
+						struct target_cmd_counter,
+						refcnt);
+	complete_all(&cmd_cnt->stop_done);
+}
+
+/**
+ * target_stop_cmd_counter - Stop new IO from being added to the counter.
+ * @cmd_cnt: counter to stop
+ */
+static void target_stop_cmd_counter(struct target_cmd_counter *cmd_cnt)
 {
-	struct se_session *se_sess = container_of(ref, struct se_session,
-						  cmd_count);
-	complete_all(&se_sess->stop_done);
+	pr_debug("Stopping command counter.\n");
+	if (!atomic_cmpxchg(&cmd_cnt->stopped, 0, 1))
+		percpu_ref_kill_and_confirm(&cmd_cnt->refcnt,
+					    target_stop_cmd_counter_confirm);
 }
 
 /**
  * target_stop_session - Stop new IO from being queued on the session.
- * @se_sess:    session to stop
+ * @se_sess: session to stop
  */
 void target_stop_session(struct se_session *se_sess)
 {
-	pr_debug("Stopping session queue.\n");
-	if (atomic_cmpxchg(&se_sess->stopped, 0, 1) == 0)
-		percpu_ref_kill_and_confirm(&se_sess->cmd_count,
-					    target_stop_session_confirm);
+	target_stop_cmd_counter(se_sess->cmd_cnt);
 }
 EXPORT_SYMBOL(target_stop_session);
 
 /**
- * target_wait_for_sess_cmds - Wait for outstanding commands
- * @se_sess:    session to wait for active I/O
+ * target_wait_for_cmds - Wait for outstanding cmds.
+ * @cmd_cnt: counter to wait for active I/O for.
  */
-void target_wait_for_sess_cmds(struct se_session *se_sess)
+static void target_wait_for_cmds(struct target_cmd_counter *cmd_cnt)
 {
 	int ret;
 
-	WARN_ON_ONCE(!atomic_read(&se_sess->stopped));
+	WARN_ON_ONCE(!atomic_read(&cmd_cnt->stopped));
 
 	do {
 		pr_debug("Waiting for running cmds to complete.\n");
-		ret = wait_event_timeout(se_sess->cmd_count_wq,
-				percpu_ref_is_zero(&se_sess->cmd_count),
-				180 * HZ);
+		ret = wait_event_timeout(cmd_cnt->refcnt_wq,
+					 percpu_ref_is_zero(&cmd_cnt->refcnt),
+					 180 * HZ);
 	} while (ret <= 0);
 
-	wait_for_completion(&se_sess->stop_done);
+	wait_for_completion(&cmd_cnt->stop_done);
 	pr_debug("Waiting for cmds done.\n");
 }
+
+/**
+ * target_wait_for_sess_cmds - Wait for outstanding commands
+ * @se_sess: session to wait for active I/O
+ */
+void target_wait_for_sess_cmds(struct se_session *se_sess)
+{
+	target_wait_for_cmds(se_sess->cmd_cnt);
+}
 EXPORT_SYMBOL(target_wait_for_sess_cmds);
 
 /*
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 94d06ddfd80a..229118156a1f 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -600,6 +600,7 @@ struct iscsit_conn {
 	struct iscsi_tpg_np	*tpg_np;
 	/* Pointer to parent session */
 	struct iscsit_session	*sess;
+	struct target_cmd_counter *cmd_cnt;
 	int			bitmap_id;
 	int			rx_thread_active;
 	struct task_struct	*rx_thread;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 12c9ba16217e..bd299790e99c 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -494,6 +494,7 @@ struct se_cmd {
 	struct se_lun		*se_lun;
 	/* Only used for internal passthrough and legacy TCM fabric modules */
 	struct se_session	*se_sess;
+	struct target_cmd_counter *cmd_cnt;
 	struct se_tmr_req	*se_tmr_req;
 	struct llist_node	se_cmd_list;
 	struct completion	*free_compl;
@@ -619,22 +620,26 @@ static inline struct se_node_acl *fabric_stat_to_nacl(struct config_item *item)
 			acl_fabric_stat_group);
 }
 
-struct se_session {
+struct target_cmd_counter {
+	struct percpu_ref	refcnt;
+	wait_queue_head_t	refcnt_wq;
+	struct completion	stop_done;
 	atomic_t		stopped;
+};
+
+struct se_session {
 	u64			sess_bin_isid;
 	enum target_prot_op	sup_prot_ops;
 	enum target_prot_type	sess_prot_type;
 	struct se_node_acl	*se_node_acl;
 	struct se_portal_group *se_tpg;
 	void			*fabric_sess_ptr;
-	struct percpu_ref	cmd_count;
 	struct list_head	sess_list;
 	struct list_head	sess_acl_list;
 	spinlock_t		sess_cmd_lock;
-	wait_queue_head_t	cmd_count_wq;
-	struct completion	stop_done;
 	void			*sess_cmd_map;
 	struct sbitmap_queue	sess_tag_pool;
+	struct target_cmd_counter *cmd_cnt;
 };
 
 struct se_device;
-- 
2.31.1

