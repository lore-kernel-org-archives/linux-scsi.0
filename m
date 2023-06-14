Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D01EB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243388AbjFNHWD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243386AbjFNHV2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:21:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01302100
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:20:32 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6k2Fv023003;
        Wed, 14 Jun 2023 07:17:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=s03+KYerlsdWFWk+h9Dhiv1cQPsviHr48/by5s/54Sc=;
 b=kEDrfqsP3f+/fPdmThEJSYuLKoluzE52zHDYZ6Jj+XgphK7J1Eyx6mru/mm5asTe2hUl
 bJjaTaeWxzBd8f0ktR6c1Oj/KUEFRw4STxAG+BVXabzuqgUi7sO8jqukMe4opieg4hV7
 xUZZ1Xw4Ld8xNFVjtuqfZon2afZMAHGLg3Tbir0X3PNLLsaLy1QD1avZSnXu4+frLR1O
 SubvYppR1J0vrFQXPFykZH53CnYPF7x3cgVRJqTwO4udYwOdRw+/J+rLY/+Rgf2jG5Ma
 OWzcbew3N0SS/og+ZOS6WZ4UYgr4bFUBpJZMJuuE2Lld2fKPJREY2Ba0KPfg8l4gLBR+ 9Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4hqupw7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:43 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E5Oogj017727;
        Wed, 14 Jun 2023 07:17:43 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm4ws8x-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jUQkY2mK9UiLNPjZmdheoqo/DrOAW535zi/AO3RJb+x5IN4GZB0moWB+kLPakz9I4d8IgLUn/Gbmrmp19ybA5DaeOMHkBFaSB6DZqgkKzVfmMmg5zi/TGjzb+rJaiCl2LHL6r+gIflK0VQzIW12aLe4lZjwH32sjrK7EDJZ+A/65FeP+9cbpm3dmPqR+5hNtmLlmF6bRWn4TWnPNqsIKt7NyQLdmDzpsVSSPuOTY0OzYoOblQ6WXKJrq4fQpsu/17Bt2vC85oIvCiHmV9TW8XoHYCkIqDSq9R3lIMCCkFK8uKSI1cQ6AL4vM6YlAB8O1SggttLmeciks99i3/C3QMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s03+KYerlsdWFWk+h9Dhiv1cQPsviHr48/by5s/54Sc=;
 b=oUl6Ck6Zsa0olKWQ7j/L0FVqC8Eyk2mJBT63PwNMafGK2z0by6ajQ167g3w/76s/6GtZU7Iy9w+odeL0wgiZztPY7qhZiiRJe3R5pA1iDVx7twXnKdKXvIL9KaijRhtBkAMBk1yeY5DnhmnidRDEuRabPpU/IEN9Y0tD9azcXsz/tu5S8i4HLdRtEstLahYpLyJ7eldlXSyceWQCMtMsBdGlvigdBhabuFDZeWMzwWL8OGwE5g53c6vTiGkWIgkw+JFpMDWn6zET8Fc2gN2eY78pJoOV+wMQmgmQHST6k/jpX8HRqTTyRYk/ZRB+XhrZh2sbcyyA+pIMgNPwbh+Ldw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s03+KYerlsdWFWk+h9Dhiv1cQPsviHr48/by5s/54Sc=;
 b=fpgJtmGoLBu5znXME3hxFPFyWxYZPOXDX6AnOtcwQNS3tk6LRi8yuBvJpXuRQUACJ4oi6709mhj6f1ISRO+CL90huVeZ976zBetWF6MIHONliBrj1TaXtB7yTWGFnvP0+hOW3hM3iXorG9vAptpdsmDYyw7YU2a7zq10OHF77qA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB7030.namprd10.prod.outlook.com (2603:10b6:806:349::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:17:42 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:17:41 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 11/33] scsi: hp_sw: Only access sshdr if res > 0
