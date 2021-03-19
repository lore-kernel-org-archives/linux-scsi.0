Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2480C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A19FA64F42
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbhCSDrY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 23:47:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56526 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233706AbhCSDrD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 23:47:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3V1cw076002;
        Fri, 19 Mar 2021 03:46:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=L/P+DRpOIPIBxtBo2zAwVSDAqscdHffAUtp4u6IhTCA=;
 b=mt+aVV6va0rckSw14A/W4qGcYn6umrRU9Pny8g9UuYTmrQ1yBp3Xtif1Bu3V9MXXhQbe
 pyF1XPqqG5beqcvIbWUVqBI0ADq6sx/Ii8UQoas6i47R2hvFgPK/EFUxSv0VLokENjyh
 UVONbIozKd8vUjMTpwQAOU/7G8wii7SXBf+xB+4C6nlQkEcvzrc5kaJczOBucKi3BW62
 8yHwL49sU+H7DKheHDJO8s+yGmXl5KLSODcqNawUym3mdDizFxtL4dZLVQYfZbb69nvK
 dqMPrKQ6WJ/IsCtgMUHBt3vvTbVzP66UB7qyrKSdkzB1a17N9aGbygpS+pAG09ZhEu9m jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 378nbmhhdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:46:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3UpxF154019;
        Fri, 19 Mar 2021 03:46:57 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by aserp3030.oracle.com with ESMTP id 3796yx0edj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:46:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U2G1UgEn+DpmehzjJESAGkogveCdeWonSqY0/mXEuqX4/Rm0znKKjX6zSns7b26M24NyNOE+H24UevNrtt40hUWWYo6MUndaTNJaM0JP9TdJXafODdcWv3edNkHBU0V70gxTp2pMMe4M/OraN1kO+JnwK6n7dSE2Pc53hpl+zmfn2TtC1OLsMOiVS66clELM+e2E5zhvwP7AkutlUrFMLU1Hcq0V5Qm2Sq1Dn3lacyUmeaPnydQx6CH6ATtW+3L+ZfW6gsE8yXGziF0LpNP5cGOAIK4+LVDWOCZHq3qqcGbTo1rYg+gbLf2CjVpk54Jjb4PHHu6x7ku1F7KGGqEP5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/P+DRpOIPIBxtBo2zAwVSDAqscdHffAUtp4u6IhTCA=;
 b=J+un4i3KzBsL1qaraCbnzetHk6VftqMQZ6FGOSb3SsE2GM7UTZb5jPIuEbZueVC0wGbbj3+SJaZzGOnyXcCxtzDbyAJZQwQAkzQBf/qIuSiL3SkEaPfgBwseYoJ7K+Rw8+D6EE1ti+UWzinFTX0MjAPtLwz0Pvwnw2OQFBP8cuNIeHhA64RWbftqwmYzr3aIutsu3C2J4VMqSu0TRORkpQJ3TTCbtGPdzqkngoAZfma6lBTryr3fQP1Z4BcBZD0e1dZnTwfr8LCkf8icasdicKr6tfWdSRKC+ELMsMtCvvS56a9BCzgy4ion4809Y+Pl5XijTSVTes825gBp1NsCmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/P+DRpOIPIBxtBo2zAwVSDAqscdHffAUtp4u6IhTCA=;
 b=KQI1PV1W6RTGaTOt1OKPTHedUY/DHLm3Yg15hWzBox13aE68en4POrlDHkB9oUNWW0Ef4WWy94X28Jndo62vw8MDacJ2ZwkWttEcAzJsQQZaXaXXbrXfSlnBA43TKQo9GSdsdUxGL/thFOM7PcZZXltk2mfKk7mtZqRpkjdoX5Q=
