Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A4E2C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 23:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiLNXwf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 18:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiLNXw2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 18:52:28 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7974E2E9EC
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 15:52:27 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEMwaa9009159;
        Wed, 14 Dec 2022 23:50:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=jlNOiZQUQlde1GP0KqLYkfyobLjLTy+CPpfH/jLBiiQ=;
 b=EZAXJeIZUPb08YpE109AH2EzsBEW6c3WlljagxXleoph7Ld/OAPRAe9SOzcUXasnPHHG
 vTQIvQTBOuvJ6tArik6siwVAnLdZeCQU3eVITUe/qNWtwBdn36OJOk/G12K8AlqnbenQ
 yOCSsL8TSbdCrmiWLIQzYz1ama/Pe3rcCwLQNOy1xDLyNWu7ro5i43tD9p/OmGuQ8V3x
 p/0CgDi6N46Wm9IrGnusVgvBikaIQDuvccATD5qvTyqVG607R2Q7+PahnXMy/XslTU01
 qT2t8H/YHEvIis8HSIyn018oy07XPz4Lby2sDJcOm/GeWME0RsoL0b4D47SLBl/VvnYn Rg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeubp6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:20 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BELUOVY018783;
        Wed, 14 Dec 2022 23:50:19 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyeqtkgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KiEADQLTfQlGbH4WeJhrBXTxthcE6wapkpJxt3MJp2KFJyfaEcz/CE0NK+LMY1ruhVKX/3Sv+GEH3sKNKcHjZuyH9flkZEcNhv2eezlMrUcp0aaMyw0brcise79TUdyzFYjic73MVGVTnB7Mzbxnif7WpY3GPph2jptru02kjZz1B9YzspSvnmYz0YBpKtExFxhMrh1pfqv/v988uU+Odt0gZ7NqWcUUQdvMej27nLrCmKtGElVo+0qTP8Ra6+Qf63Y5eEf1qSm5xM9Fi0jlHqHzR/VTOq/b3qxL2+YBYdtJFA6CvGB+4Chje42XvgW0wDFqb9vZjpp9x1rPDkGXfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jlNOiZQUQlde1GP0KqLYkfyobLjLTy+CPpfH/jLBiiQ=;
 b=VmWrZbt3490u7pewdzzuj9j6s69zUuXvbfNrNqb9ETF2Xc4n9iGAEZx0tDR3OT72C763/zysKLN1KTfXocKt3Sl9TQCqVMmMSYdkyWQAQSahhVxWTC/tKan40vbIm5u5EI8m4r/eoQXhwvfNiTU9DxcHBbmrCd4IsvZ42Qpx+MN0OQsICx03VsJm0+mLWG+3ob6+7g1Xzm1/Wuv7kCZuzLb8IYxwUhHD9b3Hs+8wCy8IchGM3+t+iTaEPexe2gY7fG6xoF04w+ge8C7pYkP7vPbFa2mDEaRxW5ulo8940sygvmz9GdIGJzmcYnOBJMxRDbn5HMgEchije5a9E9IzNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jlNOiZQUQlde1GP0KqLYkfyobLjLTy+CPpfH/jLBiiQ=;
 b=oltmgPMfmcYR0Go5AwMi33sfC1MKqRk+87N8WTJgWOq+RDR6IF9YCYwMnw5S+XuMUyR18i7dTsqnHXQHovSt1bfISQhioGJnvO76tKQDLQ3fGuP7JwjHtHluiMBu3sFMhmr+nZleDlKRfGbbbaS4pRbWKhoxvAeRZ7qOItEZrTk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6800.namprd10.prod.outlook.com (2603:10b6:8:13b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Wed, 14 Dec 2022 23:50:18 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%4]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 23:50:18 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 09/15] scsi: zbc: Convert to scsi_execute_cmd
