Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0231DC04FF3
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 21:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C44B1613EE
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 21:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbhEUVG7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 17:06:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48098 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhEUVG7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2021 17:06:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LKxDT1048212;
        Fri, 21 May 2021 21:05:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=VfI/fmz6cotZgp21grpcaSHBiZQ8I+Uv8dIV6HfhIGY=;
 b=gUJLXVGn5nZyncjmJZRnKddMxoFbYkeDGwjOrsTn/fYHyiBUW26aA4ZcyXuL2zi5/itF
 0FIr3KLa55gn8Lf0GE04cJ9l9rgSFQ94wImm1VgDM1NP4rIsN9GGpcSPPiTYryvKNeiW
 /OYA0422roSeAT4awLMW9fDKjcvdEjdDbFS5Td6jm+k0iKyCvMxyUheQY1B2CG0OUSLl
 X61FnO62rssd31s4dM1va1xCSpvJJF5VRZlx8KXGlmLfmHbHBhbJDifT3omdQVzhs9Sz
 n5sq5G8/KKoezkKkaiER8NCZ6WE835nBhT1zjXKYDd9FwOedBZYYXpGTzUzpk+tv8rSd zg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 38j68mrqbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 21:05:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LL0pNY083837;
        Fri, 21 May 2021 21:05:17 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by userp3030.oracle.com with ESMTP id 38megnwkch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 21:05:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nY+JDtQyH9x/pg79hPSJsrFKXx6+iYfgVFE3YAsrXGXjnqWxoHcgogQqHEwGf13RiQRfigJ15S6u2Oo7bc5YnExEUEZZXh5VOnkmjxeOmZBcuuwz/V9jENV6wsGEPf91qhCpwoXUd01mUVLPaadjrdtXCEoCOhS8uIKCANJWF3knZCQYHRaDluCJO5Uin4CC/PZlYhXXnuBp5s/c8A13jW/uEGxv0Ca/zJJblAtDP3nxuqcbGrAIMWklFK9jqLg+aWqzGNwnlNgc7ZWiawse1bpPfHi2w9aFTgahyRU2wkSxM3f8v3WrOTh9LhBPpmyMlMNkbYMfaLSNCAxAyN3Hpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VfI/fmz6cotZgp21grpcaSHBiZQ8I+Uv8dIV6HfhIGY=;
 b=d8jD+nQYnOt+gKL23dyXEyE5UoGMv/ero7UfAjiIb30xDbHKdNwW/yDdmL/uT3YjWRLdEtIaoIktzMm+jIE/r7YxLXIs8DpNkjYbaG/XQz6OFGCKtAINWS+9oYKFKNJjrj7QZEq30Fy9tLWl9ytTPvZyUlNnt3kBSkCkHMmCDbUXIqp+BmwKFc12cOiS83sq1NoZWTfWdMrv2AM+cSw/4JYZmWDl8wYjkepLIEcp8rIhNj5PdT2ssQ6GPCBfDGOS5moyqHVPYRO/X/5s/QLEGdvH4lBFfCcBgLzMTOyIxtc3Uvp0TuwhiXouopWYm8qzDqn8DX8ingo+zXxEpmgnPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VfI/fmz6cotZgp21grpcaSHBiZQ8I+Uv8dIV6HfhIGY=;
 b=D6GhBY0KQa5RNLe0O7uBTKm/lWQoHc1znT5Bh40agSbMKy7hWDzcGzofC45zmaqTJbhS0Ne0CwSLGp8yu+gvSn8uKwDRc+xsZngKsZH7Sef+C0uLYhav9QLDu05HQGRGDZ3pb4SmTI/c3yvEnw8XB9Mv8CpbGNqwADvUSuyMMUI=