Date:   Wed, 14 Jun 2023 02:16:57 -0500
Message-Id: <20230614071719.6372-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS0PR17CA0019.namprd17.prod.outlook.com
 (2603:10b6:8:191::8) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: e9ce2fd7-81e2-49b6-2045-08db6ca77134
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n76pnn2GDWBdJ14NxMjkx3VvKdL2PV3+Lto+/uyMHJeq5mAqi4wyFMhfvpRg6sz9+FKwg/sAiqXZPdTnVWxiwu6dlvj8KxWGV/WV9mb1NhUU1IFvAJguwfUj1gYHkJ3r3AZpcSAhcqNv/UZx0AMBzhtTKYsX9u2n72rP19Fzte3deQtcoDApHgkxIQ1DAPbDPdMhMdp3/myFcOih4gZU7i+EvF346mif1OoKQxErV2KX3mqWeKrACBpqgoaajp/iwCnAS27UxwUb7Irc/a2m4kiSPgZ1em7XVtAHsd9d+WdE4JUd8ecsTBLriLfRWyan84LTd+XDkopJtNVCp2iEt4leS7XCLVAvyhUEpDLNzGCD7qS8EPWnEkXY8vPlR6GocF3AZ25eah9XHDjm+pK+LPAtGU5EWQRxtNzxV+QsnuZnqcTpUJrtAlqZ8uNpbwjm2IQkuVbpzSown2UEuWtvn44+XLg/pTHgpBWzs+6X+3bt+x1LpmC7uKyLyGj08kF2VDVGXHunoaRhyFzNZk2BnMtObRM1ajUsUZFgyyPY7UdEJClcuQz2t60qioqyNoQO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(66946007)(66476007)(66556008)(478600001)(5660300002)(8936002)(6666004)(4326008)(8676002)(36756003)(41300700001)(6486002)(316002)(38100700002)(107886003)(26005)(186003)(6512007)(1076003)(6506007)(2616005)(2906002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lbtrMj7bMxeq6AOpoVX9gxwkrTOt6yUGa8vJDpP+A5v4ivY1cRV+TEiWPAOt?=
 =?us-ascii?Q?T3Q7ILA7lUGfglXdGtxE9ffQ5X58d4kv/cAl0vxfQ9DME/zqpfsSsRMYfQmq?=
 =?us-ascii?Q?EJ9bjJFPwTxcgVyKS2m+VtHm0URqnE4MkP/70XMoqHwrCZsQggZvM3E+6F20?=
 =?us-ascii?Q?AZ/iuX6Ten8B2qmjcGVZ0wf97v2UW+zVZoMkA586UbgmVtmbDP3mYlKlghBi?=
 =?us-ascii?Q?PNM4FfnHWYQz1pA+utlR3BQdDM+wX+iqmsbv9GQ40XlBmUgcRBEUX79dzVCZ?=
 =?us-ascii?Q?ns0yRVBSHCwnMxkt8XA3pwGIF77R2Z0qV1IgnlN78n27Uvmsyoj0GjJu3T6C?=
 =?us-ascii?Q?yTnnwy669HiUp+fKWQuMq73iu0kXr8SN0xsg2+oKf1CJI3thcUgldvjqH1o9?=
 =?us-ascii?Q?1+mhv0fBudN35Yw0DkfSnDrEfURxm9wXz6PGrZgErVjHwHf+L3zR6fC78kA+?=
 =?us-ascii?Q?98+6r5jHiAy2jig+8kEXQ3y2hbu8Yz/wxc0k19qLlwGWJaJLRkzECJDZGs72?=
 =?us-ascii?Q?NVKz/SRN5aa6OylUGLOEb/Ys7l2sblwkHfucnllEsFI2sZ7fPrx7m+t/le64?=
 =?us-ascii?Q?8TBd07+1/V7eyunU3Fqde0dDg5uVhk7xQOzeEyykvYQRa+dPsmaW2D6r6gXK?=
 =?us-ascii?Q?n5LILfrc+pjmvnil0bERW0NBMNFqK2bDlJRd8/Yz0nTID1bCxSh3U1/8zYHU?=
 =?us-ascii?Q?b3tgk1oivjn5BlmE0h+8CGXnQNDEg61nd0V52mFM8htTj7hrU4dJ3vKCtdI2?=
 =?us-ascii?Q?Fin8dD87iWawtVtc2HY/yFUZba790r1p71QnSO3DcyX1+0G3gJ8r5E3lyvji?=
 =?us-ascii?Q?quU5rGv7PwAd3jMqYe6NAQDhAQvChCZQOJKQoizf52Nz8iaMIYvHBD+K3ZKA?=
 =?us-ascii?Q?LKaehJvnLnCImF1OILZ9jNGZ98R3hPWTabfn6J28ed1dw67rWwMDLzljPS3Q?=
 =?us-ascii?Q?hLtatMyncACh/824RG0Xvnmy/LliQzew5Fk4UXS9NEYcl90vIz+xUNmplux4?=
 =?us-ascii?Q?y8Acv43c5zRKqUKWjRzAU30R8fao5glh9aUNodc20q6Z1BuFVcOjAK6Xc8YI?=
 =?us-ascii?Q?JvoUanSdmrGWvpyoVi/A6Wd3dGwepnR7axVicVBCD5cSDidvwAP5sLKrNS7K?=
 =?us-ascii?Q?Dq5JCJ6kuxtIYefuAhxXBwNFg53Meib7XnM6wKxi32jnDI2TNe0Lxw0ENWe0?=
 =?us-ascii?Q?psHQ02iYq2MPuyaE25gRpL+ofyeeKxRVop6m6L66TamW95I44BzOMb29Zdgg?=
 =?us-ascii?Q?Y38jLQAecLIbz37POTCjquIYjxaW9PlWUbjYdxQ2DMB59PleAAsNwlKsACN8?=
 =?us-ascii?Q?xGbVnGEE0EEYM+LvEArdfOVdo3b7shqNJDj8yWWiPJiUAzsssi1CWlDA4n7f?=
 =?us-ascii?Q?rcd4pdB97VB/3gl5bSKvcOe8vK2iG021oOgWcONn7WvmHFu+is8nLn6EAOUt?=
 =?us-ascii?Q?Ix8jvotd4T+y3hS+DzCtwn69X2TXsVUY3a8LkN4N5/mHfB0LObTV6Mp3onRc?=
 =?us-ascii?Q?Qm03wKJv8CNiPqmlCc1XJS6Duk9kGGx5OVolr+ij5A1wzvz02/416d/4ZzU6?=
 =?us-ascii?Q?qyoGKl1eOBkLmjq5+Ul2aqJlkpMCmN80gYG5SRK9JJDphzHJ10GaYG+4xetS?=
 =?us-ascii?Q?Eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: QYIOoLDSCJf3gHiHz2q3wWKq5ZUijgS+jcL4c+xMq5w2cepui1CiD4qDLil+xeJAfberNWOOSL4LbJV3S5ccF4AHL0J+iUcuxUXExmiteLExfE+ctMQvCgKpUb3YrrSDYGQ3BDV+lM7bxjoaYlu0alVHhRB+mQBj7XSR7nETeOa3RFDGEDHINbaqJeXzTBeSsLT+CMV/fpbfKJabH07ACZhAt6DWzYGNsBcUydNCjFA0ElmwqyULsMOIzotQiFRHICVtywaBuH5y7sceext+P+1M3kvRa8h4b6snHBOWl36RYmAfX1eUXeRPqhfSRFHBK3R99glakNlZYL9iSQ/3nxo9VFlNbzsl7MbVAAdQkf6SAcykhm/tZaGJ5QGvDQ8/v5Hc73qw34ZKdcyq0PEciwM3OGQUzqsL9gCBdQIMnuNqFVMa+qdqicKsEZVbjPkcilv7GJZZmdzgkM3jlk/PYDEHTLMAlpvAFHkPUkk4IYtoTRbtp5QCWWSgDdwj1W0iuUkxt0OSe8xtZeajAZGkcB6lCc6vgL3ZZ69x1zQGntKcvblgNJGVj9/oR5xKQozEDToNe/Gn5DSSluc1rNsn/QUpQW3ZRHywvHJpJ8fugEIWwIIFvf815eJgzDiDR6K9nSWwEG8gvnLPYl72kQsFUetStpfXmAuSF1a8luFGgiHQGK8tBVI1rWHyubcUNGzPnPVx+vwP4xWIJnilDrqAOAqraaRK5haq2NnqlCgGYZF5q9cI8aSlGkslSmQCyqVc21oq37KtfQ9XPKc+vVUdsrPsINWCEZiMphENHeumvugXENeta2xmY55+YuDZLoYs6Ge6DlGMpHT2EjP1b0/1o6YHIBIR68uL+7y0mlI3Fas2yfcZiK9zo8CFCmuYNwJV
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9ce2fd7-81e2-49b6-2045-08db6ca77134
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:17:41.8861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cr2ljh6ybISsyEuXXcuUTP+BXhHapyVJ9cC1Kk/IfiRsQ5Sl4yqvgdzfzt6RN/kk4vz1xu0mhLJZEU8zxMRk+TlPugm6HvEdP47KPyATiGQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306140062
X-Proofpoint-ORIG-GUID: i5d6Bi52BkiPvMD37FOKmq7A8vFVsGA0
X-Proofpoint-GUID: i5d6Bi52BkiPvMD37FOKmq7A8vFVsGA0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If res < 0, scsi_execute_cmd will not have set the sshdr, so we can't
access it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 5f2f943d926c..785ab2c5391f 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -93,7 +93,7 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
 	if (res) {
-		if (scsi_sense_valid(&sshdr))
+		if (res > 0 && scsi_sense_valid(&sshdr))
 			ret = tur_done(sdev, h, &sshdr);
 		else {
 			sdev_printk(KERN_WARNING, sdev,
@@ -134,7 +134,7 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
 	if (res) {
-		if (!scsi_sense_valid(&sshdr)) {
+		if (res < 0 || !scsi_sense_valid(&sshdr)) {
 			sdev_printk(KERN_WARNING, sdev,
 				    "%s: sending start_stop_unit failed, "
 				    "no sense available\n", HP_SW_NAME);
-- 
2.25.1

