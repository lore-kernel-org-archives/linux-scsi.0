Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D085C25B08
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 00:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244668AbiHIAHK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Aug 2022 20:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244664AbiHIAHA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2022 20:07:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A341C92F;
        Mon,  8 Aug 2022 17:06:59 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278Nwhfj031116;
        Tue, 9 Aug 2022 00:04:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=1sge6uZmDOyuswXIVdUO1HSw+3HddjMSW4Kjib/+SR4=;
 b=wbRtA5sKL9DZxEWBN4SoCsfV5Id/fb8u6CWeBOzCS8MgceCgESMn+96MVSxuhAMXxvxr
 EuRiYlJkxd7YOjZvXA40MMkQyKVZW0zDqXUc7ftG7Po+O2qfrflKeS0hOrO3xRA4wyn4
 e6cx/Nxt+Go8E4iwcsv+CPI1O1rSZdrz6ish/GALn6mO1hi6FMhIhJLH2n9V1XiepdQa
 czmRonS73uRC9vuF8TnfP1fjc9MAIUe2EJtGC/z4fYhiQ+sskKM0/6R7FXDET4FydrU0
 6YvC5v3ITGLY34wFRCpOpQ1oLpFkXwwclnlerwUlXsCDIQsakFHn+QyAK+DiqMmYBpNY dQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsew155hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:47 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 278M0wOA034454;
        Tue, 9 Aug 2022 00:04:45 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hser2da0q-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hLG3bHRRtluwQSTw7XLBScLpE6NnqZk4XfJWhp4LJTmpI8j1Djrvp6rOUqprn/DOUFUzs0pO79xP6ZOlHDG1t7NQ4GQTW5VVn8LCJXZoUsdB6YqsOBLmvf1kT9Uq5uwEWSrCy+VyhAq3ROUzU44GrZhSyyDhebAvQXZ+8DPWTOvnfar23g7+KZFofxpDauLptRZG9fCq+q9LTIAIGKPocTXXD8QC6tYJ+ADiu5CgB3oHCL8pMH95h6GNMXril0k6yHjCpA84olfdMxvwB++NerBSAl3DQATdoRQ9EJ/xsX4au2CXezboQXOFWHk/Ga8tNJU/7FoowC0Rc9U5AWCenA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1sge6uZmDOyuswXIVdUO1HSw+3HddjMSW4Kjib/+SR4=;
 b=m9LtO9xskUnrH7B4h/og/eeb9q7ZyafqICecwEde4cdwD3iSTpZvvO52BXz2+ldNoNPKDPRaUCgq+iRBxStphlV8EvCfTnGOzlpTdud4ZROWlPkKi9ktKDK4MESEcdvdSZqWvCl3lUfsUBLQZjvg+6q7LAxuE9QR1KQpWkPe+YbSQHJlIBYDbbf0OuypMBVJr4mUeJ+LlNjLakfx9v6T025xYl25R7SlXuvK0ntnsJdVCAx2mia04OqQn4m/tGXV7kco0EXaxCWtHnSCUF01En5fwLd404ej8jP/ySqye8s+P9BKUXA4MFbAIiDhv5zBtt2Xhup4XyE+vBrTc0ihFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sge6uZmDOyuswXIVdUO1HSw+3HddjMSW4Kjib/+SR4=;
 b=b69YNOBM7X58w3fS2rDZV+TZm3mJrdA12nx7VgAZYKdhqHsVOVkGB4PiJAIJsHYGKDpFUQCj7xxfzr8LYc+tM2679tDTs2TbUcY+pb987qJUl/q5c3p2LljTy+fqcfXDlFNkCI3kXY+LEZ8p0iphyh38IjrboRyejJR6bjay6ns=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB4907.namprd10.prod.outlook.com (2603:10b6:610:db::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:44 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:44 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        hch@lst.de, linux-nvme@lists.infradead.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 15/20] scsi: Export scsi_result_to_blk_status.
Date:   Mon,  8 Aug 2022 19:04:14 -0500
Message-Id: <20220809000419.10674-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:610:59::23) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e026638-f8f5-4c3d-d4c7-08da799ac3e2
X-MS-TrafficTypeDiagnostic: CH0PR10MB4907:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l6dQiQk4CJoci2YIlEjENFhiBDEKX3oQjnb2kgzxP2k35S/lQnH5PL+33AdcGYiEB+g7UnxM94Gj4T+nigZbYI4L5tPvp3MCQ2bK/16eWKttWpzyCi5kL3W/zlJs8QtH/PxlsUv1s45LQcHzbcYKo7rtH5VofIi9I55m7HLUhbcEDX+Pe0snxi3IqGghu7LO88Ylvb+5wRsyC3gc/aIRHxj5dD+BFOnwqxPBjnOU2n8UwPA3Wu4psOAxzzWbBSn6gDkcLDs3qs2FauxLk3m/3uSpfYDNaUYyZpphKnXelLTPGY/910PAZuC6XAck5uXRuKGULyzEMofX3M5dpFo2A/ua15OITHW/UsMWOUzkszNxusqSAESJMPoXApFlkdBgB1olo4wXlavrWAfzew02fMFTllOuGzw0cPWM9pzdvhRia4Lx620JLctYZ9yDXoBdHOAX3/t5ECx8STM4JcY2bSwpRfQJetj5M/lDKpqxP/Zou4zDuDBY4z9oDuEfMqtZ6N/UepVn+fEBg9B3fZn5v1Gu+MvhqBkPqWhf+Skh9i2W6KSC+ho6DnfUpfzSOdUJp96+AVzBu4Ho7vNZ6Ksjbjbanen5SZqfYPcQlSzuWPR/ssT9/3gqb6K8Wuyf+OoLU7voqzY1tBrkxaravLIb2hsBo65i7tI9wi0JVMDEnSjzwLIDGvp5c6/GLuwyXJjtu47SzOigq8EoD8cpta78xky0qfQEKaMUVxhiG67tJuUd8jm9lC6uupKk49TxpMYMGFDUZfrEQJhMj1VZThxH5e1Ya/h2Ib3vWE4I/WXCovE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(136003)(346002)(376002)(39860400002)(921005)(6666004)(41300700001)(6512007)(26005)(2906002)(6506007)(83380400001)(2616005)(107886003)(38100700002)(86362001)(186003)(6486002)(1076003)(316002)(66476007)(66556008)(36756003)(8676002)(66946007)(4326008)(8936002)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VGPAvg+HVdIYIMtlW4dZZ5GVmcftTne/n8BcwXIreyXVNPzLRyZmgGzN4NhX?=
 =?us-ascii?Q?I4WtFS/2p/Evim1j92/BFYNz6U4EGtzhtxMetWvgpBP12Thqqvu3s+CXcOwe?=
 =?us-ascii?Q?pQM14PdgEKcaLiVIaREQ21/kg6EU7ezyX8+F4Wwyvy5zezgTz0l5taMINHM2?=
 =?us-ascii?Q?xHXmd/riYw+aP8fronCI4hQUOdXrnT2JbjyqEuGTcyTF9+JR2QFxfrlr0rp3?=
 =?us-ascii?Q?+BtZin4srhw029dy3d5mKMrNmNzshBcs6SByuulgJvbHNyVjjPHPuJ6B1PKR?=
 =?us-ascii?Q?ZctXpBwiaDDWEECrhP36/kCrTSpugPS03Xx3kKgzxQwaGIirbxV2tu0fn5pp?=
 =?us-ascii?Q?m9yVcgFmguYgkdQmiJpcbOAKZiTjhkCeUAsEo+adIFzKOSBRfpqNbL6uv2YD?=
 =?us-ascii?Q?X/A4BWSPW5F1pnPdaFVSy8X097gLySeaULFDM6HnRaoEXFDhSIcEA6bRaRn8?=
 =?us-ascii?Q?Ek9dF6ezM/LbLmUBSSQHtKT6h576zu59o7G3XmzUNOUHxV4VpXHeLiwefT+W?=
 =?us-ascii?Q?cITTbRUrjMxyaDYknjjiTpg+Izl4Z0ifwXuudBOGb27gHE4Ibc/vLlBkpZcV?=
 =?us-ascii?Q?+Rg+50/lQYjnqAIK5oWoMRNfsQsIGP9PmgRKoJkOxl6p0nhU+sMm5Zj9EEUq?=
 =?us-ascii?Q?QUt/B1TCqJbcyp7kD6y8INhV2pggisMq+hb26ihv/BemefrzU3iySVi8Tb4R?=
 =?us-ascii?Q?7q2u5f7irC82uW9yWvbtjLg29EDEoPN21pahddtUGnXR7WYMsk0qQB+p9GWJ?=
 =?us-ascii?Q?0ZAk/LcVzUgw5thHIIfyDYdFeNEWSVGsOVXGX2aHPYn+7tNY/fbPxE5TfsHM?=
 =?us-ascii?Q?KFaWLwXjK+1d+FFckxoLPgDlm1bshunZeKB+pM+T+E2Bj3HwoMANBQgD/Dlx?=
 =?us-ascii?Q?/P1nSbFJxTnFatxoovlJmpyZRzoMKnhZQ7ivRFedDI5Uj2KRY+5ZeBPEl1b/?=
 =?us-ascii?Q?Aq25ODg6ipmHtPCbm8kgg17ApeaINKYSsBBVtVoMat7QjOaXwU0M1moOjDuf?=
 =?us-ascii?Q?e7EPN8S0RnTNPUuFgEGk+VGHfe8bV4EXyRhRgPVZnnNIwqTELjpKWUpYEh4/?=
 =?us-ascii?Q?jIoMHniT/+fv/UFvzLHnbPbf/UnIN/38sJVjUaGeLPNz1L7FFJvKAix4GZCR?=
 =?us-ascii?Q?xWexbCOBJ1M8OLZQKXkyTI9vOXMRWrib+Vo+JeJqFTMT7i3qSWcUbi2aflnF?=
 =?us-ascii?Q?hrlymMOK/I4AFxI/VAIE2SF+d9BnNsAJ3Q0b7qyG9Fx289MP86ZvGK92pTNq?=
 =?us-ascii?Q?nNIAHgSajOicpLfYDbxyetGDz5F/2Qm8jSrzI5QjLJoUwtNSqadvWI3FGQ0q?=
 =?us-ascii?Q?fuTJpDlrrnthZCdm+BfVb5TMX4ytPKyArFfWru5NloTK+GFp18lkLQfFQYmm?=
 =?us-ascii?Q?4W/nSOlJ/twowW4w4IqGUJ4EpUMat7uehOVqexRzGXMCLhi9eIRawN5DfBM3?=
 =?us-ascii?Q?9qkmh26MajBqHw8M4PE/PXEquU0nEnA3ano5bG36C1puhAFiinQNy2lAIjJ2?=
 =?us-ascii?Q?DgGMglJ1j+x9THJQTmItsKMZmzo+NrCcS23Wi0f65odTNKIMM4Nujawoh1Qw?=
 =?us-ascii?Q?lwtQxLh1QgwHBS85ERy9UxhIj5IJss/p90TgfNk6F2y9gJiejif6wyIWda6L?=
 =?us-ascii?Q?pA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e026638-f8f5-4c3d-d4c7-08da799ac3e2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:44.5787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UAsYdiRwxLGLg14hxrHoLUiG3ly5vj2SlFqjKBsEMG6ubq6wVOD1Qy2IslUsrsBEZky7hAOP3m6jYOJsriWIP7HN4eKHL0aLMuDB2A6NUiw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4907
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: eGr85Xv6ZWE4f5jBH31vF5JyTyVnOliB
X-Proofpoint-GUID: eGr85Xv6ZWE4f5jBH31vF5JyTyVnOliB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Export scsi_result_to_blk_status so the sd pr_ops can get a BLK_STS error
that can be returned to other kernel pr ops users.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_lib.c  | 3 ++-
 include/scsi/scsi_cmnd.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a2a3a9bd5ba1..d7825ff8915d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -587,7 +587,7 @@ static inline u8 get_scsi_ml_byte(int result)
  *
  * Translate a SCSI result code into a blk_status_t value.
  */
-static blk_status_t scsi_result_to_blk_status(int result)
+blk_status_t scsi_result_to_blk_status(int result)
 {
 	/*
 	 * Check the scsi-ml byte first in case we converted a host or status
@@ -618,6 +618,7 @@ static blk_status_t scsi_result_to_blk_status(int result)
 		return BLK_STS_IOERR;
 	}
 }
+EXPORT_SYMBOL_GPL(scsi_result_to_blk_status);
 
 /**
  * scsi_rq_err_bytes - determine number of bytes till the next failure boundary
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index bac55decf900..c4de69ba859f 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -155,6 +155,7 @@ static inline void *scsi_cmd_priv(struct scsi_cmnd *cmd)
 void scsi_done(struct scsi_cmnd *cmd);
 void scsi_done_direct(struct scsi_cmnd *cmd);
 
+blk_status_t scsi_result_to_blk_status(int result);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 
 extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
-- 
2.18.2

