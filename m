Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5250C74A44
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 22:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbjCIWdp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 17:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbjCIWdj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 17:33:39 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EAC9D1AC8;
        Thu,  9 Mar 2023 14:33:38 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329Lx1Dp003653;
        Thu, 9 Mar 2023 22:33:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=YuHy7KwdY7sUY8P65m7iELRED/67+tmk9KbqQ/9mSk4=;
 b=PEeyHHtMg4AKM53nXoQIrNKaCPOwd+eeHXUoKXFwY3vRH5XvfToxuklbXxraiRR63wvp
 VaTaCgxgTC/nOZW375ApzZHxDQCglTWJU+kwJQLXfSDEKNJ9IedqAgsViLXq+bVd8mF2
 KQ4kiSvpVMTcsITPmgqbZhk6uh2+p7PxVy3yCM5UxfHPzpDaxgeBa1IbnjYMdrk1do3P
 jUcTVFvoZK5sxO4wN/tR/vXqEfFGOe6Yagar5mW3zLcvx2mzxcHliqKizdZNJzYNkLJm
 A0UNMeWuuIvLUMvXsofHuy26hw7EZ14RNVU89MwxR8B0pLMWsPT5YDX3IS/t1pzuBzsg tw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p416wv203-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:29 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329Kf86H007359;
        Thu, 9 Mar 2023 22:33:28 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g4hw9r6-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A6OVuBNYDYn9SGodCxSW8m+PbAnLc01pqpmi5Q1OQZFnjUVkEFS49HXj4SjGyrNK2IANWtxDRuuPUs8eHI1oF9UmeMPa7da42mx0BqSv6Q189ndQdJnWU2T1IGmKX59BRrLc8aetkeoqU9MuY4Zp+Blh0m6T9TBvFlsIS99dMeU75HuSsXBd4ivt0Ac2IcRoOFlrj9pkN9cBsqvmVHKGo+QBbpAjP9+Rx0+w5x7ZM6jBDb8jkbwomMZXUV1O6HtXhj1uEKCBDULz3+2FWiJu1FQF5QIzYpzyyElN82I85HyLn+bxDJFP0YZlJCZF0A3Yfzn+gEj0hJtQQPhpfS95FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YuHy7KwdY7sUY8P65m7iELRED/67+tmk9KbqQ/9mSk4=;
 b=ZtLG38sy3WWNk+xDQS72hcLTa3aJeHyeVyppH0ylTUaUMSTg/ILFBp377VmMruELk7ZnQ9yaHZKj0O4zLxkXKIWoW6JaNKGcFYWFAp5uSCQGwm7pCNYmYFiRqPnenpKz9awRTFvlM4BVxU5YJUXXTnO2eQm4fLDpMXH102ixz/3f9g8O9zHK+rZFaaGJ5i93HzJfCI26VjsoZU4mQas+/Zt09gQT+KYmsVxAxY4tA9ldij5OpD0iByyPGI4FUZfNoXuNZb35U5lbWNGsIrldWV7+clGUexgpiLfyIN28Ot/ImuHyKJFyScbtmY6su2vU6n109BHfXLxT3eJ1Zlg+6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YuHy7KwdY7sUY8P65m7iELRED/67+tmk9KbqQ/9mSk4=;
 b=IRXy5U/4zbnhCXdadgPqA3bVIjsG4hzV4FiVonmXnDE9xeIljG/QWQXuXIvVny1TEnFMB6F58UhlkVekUueGfQfgMqeUddeZHFvxsilZjy9MFtHODVgpW4FMpP2Ro0p2ymyNTLVVfEI3dx3W47JFE2jf23PiI8D5CS3FofujGnc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6479.namprd10.prod.outlook.com (2603:10b6:510:22d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 22:33:23 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 22:33:23 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 06/18] scsi: target: Drop t_state_lock use in compare_and_write_post
