Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3EBC433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:30:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B84F64DEC
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234277AbhBQUaU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:30:20 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43936 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235055AbhBQU33 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:29:29 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKOCQ8190334;
        Wed, 17 Feb 2021 20:28:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=kl/EjnB9ZwBzqtChF9uf2wvKcrv+VSurCwCXDzlG5UY=;
 b=pIuAmLMYMyBfbI47PxncfBKEuintI2FC2WhTC+3X/Uyc6EF4PXukJRW3b/JllR/U64Sy
 Yy+k0d5D6yvFzbBdnyS26yTR/0occBQwdKpY85ARaGQxeMxl6XCPqUmtVSiru/tQjMUH
 ND5dvAVstlcRvFyi3cCPCFgkCmU0BFSHnnnQ+7DjkZ5DzStzAFcNIZaXrXWWg9Q/cerQ
 FV2ygbLQ/HkQSgw1QdR+5amlOEN2yeXVr9SZNGuMY5jIG5A1cbnLzbyNwg/gGBXFoksR
 YqNea7JZW0HIB+r0ZtTYQfV7a2CF+oV8pSoYluQbVs9YWN8iZoOZQgMF7wZ1Xy2BAr6E UQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36pd9ab8h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKQB6E191515;
        Wed, 17 Feb 2021 20:28:39 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 36prp0p69p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GFy6JpGzrzH4dqHvqfYA+zKf+MsEeL5fVKh4NOewmjoepilPq9VGublW23bCRWm4QMrBX+PrTQoUZb/uEATy08ccbUMfsJ2Fd31H/Kw0z0eoxTVjquDZQ+EYqipS3L2d3jPwkqRdzLvniMD/PNX2pEfULqRsT/jUpvbrFH6PGTVfbmR7a3lq6ZepZ4268AaVnQ63VbI8RE+NlYaHihHtejUjDYT5cTk7+QF2T5RANEIklZEHTwgGGb+SlrVazSAX4blI/eflFwlf/AbsI4uTJ6KcJNQAg+S3AOkzXnskQ+1rhodKkIrusi6zehQj4zDigzsZOK11LnqRpbfTIpFUNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kl/EjnB9ZwBzqtChF9uf2wvKcrv+VSurCwCXDzlG5UY=;
 b=RFoMZYFWfiD/ZwI2S8FGISS/YcA+n4Q04xP6PxY3PvGVw4bqDznptRpKULfd/+6lKKC43dUl/x1LuUZ2ioQWSm+I+rhKZzjVekyiAINssRRU2kemQm3hmNBq+jBchZETRROXGAoda6yxYPjIISVCEGV2bSl8RWZB1RVaVfaoxxouaH+sR1v/blUnQJJwN6W4yZiXJwGT3scy/78GjnXqgK49S0tb0DmuNOLMoOJJ3y5YVm00LVamPCpzXxs3SStUMTxBCHhQAYd0xHFOXwcbVqisx8jlx4KvJyPIpD9ADV8x/i2aDwnsycmRh/MCBAZpIGHAI5Y4pDS980gM3HZZPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kl/EjnB9ZwBzqtChF9uf2wvKcrv+VSurCwCXDzlG5UY=;
 b=prrw09ghFbENake3jl/NEzmUchdC97b5AHRbc/gFzH1gpJP32zemmjsTExIkUKdW18sEunkDmWngygwesgrcdZog/hYZJlkhvlvRs6DA9f/D1RqWnxi2qX1uwiwLCCFNtcOSDwrW0euAF6D3OiO86nBuB3qh/t3RpDkP6DD+6kA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB4101.namprd10.prod.outlook.com (2603:10b6:a03:120::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Wed, 17 Feb
 2021 20:28:36 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:28:36 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH 07/25] qla2xxx: Convert to new submission API
Date:   Wed, 17 Feb 2021 14:27:53 -0600
Message-Id: <20210217202811.5575-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210217202811.5575-1-michael.christie@oracle.com>
References: <20210217202811.5575-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR15CA0001.namprd15.prod.outlook.com
 (2603:10b6:610:51::11) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:28:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ea60b14-0901-4513-6024-08d8d3829a4a
