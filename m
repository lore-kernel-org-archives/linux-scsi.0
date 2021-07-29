Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6B3BC432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9DB760F01
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbhG2Dhc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 23:37:32 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:12116 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233485AbhG2Dh3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jul 2021 23:37:29 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T3bHOO009545;
        Thu, 29 Jul 2021 03:37:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=4gTDO8NguLtZH6ssqZGY02Qg5c22qVI5O6nN5iklkNU=;
 b=WHsNoFH4gn3BjBPXF45h2hpM0EDLaYs9Ir+1074qFJdEHmWbI3Z6a88TzLx9Z56xo6TX
 PtwcuagM9I5UTMfIpDuOH5bfZHMFaAbHFn6pzytGkAuQhLGKA9Xkm60ebAt4xCAs5plA
 ETPUKPUCqpyKLPAubhs2cc0sRBjuion2fVGobIbv9raGrTCQNFWj7cUCMV5VMs0ziUyE
 JevzwL6YzodR5nsMYoHRMTnUUjnqdECeWTETb/J22XG1iahqpqXo0nGt8Ccn0BgQdrla
 az3IoWBlPzpahrLPpv5MypRSpWbW9iwksarTQUeWWIy95K6OzPWUnYoFvl+rCxDLK0a8 xw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=4gTDO8NguLtZH6ssqZGY02Qg5c22qVI5O6nN5iklkNU=;
 b=P/dxL4c20SKvvTDCTLa6YhtCLmX9x5i7S1rObMThkGMr71XRdUKc8Vt9f7UniHgOULjt
 6fObK9W2JLpDVGYk9PPMUnmq3KniO/+QroVWjpd6lXL+Ip8M5+vkm6c7QQFDHEjZClub
 LAuGbFVKvuZymfNWR7V1xKhr0smxpx9bFwbdY30AHZ8Kr3JJH2WPTwEZM8bCNNJVfMyx
 OTsKFYqx7hdegGb8u3ecqMREtMEOFyfJCzjVDGVu6Rtx7JJF9Qo/aMobT7K4UYrArTSz
 oDw7fqWjC6vg3Wvvo4y0EaYJmbE/K1pTNHnDdU6rQLYtFpPADFr7hWp2a0APETdCUXdY /g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2jkfcbhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:37:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16T3VbDT181987;
        Thu, 29 Jul 2021 03:37:20 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2040.outbound.protection.outlook.com [104.47.74.40])
        by aserp3020.oracle.com with ESMTP id 3a234bew8u-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:37:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WyfBLA3BBRWsooqtSXLYVbB/zwS0Dya93zE11SUBqKGivC+0ms3Hpvv/ePRHMQjHRwDpD3IxgxiX1DVbu4EUgAe6rX1YyvG86ouh6F4UI9dn2gFF2q26eTLEraCw8bosE6UasErdlQw1NBGbtM7Ub/tR0++N3hlLuQL5zOzFdF8QIY6hpfTAK7+jKe1W3KSpk8xILEC/ZOvunR1XdmzKZdtkzpl0VqI0h0Sm8ACubcvsLWjB7C2O0DGuLigsKF8j1RVu/aE6HS+gZyWbiMN19QCS17qXMjhCikRp7ksex61XfiCpvPBGNBqWiyElZo7thiqESrrJKc2y4Bq5yx/9qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gTDO8NguLtZH6ssqZGY02Qg5c22qVI5O6nN5iklkNU=;
 b=EkaXf6F/Ws0yA9eC/KKhj/9MwSWCRAIv+F7TTY7+3LZ9f/VMQBoRv4tIb4viNUSFHToBQu4ETvr+2ZBs5UaRhJsGjnisd4Cf1pZEFhWTZRBW34wXW6Ry7qLbKPUBOJ+3yJ3tGXkYr8uz9dyfuQVRdW0DHZ/nP9rg/z7PBBF5KOI2GOyC5LsJxqTSpMmCEoaVgqcZ4rOPxIFe1rs+pi+IP4jrVXJ9/+9G/0vC5U45ErdhpH7KL2hLnXCqj0fMYCLaSWITsQMOT9BUeWucHGJIW/Cp4V+HvudFFxYgngrfxMO3NU+x46x52M9XX6U1zVTiVz8JKvitQxz5xbii6Eq+dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gTDO8NguLtZH6ssqZGY02Qg5c22qVI5O6nN5iklkNU=;
 b=KoCuHeE7BJy05AX4Yll5IJOyjUS7Q9HOErWODwb0nCiAJmbRkWOdn7ZkYl0qQ0ao9T3Bs6vrMA+xSLDdGtQ5RYWonXC+KSn7+CA7RTJ+FFYh7ln8KGOd8L8VLIwIjWWLodJR5vHGfO3izKU+/eKPmF/6TmXx9jQypvRP1UiSRXs=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1549.namprd10.prod.outlook.com (2603:10b6:300:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Thu, 29 Jul
 2021 03:37:19 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7%5]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 03:37:19 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     axboe@kernel.dk, Li Manyi <limanyi@uniontech.com>,
        jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: sr: Return correct event when media event code is 3
