Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 646A2C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Mar 2022 00:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244493AbiCTApq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Mar 2022 20:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244484AbiCTApm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Mar 2022 20:45:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CB1241A0B
        for <linux-scsi@vger.kernel.org>; Sat, 19 Mar 2022 17:44:21 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22JDHFEs017476;
        Sun, 20 Mar 2022 00:44:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=V6E1xyfdG0sMcYFI86rKLjGCzrRBMs822iIkct0fXHQ=;
 b=q/Mbfu1+KsSdBRqJqW8hR4eUfU7bCOor3CkMoPNaUQPH3u5WKBFk7vZprJc3V/yWXITM
 HUHVV8fKEWIxNf+PuPCglRo3RWtjm1ij9dwOtGI7XlKXGevy/EOn2JQr0GZQGa/NKG60
 YFaeb/gM3R18sw4EciVe49EpF2eYl1Dr8dJH0gcL+h8A14FzjI2vYhRCoEHlotyms/pe
 szObCpBd8ncfe76rEwnfinT02PH55aprSJ+eQ4eWfvdlRFY4aFWRo5OMQvWvcYDZ/H0U
 5DHFD+4enC5V+K/0U5L1MIyUurm08TQbi3/QwBzIKFwoxir2pSResct0IyUoVnmkFzTP 4w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5kcgw8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22K0ffaj137063;
        Sun, 20 Mar 2022 00:44:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3020.oracle.com with ESMTP id 3ew8mg6mq1-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8cr5IEl/OhdXKCV+7BDOEBRYKjarpVdlsHi19ALJBsUYL2d5LiwobchyEn0/g+BnhCP721YhNJWYSm2wFKMObpEshCO+nB38fzPsiLQpb7YUYowlxyhpy3U2I1BXIz9zCXTPtpH/2l5jA0EpIaZJOHTCoqs0xx04oi+MtOhQ0wseKPLe2irNmnWZgJHLE8MAav3gpDeUe72tJtUhVQ87viiU/HMJ1gJF30v+LkmYM0jQw4HrTipegf3+x5bq+otGoWxHK2ztVlvpK1pfJp9nR33RXVM9/sOYNbE2D6fPlCvDlITBEuRZLFMYZxGfkySkkbe37zDlO7IzMfXiXlLmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V6E1xyfdG0sMcYFI86rKLjGCzrRBMs822iIkct0fXHQ=;
 b=hnwyAWuAm1yRdHTUANRZGuo2YsAfl3Jc0C2zx9/1ZOU/X5l4HLMU44P0LRQGKxNnhKCzh7FRL5LBFvCFs6G9yaHioluS9TPLNrYV1I81oKzg7YbeWMvHNht7NjiIul3eNyCvhXJG9kpfflLJNTgq0zd7g4YpCgRa6YfodxB1A3ktcSmHCdHOPInxf19zYcuCA7BTWKR+SBR61PVVZsZxdllpuCJs3aNYJmC0F2T0yGI6H9lF9KAp2kq8GutdDoECoMkwHfAHCTLyUcYbFCVnpSDX5R2o3p+5vx/Af6MV2DD5BVekSaC58N7M3DQyNTAAudXd7x/FbigHB3Z/JCKwxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V6E1xyfdG0sMcYFI86rKLjGCzrRBMs822iIkct0fXHQ=;
 b=IZl1kNWidl8yUX0YmBIeQiq74f8gehbPv+/C2AUMww4Y2tk1VRblud5++KrSiBaRIbU+pHO/LfNaCK0mZUOB75J68m+kD8mrg5F3pj6cb4kB1+1tlQbxhwrHQV0SZJ5yyqyQ0GVdFPdQRLa9r1oxOVdh91cTUVyCvXBBdLrHXcY=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH2PR10MB3992.namprd10.prod.outlook.com (2603:10b6:610:9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Sun, 20 Mar
 2022 00:44:14 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f%11]) with mapi id 15.20.5081.022; Sun, 20 Mar
 2022 00:44:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V2 04/12] scsi: iscsi: Allow a recv and xmit work to run
