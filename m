Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB7ECCF9E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241424AbjIEXVX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbjIEXVW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:21:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459A9B0
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:21:18 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385NAAgA018624;
        Tue, 5 Sep 2023 23:21:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=rGqIjL2BEoDerG581WhKY+B05xy5ECIGM99ZRskov9E=;
 b=k1ME0lcDm8TcITtbqRlFeS0v91x5MeYZ1Xz04oiZ6tttRJ2Mgciy5T5IIUTQQuuTnUHX
 PuILvHLWqUjz3h6YdrVJZ7UoRxNVXo0Y4lcWWluWbggF8Gpqz2mSJjuyL6tE83J2cBCw
 Jy+QyNjpwrjR5dUieK0icMmMBe1ypiDpOQjmeBS1ZmX5jTwjL8/WdQPdfqOG//pz3K+H
 mOpTd471hIc4AomlwLGZ3Ilr2SmP04lClmN+yZSXpax1HSXd9heqaqNFwesBfhI82nH0
 6wf1MCvNYT7eGEViSZ5MMsm5aIr+d3n77TEGdksB6yJMur9aKZIe6zCteXxAQu+Hgll1 8A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxdrn00k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:21:05 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385MDVk4010582;
        Tue, 5 Sep 2023 23:16:38 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suugbp37f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kWGMItHDlwymQSOo0avQ5UKHZbyAVlW527/fO1RVmWaQ97wjSoloWfJhEfl5b/O+I9bHRk7kK5gxY/obpGlvMFUYH0VTGYXGCCUTTIFkddpnZ0q2H2mkGRTBuJ7dNEIb9utLFGeHHWvJ1LfqM/By6aZyK/uNs31lipU6upNLdM4ujYPZPaK0qQ2xAWidE5dFhieEWSiA4vWejNLiXoqBs1tt3d1g7+83n+26hBoK9b++wW8+T1lpzfocKRYN5yD/bpp7xXUbkL3Z8Olp1raqmwzsejKPJmCF4Z+S2h0UGaxN7CuNiIdwZi4PCjGlDofp0Y7vEx0I/MEC/U1WvozeRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rGqIjL2BEoDerG581WhKY+B05xy5ECIGM99ZRskov9E=;
 b=ioT0JVaoHRCvTWWgxVDY5vBo5JGHBgIzqYWGJ2UpU91xpDER4uFE0912ygyEyK6scN/9q+zABybYw8JtqDu0ZGpUQzSOSZ3M1ArIinJGrtuX/YxR3EQqhG6k0LWDBPZyJVwUSL4uSvBzS9Sd17KRVFX6Q9DCxCp3loScVnTpgP+4uT+rOQ6NRaJpSVtqPh0sxsk9K7F2HkS6HzI1KILziSvnl3MtyKIf1CYKk6xR2OTkPlcLSr08UVk8IrbZIXWeAHzgoNpQIlZLcgrEj2AUIHQ0pC1wYbK23LxmxcRP/2qNj1+yDkhM6gO1lqmvOE1Nwp45XCvkR0BiYHcasaILMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGqIjL2BEoDerG581WhKY+B05xy5ECIGM99ZRskov9E=;
 b=fVOFLZgFiRlQx77nl/RoAwnkGp+pzuuPxOxP0f8yIUuADuyu9PstjiGPOpI6c0t3troM7s0SCnNCoBAym8t/o0D5FTTkE+iU2OOUqj4ij0K47/YDJS719fIOUcLEvu82/yGDW/9L90H+rottd4x8u3YnhnGLumr2MbC4ktKD/lk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6109.namprd10.prod.outlook.com (2603:10b6:8:b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:16:34 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:16:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 24/34] scsi: Have scsi-ml retry scsi_report_lun_scan errors