Authentication-Results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4469.namprd10.prod.outlook.com (2603:10b6:510:32::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Fri, 21 May
 2021 21:05:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 21:05:15 +0000
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: hisi_sas: propagate errors in interrupt_init_v1_hw()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r9z3ikd.fsf@ca-mkp.ca.oracle.com>
References: <49ba93a3-d427-7542-d85a-b74fe1a33a73@omp.ru>
Date:   Fri, 21 May 2021 17:05:12 -0400
In-Reply-To: <49ba93a3-d427-7542-d85a-b74fe1a33a73@omp.ru> (Sergey Shtylyov's
        message of "Wed, 19 May 2021 22:20:15 +0300")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0201CA0003.namprd02.prod.outlook.com
 (2603:10b6:803:2b::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0201CA0003.namprd02.prod.outlook.com (2603:10b6:803:2b::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 21:05:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87c7e937-b820-4aae-8aa8-08d91c9c21cc
X-MS-TrafficTypeDiagnostic: PH0PR10MB4469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4469301FE6A7B82BAD0AA24D8E299@PH0PR10MB4469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TBpMCE3oSKwH73Mu2MLk4oQ97d+qhdhTwOsECGVdV3YSHeaxTTql5ZGoT3CVGveX5y9tM6PgNMRSC9m/UuLCnJ4J+OYIUf6Z6y9iiotmUlZMyf+1BtszpSUxDUsXapZhAIWY+190VIeJpShXxHS/V4pmWVB0aHMYJdGfiPmIfjoYTpeb1R8SlOZEab1L+L0lOQ9cNpwAYb7nFChHTSY34L+eO470Izor+VkP/7gNYxGVI8ov00icOpIi+jo+eTxMItCIcklBB4V9iI4WFP1aIzxWT6/JzuhS340vWAqtCI8JvuTyRjJ2vcMQZlKq8iLWzjhNqQAQLH13bkfZGzHPbVqGF2cGFxH+N/+462hijp7ygneO32S8lvMuIa+5tuIs3bPoTpUAsK7zhRUJmucInNQOxZznqDRCfcqwld5wo4F5fKAeTJcggz59fjJ6IsEX3bqsCzmW8uqNrvBmBAZYMeyqkNV1xnsTBdn0COmPQArg4VZNgvw0T/g8RKay1p76D0QcnOUmJvIl/rIi0NtHk+1RP00AS1fODo60UEv5ZU/7PrjXGooYazxeEnR0Di7ndAkrjVXbv0W09u1KVV8uyM/EGsitUiRss8lGUJvcPTcLTzxupqPRALsYsCnvExV5643JoA0unXwrSi6QSX28hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(39860400002)(346002)(136003)(16526019)(8676002)(36916002)(6666004)(2906002)(66556008)(66946007)(66476007)(4744005)(26005)(478600001)(186003)(956004)(52116002)(5660300002)(7696005)(86362001)(8936002)(6916009)(54906003)(38100700002)(38350700002)(55016002)(316002)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xx2uju8IxAfzUN7zV5IT7wQkjKV45OOcNlzYHWYOWi0hZkE26KIlP94taIXy?=
 =?us-ascii?Q?Cyo4zeZyMBWivtC9BmheLiG2OBfn1epniaczSIiO/WqgNddERCf0YGwWvbvA?=
 =?us-ascii?Q?9S/5Rn60+t/u2UFHIVy7qCdJVDGjICfhNBRttc5WnkCRDVNrSCjdpuD9yA2k?=
 =?us-ascii?Q?ZXCn+Wz0eStxS9avaT8vf1sjG/89mG90L2h5Vtqa0UBeSORpJs2c04Efxxbp?=
 =?us-ascii?Q?/dsQ0jZbDXIpwZ/02ujW50CdYpY4wtMO8m46FYY1VM2utOqnBh8JifSUfVbV?=
 =?us-ascii?Q?KQAMdThCi848HZOttdzuzuebQoM3H6KAKoHIWHF+hKTsGEhOQsZwiBa8oMoR?=
 =?us-ascii?Q?YOzyLKnYtRT34NIZPd3VMn8b/cU3PiMhVEMEudSvNis/VZuj6bDpSMBg7sZB?=
 =?us-ascii?Q?BenVlWIvXxtm+1vDvWFKtCQT26F4ZOmmbKphjExtR4eQbMK759TKB50qbSRb?=
 =?us-ascii?Q?nEg7q48IdduJxemhfp/F3Bgp4ko+i+xD41/wi0+WnbqidOyZXjCWZNn/kTBS?=
 =?us-ascii?Q?3AmJnS2OJZO9kPc38f0Nhvpprk4lE7rPWTbcvnxdoUe9Q47kxscergRG5bDU?=
 =?us-ascii?Q?ivQPxDlqLXSJ96JR5qvJZwJRFj/r+Wc6IaNSBIhqS83V3pxEuDuA7Pqfjrg2?=
 =?us-ascii?Q?ozwFT8IoaaOB401KjjGiTTY38j+ZCAz+5pWFp/mY17A/e/xbmjFWvPZdcCDi?=
 =?us-ascii?Q?bMn+j5Le1oVOXV1EpgxNH/IyMiXmiI6GyccaEolp6Z5NUrJnhHH8ERKcJICn?=
 =?us-ascii?Q?HPMrfRwjHJ5x6obs+L62mDvjNyimYr2qHLW6EOZfv6Ip5YwJ63VlnbpJqPJ0?=
 =?us-ascii?Q?H6PLkTOZjTuV05IU0L38SkE3JUCmqUFSWdInRFZsJS+0mmvcDvavuvuRcq1Q?=
 =?us-ascii?Q?XVSYl1gKIDZC2C+GF2W24KKdJVUal/uYPiU2HCUTFrTnf8I2e6xhxOW0gAsh?=
 =?us-ascii?Q?XSgH9QeIaHANT692PqGDlSlFQgCMtU7d22PP9pKRU39Tc2MR+lYwnGw9tzbA?=
 =?us-ascii?Q?9q5lyZphkdaCKtpYKJrHegR3UppuLI5Fu/3btJgCSUk+jwZ2mMqAsGb6oQI/?=
 =?us-ascii?Q?id6i1FikX+rqEWfGu1BTlPXwEDHv3Ex4RjKSokGW1g6i3nOFy37MpPwn6tPJ?=
 =?us-ascii?Q?iLB+Ayo3A7HukvdJx+jnN1aQY/UoG1Fb/WLmzqdiU0UKOKOZuuVkPE9tPQph?=
 =?us-ascii?Q?iyhxJs0i6MGufgR4lSpdxZGzl0cFyqJWjh0MuL5uLCWiSgmsE6lhvxT8/RL/?=
 =?us-ascii?Q?zjMTXy5/Jev48WVKTWst4OGjk573z+AWLqMQf4T9U8iepvMpZ4yBKFTbzLis?=
 =?us-ascii?Q?WT09TnN+advdMdKGjLJA3VkB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87c7e937-b820-4aae-8aa8-08d91c9c21cc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 21:05:15.8419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B/L3Bg63+c9+YP79BYEOnVqjgp305F46WOlRcCg588qyLPmUEEE5cd85AFKgOKOHxPMg0a4MJBUrDskmeQMkLb0V9oWOACict5W8KRSL12Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210114
X-Proofpoint-ORIG-GUID: ApvHWlc9BV0q77DxwAiZtDv-GHZ8M9s8
X-Proofpoint-GUID: ApvHWlc9BV0q77DxwAiZtDv-GHZ8M9s8
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1011
 adultscore=0 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210114
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sergey,

> After the commit 6c11dc060427 ("scsi: hisi_sas: Fix IRQ checks") we
> have the error codes returned by platform_get_irq() ready for the
> propagation upsream in interrupt_init_v1_hw() -- that will fix still
> broken deferred probing. Let's propagate the error codes from
> devm_request_irq() as well since I don't see the reason to override
> them with -ENOENT...

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