Date:   Sat, 19 Mar 2022 19:43:54 -0500
Message-Id: <20220320004402.6707-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220320004402.6707-1-michael.christie@oracle.com>
References: <20220320004402.6707-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR18CA0065.namprd18.prod.outlook.com
 (2603:10b6:3:22::27) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88446c75-2d59-4020-304a-08da0a0ac15d
X-MS-TrafficTypeDiagnostic: CH2PR10MB3992:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB39929D0282700522A7718F0BF1159@CH2PR10MB3992.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VeqnzvlodR/UFz9rb9x6KiEIIBu33xcoARQYuB17celYTJUKJdOHBgq9zFAJYUqGWYmRIUn49ohvcu0SW+BwcPzTdJySUk4PNhrFK6eJalEXl1ZcUsTYm/k4nYTMkOrVsE3mD4XA1p0PB1BYjh/RZeipdFO7j45V7lt/C5P8umv+mVtJ1AgZrz/pkuoBZvwGS6//dK5lDBtJoseN3e9AGVG0h5OFqgMdOwPFzWmegps0iu2Lo0ALfpVbG4WGP/qnMjYCf7+/Vh9p/fztllXZPNT7DjqiqIKgv+rck3NxUpRJF/r4ZHldAlO9w3I0x3bt4WyZ3VnYbUt4Nqpe/rFSgrW6eZ5+cYFA6hmDYlteG1bHbPxcSAgpKtlM+M/pkeOjHVRVM7j+YYKVxEymm58mKvJ8URt1m612lmvjxWYSmJrpgoEx/P+al1c+s7so6Rzah1zGhUObdfqctTQLhcjOPV9ek0o549co0WP5IYWk+3Q7pMkV9ulnQaRdrCfsgiY9PxPvfKT0Z8Ck9YUSW72sSKS6a6xDrmmklpUF2jp8ZpsI9/3dJgC/mVPE2309kiADhIel50pMqZQLQTrELLrGiXlQg1KIpgC9fBKRAO/Y+ret3jEJjleoiVMBlgcVBl0I5g2+32gDQaS9s1t2hCJ5N6MB8MGm4tBF8vA6QsNlVWcY2Fmr9+MPHlOVJJRMxFude4oiZw1ruKhbAmk45G4npQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66946007)(66556008)(66476007)(4326008)(8676002)(86362001)(83380400001)(5660300002)(6486002)(6506007)(6512007)(6666004)(107886003)(36756003)(4744005)(26005)(186003)(1076003)(2616005)(8936002)(316002)(2906002)(38100700002)(38350700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r0qibsb5E6BmsHGQxPL3jZWL/Mhbz9CVPHvU0jsxqJwl0rPj5tmEsPIVD7YU?=
 =?us-ascii?Q?V9JS3f+LJwyGM+Obt/DOVpvHepIG2aD9VbDg/RkyiqsC+CTHmwB28Zm4YhpT?=
 =?us-ascii?Q?JkhME+5zHIOaipPgwMAjyoCAbPsEyJp27C4r6VOMM9htjv8Ex4G8ed+ybA/D?=
 =?us-ascii?Q?unhvknJai9MHDZPcHuQ3MNAEBCEraQ+ZjDbqTkNpMK9AbI65ZSmQN75+tcvj?=
 =?us-ascii?Q?CIUu2H/5rQFrfNMxsb0HV5/G920ydJZzafMfj9TIDXr0AZo9t5jXrUGhCG+2?=
 =?us-ascii?Q?L0h4+8MSydo0UUa1R1ZStdGrJ9s5GVE/qh6g4b+XMK8XtlQyUszJYccHAFzi?=
 =?us-ascii?Q?cyO+I65c6Z/Nr3bih/pYdyyGc6xYlsU9iIjCWNoFnTnWr44ZRHVtZ9t907Tz?=
 =?us-ascii?Q?fqVPi1i+T9UxNpSZeiUzwDSFHoqQBl7f1Cgak2V7AYeWgGTrpe9AVP3+5Mzb?=
 =?us-ascii?Q?5xrFCgVa9ceW/KxWomYhHsx6vTkrs+WNdgC2y/hHYw6QfCgpqDrX4Md0TLth?=
 =?us-ascii?Q?vuATlxxNdMFYyUmZEJ9ERfrOUbaZm+e9bRJrN9MiputnOv5kj3eGy91eBgOm?=
 =?us-ascii?Q?K64CAvqBnkLWx/xWtnWTz0+bK70oGK4XtlD57o7/E/kj5SJAne9HkhS3yO16?=
 =?us-ascii?Q?G/xJB7txAq1igSGvq0PusQlorI3a946ZsqzM265m6lnjRnbvxzGW/J3uprMC?=
 =?us-ascii?Q?CKGsUSL8cV08Q4+9FYBCQS46RnnbLyRzsyOlEj7YiAmhmww7JqbyGKm9TJpI?=
 =?us-ascii?Q?WAnnu59dKWjFqWeCgCX5714E9bHshn4RHZzp5csqrPqiO9JzrGRPWTSwe1M8?=
 =?us-ascii?Q?Fz00Rqm40cdi+rrINwIlZSbmTc9ksVUrIJqN/Pf8efuGeSFdycPZWTO9xIwx?=
 =?us-ascii?Q?BvLfEsDqUcARbQvwAEJyoJg06/3R4vn0wYo48YsnXVNgzJLnAdlGiwb/VsAI?=
 =?us-ascii?Q?6cRGk31o2x0zinjNUzREmakkjGWpCm0C/jnqU+IpykhD7eTSnedc5R6ahlb1?=
 =?us-ascii?Q?s56XRDluT0+pX8FebK7Ket53/VWamIiX8cCyO0pvWH2MjDS0nJKiw7J1k0e8?=
 =?us-ascii?Q?hr5ze9FiCS0BdzV0YfMKRLJkrTmpl+fd/daYx5q2fjcY73OOKqbG1RNIENOQ?=
 =?us-ascii?Q?3xv1HvuFqhn7vdN4z0s6ZhysQ/a539W1ES9MBxuvriVBIgsJZdfkc78oLf/V?=
 =?us-ascii?Q?WLMfPSVMQntdaCZihL54yokgUEuhm9D75lUhGBoLrRFRd3UxylMU2xStfsNQ?=
 =?us-ascii?Q?tlxKCrxfwwYHe8S4qsymXRPDtiTXVKE8SjuAMXboc7MaYPBqJKDSSp5w4ST1?=
 =?us-ascii?Q?5Ujw2eqxWKrKkevRqiVG6xosFXhj1PhTPkBNpnrlK0hsangVxTWek+9NKDm0?=
 =?us-ascii?Q?tBOUXV59Zn83BbdmVa3IQ91/XsDp2RvZAK+yRMY3rlUDsYiZDVxdsJ/wMSyq?=
 =?us-ascii?Q?NPc8vy7HF1i4Cg9nHBLG9MMXYmJsfy+bHRSYZGXuknHf9xNdfcStcw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88446c75-2d59-4020-304a-08da0a0ac15d
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2022 00:44:13.8438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1pWEyfe7Od6FvyMVFAJclXxXtvYfMszJEJiVqyCFTSG59zv12Xrb4yhwoiQgCVvVNQ10zPpDLfQbUmrHD34w2z6ORHvHDYLi9E0ReGxVmnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3992
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10291 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203200003
X-Proofpoint-GUID: 61kkDJsgeNNOWemWHXssNDzjr1wJ2yqh
X-Proofpoint-ORIG-GUID: 61kkDJsgeNNOWemWHXssNDzjr1wJ2yqh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow the recv and xmit works to run from different threads if the user
has set it up.

This also removes the __WQ_LEGACY since it was never needed.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index fec64cbfa4b6..0a0076144874 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2824,8 +2824,8 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 
 	if (xmit_can_sleep) {
 		ihost->workq = alloc_workqueue("iscsi_q_%d",
-			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
-			1, shost->host_no);
+			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_UNBOUND,
+			2, shost->host_no);
 		if (!ihost->workq)
 			goto free_host;
 	}
-- 
2.25.1

