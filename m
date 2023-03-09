Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8607FC6FD1F
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 22:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjCIWeS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 17:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbjCIWd6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 17:33:58 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83DFE9CCE;
        Thu,  9 Mar 2023 14:33:47 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329Lwt6i018084;
        Thu, 9 Mar 2023 22:33:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=IgzHmvphR39o3PjSXKQRjVIpDY4S0MEkoRf/Ej+4fuY=;
 b=rPFF2B+mZfi65AqF18HH+dS7+oGcWdvS8ZJiMWy1ZLQaw3DdPiFN9rX0iYDsppcDRfjQ
 2xWKSnEJJkARNj18mgBGP1Ks1/ZZX1KrG49BhFOuZclwETQoToBU/fLeTlLt7EFO9HTv
 9hDrKYQ5DbyOOvyBa8SKavxZQV021tgTDy2zwA513ftwX3YE8tNxl7FU615H8hfOk6o4
 wa/9ECmlXZURmnulllscSi8GaDjKidWL6AWdhNxUfcbloJBT0Lt0wJtVU8g45abrgY8i
 SF/7HfOSPOwgAUre+3xnw2twQ3O4dkn770vL/Vj6U2K43JSXqeKyMPs0RJ0e1t3BRMk3 yg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4168v15b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:26 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329Kf86B007359;
        Thu, 9 Mar 2023 22:33:26 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g4hw9r6-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPAygN2M7QVW1tUPUwJq8MbgMgYC8OCayVrrbsg02flWRXrLyFPtyW9+z/8w3pB7EYFpsfFp/WBu1kzBIt/FmU0xhtiNjrm3/Mbr4FnLDb92PovsjAi7hps9UgAnEjSfxLajSpFEP6BEOWR4ybb7H94nCvzQ7W+0/sukLzHMWm1zmiFZGohGDE789AF8t80k7+rvYO+VCF/s+Yl6wXl0uYaF8ODwpHQl3tKIgT5TtjzbQW3cynTLI/tkqHRGJ1/vCX7LANboI9aHJc22Oqvv2QoJ0ZoTW50wTgqqon4TGMpGxOgw74aakBrZipsK8T6RSeUIOfgQpFDoPR3vNtu7wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IgzHmvphR39o3PjSXKQRjVIpDY4S0MEkoRf/Ej+4fuY=;
 b=j86C00Bf+Rm+5Z42Rct5PqPQD4ccmTb+VC6W3aFDtzpRpRKjyXkQl+irL6s/znBggKK9qtFSh06yTJqsuRQL45s5Pv2BMHOdDiP86Vu+B/Mcs2Fjqc8X779SddSLshVj2Vb+WEVT+ze/80Qjh4NMjFuhvmAZa4y0DTIjB9Hc/rU49R3v0TyuKQyS3hIy9TTZkkARrDDz9OqXNJ6a71hadafRL0KGKETsNcxqdue+BOnYDh+AqweRw4e+pTj3iBzdhpFMqRHyFQ7sf01oX/0iViiQr++rPPk9a1t6K1OSn7IWJvXhhbP2MmUQPoyAcaP40GbnlxtPuOSoUDmXBJ02eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IgzHmvphR39o3PjSXKQRjVIpDY4S0MEkoRf/Ej+4fuY=;
 b=tlpadhiUIaqsl5es672fYMfXR8jfaMV5fADeHLiMnMHPG9XzywrKAPyAafu9/hjfx9QPP0ug5HOwGZR/YcQm50HXjHL2pQ349OEjHcwIwoUADQybMDqbsGyOOBqsbIF5Yq2f15Eq5s7zyKwJOjXkwdJvE2nV6DHOkPnLGCXAdbc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6479.namprd10.prod.outlook.com (2603:10b6:510:22d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 22:33:18 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 22:33:17 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 02/18] scsi: target: Move cmd counter allocation
