Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DADAC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FD1364F91
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbhCPDOm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:14:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38182 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbhCPDOJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 23:14:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G3CDMt076954;
        Tue, 16 Mar 2021 03:14:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=wqPoby307pfxtK1W93HJ+k4A10Cj32F7QKiHHmdgj3o=;
 b=GL7zHOmuVYZhLF9jZ4uyqTKOmb6A5av1RhD9nCSoAfFPRDM9jIs2tKXlgyLjxZhD1KyK
 5DT6DSk/SbgmcLaxg2z2tpVJ3rHMsAPZN3hQShjOJx05ne7yj8zC45oYH78gCC/Jhd6n
 es9vh2CJSqxwJ9hk6FYSKdJcT8/zhHMKdfQGWZBAkQ6TKWnRxdRdiTva1o5dWeC99xFY
 pPXotYiJMiETZg1xBRAeS9cg+lDT+WxMIpgUrNcQDYvH7+d5P1ztPIeao7tdEoFmR2b7
 KuybcaQdoUo0BoKJ7T3Hu/R9yIXtfgCR9pWxbIYx8AhTq6VWJdr8ROhlL0suFk8Q0Wod 0w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37a4ekk38a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:14:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G39djh138200;
        Tue, 16 Mar 2021 03:14:03 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3020.oracle.com with ESMTP id 3797a0naca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:14:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SFc6so7AbwMEdkV5wvU3j/9xT0fLQGBIhHroCXPYWGdBdD+dzfBZKNmQ858A4SAQ3261yiFt1L9esVM1uftX+UkkmDzJ4E6WjfqPx9N9mP538Ep/V7UIc56muk8WXEfew15VEMeb8/9Vq/cxKpuFvCmw1oXHrfoqFLnA4O6oPNhBFjL4YqpEvaD3l4zRWZ4UaTbPImgK0Si78q0ioO0hKeCaLzaCPbpFz3H3gjh6XNwwi7Lfpb1VKeAZdynQ0q/5kpD6i0Nb1Ll9QWbTCFFB9QKLm3+GPcq7GMhsgCwWqxn6YDTME9iC+uXJ07Oixl0sVQ4se51O1ySuO1xwvEBdjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wqPoby307pfxtK1W93HJ+k4A10Cj32F7QKiHHmdgj3o=;
 b=HCk0fRUaDp55Qn58uexDfNl2QiRLKriUH903C2pdDMDI5/IF6kCwQWryVyQHby90fAdMBi5GAWRSuGrgLnDtMBLElRQPjGBRhaXDAsSevQAbcdV4CBZ433wTO9B0/Av/H2HZmDThPiZMRAgKP5J+6GnmPq11klwbBHmkc94sjELLv9CU0s0FrM/crc1pwfZgpvgYEO0gPHe+bTjNnoH2GIsoX1PgZnzrF28R3J1rPKpD27hh9vyzyL+mgMjiu9TWSDWEb2TYHCllcT6FY2660Mot1uWXCKVacw96lPqUPbcqYLDgxm5bxwdJ+TRg4mZJ1YTWP1T7P0clBdvxabEN2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wqPoby307pfxtK1W93HJ+k4A10Cj32F7QKiHHmdgj3o=;
 b=LW4sm4it3FXpXGvOj1ya9NUZeJJAWDjlaCJxdUVvDS+LZXxflouGDwLBtD2GNVjSjVeA2RUocSFcPC2jsQo5243W1w7jx1wToHj35O6kGVmPC7piRXiy9qpSfDipKz28vBAmCtzf/U5fegzFK8i0kKB5ma2V3ILl6nhCOZQ0uD4=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4709.namprd10.prod.outlook.com (2603:10b6:510:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 03:14:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 03:14:02 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Alexey Dobriyan <adobriyan@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, njavali@marvell.com
Subject: Re: [PATCH] qla2xxx: fix broken #endif placement
Date:   Mon, 15 Mar 2021 23:13:54 -0400
Message-Id: <161586434245.11995.2661766789536735029.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <YE4snvoW1SuwcXAn@localhost.localdomain>
References: <YE4snvoW1SuwcXAn@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR03CA0119.namprd03.prod.outlook.com
 (2603:10b6:a03:333::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR03CA0119.namprd03.prod.outlook.com (2603:10b6:a03:333::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 03:14:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 207ccb9d-4f28-4a4f-018a-08d8e8298c5d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47097C8FDEE206D869CDAEDE8E6B9@PH0PR10MB4709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W1XukiEn5xivmLfKSVEUcfqL7W5VAy4Lv53TTxVykcDPneZCKpzwyVWzUWe20fvFoB7VeIAjXiui247STxwWJwQkNkHXNyZhPhPdvk+V3sS1ij3asEHoVRXDv6ne9unquGbVslymWr1Lm8KAmyZLt/F6AFo0O3pFHENgvkKAhqmtTV6AkH28SVhH+eYeYEOuTmHEt8bqA4nmkXNC0jUYWSBLXg8EyevRyE3nlC/wBNYJpjCOQ5VlnJYEHQOW/WMqs6Kes1dl8s3k9LmWasIYCSApoZ/FBTwNjjCXRYpXuLC2VnxMEKrJ6NO6YyIr02zxH6ufr8uIiXhdKUcQrNAczjpyh/4TnyJ7K8/T7HSARXh80zjrGYTM6GNvroVdFVeEORgTXXrOB+Bkvkv9kDdMU6LYO7AW4c1yCBcabme93x17TWV5t18dEeTWu2vLV7Elb1YMa8d8EDhaTneFhMCJ/lZdh2phldcOSZte+kCyDlxineTPccUUynXUeSteZjZouy1xda3WpyVy8mMmH2euYGUnT2+tcMr3rJgAOddpaBvaMNuKJ7ISpJanoEnPCyTA/1UBr7PqEjckZe4hvboIMhWn5MhKuZFTb485nzY+1YDaUk9ilts6gqJTPwRueTgo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(2616005)(26005)(478600001)(956004)(4326008)(6486002)(186003)(66946007)(103116003)(4744005)(316002)(5660300002)(966005)(6916009)(8936002)(86362001)(8676002)(16526019)(6666004)(2906002)(36756003)(7696005)(52116002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aTIya3l4Yno4aXBLUEk4R3A2N0c1TFRFVUVUZGhqUGc0QXhqWUxBSlJ4emhW?=
 =?utf-8?B?UnlrdGhjVlhYMGJEUm9ubzlPcGRTUkljenh3eXlPL3N6Q3ZTdVI5Z2hCUmM2?=
 =?utf-8?B?ZGNhWm41Ykd3WWRTRDRHcTdIbTk4QW9KREhLdGNQT0JpOGhYdUE2QmtiYmVR?=
 =?utf-8?B?UThwYTR0RzVKOGZxVkF5ZnV5Szdnb2QyMkZXanZLMmpheHZTcUd0aHhMUk9u?=
 =?utf-8?B?dEwxRVZneU40WEVSa2JCazBPM2hjaUgvZzdXKy9CMmFqTDNVdEs2cCtsbVJO?=
 =?utf-8?B?OFJmbHZ5d1ErQWNkSExGTGZtck81T0phY3VFcktnWDg1dzM0cGtlQkc2WFp4?=
 =?utf-8?B?VnNTUzlkUklISUZHbTZsa2J4ZWRTRi81QUJzejdGUFNUZllad25MR2NVeWVN?=
 =?utf-8?B?eGpSUFo4Q2VwUU5rWFNSWUNzQkJJUGF1MHlxNm9xOFUyWHphL0hiWHlKMDdx?=
 =?utf-8?B?OHoyQUV2eFJjbjI0QkpXblZLR3JYNHN1U29XT052N3Q4b09hS3lVdnBXYzJY?=
 =?utf-8?B?K2c3VXQ0cWxWTG1KbHFDSmVmbUpEck9lTXh1UjhNYWJMZXpBTmlmTzVyTWkx?=
 =?utf-8?B?bmdjWUVxb0pFak9Nd3p4WXVZdmVaYVZsKzZzczhZbFFHSXBYOENnc3czUTJT?=
 =?utf-8?B?Q1dwYzl5MWN0Nml5UlBKWGZzVytQa29DMzJ1MFlnSEdKbGR1OTFNaHpZMVd1?=
 =?utf-8?B?SHk5RzRVSDhRbHk2eG9vVUVPR0xKYmNQc0YvSExLZ0hjWVVXUWZSUGZrckxy?=
 =?utf-8?B?bVcvSS9YVUljYk9qZGRhWUlEcUhNQ1lvNE5lTGszbWZoR1A3bkxXM0JWR2I5?=
 =?utf-8?B?RW0vK05xazZOUGlEUmx5bDBzNkRJM3YzY2M2Y3lUYTlyc3N3a2Y3MHd6UG5K?=
 =?utf-8?B?WjMvejNvaXBSU1BKVlRvRk5sUUJHeG9wZWxOMjlrcTMwYkxNWVRpTm1Ia09V?=
 =?utf-8?B?R2tIaDF5UDVweisvc25QTkNNclFWYmpXcVZFY1FEZUM5WCtpbGZhQjZ1dFA0?=
 =?utf-8?B?NnB6OUNCWDIwUUFQcGd6UzZ4eUZwR0tQbDlEbXUyQk52UTVkQlhPTHU0dHZ6?=
 =?utf-8?B?TzREYTBnQmNBQUZpNXYxVTQyUzFPRmJOYjBSUTUxbVJPM0JnQ3NUUFVhd2Jj?=
 =?utf-8?B?SU9RZWJ0MTNNZmIzT2ovN0Rsd2VibkJqTC9DbFp3LzNmY2FoT0Rqcis4eWVm?=
 =?utf-8?B?UzFvR0ZjL1dKUURrei9sZ0wvWHhMWnlxdFpQSXdoY1ZmZVY0MUg2ZTA0V3Y3?=
 =?utf-8?B?MERRTXlHS1FwcnFBRUFRbTVzRnRtMnhORFI5ME9qcktFZXA4KzJiOHBrZEN3?=
 =?utf-8?B?MHlSc3BsUzRHYlRsRVhONUtOOU5oNGxOSDRndmF2alFXZkpxL2pQV1U1UFNT?=
 =?utf-8?B?OWFiVXBMbGM4WkpIc2R2dlZUM2lETjY1TUlMKy9nbUY1NjFQRHNFNnVraFNO?=
 =?utf-8?B?bUlFdy9naDRZZXNKcys1blloTnlHdm1PbUNpMmNoMVdhSnc2QW9XK0g1Z3Ex?=
 =?utf-8?B?dEd2eTNCS045ZkdCOW5DZCthcStnbjM0NGdkTThhWVRSRm0vTzFpYVhUNTVV?=
 =?utf-8?B?SlFRdEhOdGcyK25NeGJ4Q3BhOUMxaVhqV3hnYTJlRnNENWR1WjF4NDRlY0Mx?=
 =?utf-8?B?N3JZYTA1ZlIxczJ2MCtidUdvRlphR1pERTM3MEJtVWFvRkZuajdFR1JTNDJE?=
 =?utf-8?B?WkZKVmg5eDFYOXlVa3Zkd2l6dTVtcTNkaVlaVExuWWRodlNSYldrY1U2Rkdq?=
 =?utf-8?Q?WbVMfE/QnBMDaTLJQqCRYacbePPKStBVlMA7Efe?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 207ccb9d-4f28-4a4f-018a-08d8e8298c5d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 03:14:02.1045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5vA3M7A7sD1N4wCCXn0JYp8PKzz+bU76L3dzWjhEqXbVZWMdua9oROH7ZqV6NeuttQ4RpgOETekx7tj6hPNoP/7S+5OxXqih2q6enn+ZJ08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=952 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 adultscore=0 phishscore=0 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 14 Mar 2021 18:32:46 +0300, Alexey Dobriyan wrote:

> Only half of the file is under include guard because terminating #endif
> is placed too early.

Applied to 5.12/scsi-fixes, thanks!

[1/1] qla2xxx: fix broken #endif placement
      https://git.kernel.org/mkp/scsi/c/5999b9e5b1f8

-- 
Martin K. Petersen	Oracle Linux Engineering
