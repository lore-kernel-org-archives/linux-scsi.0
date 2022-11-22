Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB986C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 03:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbiKVDpN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 22:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbiKVDo5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 22:44:57 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9DE229379
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 19:44:55 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM3ibSQ003442;
        Tue, 22 Nov 2022 03:44:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=324ORTN/8GrOjvXpqveCu0OkztnWCzd3KlMAkt/HlBw=;
 b=bWVNW2zGdAAtPhR4bc+JzHrHEjkHReDPFmrLr56bFaL+eLV1IXUwhTtqHtXyawRwrxMI
 eyuVNC+8fiLElQcErvq3hitEoCJp9HcnceKn6AXvfyLijNiKMEMH8GGOCk7QxMvDm/o3
 BKLsa+YYNnj3Utxd5aERuBXHsOjrjZ26EN04o5+1QqLBPmnr5z6nBcSdV25yMqgWOQhw
 LCuZm1umpMR3Gi0EmHoduy89e7esEipcLERnkuuzXuuXErxJI+x6rxi0+beiQdAQ49s+
 svWwq3T0FLYsbhd1uIEPFDs4hvlHu+3EJnP6GJCQTYfnhqQkgAHzJxIQxa8h97eiZoLz aQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0pf2r1e6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:44:44 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM3ZkVC039550;
        Tue, 22 Nov 2022 03:40:32 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkb0yd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ThWMM2Zw94oDlPpAVnNqSbC2NrOzPiFnZjYf1iMK2LR3DQ98eu82quoUDUGmfJSrWxMXlLRehlKTkNwLsqnFhOXrtDpspzOzZ02kckxScRqpUk0fVaODZsEjgi9H/cg+uNdrOkMJrgb2OXclbdzmOu+ODwlCiWc3gyDmlEsSKFKFCad+/wQLFB3K0Mk4LQULNe5H9LH8hPoqMS0R2hE1Iuujx3VUqsCTDQdy0oYSbBCzs0JRbNSezzx5NrrGmYIbKq2CE2Fe+jyd7glCkTIPqNPtQYvGjpzteqr/W00wGlrD1FE//8x+WgQ+DMqnRcBVtOV2pzKMcuyuFUsZ8G4BEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=324ORTN/8GrOjvXpqveCu0OkztnWCzd3KlMAkt/HlBw=;
 b=XpfCIoA+Ir0lMzwcIFRmce8plZPhoars5S0YlIM/DHmipAVf1x87gMf46EFk/ykWeIzMgqeJFB8ha81QfDNqnhYPgMsTBBzN9d20WlxUS26ZZx+Ww9kTcruLPyP32QQN4E8oprzDjBIsofLKd/o+wNMIKa+J5h/C7gReAwR81OTFmlKAynXhmypYq3OVFYp6FpbP7JSKlkaKM4UK1Dvi4uYmnrwmVvGjs3apJZvvTrZvx+U5UVONbhi+mVgd0fGzGSSrThwPZb1ck88bQu1vtlN1OaUAQmCswxhONZy37yxodR8KAiG2IxX1wUn+OULHF0KE59u0oQu5KgFYhBn/qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=324ORTN/8GrOjvXpqveCu0OkztnWCzd3KlMAkt/HlBw=;
 b=ISdmzqk/i69DF0y+m4iyoYUrnWTXW1OlS4AUoaGH56AtJg7lZRHEHbc4VRElrqW2OLwW0D18ew9PD6Z4hKSa7yiIZSEanKCEq7pdIrDUTT27gqmP3CLMPYphvFlktLEsvTlc7FgsfoSYP8uCzcwRs3WWrVbeBo60/ACcdH7xZGc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4472.namprd10.prod.outlook.com (2603:10b6:510:30::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 03:40:30 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 03:40:28 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 02/15] scsi: libata: Convert to scsi_execute_cmd
