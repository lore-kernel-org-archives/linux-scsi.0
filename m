Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D758C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:07:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiJWDH1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiJWDG4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:06:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DD171BCD
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:06:47 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKvuj9001390;
        Sun, 23 Oct 2022 03:04:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Ny4VT0kwLgtNnv1k8vwa3rPPMHTsSpr3Xikt3BRBKkY=;
 b=ZbpKSVL+akpeEkrzsR+Nm8ih8U4b4UKPFCkvmJ2W/Wyp3u+uG9eSc2cdaOlq5xiRoauW
 pIR11y5RTJ/nnYFdn8DIFn67ktjk2BDDUG5o8162RodZwG/2miypI33YtBP5GztZ2OQm
 ZYEfOiVUTo4B8PahJL55DEnD7mb/WB8SZj3W0eLA0TaMAMFgxHM1ER/Hj+G+jN6MDwsA
 0YYaULQx2n5DzlqRmEFP2/3aeABKGKmfN+79ep31RBPqiYGqMIrfwz0oNxivY4mXkS2x
 vV6h8/HZF/n+1FsGOBJjwXuyiRiepY5BTebrYlCoNPKHHkYBdwQ3Og413V1+8e8Xf+es Mw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8db95n6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:39 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKZ43U016751;
        Sun, 23 Oct 2022 03:04:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y90ndk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=THum4IwdCtVOSiGlMIqhGpl5uoLhDXFYRLky+DR95KsNo5yWMg6v+Ef73XAur8a9A++kS46SdDHYpzft3+u7ADg+eaDMtjZRX8DIvHgsrIdY7UrlWWY+yc5fMtcg+sR92pG3aY8hVbMdPJy6QZdsD1ZVtE1tq/Lw6tefY8ZY4vQ+rVuAYeiRu1ZCp8uwcGBxUCJi1jBlofE85BEKIEYZrDdWIzuuNjIoR/1IK1FIbpEd2ZTaS17lXj/4952cPDXwhjBbEnd1CX2g+xvklzi1JIN9GtdFAZnomOFjyZPD2HocIHUyhoHbEAadgcIM6mDeHEVBBy5rNQUhnQNIXeyh1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ny4VT0kwLgtNnv1k8vwa3rPPMHTsSpr3Xikt3BRBKkY=;
 b=avYCRll6t3HvpkqHjorG0/t7NSYiF82F/zo9czQF1XGYHrmz2Ci7CtgUSM5YXyH0qqN5TJQ6aYYrmbUpgt6MmmKo2jQTei9tkF1JMLKYO/DDjEnM2R+jQ+Jomhx0EE5ZDMj4fwfKcn1VIDBuqVoYt5twxSNA5ZqM9Jzqy8GomUH56AQW1wna7N2T2LmdG6H8Xyae3mZyWTe4HUIWsoZFi7ydtfyQjtbM4DJgiJbjxxMtnsJnSiKePtW/1iLtUUzmW6jeLgg6Kz1kvsUpw7y3i9EobmZm0h+0Nvw9FedSqLaooa471NT4w4MiiLyXVjjGAATPtDQYfnTxOk/Zi6S92w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ny4VT0kwLgtNnv1k8vwa3rPPMHTsSpr3Xikt3BRBKkY=;
 b=Qp69dVuCfB0NjwEbpW2zLet2pvjUL8Lcj3UxUxzI8zJoNTAywikL3oHra/9Wwt7AH9qEDrEGol42WjzuN/vu4ZVPsC7WYlusLXyZIvlpRlTVodyqir+ozJIEenomsGX36yAmSXGdDBcWaDsXWOoPEXBuaqrGFA4xGvZXjusn7gA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Sun, 23 Oct 2022 03:04:32 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 17/35] scsi: ufshcd: Convert to scsi_exec_req