Authentication-Results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 03:46:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 03:46:56 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mvumi: Use true and false for bool variable
Date:   Thu, 18 Mar 2021 23:46:36 -0400
Message-Id: <161612513550.25210.1073449474403906076.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <1613643371-122635-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1613643371-122635-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR05CA0182.namprd05.prod.outlook.com
 (2603:10b6:a03:330::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR05CA0182.namprd05.prod.outlook.com (2603:10b6:a03:330::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend Transport; Fri, 19 Mar 2021 03:46:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba3c73a9-0851-4627-8b07-08d8ea89a42c
X-MS-TrafficTypeDiagnostic: PH0PR10MB4616:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46163F0D289F812B7ACD88BC8E689@PH0PR10MB4616.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i+xkmtaFNELOmBjm9aJMePTwuen9jrf3oJvJkcWmNfGajX2nr64kAA+vkEuEMzUb0CIFhqRe0qY4lvWUiJ3ssM5eZWaveND0sEPYNMt1njahfj7WOXRLThyiln70EqLW3ZmiuI7E9Tpwa3PS3I7tb7yjFVnjqLyUG0a/rSnw6kge8J3ePY6I1rDN7Hibf/KFX4xY25aokBWJbs8qrl2dDhySOmh0FKA2c3Urk3RHreqWKHjKHqTD9IbVKBiqKeVfbeLa4s8vEzx3MlSX2i+ay6u7FbLS448X4ttNPvSvyEbFGyQeoWXIBP/WVxxPQfIdtFrCyt9MFiR9aLPkWKXXunW+9Q4aqjyvWPRveE9vYz3DWbt9jJk48XCQeb6qQvm/l3BycwDYg3/vvLFb3Y53tJi1C2o6YRK0qeSfhq+/5O/FivCUJpUDlgQGnAgz8SLCz7n7XHzWR+K2K10ffZLOWMmiZBl7wZbgpG6chw8BLxW6qnaWXVxzlj6Nx/+EMoyGlIOU+39eR6bWQLyIGP7/hFw7groXGby2xyDALDPpH8kjfpq96fg5ir8FB8e+qIBBarfvpw2kvoTj5gg3Yq984T3DJwBthlQ+6TZh25V1RitfXhRtfHmZ1NWsUCFTuO8XxYUSV93l2l0CGGMP+gjTuOCGGJN3ku0C4QKsGX83ua247VFNHnO/R6waobOrOkrktTQ1S+GBvv6xH7ynKRvzru/nLgmznde2qEg/fQ15VW8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(39860400002)(366004)(396003)(966005)(316002)(4326008)(478600001)(4744005)(6666004)(66556008)(8676002)(103116003)(38100700001)(8936002)(83380400001)(186003)(36756003)(6486002)(16526019)(26005)(86362001)(5660300002)(956004)(2616005)(66946007)(52116002)(2906002)(66476007)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aDJiQzN5MnZ6T3YwNE5DSjdlZFgxcDlGZmdONHV5YWJhN3gwNmVKQmlZMTJx?=
 =?utf-8?B?QVpWdjlZNllRTFVyektWTE03YW1hZE9DcWpTdWhNQWRnREtkWmVXMHBYZ2ZD?=
 =?utf-8?B?NWhxWE1ySmMxY1dMRjZjZG9TalJEaXBZd1llSmNsaS9qNjZwL2wxMkVFamll?=
 =?utf-8?B?ZURiREM1ZnBMSFRlQ3JCYmprWS9CM3h1eW0rYWc3RE9ZTUxHVm5sVytWa0VC?=
 =?utf-8?B?UDVBRGQ0bm5vdXdUbmZtcEdTd3FKRTlKazBLU1J5T2ZQVU85QTJBei8rWU03?=
 =?utf-8?B?L01MUEhiajd0NkFHQlBYTDAyTitJdHFEL203S0pTSjcwNkVNcnhZYVFibjFD?=
 =?utf-8?B?eWViRitMMCtOT0FMSTRZV3VNNTY3blJEQlRucWVDK3Jtc1hWOW0yR0krNFJj?=
 =?utf-8?B?OWJaREVMbktUbFN2K0FXblZVQVRkUldrNnVlUEloK1cvV1hqSC9hVmw4Nk5u?=
 =?utf-8?B?RFlSVC9pdFcwbUZ5c2xURisxVk5JTnE2b1llMy9Fd3N0b2laY0JZL0NSNUVF?=
 =?utf-8?B?b2FUcUJTdldvVU9rL00wRHU4ZU9Sc05kTFhqbDBsM2ZRbTIyTVovbE5uaTRN?=
 =?utf-8?B?bXVJbHFyMHE3Z21mT0lNVTBVR3pNak5jMU1jaHI5SUZKbmE4L3IvaUJZZmJ4?=
 =?utf-8?B?Y2REMWRjelhTZnIvTzViTlVHVXBmbi9ZV1Y2NU5iZWVhT0hXdFdUNlZQK0JJ?=
 =?utf-8?B?YmJLTzZGYlZOaHhCeEJMSG5mYXVLRjJIN1ZOOFlHUmkvc2J5d3RUYlNmZ253?=
 =?utf-8?B?SkY0THU3OC80UXBDalQ1YzVoY1IySUZJNjhDakhDMVNabjkzTTd0a21sa2NH?=
 =?utf-8?B?TUFGN1RSRTFMM3VTSUplMWFGTEt1SmVoWUE4RlRLSWJZOW5HbDFOMWlSdk9F?=
 =?utf-8?B?aVp2YmpTL0FtQ0tkTW9GU2tMN1crMFBjMXE0OUtEc09UQS9ySHAwWFNvMHF2?=
 =?utf-8?B?ZlY4c01FZzZPZEhJazdPSk1FWU1rSmVLK1JZeGNWR1IzVjI2MGV2WGpqYVpD?=
 =?utf-8?B?Ni9Ya0hXNU9zdytjZ0drZlNwWkxnaWtmNFVFRnN1UWxmUWRFT3JBditkS1Bq?=
 =?utf-8?B?SEdsVGRGOGZUaVBaV0lWYnI0VjhSRlNQWThDb0VLUnF1bGhaRkhEUjBHNmpa?=
 =?utf-8?B?NlAwTEpxVGxNYmo0dXQrNzVLbjBtUE9HTjNETzJNRVlscjUvQllhK2ZSVzIr?=
 =?utf-8?B?WTN0RDFQenhySG1uZUFuNHRhMmh2UTQyZjI4aUJBdlBGb1pZRkpBdGllaEN4?=
 =?utf-8?B?cHl0UW92WG0xNlVkUXdwZ1U1ZmxjQ2JDcVVsUnc2RmN4V2tIcFhCamU5Mit0?=
 =?utf-8?B?ZmJVNWt3VVZXeVFOYmRjakZpM3hqRFgzT3FhQ0ZHUW12Y1NOWHlwQ0ZERmpM?=
 =?utf-8?B?TExDTnBxcU1iTS9qT0FOL3MvckNNdmhLS1Y4UlltL3lqWU1CRmpPb0hpY2VQ?=
 =?utf-8?B?TU9iQVpxV095RkI2bHNCN0hQQTdNbGs2a0VwQXZKUG1kQ3hpeW5SK0djL1FJ?=
 =?utf-8?B?UnQ3MUpUSU1SOVAxbGxUdUZ3UHo5ejlqbzh3cml6dlJEdUJPMFhFYlI1SlpD?=
 =?utf-8?B?MHFIVVVNZlFXZWNSbm4xUDVEUGV0ZUlmM1pIYTBIaTI5d3d0Nko3SmVlRmlp?=
 =?utf-8?B?dzZRQ3NIa2R5bEdhUFhicCtQZkxZbTRtNUZnenJCSmZZOXprQ3VWa3Evejdt?=
 =?utf-8?B?QUNNNmZRUHZQNC9yZGEyby9hdFZJUnF5cFI5VzE0Rk05RS9tTDRRVWxJTDZr?=
 =?utf-8?Q?ZNfTw4+keZvpq1CUKrQ9+cxBU3+9DtUSAu0sUGJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba3c73a9-0851-4627-8b07-08d8ea89a42c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 03:46:56.0499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /BT+spMRU/kKu99+QargF+BTYFs6yZXeDuwh3Kkp9oWQne93laMQ/uvl8669dhHx93GXEOcL3I1FTrfd5L8+EDlyxpJA4q/4B/+vKZ4+/vo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190023
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 18 Feb 2021 18:16:11 +0800, Jiapeng Chong wrote:

> Fix the following coccicheck warnings:
> 
> ./drivers/scsi/mvumi.c:69:9-10: WARNING: return of 0/1 in function
> 'tag_is_empty' with return type bool.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: mvumi: Use true and false for bool variable
      https://git.kernel.org/mkp/scsi/c/59f90f5e6c80

-- 
Martin K. Petersen	Oracle Linux Engineering
