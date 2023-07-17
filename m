Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 454B8C001B0
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Jul 2023 18:31:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjGQSbP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Jul 2023 14:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjGQSbO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jul 2023 14:31:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B31A1
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jul 2023 11:31:13 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36HEwrUv028908;
        Mon, 17 Jul 2023 18:31:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=GFhCa+kNA58ItG3ymKSeKqKzTxwwu5+bLy8mXr4y6T0=;
 b=AMbIivspSJRAS3v5gqf7KYJgebrxQW3OJgf3akGyleanxAP9Yr8Ws66sK1QvHOekH4ck
 w1727qlNkK9IN3yzlonQo808c0kmRP5yG3T8lamDlvCkvqPPygx4fgD4sNu32J1633UD
 rtNKJe2hBv31spE2rLxOtKEN9mkDdT9h9na7eE+Re+Illc9t7CPdkR+42Eo+tOGbz8GN
 4k5fTSxgSMmAd6/sp3Jpoin0zCqOqL8MruKtUyzTPYmhZ+nIsnevnsGYkuIHHiiimmue
 cmafKCMrA/63xMZhKEAcVXwY8h4KiSG+qXdXh4EUOseWi0VTIIA5K/UObzH9M2CX8oiM ww== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run88kcpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jul 2023 18:31:05 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36HI7pMD019202;
        Mon, 17 Jul 2023 18:31:04 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw4hytn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jul 2023 18:31:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QlKkCVgq+gaISdtYce8KUw0Pbc8bdFJ+WJIBT2Ct73fPDrBUzqgDihMCmvI9NRmILVyfG72Vz6uAzFPi2cPxeSLmgsa6jUj8d2PGRo+2UX9M+deipbkJzXvYkHdtyl6GDjl977GHQDwovxm7T9FwMRXXrk5bEs5wdQuxwDopYV4aH7SmpOGed/y6Jtlb01qUIdciZVBefXVIWYMuuUKdktQC8NqWloejKQ+zAS6SwYd6imQPDlQ9/YofXECadfMMHNoo5dZGRCfxDxeNeM6Nv9M3kP+67kfyh6eCd54UCoCE2qHY75bmk+IqGYL5bPl0nizlH1VPQafkhOz4riCIvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GFhCa+kNA58ItG3ymKSeKqKzTxwwu5+bLy8mXr4y6T0=;
 b=S7JdaB8rm78JequIikxZxi7i+Z91eFkLJWNPaA8AoyMNuWQ8MoD2OQMgIfFIuhZQPH2skiVN3yPdMD24mwdzJIB4D+yabTN3v9s8u80t0/TuSyn3OeBIQLUo2NLSsSTS595ymRn5eoLcpRxT4BwjcjHUWGIxyCRT19UaUMElAfzd4VhG8y97xciPDqe4DXA2qCG5M7niOiAfIOTsoFL1txsyFK/A4WDb0iPhlQSWFh2IcMBtTqzc1QixN0jbvbo5VU9SKjtu/2i0ZNYvpe1joQMBIPqPQbHvaH+tMHzrRzfAJhfOKCIGFyDbGlahJoBUn+21aocBEO4odSYZ2X4mvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GFhCa+kNA58ItG3ymKSeKqKzTxwwu5+bLy8mXr4y6T0=;
 b=Zxr8A5jZjxlkcPaeqi5iePf7/PYFlA/PLs1ne4EmhPYCv1O0SABA0yvBHa7Tn5TWT7eEp9rUM3IXB0kVerqgeQsEs1+4FuYesBPMi+lhIlwUfbShMtf5ku2XAbpqMMWPhPM6QJBzGJLs4tysUiLl8/qNVkxAT5seA2T7cqB5IpQ=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA2PR10MB4489.namprd10.prod.outlook.com (2603:10b6:806:11a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.33; Mon, 17 Jul
 2023 18:31:00 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 18:31:00 +0000
Message-ID: <12dfdc8f-2a38-e8ca-f0f1-84317d2303c8@oracle.com>
Date:   Mon, 17 Jul 2023 13:30:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 02/33] scsi: Allow passthrough to override what errors
 to retry
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, john.g.garry@oracle.com,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-3-michael.christie@oracle.com>
 <6fc0f1b1-bcdc-81d3-d9ad-00ed228e701f@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <6fc0f1b1-bcdc-81d3-d9ad-00ed228e701f@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR17CA0028.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::41) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA2PR10MB4489:EE_
