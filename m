Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85926C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 02:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 711CB6141B
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 02:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347738AbhI3CGZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 22:06:25 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:48572 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347294AbhI3CGU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 22:06:20 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18U0C6DL017464;
        Thu, 30 Sep 2021 02:04:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=UtDC9ouH3Q4WGuZ12fLcrluLt3CZ8j2TAPeAdEuTzVU=;
 b=RMmxnVwNGa9hkBWlxmqdzjmDKLuoy7CC3OR8Vk8dJB3IUh+UgVnB+ysH884eycwDbqm2
 GhssPExcCNrMwbruhDV8GTdVsvpc2YVcdssTbOGH3aerZpWls5RsFa8GikPtdmVZUYqi
 iWzPYZfsJuGEBkRMve/oLb7Qtd1SamJR62ZC2WxYD28UaDCQQDuDtuHOQ59Yl1zHcxRA
 x9HFGGssfeWc5meJGtsGa5VCtAV4n4C4T1KtZL4y0o8zCEWiwIhmSOxsdECsdbMm6tQ8
 qo9WGMSL7TLDMwh37lxSwzOLTul1yIhn9oHW4nwyY7l5dvDMmiRjCAlVTImjDTiPGNgt jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bcg3hswrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 02:04:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18U20Fu2160315;
        Thu, 30 Sep 2021 02:04:35 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by userp3020.oracle.com with ESMTP id 3bc3cf5ava-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 02:04:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nibDc6n+e2mv3zxS3r3T5PzBQFFj3T1FCc+MTXoCYgSOvZRxluSF2zYdDZVQMHWoOjFoXF2GH2tAmeNbD7sID8GsaHbOQWgTwvpDJCs6mnPnZQPJRSijykeZRuFYoPnHrYV4xp6w/+/w5plgU440HGP3GU12L/yw/phx93RwXnUPyC74i+dL9B+LDYsVcvV2LX3Uvw4my6c8SDGcznElCzFvWSo9yUBLSqCeuwJp9g3MUbxkBwxK1JX1nzmhEEpZ8lvCqVVRU4wJxtm9Gz0H17U63bYOoXM7K4C6/5Y7B+poPcRN45qK9kntMiV1GSspbBSJc9a8QGTcM8c5PNDLGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=UtDC9ouH3Q4WGuZ12fLcrluLt3CZ8j2TAPeAdEuTzVU=;
 b=YbMAhuHtGV53bvR0qwjgHiRKZqGc2UjTlG/JpUH1pfxBpRACi6syXseMRsg6gx2n3HB5Ko3VudYVZQ8xbrTLOZvxkqK/4mkDtVvk7RaOHctYBO14UiLUvn2S3RoOURS6q3weUHVLYEy78+qBU3EaA22TI7ZFjdL2d+b0fMgW9P2/g+41rPpb0KFGzQRtrf6F+CT1asdphgcb4RAT6N31q6Lws3lfxZETiobl5TLNj0/Jhr8XaRkguA8m3Zb0GY/Bp5ylAcReYxPkTR6s9z+AmmHzMvsIEgK0pRHXvctSLgtWVZvK9UhS5JvkvFbQrMxY16tYS0Ywg4T6pRsYzbpbGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UtDC9ouH3Q4WGuZ12fLcrluLt3CZ8j2TAPeAdEuTzVU=;
 b=dNIQVBD+NZrIpPFQsUyK+1BKXXXOa2OaTRoN0y6/DNePLAckCdzWLC793P3Y4Mx9gwFcEBgy4TDzIqBzZGNi1VKbDT86W6ZFFWfMRe3UxyYWKyvvIJDHHfEcz2r3b7VP+cYHTDVR8dKE4Gr5yV+3Fdgc9PTHNl2kmeVBUiAM/Hs=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB4909.namprd10.prod.outlook.com (2603:10b6:5:3b0::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.14; Thu, 30 Sep 2021 02:04:34 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4544.023; Thu, 30 Sep 2021
 02:04:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 5/5] target: perform alua group changes in one step