Date:   Mon, 21 Nov 2022 21:39:21 -0600
Message-Id: <20221122033934.33797-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221122033934.33797-1-michael.christie@oracle.com>
References: <20221122033934.33797-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0108.namprd04.prod.outlook.com
 (2603:10b6:610:75::23) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4472:EE_
X-MS-Office365-Filtering-Correlation-Id: 767b97cd-88d9-4c27-914d-08dacc3b4c8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bKAQMNIR9oPCQcjTUPFIBIOY9Gw37P/WNg5aXss1fPkY45xahigqADI7OaCO49Z7He3Iw7ggRFSSQ3eGnbNLeKe1CNS3fgPYdevvvrpsEiEdrEmIyXY6nCWgxr4eC0UFzQu0Zi5VFgBPZMNf4TRXhZ4HxOXPNaONOgf4B9TDZwhmDoomwhwwzGTr8aAWB3rcoOYjE3XAdZKT6NMFqD/TzZZdPJBlvPZvvKvzqpEH5LZBRGFPHgXKTnpLo49uaIsvJZbF9xCGbaR+Ex7FnF91fP0hVLNp42CnWbzSk+p++SUnDihQfUd7dtPC9JR82wG77aMO5UvEnLxbSIkfEfSgoKS+J4qBwN5aNTwwjPHA/Daym0r5s3dg8HUCGo3paDOl464Mg3DhtnvIGStCR6WnMWo0Ir1nqZzM4Dj4Q4GbtqKkk5UNgbn5dQYBAGnuCRA9K4lIF91vmR1gXh4F65WXs01A7Dmvonh2cwuIFuGvqUVvppFNy6WQYV/kElCf7x49s+NCMYn83+1KnhKKLQK7fZzsK9pSr1lF4hBRZ0N2PVfrex4iNEfgB4VC19MnB5E5R74EmFzTGzIxeqXSsJkkbarxt2nMaWJZtMVxvJxRK2GeSH7zigaPx/VJ9FhqC58nHMPPEaknP8BXkIV7vRGIxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199015)(36756003)(38100700002)(41300700001)(2906002)(83380400001)(86362001)(66476007)(6486002)(66556008)(8676002)(316002)(66946007)(4326008)(6512007)(186003)(26005)(1076003)(8936002)(478600001)(5660300002)(2616005)(6506007)(107886003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w9PrS8jlTO1FGVTCcW5DX65/qLHlrCuu2LHiM//kBGfu9H3oIKqq6dy/BQCR?=
 =?us-ascii?Q?sFsexoxoFZJTsvfU/OmPm87+En0CSommG7zc6E70oZpC/u5u6vdUurJxxoW4?=
 =?us-ascii?Q?Tj1LUtIMGib1flv1xb5epuQhlzIbarDHS0wOORh/EEBZa3sC/P4rPqaEQGDo?=
 =?us-ascii?Q?+1JQFxuLJoo3NXd7JSSd9VF7DUt2kT4HMTkHN+wjt66US5nThVF0hJl2NbN8?=
 =?us-ascii?Q?9oNJN7fB+PSvyUfKTzxHFeL/1GXzsMUuUtFCedhQnNKS5YlFem/++CxRPEy3?=
 =?us-ascii?Q?NKIjy7qmf8URoHW/Hv5YLYP/tRB98bcGTBY+jCwk4vks/CFfudn7pGBX6GhZ?=
 =?us-ascii?Q?c2Kz1x5Dgu+2vJxe4uDuSsTni0i/9EviAX++kwSTCd5QCuwiAmJiFD9+5x7d?=
 =?us-ascii?Q?y0WSwo+2Bx/20P5lf/eKJW0umnU1kA+SHCvNKC7Fgh4NY03mL1SjbDaqYfsp?=
 =?us-ascii?Q?1QqvuJ+tqBHDfvEMdR+TY7ZCRwJwwp3CzkYzHgHBhRVE+oxTBmzrVD8lhut+?=
 =?us-ascii?Q?YLXNIETWRFke9+lB+S0skmvdM2Wm8CTKgv3Vhv7k+r4z1jYJQrpVCmM5R3x3?=
 =?us-ascii?Q?WOmswNcStghrPIQGb0iZr2lbkmpfeZ8XaVxONqOgbInPfK8mRoojF/SSx8om?=
 =?us-ascii?Q?k4OxUVrehDiSNeJwb/fdiaQIK5kKiOdRIqSxPUHBM/DcqlI1y/kXDvZleE4N?=
 =?us-ascii?Q?bZnqav/1j2M0iagsvFddUWkw2VIWCX7ncOeBtR32AsfqixO4BUCejIpsYz8Q?=
 =?us-ascii?Q?mUBuEMmhVX13LB8yptOWqaMY1VYE9lcPLVmN37yhm8AakPmSTz4nj5/0PXdi?=
 =?us-ascii?Q?LNPK3UmNRIa3tTvmE+UznP5UJDB7OmoURKgi+yTuKIQOkiwKnY/CXQIkhltt?=
 =?us-ascii?Q?0G6vOlWfaMrYLRZOFOzW6lbRisLc9KMFI4rlRmczcNWRzOS5oW9MnrcU8dnX?=
 =?us-ascii?Q?rUVdeqVLP1anQnCltELlab3SqVXgVXlLIdI2fYVIXHj0cAPXHVfG3VTKUept?=
 =?us-ascii?Q?9UIisqr2He70Amg0xMroOFo+1B3wZBHra48tNbjWUPjvs2dSX6Z/305BYe43?=
 =?us-ascii?Q?SaAnLXPj09kdLpPAZ5AVv67VdZpGWVmkr9Ihb+Or1dvs7DKF0lpOQOyG+IwU?=
 =?us-ascii?Q?hS3lH1A5SSnn6GD4Hon4nMTU8YEVyVJG7ohd4ak+Etaug6jCrfkUdotO5Ms+?=
 =?us-ascii?Q?oKWQXoejRiCyx/MU1UYURZ399nat7BXlPIsOxFHnlIaiFXbe5yhFAHeyepIP?=
 =?us-ascii?Q?TZqHMrlmEMhO/QM67WXmGUpcg3dUBf0jwf1FnCU6tKkT511Y7LmhnnKjXmTf?=
 =?us-ascii?Q?DZQ57dw7JZ5Z640cH7asaAKV+KVg7pGPq3rruR/Solc9RIaILOTGskETCN60?=
 =?us-ascii?Q?h2tAVCK+z/kVI/WeHH36SsXm8/hNZvOQCVDwkkm1LWx+1nZMliS+37IVyFk+?=
 =?us-ascii?Q?cE8t4phk3OamoI0uH4LG06rUYv5uzgejMnm/OatkPrN0/xaQ/itR2ANhwFKh?=
 =?us-ascii?Q?dkX5g8N+QRYOiOhApWnSGh/356nNqcK51tGv+QgANNNUoOMP+OUrKAaj3t7p?=
 =?us-ascii?Q?u6lRZGvGcGOGWBnSgbKeQjCNPy86HllKUSf2MkQJ1EZfktdQiIPf1tPqsa/3?=
 =?us-ascii?Q?OA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: TXVB/2xV0BsBp74aRK4iEmlWWAcAymJmkae8ygPq6JSg+cldykLhsbY0Fpos73xe/YK5Y4AUEZ0lGMLBRWYBbC0jtprCizE1cSiirWi7h/KXjb8p7e+zES9x+qB2dkJTDm3F6FaoMV5m0oLDIVKtKR/EZHW6EkLbuZD1f9PiiDd/ja8IdPB8euSzdjJCjFh8CLdE72DTQdDz8ePWpeWQKWCxnAreePMO/WBEwe4h7nW5DI4tQsk6CC/8DXrSXr/12Ry/O/UkIADJIBDmryp9GUOvT8VPtwlZQx27zUBseqZBcXe8XCnFXScBNcx+Ptj9SKizeTWEvdhDCXSsJ3a+K5ttVQy7kqoIBoJHP5/CuQnu9pR45RNXX69wjSMPZl40WjfQzGjAToT8rR0EJ4k433SslTJCArooTeYspuiPgsDpEek76ZyYcjLT+hqRNkuttZCV/z9tnOV/gpRsaZc8nOD1NYrY7yRLa9xy9vHQDT8tY7m9n5wamAjtejTcdQUZidsE/LKy3Gl6Zjlil/7rw6nMPk3zv3DgCVPTILcVgS84hkx52IS7S5rCLwXtyI+sBAWuuQJ1nB3Jkmys3tczwl2uLO5pl5MwLikyTGDtnWjwHitEhrNmj5c+tHrf8AOeXdRlLb/ejjJa3lT8/xRq5w47BhQhAHoRZyspksVh5pm55FJAiEsDaKYsNP1pu6Jv4kn8x8ly6J2qDbMzCW+KT8SZe+M9q2JqAIbInHZzZlpLD56DkcZaGlAl6aKBjN5FsNMj7rgsjPbnrOm22yT9xaC4TcFY15BQaNuTu+LPPHj3YFr1BgHUjisWaBJyeeq/OVYi0EUrLNXWaxJonzzY5M6D63t3VOUnobgpzoeSHHMknZ9ubGD2HVInNLBSp77D
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 767b97cd-88d9-4c27-914d-08dacc3b4c8c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 03:40:28.6701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: phJwKtJLX9nfI7EGt0FxgJVvp+yCMlvuUOQ5F0vwhfJZ3BNk2sQ6b9ch9sjnvm79odpN+IefCqgXe7Sv0Bmg43P/+bBQx++VpWEDMZ1qezI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4472
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211220024
X-Proofpoint-ORIG-GUID: FH7bp6yHj5H10Irp4v5KZC3_4361h9ag
X-Proofpoint-GUID: FH7bp6yHj5H10Irp4v5KZC3_4361h9ag
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert libata to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/ata/libata-scsi.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 06a3d95ed8f9..b4f3a2ce9d0f 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -367,7 +367,6 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 	u8 scsi_cmd[MAX_COMMAND_SIZE];
 	u8 args[4], *argbuf = NULL;
 	int argsize = 0;
-	enum dma_data_direction data_dir;
 	struct scsi_sense_hdr sshdr;
 	int cmd_result;
 
@@ -391,11 +390,9 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 		scsi_cmd[1]  = (4 << 1); /* PIO Data-in */
 		scsi_cmd[2]  = 0x0e;     /* no off.line or cc, read from dev,
 					    block count in sector count field */
-		data_dir = DMA_FROM_DEVICE;
 	} else {
 		scsi_cmd[1]  = (3 << 1); /* Non-data */
 		scsi_cmd[2]  = 0x20;     /* cc but no off.line or data xfer */
-		data_dir = DMA_NONE;
 	}
 
 	scsi_cmd[0] = ATA_16;
@@ -413,9 +410,12 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	cmd_result = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
-				  sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
-
+	cmd_result = scsi_execute_cmd(scsidev, scsi_cmd, REQ_OP_DRV_IN,
+				      argbuf, argsize, 10 * HZ, 5,
+				      ((struct scsi_exec_args) {
+					.sense = sensebuf,
+					.sense_len = sizeof(sensebuf),
+					.sshdr = &sshdr, }));
 	if (cmd_result < 0) {
 		rc = cmd_result;
 		goto error;
@@ -497,9 +497,12 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	cmd_result = scsi_execute(scsidev, scsi_cmd, DMA_NONE, NULL, 0,
-				sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
-
+	cmd_result = scsi_execute_cmd(scsidev, scsi_cmd, REQ_OP_DRV_IN,
+				      NULL, 0, 10 * HZ, 5,
+				      ((struct scsi_exec_args) {
+					.sense = sensebuf,
+					.sense_len = sizeof(sensebuf),
+					.sshdr = &sshdr }));
 	if (cmd_result < 0) {
 		rc = cmd_result;
 		goto error;
-- 
2.25.1

