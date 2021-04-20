Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D896BC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FCF961360
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhDTCa3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:30:29 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38600 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhDTCa2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:30:28 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13K2P2bj092511;
        Tue, 20 Apr 2021 02:29:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=vlaima6KFlLqGI0WBekLGcHgaSOJ3z2ko7jFuuh9Lys=;
 b=nslbhcVKfxukigqZRE/JeASaVE3OqKtzfpRNBJMtJA8c6DLPYV0Ec8Tw1Z0cZs4hALTP
 nCdFAGmcuO1T9mE+L12JBs4aqgxYVmIxwlRB8kadiiy27TSeTEOfPisb5MJIGrnvKfl5
 D4ho6eX7g2cNzcKCfTWea4Vv25jLyZkR1ta8+v0Rb1Pen7DAMbEVtMpVNEYBvBy5vLRZ
 K4v666T3mrPVc0ETkQ0rGCDHRLMYcg626ilct56QCVDMLTEPms7tUTSTwBB7yqUAhsIH
 JUB/p4eu0g4hiscHjOFG2bkSYoqmd3odoyGLE+3OCS6YUDkzvFOcJN8FEN/StN2UEZbN WA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37yn6c5nt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 02:29:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13K2OlCW044732;
        Tue, 20 Apr 2021 02:29:21 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by userp3030.oracle.com with ESMTP id 3809kx9x43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 02:29:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AUNcBMtmuHgxeXGRHx2ADHD0SPSgUMMwy34HvwVQwejedzqWjpbUcV+xyz4Tt+0x1AxOT5daQQldkeVcIHar3daWnQHzLwl1s8SY4QoXmU9oHJ820lOFmjnuOEH72k2QUeB7Si6qIYoV7G2gA2LGyXyfIMdMkmzZ5/nOwd2kYeenQXtMcWcNWXeAdNFKGyYYX+R/3/R4fwM0zMkjEmIM1Z0XBdmd4k6NPDCJVeQBfYma/g6Gl2ZPILAxB6Qwx9sGupz25nyGvTiJhwpDHHSwhxAUCVxKnrOnAWxKP8tP4qCL0gg9TnxwRi4lJ4Ht+uYTf+5qHlVEkY2n0evtnrdukA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vlaima6KFlLqGI0WBekLGcHgaSOJ3z2ko7jFuuh9Lys=;
 b=aKI7U0Ih0+Ry8wcLdgVwBUWxMXhfElVTHLbW7oyabVVT2LRCz1BtOJN1bAcLrSr7cX3vMSpStKjCD31grb7gcoRkOW3AkCnEVy0wVQT9EvfbEn4on2pk7EQiRRbguTWWm2IL/wS6+fxmJ6gvmOnkmbcok8Wl2LoQgiAFPFJE0HZrb46j+LrI+jdK5fMmzGvMl7SkpdZYppWB1EGuLNpllq9BgYKR5VrLRj3J5XFO9mnvHuFBFGJ7DxeF9IBCOY59yw30zh3XHKK/97TCu8GuMbaa92V+f969ySfi6gaHEtPUwuj0ENCid7itF09mi01oyefSI9brMXf2wj611tLB7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vlaima6KFlLqGI0WBekLGcHgaSOJ3z2ko7jFuuh9Lys=;
 b=XHD9TDMOBSficNol7dXstnRqAwwzKwTyTIqxkFYnVjoWXiwa1YFp3FKWPXWEEn+Cfqye5ypukRTP4RwgEj6dUKd675k6fFRumCsnHDPqUrO5SQ5kzSl9w8Evz7przbZKZyedTXaYXbo3XUQkYTi0cN4gQC7KKv3Es9mmB27s6EQ=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.23; Tue, 20 Apr
 2021 02:29:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 02:29:19 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     POSWALD@suse.com, mahesh.rajashekhara@microchip.com,
        Don Brace <don.brace@microchip.com>,
        mike.mcgowen@microchip.com, Kevin.Barnett@microchip.com,
        scott.teel@microchip.com, joseph.szczypek@hpe.com,
        scott.benesh@microchip.com, gerry.morong@microchip.com,
        jejb@linux.vnet.ibm.com, hch@infradead.org,
        murthy.bhat@microchip.com, Justin.Lindley@microchip.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] smartpqi fix static checker issues
