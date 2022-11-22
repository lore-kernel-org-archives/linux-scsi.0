Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E0ACC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 03:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbiKVDpC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 22:45:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbiKVDoz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 22:44:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079F62A978
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 19:44:45 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM3ibFW003436;
        Tue, 22 Nov 2022 03:44:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=iZxU36IhY3Q6/2e4NznL5mmB9lNdSO8dV2yigOhy95g=;
 b=T+Jur9WXgIe85NSOaHqaHRJl1em74UzqrLSyz9qE+cs+fpoJaI/NzUUX01h2JXwW8/BK
 UhKnkwl5v+/guraHaGQRmRLdCT0cmuiAWhVGyL5q+nTJyfQ9BBQ2f+Q9YCypAW0aFBvq
 HWwqXjMNHov0sbTJDjOta3+7sR1tLnisCEcxuHOhbusZg+xKiw0EgyM/o/Rz0FPIPhkF
 LxLJIu84RfR47/bTpwofj4yb4OzmSnP3khWoba/XoCbFBkKlAC0vYztSfYZ+n/qhDJDc
 VFKNM+cerAOrlXvnS7UFjP/xcKefrNw7YcMRfSl89dAnBUtI6zMRgo09oPN5tbaF22bw gQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0pf2r1e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:44:37 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM16U6f008302;
        Tue, 22 Nov 2022 03:40:35 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk47378-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MaWKphCy/7hKS66GupYX6ueAdGFfAz7Ft392PzStdU7UU7tC1202E4r1sAXASJ2XMe47H/OjCuyuDA7JYjbJR3sRksVgc0OGcPYuuvcvbskH0SymkmUYQTfPsaMEh91SE3hY/Q1XzXJAPwILDVAbVqGzM08NnI3WJOq0DpTw+Xg/YneTZD5pv1B9jVE69hnyFVPtdxJasOynrWHlx41wJPVMn5/NQSEoDzpWZzWH9tbmv/gLPPBmiIvH2j1GbE2argaDI4RSLD/1tDHX3bzxgxq+MhM2Z1gR7CWdkRG3WhBZzADO0idUeEmx0mDYtoyXSIdvk8pNuBiL2VC69SXeqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iZxU36IhY3Q6/2e4NznL5mmB9lNdSO8dV2yigOhy95g=;
 b=fuDuoF5d9xlLGoLzCMA514V/pwoQFRYwVhzr3zyIE4u2bpGwWrU48hZMzD+pq+dQN7bGEuiqAyDc/idhWvnvrtRxG7doDApp3iyFtyw1pAp40A2o+lon6SKCGnOIbGhRSAbBxaAroUHsAd60uqs2r/8QRdPsL7dRStqmyLMnVaQyYKnAOjW5tOo91jcbMuQj5zZFazPf+DQCFUg5hMBU/3VAWzfzd7NCRZ5E6PVTEOBY0ZEVUo1FW5nE3RgdN9FoHVfisEuLcpzjIScETNlw2SjFW4q+1PsemlggqMbHX4iFAyOQ1qzp7pJPbc5tKmR11nVfQ4Vp3c7lE4BDqzqqFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZxU36IhY3Q6/2e4NznL5mmB9lNdSO8dV2yigOhy95g=;
 b=Y0Xnt5vjcTsm4djFH8XTXbvBKhz6Fm/iRrVlXChcFpBpKIiRXjMaYzFY29bpTapEWY4PFFvZjTkjio30IWv5ZpyuAFzNoNeIKTR/T4gwr+3To70ZFLw7Vw5x5H7t8Z/cuQda4OZPfPV88PSsxy93oSh0rs6Jo9CU6iGuTR+nrQY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4472.namprd10.prod.outlook.com (2603:10b6:510:30::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 03:40:33 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 03:40:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 05/15] scsi: scsi_dh: Convert to scsi_execute_cmd
Date:   Mon, 21 Nov 2022 21:39:24 -0600
Message-Id: <20221122033934.33797-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221122033934.33797-1-michael.christie@oracle.com>
References: <20221122033934.33797-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0028.namprd14.prod.outlook.com
 (2603:10b6:610:60::38) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4472:EE_
