Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9817BC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 01:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 719CD61164
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 01:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347566AbhI3Bkx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 21:40:53 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49804 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229477AbhI3Bkw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 21:40:52 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18U08Ob1031153;
        Thu, 30 Sep 2021 01:39:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=SoplooHbn6j4ogQH190X7aqxDfz8vcfRkXJpQKW7JAg=;
 b=t48oMnTkOyCQe/Eoq1fMUzdOxBF0a9T2036UFxXO/WogJnSN4AO33zy4mdI2fsA6LsaY
 Oxfq4Aqhf7qPEVtOPOxSXMn94HzdrUptQzmkx/b4XKI0i7ugXPXWTMu7g5s7q6HCK7hr
 qSjwIY/ltrNgeh3Y25nxxY2UrQq96R73Ipfc2fcIQd8yo/+sihhw2s21LTCqE0okXfBz
 FrkJa1Asg5tlu44CcwRhz26n/TzYDyZgLudKZ1hJku4ks+9UOg/dtJczii/ASuIqI0Em
 lKmEoIYQyFpSaJpuAQXknN4qUp0jLGGyPltTvCFl1UjwfDyzRmwrYvd1vAr6W2TJmrvm rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bcdcw38p6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 01:39:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18U1aBv1097174;
        Thu, 30 Sep 2021 01:39:08 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by userp3020.oracle.com with ESMTP id 3bc3cf4jd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 01:39:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsmySVpydREVyZ87Lkpbjqu3d7yhCUZ6/hcfscnTDWOmuwSu4w8RpuQsV58aOwHSs4PjXjcLannsNGKtz7ZuwyH/MJ8KX5OHtpkugHRu7q/eLvwb+/6OAOHWR8PBew1P9Pna5dLCJzYaQvwGRKnoTBWGPtQH6qZx+hf4loMghLF1aRDask5nyJwz+BMJIrIbOJwI3T4KTc1HDSvaRrh4Uiqc0EFjaeWwj2lgpacjVQ6sIYCBG73WQ/GGT7Z4BneFSw0c/NOe9LFTxJiW995SwJBcM7i2iUoP0XrodDiF6fp4hU7jiRlstBDvlco+KcC97ONZRZbD4cPyB67AUfKPWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SoplooHbn6j4ogQH190X7aqxDfz8vcfRkXJpQKW7JAg=;
 b=foAxXsYBglYHXjm4uERjhsn6M6SoE+/zpAPkAqaYYMqqctx8CRY3i3/1CQk1Imch/4JoLwl/Km2hfqdfq9PXSGFXLCjfvgVAm9+dWF0yEzBiNps63gajeKHNPe49csDPJNTT/uF4loEzsZeGj1qW5gLPJssNKGB6k5TRzZbHYBi5AIitZpdu5Y7B0Gdn5MbrP9cQT3Q0pp4f7JHj2rhcH0CLpDO20onY4vVh+m7mI///xOWZ2TkwCGIrdUTijFfo58tvms+W8FtdpkVFMfVyrP7bXWUeyN7Og+PF/Ye/IZzpav10jWnN5jweelbtkc6PYK92ROR2tPyB486bvkrgFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SoplooHbn6j4ogQH190X7aqxDfz8vcfRkXJpQKW7JAg=;
 b=b9vK6F6Qpc03LFieO2kPZitB+o9liEJenHZEvltjC5cxQoKTxfkgEj2UMLPfgRcvFBsJ16BP0QPEGmlLM622TwHQcrmAAlmUaOeub/dmGuobTDzQObzr505o4HJzlCu40Oxv49AwJE2bjrTHEEewM5V4pSvgXvGe2s3SFnkFdZM=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5166.namprd10.prod.outlook.com (2603:10b6:5:3a4::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.15; Thu, 30 Sep 2021 01:39:06 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4544.023; Thu, 30 Sep 2021
 01:39:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/5] target: fix ordered CMD_T_SENT handling
