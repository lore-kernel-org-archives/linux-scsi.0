Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 907C6C43217
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 02:04:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 778A26141B
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 02:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347329AbhI3CGU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 22:06:20 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:46286 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344407AbhI3CGS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 22:06:18 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18U0ETBJ017460;
        Thu, 30 Sep 2021 02:04:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=yDS1OxcVp8ly10V8vePxRfPpns6A/RLsJBT3Y0aBIiU=;
 b=HXY4GOhDzol7RUFfQMQocpxrlJFZHznt6fyicwzZXWk7Z/BV2hDcy3cogkBY7X/9mPUz
 NmvSqyrIHRmzaXQpaQrsAPvXR/QsQhHTE486S7f9606SYI41z1jol6rgX+RRf/dJrgpd
 R7ikqhwobWaABGZVRJyOlAyjDDTbOimIMxpucJtvjFAMekqMbE+0Kne1krL4swsoC+rP
 q73dSW5hCw/qxuYgPFOwfBJrOgZgsriJqtFoFnbLRkzmgivtfqJ8rOrOhNdGfTDlB7ZV
 WysbZ/J2/u2fTBqYMa2veV8SrkU0eFSBpMpcd9U9ydC+P0ADMas5Qj1UKWx2sqYwdcuW Bg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bcg3hswrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 02:04:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18U20UQh108324;
        Thu, 30 Sep 2021 02:04:33 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2044.outbound.protection.outlook.com [104.47.56.44])
        by userp3030.oracle.com with ESMTP id 3bc3bkv6f2-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 02:04:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFfDpo4tTgqVYnwFLNFxAku5YAGfY7N5oCKcRg8Xs7EsqDjRu5W/lrzOKePYHgYvt5HNnXdPpL/TudAj2KjxMw/ekHAvj7cgWgF4nD9DwdLJ3XAVV2yj7+DTs52tSkPFnC7b2kDrMU+DfiLtlF0zHfNkrcf3WtGG4rEQKdTSKOtUj2L32B4mAIl5xiqdE77uMaFxIvcCPH/h8meFZSGFgALbbWzEuGi1grWWKQmAJ2LKBwzJlkhVeavrMXDBbJwTlQ96DhNve0hHm3y4pi83aHigabLzSMeLl0Uo/4CdCXt8r2xBD72LNU+7pym+BWkR20vVmL5PmVcundwfSEHoMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=yDS1OxcVp8ly10V8vePxRfPpns6A/RLsJBT3Y0aBIiU=;
 b=FN4c4bRfImDsBQGhFfpCQi1evgoU/l1f/RAaBmMQZW0LDuWVeRCRIasjpjgdmG66EQDs4Le6WovqUOvts/nKM/BPF/mrvpRnR7xanPXBUGkUUarPEMasF3MCJiTpXQWq/7GtfiAUPHPLcmziTwl2JKYVGKsz777D+nyTLNK0LmCHuNy7dI6QS17iWmcvcgecQ6ap0QJF94rXfyTH2lu8EZCFX1dGTGuU6hclrysVW9GhQGsNQXUd/T92NV+f5HydUZBr6jmnOXmHjfUWcy9JW4YGHr4PkRhV9/2/18L7K4apdR0WgQYLc9ApsK+L1esPyoEjdhUSnvPd+AsCsLXWtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yDS1OxcVp8ly10V8vePxRfPpns6A/RLsJBT3Y0aBIiU=;
 b=OjCmsYS4gXoTN/RwdNg5ZJ7BRsSFugGh9mP5gsBKBPolMn2kyOfYSWYnnLUa0UlXQWSlmFFhjtsr7Q9cD3xg3dlxLFdK94NQTHo1szAGvPLfvbNUo4YMAsrYxMoNKghJlBMOl1142GmtarXI3HD6x4zFyIGcTwGZz1tMNUzd+is=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB4909.namprd10.prod.outlook.com (2603:10b6:5:3b0::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.14; Thu, 30 Sep 2021 02:04:32 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4544.023; Thu, 30 Sep 2021
 02:04:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 3/5] target: fix alua_tg_pt_gps_count tracking
