Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D98C6FD1F
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 22:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbjCIWeW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 17:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbjCIWeF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 17:34:05 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BB5E2503;
        Thu,  9 Mar 2023 14:33:51 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329LwpQb026384;
        Thu, 9 Mar 2023 22:33:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=hfMoiu+lZ0BV8kkTEIEtnhK4hdFmkp5P2iTT08J2NxY=;
 b=mlLgGw6XDkjZDdS4vker+SWIzo6sIaS7j1G/j9gbMz58WNqOerEwu0LDQWM02EUWmqu3
 rrCdOwEitUFDzziEciKSHoisxadB7q6JMlw6Tlw7Zsg5jhD4p/dR5sVWAnbhmEBMgCcv
 e4egJKil4rE54xRro5stvWL3Q/m8Mga6bQ9gjPMwRDO1MGj3/Fjog202SzdqhO2RU+FA
 DdYbWzDiMYJ2RgLHnD3t08KE2/dA9Kvdg1ijbwUbPGvv8dPzoiFsx72VFDS33vMWy1X6
 oQQz17cACPupQTgVW3wRIESaIBQG8LRdvFDBC3ZZ73puiubxlEONtbB1cq74V6rkfDUg oA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p415j43ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:29 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329Kf86I007359;
        Thu, 9 Mar 2023 22:33:29 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g4hw9r6-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KKg2j4ES6x+xzf42xCi3qKUKMyL2GIDeWzk2Y36Rvyn3e6VNt9jZYFuhw/k/OHZOSHWGubLEW82ODJRM1Ly6DOG7dbRzpPg49FnemQEXMxhC+trwjLs48vNbPFgztelngYe/WslOqac6CMBmGeIPtuNvcSDsuF7sOWMKNQrWqggntTvgbaetjZqjtZ5/dcNlThK97IPKIArk0yuCMZULJNS1j3pBilOjmf1krXsc42JvmMiO1YDyZif/5yuAHv75Xd/GcAXcwMB7G7+IVejnfT4wfPvzlnvr/Oq8bsa446mcb9E6rV80+ZcEWWM1OtpgDXrIBwm0KRwniCQvT8pDUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hfMoiu+lZ0BV8kkTEIEtnhK4hdFmkp5P2iTT08J2NxY=;
 b=HeD4M2EC2dt7ZEbYgJXRH4Yq03OC/ior5PmMrZM7S7nm65j0LeIG3jeAxEjpmjJSusPqSbAKH7iDTsrsph9Pko2LaJ3pluM+e6LJRFD1bHctzkoWYdqk6MMW1p6B6MEyk2Md4qy9NPQ/KVBO6HyRt4dm3UDhiJ0hZS9tQ5wfllvavQX/VKXKnD9Dl4ZWfQPtsdhjImd0+O6Immjz0qNeHpbL04tLrJojroze6lVeVvtJt1o+05pi2gxvbGqdh7lHI9uJKhEYWGtiHYDnnEQDV6Dv4w37+OcivIUlGG+fLH7h1L4q3ObyMp5iA32z4E0d3VBIyGS5P7rINPnFzmmH/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfMoiu+lZ0BV8kkTEIEtnhK4hdFmkp5P2iTT08J2NxY=;
 b=Hs6by4XCXTVP5RBJ+csECpX/GJoAePsBZF+OIW4aa3kYgqI8hBxqqfM/XuvVF4f8892ozcgvvTAwLRr2EyZ8Xbk+R9fX6YbaF5NCnOfgJJQYyx4nNADc9a+4hmX2PK41ZPWX6yrEsOOSQTLxW08fLVyBpdVwmmo7Renlk+DPrEw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6479.namprd10.prod.outlook.com (2603:10b6:510:22d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 22:33:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 22:33:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 07/18] scsi: target: Treat CMD_T_FABRIC_STOP like CMD_T_STOP
