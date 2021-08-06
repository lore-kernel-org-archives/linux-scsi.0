Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF92C4338F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 04:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 634DA611C9
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 04:00:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbhHFEAt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 00:00:49 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47404 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229512AbhHFEAs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 00:00:48 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1763uLwK012166
        for <linux-scsi@vger.kernel.org>; Fri, 6 Aug 2021 04:00:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=0phGnDR2sPMsgD56EscrYTMgFcVYc9fu0i1/boeGhmo=;
 b=k9p75s/eN4VqVPT80ebQt0rI4ZmZpq7Yh11jebY9p6HK5qR7WyzqaHWpEu6SwS/Zx4s4
 mVE3Ot5NOGdAV964w0lKMF9RnLRws1sLO60p1xFOv5QxAELj6lpqfIOCRUG4LSL8buh0
 Te4HjNi1nc1jKJ26Xz5AmA0c1APpM/+5tVj3dqT/XcAzQmVcw9jdfT5aJMyb9JB0mpcT
 3cBirzPKQOjEritzo47EODaaOm1qWxIWNVJG3XarCtzy4N4vKZEKPp1ojxRqfBH7NcKt
 xUuN70t8MAnuijMRaHSOB5Tx8Auzzo+OfTRyexBgx8aPiSmOZjyvge7mdLaXGjQKp+3S Aw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=0phGnDR2sPMsgD56EscrYTMgFcVYc9fu0i1/boeGhmo=;
 b=nmNuKF6Db6u3LMPv4qlxNJSSflQU2ZZKW1yDva6RvagrTJh3LyZXNVYLABx744dr44q2
 Q+fCaWWbRFcEDMyNh7fLMkxoULNFCHsvPpThj3jAwVZocXZ539C22ZgbX0Iq87pS+RJF
 YFXN+J0U4wFngMhMDV0JzdBMES9kcv09rTgToQUqB7OpYjlWyJE1w8C/nDSIjWkD7X21
 pLz0wzQ0C5O3YK+DyV4pCeGYElB5ZKpFjU9OjzGAdAJAN7julARnIBKD3EWHendJtznz
 R5+fQqjgjj0O4qSu6RjZq7meGudOtVwWWdQP87+h/yDjlvo/93IRiQHfHU4x0FH1GF5I kQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a843pay38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Fri, 06 Aug 2021 04:00:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1763tZHG085580
        for <linux-scsi@vger.kernel.org>; Fri, 6 Aug 2021 04:00:32 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3020.oracle.com with ESMTP id 3a5ga1g8hs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Fri, 06 Aug 2021 04:00:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgPU+q5XOru2+kkowAkOITNoB5liV/ZpGlOXIdEZskq0StB0tXee00vhrH1AR+/QcYseMh2JlWS8u/wfRHPVbHUfKLftx7/BuNBxpf99qJcPR1tPwXMzK3bM1w0cpz7D+ITJvojbxtVLqTtNhraWQWNFBHbE+EbD1U86rsSnkN8+wSdNkazdZbh4d5/XgbUaFMxB4XG9KnMqhW1ulS5tkGNZ3GoKOFIysMaWQx7t0KwWoFio7AtBJLMaFaPNowSK0L7H/qTCknDKHqOfXyJuS2PazYvGXhuGjkvciU1HdCxTUX1yUJkVH6T46lnGq4t4RDom6qhN+su4aqCb8EAvJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0phGnDR2sPMsgD56EscrYTMgFcVYc9fu0i1/boeGhmo=;
 b=myohatC58AWh6uIpJFvlfoGJZo9BT5d9iie/kbgb7x7YfW0JduoFH3iJKcsSuOeuHnTvM3qQwakDtvtgUJeX6dcy8ZScluJ1fJO6qErMT2DLNhl4YQfveqD31BWNphCA0l39KEPUPQ40DvZf5BKZFiNJu06Fqj46p4g/W+s5BDGVLXUC/XD2xK62ot/WrZUwVf0WEtDJ1CHRjAizwGvjNeldaSW7Q3ppmfIn9UpXfVixPv4ozMzElROWJkI18JLvhvRPn4qziLK1CgJMlzerrgIkYVBb4mctgaHtPvn6zga2LapUZhSkBg0wyai8HiICYAiFuFVYvNcdT8vsePVJoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0phGnDR2sPMsgD56EscrYTMgFcVYc9fu0i1/boeGhmo=;
 b=dynelaPJqJUI+3SaSt8Ndug5RwOTJDtA3Yl9TF/ri7Hu1ICWj6/WvNXtlSIPUVuWVd/lIGZBTd84w5vG3CKh3EtJ7kUEg8iyfGU8qUtbB6N8Xde6DgtAQh/Tmoc1veE95BWdWuLLUs7BU8/p47tI29zrlFtU9y4uR2iCeZ1er4A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Fri, 6 Aug
 2021 04:00:30 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Fri, 6 Aug 2021
 04:00:30 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Subject: Use the proper SCSI midlayer interface for PI