Date:   Thu,  9 Mar 2023 16:32:56 -0600
Message-Id: <20230309223312.94595-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230309223312.94595-1-michael.christie@oracle.com>
References: <20230309223312.94595-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0223.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::18) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: 3700151c-4bbb-4be0-3d25-08db20ee4790
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uTlsU7VkweeR1l0rHAwDdoUreok+ZhqphcjaroeL1fIo+gOEL2PVtfCWSImgqQTJDQPo+BphIw0E3s1JqLw9UpxB5IIybMEX1NQFPNq8Lu113g8kSRh3tE7FoZrTMzC4opiDmZL8ckreom2oSlHHLDn629FEqZayquQlibyhipDdJUhXxWi0Khc0i8/T/coozay8g/0F9QnKABK0GEnh3wtrr11FEgOuRT7kNUYdwGEON6te8mdquA/7GdpYlrHQd4ZPYvXIMQBKVPMVC9+8I2DLnXz17uUR/OLTp9zjHez8ncRcAUHcl6DOQi80oUEVLQeYjp7T6otR7R7uUAfkRtDBg8iJPXDZZOKZe4v1hRacVAnJoYCfLQ6Wl21TOuzZaAny/pjdZKJvIyfBlzn7kso/BDt+9yK7qoIz5ZxJ9bPUaZCF4yEo8uXeApj7lQizzPDQwPveCqokctzingv6UwU0/BQRvUwiMXqeos2nv37UuhmfZ8OgQ2b0O9+/IbYdDX/+M74i+bTIXA28knbrUp9r4EVV47y4sUpi1XCg4er8h1RGmJ3Qruevy5oTMPdbW4ppQx08mWImrkYoPtfNu27OqmAkCGVdL+HqtblwOoDERZGkzV2Lr8vMH8pbk0PXiNNiqZJLY7FKYdBkjhfT+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(366004)(396003)(376002)(451199018)(2906002)(5660300002)(36756003)(66476007)(26005)(8936002)(4326008)(66556008)(41300700001)(1076003)(8676002)(316002)(86362001)(478600001)(6486002)(66946007)(6666004)(6512007)(107886003)(6506007)(38100700002)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d1HQnPaoztZ6tuXpSKDC4av0lGez+DBica/UZGarxvlRY93jbGRedSZLFmE0?=
 =?us-ascii?Q?UEl7GmRfMfEZ3l0iBFK5ubHIPdy0mbwAMGkhcnIJ2xiarurSJQtoHBlvVfRL?=
 =?us-ascii?Q?NiufP4HITWzH2jC4IKY9C0c1qDoP7kCmsP3eK3tMKRj3cH7SkYTGO/NgSzRC?=
 =?us-ascii?Q?24FvQiMbyCN7aMiAnP4R8xpdh7zzZ1YAe1aJleaZ4R3Cf7hIWslyoAuXhhvg?=
 =?us-ascii?Q?YIARMaA4e+iCCkULgKHbYu4tbBbeZG8tQRL/CZ4hufrNJrGhVPhvbmBMSTDN?=
 =?us-ascii?Q?J+bQspLSqknnEXfikZgko54gWEcYDcDMnESHzWuqs6/tnXpDyLzWLPZ+lcWm?=
 =?us-ascii?Q?6xbue6kSkYOZVeCVmLo4B1LJvX+qyb7R82leOvRKN32lZR7Hz1hJptESFjEO?=
 =?us-ascii?Q?2HMK2b1Z9mLY/AWwVzzLOrfwndTMfczUNrvbb4cmXkjMVBV2TruFKjJhuRRP?=
 =?us-ascii?Q?YtZ9J+oA+2ryCUVAsMVj+YKWm0HnCSF6R/wRkrdGnEXinwIxH/tL9dFijAhc?=
 =?us-ascii?Q?GIgZ/aLEBKO47jmXc/QqGoqWamFVePCvnKGnULUq2ZvzsBAxKIkeqplZMUq9?=
 =?us-ascii?Q?SqoNs3qCF35fcqpxCK8REfwcOOHG6qugny1JHBxVup3IZp/cfxr9OdbZItm7?=
 =?us-ascii?Q?zGCz2rG5gr9OxrKLC05c/NwoOMN4ytZzZ6yoPgZZOovyOUd/f9b4udvtY6zP?=
 =?us-ascii?Q?rtmV4YX6Te+RynXC44TBAjIZ9k5eWMEoDInezD6yfJ0WfvFMLgCvNE4TfTuG?=
 =?us-ascii?Q?/nzBzYItRjVTydlETTIIGgqU8xPS8U4hmnWFWtkT9/GStHDAO1cqUxikieDz?=
 =?us-ascii?Q?09pDff3QCfUh1oxJd2cSp1gilwFCjD7UM1kSTMEM5Tn58028Q3h6OLAJOF7y?=
 =?us-ascii?Q?UcIlXhEWr6vYrRajmkNXUClVN2XcshHCqCpnXIOKGKo/h8Hi8cbY7aCGGyf3?=
 =?us-ascii?Q?sb5gesu5IwhNw5KeBQDpI994JzAFUuWi4YmlPq4435Zr+Kr4I3HnXOrRMY9I?=
 =?us-ascii?Q?PYY5KKJGUILFo/WpgCLN5h06bOxkZZIjfgD3sU/yrCSBOt2h6fTSFro4P7bC?=
 =?us-ascii?Q?L6PPp1ZGqvQLyLAQ1SaBIS6s7WZXAoSsauR0NvNu16ZY8H5c3eQBUehEULXq?=
 =?us-ascii?Q?ZX7wt66OA//BRgpyqR8LXu8e7rMKL0UcMSkjNtuy17sZgs8D0A35pNvX6bo3?=
 =?us-ascii?Q?fwiVNax3v6FetiKmKxPxqq93NGdr5f+luS9AfDJJ1nVFAZ8y9nrzOXKRnqyw?=
 =?us-ascii?Q?OYuBBo/743gAQKpkHude5WH5qBOY/xq2dluZ/CWbVRzJ+V+Jf2tkJlcVV94I?=
 =?us-ascii?Q?wGbHngfh31/q7Gh/zZIteS+Ro/gXHy1CMqDnSjnoyAzNhinQKcCw3nlU1xz0?=
 =?us-ascii?Q?9fOhwy4ctR+QSE7J9jzZN+hsSpJ+b0zKz2LrVDzxCdFkYEw8r7/NgkBkFA/7?=
 =?us-ascii?Q?WZJqm6XnTmZG0TgHLg5i8JzbQy9Gayq8IYdacOSjqmV0m7kpKyiI1Qy/Sc/H?=
 =?us-ascii?Q?6iYr8tXtmc3hGMgMwLgRcuFgK/QEe8X9zBs9YvMAX+kS/ST7XrbaGKZrzfA4?=
 =?us-ascii?Q?b3vn9acyRXvZYPMxv8Bk88VatgQr5ZqZknvJqhsSoTj8OTo9hUra6YOuGGDH?=
 =?us-ascii?Q?KQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Bxwywzro2/MdULWP4yumJNFhBxa7K6gdh+9JcAwU+oruBWXLC59z/9KoQmmPVMwCbHz4aMNpbsd9MloM4C5ABigNJuM+h8lEC4HY9sbv1moUqPDRWsiP+Ij32mINCbds9Bry8Yn217OXTxd6ZsD1vS1nIrHJNGE5IZn2q4OLq3pwHqMCL+yRoVFKF1YS7hqBmpwOdOBYslfz7+M2zEJQDrWLHclsBrt9g9902NVNonSEx32VuqlYz4ZjdGm5B7bfXmgBHeqADMsc4bYsZsM+uDGy0/D1QufJO9cuoH0fvoBZequbTYWB0iEGJaJDDNdAbBaI33U8sT9Bj5Hruia8OhxGCbYbvoO+WBexqf3WkcbJogge1G4gkZ+8YUymcNmBam5wBptKR47BIdRHfYyoKRyQkygBF69vAt0bpy+TR9Rd5h/BxfmbopNmpnV7pbPiwyESAGpFxGceb6tN7TU2joGAUrCbySgS9ITStzAtW32TwPbqAt/nueFBdv2CPFumFr3DepFVQFwlkm4qfmcN6zE8LW5BIDob46FbGO6F8U3Z1a07oPxp8zHrG+tNcNMQvolVscVzHidpOuU6oLwuWrstmMkXrYDeiS5w3tDIAmEaQ88Ev/BlSV3/KRTvQnChBPLmZNBamUs7FoQKL9HmN7uEF3FE/OAnQ3C+HJC0n6WrmEkiKfVR3fks3n8GVtrMYgf1IzHGxRKLb4k6UnUF56dmNL0w6NYcbzTCJHSRlg8r3DcL3UZShKiIwNfh4vLWzQx1gyyAIJzguSaICx62NlDFTsU472TxQtUy5Uv64/LYjmJJk694ZJlPNjHyzrhp8sC99crEPz5Djp/JeGXueBgcDQBaxZkAY1tmgy86NtLLZHQf1I2AjilzvKmcpdPM
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3700151c-4bbb-4be0-3d25-08db20ee4790
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 22:33:17.9247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Y/hGXOr1QC3vWwoWFxbNj8EkDOggK9hvecpKL8BYhFLlb+LyiFVZFURpeD6GPZfTPuzoyvgFeBWtVTVM9pe4jpBvKwqBpvVWcwPlcs7YaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6479
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_12,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090180
X-Proofpoint-GUID: x4A0kszUS1FQWsUhwZSLiB38h84Bm_T4
X-Proofpoint-ORIG-GUID: x4A0kszUS1FQWsUhwZSLiB38h84Bm_T4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iSCSI needs to allocate its cmd counter per connection for MCS support
where we need to stop and wait on commands running on a connection instead
of per session. This moves the cmd counter allocation to
target_setup_session which is used by drivers that need the stop+wait
behavior per session.

