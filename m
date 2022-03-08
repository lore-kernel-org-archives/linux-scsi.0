Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42AFAC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 00:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243211AbiCHA3N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233832AbiCHA3G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 19:29:06 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFA726AD5
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 16:28:11 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227LE2sI031927;
        Tue, 8 Mar 2022 00:28:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=utAf89Eqb0N5MnuFRt55pB1mE48U/xU7ZRc0B2oYioc=;
 b=uCrleZhPDfIAMyrqSVNmkg7x4UTYl4Um0hRW1z5B9WtLhQE7iZWxMvkis92VvsIwHssm
 D4eZrmIYbxGFilNZh4McGFQ/hN4dtm+oD5ft6apWOMxijtLQNtWgkp0Ih3++e2wugu+Z
 VnFcBJ+ilb2rms0S3fd+zGjxGRSppVI94RoR/1r6vPLQgrhjIVu53Hmvqf2mbiQuTSr0
 75FvUYlw4qZvgv5si1naEyb9wcb5tzsS53pq9fi2aX9bKmzqmD5dAMvoXXtZgU8k6pnE
 Aqezq7F4QnOwqqISBOR4aELUU2ECSFVqwqf6aYFLXGPEpex+EIlbsPOnRDQG3jUIAHJv Gg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyranbuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2280AKkw134578;
        Tue, 8 Mar 2022 00:28:02 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3030.oracle.com with ESMTP id 3ekvyu3hs1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fxRvmqYrG2bMsiKIVJ4xYTGbwIEDYt7isFEmlgRLkX+8mt7TICc/YcfvmVUFWCaeU01qVGKzaSWsZ1EcBE7an9+ITcOdZet0W2ESxEi1pH/LLleTrqlIvAHegIa9iepo1c3viR3h0B8JTAhIt/zwmkgju0Xy+BEIINo4TtYYVU7XY/qzoG/vztDfMUC4Nxo/061xpsELhTM0IJA5h8CsjMt95XihusWz6gek/0Ai2NoBFNgz41jqKiGvNNjxNf9oYjejMM9dGs2T9eJsCkHiRlONCdItfgplOljgkTXqa2eJqiH2ZSjw1s+nzByRnK5ui1UKm28HOo2R1t7DT1yB0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=utAf89Eqb0N5MnuFRt55pB1mE48U/xU7ZRc0B2oYioc=;
 b=ZxAh6j5n5iK9PoI/jlJjJTvXW+YELcRoiPGXTpo9Hliykbt/tZQIABXdi9fqeK1sBWbT0jzmkcJ594dlffFFjYmmKk6l+M6s8bRiuC1XAW1fAibRz/tWcb0Iz8jXNLYnYEajywwNjmEAdZ62xsyqY79sF7zP8Y4pryNagZL4KEwXbb8wAvq7Wdu4sjPrKVilnpe6vJscEHHzaZOgIjdzJQp/ksCnge8uMl5e0Bf5m5KHLCdC06l8uo3ev9kDnutZ6FvG1uYbGobEaViKM0WkFDTt2/NBmVpsmYl2FM3OWU0TY8NHGKwWr1w+1JhtEvOoTZOnUxtG3eR9G1sqZVvkvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=utAf89Eqb0N5MnuFRt55pB1mE48U/xU7ZRc0B2oYioc=;
 b=xqilTD67G7eC0urzWl2uf13Yzyn4pSsHzByN854B0bcs2Yy/19g7MdBWX+6cOp1mbK/qIpnWjBYUiNX+KZUTRg0Vhrf5ws+hJlYppGA58MbgP4VAb/s5I3BG0tROfoxTncsh/6UFMP4DtiCh056mRLNwdfMovDkT5xCRAS9520I=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2809.namprd10.prod.outlook.com (2603:10b6:5:63::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Tue, 8 Mar 2022 00:28:00 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 00:27:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 07/12] scsi: iscsi_tcp: Drop target_alloc use