Date:   Wed, 28 Jul 2021 23:37:05 -0400
Message-Id: <162752979290.3014.5644075654125551439.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726114913.6760-1-limanyi@uniontech.com>
References: <20210726114913.6760-1-limanyi@uniontech.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0121.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::6) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR05CA0121.namprd05.prod.outlook.com (2603:10b6:a03:33d::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.9 via Frontend Transport; Thu, 29 Jul 2021 03:37:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dca7ffc4-5d07-418a-02b1-08d952422aac
X-MS-TrafficTypeDiagnostic: MWHPR10MB1549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB15495EA58A3A14FF5B3D597B8EEB9@MWHPR10MB1549.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HSCjy0Jl6Fkhn6/mW+UkgdnT4ZiFsz86UORaz6UaVy2Re9K5rJ18sLXRr8OGYYZLM7LvfWvs6ou0t398px/aZsbDrLBuZ9xFp3AX9A0yn9AVR+tsX+n3nMyuIfoWN5HketNIE/Vy6K1sa0R7NceqSweIxQlSY+lDFPF+cs4PHNsWhFqWb9lIaN6s/LEi6vbLpTCXhhZkua6e02VJr1c0XAU63P9QGnPZ3qcLudR/frFbr/D97d+m24p3s6qyBT0AuHF2HU83SHOWV0KkpXgXNN82xPqIdSdzmlvG4iCuxALWrdppMK6EHhw/3py+fbOTAUhp2HRKAD3c8qVqPcN68iNnZ7hEm3o+w+Q35bmQtE3J83VJDWpGaW8YwVaV27LZbt1PSHIYVHmJGenWca9kPeTQLoke5be8Ku0ZEADwdP/PXxw8I3++xfDCeUlSaZzwpfoau65/l0fngjABOylzzqoqMfubM5G9jS63G/zXTsaPEBOzGR7hbLB0a6l39tOpILAtI15NVsMlNC7Imuue1DLkx/HFDPMlVFKQ2T1qYTvGWkyOP2HbNRsGYbq0jpha2RuuCuu2ENZk+epYpLD0By8TielhH9LnDsqFIATrwqnPB+e0wamBBf42nkfNwwcX/9dAGDzQnLPQiV99+PB/DZVMiDvrqltJWWb/98vPOYPISEJd0GeXhXX6qhO4e9JAHNyYzZrz9cPnl2s5gVH0/Q19mjSCqrWBO5bHXfHRRi/0Z+mz5TLmmqvfMIYFpu+Q0By8YgfigzIhPPjCtSSxdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66476007)(66946007)(6486002)(26005)(2906002)(316002)(103116003)(6666004)(186003)(4744005)(4326008)(38100700002)(38350700002)(5660300002)(36756003)(966005)(8676002)(508600001)(52116002)(7696005)(83380400001)(2616005)(956004)(86362001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWtlRWoxcGFiT2V3REt4Vkd1cXljZzMwRjFGNUd5c2huWjRCVjc4MGpLd25v?=
 =?utf-8?B?WkdQaTBJcStFUTBnUk9sRDBYM3NMY252M1ptMmNJaGZYT25kUHFudFA0a2hR?=
 =?utf-8?B?Mk05RlIvNDdnS3BETm9wb0FvU0RoNHVRbnlsSjkybUVWWEVUVlFXY0tGWXUy?=
 =?utf-8?B?dFZsZ1hra3FIb3hlVjk5aUdoL0hTNUlONUJDdS8wbmpCdVEwL0UxbG9BVWNj?=
 =?utf-8?B?MGk5K0libXUvVVh2RklnUGZ4QS9DbmtBWThzc1R1Skg3WXRkdFBvUm1FeTJK?=
 =?utf-8?B?UnJPQ0RBNUdIYmxOM2ZCVmVCYnNxRlBFT01aNlphL3o2cm4rbm9PVUtEUVpj?=
 =?utf-8?B?RVFGOWxlZU1xSzZjdEFPUjUyT2tCZVBlN3FIZDArd3gvVFp6UlAxZkh3RTZQ?=
 =?utf-8?B?ckNEUjlkU2JTOXFGeFRIa2lkb0N3OTBUbWM3UXpBOXd3SlN0cTlMYnBieXdD?=
 =?utf-8?B?d21VclNndHgyRnZjYzdHdWxsaTBULzY2TFVkWHQxN1F3a3VoMDJyYXVTN3k1?=
 =?utf-8?B?NlozTUd3aWJaemdETzdpMnoxVVE5NGxaVkNOUHQ2bTVvWGxaOHFWNDUzanV4?=
 =?utf-8?B?R1piVmI3UzUzODRWMjFzazFwekxOZG1tU0VhZzcya2lxNTVLYm1ZaDVEdDRU?=
 =?utf-8?B?N3p6dkYxNWFKbEgwZ3E0MFNKRjAwSUl6ZnNYNjFMU05YU3hUTE9pK0g4Qitu?=
 =?utf-8?B?UzFPcDZTeER6cEptdzZlQTFDRFBKYWNLT0xSNCtkRGFpenQ0b3lvYkE2bU80?=
 =?utf-8?B?c3RmbkNTbzlhYkphdGJ2MU9mcDdaWGdRZGJvVFZGbXZrMjRVZnhFTXdSTEFt?=
 =?utf-8?B?UGxVaDRiYTZ3U0VQT1QyTzl1TnJlV3BPQ0lyaW9SUEp5SU44K2xrLzZRTGFr?=
 =?utf-8?B?dkFjSmZ5bmdEWTBCQXdFb1lPblc3VXZ6S0NPb0NWVUV4N0dXNzdKZjJ3SE9K?=
 =?utf-8?B?cGhlTHdlMU1uMU55dXBGWFRIMUkwY0xLajNEUGFHbGJFMjJQQmhXWDRzMGVx?=
 =?utf-8?B?OEVaNnRnZ3lDbE9XTkh4SHgxeGR0SytkWHJySGtadGEraWo0elk1ZEY4TlZh?=
 =?utf-8?B?Z1V2a0kwdTRvems5MnpEV1ZDM0FVWmZkeHN5eHBFTzVYL3g2b3JoWkczTWw2?=
 =?utf-8?B?Z1lsTTdjaXZTNXg2cUNsNCthMGtrK0lycWtpQnpCZE5WQVowbHNvaXhRRVJD?=
 =?utf-8?B?VjZySFArY1dmU1JXZTdlK0NvV0xpdXV3RjJtODBCaWJZMUdLaGhvVmVYSlpG?=
 =?utf-8?B?SGM2WW1ZMHdKMU1aTnVHTWs2L2UyWkZqRVI1U3diczN0VTVRWDF1M0VzWVkv?=
 =?utf-8?B?ZnltRHR6SEd3Y1FMZlRpSDJWR0JEODBXNDhTdUk4SVpzQUN3TVdMWlVtbHc0?=
 =?utf-8?B?bXlndU1NV05ic0hjVS9ZRHBBaHNYbTdMTThIRUhwelVxTFNrNzRTcEd1ZllC?=
 =?utf-8?B?R0w0VjFwL3M4Rjh5QWhJNVFkaGw0YnUzellncHpCTkJKOTNqbEJkUFQvbkxx?=
 =?utf-8?B?ZnNIK1FSVEtuMzlMenhXUTRZdlZNN0dtV0tkZWxqanZPNG1aRjhHcVVsQVZI?=
 =?utf-8?B?WC8vbEFabUhuMzFCdHBHSThXRW9YaGthWGtBdnJJN1VrcElaMnN6TGY0NHRm?=
 =?utf-8?B?alE3VW52b3FrNGMrYnl0NXpwa2NhWTByTHZCUlRRcmtWVzFUUGNpbXN2WDJn?=
 =?utf-8?B?OU5XMXgrS3JrV2dxUHNFczVCZTZ0VWtRVnNGeGV2QnVOa3VQUjBQcDlwZ3JS?=
 =?utf-8?Q?tmjGyBp91+x2iWC9roTyIo67nkuaQwck9MLu/JC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dca7ffc4-5d07-418a-02b1-08d952422aac
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 03:37:18.8941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fVC5JNwk1r1gHnePm9DXQuYVwawBbOjvepcZ+v7Fz/aBlwnUPSfBv9PSdRfS+rjwSMHOy2ikf3DMnQykE9aD7PU1EjrZUwl+N8xk3rQrTGs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1549
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107290020
X-Proofpoint-GUID: oju1r70HICu0WY0BmZPP0dbsW5YPlJ4x
X-Proofpoint-ORIG-GUID: oju1r70HICu0WY0BmZPP0dbsW5YPlJ4x
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 26 Jul 2021 19:49:13 +0800, Li Manyi wrote:

> the description for media event code 0: NoChg
> Media status is unchanged.
> 
> the description for media event code 1: EjectRequest
> The Drive has received a request from the user (usually through a
> mechanical switch on the Drive) to eject the specified slot or media.
> 
> [...]

Applied to 5.14/scsi-fixes, thanks!

[1/1] scsi: sr: Return correct event when media event code is 3
      https://git.kernel.org/mkp/scsi/c/eea4d790a8d7

-- 
Martin K. Petersen	Oracle Linux Engineering