Date:   Thu,  9 Mar 2023 16:33:00 -0600
Message-Id: <20230309223312.94595-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230309223312.94595-1-michael.christie@oracle.com>
References: <20230309223312.94595-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR21CA0005.namprd21.prod.outlook.com
 (2603:10b6:5:174::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: 77869d30-ae08-4214-3e95-08db20ee4aef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aOpKWlAot3WgvYpvN65FnqZaeI2NZ4m5TFm4fWzqiqjdVzxYznouMNRVfo3a7TZc0gDKErewOFPzIQtF+HGvO0+D8b3TZg4IwQnvUP11bYuafs/mDwX0gNka9XKn2zWtQvSM2ZqOjG+k7fTV2FuYHEgd1HMRG/u9+ymG33T88qUQ2hFpeNYuzbzqMjbn9iOANRerq0H5fdICbTfWki0zr7veIPYMz1YEkmfgSeE1WtVegOiFdUPxhvswL01FsJ/O4MdDmn46+M2DnXPsgcS1wBGi9l2zPGZmok87nbYm4X8t5f0I0ovCP7hNJ2Tk8D/QIeb8JJ+8e47DFSPAAFUY2J96RqYSoUiZ2Lf5QXir6/7FxoanuzmwzwDdLeAaGyD8B6Wxj7VqX+uQOU1dRYs1QOD7n+2Gka2cc58Hzg1lNzySY+qqPAeJEhsyi9lFs2Y1+L5dF8EZRlJ3YEGAmNKOEduBM/kiEb9E1iuUk0noUv0fyAea+gLM74opNnn/qV2pmvsV7ypURPCYUhBxOM6S2wZJPT12f0IYX29UjonZ7JpVfXaajfVapasPUCWoP9DZAaBrEPHkrb44I2+Ag1QQzdOyqlhMBPBBX4mLJ0SzNpj0tUn3BK3CabHmilkG1XoeIiwKZjYSt7DeREBtK3JOhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(366004)(396003)(376002)(451199018)(2906002)(5660300002)(36756003)(66476007)(26005)(8936002)(4326008)(66556008)(41300700001)(1076003)(8676002)(316002)(86362001)(478600001)(6486002)(66946007)(6666004)(6512007)(107886003)(6506007)(38100700002)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qXJiLM0UTB1PbBnx/5ZGvRI6Fi/WSwaEPT5tJkORVtrKQh5X4Psc6QdbFg+2?=
 =?us-ascii?Q?OTbeYUqOejvBCJpECiwaL9X+j0B3vXZ3uYJnQBxGkdCRLpsagGc+3zUxXQuV?=
 =?us-ascii?Q?sdI7NEYADEKiVX6DLgyEKhPFCbh9+XMjL0Zyzg+SoUzLLzsfYCZNy2BSiFtP?=
 =?us-ascii?Q?xdreEBU/FZU3hnTTx7qlGtnnzfFSbqp3AfbU926+dDTxA5b0+A8zaQfP4EuS?=
 =?us-ascii?Q?WL3l4ShloD/9MEh2qMzSTYz/R5T7t31kVRKfhZtfaiYRIT2sEMDI3w2gTbop?=
 =?us-ascii?Q?5WQ/Q1wkQVikG3YVatg0yCizVlqvY5PoewfNRy80VoT/Gz4d75mJ0eUy524U?=
 =?us-ascii?Q?0Mcvz991llt1jVwKfzvWVROuOhdlr1qBx5bMYKpT9WPyCh45whar6fyStbPf?=
 =?us-ascii?Q?HGgvxNW8DCWV9llkDbaskx2LaFDUXFZKSgGNjtfzJA5IC5hVwFqnA9Kzm4YC?=
 =?us-ascii?Q?X0vXn9HxIy3fB02J6OOwFXOLURUNpu2tCYjdIDe86v81renYtIBbzmTWS1kZ?=
 =?us-ascii?Q?B2cOY9EmxoJgRc8nOgVukUReH+YjqyIOgSZBYwu2N5bBCNTbBgIW2zSiVU6m?=
 =?us-ascii?Q?b2m+lHFv1GL33ja81AMFKX/4aSbv1iYyZB5n0VEuUHRghD9ntll53+BpqtFG?=
 =?us-ascii?Q?qs5L6Es8wW0Bax08B/7ayVPBYNKpsabcpwZW8N+vThJpMAGQP/D6CnzY3KmK?=
 =?us-ascii?Q?mMW//vjMkCP96+n6P1gwiyklrVQqOiBr88XyffnMkyJJGZ3BJ5GVZLs9ZWFI?=
 =?us-ascii?Q?Hk735rWWmhKCmKCb4wTAuWZ2jMyt3Cju+Mq6LPB/sfpx9gcXJqyU5owbhDf1?=
 =?us-ascii?Q?zXC/E85tjswQlmMZNIbJh421nHHoFzpkBhAzENIuTEbH7vP2l7LbvT0hqJ1b?=
 =?us-ascii?Q?9gFNjrOsenNdoMIGk3hJ+tVZBPCfd+m/0E1N60smozhF7gNNTonEoojFzcep?=
 =?us-ascii?Q?Qn+W4hknidwcY6PGLqeKyPeQsNY2X0Du+JqS5BEzPXHhAPIxEDolR9jer/gC?=
 =?us-ascii?Q?D/lCCOHs0qWaiWuyI4upBYFB4eHMWcj7PcKCieM32fFZJyuXLdGpx/GB9tqt?=
 =?us-ascii?Q?NWvZj7mWnOf2TQSBkBSluxrCkeeoUaT5FIuJ4czYfmsjFlqZKWvxm1vzHx6h?=
 =?us-ascii?Q?Bi/Z2YOUTMjAUzSJrl9/UkJJEG06Gdb1j558QXTCv1LsEq6FOx58OUnpiKSA?=
 =?us-ascii?Q?rzOvR8damxshWlHpV68R4w6PO3enHjIeLIE2ORVJ3Gs2CbRdLDH+puyjow7v?=
 =?us-ascii?Q?3eGQmk+iH2FdeNL9Uk7RX5abML5jg+rs6e/HnAicC6IgRwOyYfFG/cPAkFqZ?=
 =?us-ascii?Q?ybVC/WsjjGcJfvnQqIplPHf384UrdGj6KA2mfqGPC6HbcBNhJ/0DkIMCC0Ug?=
 =?us-ascii?Q?Q2K/EY6BjUTjEwuPmrzqTT9SeysISjam766uNH7C0ouENPRQVjL9+K9kAzoU?=
 =?us-ascii?Q?KbcAohx0t2DQlUxRyTJzfFX4cSVJfJtPJrsGHx61D/9rsn6B47QCUtjmhQ1V?=
 =?us-ascii?Q?+nLD3ha2+/axaNskK4J/afETBwN8ndoxBHe8jfSbXSg8LvvK9qxKcLfm4K51?=
 =?us-ascii?Q?Svrr/yzrV6B4V45PQUpViSGjtQ13Yc0K3QvLbValr7TY0ilRexzHPYlsJNOJ?=
 =?us-ascii?Q?KQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rS3u7MUNVV5qDt6UP8WBcxlqwcSClKeat5OGUT+gEOxNEU3UlcKDrAbiyY/fYnls6018t7zfGMUSrPL17OP48tHro3ZhyCtVuyAJ+nYArsaSqF2zEsp9z7IRMbJIdcEhiFU5ldUJSzOHPBBWMyf+wCR3ApLz9pUmoGrsJOHfKPhJN54JKXaRaP/5VcgsCcAYJ+1OkK1W4up2MsmQ4XmfkWZHSETWbo5DRALcE5XuSyW/4cM/g5zIPykNgPxMhgzz2TyA7rmC/LEI2XCy9dEDdFRyAwnoMGkVDIh+Y01xcRT/lGgdhVfwcdhKGJPMu28LCaEiaA427oesOUnCdiC1NpyP1FsDQlptS8I3dKULLyLIIzXiy00/wFpmXt/cClAlMbz0b7CTYQeZRi6orlwTyXsjm7c7TdDL/fLrxfPX9qgbLrYnyByxzemzIuJRHdRyw1Kgkv7cLOgjCS5qw8n7Bbu8b0FvGdoIpbw8HKdyQ3mOR2n+B8ab6wi6CA1nrKnoBkx6dj9J1V/3y/mYUbtyeBDD+bdV1O31MzPz/AAtvrRXf0pbXzoajNyu31vtdfJ+huHhPYvHxxQnKRweXNLIYJrXfVpTVPZOxe8QteX3LT6xck9ibwkcHn9kZSvEl2PnwOeVROFqY0Z6hegKs/XU6EMQOveYAWfDC48n39ho+eBCbJ1C3jLkxEDAafNrGaxaCbukeUMOTCVhR8bS0l49oyhbOj5v+DWBNlUeNQpR0rZwQXg7mX8qwAMPV9s9jmWMqFMtgT+32fCrNztbcxLMRou167WZgTfTWbBkWD5gxpCY8XGxfVWvGfuwerhJvCP1fqkFRqVffvyfQWJe1rcUlK3xDaP+ZZoU72i0ptOVcw/pdKc3TThpI4Ru0GctCG6q
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77869d30-ae08-4214-3e95-08db20ee4aef
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 22:33:23.5805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AzQntKeP1nSNYL0wuTUD1vtJy33Ho5AMWImyjHt5Gjgu2Qi8BXsvLXCgnRzkJOcylmMnu/yY9Ytplu9KDxXdNuTBdc+BREx8an3sRyOJtLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6479
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_12,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090180
X-Proofpoint-GUID: Jn1fx70ntKaSa-0FYWA6s2TlKrAbMDjT
X-Proofpoint-ORIG-GUID: Jn1fx70ntKaSa-0FYWA6s2TlKrAbMDjT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We don't need the t_state_lock lock in compare_and_write_post while
checking the scsi_status because we have just set it before calling
the callback and there is no chance for races with other accesses.

This patch removes it so in the next patch we can hold the lock when
calling the callbacks.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_sbc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 7536ca797606..c1cf37a1b4ce 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -352,14 +352,12 @@ static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success,
 	struct se_device *dev = cmd->se_dev;
 	sense_reason_t ret = TCM_NO_SENSE;
 
-	spin_lock_irq(&cmd->t_state_lock);
 	if (success) {
 		*post_ret = 1;
 
 		if (cmd->scsi_status == SAM_STAT_CHECK_CONDITION)
 			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
-	spin_unlock_irq(&cmd->t_state_lock);
 
 	/*
 	 * Unlock ->caw_sem originally obtained during sbc_compare_and_write()
-- 
2.31.1

