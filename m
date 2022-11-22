Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52575C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 03:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiKVD0m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 22:26:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbiKVD0d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 22:26:33 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8258023EA8;
        Mon, 21 Nov 2022 19:26:32 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM2BNTM015759;
        Tue, 22 Nov 2022 03:26:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Xgv8CaTSqC+nYs4Nw7tleveKIFnjNMIOI7ojrZfVNjQ=;
 b=qakIY423KKfDFc82m+Y2+Q8tItqFOdnmzRBuFKCFHP7ASLyKSzi4KdQvzfDrfAK/luvk
 qL18rUuNs3zNNrknOY0Hl8p+Nds+QhN9thKCMUnGnz9BrO5UrHw/o54pu6GyAAK67vNB
 74wUDqjZbBSpZ8EKhqTMVg0gmkDMM+DGjVEC/lXpEfSM8kobtwb87Vl2ZwiuVa/PqnnG
 9E/FNNJBWjTCGAanIhd2MALxeNm56L2PYuSG3lwhUxlhx4kgMP3Sny4Q1koQCEfVXhfS
 VOpwmf/g0NHvCI5KvPN5ljfOxbfSDspfza2Clb4NerZmQVql5PsyLUPsBHE7KBRfSFLj 5A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0edq1bw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:26:16 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM2CqLT038773;
        Tue, 22 Nov 2022 03:26:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk4png0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:26:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xtrp4WFnWh8I6002InYPStXZ93Hph0qDWx5CpGSqS/fRh4mZzepH4xqX+TYi5Q2HMxpXGTWLbUF/7R903wZfB0209IOeLaHAx/MZj0+rEC5cyW9gw1PDHXp9ClCYOEAc7hH6JkK4Yt4Z+csPonZ4ECZw4a8UrUBiUsREqJ/dr8oXehwd6pl//lN/3S9yI9JJ2GH8QBhXMRhIXiwSaIx074dnyRAa35qPDpIAS/005NYNx0SRjQyKXdhgL81e0jRtAO+CzeM+fGUNhSU4Xi+1rwk0Y+hUZIrpjM403PaC5I6qt1pDxDTwmhvvv9aGhWzYuQ6Jl/Sxc8UgKMHl8ltQ3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xgv8CaTSqC+nYs4Nw7tleveKIFnjNMIOI7ojrZfVNjQ=;
 b=OiQSoKFZssAEmAmoQXXSr9t8VCamDwYdz3wBlmskalcH39nIKvbyl1U81pc4N9z36qbNkJQv5pr5jWz8UcDInr9KIh4mfpSpDkQJNRFl76OFnVRjSCkeIpomBmTv4Eo0UkPjkRbWiipLsX66xgGJgl2gwaW3dPfXw46lXSOt748QM6d/Syy+DNjXN0QNj+NrMeeD42M3sx8Ean5mi8jfeFfOdT3Dh0GKD6f5O0tKrEm0/xWmdY0v1LqDS+HGLB+bRWpA0n78O/auTwhzkJ33jApTV0Tgp1dGxZbXCqbHC34xGZDcFc7gPmn7JjF9ctRfchbUn4f6FmNDOykcvPKTPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xgv8CaTSqC+nYs4Nw7tleveKIFnjNMIOI7ojrZfVNjQ=;
 b=OF8cXMHC+Xot57SNVRLqYbPxMUDSQ51Ioa8mA9Lm3lGJIO1NbhQPrZjSiR14p8Vi9J+Zr01KSJNn4LKovPgn0diddVhL58qnIIGd5/4q84xHqIBAtohSUtfcjcb5alimsubzcP6OmxihzD0JYeesYO2kPnTS55lPFoEztonSZh4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB6130.namprd10.prod.outlook.com (2603:10b6:510:1f6::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 03:26:09 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 03:26:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     chaitanyak@nvidia.com, kbusch@kernel.org, axboe@fb.com, hch@lst.de,
        sagi@grimberg.me, martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH v3 2/4] scsi: Rename status_byte to sg_status_byte
Date:   Mon, 21 Nov 2022 21:26:01 -0600
Message-Id: <20221122032603.32766-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221122032603.32766-1-michael.christie@oracle.com>
References: <20221122032603.32766-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR12CA0030.namprd12.prod.outlook.com
 (2603:10b6:610:57::40) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB6130:EE_
