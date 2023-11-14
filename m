Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23DACC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 01:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbjKNBkP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjKNBkO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 20:40:14 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17BB115
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 17:40:11 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADNs4B6030165;
        Tue, 14 Nov 2023 01:38:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=GumYsAdzRdmAjg7ud3icqplo0EAItN1svWEtdMeRs7U=;
 b=nFo9hL9Z1qkO5dHs17csRBxXddw40Ekc0NzIy/EzvP5arCbjYwMzFgopABrQtZQT/78R
 oWvPPc6eq6BJUeuUeklEa6OYd/OpFm5mTi4JOoegDrxpvtnhhEava/sybTr1nEJyI05r
 TL7WwFC/RlUrZwTNIM/xh7SS4kNOQ005L3GCLte+zE7OJ5H3tLuDBZ4oufRXkL5CV7Ql
 Nrtyc45qNqw0GEoy6C4e/SxmkM6C3R2BGIwyH+zOw1HKaqU4P4ogn1YdEOnqviktR98E
 /EdKRDl34Tnb12velJP2n4LCj7u/GENcZtx+KhUq4GsuDmwZzEbtqOJfvesxS9cv5/sX uw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2n9v56s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:03 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE0mrTl013734;
        Tue, 14 Nov 2023 01:38:03 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxj193nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKTDsZT4YdTNb1tIGgyVLpFQleZP3e3dR9RKnnR01hAZu/yUOqXkKpsAmKATSEug40vAQUofy/z/vVal9LMjpHmMWOT/wYvmGwpPOpKSH0bzyO7f+asVbMEqrz0zxLkDNetH30+L7YM6l70gNCMFpUpZRtZ2hSHFN48wQaFuDfA6PxnWYb0hnaSKKMLpbf9fWDOJRqzwKqwssgE1PnSrUvr1L3589rDpwNNcxEBJCJLbuv6ULrSGXO1YozmVkwb0rf/m0djgmNTWkrAmoNfUBYUl73WYHoSU7tXv2qocAIp0BPrUw8CgV1Jd19veixT68yrT9DoZCQM/FlR04qgB2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GumYsAdzRdmAjg7ud3icqplo0EAItN1svWEtdMeRs7U=;
 b=iYnEF7rH9VOsskrLtYC8x80VULU8dp3tAZjJLNzQ26+anXQ6LF6xBqcQuiaBATWilrg/APkWsrAbjSpkN966it53R93M+6c0q80/EEbUaAvUhWghN3Sdrd2E5Mzcs6nz2OuKqp8tGkkxHLx2+d5UWwxNlq6IsiytLLD2I7EqPG59F6jgZSwFjZT/vANAavKDmmYpyEjAAtzQGZkkaEMeCu56HS1KiTvKw4YPu39Lc3YAdFhx8Ygy6zYBYkuo2lHm7x32w6dYak1tKMrQ2tuo5A9J5WBhks3lP3MqMDBgmv76SNI0rkD9lUlZAk4IS+3WFRpKmUL/MPl6k1xJxQMqmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GumYsAdzRdmAjg7ud3icqplo0EAItN1svWEtdMeRs7U=;
 b=GZ+kr/tDQt2bqtSjKTwENLAlFfYVTHVV6v9INhOD4Db7cdH3Hxnkk8WHbT7D9gIKX5gEcQjWttYSG9+R6UAHtvtSRhiqZpPWOMRrMjAEWXYjJPjSMdEQP9x8DcKPeCvN5u0nOSIDiujOFcDwBKN6xGt0i+F/A7rAlOPwB9HK4BI=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4199.namprd10.prod.outlook.com (2603:10b6:610:7f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 01:38:01 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 01:38:01 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v12 07/20] scsi: hp_sw: Have scsi-ml retry scsi_execute_cmd errors
Date:   Mon, 13 Nov 2023 19:37:37 -0600
Message-Id: <20231114013750.76609-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114013750.76609-1-michael.christie@oracle.com>
References: <20231114013750.76609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR13CA0023.namprd13.prod.outlook.com
 (2603:10b6:5:bc::36) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4199:EE_
X-MS-Office365-Filtering-Correlation-Id: dc35810b-1956-46c2-d19b-08dbe4b256c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RJT7PRLI91fjmaKRP50jX4tbJ+MHudsHbOU/hXmtc/lCrFV8o9i8ADBh48nvXRl4BHlRYs8sUEr/w6ji0CVjCxpIz8RKXWHP3ujmHsP6rni91s8ZO2af+A6B8L4hpyR8JTh9XvOjSnmdwfEBNsGZZe2Lk0dRCezJFdV6cwVyzVwh82l7xaiFvjDCM9WKdbX+mCDhrrhulfD/1iu+PlxMy7ZMpJg9xNY/EzLfWxgFycDLOwAwyOVyEsH77w+nufeo3FEoXmrqZj0ipI8rR3B1GssPvvoUsNjPLFAS8q3Tm7BXhhqsgp4AY4oJzulWYaD3wDW9pO/bx+EjcRc+b2DqthH5jk+UKKFpgGeultckyRpfm37F9bg4vn658lEb2opNlcE9qIHEeWK/jjJtxpNrCYBT8I8V4tNkTwF3k0IQVh8VnNFj1ix8N3NEW0ThcZOrzJqDfXezl8xIzjM5wCCe4HGu6b7afKrWLlsdBmusKAlV5z7ruO+fRvkQzHgKRYYdmhYVIAeNDUbT15j2v9YVtab6Xf/y54H0Dy01IGZaKbUt/3mmFmhRIcb8elqRVEMUfuNonN3F1nbS45T/BX4zY+QGFvkTqcjSuo2V9CbLL7ufijpg1M6EIrO6nAU4jBNv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230273577357003)(230922051799003)(230173577357003)(451199024)(64100799003)(1800799009)(186009)(83380400001)(107886003)(1076003)(2616005)(26005)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6666004)(8676002)(8936002)(4326008)(6486002)(478600001)(6506007)(66476007)(66946007)(66556008)(316002)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2jRSqyIHHFE29N2OD0oS+Wuohf3p0XEe+sx7hFjYxcB/qgZ9u9VmFtcDOjhL?=
 =?us-ascii?Q?Mtf7+TX10qjsI4Gbycczb7rCaQQhipSe8b2EKn3LzH8UWhl/plma0+ds07g1?=
 =?us-ascii?Q?bEz5k6oYPL1PM+rRMRWNu8OVwdeWh+Iq4uNd08oqmQi4rOscj5tTaTXnNHeC?=
 =?us-ascii?Q?94f8MiLE/yf6OZC2T+ZDcMV7HakIekITe+xTfWDZuxpccHB1qe1O9NZCADW9?=
 =?us-ascii?Q?24epxwObZf9mLWKMRuOtPUzz/v0fzAuExiImEeVkVpc6vqDs2vOu+vG7frr3?=
 =?us-ascii?Q?e9gzUAIX5B/zmXWhjsKAn+KTOECn2hhGCVr0re2VpmyzybhksieRcZrIAIuV?=
 =?us-ascii?Q?EeGZOjV3IqqbJx1HjJzdWMye6i9M+uQDQZNj46bx99DVTUF+eNDsIMbZoxnZ?=
 =?us-ascii?Q?UX1jqriq8xV1ElOUu10jxUxFTmnu4nA4mjP4CXn0cqyuHwdVOLPl4yleag7n?=
 =?us-ascii?Q?6GA28q72YDRdV7rxhmjlKVdwcw31/0tp1JbXzxi1MHOOE4Gpgkg0TJPMB/R+?=
 =?us-ascii?Q?kNhRLD0KiRFPnROBlzT3bDVMoezJEbCh7b+K4cuaJY0kpItH9XD+M0yei+BN?=
 =?us-ascii?Q?z4xv80feGfz2JBkdGdBrsr2Ba/U9TtZdzicaX68d6JvyXR0B5k/ukq+o2Xr9?=
 =?us-ascii?Q?PyUbQ9xJVyYmwGhF05wiDGuKF3xj7ABLjWaR/SEuy6k/zytU1LsTQaZu6pKa?=
 =?us-ascii?Q?a+5tcnKkwoZ584Oox63i+iCcfSfo2kYDTHQPbtPePUqUZ1rYtVREDl/vD5oB?=
 =?us-ascii?Q?YYArsHz9VckLFFWTOMsb8L3CPjRt6NQOE9U4QbCua3HEk6g7hisR4Hg59nZq?=
 =?us-ascii?Q?WAty+mpEd01HCNChLA/RhOLDDksrOGw9lGXfRpGXJloNIysyFVxH8JOo/GxS?=
 =?us-ascii?Q?knpH1D1cpMmIK3CS1GhPVlsiCE7jKGcg2ZdMyusoa5fHaWa+56cWs27aK47K?=
 =?us-ascii?Q?phx4VW4i6SJx17sUd31eomSGQNc73v0TxPpVcabD91Z3L1exe4wjYHejh9ox?=
 =?us-ascii?Q?V4/KPKv9cbZkGIFq0f4HADFwQKxby1JJS8xbD4x5S/Y58kgRxmMGT1+BzrId?=
 =?us-ascii?Q?B2XZvEuwFkRuCZXOpFsXy2IMyozwsxT/ISFl0rNKr67RbfGKTSXdl6lpHTef?=
 =?us-ascii?Q?kmEOgHv3xbw6Z5lqI3h7CAbU0PISslnbhcI8M5v7uTpkrp+lAWwKLQrqPMOR?=
 =?us-ascii?Q?LuNomT9V48j2olbGHm8OgU8Z/sYzpp1JoxU1j4ZqVelU97CunVfcQ8JwFZwq?=
 =?us-ascii?Q?gZL9tNN6aMWHxkKXAkbQ0rzJd1nXpVOO7b/sDU32DnN9jUYaFt+iNmiaeZL6?=
 =?us-ascii?Q?pNNvKMX3enWnuEVaDJ+owWYoUCLp6PuBV/OfXIVjZZG4YiBb/mcRkaWCb6gR?=
 =?us-ascii?Q?MDuHlaPK4vUjlN5KYEWlDAU74v8d2KHM7eb16DmlN7a6SO0kjaHr5lH0j4Lj?=
 =?us-ascii?Q?bYGGrf3SzxIENlx2+E7iJTcZiKra9SkKjbWto7oBXWO6IeT1lU5OOlDIUXJt?=
 =?us-ascii?Q?qP8UwY47kbuiYBzjKNI0vv71lVKBUs9QUIgQZVBGc0SiOTShvTSURSTYcaai?=
 =?us-ascii?Q?nnGTNJ3hJXW+iBk9syss7onZ0ZjhlJb/BBpllxW0wF5FO0f3sgHNj+v2aWeE?=
 =?us-ascii?Q?zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: x5DqWbhc05+3O6uynVutuTWoQWRCrMiyI+Y4r4wNV3eW6HJfjFwwgw+xZhY25oZzVbecK9GbSG5GzaPtHH05sFOsSjBU5rbst+YacXDei4aTf7rNfLKnK+P+D2Yo3ErulYcmJpwZfj4YoYZlNTeWL8u48JU99qD0TccQPvKTjGGbYjbjv7hmSSuqW880yxdXqBej3uI2u1O35t7gCNBogfkKhF5yPwf/z+3vGVV19nVbflXZ81YnMavTr4928yyyuK7vOpIpmuotXsXwfberFl+/v6V5p7Gok6FLsZe7ELAzS64jWqjkrfW6LVhPZaGrgRe6LgEBq+VTHra96njlPMmRaiZ6ag/t+/IKlNxCCRf7fMrr4gtbjhkvcCvSEssebS/8CLQK2NMjG7Njk9cq/KCTkwYO/0Fi2acr+3gP5rEa6OA6ENAld4mddcFVl3VGOGEFZK9ifDu8xRX4CaA9Qnbi78uRcT0r5HKtRaG5wc/6nyazifHXLGQmBsxSCvVGnx9D/QPYDf8BPC4GywUi1nK8c3656+R3rdVMPxLjttP8mZiNzb8W8Cjmc1d3rzyXECh9n0ijT29i+B5nQMG/FOZ1Xr1sm75f3dPi/cSDOC8MaUQ8L5gpJR3XGsVe2rUDal1FGj0OASASKRXSkuZRS1Ik0VorNqN8Ze8fA/qswjfPdWgDHOMgdKfu+OCYDNrfzlHDrysxyL7YG8tRpKCSv1rKk2LgEkYo1DuvejFsyBrybiVMJjLon35XD3ZZj61LTgZd/2QzddzBLKnbh06HRzdJDT5ulzTSLqpqZ9nd5eca8EAO0hbIXkP6tsmuIqPD+0hUy+RtPZWzhw1WWCBRuIR9yqYiTlf9T0biGTUqamQ4KVe0sT6OsiGcqWWl9y7w
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc35810b-1956-46c2-d19b-08dbe4b256c5
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 01:38:01.5168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lMZv0wEnOaTLOUo5PdCUqcQA1e7bXc3ZF9sA03hxCWUISKLhYjIvlEZosLgdnmoV0SHISyMTGjFv342/7vt2IlEAs/PLhXt2pa+pwo7rlc4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_01,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 phishscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311140010
X-Proofpoint-GUID: LaaLKb8Hu5FVWevNYfR5lN3L5caCPPYi
X-Proofpoint-ORIG-GUID: LaaLKb8Hu5FVWevNYfR5lN3L5caCPPYi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has hp_sw have scsi-ml retry scsi_execute_cmd errors instead of
driving them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 49 ++++++++++++++-------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 944ea4e0cc45..b6eaf49dfb00 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -46,9 +46,6 @@ static int tur_done(struct scsi_device *sdev, struct hp_sw_dh_data *h,
 	int ret = SCSI_DH_IO;
 
 	switch (sshdr->sense_key) {
-	case UNIT_ATTENTION:
-		ret = SCSI_DH_IMM_RETRY;
-		break;
 	case NOT_READY:
 		if (sshdr->asc == 0x04 && sshdr->ascq == 2) {
 			/*
@@ -85,11 +82,24 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	int ret, res;
 	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = &failures,
 	};
 
-retry:
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
 	if (res > 0 && scsi_sense_valid(&sshdr)) {
@@ -104,9 +114,6 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 		ret = SCSI_DH_IO;
 	}
 
-	if (ret == SCSI_DH_IMM_RETRY)
-		goto retry;
-
 	return ret;
 }
 
@@ -122,14 +129,31 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev = h->sdev;
 	int res, rc;
-	int retry_cnt = HP_SW_RETRIES;
 	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	struct scsi_failure failure_defs[] = {
+		{
+			/*
+			 * LUN not ready - manual intervention required
+			 *
+			 * Switch-over in progress, retry.
+			 */
+			.sense = NOT_READY,
+			.asc = 0x04,
+			.ascq = 0x03,
+			.allowed = HP_SW_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = &failures,
 	};
 
-retry:
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
 	if (!res) {
@@ -144,13 +168,6 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	switch (sshdr.sense_key) {
 	case NOT_READY:
 		if (sshdr.asc == 0x04 && sshdr.ascq == 3) {
-			/*
-			 * LUN not ready - manual intervention required
-			 *
-			 * Switch-over in progress, retry.
-			 */
-			if (--retry_cnt)
-				goto retry;
 			rc = SCSI_DH_RETRY;
 			break;
 		}
-- 
2.34.1

