Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC24C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 21:39:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80F6A61BC1
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 21:39:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235254AbhKQVmm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 16:42:42 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:41834 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231839AbhKQVmm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Nov 2021 16:42:42 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AHKv6gk012664;
        Wed, 17 Nov 2021 21:39:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=QrDUQ3o2CO6KQs//5qIBjhXlk+IlXHRjkFZOF+upmj4=;
 b=T6hqVqLasTCFTXUmueqxtXARpFtviZMyoc5lW6QkeTRJT27UbGGf5G+/UM+bjsP3cT/a
 H2DNlGiw/szPgz8iofYkibPPvC9JLPyl6nVMzjtlkIOpNtgJFcXTH8l+z5DgbW/Kof0w
 O6nostzFdlH7MkKhVV3PQYBEQ2KeSEfX8ve2q+IUGgW9RKoWy4pCvzRD8IL/7kkjXqYe
 CmZKpqbwj18IbnoPu7K7l9eDos2B5P5R6OIEtJM+00B5dwoWaYq5db+wAcTPchLQX32h
 eIMNOtXPH3MkA+9wnaKvCRCAWexUvhjJhVRFOoijYcPAvynTCvQjvjd+1uv5Jvgg7RkX 4w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd4qyj3xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Nov 2021 21:39:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AHLL7oK047573;
        Wed, 17 Nov 2021 21:39:38 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3020.oracle.com with ESMTP id 3caq4ux90m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Nov 2021 21:39:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZEgSAVEfUZQTMTg3a3u5xTUfnWXp7XilMd4b30Q8702izl0ufx5s7noyUIe/G+H2WF/usngxmySVT2xAorz8otZmA0/ZkWvS++Ya40/iS0o8xSJXDC3SdCHMQO20g2yRMmarvykNkn35Tnw6ecDaWe5ndg5wjA1B+SZ7GiVei1edRnQyjl/Qpb74VfwN4N39Vml+n7wTmhu8K7RGHd6+94hfKWDsQ4MPcxI8BN+FlNkyiNRrHh1VQUzRyvOSjX8UlKR/Qa1Sw6oRwG7MQjFh7kf0xsOVllwguJ6zXAk5miMiJrf5gVZTo5VKIpzjMhL37/EF/03jr2/h5IwN4dnZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QrDUQ3o2CO6KQs//5qIBjhXlk+IlXHRjkFZOF+upmj4=;
 b=F1KZjOO0nWVQM4Fhx2LOVY3Yr/XLgde443/VJo6lJeir0S8o1EoP5Knsiq4yrRqLUqooBwdnZhfUUoxdskfRdjvRILBJ0Ruc+RvWGh9RECYlWwIEDhXeqpG+Alt8tmC+Xx1Idwxid3KxZEZLaj0v6KNqGTFMqJAhDNb6CJa+03f+z57yGJ5+IK/NKGH8G1YDhspIZ3SiT5oMWZ3E1HaACVRPRDLaftQZlaeQH6+ayhcklHvQnJsCIufeSEZD9/w21W/yuXOTQeRYHgsovBxd5HZn0E29PU5Lggyi/crPIbZFJfeSeZM0WbXZPckh+n7IJtGqQbbC4E64g6vujJUF7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QrDUQ3o2CO6KQs//5qIBjhXlk+IlXHRjkFZOF+upmj4=;
 b=ENy5pYY6N5lsSV3wDDBN1O+Ss4Bt9hfCtdB53JxdbSyEYjIakfiyzgp8i2EqSDCm2E6hY604yA3T+qN8O0Uynz9Xwo6urR+FhnagYxV434Jey1K2eHckJEbe7gY31zj4osBZSwuhxIqFG5KeJjSFntvy19sTpsD4A0pCPF+HkPA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3036.namprd10.prod.outlook.com (2603:10b6:5:67::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4690.27; Wed, 17 Nov 2021 21:39:35 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4690.028; Wed, 17 Nov
 2021 21:39:35 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 1/1] target: Use RCU helpers for INQUIRY t10_alua_tg_pt_gp use