Date:   Fri,  6 Aug 2021 00:00:18 -0400
Message-Id: <20210806040023.5355-1-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0601CA0007.namprd06.prod.outlook.com
 (2603:10b6:803:2f::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0601CA0007.namprd06.prod.outlook.com (2603:10b6:803:2f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 04:00:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9367281-0ba2-4dfb-916b-08d9588ebb41
X-MS-TrafficTypeDiagnostic: PH0PR10MB5515:
X-Microsoft-Antispam-PRVS: <PH0PR10MB5515327B61B34A8E087F42928EF39@PH0PR10MB5515.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f4Bg+ffehfBN73gGYmJ0FZr7R5tThJJaoONdGmWfllmyFsMR5hEGvIpvQC4lQPfSLv0vHrgETndwv1UlQMIQ6GtMtdKhCZ47PLix7qURkL1e0HDn7Iv4RzFs35gvSE1TRgf1YcjncGxahebSmOlFZpiXCzYCJHCpI6F9Q3E737D6v/RRKjaoqJ1edypbWFJ7WmZXzY7BbScS24I+YKJ4Ncohn5rZ13svVqc8eQZJ2gtTi/vVqUrA64sTgIp98Njnd2524Uu/d8q7H2TOh6b2MySAdXUk37EEaaECGRZsxOZ3bs88m7CIihvlADZDSQaihdKLdqfU+6/YcRmS7VBeLy5IrP2yZCTexp9cbrovUREzBH6Fz92DMxHCnsVTP5jYe3wqBSK2yAfOCBsDxdP/yntl/SYQedsNVxBKxqksBX38rQHs0uGEHb96gkBNKL7+Kt+ORRLMpRfadoIMn0KVh472Pkn9B5hTY4r8700D2flISdYVY7V+JiLTT0mBgm8C6qnLuTYN8j9Y74aa87myJn8yFKbxZ2dFRlO3EFnN1x6P+5eOtq31d81m8qLvFX/YQVbhWaTi7na7W9WPAz6tqd024kPmIH8KGYhpPDqpw7kz23iPHsjTNmOKweR2iyVsqzqHtXyx6ZA2V0yanocjSmZSdKmif1aWzi9LrcQuqtvlrAvZNnHEbwhqk5xXWgKmEfHVQu27kdvFXOaNtfQlUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(1076003)(8936002)(66946007)(8676002)(186003)(6916009)(66476007)(66556008)(26005)(6666004)(83380400001)(38100700002)(508600001)(956004)(316002)(2616005)(36756003)(38350700002)(2906002)(4744005)(7696005)(6486002)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6qJ1cakE2u8shfW2V/w0SPIhNJXw63a8gT5Wn/QzGGe5mZe2CWg7EpCYkw0p?=
 =?us-ascii?Q?UNGi+O5kN0cfNKXEwpJF2BSokK1H/hS7rkjJ6NYHYQI/1o2fZS0YYzv7FX+h?=
 =?us-ascii?Q?fEVYQCg6TJqsWvsZCv1oP5sZo6z0PT+VtU6mw5QXYC1Hb3Qvq4QcUTOMQB2L?=
 =?us-ascii?Q?enxfj/9ByCsNtMTnUo1/SQ7wZN78RDrYZajvmJ8WUmtf0tCxnOP667kBzkOn?=
 =?us-ascii?Q?/hmUqTPQSRL3sdofxwUKYzs90DKkDhf2TwjmCkbEkTl0l17e8uQGyufIvgyX?=
 =?us-ascii?Q?rMsnsf0Y3jC3/xfasDtvEmqbYjZLyY90Nc0wRQyWEmRwLfdxv6AiClbKXo5j?=
 =?us-ascii?Q?o5Cav3gzmKrv3w/2fBF/BOPVtkZD+BY8IUIV0b8Nllj+7VsK5k3nFtMOikoW?=
 =?us-ascii?Q?+pTKGiRGPfHA1Fx//Mfn1V0N2wzs4lxYoU9vXt57vufGzbLqtTb4W9KA7pWa?=
 =?us-ascii?Q?IbuNqMnC6AjS3KwcgbaG7kUQ8DlvexmDmq8NWLrSAk8cXmvHjBXq8BbgOLCg?=
 =?us-ascii?Q?HLC7+VRM7VDj/KhXcmItsOoGcg48a1BJ1LhIRu7wTCfzkSc1KooAMZe3pNyI?=
 =?us-ascii?Q?hyWaFwnYPuUtplBgMaZdFFtwivTbSRN2nGRO/CjcsWXylyK4xWFik+dJqUBm?=
 =?us-ascii?Q?2SdRrWZbRSGCx45NZ1guCmElOkjjsZrsDTq1uSnM4QeyE9f5BFYhLBdanUFk?=
 =?us-ascii?Q?9Nd0gZxOa9A5IYIJnhnFgubtTGiyQiv0TPROVPUHg8rhPAjVIRhP2bVR7yoD?=
 =?us-ascii?Q?Wj3nvATkiAEAy8VqoKuh2bGU2F/RYHNoCkp2JalwD8rF+B8BrlDnE+X1S5jj?=
 =?us-ascii?Q?nRYfbKlZbn7eh/Am1PjKUMdcC+LuKYDUNjsQU5ub38cgDdPyBVz7UVlZzDt5?=
 =?us-ascii?Q?XabVVJQVEMkID9kNloB8HDklaIaHCX9zAatFGtY1ndAkFDTGIMX/2gH7ku2F?=
 =?us-ascii?Q?UXUyb0+A9Wf5U3oRzq7JRdkqqAHmqG9dbV2yTDBWhbPmZMSt7nO/zgoyMGrT?=
 =?us-ascii?Q?ZQKJQgBIQGQytLeIAf+8oW2hb2IMF+SXU7iesm7WkXXqwBKQaGs3QF7BA1TD?=
 =?us-ascii?Q?H8Q4eED9+zIAQ/oEoGbRPWyX2+Xdt4rqMG7lHDfBWujzOitUkOKMcgXyY0ll?=
 =?us-ascii?Q?oh+I1X9wLXgVbeKIX3EmxS0CoU0EHm7pOzZdHex0XvsnHykPcOG3JAfCQUp9?=
 =?us-ascii?Q?ARLoQYMHbunVFi3ZOBKhQ2EROrLk07tyEsoU2WCaiadYuWKhZkMPR33hNQiE?=
 =?us-ascii?Q?tIpJqE+HQO9xVtH5v1lXqVCZHgupAnsnn7FV25f6D+Xiw4TMbiu0SpCBITyB?=
 =?us-ascii?Q?9U9SNp1dK6lubzbMMr1FNV5A?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9367281-0ba2-4dfb-916b-08d9588ebb41
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 04:00:30.1973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aWr/XCXgK/aCSkrvZn892ePcx5lLOqrepKqlsea4OpT0v3oIYHDx7N8iRbu4l/8esPSW3jSWjiga+LS8pkIwGxLMpX+q7OpeBtXTBhoJhr4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5515
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=572 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060024
X-Proofpoint-ORIG-GUID: CvM8jR7QlWsblPDbWQ8txQIkpWOEf4Bb
X-Proofpoint-GUID: CvM8jR7QlWsblPDbWQ8txQIkpWOEf4Bb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is the remainder of the PI interface cleanup patches which remove
the guesswork about what and how to check from the low-level drivers.

There are no functional changes since v1. I renamed the function to
get the logical block count as requested by Bart and updated the
driver patches accordingly.

Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering


