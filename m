Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22329C43219
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 02:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0845861875
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 02:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347385AbhI3CGV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 22:06:21 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:46338 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232383AbhI3CGS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 22:06:18 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18U0LepK026125;
        Thu, 30 Sep 2021 02:04:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=SoplooHbn6j4ogQH190X7aqxDfz8vcfRkXJpQKW7JAg=;
 b=pozzxHDM0VWFXVT0MHXAehcbhmTVWiNlMEGH2U9TK+KRLnRgpK9511guvBPRPCJYVC0o
 tzpsjhMHCiHKF3L43UM+mg40owKSK0OavcnQEAmHTWdEVMHj1B8P81SR1+JM45JVc+2H
 ay0TN15FC4lnI2YrctLHEtdKeprOUY4D9UiI2VcYX93ZqUVM1X8YXhfSs+qOJflBKf2X
 JGfZNfepDt0hGT3gtmhqT27PvSa+jWr/NJP4HxTISjaw80bV/7ygU33ACbjopSQKP2F/
 414sgRV6sl5z/Ii3xKk+77+BGu57fklRyB4HtsYxVYvtHDldR6cPWeK9pm+mcjEdtlaS mA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bcf6d099w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 02:04:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18U20UQf108324;
        Thu, 30 Sep 2021 02:04:33 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2044.outbound.protection.outlook.com [104.47.56.44])
        by userp3030.oracle.com with ESMTP id 3bc3bkv6f2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 02:04:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wd9lpV+xU1CG7fL2KCrUFzgCOiogGhp1NUC72c4BAkQJMi8gXOw7WX3PBp4tqKyrcJyXCtwRapYks3SLDzW4SY9q/AzpzouQxdFsJGo3/obxFD568XXzlhopQ+uUu8Mi4tNEXc2okruUvVX/XXXoa6yMB48Fs84b+TGtbTtWKcFQTDmFs1LLV6318s5mCwvSv7agcN65Y1G345i2+ocU4eWW6v4Wa6/a2CmvAw1glHuFRCXUyxi67yTnbqk8ht8QvNizV6lZc7AnM38nkW/PzBlFEltmK115QP9MKD4CnTYbCPehwffO3zDqCEyRZcLhw89TljHN20WLtQ7YSAA8fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SoplooHbn6j4ogQH190X7aqxDfz8vcfRkXJpQKW7JAg=;
 b=K5cIPBVat8vbbIXJzwzzMiqfWP2cV8PkVm/g9z1B+hxMuF2Juwdq6A0hDbt1w90bESNGNP4kZehFYfSfkKyzu1WI/jAeFGRM233WXP12FrXm6CBGR4Mqhz4+CfjHGiZS6bSk9/wMRHtDM3y/93SjBM43jRE1COSh/hNJ8hcZV1LsEF0l+alPHnshUsQnBm2xGwBP5dBtVCdEuBR+Vsasp+Yd50orzBx33A2SG6Nqxf1sFyN1IOqIGAk1Jxp9FJD+j0CSGD0bUuAG2H+uEh881D43NXzdtqz7V5JLDCpp9N30QH9KDQlDwByQ70a7J66ioL5avfCcJO8O4cJrOkGsAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SoplooHbn6j4ogQH190X7aqxDfz8vcfRkXJpQKW7JAg=;
 b=pW7h+PN9c20RpAUuK59v+LUa9IQX8S62VoRD+LdMYwSMGRCY2xBST4JVqfoyueYg9Y48FSpSbFPK1QqIfhzAs4UgElnPwUn9GQY8sECw72x+nfPDk3Mw2Cd8y1Ue9BMpUhM1N1q6GdNh4Prb3jk+CDJ8IudpRwqg+qC7j9urmX4=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB4909.namprd10.prod.outlook.com (2603:10b6:5:3b0::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.14; Thu, 30 Sep 2021 02:04:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4544.023; Thu, 30 Sep 2021
 02:04:31 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/5] target: fix ordered CMD_T_SENT handling