X-MS-TrafficTypeDiagnostic: BYAPR10MB4101:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB4101A20C5BD05CC5FCB451E1F1869@BYAPR10MB4101.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9CVAhEQtv9VPeqTt11r//dHvsjgnkb1orCPcrG3hGlDbrpWmKjqF0UvXdQgi8tk7SkCXKq55aytVtgEyOJS8JvMvi7NwxRGEHmykmaw2jGHKY5USwnwhrKG5HVOAROz3gSPueiipIsaFKihVi37WHoCcH/HY+OYdRJo+d6aE5ggyeYK5UbqaHnCknJs1oAIl7fCVkD/4U5ZP3vD9dDNWbDahNIdwpruvgS37dxVWRXi63rSpDGzsx1wJrcRcITZrjlrhvg1K4muIBhc5kZEe0S8CQdlI60CoMXnfn9beWVcMM0bPdPN2QGBYTtv+apchnkr0D1grFgRuB4f3WAGrfHyvyjgLwm5b0CiDjuIXV8H0JcTfgp8Ee+Buvg4uDGPgZaFNcRbccR1faPhzs1k96qBzZsZtDdjbPKoqo3lt+jm3ewzjfz51qJ231KjeMNXV5cJF6WyTGyBpc4TZw7z/I1B59zH5WXLJhd7WeqNOJo5OQNIpZWFiBG4wE+WCu4kqDOoELfy3A+GKTAmg3cQWLYdqbqHRKifRePoNV+KVwlOW2y6YkIHBClj+ly9zuf1pmJGV5Zmny2diOg+bNhKchg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(396003)(136003)(346002)(1076003)(107886003)(6486002)(26005)(316002)(54906003)(478600001)(2906002)(186003)(86362001)(6666004)(2616005)(6506007)(52116002)(956004)(36756003)(66946007)(8936002)(6512007)(8676002)(4326008)(66556008)(66476007)(69590400012)(5660300002)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?a8SL4giyZj2jEPMRKyugqNtzhaa3qXyyM43pXn81G0jk6IOAKyT7hT6fEbKN?=
 =?us-ascii?Q?ZVGgGWEdADvnE07SPzu6cLDsW7neewaAyIW2Npx9ObMcjvXw/d4dTgr8IExW?=
 =?us-ascii?Q?7mwvn+plST9G5N1nSBrCUX9EuLXa/FALyrfi+/RrgI8JpUCTbxIJo76DO9dZ?=
 =?us-ascii?Q?07IWb927yDiYXayeWbq2Q6FMAySbs87HViBlmbYFavQIqTXefKyw/Br6RceK?=
 =?us-ascii?Q?8H+1Od92zwGzrExa2BO9AUEsIens3FqAcWuYhNPaSyAieA9Ttid0v0T9lUQ/?=
 =?us-ascii?Q?jnFtXhHj8HLJjHW0knHCwiuMBbGMrYDpv/+6tIaWx4tQMTazZFFlWQoP8oxv?=
 =?us-ascii?Q?3Q5tq9as0cC6CpfVbZVlBJxK65NiQ921v1gAe9+JWetXVHCdR1Ayp9FdnbBz?=
 =?us-ascii?Q?XxbcfnLmtaKW+l2hCSS5lsnXPTnynoJsLiVRG1iWmZjDrVSOb5GesZsmRWdo?=
 =?us-ascii?Q?hWRmfKIUOoTj1uwaBV11ZgrZvd6X3teIUyJJ+5JuPMGVY6Wgpxt6aBakWfrJ?=
 =?us-ascii?Q?rA+mBKh1hnN/qM1HFCbyJBbE4p8an5C0dIV71jIC3YWo5Yvwci7Eqooe5MFh?=
 =?us-ascii?Q?YlquQ6T0NRpdtIZd2GYiAkQ4sLP9LHBRQoYyOMGuE//+DEi4v35ucBO8ueN4?=
 =?us-ascii?Q?XDa7Iwqfs/+cQ5f2AW3iwnk6kgTEjGA/XTH4KcFBmADcNGAh+rYnwFP9i6Ui?=
 =?us-ascii?Q?tk5e7SF2bniaGIjiO/dKo9/9NTJXZlHcI2nN26YknnhVyhzfdiBsvpo/yMz9?=
 =?us-ascii?Q?vlb/rBa9nOqeNHMO7oM+ftsQqx03fZUnP/Bh53wklBF3DAkozI11ZP4NVHO7?=
 =?us-ascii?Q?/sZxGwevdc0zvvwSDacbOiiWxgiYHBuKmPGi1cQ9HzGVbRVivrkbqy/40WWq?=
 =?us-ascii?Q?4IyzQOK6oOv1wZ2wx67Ra/iVaFUC5Qh3uZf/n4IbHxtcNjgel9cKvBC4STYm?=
 =?us-ascii?Q?hrukzQ81DBuHItB5lyMi02yu6tgoDP/CCYHNOv08D3q+VxEsE1cbHKuaHuzR?=
 =?us-ascii?Q?rn+gznGU1BNSlnqMlgyvC16wVM1l2xKHP8DPCH2NeWF//vL4bwhU1G1tgQfi?=
 =?us-ascii?Q?lbJj1XVToSWKDJJ2o9i2RD6cCPf3/63eaboYW9DMz7hwvopDLeSyX2GvfiZG?=
 =?us-ascii?Q?X8rUWuGwkLLrvhlShp0+qy4WRwSK7zv/OXHHhB+Z1UvejTj7XjHV2fMNeGun?=
 =?us-ascii?Q?Sw/egmoMhmiV3UQS/wwvO2aBDPruXJGqAAeoUimmkXwLeG2MOB+NzF5yxVeo?=
 =?us-ascii?Q?B8icaN6pHewWgYR3kjkGlRuPkujfzclq3L3ZHvea/LHtLEiYjdWQ3LmTK+eR?=
 =?us-ascii?Q?5W0GBtQBQWQoSrXczD4CdRt1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ea60b14-0901-4513-6024-08d8d3829a4a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:28:36.4557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: be2lwaZtaSsz1pv5tf5vrLn6YwtM6kItFQXEKnAQAj8+Wp5itXGwMpiUwijqy+29oxmOrDc0p12SVnLFz/UZHYe4aO1Qr5sx9yz2x/a2Nfg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4101
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd is now only for simple drivers that do their
own sync during shutdown and do not use target_stop_session.