Date:   Mon, 19 Apr 2021 22:29:11 -0400
Message-Id: <161888563602.11594.16470501854942163846.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <161850488487.7302.7018870513204678832.stgit@brunhilda>
References: <161850488487.7302.7018870513204678832.stgit@brunhilda>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:806:a7::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR10CA0006.namprd10.prod.outlook.com (2603:10b6:806:a7::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 02:29:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 664f7969-764f-45d4-ed4a-08d903a419db
X-MS-TrafficTypeDiagnostic: PH0PR10MB4536:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4536713704DE07753A799F728E489@PH0PR10MB4536.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TJNrZSL69tT9WT6GakglbuBG2+aPkKLYJdjUBAGe7evkykeYZRi+vCh7MR3KsjxFGAJJzEUdAceqbDuVtSaEY/9w+IfwNGMNy6emIYnrpstmN486xpZSLgsnZPchgtrLBjXOKb0PX3hoIwz6x2Hi25gSqmhVN7G7ZOzCzITR6rlSfN8yHuCShujfEV9hycxAzyTHI0Av9nSJqb/+74Q15SwsqpyPhZuK/o35XkBQBXpe+hOIbGjbBhOO7DtDAvM0CfZtSIc7wSUEYOjYLJwiy+QhCqkqQS4tBwXbD/LgCK/3mFTEs1IB6CyrSPHA5Y1AwINcOqfb7RLeZ0atE/bbrJFNjeewbMHWESvTAemEzEZb4jor/dY93xvVRe3WzCszIzQO6S6FON+EBPLt1k0D+G0mMIfBRUl0VvlgLjthN9q054krHKAblywBouNFBed6P/R5SFitip1qXvkkOu3VME6rMoDmEUjhRnDZZkU6G4xIGWq5EuqgWHILXw+O1TVkJ2qsHEy27DPFG8paWVmo+NBBw2wC+cFXk+GQO+0pETJL3zzUwuZ04VFc+apmUQhVm/MsTzExaYoLPQ+wU4akIvy0Bvn5I0c6560AFtLxSqhv7MwY2iTd2HCwvZmq4k+EvwgVr0pnRkO6MRn4LsM/Z+40x2Kyu3MBdHBn6MhJec4QfGn2yD0DvA/dbFxp/vbYxSPSvBydxD7/oV3E5gcKFIB77c8Lfu2QEgrUUWkhC8xWvv9sXdVIBOCepH9Zp7Ws
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(366004)(396003)(376002)(2906002)(7416002)(38100700002)(66476007)(52116002)(86362001)(5660300002)(38350700002)(36756003)(8936002)(966005)(16526019)(26005)(66556008)(2616005)(316002)(103116003)(186003)(4326008)(956004)(83380400001)(7696005)(66946007)(6486002)(478600001)(921005)(6666004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bUlKRFpXZGc3WG00SVA3ZCtXdG1OVUlqTHlPYlljbUQvL1VoSWpaTjhFeGRJ?=
 =?utf-8?B?dG5ZNEIwN0FsNkk4eTlRZlNUditFQ3VUaitYYzZyYTVnRjZuaWxtbFZCQzFY?=
 =?utf-8?B?OTZ6V3hObGdIaGdhN1drOEowTzlrTHpabDBGZHpQaU9rMmE0Q0ZkL0IxU2JS?=
 =?utf-8?B?d3pzRlRDTGkzWkJscGs4a0c0M0JMcGVtRmlnS2VXL25vRk9lR0k2UGxWOThw?=
 =?utf-8?B?Q3RuRkhTQnFLb1BIUWFXMnZ3NVJKY0lTOTBmM3lMQTJ0VGhBVjZKRTJnemZO?=
 =?utf-8?B?R3ljU2VQUDErbEJJRGV2OWhqd2R5TENEZ2hwYXlSREtENXhhTU9iOVVMaEQ5?=
 =?utf-8?B?NkVEMWpQbGROdG9JR2R3L0RVNXBJbWwrcEpHYkJISkp0S2lnMFFucVJLVGxX?=
 =?utf-8?B?cUxEb09BQVh3YVVtYVI5aXJlckdjUEY3RE9odnBQajJ5RDJiZ1pmL3RITllW?=
 =?utf-8?B?b012dG1LSUFId3BDaTA0d0UxZ1hJNXBUdk56RmR2aXZwUC8rTnhhWG56VGxN?=
 =?utf-8?B?bGMyRXFMUEpvYkw2WW5kY1Y0ZDZVWnRtK1laRWNxMVRkR3NUL3U4Tk5YUEhQ?=
 =?utf-8?B?STh1UXFObU8zbHM1YVRKZ3QwZ3RyL1BEYnI1TUFONzkyQmZqZGp4N050NUxJ?=
 =?utf-8?B?QmRuWHZ1Z2JCYjh3Vkh5SjFhdXl5MnZKSmZLNzNiVC9XcEdBMmhLYTNyTkpG?=
 =?utf-8?B?a1dvekVZVWlHdk1YU2tmdTYzS1lzYlhNazluSkxWUTd5cmI5Vks1U2pZV0NH?=
 =?utf-8?B?TXlsK2JwTk1RY0JSR2RJTVFLR05WbTkrb1NBUVhaclFDTllwSFZJK0lxRlpm?=
 =?utf-8?B?R1g1S00ySE1STDdmMjZWMnJsOEVyMnZ6VkFCN1AxcEw2cjZubE1UTG1hUmYw?=
 =?utf-8?B?Q3ByR05Tdy9maFRDWVc4UCtCcWtEQ1o3RUNYQjhzczJobTY3dm91b1VIWEFG?=
 =?utf-8?B?MmZzaUZSN2ZaRDZVQXA5QW5hT0NIeldkMGpDcEhnNmFXYi9scnlDdElNcXkw?=
 =?utf-8?B?ZHg5Mk1QdXREbm5pSDF3YmRremtnSVZMR2d5Z0YyampSSFVucE54N1lnK2RM?=
 =?utf-8?B?T2JLSkhZL1htR1N4dFdEOTBKMnRNZDJXcVNlOVJjWndtd2VTNXRuYXYrMk53?=
 =?utf-8?B?RytLQU16SlNlZmF2aHFEZ2taWjY5dGxkbDJiaFFndG0zbGJrQ3pUODJQUVR4?=
 =?utf-8?B?SFphcDY2TWp2OVUzOWZhNElFaFBoditzVGZaSDkwQ1crVWFWR3hJSHJJSm5k?=
 =?utf-8?B?bUZJRXdWcERBR1pNeHZIVzdCUDFkWVV0OUE0d0NCRXM2NXRpWE9KUnYrSlZZ?=
 =?utf-8?B?WG1HMlc3WDhkaTZCSzQ0WmRRNFJoTkdTWFNOc2Y3UjQxOUQvRnZ1QmhTaUt2?=
 =?utf-8?B?SFVUcWJwekdoZlFyMEM1UzMydVFDSEhqMlNzaXBDNnhkcUJHYThJU0N6cmdU?=
 =?utf-8?B?dFRuQjYxdDEwbEJNajltM0dUOFkxMTJvWk9VSjRTaUJlVWJncGM0NHp4alNr?=
 =?utf-8?B?bkZTWm5TbnlBcEZiYzVjdE44RVZtdjFRRDdwdW5mL2NaMjgzUVJDUmVlTG1T?=
 =?utf-8?B?eDlnKy9wZWljRmF3Y2FBdzBKYjhFUlBNNFlyc3k4WmU4VUVGWWlFU0JFNk03?=
 =?utf-8?B?aGtxa3N2SytOVFhwY1BWQUlod05zMkFQMTV0ZHBVNkk1dHp4V3pTWFBmMmxH?=
 =?utf-8?B?THZUa0ZhWUNyZDBsRUxoTUJvREtmUXpTU0JNcGJSc1Z2MDljL1dhQmdmVUYv?=
 =?utf-8?Q?f3NOaUxdI9WYA6ckApwIN4W3zUPqF4goGq/UPSG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 664f7969-764f-45d4-ed4a-08d903a419db
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 02:29:19.5508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yuVpG2yXPCxXpzZtMfJ3KmHW+0BkX6j1foKwISBoHHx4JYKjB2uiDZqoERG4t3hsW9aE9SgoaKhJXVHDFesHUkv461ZsPM7Ax6neMWn1xLk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9959 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104200014
X-Proofpoint-GUID: shAYey1z6mjQA3lf_gBjCANvjiM4lGQG
X-Proofpoint-ORIG-GUID: shAYey1z6mjQA3lf_gBjCANvjiM4lGQG
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9959 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104200014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 15 Apr 2021 11:41:58 -0500, Don Brace wrote:

> These patches are based on Martin Peterson's 5.13/scsi-queue tree
> 
> This set corrects two static checker warnings found by
> Dan Carpenter <dan.carpenter@oracle.com>
> 
> smartpqi-fix-blocks_per_row-static-checker-issue
>  Link: https://lore.kernel.org/linux-scsi/YG%2F5kWHHAr7w5dU5@mwanda/
>  Fixes: 6702d2c40f31 ("scsi: smartpqi: Add support for RAID5 and RAID6 writes")
>         Using rmd->blocks_per_row as a divisor without checking
>         it for 0 first.
>  The variable blocks_per_row is used as a divisor in many
>  raid_map calculations. This can lead to a divide by 0.
>  This patch prevents a possible divide by 0. If the member
>  is 0, return PQI_RAID_BYPASS_INELIGIBLE before any division is
>  performed. The current check for a non-0 value was after multiple
>  divisions were performed.
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/2] smartpqi: fix blocks_per_row static checker issue
      https://git.kernel.org/mkp/scsi/c/667298ceaf04
[2/2] smartpqi: fix device pointer variable reference static checker issue
      https://git.kernel.org/mkp/scsi/c/5cad5a507241

-- 
Martin K. Petersen	Oracle Linux Engineering