Date:   Tue,  5 Sep 2023 18:15:37 -0500
Message-Id: <20230905231547.83945-25-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0254.namprd03.prod.outlook.com
 (2603:10b6:5:3b3::19) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 77673dd7-d1e4-428b-bdb5-08dbae662586
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MXXkJWgxiu35x2eFoxdWA0xYhaoV/GeVvwLHPHq1ukLtNH0KdOfx80gNDBYpAo+eo0Yzuu61EB9WWPPWNgGWNsVX4gAtL46Nz2gxoNp4jUfmKiA7Rb4mTI0GXlPwI4GltW1Ns9an+vpJwLUGXEwnC+qf+nkY7dAP9vrmjZArFSCGyHAEaC0fmDuF//SyQP58/y/bnvKa/tn9b9hrQzDyE6oJ6btNpz+EiKsrmwgJhlUa3rHQVbso13RDhBinffmTjd9jim21WuQvsICcbjsb/uvPjsmcPT738mSV1O+uoDlbXjE8Vij7/XFZOI+hJfzncWd1dlTAxGeolZ08TFksyiT5daIjdOaP1NVlOBW/7WdyolAuqtV3IpiC0hMiS1GouZA/2FiKymOxfuWVBAS/aOTYww6oXBCCYwdNBi5Mp/MZsJKiwtP3FPFNOFe+EpYdZY0Ntie00jnrJXhn/CVNNpeMD+4j3gwh4eSq86J8ocogjmpW3fntXYH6EBnriZ07mvbzZ+U/o+ScyrUH/scuHaY4D1Efv80Az8Z4VAXfdOaLVWaWPlBWLLsD54RU5Tpt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(136003)(346002)(186009)(451199024)(1800799009)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(316002)(66476007)(107886003)(66946007)(66556008)(8936002)(4326008)(8676002)(1076003)(2616005)(478600001)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b8p6Dw0oWi1xC7+anjbCC2BlK6NP7eJ3Y4qB/LodxhKB32CJrNxZXwFODqov?=
 =?us-ascii?Q?RbUSSR96kElHH2aYJJ3w3ZCq+JLNQ1EIWYHnpoCe4UU6XzbU4adpqbdnElol?=
 =?us-ascii?Q?xnlV1Tkl9Sv8vjIEw4aTObzZGpr0z9h5Q04dlMOrVw04DTR943Q0UqPLjx19?=
 =?us-ascii?Q?UJyi/4bOpTKs4IENQf4fSoCuznZUQJt/CpuTr+K1owUiJDiFDaeTcsLQKEpV?=
 =?us-ascii?Q?G1k/W0tDkFEu4LZvFeH7tvmKG7s/D4CPg/Hbqg6MvTvakqkS4owpoA9imVnW?=
 =?us-ascii?Q?oNYqpmluxHC09LgyjBxF9nYEl3YwBZZ56wXBnpF8V2MsT+08f5OMUvQ/FRrz?=
 =?us-ascii?Q?BRVfA1oldYu840THQzrt9b1qUTfXlA9bxkIdCZEm33zWY5Y5Q6BIBDJOTYWo?=
 =?us-ascii?Q?hqrYYf5pNkn+u0Gig5+zPR8AcL0eDhh2ywhMrRnI11M+Sctw540GcRrW0L7w?=
 =?us-ascii?Q?yU69emA5XYqyQmZbM4XBZmOR4RAOEIj54Zos9nvfI4p1nbr0awdh4OJEIjkm?=
 =?us-ascii?Q?2y5LcHu9ss42j7bmDaMFR37ijIMAHh+mPvhrmFM2xB3cRaf+isCt3UnAlcuI?=
 =?us-ascii?Q?qdfZLCUWIqmNlOp0HF+yQR+VRRrjybtzDaamh1pmcTOM38AaPhnT2z+FcF5d?=
 =?us-ascii?Q?KLa+H6/qrDBRCcym+QPcg39tHTBwX8iYNHp2D4DdvcwdPTe8S24zAeRfX4EL?=
 =?us-ascii?Q?v3xXPENYxck3vEoCd2QcNSzAP93bfq2hMieQHzg71Ka8mEvsXUOCVDT65hBs?=
 =?us-ascii?Q?lbH7lWnpdVYSZIW78IMmvq2tcNaIGRBda1drnVznL5yevlBKKeHDiGWk06xp?=
 =?us-ascii?Q?XaTE6juNhJZRfwvTeaMrariPNe58zsKxPuqwnOrRYOxLnHuRvogV0ZNm5cke?=
 =?us-ascii?Q?17p0iAyZjyvE1wlVN5xuJMx+NUmx0HMHe2Fl9gtbL1va6dAEJ05vkHUqRzdU?=
 =?us-ascii?Q?o3IET6OccOQ6ByUm0jD4LE9zEXd4rqAANebZmYmzJXKmSK6DAtgnlHk3wcKq?=
 =?us-ascii?Q?mu5ms8SWhrjndEhiDnBq+NF+I72S39daqcFVMgBWC2XGpOLhSapTOfg+zHR+?=
 =?us-ascii?Q?egjA7iMukWeFSqQoykf+SVi275HEa8YyORcuYP9EpVbPIV3CWACP0MNWjNM8?=
 =?us-ascii?Q?8c5+mCfKgkZ3kS5vUMmA6D3jx5DB/nPAZk7MPXZdikt1UJwU9XBQTRAYqAp3?=
 =?us-ascii?Q?HymlFAvvqFt6a3WAundt2vySmSGJbg3i6quYSnXWfLjdreR7ClgTZo4ycnY5?=
 =?us-ascii?Q?gy93DUGa6vmtyqQzDcWVm+ZK0ZdZmuOmQ/TyCjXRVIFzlWLU5vvo5rRBs3iX?=
 =?us-ascii?Q?jyIdV76nopD+YvzowzXoZI3ieEU/oD4xaMqbDLHOIBaw779EcxYvnVHey18s?=
 =?us-ascii?Q?Hhd1xoqy7J/18sW0Rim5fZSgljGwzGCWJnt24XDtmN3KE0F3dohgpFzDEZ5u?=
 =?us-ascii?Q?dXUC1GXjn1Cjtl00bSC7RRsGc5Hpa1S8d4j1nj0oYRX4tiEqALYByEIhdAL8?=
 =?us-ascii?Q?cnVuP3JNmZeq4D/OW8nxpyTpNM+VYGzsK0rnlH5MxxibfvJImLWp+QvBkd8B?=
 =?us-ascii?Q?NTBeDHjfISfEgGYr7fH/i4ZgRDXYxW4Y7+ZdGve5ASh2vDclsz+okJL8cpu5?=
 =?us-ascii?Q?+w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: K0pxwAQjos2QAZlbiWICn0yj6fjPxNVSCiU+QxVTLxNP3h+gY+DKMb+O8SNsSIRDA36ZoGa/KUjFmF2n7P3/uYnV7fEqS/kfPAhVllcJnEdFiuhhk5bElE5r72UQhBpwE8vJNDmnnoLf+wB14oEWr0beeEABI33TpEGgu4etFxSFuYdcoOakrQepI+S0tjSFTbNsL3SRTfsxIVb3qgkV6rMAD+ERWT3SpYLApuYhyN2YmFoXGu344uoraJ6lDTcEZr/E1s/YmucImF7X9+Jo7NGa8qevqiH4v0fyCo5X/ERtXRaMZsUOz67CwoQ5dXVELKx346bAd8R6PjRI7EDMycJbdVVJ8emRN0W6zuO5D5u4N6093eBK8GmDQIb1eeJzG7NJgPx2V3UdyFcAzYqiv68oAjLFMnzYJxK1YlfuX6Iap75ctmPzZJ/4f39oZxuAf7F8pwg35ae34G4tum5z5enxm4BtneqCTQlgVNmIipVO6yTPym0Vkn5TNVsk28A035sfqUqs6xA6MDAvjk/ZxLD3Hkbehuz5kUqXwrxx5Kb1ICVXKm7Uno19GH8HDBVyOjn5JxvetAdbjJamT4/PZJ+UTLYaAhgiEcCZHaGNK9vsw07t5lDiNnkaz14VReL0oNQqxAlalLjrRX7ooXC49EvCX2JTJngnRXrbUl7lnkorDAXCbGRAi40gh/fqdurIhH63RTz+8z7j6LactJpotp0Zqpkqfx97jTdfeSu+3x1hXHvrR9VlWBgmm8D2YOhYzpcMPxQoT4KU9XTT6y98fJ5bm9AnFOl9mvB1BLGcLVlfwhuAK67s/xydN318zCbb54EfY4skrVqbhnBBVfldnK7kEw9RcCN7OhzyFvrXOjcXU4A9xKq1rXpRlRaXPcI3
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77673dd7-d1e4-428b-bdb5-08dbae662586
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:34.3821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GtRElbRRQYC60yZXPTDutbmdFoq94yffGZHJkeTSlgvVMtSSPKIX93W9ADdBXIK+3DuZdRA6JhSYt1dfxUS8TWkiCNo8BUuQF4Bj8UNctuU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: hduaxdFT3b9E0K3UjUBD15PeuuQccVAL
X-Proofpoint-ORIG-GUID: hduaxdFT3b9E0K3UjUBD15PeuuQccVAL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_report_lun_scan have scsi-ml retry errors instead of driving
them itself.