X-MS-Office365-Filtering-Correlation-Id: f3973db9-4e83-4fa7-d5c3-08dacc394c25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zgoq2BOBV0ets+XOKqTmF7cPncdbo8ekRVROcFmyB7YM3PnDaBRY/xpuW5JDSqo8f0X/3DpZrDo1zU+epbNw8w2XKbXOzbstXCXE2HJrJVBuoFag8Ud305TucJLEa01Y9SCAO1K/YpltQHvYLaD/3yO2QRnnB9KvaEJn5BAPaqisEqLabDQFtxQd4tq7AF3Ft/xDB8/5ciabAgWd+kP/6wc/IvrKnl5/Pw6I96Haw376RNI/XHdadyk7SAB/PTRE/0BRgxYJYpLV3GXgw3ijnXCh0hatmebjL7is71PTingc93J3dL7jUsJs64bFIrMB9ciqSawtrzsrEVZqE9cSGpN1gqCnr11pVm84iRAjt5Xp9bIvdSTf9nEEZL2rOn6np9yKSDwmB3UvVAwLW5BEtPssOQM2JZFH98Zdue5+urqxF1wn2b6FXPzfQMwIl0oxFvDltDYlcSVGi9O2dA2Qha2vpLYVYjUQWWD3m0hCN2WBxihs6G63ruYrQQ/0Y1wqFSd4cM0ZHMhwTJ+QVJ1eHzmLXNkWuWdfr2RskrUlzZfjzI3H4hYkhlw66MDEqZX+ZBnAVNWy0SIoVh2idboKqCoEjT6J5nFcNbgOpyfxwFwBzz0xoFXGd8TuGxBBGw1RMGZ0gxIVZcgY/OI5TI0+eNmo5BAusC7I74EXFzlMCHFk9yS5UmtFLV/C1pcZpoBd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(376002)(346002)(136003)(396003)(451199015)(4326008)(8676002)(36756003)(83380400001)(54906003)(86362001)(66556008)(66946007)(316002)(66476007)(26005)(478600001)(6486002)(6512007)(6506007)(6666004)(1076003)(186003)(2616005)(2906002)(38100700002)(41300700001)(5660300002)(7416002)(921005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oRNs8T3VHulg9H/yGl3xxR5V9oLkXmnWIgZ+wrO5vTmAPHAL5CU1OLsuRnfh?=
 =?us-ascii?Q?RjynF5ppiyX6yMMj94i7/BZmjl6HCO5DGk22HT2NlIq8ze416ycxuDLBE32E?=
 =?us-ascii?Q?9kgqMiAIz8Qn6JqLtAwNjHP7Jz6pJgJ51LgM5BJP2fXWO1WfpnvxCM+oHP93?=
 =?us-ascii?Q?N+93BcNrPxau+f0puEJ6QIA5N7wntvyG32j7B/YbgR/DaGkc5dCH2rdHXLIG?=
 =?us-ascii?Q?MxE8bMM11EnxL+IHK4xfq8uJhKubf59TeqYv06NgQnhTQVy17IgE0XmKnEZ+?=
 =?us-ascii?Q?1VHaHt1TC1dgNCW8KI0A+SAu5JAb16BrIBtlGXOpDH87kKhBOuA9lu6V04KZ?=
 =?us-ascii?Q?Vu3/tX9dNdRv5fMrS9qGbBDpLB00zlov3C+VpoO5/gmPsGRHr0scd2n1ih9E?=
 =?us-ascii?Q?/LN9nrG+55ZpU6f6MicIsNsKmKxJ/xa55iTMsXfepf4oMhCMOpwqgd8oEw4v?=
 =?us-ascii?Q?YVuVjwBzV34bOr25ZKDckh6R4MKv6d9PeKKGUeHl0uBDqsMT+eQYHYY8BePO?=
 =?us-ascii?Q?5XLq8sZbqXrzAIt+W2uOCIbJD1npC32EcCD1QMkvb9zRVxV80zNyEEWUQcgY?=
 =?us-ascii?Q?5mb6uC3zI3BhI/Zmp/uhhT/bra3iLwIbkSkd+HmuKP67ilHani5+JGvdM5/l?=
 =?us-ascii?Q?MiCiHxs2iwkbtmzycC9ayml9X2MLjshDZt8KQZxQ8qQC9Hxt+YLIPQaGA8ya?=
 =?us-ascii?Q?+PoIcmX6X4hL+qlzNTd7qegI3x8AbK0JNKa2S5BDb3D2dQqU2wl6sKn+8siB?=
 =?us-ascii?Q?zW0OsgpWwjdByM3AODbYgrVLeZx78DR78BaUMJh+rYXk5Kg6T4yEwHAbdGT8?=
 =?us-ascii?Q?WwcsuBYEiLLWa7Jq1PDh5nfh83mu0Vzfm9QbLFC3idBGHZJFccrLrynKYroD?=
 =?us-ascii?Q?xH7KRz0zgRl1xRtjESqF/ic1Ee3dIHHM8C0W/3x90pJoTotXMbCCIkyIOM3g?=
 =?us-ascii?Q?P+GCznFDxVtu9HnithFna48Na77XXTYedHUa9mzwV4z6nGmeeY4IT1CzMnOz?=
 =?us-ascii?Q?jyIhW8yuVYE7rJPEgg5fP9QYJhSibS+fARs/z5OxqElBOpHcRvodjHhTGQNE?=
 =?us-ascii?Q?xfYvigvGKtIxSzFQfsuOE8ttj6EClBq0ifUDIkyLswWOBQo4gr/7i7I1z5y4?=
 =?us-ascii?Q?xHhpmrptk7abQAU3MSGjXtmsQEj2A3ABhUeQrINkVfjciXnzFmCkRDR7Zlno?=
 =?us-ascii?Q?/vBML6PiVmPV5vFhcNZXpvUyFUeiVS6EzcFWOtrpnVryzYOLzcD1NH/bzjmu?=
 =?us-ascii?Q?LdH8nbhAkeWvsS7r9HENjgOZmPGXwlpiGjCTxjR9tH7dv1PfGGmCFbf7qiwE?=
 =?us-ascii?Q?Z7+Pi4HVdKIuhkqQ1erhCRRk7aBYEke+QN/AGYSxewuLZ/0GNiBWFTVBojNy?=
 =?us-ascii?Q?i44nK+OVrMAxuBiGTlzGrWTAUaQVA21t9R2InPhIlaf3DYeBZNJX1/sSG7VS?=
 =?us-ascii?Q?nlpJvXgWIe2VGkxjtym9IMqk9MM7/xHtZ8KFfW8U+kIVSI8173CNsc8Ol8Ga?=
 =?us-ascii?Q?M/xxfEw7VzncXHbTSX2hL+EhCyoMmzsLbwVLAB47EDMlNzN2JNfbYi8+58Ls?=
 =?us-ascii?Q?ZjjIa3sQTG5RItQEuY0DmFFCy97pCiU7eFxdOOvw9trTjPSOcwYJK5jISmCP?=
 =?us-ascii?Q?7Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?T1HkzDIpVlKlY26gHooIE8Kz/5O989VKiuMFvV3S+oCyHcpKVPS9uGF9Oead?=
 =?us-ascii?Q?AaxOJGvhrbRQZtBijhaeqPljVkvJ9AmQti9Y1pYwAJYzn+lPjlOTexZsqKoK?=
 =?us-ascii?Q?qOZh/mS2QSqJBN08AYVv1UrDYuYPyeM3fMQwZDBjAobhH6TW+KmuA6ikEKnP?=
 =?us-ascii?Q?Dsid8pwQYaD/Pwyk/hu/m6S0Mc2Xd97ZZ7ozcPugI8e985ejQ9p82O8/JGd7?=
 =?us-ascii?Q?j+p/3VP2ubVcsTAWeicoUF6rB4WGrWto9jOdrvW8p+wHJpW6deAUwZQzZcN8?=
 =?us-ascii?Q?VtzGhMQaCUKnAus4NeCbdTF+2HDV7R1IEaaV1takVjEUFLUepZyY7K/c16bT?=
 =?us-ascii?Q?Z//qmk58u9Ep4mb2BKqhIBUzjlWa30wPBeq4SfdC7T3g4DNezHjh8dMxeLDu?=
 =?us-ascii?Q?CVtLUCCzHx+qWzb7jyDicYOvwpQHJLb4179ogynmgDiybYJidEzHfH3AlrJo?=
 =?us-ascii?Q?XZkYOOisybM83IIl6YtiUetFh1m/850wqOydiy+gLkr1muLbqmXSwWH/cgDj?=
 =?us-ascii?Q?r6EDU/qJKem5G0Jh4Tv81eyDEy94ELIwUxnazttTwgoQUxJvfuiEW4ou9ygZ?=
 =?us-ascii?Q?Jzv5SzJjLnTR98Xg24LKqZxFqjeySEnAFMcc62Aokjb/AwIthQ4Y/cKV1dN+?=
 =?us-ascii?Q?AbkXAw5kHY3LwmQhFdyW+n06cTbGu3pVHHjle4u6Ogviy524WB9dl4CXPRTT?=
 =?us-ascii?Q?HfnHUSfCgtn3IYsU+Nj2JUyCWBoPYAFR+2I/OPI2kr1Q9Cvn0cEGePZ/ik0M?=
 =?us-ascii?Q?/bxNBbtPzzqAEwn3mZJsNHAUUm1kg8RtkoKiztRmcX4JGJGW9KOjtrH1jRBC?=
 =?us-ascii?Q?IIPuXfB9K9FnxF05QX8fCuzjJrYeF27JXsNJaEafl6oqQ+LqY1ElwCbpyEyt?=
 =?us-ascii?Q?15teje5JJzIaasudYeRXcPGJb81JgynzEbLBAQKhEpM85cYiX4qCWw9SeTZY?=
 =?us-ascii?Q?b4jJ0JpEajHCUDj7W4Mplzw8xa6mY5yIUMPiAjTVI66l9a32taG51wDePwvi?=
 =?us-ascii?Q?UPO2+7jLnDNHcuxsD9NpiT/JEDKn351efXnSxB0gVsKBWqg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3973db9-4e83-4fa7-d5c3-08dacc394c25
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 03:26:09.0346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UHvhExbrJaRH2c8CriAn4+qwv8gsrk7Kjp3ue1Kxa9Mn+o23TFjjVmtDHqepQkWIsy8t6XmO3B/2BUO80u6yt1MrQ2CXsezVGqc2KuosnFU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6130
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211220022
X-Proofpoint-GUID: DO-DeotNSB3MpI1YA4fW0YGC_fj0kteD
X-Proofpoint-ORIG-GUID: DO-DeotNSB3MpI1YA4fW0YGC_fj0kteD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patch adds a helper status_byte function that works like
host_byte, so this patch renames the old status_byte to sg_status_byte
since it's only used for SG IO.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_ioctl.c | 2 +-
 drivers/scsi/sg.c         | 2 +-
 include/scsi/sg.h         | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 2d20da55fb64..8baff7edf7c3 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -376,7 +376,7 @@ static int scsi_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 	 * fill in all the output members
 	 */
 	hdr->status = scmd->result & 0xff;
-	hdr->masked_status = status_byte(scmd->result);
+	hdr->masked_status = sg_status_byte(scmd->result);
 	hdr->msg_status = COMMAND_COMPLETE;
 	hdr->host_status = host_byte(scmd->result);
 	hdr->driver_status = 0;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ce34a8ad53b4..d61d8d0d1658 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1349,7 +1349,7 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 		struct scsi_sense_hdr sshdr;
 
 		srp->header.status = 0xff & result;
-		srp->header.masked_status = status_byte(result);
+		srp->header.masked_status = sg_status_byte(result);
 		srp->header.msg_status = COMMAND_COMPLETE;
 		srp->header.host_status = host_byte(result);
 		srp->header.driver_status = driver_byte(result);
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index 068e35d36557..af31cecd9012 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -159,7 +159,7 @@ struct compat_sg_io_hdr {
 #define TASK_ABORTED         0x20
 
 /* Obsolete status_byte() declaration */
-#define status_byte(result) (((result) >> 1) & 0x7f)
+#define sg_status_byte(result) (((result) >> 1) & 0x7f)
 
 typedef struct sg_scsi_id { /* used by SG_GET_SCSI_ID ioctl() */
     int host_no;        /* as in "scsi<n>" where 'n' is one of 0, 1, 2 etc */
-- 
2.25.1