xcopy doesn't need stop+wait at all, so we will be ok moving the cmd
counter allocation outside of transport_init_session.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target_login.c | 10 +++++
 drivers/target/target_core_internal.h     |  1 -
 drivers/target/target_core_transport.c    | 55 +++++++++++------------
 drivers/target/target_core_xcopy.c        | 15 +------
 include/target/target_core_fabric.h       |  4 +-
 5 files changed, 42 insertions(+), 43 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 27e448c2d066..8ab6c0107d89 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -324,8 +324,18 @@ static int iscsi_login_zero_tsih_s1(
 		goto free_ops;
 	}
 
+	/*
+	 * This is temp for iser. It will be moved to per conn in later
+	 * patches for iscsi.
+	 */
+	sess->se_sess->cmd_cnt = target_alloc_cmd_counter();
+	if (!sess->se_sess->cmd_cnt)
+		goto free_se_sess;
+
 	return 0;
 
+free_se_sess:
+	transport_free_session(sess->se_sess);
 free_ops:
 	kfree(sess->sess_ops);
 free_id:
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 38a6d08f75b3..85e35cf582e5 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -138,7 +138,6 @@ int	init_se_kmem_caches(void);
 void	release_se_kmem_caches(void);
 u32	scsi_get_new_index(scsi_index_t);
 void	transport_subsystem_check_init(void);