There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs the block layer waits/retries for us. For possible memory
allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
will probably not help.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_scan.c | 56 +++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index c27b64a1b239..b29c47c2a5c6 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1412,14 +1412,33 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	unsigned int length;
 	u64 lun;
 	unsigned int num_luns;
-	unsigned int retries;
 	int result;
 	struct scsi_lun *lunp, *lun_data;
-	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Fail all CCs except the UA above */
+		{
+			.sense = SCMD_FAILURE_SENSE_ANY,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Retry any oher errors not listed above */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
+		.failures = failures,
 	};
 	int ret = 0;
 
@@ -1490,29 +1509,18 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	 * should come through as a check condition, and will not generate
 	 * a retry.
 	 */
-	for (retries = 0; retries < 3; retries++) {
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: Sending REPORT LUNS to (try %d)\n",
-				retries));
-
-		result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN,
-					  lun_data, length,
-					  SCSI_REPORT_LUNS_TIMEOUT, 3,
-					  &exec_args);
+	scsi_reset_failures(failures);
 
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: REPORT LUNS"
-				" %s (try %d) result 0x%x\n",
-				result ?  "failed" : "successful",
-				retries, result));
-		if (result == 0)
-			break;
-		else if (scsi_sense_valid(&sshdr)) {
-			if (sshdr.sense_key != UNIT_ATTENTION)
-				break;
-		}
-	}
+	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+			  "scsi scan: Sending REPORT LUNS\n"));
+
+	result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN, lun_data,
+				  length, SCSI_REPORT_LUNS_TIMEOUT, 3,
+				  &exec_args);
 
+	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+			  "scsi scan: REPORT LUNS  %s result 0x%x\n",
+			  result ?  "failed" : "successful", result));
 	if (result) {
 		/*
 		 * The device probably does not support a REPORT LUN command
-- 
2.34.1