X-MS-Office365-Filtering-Correlation-Id: c17d2904-7c46-47fa-9ee7-08dacc3b4f12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DGZwdnYmZGIX0uc5RisjpIhMoIBVWlZA2dd+DPrw97g+2tJBTinC7UfDgdwlK1zQz/rGDNf6uEfe6/3QwtOJ26EGcUPP+UgfHLrYGpybTmNJbe/t55ZNX7y/i9W/VPnaFt61RpSRi26EG75nmg20QFQrqSY1t4Z3w0LFUTvbeTDeUt6QiG41uCpdRCwhKxzYBZCZ+8KyiI0sApNYa5pIFs5PpxbrmhqhyEXUQqdvwXZ6S5Vpb5KiodgqOdXX7do2M63RJZnh73vPMLrysg42u90wzHlrZtfEF5Otli121wq6ivFCWiNcvZ6qDtOuiY3g9kwL+p1Ds0omuxNxXQjIxmBtb1zdPsrTKg47d9sSrffVh2eboORXFKbRdjHs8wZLNacnwdAx/Xv5FLmDixneRrwr9LDqQcorAr9u20W5I6jqizefxMG46l7TtGAbTNT0pPyQ2WEOzCTduVpj2MkOnH4jl8IeaG6u4dtc2Wm0bRi/h3q+G31bwgwKSMbVadDMoVYLntGKhuO1oKbK8ndEJfi8V/hX1/2djkt9c94ewnZdWUi3yEmncyy/9rOGjxicwU9dSS7Capmw+bTYR3Ui5dTgtXERV8b8gN15Ab19W07kqy1S9egEnoEZdvIUpRecL1Fy2oitfPFLwHRdnIvWrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199015)(36756003)(38100700002)(41300700001)(2906002)(83380400001)(86362001)(66476007)(6486002)(66556008)(8676002)(316002)(66946007)(4326008)(6512007)(186003)(26005)(1076003)(8936002)(478600001)(5660300002)(2616005)(6506007)(107886003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OOSLD1WCN235OQlzO1WURjH61whlG7kcF7iKeiRwqODZkwsrgRq8PDVVvuIf?=
 =?us-ascii?Q?h1TA4A7/FI6z72dk3uDrB7HTzx61DXJuma9DevIlEDcH+6ZhTpF9I1k+rrwC?=
 =?us-ascii?Q?rO25jbgNHUXCr2f8pz9FBknsHpii6VofwiuNCF5gRC0B/Q0nQtfjDJmfQmD3?=
 =?us-ascii?Q?KlsccgkIccq9yDx4VFwt0rzQ6bavjYzTvddHYozQMa5jdksucNifavtvTgx4?=
 =?us-ascii?Q?Im1w2+NNg8MeKkGIjkOPxOh/y8Z2xdd6KKjwXtL2a5YOsslwtxUZJvyg76xg?=
 =?us-ascii?Q?2+Tfb7DbmXQlsvmW/Qy9I/JHUSmcuPjr6kiAnvbhnKNo774Z7h82QpnAr7G5?=
 =?us-ascii?Q?QkNL6Tm4CsF8Zls/SiPI4nb/Oa0QL7QEp5pxTAxMF0MU3OfTYww/ejUA7Yvf?=
 =?us-ascii?Q?MPk/Fl6+kYeNWGTd9K28Y9Qc9nVpk3NyeGVQ6Z6L2qnVmdslhpLGfR5Tncjd?=
 =?us-ascii?Q?55MzqyEcWfMSj5AQ5EEkQISzCJZzoH5DiCTcCF9QPQvBMfsgas61+YVd052j?=
 =?us-ascii?Q?BpeVqFRHlLNUUtHsPXovPh/MarnO73/FPPBG9lvrNPP9kzK9b76GPC5HRHkI?=
 =?us-ascii?Q?tqQ1vywaqYotbL17pSzmYa7T8y1qRd+pRfOolX7DNU1QLES7OpplawwtCzTk?=
 =?us-ascii?Q?PpilbLare6Aidu9W3pb188niU+VC+zYjdWzO/8m0aWnw7Wy8zOw8WyPQnJ9B?=
 =?us-ascii?Q?MsELG+0+aT1OhLeLY2zMG0E9yTTiftFB7XacHyOYLPsEfzam3hsZZDDAnFNS?=
 =?us-ascii?Q?mGVJF8z9f0NdS37u9gcKMAMOrNpSOf7aUWeSf88OxlYBGFx3kgNzwV8QWKfC?=
 =?us-ascii?Q?Fl3KZKdfKdWq855ciMGAAeahZTxLqdoWEf4sfwkWIevjXD/B0YVFx+29PMGt?=
 =?us-ascii?Q?jJBS2uZzJzgBl6cZpP4BiY0rtEmcs28vaBso5vzdXkd4piOqrgPIDTGkt+Js?=
 =?us-ascii?Q?wIAtxHMO6U7gNQ69nDAg9E/tPuy97mInZpSRwVPGSkcjjKuE2qcnXzPbzWG3?=
 =?us-ascii?Q?Z3yBUWfwOle2/2O3/NO02Nwn9eo10uLRd9w4h6Aq7IMGc7UKrU1T+EkkFo1p?=
 =?us-ascii?Q?Py+sSILc/TE+znVUR5R44qkw1L64DSydOTFjNiqcihWUlRdoLOw21Q0K595N?=
 =?us-ascii?Q?v5oyXKxlDUpyDKbg3ugxIECJc8Ati1JdKUhQNcXr8KYuTdc9hcb3ABRt6evi?=
 =?us-ascii?Q?LcVpWUMlCBfyCRUiT6yrIGDa2tmeajqYZx3V4+LVb/Hukyi5X2JLkg2oS0kq?=
 =?us-ascii?Q?tr72ghjyhboT6iqR96TLpQinqDHK8X7JO5hNy1sXUuBZBmXQuuT8j+KpW5xz?=
 =?us-ascii?Q?+D7i29RhZz98qSNdWer6aq7m+OI4IP94Y2xURdmig79vwR7/ylYDKjIS5eF2?=
 =?us-ascii?Q?NrapWJoeEA5kWIvTo/Agv8OcrgQv9X4Hi1n/gTe8Hd8JSGWBk5PhNIBMB1Kw?=
 =?us-ascii?Q?ArtS94usJOm/IsbwiJ5MJeO6UrBYwKYm+0Cap6JXAs2By/hIy8D9sSTU4eAU?=
 =?us-ascii?Q?0PFuLIuecMswRt3cQu1VMYl+1gsnARUPw9lHNLn4HyJPcxSCFttN+u4ZzAtC?=
 =?us-ascii?Q?AhzdkrHMfrWufnn4h8xV41nzSJGbILj6fUjnh0ae9IxcXEtkzJD22sDlEN0+?=
 =?us-ascii?Q?5Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: iyVuA+jNUzM4F1WtLpEr2Icv+yNGw5mgufArMVvhRgscHRdzSnh2G0AsjBbNqupwEt4Smme2XTuWUOMFCm/XAALkZl97eqwvDgDyRRthETflcBXMe1BxpfA+VyhO/SEX4v+8Qd7FJzdqrR5LZOCBWxF06qEOfzpUXue1rBIaq3SyPpqgBQm2cRwrlLZz+ZondUHoVWd6bjoY4V51scT+KDctuCK105feYg26cVtHarf07+qpjAxk2VpXX4qhxsXbng63i7JwgL1vsggWKjNsl4Q0ncbFUHNB5vTHaogkl8oP0JISIPYrut+EalFvRUIN4xJpGw11JTpGitIb/ZsjQZJBI7JmsELQYjO8JQArk2OKsa73AiVIaKGU1Aysnrg8VWO92zFg490+LVGItXqufCwJAR62aq9Hp4a1tf/F1jXRLPI0i5T8xlmyn/Njjvukyb4SWr7sbv20bDMSR9jhtgpKoxi1rAhLtPd9QgTBq1rKrOSgJTUcQBEWIfsK3VW01FrfLs7oDt5wygbN887ZRpio4RgpLs5TbMzXPUXnHDV4Ve3Jyj2X5kpZ8HGNtdxBa9VtoO/NkiTq5qCArAF/NSaqEKBRTJeQ0BvMah3o7Ji1QQt5ImDxQ1gPssB/uQcRDttygFr7fB2u4n3q0dDl34+7OUnNpo9DStENhmLAZpIzmf6lDnewRNtxeTaiGi7he9GfcXdWBk7y6GTZda9z/mKQd9Ri3O2sW2RtYVlDFWQUFHx7i5d9f3jcjY730brfyPHnCWxAqI0pyfYjayCcwVg4mcXw7y/iaMA8NyGuDGlZN1ffmWp0g/SVYyxCfBB0Ziz4vGnxUcAKog+B5l8mfTpUgLriUpc80cKuS0HKrUhZ82LahHuhJYeJ8eKmJZ4l
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c17d2904-7c46-47fa-9ee7-08dacc3b4f12
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 03:40:32.8728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iYNbnZ18nfJA2MdnIg7o33QjZVa2Es2BK4UQq9XHHnGTJP0OUCtjSXmntwbELJmBXbHImz+RGhklNaIjLvprB0QG6nkIBR4nrPtasfZOAYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4472
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220024
X-Proofpoint-ORIG-GUID: gVQN23Ae6Tey0PEdIcMg89zpfvf83djr
X-Proofpoint-GUID: gVQN23Ae6Tey0PEdIcMg89zpfvf83djr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute is going to be removed. Convert the scsi_dh users to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c  | 22 +++++++++++----------
 drivers/scsi/device_handler/scsi_dh_emc.c   | 10 +++++-----
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 18 +++++++++--------
 drivers/scsi/device_handler/scsi_dh_rdac.c  | 12 ++++++-----
 4 files changed, 34 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 693cd827e138..0a595275eea4 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -127,8 +127,8 @@ static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
 		       int bufflen, struct scsi_sense_hdr *sshdr, int flags)
 {
 	u8 cdb[MAX_COMMAND_SIZE];
-	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-		REQ_FAILFAST_DRIVER;
+	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
+				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
 
 	/* Prepare the command. */
 	memset(cdb, 0x0, MAX_COMMAND_SIZE);
@@ -139,9 +139,10 @@ static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
 		cdb[1] = MI_REPORT_TARGET_PGS;
 	put_unaligned_be32(bufflen, &cdb[6]);
 
-	return scsi_execute(sdev, cdb, DMA_FROM_DEVICE, buff, bufflen, NULL,
-			sshdr, ALUA_FAILOVER_TIMEOUT * HZ,
-			ALUA_FAILOVER_RETRIES, req_flags, 0, NULL);
+	return scsi_execute_cmd(sdev, cdb, opf, buff, bufflen,
+				ALUA_FAILOVER_TIMEOUT * HZ,
+				ALUA_FAILOVER_RETRIES,
+				((struct scsi_exec_args) { .sshdr = sshdr }));
 }
 
 /*
@@ -157,8 +158,8 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
 	u8 cdb[MAX_COMMAND_SIZE];
 	unsigned char stpg_data[8];
 	int stpg_len = 8;
-	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-		REQ_FAILFAST_DRIVER;
+	blk_opf_t opf = REQ_OP_DRV_OUT | REQ_FAILFAST_DEV |
+				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
 
 	/* Prepare the data buffer */
 	memset(stpg_data, 0, stpg_len);