Date:   Thu,  9 Mar 2023 16:33:01 -0600
Message-Id: <20230309223312.94595-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230309223312.94595-1-michael.christie@oracle.com>
References: <20230309223312.94595-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0037.namprd03.prod.outlook.com
 (2603:10b6:5:100::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: 4540be1c-4cea-4421-46a4-08db20ee4b9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NEF/1AcV8kxBnP7mBYEMrzSDezVGHjhTc7KThaRoB88LlT1TVofKbDwzeIELnhe9ByYiMTbt1m2BcmPQoTssBZre2k7MXvpZrix2e1E5NYb3tBzVTUisKPBEMUGb7mDj4erfotSN/PfHNNXqbLsksroJm9Uy0iOYRRcwyJ4st9CEJOwUfEWQT8eISIi8bXajNtCKJ06fJM8zez5y8WuhzJZFQMCQknemTWL1S0sEGU8i0Aa0/mkie3+4Ob++S20XXaOyNlD6opxNWsqlB55NU+1e0zjM+l3nuPR1ty65M/218MPTJxWwLZDdlAkezhtMj5jL7+kPNSnoQdQLMJ4XY3iZmHiDSLToi8zFghc3BMVTwYeQqxLHJDZqeG9XkfB+iD4N1sJnAvwmZ7m5A1S6TXb/Kwt/O46d0gfGFwo/8v3RFGNrhiBUgddjn/eX1LasKGGmU7yIyUXR83tG3oTVD+0dbazS9d/Loz2oiqU+ze6pKPvCu8m0HGjipcTTe14UD+wLCz2nSiT0BxyJxz7wVgS0NF/dtqmH2yQc3HqqdW6ezkGZQNb7zaQPtlx8nAP+sDzv1lYdF952nEfg1XqiwzYs3D4ov7BAgZWmQjG3i6kDo6lyGaFYCDLf1dheI5dEX4xXzFySR2Adf/APdYNz3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(366004)(396003)(376002)(451199018)(2906002)(5660300002)(36756003)(66476007)(26005)(8936002)(4326008)(66556008)(41300700001)(1076003)(8676002)(316002)(86362001)(478600001)(6486002)(66946007)(6666004)(6512007)(107886003)(6506007)(38100700002)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WQsEP6oWvdbrUMefJRVPTdnPPD/6LpCHiwy8/Ndls9L3geQKE+vIFKsWWhML?=
 =?us-ascii?Q?Or4E4baBS7MJt+XsOpS8YYEnINRPaRdbf8rbJssQ41J6JS2rovfXqc5Ah6IP?=
 =?us-ascii?Q?szubUldm/w9nWOmv4MaBAr2R6qOoaRhb97KdCLJftswN4JTruqeguI8WOhm6?=
 =?us-ascii?Q?0QHQz3bs+4gDx5DYH2Htfntr60twPECgZYPloQkReALXG4Sj//uftH3LaB0K?=
 =?us-ascii?Q?YgpOtUkK99GOzfl15XUnGM/gHwUJPVArcrR3agI01GDBJKJkemdSskQpCIxK?=
 =?us-ascii?Q?j2CIcD1GXYLYQ6K1UrPIfQllP7J/zpu8N7sN658rSCa6tmfeMkXX7dq63J5u?=
 =?us-ascii?Q?kPyFPxcDLrnEFoVqxQ/QFfw6J3/CiYBZngos3SGwfNWaN1mJMAPpN/M/BTZ0?=
 =?us-ascii?Q?CLm2mEh130nR90xIDrSquiTc58TqZ4UvXxirsEFwlVdrknTPRxG6a60R/JBG?=
 =?us-ascii?Q?1pFs5pcHLLDuFGmvPJkMHTTb9lWJbW8E2ruK7snlfKSiKIPEc3GnIyGxrILp?=
 =?us-ascii?Q?L36dJW+6cGSfQBvAOd0gdXZZaGSSesYEBoqWqteITKyKIV66O5xVDmxjl2VO?=
 =?us-ascii?Q?pF29yRabbCeQ8IzRScdEeCgLjXu9OnW4BE4Drv8xIuDloP85KHFl0ojYaBSn?=
 =?us-ascii?Q?eKOQBaJMB2Wj+gej2JKMosxrvTAxLQSdecMX/4IYrbSRg9PJo7b1I5EbDics?=
 =?us-ascii?Q?6zOwmxw63DO/kJywqo8KjRKcQqYqGh9loKVcahVhhgNfMK0himHvM8/LdatO?=
 =?us-ascii?Q?osUk+WoAp36bMQdAQFAKR37XUQw+zEIDlTHdzdSX0aoXsZCg7L/Z3I7IwCX0?=
 =?us-ascii?Q?WflVRb8nnouEobMEa0ZpV2F6Zno6NcZB9DUd2OYOLxMiXz9/EdOl21+nbIpH?=
 =?us-ascii?Q?laddKhmNSJVtzzDwM4BmF9XBtzvtLkYwKzbaYQ9eetGbYXgP75kjCgldk+9R?=
 =?us-ascii?Q?AFXxtHolFpsFm2aNDx2IWoBZHHjvv/tYFEVOGxvsGNVxGjgp6h8wxzrh3seC?=
 =?us-ascii?Q?7v23vBdKnBcdG8MGzVaFfANsBvpEjoEqiSagUR5NukBsDyFmx3fN+5nAg4tr?=
 =?us-ascii?Q?gGFuAXLttQKBtZFsHDfpRippUpEMy6foBZRF88d41isIRx0oYT36+46R4d+s?=
 =?us-ascii?Q?0pCY4KUcU0fmXcjOEzZXzu8z+8C6ysx69bHRwMmFbj+pb/lZxmRAIZRUV0gr?=
 =?us-ascii?Q?P+tnHyYyP/mCstdcF8etwlczIrdkqeBEDioaQLoLjhsgmsjOKFZvD3bEC96e?=
 =?us-ascii?Q?82eDqilR4vFUm96+D3lN+n+3AqXpLQN29BrNlTpNwXEl8qI2RZc/uNNceZ3h?=
 =?us-ascii?Q?N1flzUhYa0ujCJHMliznb5tBSyf7IhMpKGbmobEVnUdQFh/l3A4vfYbYC2Qv?=
 =?us-ascii?Q?g9CO84cHJQi8TnNfWxaCQfZgqvMIWnX5oorG+i5B050hJ+d7uu23I1MoQ1xR?=
 =?us-ascii?Q?yEy+Bw9ewTP68kMe7xsLDkVzPW66kpfg9qTLlNbSs4VE2u4xaHuLcH45tcYz?=
 =?us-ascii?Q?gVp66litG7Ub2ui/XMNIyj8iBovA1KHZsXAXaliOWkDPsmVNX9vOnWQfw9AT?=
 =?us-ascii?Q?7Xc1mFCL67kRciKrhghPLT/lHK3Ih3qp4ApigoXToq5NG7sRoQWCggH8mn6y?=
 =?us-ascii?Q?5g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: X5D8qq6P5IXvRVsWU+5hwG8dQHNxi8gDFQw93vkJAdibFN2zZJ3FgyUNjrzmyogN65bHj79QORjM3TuL/QT7AzmO+rQhsxfgmNPbT5JFR+x3c1c0EwhMmCAlw5tXEX7KPH+ip3rqMVdG0IXD5alylfndncZR2nsXWXyzB5nMBtmUgSU8F22WWZT0DsBiB1Fmxra3nkAVh1cbTm0KhD9sHQrRAZOvoSkURAo9C+ewcZX2Q471sWrGjSLHBThTguqZYTdIjuDmKc2qrAQ3s+aQGkZMz7A/C+LBE5Eo4aoioRfG8T093UzBlA2FABQuSwxAus93QLXEcuESvohNF6mG09E4pH3B4QmaG/zYwFX0XP8ov2Kk09NdoY6EnCVLrdd3BPkRwIGwvCQ+6ebk4wJqDo/0DbzHmjVvdJaWr4OLVonyEao5JHfka6LrJJGGyRuOGU498nzxMFmMCv5ocf82rkKBY5OBy5Gm4/Pjk4OfJvBhbjZNY6+9qgBOPejD+Iq+qIN95b9JDDQvjfZP0N1LXXO6zcbYVJiza57Bt8XTUSxiNs1+PTI82sUpwWmgUHup/VJRfklQhIrs+Er1qwTlRjmkLMphfD3liAN9i4gNMDE78mtfQC5ARXhGthmgv1IHY97r50/acbXvMhjRw7dz4Vd3mdtjGUgGjkpofYJBYfky2OHT4pU4RIiF/oRAPkPNL0ANEPwnjIFGEOUOQMlaiUL87ujX+u/otU1biK25RPCFHYYPZj9MiEvs9GDwZYpLRjmJWEK0f6pGAgVpSsfQEw9QZv7vSIzPZKCvl5+/4gNv9Bha7Eap5ngMVCmZeAfSYGu5mgy5XEsF8hPQyGpWZAUuVPYhSU/dQy5bMaZPvbvjo5KTcDUsyJQ/fnvpg46w
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4540be1c-4cea-4421-46a4-08db20ee4b9d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 22:33:24.7367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: svFhL/qkI2GLZ1HYowGyrX/QtdoYfxhj0gF/UVEEDW75y/odH1vahZALZRfUYVqOqyAXiHchTT5SXPqhiJ5ORpUE5OCLzgUzP99AmxzQr+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6479
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_12,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090180
X-Proofpoint-GUID: 6PVY67tFoYlZF9eoDUcZz-GSQ1iSr1Og
X-Proofpoint-ORIG-GUID: 6PVY67tFoYlZF9eoDUcZz-GSQ1iSr1Og
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iscsit will set CMD_T_FABRIC_STOP on running commands when its transport
connection is down and it can't send/recv IO (tx/rx threads are killed
or the cleanup thread is run from the one thats up). It will then loop
over running commands and wait for LIO core to complete them or clean
them up if they were on an internal queue waiting to be sent or ackd.

