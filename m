Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3805AC07E95
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1525A61374
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237244AbhGNBQM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:16:12 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:46052 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237198AbhGNBQL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Jul 2021 21:16:11 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16E0vOMf025444;
        Wed, 14 Jul 2021 01:13:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=k3E8SgrRNT6PIN4HvMZBjqxbWCdbAtLefyJKk3kl3Ms=;
 b=AslnwyNy7ZxihvqX5QTn3VY7Z3EHHspkUdLiyJBSFLwDpezftOZgF2raVClbcpeZNETb
 U9RieLo6gXd4qEH34Z9wuDtBk8tYvfXg5Afxbml/zD+nOS6/7RQPI/bbMKYbxIApPriu
 KyKAtu/EQEJshuyQ4dfwamQKUA7Jz6JWyDlvkwvHDTbz69D01Zem35KunNGPHoTzqSdM
 oQTIQpwgqfXUR043QCoIaZf0srSlfdYqyg7hycZezHQ/eQdZgKpqvFEvl8u5VEeFCjEt
 3mtaikzMhru9Hv5OO0E1GzrkhVjISlw819qpp9nFD3ZtUcHCZyjQemRL3Cq1F/8rXUKc VA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rnxdktcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:13:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16E0suUG035645;
        Wed, 14 Jul 2021 01:12:59 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by userp3020.oracle.com with ESMTP id 39qnb1cvc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:12:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kd9mZKGfcf3Ohbq6QsPaUQ//BIfaGe2PU/teH8SJ+WgsUx0sa7mypyfsxbZ7asBHPi+U4nBJt9/WMR/gV8Q5CcMigSuqMUEX1mnmv2wEGQslGXrseWrbdyNtKT1xc/bEIwSnIvVIkaNEF31u4Ltgx6+myJNaAlJeSxn/2aCl+aWoOJHxhOZoA0lgMOWpr3aaNO2pBY9+N+fHGm1O/jc5DjGqSk8IW6Gqj+rhgbujPB5pCbaDVnNEhyAZ/yqjdQ1+7q24F2Aa/2nyCX0aGtqagaUHNWfaAW1SIsQSxr+vlRvNgIO8d5IEe339CWcw62ZSm/kd93H6B9YuFYMYYQ4l0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k3E8SgrRNT6PIN4HvMZBjqxbWCdbAtLefyJKk3kl3Ms=;
 b=h9W+pIW6/KNri/6BAkXX3VErzQIWURRmN4hRHJ55X4dOOl+hk4mH+2M/sbvpYy9jRI3pC+Oq2Qtu0Nn/n1qHr/7YfPqMPuVK/XOx0U6lKjolb3vfcFKoka5Nlle85ENKi5uymxWbTsiCL5EWk58ijZ6T2cD3cfm7dz5ea7Mgu/VjaOpijezk99yqhMyh1ywEXTQyNX3WT5d/ThH9mLqQUnwrQO8obReBFBUOcQT/x8OxNzhqxkaG2z8aVQG6biv6IQ88Mazi+ZUfeq9k4zd6elu6PmyDoc2KfrsZzI1o419bjGqkG4IoeFjICx9uga5CKuH4DKaIWndY0aZrJmJiYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k3E8SgrRNT6PIN4HvMZBjqxbWCdbAtLefyJKk3kl3Ms=;
 b=vfbBaVa0M81yA42x1qpOb98Q7Xjd/HSDgogVCAGe9ZsCdTDeYYfSEM9ji+HKcN848U4tlRhN3vJL5I4t4a5ahp7OkymQx7NZjRjhkHYQXFZFyDbXWHXUkvebfsIKolDHj7rJIfT2d73wL0i+jVSMLCDEaV8Wc0RDdwmXwYZ6GLg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by MWHPR10MB1629.namprd10.prod.outlook.com (2603:10b6:301:9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Wed, 14 Jul
 2021 01:12:51 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f%3]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 01:12:51 +0000
Subject: Re: [smartpqi updates V2 PATCH 2/9] smartpqi: update copyright
 notices
To:     Don Brace <don.brace@microchip.com>, hch@infradead.org,
        martin.peterson@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Cc:     Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, murthy.bhat@microchip.com,
        balsundar.p@microchip.com, joseph.szczypek@hpe.com,
        jeff@canonical.com, POSWALD@suse.com, mwilck@suse.com,
        pmenzel@molgen.mpg.de, linux-kernel@vger.kernel.org