@@ -171,9 +172,10 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
 	cdb[1] = MO_SET_TARGET_PGS;
 	put_unaligned_be32(stpg_len, &cdb[6]);
 
-	return scsi_execute(sdev, cdb, DMA_TO_DEVICE, stpg_data, stpg_len, NULL,
-			sshdr, ALUA_FAILOVER_TIMEOUT * HZ,
-			ALUA_FAILOVER_RETRIES, req_flags, 0, NULL);
+	return scsi_execute_cmd(sdev, cdb, opf, stpg_data,
+				stpg_len, ALUA_FAILOVER_TIMEOUT * HZ,
+				ALUA_FAILOVER_RETRIES,
+				((struct scsi_exec_args) { .sshdr = sshdr }));
 }
 
 static struct alua_port_group *alua_find_get_pg(char *id_str, size_t id_size,
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 2e21ab447873..7da4c5ceab89 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -239,8 +239,8 @@ static int send_trespass_cmd(struct scsi_device *sdev,
 	unsigned char cdb[MAX_COMMAND_SIZE];
 	int err, res = SCSI_DH_OK, len;
 	struct scsi_sense_hdr sshdr;
-	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-		REQ_FAILFAST_DRIVER;
+	blk_opf_t opf = REQ_OP_DRV_OUT | REQ_FAILFAST_DEV |
+				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
 
 	if (csdev->flags & CLARIION_SHORT_TRESPASS) {
 		page22 = short_trespass;
@@ -263,9 +263,9 @@ static int send_trespass_cmd(struct scsi_device *sdev,
 	BUG_ON((len > CLARIION_BUFFER_SIZE));
 	memcpy(csdev->buffer, page22, len);
 
-	err = scsi_execute(sdev, cdb, DMA_TO_DEVICE, csdev->buffer, len, NULL,
-			&sshdr, CLARIION_TIMEOUT * HZ, CLARIION_RETRIES,
-			req_flags, 0, NULL);
+	err = scsi_execute_cmd(sdev, cdb, opf, csdev->buffer, len,
+			       CLARIION_TIMEOUT * HZ, CLARIION_RETRIES,
+			       ((struct scsi_exec_args) { .sshdr = &sshdr }));
 	if (err) {
 		if (scsi_sense_valid(&sshdr))
 			res = trespass_endio(sdev, &sshdr);
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 0d2cfa60aa06..cb2f01b600c2 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -83,12 +83,13 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	unsigned char cmd[6] = { TEST_UNIT_READY };
 	struct scsi_sense_hdr sshdr;
 	int ret = SCSI_DH_OK, res;
-	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-		REQ_FAILFAST_DRIVER;
+	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
+				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
 
 retry:
-	res = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL);
+	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
+			       HP_SW_RETRIES,
+			       ((struct scsi_exec_args) { .sshdr = &sshdr }));
 	if (res) {
 		if (scsi_sense_valid(&sshdr))
 			ret = tur_done(sdev, h, &sshdr);
@@ -121,12 +122,13 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	struct scsi_device *sdev = h->sdev;
 	int res, rc = SCSI_DH_OK;
 	int retry_cnt = HP_SW_RETRIES;
-	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-		REQ_FAILFAST_DRIVER;
+	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
+				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
 
 retry:
-	res = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL);
+	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
+			       HP_SW_RETRIES,
+			       ((struct scsi_exec_args) { .sshdr = &sshdr }));
 	if (res) {
 		if (!scsi_sense_valid(&sshdr)) {
 			sdev_printk(KERN_WARNING, sdev,
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index bf8754741f85..08ad6a2282ba 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -536,8 +536,9 @@ static void send_mode_select(struct work_struct *work)
 	unsigned char cdb[MAX_COMMAND_SIZE];
 	struct scsi_sense_hdr sshdr;
 	unsigned int data_size;
-	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-		REQ_FAILFAST_DRIVER;
+	blk_opf_t opf = REQ_OP_DRV_OUT | REQ_FAILFAST_DEV |
+				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	int result;
 
 	spin_lock(&ctlr->ms_lock);
 	list_splice_init(&ctlr->ms_head, &list);
@@ -555,9 +556,10 @@ static void send_mode_select(struct work_struct *work)
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
 
-	if (scsi_execute(sdev, cdb, DMA_TO_DEVICE, &h->ctlr->mode_select,
-			data_size, NULL, &sshdr, RDAC_TIMEOUT * HZ,
-			RDAC_RETRIES, req_flags, 0, NULL)) {
+	result = scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select,
+				  data_size, RDAC_TIMEOUT * HZ, RDAC_RETRIES,
+				  ((struct scsi_exec_args) { .sshdr = &sshdr }));
+	if (result) {
 		err = mode_select_handle_sense(sdev, &sshdr);
 		if (err == SCSI_DH_RETRY && retry_cnt--)
 			goto retry;
-- 
2.25.1

