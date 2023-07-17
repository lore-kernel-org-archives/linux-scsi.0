Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ADADEB64DC
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Jul 2023 18:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjGQSiF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Jul 2023 14:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbjGQSh7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jul 2023 14:37:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDCFA6
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jul 2023 11:37:57 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36HF0dHD016424;
        Mon, 17 Jul 2023 18:37:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=CQ1Vy+GTNOhsYaJcdW8Z7e0TCM2jBg/jsSfQn+mrNVU=;
 b=HX1aTISPTCJ5mBJvx/B5hoRXqThxIqZB5s98ZUQc9Og6J80X4Qpn1TN3HPYlmfG/Dncn
 MIaz03igG+1RK/uOBfXnAhMb2KVewZYcjN7RApBSZNKn5VwkYMLO+aTBIK4gzhwyGD8u
 HjPjNBqYPdfgYv48w7ynjEVMv0iwMWMLWXfUetM/dbKIoqI1X5bOAiQcCFYQKXksrCtB
 D3V2bQLssIbMKD+HdlRJeECiKqTpdnj75FFkWr7wDUtO1lEfJFXPi+8deOTN/m6Geag2
 7prZGjYrZCZ3kcLR+C2iBPY6TsR+S9Ns4DsW95Pf6UUJfo76uK40qDj+sgf6GKMAMmPx KA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run77udvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jul 2023 18:37:52 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36HI6Zd5023917;
        Mon, 17 Jul 2023 18:37:50 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw4a3vf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jul 2023 18:37:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6nEC3feClzWc10pWyYHkDtUNTE7X0Gnk0u/e+uVg1Q9NwGrUDUkkGob+bdP+EMDLjB3YLXBwlQIDuMgUGqdFxiz14dNWulZGUMNQN1JO/ySZOOkQABJ7rh3KpSoPWpyfYxYHKoJe40dEGwULbCidXYtPg2TZ/xsQlMCl2BeRDAqyuRCIG4jxhhN1o6+edQbtR6d6kH3TyPTUwc8JylnJvOF195qn7Is+uWqC82UhtC4TF3O417kWssbVsQsoJAhRZNzd8s/mCzQNqOmOP36X7HqORoejSBxFbm1CZpTwHK/83djfFzj0EjdnkvaI/JWCoicvl4jlYYS5wOi3FAK7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CQ1Vy+GTNOhsYaJcdW8Z7e0TCM2jBg/jsSfQn+mrNVU=;
 b=JM9CA1+Hwe5nxSBn3HqDNoNVn40XXU+uXSGO0GAeA5UrMmGZt6DM/oCsEApBF8lRpuxSQGfYaGOd5N2T3QHbDv1JyVXWLr+Nch4KYErsmQr7rs9EEqEm9UXuB8jEqpDREY61tZP+20pdxl34yVusjC7R2SnNThjs1IWt2xwa3tLGUziIa2tj+GiW+Nhflj6fyDO5LtmcoOJdvFzGpAXu8YrlV0ZazFxGPJTzvbd1ybLKPgC0ewf5e+QYB0xhGkcWLnmaQeoaGfP6pM94JrDwn6+Vces7LZbUUXCOVGBiGQziOHoocNFiqksiMB/wo0Bf3giquja3ZuiijOiQhiJqSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQ1Vy+GTNOhsYaJcdW8Z7e0TCM2jBg/jsSfQn+mrNVU=;
 b=JZm3twMRZvOk6FGr/nYAQfjA+iyHRdcn0fdwToFBjZL6yBiQ5uCK0t0FR0TxsTpByWJsCpRBLP2JiaE+GxVrpyoAa8aX/UGwKwWB6DZinpdC3B3Dn+GMeW2RHj4c2Tgkp1sS4ZQlw2it6m2qtFelpdieaIooXCYpCLiC5ZBP8rg=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by PH0PR10MB5732.namprd10.prod.outlook.com (2603:10b6:510:14e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Mon, 17 Jul
 2023 18:37:45 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 18:37:45 +0000
Message-ID: <b7c94f6d-1b08-5744-cd89-6caa43e767e8@oracle.com>
Date:   Mon, 17 Jul 2023 13:37:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 07/33] scsi: sd: Have scsi-ml retry read_capacity_16
 errors
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-8-michael.christie@oracle.com>
 <4c1252ca-0391-869a-2018-986e685f3611@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <4c1252ca-0391-869a-2018-986e685f3611@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR18CA0004.namprd18.prod.outlook.com
 (2603:10b6:5:15b::17) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|PH0PR10MB5732:EE_