X-MS-Office365-Filtering-Correlation-Id: baedcc6c-4447-4a2b-0fc4-08db86f3f869
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nsw/IYl2VF+GbXUes+/RzZLm1M/FGBBSZTOB3QNRUbU+uhlg9cxJOGXl5zA+Zx3QqgqB2Lo+Lr9KVkdckpP6uyYzT7mCvvOE3L9tAIslM9T2jKttYRWl8m67+ryDt10tFgWSk9TOeAvHOYD+jVGAepvvn1xNoGjsYSx1oitRhW/bpgXhWwFo8jjvdG01Aa79QhF0YpF/Pg5NKYpFypDo6e4T2zF0ri3MN6XU2tebaPMdmA8FGGlI03bp0pQhUs1ybedFlqobLSuLqd7AdZD1WXCn4kx4kpVxDq+FlR0ccDY2IPWS/0z9nIuVZMSu+fLsYBTvd9TTHVh5Nlf/iQlP+b+t3A58fUJ06niJ1Gf0kVpy+zdKy4yzNivwqedpUlYDGgut2Tp2f+g3qYl3YuBYjskLe9AXzCguebAjh59jcbj4JWz1i3AqUeD8PJv/vySJUYiGDTOR0oyL8ozxaQpSafdj3vJLY6KBs5yxzN5nRml2I4t9wWU2JTfnqEmAmv5XO2xOXOz9yvkyTofTnZEAuswwTk1WpHUro95hoZ4Asz17S9+ILlLGrU/UrB4y7oPThId4n/ko2uuQLL8wi+01Bc0XMUCJ3AuT0q2fTp1efO13OB1rS1quUb+cU0o2G7u1dtbUIJhuUB+fnAmcsu426Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(346002)(396003)(376002)(39860400002)(451199021)(478600001)(6486002)(186003)(53546011)(6506007)(6512007)(2906002)(26005)(316002)(66946007)(66556008)(41300700001)(66476007)(5660300002)(8936002)(8676002)(38100700002)(86362001)(36756003)(31696002)(2616005)(83380400001)(31686004)(66899021)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2ZNMU9TaDFXa1gwZ1pqUk4rWmQzT2h6S2ZCY0NXWXZFVnBOdjJOcFV1YUNF?=
 =?utf-8?B?dTRxamFUZmJVZzFocHFkTWFFL25zdzhCcC9jZkFvcDdNYWNoMFNpUXRBTEhM?=
 =?utf-8?B?YXY0bTFmNzdsZENVdmRQK1pyY2pHZko2cy9PK2FaT2Q4UEp0ZTlOSXIvMjM1?=
 =?utf-8?B?bUo5RmJGem1tQ1pOY2lJbGY0eWVscnhqSExFa1prMmFlWmZQK3EzZ0dzWkxw?=
 =?utf-8?B?b2pBUlA3VzZtUzM2WTBidi92ZVF0Q05pcmFoMW5US2dEdmFGcnVOOHdkVzdw?=
 =?utf-8?B?UnlGTlNBUUFOOStrWmxUanRxdXhyRlkrNytLa1ZpQm16OG9YS3J5TDc2MFNQ?=
 =?utf-8?B?aUNZQ095QzVKZ21sQ3NWeE5EKzVPdGwyYzhmOExrSjkxZnE1UXF4Qlh6dy9H?=
 =?utf-8?B?YnNyYVlYUUlVT1BWR3MzR1NjbERIVkptc3BtdkJwZ3hibWZ0VytDT0N5WWdm?=
 =?utf-8?B?c0Y5elMwSUlDOEdWL0ZFUENRSk56NFljdmUwVnlNaGN1U3JPWFc2SzZOZ3NI?=
 =?utf-8?B?MEM3NEFta3hyOGxMNFMyY210UXYyK1FqcTFKdGFHc2NxeWNrUENHYnVKbjZj?=
 =?utf-8?B?MkMvVzEwdWwvSm54NzNDNEVKWnRQVjdzRm5zM3ZWS3JFR21OcUh2MUhHM3Ax?=
 =?utf-8?B?NkIxOUhnb3UwZUNiRTJFNHpJRWhlenc2TkQ4azMvK3dYQnk3UWlubitTaE1Q?=
 =?utf-8?B?RG1iN1FTOEpxdVV2NXowbXU1bkI5UytMekVuaG4xT25VbzU4THRzYm9Ydng3?=
 =?utf-8?B?ZTJpejlKU3Rvc000R3ZpU3FPRkx5VVd5ZkkvU0lPTy9tdmoycmQ1WGxpTTVI?=
 =?utf-8?B?em4rV0o3U2VLZU1WN1RoSzNxeDZLK3lmM0lKQ2JMdzJCbXd6YS96R0V0bjRT?=
 =?utf-8?B?VHZGV0haQjREUkFXMDhEaXN2UFRaNFhoT0F5VTl2R0lCVTFaVThOaU1VWUtp?=
 =?utf-8?B?SGl1YjhOV3JTbmMrbWxUZUpxcVBZSW82VDNZYmpxNnh5dmJVUmgrY01JVjhJ?=
 =?utf-8?B?cUZPOWZOcmlYZjVmcTY3SFo1cTNQNzhuSG03TVVkcjRWVmpxUEdiMlU3d0Zh?=
 =?utf-8?B?YXdZVCtPT0puR1VxdUxyMGdTNDJDOVk5RWNUcFdyczMrYU91VW0vdVRVMXZ1?=
 =?utf-8?B?M3cvb2g1Smtrbk9EWWVqcmttY25QTktBaVd1OWQvL2t2MGJTajdOYjkwc1B4?=
 =?utf-8?B?V3paa3E0Y1VFS2JDNmJmVlBBbGlCU1BJekpRZEFvVHJlUVVOeG1kYUVLb2xN?=
 =?utf-8?B?eW0ycHAxTytUcjUzZnhNa1JpczRYRFE3MWdRMUo1dHVQYkU4K1FGU2ZMdkNi?=
 =?utf-8?B?MW9XRW1oYjBOTUpPMXJmT2JEYXhxNXZsMThPTHVRcEphV0htZDQxOUJEcEhT?=
 =?utf-8?B?MmFtbEtaUm9hbndqa3lORitabElFc0FBODZ3U29GaC82VTZKRGh3NCtQSXkv?=
 =?utf-8?B?VnFTUzM0WER1cENFQVhwekZObjFBQUVuZkpCUkI5TGV0OURxWVIyckViNG5D?=
 =?utf-8?B?NlZBUzh2Mm5vbFhJaTIxYit5L2RFdFZIWnA1WGdURHVqbzA0bTN5SUxHbzNX?=
 =?utf-8?B?L2Z2S1RtTmkwb2JxeTk3Y29hdktkU0pxQW4yWEJBd09IMTZGVjRDOG5KMXM3?=
 =?utf-8?B?YVpaSGVGTE5BcnJ4dTAydGFtSDhSTDRFUzRxUExXa1FXa2FaYUhBdU83N3pK?=
 =?utf-8?B?MHlTS2tTWFZjVGUvODJXaGt4ZWp3c0U2WE1xY3BkMGh2R2dPN0pYVjBDZmlI?=
 =?utf-8?B?V3pIaVNNZGFBNDYraVczWGJWSHh4djU2VTlXOHdXRThsRXorbDBhR3hOZkov?=
 =?utf-8?B?Z24zOTlEZ1FNQ05JRnhoVW1KeW55KzU5RENXKzVxUHFFN25mZXRFK2Y3U2lk?=
 =?utf-8?B?OXhKMm9OcHBxQ0pBanhMTWVZSkZoQStHNXcwK3k2eVJjMFVHelo3RTRvTUN1?=
 =?utf-8?B?NlhQYTVnYUxsYWsrK3lXMFJkdW5vdE1peWdMd3pDMWw3d1RWcnRZMi9ZQkI0?=
 =?utf-8?B?bk02V1QrbEJTWGVFNTdXOWhEbHV5QU1ZelhTMU5WVjRSRlFmQ09uUEhYVXNN?=
 =?utf-8?B?dVE3K1NUZkpLWmROdlkzSDJkcWNKdEdhMzFaLzE4cUoxNzhpU0tOZEtmbDFM?=
 =?utf-8?B?VkpKT0NTWUJja0FSRjhpZFd3SUxEL3NnaXpkc2g5K040M2hocVY5MVg4ZG1p?=
 =?utf-8?B?UlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: xOLkSdXEvt9xombR4j8R72pUqUuhF/XHbQEvHvJ6dxuLGecj4k59LnM/EVb6I2dWmKPpp+7xYRAwn7gaPsV6w3jhRZwkqoRaf3ve2G6IxFbH9u6ut9UEB07exOn6QRLdZpcvX9h8QeVkC8i0Uf6gpeip2Hxt0mVdZM38AENultNRcZjylnCma6R3PnYXNrpVOi3pTIwDeBR1USC7FxCRxfqmE99bD7c1drckmZqypapV95/ANnQ2JDmyVG6SvgH9duT8XhAx2u7j7JwuXTZ3hRfNJPVPfHM6WCM9YZC1cO5sYGtSv+w3qucEqw7Z8r6cNz/hWo8QRsGDNYdpE31N/WdvADVFycqrKNimbIsvZOTZ+5CqUmhFXWUFpZ6hrawpK1IFXfonHu6SerDyP2ed9/+EPOdmFym/SYq4+aZAdGFKN4utIhBpTh4pVQ8Bh6NRP8N5SRsxVAfNsersA6spyPE8yONrAwyq3hcLGz14W/KvnOvTJxiXqXZlm0LmfT7ttzbnxmBbGm/SbUEqDvYXrHBzICczU9jQMejH9T0qKkU3Olw3XX3zfYWqVP6sWRt1ueXD4D3/4GJn8WKLXFiO93owxLTTIyt+j0Bdwyh3cXfUjfrV3fbFOWBDWY9IkDUiUa6cJEpRhOxMHuJ6WXT3dXipLhf1KIFUpklZgnH4wFr40dsJ7Bfv/G7/rMmNciwL7tpZRJnugHQsIp5fxxPTz1reyxjs+0qGmb8OWpa6SVMQdiQ80o1vpu5vZaq6LCp0+fxFFowRqZBhxFI7T2/g0dRQblBkVkDcobtD63uQwWQoyUKHSZwfKFmMVCf7hpvsK4QmizwaFiwAh8mZn9J5EXaZpndmJitqEnTXPxm88LfwNyjy2eL3Z1FbdNAqhQYY
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baedcc6c-4447-4a2b-0fc4-08db86f3f869
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2023 18:31:00.7070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xEC3YuSdxhMfHH1jJtbQKJtzSWC806x5BVUXj5V8G/An4RrSC/lojdcbh9HFvwKbpTzXfkKpJz6Szp7/AxqpTPsUev1cxo9XXWl7yBMH4rk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4489
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-17_13,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307170169
X-Proofpoint-GUID: LtxsFUJKEZKwnwidhzfrr2KiRzntSx9d
X-Proofpoint-ORIG-GUID: LtxsFUJKEZKwnwidhzfrr2KiRzntSx9d
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/17/23 11:59 AM, Bart Van Assche wrote:
> On 7/14/23 14:33, Mike Christie wrote:
>> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
>> index 526def14e7fb..9a3908614dc9 100644
>> --- a/include/scsi/scsi_cmnd.h
>> +++ b/include/scsi/scsi_cmnd.h
>> @@ -71,6 +71,23 @@ enum scsi_cmnd_submitter {
>>       SUBMITTED_BY_SCSI_RESET_IOCTL = 2,
>>   } __packed;
>>   +#define SCMD_FAILURE_RESULT_ANY    0x7fffffff
>> +#define SCMD_FAILURE_STAT_ANY    0xff
>> +#define SCMD_FAILURE_SENSE_ANY    0xff
>> +#define SCMD_FAILURE_ASC_ANY    0xff
>> +#define SCMD_FAILURE_ASCQ_ANY    0xff
>> +#define SCMD_FAILURE_NO_LIMIT    -1
> 
> A comment that explains the meaning of SCMD_FAILURE_RESULT_ANY and
> SCMD_FAILURE_NO_LIMIT would be welcome. Does SCMD_FAILURE_RESULT_ANY e.g. retry only negative values of scmd->result, only positive or both?

The retries in this patchset are only for when result > 0.

> 
> I assume that SCMD_FAILURE_NO_LIMIT means that there is no limit on the number of retries?
> 

Yes.

Will add some comments.

> Thanks,
> 
> Bart.