-void	transport_uninit_session(struct se_session *);
 unsigned char *transport_dump_cmd_direction(struct se_cmd *);
 void	transport_dump_dev_state(struct se_device *, char *, int *);
 void	transport_dump_dev_info(struct se_device *, struct se_lun *,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3d6034f00dcd..60647a49a1d3 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -228,7 +228,7 @@ static void target_release_cmd_refcnt(struct percpu_ref *ref)
 	wake_up(&cmd_cnt->refcnt_wq);
 }
 
-static struct target_cmd_counter *target_alloc_cmd_counter(void)
+struct target_cmd_counter *target_alloc_cmd_counter(void)
 {
 	struct target_cmd_counter *cmd_cnt;
 	int rc;
@@ -252,6 +252,7 @@ static struct target_cmd_counter *target_alloc_cmd_counter(void)
 	kfree(cmd_cnt);
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(target_alloc_cmd_counter);
 
 static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
 {
@@ -271,24 +272,14 @@ static void target_free_cmd_counter(struct target_cmd_counter *cmd_cnt)
  *
  * The caller must have zero-initialized @se_sess before calling this function.
  */
-int transport_init_session(struct se_session *se_sess)
+void transport_init_session(struct se_session *se_sess)
 {
 	INIT_LIST_HEAD(&se_sess->sess_list);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
 	spin_lock_init(&se_sess->sess_cmd_lock);
-	se_sess->cmd_cnt = target_alloc_cmd_counter();
-	if (!se_sess->cmd_cnt)
-		return -ENOMEM;
-
-	return  0;
 }
 EXPORT_SYMBOL(transport_init_session);
 
-void transport_uninit_session(struct se_session *se_sess)
-{
-	target_free_cmd_counter(se_sess->cmd_cnt);
-}
-
 /**
  * transport_alloc_session - allocate a session object and initialize it
  * @sup_prot_ops: bitmask that defines which T10-PI modes are supported.
@@ -296,7 +287,6 @@ void transport_uninit_session(struct se_session *se_sess)
 struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 {
 	struct se_session *se_sess;
-	int ret;
 
 	se_sess = kmem_cache_zalloc(se_sess_cache, GFP_KERNEL);
 	if (!se_sess) {
@@ -304,11 +294,7 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 				" se_sess_cache\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	ret = transport_init_session(se_sess);
-	if (ret < 0) {
-		kmem_cache_free(se_sess_cache, se_sess);
-		return ERR_PTR(ret);
-	}
+	transport_init_session(se_sess);
 	se_sess->sup_prot_ops = sup_prot_ops;
 
 	return se_sess;
@@ -474,8 +460,13 @@ target_setup_session(struct se_portal_group *tpg,
 		     int (*callback)(struct se_portal_group *,
 				     struct se_session *, void *))
 {
+	struct target_cmd_counter *cmd_cnt;
 	struct se_session *sess;
+	int rc;
 
+	cmd_cnt = target_alloc_cmd_counter();
+	if (!cmd_cnt)
+		return ERR_PTR(-ENOMEM);
 	/*
 	 * If the fabric driver is using percpu-ida based pre allocation
 	 * of I/O descriptor tags, go ahead and perform that setup now..
@@ -485,29 +476,36 @@ target_setup_session(struct se_portal_group *tpg,
 	else
 		sess = transport_alloc_session(prot_op);
 
-	if (IS_ERR(sess))
-		return sess;
+	if (IS_ERR(sess)) {
+		rc = PTR_ERR(sess);
+		goto free_cnt;
+	}
+	sess->cmd_cnt = cmd_cnt;
 
 	sess->se_node_acl = core_tpg_check_initiator_node_acl(tpg,
 					(unsigned char *)initiatorname);
 	if (!sess->se_node_acl) {
-		transport_free_session(sess);
-		return ERR_PTR(-EACCES);
+		rc = -EACCES;
+		goto free_sess;
 	}
 	/*
 	 * Go ahead and perform any remaining fabric setup that is
 	 * required before transport_register_session().
 	 */
 	if (callback != NULL) {
-		int rc = callback(tpg, sess, private);
-		if (rc) {
-			transport_free_session(sess);
-			return ERR_PTR(rc);
-		}
+		rc = callback(tpg, sess, private);
+		if (rc)
+			goto free_sess;
 	}
 
 	transport_register_session(tpg, sess->se_node_acl, sess, private);
 	return sess;
+
+free_sess:
+	transport_free_session(sess);
+free_cnt:
+	target_free_cmd_counter(cmd_cnt);
+	return ERR_PTR(rc);
 }
 EXPORT_SYMBOL(target_setup_session);
 
@@ -632,7 +630,8 @@ void transport_free_session(struct se_session *se_sess)
 		sbitmap_queue_free(&se_sess->sess_tag_pool);
 		kvfree(se_sess->sess_cmd_map);
 	}