Currently, CMD_T_FABRIC_STOP only stops TMRs from operating on the
command but for isert we need to prevent LIO core from calling into
iscsit callouts when the connection is being brought down. If LIO core
queues commands to iscsit and it ends up adding to an internal queue
instead of passing back to the driver then we can end up hanging waiting
on command completion that never occurs because it's stuck on the internal
list (the tx thread is stopped at this time, so it will never loop over
the response list and call into isert). We also want to sync up on a
point where we no longer call into isert so it can cleanup it's structs.

This has LIO core treat CMD_T_FABRIC_STOP like CMD_T_STOP during
command execution and also fixes the locking around the
target_cmd_interrupted calls so fabric modules can make sure cmds are
never marked both CMD_T_COMPLETE and CMD_T_STOP|CMD_T_FABRIC_STOP.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_sbc.c       |  2 +-
 drivers/target/target_core_transport.c | 27 +++++++++++++++-----------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index c1cf37a1b4ce..ff1ae779543f 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -457,7 +457,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 		 * we don't have to perform the write operation.
 		 */
 		WARN_ON(!(cmd->transport_state &
-			(CMD_T_ABORTED | CMD_T_STOP)));
+			(CMD_T_ABORTED | CMD_T_STOP | CMD_T_FABRIC_STOP)));
 		goto out;
 	}
 	/*
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 86adff2a86ed..1c23079a5d7f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -737,8 +737,8 @@ static int transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
 	 * Determine if frontend context caller is requesting the stopping of
 	 * this command for frontend exceptions.
 	 */