Date:   Wed, 29 Sep 2021 21:04:18 -0500
Message-Id: <20210930020422.92578-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210930020422.92578-1-michael.christie@oracle.com>
References: <20210930020422.92578-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0159.namprd07.prod.outlook.com
 (2603:10b6:3:ee::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM5PR07CA0159.namprd07.prod.outlook.com (2603:10b6:3:ee::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Thu, 30 Sep 2021 02:04:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c98598e7-af74-42d8-6d80-08d983b6a443
X-MS-TrafficTypeDiagnostic: DS7PR10MB4909:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DS7PR10MB49092F3F23D2421A136768D7F1AA9@DS7PR10MB4909.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ipKZcdpLUQTkBamRvwqhCgeg66MaG/4WAt7ACs7kn45Qx9+Cj/cU0V2RMNMDlnnbTLCnWmycxOuh9FBwXzOL2lDN1vywK0+lo8pyiHofOO0defQCeKJzn2EoubExoGK1kvjQok0kpS1SUgAH+UZjJBusJgyhLYwmtn9ne3TURxWj3e+64xlEoBbjdWkZwkLK4rmMO3vJMHOczdiVkJUXRW+hwHv2jwr1ZM9QPoK3MmPeqznJTw6mHGRYzING/Cmjw9vi3mBB3X9fYtf1hPtWqT2oITW1D8DfEzUma0dKwTtjmJ3lNPBcpwGlEhqrm3eoKVztKCQDqiBMUL23QF44hf6DHxlcKH7J/PJIHfSkII6x9D9giFKp/fb8cbWGRS54OwigSZoacjvTTw3MO/Pp6CSYyrIp6w3D4WNBXcD5FCyduTDjZ3wttbnZIqYD6cPCniAYzhv2jBLZS1hXIa/ztlKmeaOQJqDW6f+mbvmmUebXM6acEhXlq2PSuY36c0kbeT55qXR+N7b98vw0ZtWIkI3hsG161NSTzXdlgEG4oWeKahoSl2YDWy2zjS9ltQxF73nQLwigGiqCqCRATRiLhCTpiRiRcNthOlKFrt9QeT1uaIa7pXQiPDO6dVpFFh0dUP0ukPi1Mb4anEbtGbtflD/wZ+zWWc266lDCMHc1Fjh774B3MmM8TBYwPmOziREFT7p3pr2iTdPJyNsGNkxm7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(956004)(38100700002)(38350700002)(4326008)(6512007)(6666004)(6486002)(8936002)(83380400001)(316002)(6506007)(66476007)(1076003)(107886003)(508600001)(2906002)(26005)(66946007)(52116002)(5660300002)(8676002)(86362001)(186003)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WH9/sDj+EE54lb+ft9DO3SeHkiS1LGqd3Xy0GiyPGgHVRAfEPi2f8FwzM1Og?=
 =?us-ascii?Q?lxmgQkeeTI3ClewZTzC5DF6DgLdFSkUJb6G6/RSci/YhSPHW5rC7vmMqCDdh?=
 =?us-ascii?Q?YpaJ/EUyaw78smEXImx/qwTERr5jLR1F+6nbBIl2E8qviINorch0UKbK43H1?=
 =?us-ascii?Q?oiGVDnRtKXyyTxXNs2aLZW+JUdll5lxgjHOlUFFf7NLelhei4VFVEUAWzhE4?=
 =?us-ascii?Q?Yy1wgsplDRv6E1CUkRwlpFgliP9Bz86DM7I7kHq7NCqfi691d9PezkKjK7UP?=
 =?us-ascii?Q?nZQAmVyQDx3umOme6+2cMndpYRtNSmT01VwP1jLAfvMV34CUXh11GLSXtSVs?=
 =?us-ascii?Q?N07mgsLVmI5BFnxRi2tCUDrXlXamBOIq59+AWSxLiYM258uVBqv3t61cOXZ+?=
 =?us-ascii?Q?MPtHGPPUDUeylRlyUGsPJa7WHObszLSpRhoHA2dM0PPEaBjQbRgj7yAWP0ez?=
 =?us-ascii?Q?nUly10VN+FlSRPphEjkikvZ1H3Oq3ayvAiRYn8oLohl0SCz9Z47ofseMrHYm?=
 =?us-ascii?Q?/9N+/tXNZY4mVsHn8g0LSIUrtxDE02gVImOOpy9VTVEJ2EoNY0l3uVsW1u5H?=
 =?us-ascii?Q?NmtagHjz6daG5Hl6xPTJxFa0YG4iBXGf4yvz1/oE+sIuB5QmyrHNnc0UkNoF?=
 =?us-ascii?Q?XJjSWSJ7vlIQEn6eE4MKt8U2kaGNvl9aPUDdbmYKlcQ32bugKeZVy33yZuzD?=
 =?us-ascii?Q?lz9fJV55ClDhvmvUrEchWQIAY2CPC55xybIPy6l4fKF+xldtm2ipDiKRzosy?=
 =?us-ascii?Q?qgQqevWI+jI3PynTUAutDNPoGXbUZlrx0iwIrPQrRLs78JZr9ccNCejbMFE2?=
 =?us-ascii?Q?1ZB0dAeQH5KbTKju5hr2CseINByrE28y6lS8QsDWNvkXLZdqCeRcboRrZM/K?=
 =?us-ascii?Q?t+ByYU33ocDbfg61AXcgFsxroa1Bff/CXgdgUZinKbHM1H4rMEPRb9ETD9n1?=
 =?us-ascii?Q?HKUT4d4XnIx+jEDOUxICPrWvj86WOe1BQfo3pnzlR9NOiCkmDWNkKB06OGdi?=
 =?us-ascii?Q?aNsXLSuYzHvhaisukp4C6//LecQAPtawWmkOPtsjITxChKEVzcP/I4EvIK+3?=
 =?us-ascii?Q?m9qOaLt9Kr+8UBNGtCtQtIGImkVDQBotHKZYsjfpVhONLYDcSxVDpXJ8sz9l?=
 =?us-ascii?Q?1TCtxGiyycrkTXHKY+bpR0E6d/sHMg59Z2gpWTcw+ChHlfhszvqGEDTEYRqZ?=
 =?us-ascii?Q?MYniwqwBDrI47IUXBiYBN+Q9uhAwQKAbPWwHspMQoPWBfY+9EgRYgpKKN4EM?=
 =?us-ascii?Q?JDRDx/R+FetSotrX7zVRbQcP4MPfWQEAfRJakNP3ToKyloB7SHjRy2mc+7d+?=
 =?us-ascii?Q?5iqHsx7FnEWxfLYmgsaK0p4h?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c98598e7-af74-42d8-6d80-08d983b6a443
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 02:04:31.4533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kv5V8Rf3KjHSxnELuMJyK9fZ2DmYadntde6V9Y4kvk3WLevSbqoWydzEeP3Ds8dCYJGYryiySOY8nAQD8ps04LS4H6ig5nVaPfR+kPsjUEw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4909
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10122 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109300009
X-Proofpoint-GUID: qa3192nd9AQLbPIAcd8jaEvMNygSgiHB
X-Proofpoint-ORIG-GUID: qa3192nd9AQLbPIAcd8jaEvMNygSgiHB
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

