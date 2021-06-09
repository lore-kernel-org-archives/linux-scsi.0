Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A6B2C47095
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80EEE61263
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236555AbhFIDls (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 23:41:48 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50394 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236534AbhFIDlm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 23:41:42 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1593AEFM041117
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=3BLOlMMVPfGobjjqcD6snRjxLO0iG1eCeDb7vauw1Pk=;
 b=qUyJqEPuNqQ30y6QhWUmaUlUut8dOAtNtxrAivzjv3vcP8+sAQ9EjfYO12QjjJ9FH/l1
 SvRUD9jV9A9W3TF+9UwHAFX3kBsxRTwFPp9H5IxOpZKeyf/+qYLh5lOuv0aJwI3RqbBK
 r9qXVE3TJmO0EekSC7nvJIny9PfJYdcPMyO+Qp7jyymScL0hAKhM32/qvQ6yfXv4m951
 PzrWjCerNURBR/z3o+EfBZZtEUDQQptlGzdp9uE+R/VcupF3MD1lNHTIG4wGs7Pem0wi
 8VYp3fmXUbovfkhVDNkIOlj2LWYpBMqwK6ZhjxnhRXPE1J4tKSyBD+zGRoqrjAXbIZQT mA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38yxscfte5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1590Z2Kb082667
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:47 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by userp3020.oracle.com with ESMTP id 390k1rhr3f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OTfxK+MSl36oZopwKOvKZmzNY8Z9pfDAEcuZbPUtDV0C5puwgf1/WdXFa1w1eWKiU/vyDjkWZsY3ReUvrimHfAQElrUgQgjkH6O91letetQmcOF0v6hhr3/rQdKC6VkPxLU0TzTjxMTO8gWx53ahUCeT3XowCIXQVBXMgsE3r30kR5HluKvNDiEptoN0UPqfvMFZcTTGDu3XKYxHDw2NiFeHBk1L4FAvSb3Ion5IeJ82lRETH6dTfVbpowzsQHJg3CviRig1wgQUcmfDk6gY66udQrUD1iDfarerwBqvwPgsqHgstrug39yisnEUXhJoOPDxMPTnzuskGAR9hoRu8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3BLOlMMVPfGobjjqcD6snRjxLO0iG1eCeDb7vauw1Pk=;
 b=Rc28tRO1E621fevN/wMyrFpE68Q/Pzi1xe9wLiKz5N/KaCMLShPmGvG3qz6GxDMjIdbAxDd69HAmYKlKyqBmF6bLdemY0waJp8pZwn1NwZcVg65D+cMDDhYOn1Apwto9iHp2EoWY3vg8ImJQ3bu4Aawuwxxhi0HTya53gbDUlwg34KmyxqfNL4mzGUHkBkp2Ox0RbsHVpHgYPO814E5ycmbe9+QgNKEwUlaClehVzIlCTuJhUqxjnUowmYkBi/YwgJ93TJlGtV7lPq6WE2mYsJ9Fmb1KgUs01k0jUb2DGPWTqwUHDiF2u8eD0oRQhWOgNbHHeAX/uyPqQ9y9Zg+hpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3BLOlMMVPfGobjjqcD6snRjxLO0iG1eCeDb7vauw1Pk=;
 b=IPLHWL/Mw4UbUFIKD4fntm8IUEdp7fnip8ax/KVhiko+rxTGyDS7/MB7POjxFLZ6VFtXlHm6wUepApStA7Yfi1yw2qeSNQKrEeEU0DfME91GlmqR2QapI0sXjJJHnFiZqIZmj5qicaq6pRrCwlRtpqW5hSiVSV7RlA7YSfdQuIg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4421.namprd10.prod.outlook.com (2603:10b6:510:33::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 03:39:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 03:39:46 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 15/15] scsi: ufs: core: Use scsi_get_lba() to get LBA
Date:   Tue,  8 Jun 2021 23:39:29 -0400
Message-Id: <20210609033929.3815-16-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609033929.3815-1-martin.petersen@oracle.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN7PR04CA0034.namprd04.prod.outlook.com
 (2603:10b6:806:120::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0034.namprd04.prod.outlook.com (2603:10b6:806:120::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 9 Jun 2021 03:39:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5adef228-ac58-4566-1114-08d92af839b2
X-MS-TrafficTypeDiagnostic: PH0PR10MB4421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4421EBFC95806DE1757727A98E369@PH0PR10MB4421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FKkFJkrIArAAysWm44G4gM9xU2rwvZdqmjNitJ+scMzaplU4tYPsf/+qNu3dU0bx1NiFpNEbbdDB5C53C/5iGNhkg7DokUhwk2vHqBi3gP7J0Z6rpbbE0gnNjdkqakhm5Vj2oExdE70oEGGTwfP6Sxo0k8GwJyCU1cTkF0RXVLMbxNsR2Rn9yApahnmTl+tJgiaRrRsj5qAYeutHikCz1tbgjy3AIfwweRNmmND26mbKFnkBQPIhN62+KmVCT0X0vHzdkm19D8Z58q2nGC9/gnc3hKsp/xB0p59HZyPj7lOpsssz1Nrl5ZSSlGWXScv5xhtnylK/FxLO6pJLb54AVFhrD+1HvdcV3o5dqQpXHmqdCRXoM13u7ohDPryB5WP5s08JpaYpqRGB5/9zfHrQrJJWC44SU1WzlyrS+PZZDNYNbBEN36WhGRukSQdUHLLwFMjN99dVXLm7+/UaI06xCgRl0QHCaAzyUpeLggUTESx+1R405vImQ7XiydaGg9VQiIappY2Iu43EUbhxwaWDSWdJe/dwCdz+SW9K4k5GDh8QuW8jckLBiDSlBdbtnTHO3Pm+lJO6mXgfYAGr22Y2ebj8IVJ4+Smhb3aBY7L+PJTgTx3mK62JlG2Feh/yuMANHiUOrBO3iGsDTmmiQhZLsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39860400002)(366004)(136003)(8676002)(956004)(2616005)(8936002)(2906002)(6486002)(107886003)(4744005)(86362001)(66946007)(52116002)(16526019)(66556008)(6666004)(66476007)(6916009)(83380400001)(478600001)(26005)(186003)(38100700002)(7696005)(38350700002)(1076003)(5660300002)(36756003)(316002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tROskTFAJQ8n9zk5DnjhNMTz8BAUL8jQUHdUC25ClDzloCm6yITca3AyPibH?=
 =?us-ascii?Q?SdM4fzwkjq27QyVgRakLwR/pZx/PUuyM/9w/42MY7XgrXuQj7Ofp7rvsAsn7?=
 =?us-ascii?Q?i4SaCfK1Da/KOt222/Cdn9Cz7bvNjfgAvgJE4itRGEqIBrfE9Os8DSA6MeWr?=
 =?us-ascii?Q?WCHK/veCR3c/ViWq7J6HI/L0F+jTNz7ar8u56qm7b3mqla+fMIuJ9fKDFnZ8?=
 =?us-ascii?Q?p4adFwlmNAVbkzvE7PIB8EU5B0a9y9QFa9goF8mfNftBkx5hYJqxAbUMW5hf?=
 =?us-ascii?Q?HUIMt/+Ydp4Fs/GQU7HjWxifUdnyK/hlmzjf6TiQ1/lmy2XPPip9IhpsJiCy?=
 =?us-ascii?Q?/Mv85deBj2++vBtmNFemfA3xfSQ+bMY3Xrydodjr2gIa3Dk9x8rgdGoBbs3N?=
 =?us-ascii?Q?X/irkGcUivZ4GrpcGTlLuPkl91EnXbHtT75E9Ku6ArQiXF0W1B+7KZ7pJxo0?=
 =?us-ascii?Q?KkJOhtRJtvQsItSR943LGlJISVEvWMhWC3pGjQfRnPMbpqrXAdUMRsDR0DKx?=
 =?us-ascii?Q?YYu4ymJweo+YgNBxx0wbxgfJsgbplZzymx7yPAegOZ/wYenQbv30ZClx3y1n?=
 =?us-ascii?Q?Qnr+B1S6LXCrAkoN+0X0AV6MckUk01s5KgM7vwUH/aqUcxoO6OCe+aTdruqQ?=
 =?us-ascii?Q?SchYhk5XmReCbzoTHcWZaKD197Gy9HkOQJ/IxUKA6udeD5ARsV68M6fWYga0?=
 =?us-ascii?Q?5IG9eJqwes36R1zMsgWHQZBhkNACdgDZaV/jpvjXMqKhGtqnFkR/4pSIhkaZ?=
 =?us-ascii?Q?dXO7/S5z1hN7hF9bAX2WJI8fsIf6GTfD/nd+OqTViKqOrHvUt/MpPxW6uxMA?=
 =?us-ascii?Q?ehLCrLbM4156pTAOjNlEIBbAmXvZEmP4j1UwLHWY3+rbfsuqQneh5/vYiR+b?=
 =?us-ascii?Q?EWZgCr5qc1pyDR0Zo+cITcRGxds6rVe+vwjyFsHS26UnZeT1JWRbRRvHEu6T?=
 =?us-ascii?Q?vBr3BKotQ1xYytAl7hJ/3yWxVI3GNgtEDqIhJAlRLWlR8mAwOznLrSyaNCWR?=
 =?us-ascii?Q?yFXfUvjwdzpxMh1qtEs7M3m0n4KcL8npXBsSrnIjYgDmIyg0Xo2lJXR41gIo?=
 =?us-ascii?Q?edpr87SHTh4ErqN4LyW0sQvhPfxMgKMiYAcXBb+AB79kYPhz4iy1aqK2veNA?=
 =?us-ascii?Q?p9k5KB8pWU7H5lOmWSBSH/u1z64CSKiUDJQO0fHjZDVjQushjUL+SLWB9PVt?=
 =?us-ascii?Q?yZbD9TZ13oMXMmNxwWDah/ez95+2UAjSvDe/roMM/1IMoh0BBlibIo062BIc?=
 =?us-ascii?Q?PPpDLK5U9UYv1+lkHTVbs2AiKV4jFF+CSipto4FcQ+7+QAi1XeEknvRy1RA3?=
 =?us-ascii?Q?snsTK8bA9svFnRnPlQ4SHsJE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5adef228-ac58-4566-1114-08d92af839b2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 03:39:46.0869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xNcuRj0s7yXD5ggILoHs0TXkAqtz8RxGG0XApJtDOplpY3UP3JY19bkcrtmyXeDar6MQWWvjI+FM/EjwbwoPz9o/qpBcDVyHS2P8cHE+EeY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4421
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
X-Proofpoint-ORIG-GUID: jdAYCRiToxvNYHFCHWYghVuaB7IvhPw5
X-Proofpoint-GUID: jdAYCRiToxvNYHFCHWYghVuaB7IvhPw5
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the scsi_get_lba() helper instead of a function internal to the
SCSI disk driver. Remove #include "sd.h".

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fe1b5f4b586a..beb52245554f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -25,7 +25,6 @@
 #include "ufs_bsg.h"
 #include "ufshcd-crypto.h"
 #include <asm/unaligned.h>
-#include "../sd.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/ufs.h>
@@ -390,7 +389,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 	/* trace UPIU also */
 	ufshcd_add_cmd_upiu_trace(hba, tag, str_t);
 	opcode = cmd->cmnd[0];
-	lba = sectors_to_logical(cmd->device, blk_rq_pos(cmd->request));
+	lba = scsi_get_lba(cmd);
 
 	if (opcode == READ_10 || opcode == WRITE_10) {
 		/*
-- 
2.31.1