Date:   Wed, 29 Sep 2021 21:04:20 -0500
Message-Id: <20210930020422.92578-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210930020422.92578-1-michael.christie@oracle.com>
References: <20210930020422.92578-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0159.namprd07.prod.outlook.com
 (2603:10b6:3:ee::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM5PR07CA0159.namprd07.prod.outlook.com (2603:10b6:3:ee::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Thu, 30 Sep 2021 02:04:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21ba12b3-e7f5-4657-cbb4-08d983b6a4db
X-MS-TrafficTypeDiagnostic: DS7PR10MB4909:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DS7PR10MB490923647BCAF373AA1B100BF1AA9@DS7PR10MB4909.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MZbRlycx86dHXgDioiSMqonCtrdhWAqWKF3dRwyxIUCKUrkM90evKU+6agD7Fu/WT0onfe1eQxWPhQotu2+Yge2K399joLVNJSearL5CoxRmn+Tn6R65pkUGCbx1TzQRBsWcOszjqyBr1/slnnQmjTTScSFpBb+rsJG7Ay5DQMvzexE4v9f5HV1Yu6Q10PYlubzfdiPM+Ob3lu5M1jXRaNMbDf94sinjfPxUaGIokXJdyhIQSsk3d+8i/FdAcRUoN/zsmzYNbkFknYKYjVRjSyDuFOYiYDCkN4dWvspphybOru/HQSnVsPIySs0+nTtvnEkX3woj4JD2DucyHJFYx9KXdG5s4qnsaqJVFzn1FcKC5gTRZlua+tb6SLtIHYKBXq5TF5X7djo5j/QOb9eMOCq6ShJ3WrOmomZmINXsgKu0MSq2cLbCLBYLpkY2OrlCjL7wsOs+Mn0FB6SNpZVVYAx0bKVbGV19xDkhOo/92MinXWeEnM/DeAu/mdHyGkM83lB4qVb/4c/djUSP0piScWltM0V1092huPDSuhh/0+3v9WUxgwVXcEeGs8Mb33pchHSNNBWR/0AevzRIjJVlT3pSG9A//NfJ72SmvlDBqNLEsuFNsANXXE6K2k3GlYEWv/ZcL/NyiIkWuak5E1EHMCMGqxVNxm/p6hcemd2a0c0sXsFqWjWIJx4Mb0amS7sAAsFDNoCyHCwQ81qBkLCbNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(956004)(38100700002)(38350700002)(4326008)(6512007)(6666004)(6486002)(8936002)(83380400001)(316002)(6506007)(66476007)(1076003)(107886003)(508600001)(2906002)(26005)(66946007)(52116002)(5660300002)(8676002)(86362001)(186003)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ifHm/ySwstZR/hD67asokfQrWehHEOB1LBb4qsCxGJrxi27SaE5bp3j1JSAK?=
 =?us-ascii?Q?53IwwpYxSSuoBhY9A5QYLqWT4vmd3MxSVs7EIeauJzvO3ltWJvlA2sOFjXp0?=
 =?us-ascii?Q?1+8Co9Zv53ic7sct9WOr2GImmZ8Vx3kDcmQLGxuvEG8mo+OkI3uH87+YHdnT?=
 =?us-ascii?Q?XTdOA4xgO2UKkDvJq6F2oNYOH12ffLVAEajfbcTIRosXwMSr51V8TMJCvYh+?=
 =?us-ascii?Q?vzEUr2ScOdlRtVdQlStpf81cDYiZk8hf9YBApojXdAkS2QJHms8wjff9rhQ8?=
 =?us-ascii?Q?0kaR1YIJcoiKB0uVguFyBzxp2f3RzrkxA9MRV7P+UdJjJ1FHuCYOvRsaNVBY?=
 =?us-ascii?Q?lr8l/Wgl6TkzPcGr0YUU5ILmsIMKCMpirJI6MQZ6067+738Yh4KvWm+dbAW0?=
 =?us-ascii?Q?lL2CmJd0jypFW0RdnVeQLFOKyKbncjBXhbBTEyrOqHlRV+IvAURUQBS2w1dm?=
 =?us-ascii?Q?L9kJs+3zsdRhbYdWRDrwFYotDkpw7WNGbV5u4WHU6DAC7o0UTXc4kgECpem6?=
 =?us-ascii?Q?wjpqAVPujvufU83hWIqh2eRiwdxTCh4vukVsqsFNARGuRMuhuSohmecmEBnV?=
 =?us-ascii?Q?ORRakml1veXYbNz3U6lKlrxNLv+Ep+upApmDrxTWGx0lwztgs4YRSAMEDDGt?=
 =?us-ascii?Q?nJ4ycIRw9M/LE756Q8GdUWfn8b2tYfvkzuL8CNXfmRtDxqlBMeiTOABIX8rp?=
 =?us-ascii?Q?EQD9+L1pr7Bs9tUi4qJE/7uLIVe4ZMU0K2ClfbTsCxplh3nWXpfya8KKj9j5?=
 =?us-ascii?Q?JML+JlZJ7D/B1SRnG/XnwSDUcGC9FSNvd1z8FpFQ/9yQa8fwlLg1vtcoP9hT?=
 =?us-ascii?Q?UfpppUD7YIcPi8SbLssslhQrrQcNhc4EJnJPOd+95rQ8YoxtuIN+CEl0Yk7Z?=
 =?us-ascii?Q?xZC2yXXTimLZVYzAqri0TJY6HnBvbVmkGZLMpbQVP2V0Cqrkf5XpUW7Tw3E2?=
 =?us-ascii?Q?H/SQ9SRv/d203XCwpokjAgAmi11bcmXl9vFOWWdqrwFbXLKZC+MpCyfoy6lx?=
 =?us-ascii?Q?5BU15GIBOO6ABRvjeMrCSCN52ixkhKxYpNzYnLbfklfzHQNmLaFyIwglMEe+?=
 =?us-ascii?Q?dnYepSuBQpyRCQeoxJ7k/cSypwZkCSK4LOFYeZeSzgakeFm58jXdWdsL3h8a?=
 =?us-ascii?Q?Et1au+QjB+nQoAYK10V2J3ZQpNdQdpdIaB8STiGXNHsUZyRDoBI/NxCUW3Cg?=
 =?us-ascii?Q?tSZzWIym38T9+5QVp0vkUZA0uxHU/uueeN70PAzNFCTvWx4xX6POfD/pcOZ4?=
 =?us-ascii?Q?9+crLuFxmULRdGSja6ElCWFjFmMTxwoI0h9y6HlTP4u3cD+Q5+r5Sd+pYR79?=
 =?us-ascii?Q?hDKAb7chaNS7+8Q/Os1UZjMZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21ba12b3-e7f5-4657-cbb4-08d983b6a4db
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 02:04:32.5689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0OI8TL1BR/BAxq9GsNVlPkhcYgVgIH31IrD87TarNH1oQ97lgEmbpDhGzBGMLqN3KankPtXbiq4k2UL6GqaQLZoKNDNyuqANNpBwGfpJhUM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4909
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10122 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109300009
X-Proofpoint-GUID: W7XJDD1_ymQdPJNd-zSz_VAVevfgl00x
X-Proofpoint-ORIG-GUID: W7XJDD1_ymQdPJNd-zSz_VAVevfgl00x
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We can't free the tg_pt_gp in core_alua_set_tg_pt_gp_id because it's still
accessed via configfs. It's release must go through the normal
configfs/refcount process.

I think the max alua_tg_pt_gps_count check should have been done in
core_alua_allocate_tg_pt_gp, but with the current code userspace could
have created 0x0000ffff + 1 groups, but only set the id for 0x0000ffff.
Then it could have deleted a group with an id set, and then set the id for
that extra group and it would work ok.

It's unlikely, but just in case this patch continues to allow that type of
behavior, and just fixes the kfree while in use bug.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_alua.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index cb1de1ecaaa6..bd0f2ce011dd 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1674,7 +1674,6 @@ int core_alua_set_tg_pt_gp_id(
 		pr_err("Maximum ALUA alua_tg_pt_gps_count:"
 			" 0x0000ffff reached\n");
 		spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
-		kmem_cache_free(t10_alua_tg_pt_gp_cache, tg_pt_gp);
 		return -ENOSPC;
 	}
 again:
-- 
2.25.1