Date:   Wed, 14 Dec 2022 17:49:55 -0600
Message-Id: <20221214235001.57267-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214235001.57267-1-michael.christie@oracle.com>
References: <20221214235001.57267-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0018.namprd08.prod.outlook.com
 (2603:10b6:610:5a::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6800:EE_
X-MS-Office365-Filtering-Correlation-Id: 5649f208-cc91-4942-435d-08dade2df45e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3hZ0D3uTkeS9/OWB+eLvLIrzXL/XRSAA0KRhlJZEpp4ekmk8VOHy8iHqzxhmOqSW5f0zy/BXqgSqOsM2hheWMSaCOU6DSBOytWtzmdvkp1KnpspA9BP8qHcLmy6PAl4tboamp5NPqOEog0WN8rDoijLXhieqXuw3f+9nNGqLNivKoZDioruH07HpbtwLqOVehs1XhTxA/2Q6HVa204ne2m+TEmzylK8IafCJCx+kcXOdPwEp1ASqKSSfIqEigMbltKEVF4Xlr6fRfDkEptMSVo+MTQpwtb5VHpusBAd73Ti6acD9ZHI8zZWk/fly3X3UaxKLvUrp7+//+Ax0UxrUDZwu7YgvlNa4wzmPgVN39J7XjU8YfrzKhhPqWi9J8eAUHNgKOan4Hxy3O+x37BkyHhZttNEmgLqNft2drkEtt6083BgdpHdl5kdiZ11yO8t2V5OaGu2N6Htm/TrzT41bDkx6abI6+2Cnjw85rr37KO8NUuvRCqScvjrF9KP7NvogMMVPZnvNa4E0UJvnU7hqjKQHdAXoLl7bStqh24UoTMcy40peQH419fum+SpUxEvfWjMpBDaq+OLFfHOoj9Ag1J96+5waXDMKtoCD4u2XDREf2cqxE2qaTTS2g2wRWvilkuKINv5fRELtlXQ/MtkeRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(366004)(396003)(346002)(451199015)(5660300002)(36756003)(2906002)(66476007)(66556008)(86362001)(316002)(2616005)(478600001)(83380400001)(4326008)(6486002)(38100700002)(1076003)(26005)(41300700001)(8936002)(8676002)(6512007)(6666004)(6506007)(107886003)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DJ3zr7Nxvf+7B6APj+1la1AifmVeKRRUhmhq2w3iuln7UIwfxq1vw3dAUNk2?=
 =?us-ascii?Q?GHfbf5favgNj2AclasUOk4W62O7wvB+dp5HiDVkcqITfgg+T3nVeK8qKlB0r?=
 =?us-ascii?Q?Nv2AMr9T9ip789kURH7fsC2VKUR2x1loHODGjJ0Qe5iTB5wo9WOqWZ2kDHbS?=
 =?us-ascii?Q?FsaWmZYhLN1eb8yKWgJ8KdEcwBz/St4gpx2r63qu017IAWuhV2nzdfUff+Kj?=
 =?us-ascii?Q?nVamuWG+wjnHsjB4oBER3DYWkZuexGK7VKNd2hs/LQT5rTafeg647oYAG2Vf?=
 =?us-ascii?Q?q0AXXl3CIsWc5KebrtEJ4Nca3shb7UAB+vRjD1gk97pfwCAJiSaOx0p4xq6G?=
 =?us-ascii?Q?A3/ggPvdwRzik8aULbAVikY0m/dcqxCvWc5c/jqRDB9qnzPwUBVRvERSk4uv?=
 =?us-ascii?Q?1sPjedyqpwGOQ6el236WZ9CTYmA+EWdkYtD58eDX7veS60xTYkkWOrZ24vpl?=
 =?us-ascii?Q?kXxtHJqPNI2HdhV0KUz6v5t4vKq/RruQOLqwc9xb8rCWi11kjhUhRHGCzn3C?=
 =?us-ascii?Q?BmlwMc8QPuUUYNCOj48XIMA5OsCh2jEB2FZoKyoqjD5i8DjlfibSRF8q+ntl?=
 =?us-ascii?Q?FnyVSQ6Zqv8sPDFSTeAgaOXW9oVA5gt7Ik9VdtnqaDnqgINEev/DPCVC5IB9?=
 =?us-ascii?Q?7CAbLthcYECw9Y79NkBKCRMpx36c8L0BNy0j3O/qv2yOOREJOqSaZHmW2ys5?=
 =?us-ascii?Q?zj5ke76vn0G5+GyQxTRtEXLUS6QCVwK3spLyjpqSUxA7FhDGqdMiGhNT6AP/?=
 =?us-ascii?Q?/NcrC4fpGopip51Qamb498yCPxlzc2A/nBSDhneTwVHX0ypcKaN+am4o8xFO?=
 =?us-ascii?Q?Oh6KKp8NzAfTFXnjhpfKrcF96Hb/2BotSdwqhH8AbcJldiZKDZRtz8MJjC0K?=
 =?us-ascii?Q?YlmOiFVtSoMjDZGMT0T9sxa39xkYQT5dIP3GK8PMLlRQTzksKrofDNrwxfIR?=
 =?us-ascii?Q?+/9u4Bpy0fX8/z0ObtWkbFQMT7IIs65ZUYBe8LSOwsv4Xvar5lEIgiHCYsgf?=
 =?us-ascii?Q?aEOnBFowPQh/UbLCfsQA5KJfossNe6J4fxXjG2z07ZdeQYnd+A/5U6kxPDst?=
 =?us-ascii?Q?6cM9uQChLTq4aP/V8v76wsh5dCJWFp7EF6QCs2rcoBwRg0niZ3Q81Y/aCTsH?=
 =?us-ascii?Q?GxB/JzT6f/uedb92HdcbbxKntr1FIQftWpwZA99s6BbM0/7bUDq6ZKWXaSn7?=
 =?us-ascii?Q?WtdO/u1Blm/NQ9sAY0qWzysdbotYvMBgg4410OTbPGGoD63zT61+1JTXZvK0?=
 =?us-ascii?Q?M45SdH3ZQ4/mP6kviOAeXHC11l60QI+QZg5fGNbJbrzvudGUC2FULRjmOyDw?=
 =?us-ascii?Q?EufzlEMtKnDaJn9pAaNjOALXtI8TK+9BbEmH92OZCSB4Hoztj63CrQxgYtJQ?=
 =?us-ascii?Q?Qc6Yz6Dx9INpjzGKg0YPKAlnSeW9SBYmPRjO4mG73CswZPIfQ0w2J6BtRWvJ?=
 =?us-ascii?Q?tPpFN3QQeHSxYYmaUqJz9jsIZFasVL0YHayge9nGuaxK63GOFb2s+x64p40J?=
 =?us-ascii?Q?CFyAJdjRyebitzd2amIfmTZUkjd8LWoTWzqrOg62kO4yIh80GOKH/491Jffz?=
 =?us-ascii?Q?3/dG+PxVQlDLeAnB9FTLcdadzhtJuJTrbmi5zHmjTYZ8iRA6EHbz4BOlEWHE?=
 =?us-ascii?Q?lQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5649f208-cc91-4942-435d-08dade2df45e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 23:50:18.2465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 65aTcEjWCTfVeamo2tBwgddgkBIPd0G6ASlvODLgEoZpJcWtEt8HqGSOjYzIKhcjGEZpbERx8ER+dW31wMcBV5++ZKzTEK5uYCdeV90kpJc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6800
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140196
X-Proofpoint-ORIG-GUID: l3YLGMcU5Q2BQ1oJz0J0FDnUjimAH_k3
X-Proofpoint-GUID: l3YLGMcU5Q2BQ1oJz0J0FDnUjimAH_k3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Conver zbc to scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd_zbc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 62abebbaf2e7..6b3a02d4406c 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -148,6 +148,9 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	unsigned char cmd[16];
 	unsigned int rep_len;
 	int result;
@@ -160,9 +163,8 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	if (partial)
 		cmd[14] = ZBC_REPORT_ZONE_PARTIAL;
 
-	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-				  buf, buflen, &sshdr,
-				  timeout, SD_MAX_RETRIES, NULL);
+	result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buf, buflen,
+				  timeout, SD_MAX_RETRIES, &exec_args);
 	if (result) {
 		sd_printk(KERN_ERR, sdkp,
 			  "REPORT ZONES start lba %llu failed\n", lba);
-- 
2.25.1