Date:   Wed, 29 Sep 2021 20:38:54 -0500
Message-Id: <20210930013858.91752-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM3PR12CA0072.namprd12.prod.outlook.com
 (2603:10b6:0:57::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM3PR12CA0072.namprd12.prod.outlook.com (2603:10b6:0:57::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend Transport; Thu, 30 Sep 2021 01:39:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 609e9620-7194-4b79-7531-08d983b31680
X-MS-TrafficTypeDiagnostic: DS7PR10MB5166:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DS7PR10MB5166BB307F198EA78F0E913DF1AA9@DS7PR10MB5166.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HJU4UNRWkr2Cu6l7TN1Ki7JvVzLb04hEAmfD5TCwLIhHByf0LQjQcXbcDwmc8tIwcvI2aJScm1e3V322sKlAje9mHHqtWcawx1lLlUY1BIDDx3wUcolM7YEkrS9TZFPESXdReSijyBkKExb4360rWFXiaTx+WzKXS3MtWWSupBM/W9veKhHKeTl5opRmcEMAOvESnPscVAheC9hnXeZUSeUZcgbv37SNkTGWeF0OFDZmeR+KNecmH2kSveJD0iK5MIh7DMgdAn6SiVQkcfwq0yUsxrT8z6rEm8IlH6Q2ojaCugdEdURktxZ+ka9yamIXy92ofU/RGKa/DeKL3f/Hit1malgsJ2CBGcqQPbfeBx80PTHrZJLk1jAOMC69smuvE+JxbKcz+xOGQM53qBzSCD4INvf4xdxbx/08ticPbKdXudMZtSYlVyjV+tJ1Cy2lvZTnsh7/jSoF4bwOP0RYbiCG8jdIzslgzOnHtnKqX7bWSQ2cnKCDFD8n6553qJsVuTWqTXfRLNSWxmVgLcxmhY1SzUYcSODS1nqDyJ1pkNygB78NnRrlOSymnzr9GDTG7wSkxFP0bbTnOLS333HFkXbY2Mgbk0eJODZKf7oJx6+Lehc6XEEDBMEyayB1MnvWbDDCPAhyR7JRey1AM28woxac+YVYlk+eHG55FAwWCiIoe6yjqYGE9U93LSzc+dMF/jSwk14Rjraj4qf/4vfmjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(36756003)(66946007)(66476007)(66556008)(38100700002)(6666004)(38350700002)(2906002)(8676002)(83380400001)(4326008)(86362001)(52116002)(8936002)(107886003)(6506007)(316002)(508600001)(6486002)(186003)(6512007)(2616005)(5660300002)(956004)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?at5xKzX4L9hdYxWLqJQzYqgYomsTAInCgbbJdN6xO5KBNkSzd4TDydpJccms?=
 =?us-ascii?Q?D+vo0VVeqQrRQ7ro6aGdccCuzr/GMG7vjyc8JTeHLlw0zC1UCkAFDIKljhXJ?=
 =?us-ascii?Q?uvSKpGY/e5Kr+CsjnCN12wmd8L9+tqkYFGK5Ng9KaRo44M2r5LKrYybV7gGl?=
 =?us-ascii?Q?uusHqbUG7yVCeNADx7pPeqDJsgXAQEBprxUiHmMSSeLP8Df8VNBl1uSC4613?=
 =?us-ascii?Q?BpBahg6IPsSdZyPOOX30CbTZAAxbGfyTDL+OerJanEu/xk9OWecNz+04xadE?=
 =?us-ascii?Q?Ec/0QS84tkn+iYhHZiWYmsUEAPZxG7KWRNvpF2+10Py9yY1bq+O5cB2Luwoh?=
 =?us-ascii?Q?JqK0iO7cIxuNFBqOH2mjLVGZES4Ce5OY7/NLqiSkyH6K/8kVGCCKEkTgxV/W?=
 =?us-ascii?Q?X0EtSpKwmyulspgDzPU1qyNYBuHUKf5FWl6BY+wiy9izf41vtuYecqBxuNGl?=
 =?us-ascii?Q?gppW9YpSIKqMCd/BRfinILcoF9yUxsu6F3tzVDb6KjaiHlg0DBrvYr1UqKIr?=
 =?us-ascii?Q?+PZT4kLbG6/77SyDYxWri/5iid1yupTM+LjJzlxYK6qIpuZUB7ik4BtLKyvW?=
 =?us-ascii?Q?iPjWq+X9Rlg0ZcupexREXVXWUm1rn+aRt9a9K7DtC2bD9lV+CHujrOeqjKFP?=
 =?us-ascii?Q?vNSTyS4JlchnlnLn2YMri3MCOETu8TihS1EfjsWA3FMCULHOk3JXP5PbCLvd?=
 =?us-ascii?Q?LpqmzLx5IU5ikPHXAQMbKqwzB/SoH5078tNQ5/1y2J5nzxXnMBL3iWRV4dvX?=
 =?us-ascii?Q?CDxhz+Z8RhkxGYoiPr27GMYP00fSn9er5009rl+1kl7Cp64aEB2KL3AYztXU?=
 =?us-ascii?Q?X3gavvgfdAAvy87L7jtMd21FXt0P1xfkLajDcXTGNqedxgnAT5yA8/rfAps/?=
 =?us-ascii?Q?3GWxUQnM3fPuOuHz7pM/cdXtAXShrI2ajuhLMtjQgwF8aZoQnedWyn+QG+EP?=
 =?us-ascii?Q?kP/A5C6MgkqCRNXcvT7jD+wlhzsT636+KE9O/y4k3RHK8/TZ0cJzupckIcjx?=
 =?us-ascii?Q?/ATXg680Z5hLO7xyU4Sstcov2tVue+nvx00PEnTQStReACwzg54nq8cEVhDW?=
 =?us-ascii?Q?/VIM42kfDTzQU/r0P06keGQ5YuPjzVFDB8/L1qlA4yRO09CHeesop/GEM62O?=
 =?us-ascii?Q?ZaaFN+hCiX4O7FDYWjBitQLJEJBqtQDPsgeCXoAKNdxkPDCzgHX6+Opv/FrQ?=
 =?us-ascii?Q?bUSBoVajX9R9PlmWUmiJ+NJv0C3tqast2+AxG/3x6DxzBl0iwIGL9lAmzy5C?=
 =?us-ascii?Q?QJEjTJekzQQPLx95MDhSOIjSxyTTEeqDCO6HXiUypzuXJYlK3wil2SbVhFBQ?=
 =?us-ascii?Q?XDfVQbX7C8xR1WZ0LE3O5dvd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 609e9620-7194-4b79-7531-08d983b31680
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 01:39:05.9583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EPKnf6H2/aid8VRIkTT/F1j85X1Ch47/woGLZmrspC1pZrEfqIb1KJQu32WJ0oqfc1U3u4kh7ZL3K1TBYEmiYW9PJaThUctddBTuubTdBPU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5166
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10122 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109300006
X-Proofpoint-GUID: 6Yue1oSbr8_oTXAbF9ZCLpTdF9EGhhyU
X-Proofpoint-ORIG-GUID: 6Yue1oSbr8_oTXAbF9ZCLpTdF9EGhhyU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We can race where target_handle_task_attr has put the cmd on the
delayed_cmd_list. Then target_restart_delayed_cmds has removed it and
set CMD_T_SENT, but then target_execute_cmd now clears that bit.

This patch moves the clearing to before we've put the cmd on the list.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 14c6f2bb1b01..e02173a4b7bc 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2200,6 +2200,10 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 	if (atomic_read(&dev->dev_ordered_sync) == 0)
 		return false;
 
+	spin_lock_irq(&cmd->t_state_lock);
+	cmd->transport_state &= ~CMD_T_SENT;
+	spin_unlock_irq(&cmd->t_state_lock);
+
 	spin_lock(&dev->delayed_cmd_lock);
 	list_add_tail(&cmd->se_delayed_node, &dev->delayed_cmd_list);
 	spin_unlock(&dev->delayed_cmd_lock);
@@ -2228,12 +2232,8 @@ void target_execute_cmd(struct se_cmd *cmd)
 	if (target_write_prot_action(cmd))
 		return;
 
-	if (target_handle_task_attr(cmd)) {
-		spin_lock_irq(&cmd->t_state_lock);
-		cmd->transport_state &= ~CMD_T_SENT;
-		spin_unlock_irq(&cmd->t_state_lock);
+	if (target_handle_task_attr(cmd))
 		return;
-	}
 
 	__target_execute_cmd(cmd, true);
 }
-- 
2.25.1