tcm_qla2xxx uses target_stop_session to sync session shutdown with lio
core, so we use target_init_cmd/target_submit_prep/target_submit, because
target_init_cmd will detect the target_stop_session call and return
an error.

Cc: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index b55fc768a2a7..56394d901791 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -451,7 +451,7 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 	struct se_portal_group *se_tpg;
 	struct tcm_qla2xxx_tpg *tpg;
 #endif
-	int target_flags = TARGET_SCF_ACK_KREF;
+	int rc, target_flags = TARGET_SCF_ACK_KREF;
 	unsigned long flags;
 
 	if (bidi)
@@ -486,9 +486,17 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 	list_add_tail(&cmd->sess_cmd_list, &sess->sess_cmd_list);
 	spin_unlock_irqrestore(&sess->sess_cmd_lock, flags);
 
-	return target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
-				 cmd->unpacked_lun, data_length, fcp_task_attr,
-				 data_dir, target_flags);
+	rc = target_init_cmd(se_cmd, se_sess, &cmd->sense_buffer[0],
+			     cmd->unpacked_lun, data_length, fcp_task_attr,
+			     data_dir, target_flags);
+	if (rc)
+		return rc;
+
+	if (target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0, NULL, 0))
+		return 0;
+
+	target_submit(se_cmd);
+	return 0;
 }
 
 static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
-- 
2.25.1