X-MS-Office365-Filtering-Correlation-Id: cfbfb2f9-a8aa-4739-6e6d-08db86f4e991
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ww3nG7Fz77qiNsADsID0XJfsX+f/1p+TkaTFrHOsROP7hfUI4BfvP7A2NaaASS0osBHuQfyO8IIpI1r2nTcwOZslD6lTdw1iZwiZLEGA4TYwCm2tyLoLj1R5mv95jrmWcixTSyEeA5AlZTieAvA0twhjPjtsMfDSxHwnnrokTarCETcwpmsJfIhtmHpXlkF5GlMdGpoLvLN+606mrDVDkanbyagWo9wWRDmGU/r83Q2vY6dbqQDqzlRmMKvWcVdi/C0ZXaemyvKsrJBxiHLDmvTrwvDyygjbAK7VMa4KWU6y3kxCn+Ai3B0pXFAndXjULQKxVm7HwMS6NB1yxfZJn/f/6dTTgaO9gYqI6rxoKXbS8M8j/dXRaUM4/c3qNKWPUjFvi4judJv/unhtlNTaGRDeKKeMcwYtoucbo0enOCIoSZE5yf6QRev/gMIFbCLz+f4r0MS1MoCRH7+6P2oiHK6JzI2ILende0VWc9kdLanVSfkXn5cKwZeh0TCYquWuAMjwgMcdnnaNVu9klEZ+dHgMcCpKYP4NhyUfVlnPyYh3DMn7J9nxmCd3Nj9QEqhNgyX7celNjgtuX6IBg0afGmOF0ruTLOSPs8oaidsY+Rsg8zVUTlrDGP3ynfLYVVUGcAUPuAHL6aEu6LlV/Kd+Jw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(376002)(366004)(396003)(136003)(451199021)(2906002)(38100700002)(86362001)(6512007)(83380400001)(2616005)(186003)(26005)(6506007)(53546011)(31696002)(5660300002)(36756003)(8676002)(8936002)(66556008)(478600001)(6486002)(316002)(41300700001)(66476007)(66946007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHZsWlJLSnFIN2lDMlpvWlhjYmtVbDZ2d0R4eE9hUW80YStOTC9wSndDQ1Uy?=
 =?utf-8?B?WkYwOXUyQUJ5UU5Cb1RzdHJkaFlXR1FzZld5Vkh2blZPbWdlMXZNcWJST1VY?=
 =?utf-8?B?OE5QN1hnUkVKY3IxVkNhcVB6K3lZRDlOYzROejhHNGorSWxiT0s2UWlPbWdE?=
 =?utf-8?B?YXFIYWcvTEZhamticjlTQUVZZW41RkpaVU93ajY2SjhEcTN1aVVWcWU0NDYv?=
 =?utf-8?B?S0t5cnlmQmswK2Yya2VZQnJjMHNDQ3hwWnNOaG5qSVk5WFlpcVlPamlMZEt5?=
 =?utf-8?B?aGpYRjk3Y0pBbkpSQzZXWXJlUzUwM3haOWdQY1R2Sm91K2hmQm1vck5tSTJy?=
 =?utf-8?B?OHhwRWYxUFVMOStTbHplYnNZSnR5Vzc1VUxmaVJhajhzZHBUd0tOQ2ZYZEUr?=
 =?utf-8?B?SVU1bGIxS2ZERnUxdVNCVHpMNnA2WkZUR1FxOHdqaW1Rb2F6dXRCNEZQOExr?=
 =?utf-8?B?SzRtR0RyVVh6ZWQ2QkJadGJJc01tYno2TEJwMmVNb252YVhKRUtSczJuZG9s?=
 =?utf-8?B?RUNWbGQ2TDZWekN2ekpCRlUzTmM2V0tYcERrV1M0Qk1yKzdFcE1XR0duT3lT?=
 =?utf-8?B?ZU9GeE5XYWhvT3E1aXl5WHduS1V1Rm5pTXNadStOU1hVcEhjWE82LzBKNHdw?=
 =?utf-8?B?cU9ITEtnTlhCMjdLbmovenZST0NyWnp0YVRkY01yZjRrQkgzL3c0TzQ0TEpM?=
 =?utf-8?B?WlJCckJObzYreURWWWd6bExoWXFHdGlEUFhBVkduZ1pPWThFTm9zaDFyemVv?=
 =?utf-8?B?MzRMcG5uTXRUZi9pYlE5QWRESDBZRWtUYytINFRiZG1jeFdscGRPWHA3b1pZ?=
 =?utf-8?B?NGMvbWNEYWtJMGFyQmlCUmtJQ3lPeXRIVS9YWTYydUw3NmhUVDJKVk1pVXBF?=
 =?utf-8?B?cXRHNHU4RFpla0tUcUNoQkJxbkVEQy9qMXFGeGJSbjdxcUFveTdrMitPVzZZ?=
 =?utf-8?B?aGR1M1RJUkRyc2w4dkdLUmpIOE05N1V5VzJMYlJmM2JQMEpZRFJXTzZkMlU5?=
 =?utf-8?B?VTZyb0g1aXgyV3J2QzJYVjFCMGhqZ1IvM1hQc3pYc01Zd0xIZTcrQzdEY05G?=
 =?utf-8?B?WkNqV1Y2N3RBNFQ3VzVqamlMY3FpSVBQSHdZdFZpZzRENGxiSDZkbGdLM2tL?=
 =?utf-8?B?MFpJSVg4QkVKMDc1STJPQ1NWWWJwQjZibnEvUGt0ampYdWZZdkdIWTJUUUZ1?=
 =?utf-8?B?M3RvNVlnY3BEc29hNEl4SnBMRDlpaG5lVDM2eFo1aDR6TEhLTFd1cmQ5RHc5?=
 =?utf-8?B?MEJsbXAvNEk2bDZQVDkwQzRLbXI1dFpFditjZXNFS2puNG1ob0VzcW05eVZG?=
 =?utf-8?B?MFVuMnBDeVFPY0dqSm4vTzNtMjF4WVoxZWYvOVVFU3BhcHVyd1FRQ0JRL0xt?=
 =?utf-8?B?SWRSY2JhcUhHbkdqR3VqZWhDeXgvM09wc21BRHpkTTdLQVhUQXdkVUhqb1lE?=
 =?utf-8?B?U0k1U2Juay8xNlg4Vm50V2tEK2xMY0hVYXNxNHNRc0JUeUhoU1N0QXM1c3Bi?=
 =?utf-8?B?TEtKbFV1em5qR1dyZStlNGdkQ28zckV1QkFHTU55ZE5lZ2lHZEpMS2M2REJk?=
 =?utf-8?B?eExuTFgrdEo0cDBxdnBpeVIyS3Qrcjg1WUpHNGZCMXpFK3lMU25QdFFrb1BW?=
 =?utf-8?B?NjlhZ1o4SXdoN0IwWGc3YVkyVDNxQlhyQlpYM3cycXFoWjhHcUtCR3dtYTIr?=
 =?utf-8?B?UnBRcThxZE43MGY4dWJvTmlJVWJCaVYveVBaRVdZQ3RJL0x2bWYyeHlyY2JW?=
 =?utf-8?B?UFFEbnhpMm1mN0FFaTQ0SzFWQkw4eUdZZ2RJanowRU9EWWRRMEpuVlM5Ykk5?=
 =?utf-8?B?R0JpbVhmTVl1Q2lvWk90VmZCMklZdy9udWl3Sklpbk9CRlhyVDFndmJWbWRn?=
 =?utf-8?B?bWZqeXNYKzFRUGNha2RSK1NvUndYdEpxNzgzYjNaVk1xWXhHSTBIVDBHUzNa?=
 =?utf-8?B?M0xxcUFScWRxc2ZzVm1mZy8yQ3N2NE9ic3JIbTZpQ05iQWFNVVFJT3kvclZY?=
 =?utf-8?B?RndoVjhGTFB4dGhzUDFUTEVqN082TFY4V1Vhem1OS0JpVlpOMC91OExOZWgr?=
 =?utf-8?B?RGZwbGpZaXpMZGZ0dHVVN002dDJXL3BUZEc0SEp2OXU4NVg2ZHFZUGt2d0Q4?=
 =?utf-8?B?K0ZVREl5ak85Qmd0OU9sbWtnbDFZS3BvV0hSUS9jbDVNa2JUMlNZR0FaSkNO?=
 =?utf-8?B?L1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: XxpUviE17qZEyvpDAq/c4e8qHGQe3y6E+VpZiO86QXykB0jSepoE2b3b0BEnyHCIvaBAwmiwz4ptto/3mQDXajI1F2ki0ecym5NEuo9+fz/z44xk8KRpCq+TKj7G9wyI6nSa2YtNclLEWqqNqHz6Jd04F3xe31H2/ae1147WLfXvp9D22k9m4ixMwU04D5NAylxI++AolNDgazA89xvFnMg1bIOT035lc0fKZu5JZ38oklViVO7j5+6ncG06M7w23/xcwbk+PavBj85soel+hGXw1CHjQ4uE08Tj7eMAqkKR1NqA1mb77DGrK/nx2BBjQReo05vh5uS3Ov24eyCFfgq5tgoATNsZiu7NqkaJaXOOr+DazK9TiT7QKCuaOLVRP9pAHaETazMGymv0awnM4vNBAcjuxYLlQWGEcoj6XG5XEj2IwPmZAVhYHtRMzb2e6j2lsVrihqiQvUKlCXlZQIpMby/8fHRWrFjY16i1vT5QVaDowy7sfaNh49ltB1jZW4aF+ki366EKLZSAbD6X4BoEpe7zwWr0/ajRW+35T4Y4m2WBwIhVmN6BfHBLgXdmOV99m13z+CzbYjVnsQHuDITrPZKgSkAqJ4k5x5Gnv2WZAfssPI7vnLurExjRwT18mc1+xAw2LURynp6job7HK8SnoQCaXa6Bowf1ciz3tMR9olj38B4SiIh4FjGkxC1bYbKffZeySFqWXaVUgbtMUmWPdgmQIRtrvw8SpwPF1OnYD7Uv98HRDH1h2G8inlyldvAnPdPcRyweLc0iAv0GNG1c2+xAgK/jcd7v89aH9rVsDrP5dEHHhCqwZyUsRWpm4zLgMvbd9RKykRqv3YinEThq4Pes3qBf19WPdln0Tw2u2eo6zegwXucHZlRTaLJk
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfbfb2f9-a8aa-4739-6e6d-08db86f4e991
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2023 18:37:45.2904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TrbZIOxl+yOBco02yNNY2m1ALavkTFqXXK88u3DabS9liebT9kWCMm5lIquK0e3dxMV/w8Ubfmq498RS62LW3/qIUGpq+kGNxtkC49oihvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-17_13,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307170170
X-Proofpoint-GUID: 3FOo6WRcUgLx7eE4Q4TVkFT2Q0pt9Fm0
X-Proofpoint-ORIG-GUID: 3FOo6WRcUgLx7eE4Q4TVkFT2Q0pt9Fm0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/17/23 10:43 AM, John Garry wrote:
>>
>> -    unsigned char cmd[16];
>> +    static const u8 cmd[16] = { SERVICE_ACTION_IN_16, SAI_READ_CAPACITY_16,
>> +                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, RC16_LEN };
> 
> In terms of coding style, could you follow previous style, like:
>     static const u8 cmd[16] = {
>         [0] = SERVICE_ACTION_IN_16,
>         [1] = SAI_READ_CAPACITY_16,
>         [13] = RC16_LEN,
>     };
>     
> Seems safe to me (to ensure we fill in the correct array element).
> 

That's nice. Will fix throughout the patchset.

>> +
>> +        sense_valid = scsi_sense_valid(&sshdr);
>> +        if (sense_valid && sshdr.sense_key == ILLEGAL_REQUEST &&
>> +            (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
>> +             sshdr.ascq == 0x00)
>> +            /*
>> +             * Invalid Command Operation Code or Invalid Field in
>> +             * CDB, just retry silently with RC10
>> +             */
>> +            return -EINVAL;
> 
> 
> nit: personally I would use {} here, like below, but that's your choice.
> 

Yeah, I like the {} when there's comments. I've got the not needed comment
in other patches so I just kept the previous style.
