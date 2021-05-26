Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48FF3C47088
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 02:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E0D561090
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 02:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbhEZCwQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 22:52:16 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59978 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbhEZCwP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 22:52:15 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q2dWh2096389;
        Wed, 26 May 2021 02:48:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=0tS85mgX62QKcJdqtCNcu6zas/xPlcvnAYbyOY/aV8M=;
 b=j4Vr3vPbGKZ9GzDQDicxSWB+t1BWpBty6ynUgGQ5fKIWGoRB6Nr6VC++hXMHmJzKfuFA
 vpjEzYfV6a1zxSE8et0woZaBV7OWHAMysLudrswnBqj126Fn+Wqn+dqnU2hjvUngiUk6
 GY9C+hrSkB5uJwlCA0QWWnRBL0DdAk/JJizXm8OqBupdEZRF4pRON6FzkXvF/YC1PSIV
 9SqguRsnLMt2W88NWOsr3axJpqyFojtNj35+nSggld8OQHPQZedmSZUNDqibLOP3Es9A
 vDhJRox8mWIORrKmk6B73nPv2WrEHUyI2lHpjQOFGHxqpqOd+M7ADWnln2NVTVY/gnjd Ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38pqfcfr4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 02:48:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q2eE3J098414;
        Wed, 26 May 2021 02:48:26 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by userp3020.oracle.com with ESMTP id 38qbqsu1qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 02:48:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hjIDUprED4jAGxq0zNg8Laj2INw6PFROIltf3SLswjQFeUw/aCSjY6XkdsgAcF5aMkUqSjNxh9Pnx6kRg2KT31KRV7YvhO/7mSCkzvY3RiLOyhfISbFTAmCuQZt9scYaR5zToRZM5UZ98J7zQ4DWlcaPBD4zDhnbIEt28RpUZ7ndyWyIoLeGhc85tZr05PMrFqZw1XttdeR1i8DrWO6u0ALMLnwHwbmzKEUqGIZsp2WCFeY77MSpXk12o31mIsGmgBo6SteOQK7VMss9CniT3ouGSEmTZdwf+GRfdqwFP6fAJlceEgSuh8waL0YI0uIz3iDSoeXei4WMGJSG3dGwDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0tS85mgX62QKcJdqtCNcu6zas/xPlcvnAYbyOY/aV8M=;
 b=VwBTf4j8OSQRNVV77R6HwaTGc6POcFwZ1qW77mqOZJiCP+g9sF5S3JsLi6Gq7RsN01A6rbl5JFI/m0qhoMv/SmIT76mt0iBwX/EggkJymAY1RTJZ40nzAg7iLQ52hHjpvrrpdZ00lhGYv5oxvo1ItFNaKD4uvnpIOxxjzKAL41sWm3nA+Cj33ycobTd3PE8aMBFTUo6U4ZG7OADTP0qzJ3oTo8O1YvrX4v4lqwpXv7/D2KAuKaPHw4bNIl9g9SJZw/k9JcnmJHajOZVqFqv9goRXJjUgDSI2xxwTYe2rhvRYxp40MOQru7r9WV8cWkad8+IPPEkk3bvCuVTDHl0ymw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0tS85mgX62QKcJdqtCNcu6zas/xPlcvnAYbyOY/aV8M=;
 b=EOclV43nkEFK9UKBXzZ2L0oOU73pAY3GsL+m5uz1sqSomuzxNt8neRx+sbyYfnjDs6Qlv+xG4lYOQ5ue53n4CTl29bG2S/1YJyWSyjueM2uuzqNzREqfBuAFhh2gC9UOergtzFpsAYf4bxXLRYN1JKBtDdN5Uam0ndr9/w1v1ec=