-	if (cmd->transport_state & CMD_T_STOP) {
-		pr_debug("%s:%d CMD_T_STOP for ITT: 0x%08llx\n",
+	if (cmd->transport_state & (CMD_T_STOP | CMD_T_FABRIC_STOP)) {
+		pr_debug("%s:%d CMD_T_STOP|CMD_T_FABRIC_STOP for ITT: 0x%08llx\n",
 			__func__, __LINE__, cmd->tag);
 
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
@@ -889,7 +889,7 @@ static bool target_cmd_interrupted(struct se_cmd *cmd)
 		INIT_WORK(&cmd->work, target_abort_work);
 		queue_work(target_completion_wq, &cmd->work);
 		return true;
-	} else if (cmd->transport_state & CMD_T_STOP) {
+	} else if (cmd->transport_state & (CMD_T_STOP | CMD_T_FABRIC_STOP)) {
 		if (cmd->transport_complete_callback)
 			cmd->transport_complete_callback(cmd, false, &post_ret);
 		complete_all(&cmd->t_transport_stop_comp);
@@ -907,13 +907,15 @@ void target_complete_cmd_with_sense(struct se_cmd *cmd, u8 scsi_status,
 	int success, cpu;
 	unsigned long flags;
 
-	if (target_cmd_interrupted(cmd))
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	if (target_cmd_interrupted(cmd)) {
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		return;
+	}
 
 	cmd->scsi_status = scsi_status;
 	cmd->sense_reason = sense_reason;
 
-	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	switch (cmd->scsi_status) {
 	case SAM_STAT_CHECK_CONDITION:
 		if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE)
@@ -2277,10 +2279,12 @@ void target_execute_cmd(struct se_cmd *cmd)
 	 *
 	 * If the received CDB has already been aborted stop processing it here.
 	 */
-	if (target_cmd_interrupted(cmd))
+	spin_lock_irq(&cmd->t_state_lock);
+	if (target_cmd_interrupted(cmd)) {
+		spin_unlock_irq(&cmd->t_state_lock);
 		return;
+	}
 
-	spin_lock_irq(&cmd->t_state_lock);
 	cmd->t_state = TRANSPORT_PROCESSING;
 	cmd->transport_state |= CMD_T_ACTIVE | CMD_T_SENT;
 	spin_unlock_irq(&cmd->t_state_lock);
@@ -2847,9 +2851,9 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 	 * Determine if frontend context caller is requesting the stopping of
 	 * this command for frontend exceptions.
 	 */
-	if (cmd->transport_state & CMD_T_STOP &&
+	if (cmd->transport_state & (CMD_T_STOP | CMD_T_FABRIC_STOP) &&
 	    !cmd->se_tfo->write_pending_must_be_called) {
-		pr_debug("%s:%d CMD_T_STOP for ITT: 0x%08llx\n",
+		pr_debug("%s:%d CMD_T_STOP|CMD_T_FABRIC_STOPfor ITT: 0x%08llx\n",
 			 __func__, __LINE__, cmd->tag);
 
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
@@ -2880,11 +2884,12 @@ static void transport_write_pending_qf(struct se_cmd *cmd)
 	bool stop;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	stop = (cmd->transport_state & (CMD_T_STOP | CMD_T_ABORTED));
+	stop = (cmd->transport_state &
+		(CMD_T_STOP | CMD_T_FABRIC_STOP | CMD_T_ABORTED));
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	if (stop) {
-		pr_debug("%s:%d CMD_T_STOP|CMD_T_ABORTED for ITT: 0x%08llx\n",
+		pr_debug("%s:%d CMD_T_STOP|CMD_T_FABRIC_STOP|CMD_T_ABORTED for ITT: 0x%08llx\n",
 			__func__, __LINE__, cmd->tag);
 		complete_all(&cmd->t_transport_stop_comp);
 		return;
-- 
2.31.1