Date:   Wed, 29 Sep 2021 21:04:22 -0500
Message-Id: <20210930020422.92578-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210930020422.92578-1-michael.christie@oracle.com>
References: <20210930020422.92578-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0159.namprd07.prod.outlook.com
 (2603:10b6:3:ee::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM5PR07CA0159.namprd07.prod.outlook.com (2603:10b6:3:ee::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Thu, 30 Sep 2021 02:04:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a7499f1-76ff-457f-809f-08d983b6a5ec
X-MS-TrafficTypeDiagnostic: DS7PR10MB4909:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DS7PR10MB4909BA330411E61B4C0D8C9CF1AA9@DS7PR10MB4909.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:530;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZuKJEv2vQDClzyiDWzEmks1USOxZi7WBps1XdsSLKGy15lp0qnNDK0CUvhPdoLBK64InV1WsOPFdRBAdcU5XRFRYOoFqNnYyVnLzhi17F6B57WW7+WqOH3K35jLpA3lQ5lAM177cZhNFpIFFABjxYIYlyfSsJhjRmo8BvTWRmIAp12D3EUPJQh5gP/KKdjDaNm4RnZLxuKW6p4SObbmCKQ/9/CDrWAT7Cvoywtdeb13PcR+4lz3ohBa28l060GYGAp8um6llTVlws3mKUsIZYcHWbIXcKy6BofeoP+Cu2NIwqSAOHGUWev9bO7HG3Jbcxj3TH0xWvngszm4WzOVHuiyL7M3tLTSCa6Hh8eme0IoeTbNPmAKKNpR2QkhHLfBTDx8BsjcoNEe+qrcVANw+yUn+ciDtWfqkCDXvjSbJSbcYAiCCdGDtRno+EoGu5BGqVOZ9HjBxOpTV61SkasTwKiTQzxD1VIQAKy5P5WKxioBClJaEiZM+W/WUvIMpXBgQvAhRjTuHq7tIdX0f+kYpCcua741/Jm60clpUBnp6C5JvjxSP2heCLyfSFgs1a/wydWth7zq5bdPigaT1b+/2N3X+CxmFSSuPR7d//QPl2TKk6ixKK5nbFxoWR3D3ujfmMfLaF1RpWGarNVQxY6Ff4niaz1GeWhYc5fETT1qyhRro2JV1MjeED5HgGJMIx+jQGKdM7gEZS6hp5g6AbUCM0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(956004)(38100700002)(38350700002)(4326008)(6512007)(6666004)(6486002)(8936002)(83380400001)(316002)(6506007)(66476007)(1076003)(107886003)(508600001)(2906002)(26005)(66946007)(52116002)(5660300002)(8676002)(86362001)(186003)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nBVI2v6DZeKO0LqIC5fmnC3h1H//CNpC6z6H3CIfVjEt8gWfmfi+vVWE8h1O?=
 =?us-ascii?Q?OL04QR5rwME2Mx36XHIaYQlDQBmKj7GTJ2RKFaYPRHM6O2m3bW93FrOJO9Lz?=
 =?us-ascii?Q?Zom6GSMR7scXN9JO+WFirXY/C6C6Bj7mVn5pHWHOaCL4Ks+125ZjIp7iyTYM?=
 =?us-ascii?Q?0M5JGcFagwYS9vbP4RNPiOUESBCpHF26wziWuPARMHbupQEw+/FLcEdWyCkv?=
 =?us-ascii?Q?DmmMWdmQ4M288nGYAtmYAWnKKf03jhV/KgvW0x8o7Te3allB7racBUYzfDLv?=
 =?us-ascii?Q?3I5gJr/1vNAOPl+EzlAZw8smB6mcO1+L5bNcuN6rPJWxFnlKKuzEqnTVDV11?=
 =?us-ascii?Q?h6IDtXMc61m54sQ7DaC2Pu/jxvquZEiImCVflX8RJPxyD4nnAggHT20k4b97?=
 =?us-ascii?Q?LdkeHg6/a98HZnaWK8nH7nuEU5vryED27RlzNheuI8n7PpVKwrbJT+TJPfli?=
 =?us-ascii?Q?FhQQRK3WUchWGTeNzdSPk2F1OmBAdNTjlSlwKeAEdjk4XCkk1hXcnjNkSTST?=
 =?us-ascii?Q?rQF4uz0XDfVN+ROMyZrOYbSoYPpUWYIdmXKSMPaSBT186qMAvNklgsGnPmxn?=
 =?us-ascii?Q?MowUDZDB5D+kJCxpOVrl0kOIcBoybSthRnSFVR7m679fA1aA0fE5xB3WlgIK?=
 =?us-ascii?Q?f8s03lX9xXKuORLFvR+UKjNvTaOEuB9LrvEvRbcUnCTFmFJU/I5fMmlphkX1?=
 =?us-ascii?Q?A4xWbIJVWZfnQeJJC1cyqOzO8G94Hg78OAvNLghOsUGVwmSqcMTbqlTR2VUw?=
 =?us-ascii?Q?2tg4JBdxbbru9xY67sjPxP635kWnZMrI0O/L1mmmZzhW0jhmNy0vuhYOka1N?=
 =?us-ascii?Q?a26CLjJnNc0td4OPXijW3MkW5H3lzQ1xZcCESAPOMcln2DwZbujImBniGSgZ?=
 =?us-ascii?Q?cdgUOGOIY8CMA4kazF1/iStUB2XLxNudNtQZ6cqclrTATdnaACDFyGImln/W?=
 =?us-ascii?Q?wVAHFa/4zsAMKwTAqy1uZRLq+q1s6QPb2M/VHCmvQKwTlkUvUigFatajSSzE?=
 =?us-ascii?Q?EKMD5RWJjDSkJFHSE3uB/+JsM/RQWK+kUJTSw4na/4EYTOCXhC2H9D7rycOJ?=
 =?us-ascii?Q?99RhClkwA5ejPnMy2nsll+nvkzQmaV2K6dZ/jKmKz+VoYTITbyTHtoJOPEwf?=
 =?us-ascii?Q?u644BwLu/bCBCrNITAY9WeTqREvcLhBDs+sFKSMaM4kQbEeW+DqhniKAKHj+?=
 =?us-ascii?Q?vHSGCPQLVKmGjwqv/XHrZ6bYcyp1nrMV2skI2OHNoIBoQTInfhGyNo7Zq9bL?=
 =?us-ascii?Q?yiFD1SbTZxGBQTghUo3y+5pkYTPYBjp19grFYBqQzMh22JiTal+MDJyzt5UU?=
 =?us-ascii?Q?ScK18RpimLaTZHTBZ58+esWN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a7499f1-76ff-457f-809f-08d983b6a5ec
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 02:04:34.2031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nR7Hd/t7T0McqOTUdj67cEgvu2xy/s3eXofVrrv7PJBnvorfCNK7/3aL3HKe51NWGtAOOp9M2LQkhGBsLU8CsNIib4W1QWLQwuFPA1ea+3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4909
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10122 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109300009
X-Proofpoint-GUID: tz-8ZkBl9oqPlvDqWW4LvHW6d9S12Ojg
X-Proofpoint-ORIG-GUID: tz-8ZkBl9oqPlvDqWW4LvHW6d9S12Ojg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When userspace changes the lun's alua group, it will set the lun's group
to NULL then to the new group. Before the new group is set,
target_alua_state_check will return 0 and allow the IO to execute. This
has us skip the NULL stage, and just swap in the new group.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_alua.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 74944b914b4e..b56ef8af66e7 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1835,8 +1835,6 @@ static void __target_detach_tg_pt_gp(struct se_lun *lun,
 	list_del_init(&lun->lun_tg_pt_gp_link);
 	tg_pt_gp->tg_pt_gp_members--;
 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
-
-	rcu_assign_pointer(lun->lun_tg_pt_gp, NULL);
 }
 
 void target_detach_tg_pt_gp(struct se_lun *lun)
@@ -1846,12 +1844,25 @@ void target_detach_tg_pt_gp(struct se_lun *lun)
 	spin_lock(&lun->lun_tg_pt_gp_lock);
 	tg_pt_gp = rcu_dereference_check(lun->lun_tg_pt_gp,
 				lockdep_is_held(&lun->lun_tg_pt_gp_lock));
-	if (tg_pt_gp)
+	if (tg_pt_gp) {
 		__target_detach_tg_pt_gp(lun, tg_pt_gp);
+		rcu_assign_pointer(lun->lun_tg_pt_gp, NULL);
+	}
 	spin_unlock(&lun->lun_tg_pt_gp_lock);
 	synchronize_rcu();
 }
 
+static void target_swap_tg_pt_gp(struct se_lun *lun,
+				 struct t10_alua_tg_pt_gp *old_tg_pt_gp,
+				 struct t10_alua_tg_pt_gp *new_tg_pt_gp)
+{
+	assert_spin_locked(&lun->lun_tg_pt_gp_lock);
+
+	if (old_tg_pt_gp)
+		__target_detach_tg_pt_gp(lun, old_tg_pt_gp);
+	__target_attach_tg_pt_gp(lun, new_tg_pt_gp);
+}
+
 ssize_t core_alua_show_tg_pt_gp_info(struct se_lun *lun, char *page)
 {
 	struct config_item *tg_pt_ci;
@@ -1941,18 +1952,16 @@ ssize_t core_alua_store_tg_pt_gp_info(
 					&tg_pt_gp->tg_pt_gp_group.cg_item),
 				tg_pt_gp->tg_pt_gp_id);
 
-			__target_detach_tg_pt_gp(lun, tg_pt_gp);
-			__target_attach_tg_pt_gp(lun,
+			target_swap_tg_pt_gp(lun, tg_pt_gp,
 					dev->t10_alua.default_tg_pt_gp);
 			spin_unlock(&lun->lun_tg_pt_gp_lock);
 
 			goto sync_rcu;
 		}
-		__target_detach_tg_pt_gp(lun, tg_pt_gp);
 		move = 1;
 	}
 
-	__target_attach_tg_pt_gp(lun, tg_pt_gp_new);
+	target_swap_tg_pt_gp(lun, tg_pt_gp, tg_pt_gp_new);
 	spin_unlock(&lun->lun_tg_pt_gp_lock);
 	pr_debug("Target_Core_ConfigFS: %s %s/tpgt_%hu/%s to ALUA"
 		" Target Port Group: alua/%s, ID: %hu\n", (move) ?
-- 
2.25.1