Date:   Sat, 22 Oct 2022 22:03:45 -0500
Message-Id: <20221023030403.33845-18-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0009.namprd08.prod.outlook.com
 (2603:10b6:610:5a::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c8fccfb-0db2-46c0-89a2-08dab4a34ee2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DD5EPyip80XqnqWqEW5moMXPr4BxS7K1g/tW9WWkCySVxiDUrqWvOzqYK9bYoPDceDX7rdIk7lU3i/TNVYGq7Keq2Egf4U281nlY8Lr3XMYWO1gYLEX6busjcQjOSVP0FbJ93XBfK3OZBelCCz1qB/6hEOZ8Qm/V3JQpFKVRkCweRM2MTNEDmsgujHDEzCwThnpFPx22pL/AA5dCbQT/k3SgPKYZe2N6DUK/kXtwXVY4F/Xpy8uHbUIJbtMiIcR9wjiS5GeQk7+2mWlOkznbWQklOTK7WgB+p4jpzBjrZn6AgKyJwn5H9GooIfaZr9MNwsjmo+MF5VIoyK2luGpd0APMxPkl9OqgphAa+S2M41Q9wf8b3Qr13dcBR4FJXhi7buu134wD02WvJUauJEUFI6gcZmq1fngKzLaCMgTaVFOVs7a9ccK3goTAJPY7svrBZDFmsP/4bxPwaM02+DhP2tauHYmxfntwD9/VBstRCRzz1vFsfFBVJ2DaYfwAv4YB8OT8+Ip6xjzhl00NwhqQ99tNAnopEZ8+PglAbWj/WL61MAWBmjJwj5k28j4s0p0Rk1rjxKBmLxb2heL9tsSOXL7g4bWLUdXBomtfEHMU/8Is/mtwTui2eH/+OTWXLY2PGXhtB5JrAwJ6sJc2jJn7doBF995A1m0sUabVax1bmu7zR6XafZbPeE+LWYie8dR6Ldo+IihBDiDN9EqkLUdI8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(478600001)(8676002)(4326008)(36756003)(186003)(1076003)(66476007)(66556008)(86362001)(66946007)(38100700002)(41300700001)(6486002)(83380400001)(2906002)(6506007)(26005)(107886003)(2616005)(316002)(6512007)(6666004)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wQak4Swj/rhJUAKELcbj9YITLc36rdrLH05Yg3Cib8pmTbB8o0VHoW/P1vIW?=
 =?us-ascii?Q?QQh3sZF4lHWTZQDfjVlhx615eKbR75YV2EaZuSGyWeTcCwMt/05Zf5m0Tyw3?=
 =?us-ascii?Q?Twd4/8BlvQTKD+puKTOKrwM2nDiss6XH+jMMs7JFp1j3r3ZadxkpqhAVAifo?=
 =?us-ascii?Q?b9MNMY9RgO8kLlab/qpzw74kMeMzpEJzNmqHO9PHcsOiUXfMmTUq07umWKQy?=
 =?us-ascii?Q?b88Lr1SKHxr1WDQA4vqEQoEtOBcFkWwsCRrJPWX7lskqzDm5V7GV7lIB/mBR?=
 =?us-ascii?Q?BHpGAM6DBcxy5Jgi2AwKpcp5dIYgKI2nWVMJCaijhphzKzPnMgoU8PcZY7Y6?=
 =?us-ascii?Q?2VkYxqo0cz4dOft72lYDERytbqqOQxEsEkJ0gwxKs5nljPZhOx6K9ZwVGio/?=
 =?us-ascii?Q?8KCdJTiGwLUsaaAHtMosCCpZCXamADR1yDp+CJRE7s+TNRmKMDs7IJd/gvMO?=
 =?us-ascii?Q?NBSES7zhCnk99mWwycAzHIQSQLUSRzg/IftOqWajNHAWa9JwVZWuDkg/VjiA?=
 =?us-ascii?Q?VkSwc2WmOfMbS5x04DmbUhKNL9IDWk7OjSnXOzFT9RYNaBpesxbmnONCErB+?=
 =?us-ascii?Q?3i/MS4Sz8RTsF5b0sAHW7e+Za0gF21Woej69kAAyJKJaQgx1tsl9EC1XLt4O?=
 =?us-ascii?Q?DxUJgAECqnazx8I4pOmoRyXw+w/21CV607OTeTpWVbBP44DiX8+orD0OQtvW?=
 =?us-ascii?Q?bdZFXsWVzii2DjBlClNcZpJrsi9PDbDIE1+DJbQ6hURf6nUrJwV3if2S26d7?=
 =?us-ascii?Q?EfcZ0aOXD2kxyzw+xS2tuELW6MGsmYTvAugGI5EqLmnQy+ljxVVbPRg9BYsN?=
 =?us-ascii?Q?6fC3YjfeqvBLs4nYzE1SxwbzddAPTon1CX4viUlkncRDyJpVch7DYX06kA+L?=
 =?us-ascii?Q?JykOXNm2r03Xku7BSFL/r3u3HkioiZjfPeUBwkFY+C8FEqVyHvQeWMdY9UaU?=
 =?us-ascii?Q?1GJf/Lar5B23yfORj0XiipdiDJvneikb9jOkSTVGl8RKzeZJRjcP9F+NU3CU?=
 =?us-ascii?Q?ejYN2x6pH+SD9qVC6CrVJwzxih3fwot84bYYCLZPMX5wkRsIOCYV96wDGtn9?=
 =?us-ascii?Q?ayoI38dqDC/m8fRZgGmQCVP3Bzbv8RAZ+rEOJFluKQFTQ0o/PRF0mnJ9beFK?=
 =?us-ascii?Q?eZTXTK7vatawcqphBOZQMxHhy0QV7uz/fOLANEL1ECKFEipI0HvhLuvCQt49?=
 =?us-ascii?Q?FT6YwZSLESl7OWVvjFioP5Rliiqfx/qSZaIU4O9jfIsh31qkrm/U5HCIum2c?=
 =?us-ascii?Q?iQgrbcwHPj5p1r5lSNYIjkJ/Q/PMZtf6OiTxtqXRiZLSb+k6e4GP0si1dIBg?=
 =?us-ascii?Q?lYQ4sq5qUt1xZSLHiiZqTjMrc/IjlodRWX4Doef9sXMp6RUh4/6uImr5ij1A?=
 =?us-ascii?Q?IYyF2XIZ9wBxZl31+aE5/V9FxKUmlxdkwlJjG6Fgz9CbXAvNWat/EYITnkRi?=
 =?us-ascii?Q?I0NdAf0DTwlSTypQFIB06NBBw6/7YLgdjnyl7ll1rxNbkeJm0ID9VEEEjdpQ?=
 =?us-ascii?Q?oWyJ58XjOYVEdWhJIwn3Q/fKQEmjcte1RaEqk/O8DI44RxfU1P9A1ZPQklVj?=
 =?us-ascii?Q?EXmkNGu3wqd6otBsemNE4I6PYfYuwNy7/n3DOU7dhDxVaKTXUt98iSDpLSoe?=
 =?us-ascii?Q?OA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c8fccfb-0db2-46c0-89a2-08dab4a34ee2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:32.3265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n1icPyLrIx3YWxcjD3g5XryTpWLMTk9ov+LUQqSxvlGdjEGK49/s3lH8yatMHskoGjfxqVFb7OtFWUlXa8UZ3Rj1ZfDAXxs8Lfip0hmdknc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210230018
X-Proofpoint-ORIG-GUID: 4Zv0MT5D5NIGHm4Gt85Lj-PitL6gse6K
X-Proofpoint-GUID: 4Zv0MT5D5NIGHm4Gt85Lj-PitL6gse6K
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Acked-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7256e6c43ca6..8ae51ef66b8d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8787,8 +8787,13 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 		remaining = deadline - jiffies;
 		if (remaining <= 0)
 			break;
-		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-				   remaining / HZ, 0, 0, RQF_PM, NULL);
+		ret = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_NONE,
+					.sshdr = &sshdr,
+					.timeout = remaining / HZ,
+					.req_flags = RQF_PM }));
 		if (!scsi_status_is_check_condition(ret) ||
 				!scsi_sense_valid(&sshdr) ||
 				sshdr.sense_key != UNIT_ATTENTION)
-- 
2.25.1