Date:   Wed, 17 Nov 2021 15:39:28 -0600
Message-Id: <20211117213928.8634-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0028.namprd14.prod.outlook.com
 (2603:10b6:610:60::38) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0028.namprd14.prod.outlook.com (2603:10b6:610:60::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Wed, 17 Nov 2021 21:39:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2865ae15-1fe9-451c-3694-08d9aa12bfbb
X-MS-TrafficTypeDiagnostic: DM6PR10MB3036:
X-Microsoft-Antispam-PRVS: <DM6PR10MB303681E506195DBF1BC8EF09F19A9@DM6PR10MB3036.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wdHOhZFPN0QFJ2kQBak+LfvV5Xe06BM5lwlujQCgcwLkWKpSGN4LC/faNTzBiWVLOTjrG6jaMcPWyvpM/9z6kYIkWYkUKRwGY9PXabh1mSwjhfR8cPFtEKsWz8a+oRBq5tj6Wj5B+qVMPzSIUFhV4rKuVOqKvneYCfTAdQrhedaBoixWacZGfAG5d9nK3CcDHoiKdZjsfK0HVMTWUHq4zBQhXggY61zWFS2zZ7aKXVjeWLUZQjJMxcncCT7osgmobJxqp05N4yUWm8Ibuvr9PQf4083+1aageoXrJXCVDYRnUpp/xboBsQmhf7g9N+7WPKx+lyME+278p6tMMSF4Twe75HBmhQg8vkd8sdHeDYYal8KCsWLxscAOm5vX9Gvh3hq93F0Nv2L7C4MaeC1qosB+r8eiU0uSAgGXtOo97UV/aOc06cG1cjge3Vr3jUJT8+sxJuE4iKiE/lqLGM3aVAAPMjM4CcLgVpkSqVlOfUE3npiSPnLeXhXe5/RsSOfGI0q7nmT+o2KHpS+rBci2ToS9aBiFJ0Om2jcfnqYqgCyZ9G/MnmouW5XKctLaRKsqjRDIak73yrJB7Q12rhUexs0RWXWffDiVy5BAx8KFqZL4SU+e8nPh/+XNSTdQLCE5E11+Ei2bW40j0LvK5kzlcxnX9G9WhDLdvUbVnkmomE/ytgSwi6FgouJi6t0h+NNUXQq1ZDPxDA8sz28JWMEQXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(6666004)(6506007)(5660300002)(2906002)(38350700002)(6486002)(8676002)(66476007)(38100700002)(54906003)(66556008)(26005)(186003)(66946007)(316002)(1076003)(86362001)(4326008)(508600001)(36756003)(8936002)(956004)(6512007)(52116002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JJsRpdtHYPNxGvRVXJxCeKbq5Rfg0OuuOJJpBTynpNUi5XkYRGM13TqSRaZ2?=
 =?us-ascii?Q?EQ1tFZJNUj/xIAtaVWxo2umG9Pk+mUm2YgLIAJXbLlVIsj3hMi2IR80ZoJMA?=
 =?us-ascii?Q?DalqRFeLgcvMPnyjdIMO/kurBp2IiwPcjB7sQiMicIIti6JIPw6jsxjJpeMU?=
 =?us-ascii?Q?C2q3WUK9W5HrzHy/P2+jhwLkC0YxVV+SRIcXQ04h9oqJhkAFqkmfPgPW2DO7?=
 =?us-ascii?Q?rOwmRnqg6GOVQ1h6udlS7lGWmBSIwaVWEhaT8n160A0WQNclPh/l/NEf0jgd?=
 =?us-ascii?Q?oJRe5aHD8hljmeSJCW1iRwqfog6hYfYVet9L7WzEv/ED6CCm9Oh4ohtRwL2y?=
 =?us-ascii?Q?J7QIjx2yGOkdonPrVQ0U4LADMhrM6+IeKHjvwhHVaNglSfY+H+yrqdB1yCmn?=
 =?us-ascii?Q?T+XsT7gL6Q5SErBbOT394oZG2m487TfLQ0W9T39vwisxhXGrJYFB8ELwOS1F?=
 =?us-ascii?Q?tIxuHstoX/Y/qq3ZEDg5k79B9URxnjlmHvJZHMlBffpSi4F0TknoaWk6LdOB?=
 =?us-ascii?Q?N+lP12e2RqG34etrk5+J9l4FI3arta/uT0E/McKDifHX1b7FqoGQrsxcqO7i?=
 =?us-ascii?Q?t+CpznFHPVVKS46nXYtrZcJiLr1IKRsULXzZYoaVmFwk/wz0nIy3Z/9cjGGG?=
 =?us-ascii?Q?09+pzm73qDEKpV/9KG4QRrD30IcOmJ6drG6Byd/dzPci1ZQECN1i4mbB6Jq7?=
 =?us-ascii?Q?o9pEdfudbQYjB+8QNcz3tWG9SYtFn4YIZnoVjO5fx+eznIeZgdVMPkdW1I+Q?=
 =?us-ascii?Q?HV8Y4V5NhiyxBY2zdcwen2wtGnZxsDoONIsGb7Lu3e/oom+R543U2a94WZeQ?=
 =?us-ascii?Q?BVAVX4moGG5EroLk+3kRnCldge+gD/nEca++PJQl0U0vTVU56XvsnlykQiAp?=
 =?us-ascii?Q?YG/zcQb87qKvqHRR2e+3ZBfyiUrfnYB/gAXNShHQehcqiaNwPLkOUkDw/zG8?=
 =?us-ascii?Q?1vuR2oZPqtcToe4Vqo8ExSj7c9xxezG3GhUF9tEM+///SIydTAC8y2jknpDe?=
 =?us-ascii?Q?KB23OxH+2FgBXvbxVerpm069AcpYLUsm8+ltDsynrrxxdTXwHivrVzrqVzhs?=
 =?us-ascii?Q?YJAGnbw2KcQZROEjH5ws1ncLI7V8fUqx5nM47/Aev0GvkoSSYz8WAe4NF53X?=
 =?us-ascii?Q?0m/iEHIC84rPosT4otiJGG5XoyHBpRy2hhoE8RpX62GOcQ1FyCSZokyiIFgJ?=
 =?us-ascii?Q?oTltL/r3p+dhc/87i6sLaikllpZkwSHqKxZXA0QPZ07TdkfadYTRPLTlVjZ5?=
 =?us-ascii?Q?LKEiiGOgyulDYaNom1y6IIT4icWbkZUrYdBFeswzZVMTpov8RGQR0E6VJu5L?=
 =?us-ascii?Q?uacTBZCLzrhVxwhkRjasy0srxRVjN8GeUKcg6/VQmIF1dbh1ILiD1179r0u7?=
 =?us-ascii?Q?f9EhLNqtWeKnzQM4UuHwZy21n5yo2SJ4iOUeddSOQWoigzh2FMn5M/rUFo2U?=
 =?us-ascii?Q?BgwvFaqAahe6EZx0+to6wKG5Cvor3CPFKqmpIVK7Lprqe2bN8sqbNM6AbfZD?=
 =?us-ascii?Q?1ofX1Q2GR3QYQXwoVUDkAD96eWZUqZ6ia9y9FjphFAIZttNZ4OTqfZsh8jR4?=
 =?us-ascii?Q?KFJbxXmygbqKRrl5kTMUzSJfNCDFLdvwUOJhVsUp9THOsybbx6UOMzueaX6I?=
 =?us-ascii?Q?CcJhwy8E4+SWwaCmQutDUm3qW4Iw+iaXjmM+qYobAIc3tacXz/MBbuXT2bXa?=
 =?us-ascii?Q?AXAmDw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2865ae15-1fe9-451c-3694-08d9aa12bfbb
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 21:39:35.4055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qevfs7P60NsaxdYlMJNzjmmzCmzUD9By6lLXtgbm2Xn8snhQ/y3eD45HAViTAVNGH1k9t6PPfp6y7ydNXzvtkvx8uslpWIpy1qtpn3so78Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3036
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10171 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111170097
X-Proofpoint-ORIG-GUID: XWcCOfgyNr9ukqFgEwtivA8QyyfQ9DcY
X-Proofpoint-GUID: XWcCOfgyNr9ukqFgEwtivA8QyyfQ9DcY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes the sparse warnings about t10_alua_tg_pt_gp accesses in
target_core_spc.c from:

commit 7324f47d4293 ("scsi: target: Replace lun_tg_pt_gp_lock with rcu in
I/O path")

That patch replaced the lun_tg_pt_gp_lock use in the IO path, but didn't
update the INQUIRY code.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_spc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 22703a0dbd07..4c76498d3fb0 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -40,11 +40,11 @@ static void spc_fill_alua_data(struct se_lun *lun, unsigned char *buf)
 	 *
 	 * See spc4r17 section 6.4.2 Table 135
 	 */
-	spin_lock(&lun->lun_tg_pt_gp_lock);
-	tg_pt_gp = lun->lun_tg_pt_gp;
+	rcu_read_lock();
+	tg_pt_gp = rcu_dereference(lun->lun_tg_pt_gp);
 	if (tg_pt_gp)
 		buf[5] |= tg_pt_gp->tg_pt_gp_alua_access_type;
-	spin_unlock(&lun->lun_tg_pt_gp_lock);
+	rcu_read_unlock();
 }
 
 static u16
@@ -325,14 +325,14 @@ spc_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 		 * Get the PROTOCOL IDENTIFIER as defined by spc4r17
 		 * section 7.5.1 Table 362
 		 */
-		spin_lock(&lun->lun_tg_pt_gp_lock);
-		tg_pt_gp = lun->lun_tg_pt_gp;
+		rcu_read_lock();
+		tg_pt_gp = rcu_dereference(lun->lun_tg_pt_gp);
 		if (!tg_pt_gp) {
-			spin_unlock(&lun->lun_tg_pt_gp_lock);
+			rcu_read_unlock();
 			goto check_lu_gp;
 		}
 		tg_pt_gp_id = tg_pt_gp->tg_pt_gp_id;
-		spin_unlock(&lun->lun_tg_pt_gp_lock);
+		rcu_read_unlock();
 
 		buf[off] = tpg->proto_id << 4;
 		buf[off++] |= 0x1; /* CODE SET == Binary */
-- 
2.25.1