Date:   Mon,  7 Mar 2022 18:27:42 -0600
Message-Id: <20220308002747.122682-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308002747.122682-1-michael.christie@oracle.com>
References: <20220308002747.122682-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b92d97e-abbb-4af8-8e8a-08da009a7f66
X-MS-TrafficTypeDiagnostic: DM6PR10MB2809:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB2809C2A6B55015ADECF15736F1099@DM6PR10MB2809.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3EQwwMb+yX9G3Fu1WrJl5qvfk/UMSwGwItNCh9FKWRxRh5a/6/SOedLGMo/DOu+nbpaI/iUDtanvnRMV6MDjgxeKX767HqxQIUSv07UBP+cOjp9WsxEfjM9xzVgqNYnjItxBABF+zxHSHKPnM8PT1Q5kW8mMvNDCeSR2Qw9OAS06VArrGVMLa/4gJkwItzAy6PhoA3WUPUGlEYO3aY+yEwtv17EZVEmqNrGIu8o95hQcm03y0VBAETSTip4w9Bs+F7CaSuWSg0MfZPeqK40HiOT/0bnSWs7RZ1/nOVtQNJy+KdrhxxjFsutfwGBBueg7HWampuXS0Vvo8PzVakcebAqfpL0r81CVOcJEGIhwndDUnfuJpvVFG2B323n37dHm9o7Gw3NFDU+iZr7RlIt2gJczMtgvb/db/UzSiSa6MnfgJeNtsXgmkxtzAFjiSDCdCsjcocb97tQmicGle0Lu0Vqm1YaGvR1PZYX++idEOeMYeTlt+cSwicgpfunDOnsKHkdSdwdez0HPVVXNhefFK2x6/RGz6LN6dLCqJmeI0FrNLEiWMkWnaElkmxqGWYaTt4XO3p3eVPuAadKH6VmVRN3a0f/UT9IvlZ+WX+SkVSmFHKNplY6ylyfX3psWD0cyF2iOKjp7paGXlqDX3KTu3zGXI/+rxTFYoI+BNNTfnniXZAnjTRKY9PQLkyufYMpk8hc7Ret5/+3yUdIh3yivKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(66946007)(38100700002)(66476007)(38350700002)(2906002)(66556008)(4326008)(4744005)(8936002)(5660300002)(6486002)(86362001)(316002)(508600001)(52116002)(6506007)(186003)(26005)(36756003)(83380400001)(6512007)(6666004)(1076003)(2616005)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/J64ut18uob8eO6hhY7HHdINkeBAr6yzZ2wcDHC/HJnI25IRaoQREg1VjhY2?=
 =?us-ascii?Q?r40/0zmTPCMaxXdUwQqIa+3GBlPkLb6zEpuCbQKQbbMIUEAugKSqIxOrAbOk?=
 =?us-ascii?Q?d8trWfgrP3NVZC6S0ZosXaxjSgy7NXvEPsiksOEusYRe/vasqWIUEO2A1IVW?=
 =?us-ascii?Q?+WwIJKQ6/yznMEzioGYO02RcoAwVtslPaqbfP5bnksg9q108gdWcAdsrlvD9?=
 =?us-ascii?Q?LVbMnt0a6l6DdapP1fHKxBHE+sqGU6a51GqV0bRE8U0a44bF6+1gXa0Wgc1c?=
 =?us-ascii?Q?X5XOiK5WwTuUZGGJUYqqRGe8yPQ3zQL8Ejf2uL7FSJaT+96mnmjsx4/5sJMj?=
 =?us-ascii?Q?/H2O02oMz8V+7ZJypXOnoCiYN7oQ7jFQ2HlOewrIItkp0vMS8EA0heZFZJWU?=
 =?us-ascii?Q?itY+S1R8gA49LrSLiy0Zn+8FcXYaLsmQ45xRvCbGUfWlYgv3y52S0Rp00gVm?=
 =?us-ascii?Q?kQ83ZkMS8Izd6w0DO9+upeDWYW4XcOdc2jupyz3rO3EY7XAVhPDxmpIyPiTh?=
 =?us-ascii?Q?cwgCqcw8UGnK0jtRC358HFlJtgOpR5qgtHZ+1lM4+XiiLULXnpMdCOiUDYme?=
 =?us-ascii?Q?o8leZeLvFFs1Z0MbA9aX/oGoMXRwhOWkb1kk9n4NZ5ilNE7dO2DGtW2rHdK5?=
 =?us-ascii?Q?t99p38D0Q06Bw/ziKmMT1MQ7yCN4C0+S7pZAmjH2E9R1au6U/RNj5BR+DHtN?=
 =?us-ascii?Q?nyku28vkotFx/o2hbPXqGvftmcwXp007mwqmyO+ZlgMpg8DxDJRHey5fNZUp?=
 =?us-ascii?Q?qFd7gNM9RotcDBXZLeuUMnp56gdVzYbkvqfJ4LRG4KoQg+EbjgBD5gEYWGTm?=
 =?us-ascii?Q?PdWydc8+V5OjePZA3kmQ8zApZVQpN5FU/4c2XFBV17Giiy1oRFC40kyI5dHy?=
 =?us-ascii?Q?CtkOMDDccL4uW1GfI9ggGvZvs+E+h+9Th6KdzpyBoybayqHutO4dDyheMMzQ?=
 =?us-ascii?Q?xqQq0X8wojU9R4Bbl80gdVDVjP8IEPWFjSPYBJ2GW3WzbtaZpZB6k1OQIwiL?=
 =?us-ascii?Q?zOafjAYmlc3rjejMrRMX57m1jRl3nFQuAJLjKZ5Ynl7Oe/bMoqi8YoMkRetg?=
 =?us-ascii?Q?bZmOoNNm/JtJa5E8fzwpkxYFqd/5zrPZXCb0pdsC3fkMeQRoHlWbn0Cl66TT?=
 =?us-ascii?Q?eXQclll9VhNUoXD581e9YlN04OfbD9qKtPYkRpm7a4mPR9jVmuFpDaEdaKye?=
 =?us-ascii?Q?gInWmuDwR5Uab4G6kyVo6MSi2gkvUZQOVz0e/GHJFaz8fBQCsbRt8rfRrR3U?=
 =?us-ascii?Q?G+Cas8hmySOXVe/0I5ODzTYXMmX0Ilxmx20hqFbF7c3DMftpf+9O+3F3GSJF?=
 =?us-ascii?Q?WtTOk/9S9T2P885Phe5D5EKuor79WOCIBPzzIq8ZQtKH7oj6YPKRjO+MrT7g?=
 =?us-ascii?Q?M+PVGCvNLbdsItxkGPKBykiIfF5J4aBY5EZQQ49IReckyYaPLtcg6QrXcDoG?=
 =?us-ascii?Q?JQRdhz63D75mWresC6LyFihyF4/DmPUJcHKEgnbjQjX4fCFu9Y6H8Kojez0o?=
 =?us-ascii?Q?EJrCIOIiSOvmYgzSb1BTRFWI6w8fMrx510YZ4U1yY/jBQIJm23/r50quqVLk?=
 =?us-ascii?Q?71Sns9lb5JFes/qXY0e7+YKwViwR2nnACR5P9QZH9Z7hN7A0u/WWfZLN5sdD?=
 =?us-ascii?Q?dTzqQpp5s8oylivRicadlM10l8Qi/MYnqsUol9HgOpj3BhOQU0Vzw43r5aUt?=
 =?us-ascii?Q?e+O43g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b92d97e-abbb-4af8-8e8a-08da009a7f66
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 00:27:58.9831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aUCluwAPldl3BOLwnN4dIxYXSC/D/Ee4O7z7dSEN0cDsAzBrcOx3h/3g9VjYnVwGesCnxzc95FEBKp0B71PEjguTnADrcbpxJ4/0WR75Z50=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2809
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070121
X-Proofpoint-GUID: AFwVm3kLPQssd8EZ6l9t1uuDQ1hdUZPG
X-Proofpoint-ORIG-GUID: AFwVm3kLPQssd8EZ6l9t1uuDQ1hdUZPG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For software iscsi, we do a session per host so there is no need to set
the target's can_queue since its the same as the host one. It just results
in extra atomic checks in the main IO path.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 3bdefc4b6b17..974245eab605 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1053,7 +1053,6 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.eh_target_reset_handler = iscsi_eh_recover_target,
 	.dma_boundary		= PAGE_SIZE - 1,
 	.slave_configure        = iscsi_sw_tcp_slave_configure,
-	.target_alloc		= iscsi_target_alloc,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
 	.track_queue_depth	= 1,
-- 
2.25.1