-	transport_uninit_session(se_sess);
+	if (se_sess->cmd_cnt)
+		target_free_cmd_counter(se_sess->cmd_cnt);
 	kmem_cache_free(se_sess_cache, se_sess);
 }
 EXPORT_SYMBOL(transport_free_session);
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 49eaee022ef1..49a83500c8b7 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -461,8 +461,6 @@ static const struct target_core_fabric_ops xcopy_pt_tfo = {
 
 int target_xcopy_setup_pt(void)
 {
-	int ret;
-
 	xcopy_wq = alloc_workqueue("xcopy_wq", WQ_MEM_RECLAIM, 0);
 	if (!xcopy_wq) {
 		pr_err("Unable to allocate xcopy_wq\n");
@@ -479,9 +477,7 @@ int target_xcopy_setup_pt(void)
 	INIT_LIST_HEAD(&xcopy_pt_nacl.acl_list);
 	INIT_LIST_HEAD(&xcopy_pt_nacl.acl_sess_list);
 	memset(&xcopy_pt_sess, 0, sizeof(struct se_session));
-	ret = transport_init_session(&xcopy_pt_sess);
-	if (ret < 0)
-		goto destroy_wq;
+	transport_init_session(&xcopy_pt_sess);
 
 	xcopy_pt_nacl.se_tpg = &xcopy_pt_tpg;
 	xcopy_pt_nacl.nacl_sess = &xcopy_pt_sess;
@@ -490,19 +486,12 @@ int target_xcopy_setup_pt(void)
 	xcopy_pt_sess.se_node_acl = &xcopy_pt_nacl;
 
 	return 0;
-
-destroy_wq:
-	destroy_workqueue(xcopy_wq);
-	xcopy_wq = NULL;
-	return ret;
 }
 
 void target_xcopy_release_pt(void)
 {
-	if (xcopy_wq) {
+	if (xcopy_wq)
 		destroy_workqueue(xcopy_wq);
-		transport_uninit_session(&xcopy_pt_sess);
-	}
 }
 
 /*
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 38f0662476d1..65527174b8bc 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -133,7 +133,9 @@ struct se_session *target_setup_session(struct se_portal_group *,
 				struct se_session *, void *));
 void target_remove_session(struct se_session *);
 
-int transport_init_session(struct se_session *se_sess);
+struct target_cmd_counter *target_alloc_cmd_counter(void);
+
+void transport_init_session(struct se_session *se_sess);
 struct se_session *transport_alloc_session(enum target_prot_op);
 int transport_alloc_session_tags(struct se_session *, unsigned int,
 		unsigned int);
-- 
2.31.1