References: <20210713210243.40594-1-don.brace@microchip.com>
 <20210713210243.40594-3-don.brace@microchip.com>
From:   John Donnelly <john.p.donnelly@oracle.com>
Message-ID: <690fc3f0-004b-0c4c-f772-8f0d9b55d8ac@oracle.com>
Date:   Tue, 13 Jul 2021 20:12:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210713210243.40594-3-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM3PR11CA0011.namprd11.prod.outlook.com
 (2603:10b6:0:54::21) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.106] (47.220.66.60) by DM3PR11CA0011.namprd11.prod.outlook.com (2603:10b6:0:54::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 01:12:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0844e24-233d-4c85-ad76-08d94664802b
X-MS-TrafficTypeDiagnostic: MWHPR10MB1629:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB162985B30852F32C8D61F029C7139@MWHPR10MB1629.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1grrMiI3CcDrQ0xGZCrnY7xBW16rFyF7avLhV2p+LqoCfH2CVq3sItrK7+aFvD6Pz0uRBRRbczuuTwrgQLoOLI4gr1mTXCobTqF326IpRtfkg0kcZM8b1Q0kfdU9DYSO/kXxuW4vKPTvkbzo0tIPH2/ENDUmwyuFgCmhu95DtzYQRbEJTzMe1fXsPAi8ELVbBa6z/ZY1MIsQE6xT04VXPhUB1+TF8HA+8IyEqVl+3uRoLDn9FTQ06l/2HCfzrkAT9Q4UlHqnmywDkOZ31vb6Cp7X+DzEvkHwmiRH+/sEoufOxVgkkj2ZthJjwV0CFFlHcoB0MdhejfQdA1dXv17DUgWEMZ5yDp/u1loFYvYweJRCExoj7G3xL8fu7SfEoJWdbdpS4gk8wG3nky4OXzVRMU0QqpAPTzXgI0+h9ffXOcRS4NQ2zB/N2hsJ+sSFOsYYHJ+zSpY0fUBtLXM9YlywFSMIkgqQzqrxlT2nkYHqsJgzDfQXKi904+hqm5i0/pdssGySnIvlex2xkuBJ2qP8byPnpMc5l0O3VsobKNI3SyjSTwxdRqNGD+Y28ykYhysZ/nsGpQt8XRAJgaMfSBqwcOVN+MtJ6zfvc4dTY1vhnMuzgYneXrWoHnxjdM/3mvaEmRTFFHgJP/+XEJjpRMjp+L3GENJtfGe+Lqi7Z0FkH4Ph0guwouVTskzCHvK/z7gr0wOGLY4R5rjangFgmi1yLVAEBPubBpzJCxn/H4vbB7A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(376002)(396003)(366004)(7416002)(4326008)(478600001)(83380400001)(2906002)(6666004)(66946007)(15650500001)(36756003)(16576012)(66476007)(66556008)(2616005)(956004)(86362001)(31696002)(38100700002)(31686004)(316002)(53546011)(26005)(8936002)(186003)(6486002)(8676002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aW90YUpIK1p2aThRa05VWmRuM296OS9uMUcrTUcwMVZWMEkzUVRQVGZlZGZa?=
 =?utf-8?B?OTF6emY3MDZiS2Y3QTVNclpVdTBxb1hQSXNwVFlsRVNVeFlSMnkzMTY3MmVn?=
 =?utf-8?B?cldBbUdBbmtsMGlDcmtPN2Jnc1oyWEFET0ZSejljWVJ3SFliQjNNMURVdEM4?=
 =?utf-8?B?dGtPOWZZUEF2UzUxczV2VUZHY1piSE4wL2ErMmdGRG5QdlhOVldKejJRRGhS?=
 =?utf-8?B?cFhSa3NxelhUUkpSbGtnOTJsTENQQVdLYnhqN0FROEthbWhNY1VpQitJM2tC?=
 =?utf-8?B?aU5HSCt3M1Z5RXYzV1hOeDVuOXhrSjRXU2xXTFM0My9WQnJWbGdPZTFoUXJp?=
 =?utf-8?B?ME5HQnZocytxQUY4SGZGbmZ3Z21tQmxtaDJyWTN4VE9ZMXNWY1BkL3hwQkdB?=
 =?utf-8?B?RlZvM1JuOGZWeEwzVXQ4VHB0UkVRdGhLclk3dEFRU2RSSFloNVh6dGF1RFE5?=
 =?utf-8?B?b1hTSGF2UkEwU3ZCOXViZ05qaldFZHRDWjNuR3A4ZlFFQ1FrRzE5UkNnSUNR?=
 =?utf-8?B?ZmsyTm9NYk14c3JwMS9iRUp0K0JNTXBubXdpTGtvMVpRR2pXTEJjbXU0UGRJ?=
 =?utf-8?B?R09RMWU5NHZxZkhkR1R0c1VqN0ZwVTBaeDFGYUdUQkg3TVRBdWloTzQ2bzV6?=
 =?utf-8?B?VXhIZ0JITkNzU0tQb0RoR1hKc2pZOUR0OWR4d0t4R0Z4UlA2Vnl2Z1FDYW5N?=
 =?utf-8?B?b2dvTDBPazVIdi92cWtBNWFOT2tzSWQwT003RjBhcEFkWk5qTmNCQmVPOUZt?=
 =?utf-8?B?SWtGOXlvRHkzOEVqbWlFS09VV2dWUzRvZlg2UnRJa0FONWltUUM2bjNwOEVj?=
 =?utf-8?B?ZVJqSEVsQ2pOYU9vRUlteGlMWHdkNHQ0NUxCM3JneXh3eUdTU2NGdDlHTjd3?=
 =?utf-8?B?cVRCVjRmVDVpZDNqVUQ1TklUYWd2ZU9aOFpINC8ydEMxMVFBU3R0Q01jbGVl?=
 =?utf-8?B?ZDVWL3Q5U2ljamMvM24zUHE1N2xjYXZtMlB0S0Rva0VqUVUvOEhTS3pMdW9K?=
 =?utf-8?B?aThUYlNHaUxES3pWVE1IR0FyR2cyOWNHMzVJeW8yZ3AxbUE2bytxNTdkbDBH?=
 =?utf-8?B?TThMRUt5ZHc5ME9QcmtDQU0rV2hoU0Q5M2lnZXRXWWxreXVCc2JQcld4bUhH?=
 =?utf-8?B?dDhRRklUMWE4Q3pwckc4eE9sREtxbmgrS2piNjYvWFFzUFg3WElJTm8vKzVV?=
 =?utf-8?B?ZldBcVZsbzdIaGZLSXdDU3Q0YVJpRVBjYkdpSUpyYlJKMHZ4TjlnYS8vbS9z?=
 =?utf-8?B?dFhDMVFHcHRObGN0MFB4bUc0eXp4ZXpjZkg0R24xeExxcHhkditoaFErYTV5?=
 =?utf-8?B?SWJxYisyRWVTYnNHTzYzbzFCbWpHaXF3TGNFUnUrbzl2YTBOWW96RUhBWXlB?=
 =?utf-8?B?Ym9JeENwSXppcHdhUzRXSk9RcDA0czNLRXpFdFlONEVDSldEdURqR2xlcDg1?=
 =?utf-8?B?Qndab0pMZk9DMUFrcTFOY05HeWRvbUYxTDliVllOOFFaL2ZESzUwdzJZNWVQ?=
 =?utf-8?B?eEFxZVl0Y2dpRnZXM0JsTXJaTEhsNWVCcEM2VEIrbDlsYkxBekUzNmlpYzY3?=
 =?utf-8?B?ZmdOS2JEVndSbUlGY0ZCNjNtMEFKUFdTaTU3Mk4rZnhVUGRzWHk5VUFsNlUr?=
 =?utf-8?B?UWhCNVFoTjZSaHFpYktoOEw5Mm9NWGlreEZJSVlvaVBTdlhwcmRpcFFSbm9N?=
 =?utf-8?B?QXpPOGU1T1d3RHpZOEJIUkF4ZEViZFJlNlVzYklzTTB6bXhramtpNy9yd0kv?=
 =?utf-8?Q?oHuIyh7VCTuaa3+n5Th8CpF43sG0wYz5URggPpu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0844e24-233d-4c85-ad76-08d94664802b
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 01:12:51.2149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1maILkI1CTIOOXAqobf1HV4EZR5NwmSUfibeL8Le3mIpJsaRh/MGycS0J1eNLmlAkNMYFZMcGiT2kQCbtGx5Im7kYr4PRsqMCWDPQ9+d2FI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1629
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107140003
X-Proofpoint-GUID: T8Vwkqv-V8UTr2L-yYr2v7FC5ZY-_2At
X-Proofpoint-ORIG-GUID: T8Vwkqv-V8UTr2L-yYr2v7FC5ZY-_2At
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/21 4:02 PM, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microchip.com>
> 
> Updated copyright notices and company name strings to reflect
> Microchip ownership.
> 
> Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>

  John Donnelly <john.p.donnelly@oracle.com>

> ---
>   drivers/scsi/smartpqi/Kconfig                  | 2 +-
>   drivers/scsi/smartpqi/smartpqi.h               | 6 +++---
>   drivers/scsi/smartpqi/smartpqi_init.c          | 4 ++--
>   drivers/scsi/smartpqi/smartpqi_sas_transport.c | 4 ++--
>   drivers/scsi/smartpqi/smartpqi_sis.c           | 4 ++--
>   drivers/scsi/smartpqi/smartpqi_sis.h           | 4 ++--
>   6 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/Kconfig b/drivers/scsi/smartpqi/Kconfig
> index cb9e4e968b60..eac7baecf42f 100644
> --- a/drivers/scsi/smartpqi/Kconfig
> +++ b/drivers/scsi/smartpqi/Kconfig
> @@ -1,7 +1,7 @@
>   #
>   # Kernel configuration file for the SMARTPQI
>   #
> -# Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
> +# Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
>   # Copyright (c) 2017-2018 Microsemi Corporation
>   # Copyright (c) 2016 Microsemi Corporation
>   # Copyright (c) 2016 PMC-Sierra, Inc.
> diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
> index d7dac5572274..f340afc011b5 100644
> --- a/drivers/scsi/smartpqi/smartpqi.h
> +++ b/drivers/scsi/smartpqi/smartpqi.h
> @@ -1,7 +1,7 @@
>   /* SPDX-License-Identifier: GPL-2.0 */
>   /*
> - *    driver for Microsemi PQI-based storage controllers
> - *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
> + *    driver for Microchip PQI-based storage controllers
> + *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
>    *    Copyright (c) 2016-2018 Microsemi Corporation
>    *    Copyright (c) 2016 PMC-Sierra, Inc.
>    *
> @@ -59,7 +59,7 @@ struct pqi_device_registers {
>   /*
>    * controller registers
>    *
> - * These are defined by the Microsemi implementation.
> + * These are defined by the Microchip implementation.
>    *
>    * Some registers (those named sis_*) are only used when in
>    * legacy SIS mode before we transition the controller into
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index 64ea4650ca10..6ce17a191c0b 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -1,7 +1,7 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /*
> - *    driver for Microsemi PQI-based storage controllers
> - *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
> + *    driver for Microchip PQI-based storage controllers
> + *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
>    *    Copyright (c) 2016-2018 Microsemi Corporation
>    *    Copyright (c) 2016 PMC-Sierra, Inc.
>    *
> diff --git a/drivers/scsi/smartpqi/smartpqi_sas_transport.c b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
> index dd628cc87f78..afd9bafebd1d 100644
> --- a/drivers/scsi/smartpqi/smartpqi_sas_transport.c
> +++ b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
> @@ -1,7 +1,7 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /*
> - *    driver for Microsemi PQI-based storage controllers
> - *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
> + *    driver for Microchip PQI-based storage controllers
> + *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
>    *    Copyright (c) 2016-2018 Microsemi Corporation
>    *    Copyright (c) 2016 PMC-Sierra, Inc.
>    *
> diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
> index c954620628e0..d63c46a8e38b 100644
> --- a/drivers/scsi/smartpqi/smartpqi_sis.c
> +++ b/drivers/scsi/smartpqi/smartpqi_sis.c
> @@ -1,7 +1,7 @@
>   // SPDX-License-Identifier: GPL-2.0
>   /*
> - *    driver for Microsemi PQI-based storage controllers
> - *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
> + *    driver for Microchip PQI-based storage controllers
> + *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
>    *    Copyright (c) 2016-2018 Microsemi Corporation
>    *    Copyright (c) 2016 PMC-Sierra, Inc.
>    *
> diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
> index 12cd2ab1aead..d29c1352a826 100644
> --- a/drivers/scsi/smartpqi/smartpqi_sis.h
> +++ b/drivers/scsi/smartpqi/smartpqi_sis.h
> @@ -1,7 +1,7 @@
>   /* SPDX-License-Identifier: GPL-2.0 */
>   /*
> - *    driver for Microsemi PQI-based storage controllers
> - *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
> + *    driver for Microchip PQI-based storage controllers
> + *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
>    *    Copyright (c) 2016-2018 Microsemi Corporation
>    *    Copyright (c) 2016 PMC-Sierra, Inc.
>    *
> 