Authentication-Results: hisilicon.com; dkim=none (message not signed)
 header.d=none;hisilicon.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4808.namprd10.prod.outlook.com (2603:10b6:510:35::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Wed, 26 May
 2021 02:48:24 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 02:48:24 +0000
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     <axboe@kernel.dk>, <tj@kernel.org>, <martin.petersen@oracle.com>,
        <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>
Subject: Re: [PATCH] libata: configure max sectors properly
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135uaxmt8.fsf@ca-mkp.ca.oracle.com>
References: <1621992862-114264-1-git-send-email-chenxiang66@hisilicon.com>
Date:   Tue, 25 May 2021 22:48:20 -0400
In-Reply-To: <1621992862-114264-1-git-send-email-chenxiang66@hisilicon.com>
        (chenxiang's message of "Wed, 26 May 2021 09:34:22 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0201CA0002.namprd02.prod.outlook.com
 (2603:10b6:803:2b::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0201CA0002.namprd02.prod.outlook.com (2603:10b6:803:2b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 26 May 2021 02:48:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4977a600-c628-476a-8d76-08d91ff0bb2f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4808:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB480810E5603F57E48A6F5C788E249@PH0PR10MB4808.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HiuuV5MPBc1R/6zEeq7X1/xTa4Rqr/7YDArTGNIs5eLVScJ0uZDBTMLgEgE7TOO7CP7CfmjGS9zOk4DsXawg21ZlFPzU5yzm6mXTAdOmmcRqsKoADd9lCnjCd33vhg/c6jBTTfIAQDbpXHcRNzCti587vCJrndicCB7B2BeOy0itpkYY8pp+/uHYX+MISgDq/XYvjRamAEwoih6B/JMLuc9rq3aaxMpQBBhUCxKhRnSY1tYKwb1Cjtl3w0MCLPO0m2le8IwKDxo+Q+ijVnNnnFdx/+GXmRE/J1DwfaTGwrFzYEUHT3g0+Q3i49i9VtWTkOGQQc6sGJ+ZVluu+JNHFQpuXIfRosHRD8aSot1mU7TD8LhCiwYcI0L/Oky75ulGu7Kfz0Ll6Z3Nt8b777XPjLM6/qkITHL2O4dh7xJqNvamdu2iTTUzd+a/AhQe0AQYQ/Lw3ZLcBXdZ9OCBYhIl9/Z+F0sYbQegaUn3t4sQmkDt+NK8rh21U1xSclfAVCdhVo00IOgAYDuRE9OT29bU765Me0Ulr0GPjIhURaLLVYdmu3yIjm4xmsnUV2cUSS6kITy1P3AyAom9ZjaQ4hTROZS3njvdS1ZUtjrjR7u28Ln3rk4nlLm7r1ZlBdz76Vyi8vsEfSieasz9jGo3UCs9DQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(136003)(396003)(366004)(5660300002)(66556008)(66476007)(38100700002)(478600001)(2906002)(8676002)(6916009)(55016002)(83380400001)(316002)(36916002)(52116002)(38350700002)(86362001)(66946007)(54906003)(7696005)(26005)(956004)(8936002)(4326008)(186003)(16526019)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lWESmvPCixqF4libt7fzIRYmAqD+oqarEfU7ZgJj+kAx8BpKgdy0Oqm/dDoY?=
 =?us-ascii?Q?WfD3W/D5MiUNYdYF59uLmMgwrRN/l3KqNNvdlwSuuQGQf5qempQkTtSv5aVQ?=
 =?us-ascii?Q?0qDfEB18sTzmNIP+V0mUc11fAnBhE5ipCoKCGf7SodBj/W1QRAqdghpydrRn?=
 =?us-ascii?Q?FlXIcQnsALV2mYqZSkX4E4rH1cexYqqwDvLbtQPetEF59ptfaQ5tHg1l+0W7?=
 =?us-ascii?Q?bCg2Ige1OiE5NSRgd8gok37gQbqgdDknVmTM53IlLeZK5ZG15qo3EhDYrYnt?=
 =?us-ascii?Q?zpeCjyFuu1INT9xClnspPBBqn1BhKuy4M0gw8b5RC1vMMs0KWsSmwGh3lpKQ?=
 =?us-ascii?Q?DJaOUPV2sQWiXnBaek768glbhU8z/i5U3mrfI1s7kYA6qobs7Uf8e4JorTwQ?=
 =?us-ascii?Q?30dFzWGrGZMvp/zcM/JOxwzXezIusuArU022jUk07Fxw84ZYCTWI+beCJpRo?=
 =?us-ascii?Q?jva/VYEyEXGSjBNHN8x+0UwjX93jAgpallO6p/FpawheIY8vdDivU6NPmP13?=
 =?us-ascii?Q?H/TI0yLg4JfTRzwuy/OheSIpK4MM1AbBgt2roVlfDL92kwyaxw1cQzIWpHm7?=
 =?us-ascii?Q?9Yka0CNr1KHauNvhQPIYqX4GcNJb5eWZg7RLSRlUBj5yE+FL2HTCs+JHX++5?=
 =?us-ascii?Q?LG3pXNDRt785eoaZydtTGACAh4HKJ1gltM3G2jbKUoA9isLTr2MimdoKbyq7?=
 =?us-ascii?Q?Z5YBebVCeqIuKo2fBQO+gO2MCYhtbjyjgdHrYHNrW1wnC+ZIYIQUM28tVXKq?=
 =?us-ascii?Q?dyVFhAjbOjksPbuE9Do3N7iGjaPQPYHBWz1K4dX7IKxdTPPJioxwCzifIBxj?=
 =?us-ascii?Q?UqfzQTwWujdgcsy4A0i2ojDPLlpqt55R/KIx4m86o9c4NaZv6DTeCHU9CmH1?=
 =?us-ascii?Q?tGQ+YTQGOaHzu0pmUylQQH0rupUrFqRVHw/S1EBNRONBlM5ImjkDGeDBVEM7?=
 =?us-ascii?Q?bNF4WQsU+ef0kSfiaeTpvNayIlvDLtZOV9ecQ298Zfw7q1KyCZ7ZDKCJacLa?=
 =?us-ascii?Q?EF7cddersWHxeIUbQOTmvS2oCeFA+99lxNl1faEkGaDKtWuqOwG3lW1dhLbB?=
 =?us-ascii?Q?EhGD7bhb8EO+ICldcGbtftLxs6EVrfJrWi6SWp71xl7lxO2KD61ANg6oX7d7?=
 =?us-ascii?Q?vG9K2KZ6q+XXUKWusXMaxZPDAIMQrIbA/pz4MLUmyp5cuhhc5qzft2dyotbc?=
 =?us-ascii?Q?8Kw3v20wJelime0xkDB0KRuZY650PqHYZ5NxrVNwS/dhbsPEAk+z2APIhcmN?=
 =?us-ascii?Q?rZu/wWz4HFgB8Fh5I8j2TahThlaEeRTMU+nlpTR4Q6iYcivqtf8TWCn/eN16?=
 =?us-ascii?Q?buhFmBfIBngLbU7XdpCDshfX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4977a600-c628-476a-8d76-08d91ff0bb2f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 02:48:24.3948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2R+SchcavVb3ZKsl5dwvhFagfYdiWhTuBositVm3nxYmfhBbi5VClEJWooQY8x8PbCeDEBRXPOOlirnDNvzYveQ1N0hOWj0dipOyd7eiUh0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4808
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=708 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260017
X-Proofpoint-ORIG-GUID: DwM4TND4C814tm3qt3XFQNESkkvTIQpl
X-Proofpoint-GUID: DwM4TND4C814tm3qt3XFQNESkkvTIQpl
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=896 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1011 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> To avoid the issue, set q->limits.max_sectors with the minimum value
> between dev->max_sectors and q->limits.max_sectors.

dev->max_sectors describes the ATA hardware limitation (similar to
shost->max_sectors for SCSI). Whereas q->limit.max_sectors is the block
layer soft limit for filesystem I/O. That value should not be used to
set blk_queue_max_hw_sectors(). Nor should queue limits currently in
effect be used to configure what is essentially a hardware capability.

I suspect you need to clamp the libata dev->max_sectors value to
sdev->host->max_sectors.

-- 
Martin K. Petersen	Oracle Linux Engineering
