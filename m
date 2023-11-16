Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F178DC197A0
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Nov 2023 11:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344965AbjKPLjn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Nov 2023 06:39:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjKPLjm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Nov 2023 06:39:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE1D85
        for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2023 03:39:39 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AGAsfo8007677;
        Thu, 16 Nov 2023 11:39:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=OlkjC9B458HC1Gf0gkzNZ9U7CSwYKe7zdP0yLXqUfYo=;
 b=LCE86hOyKPh60FINYPkSwdZeD6JmDS6LoaKNIZPLGD6xNBZ5NbCP3nLDHPUMeqL0tNGX
 jwIwdFIp1yuMY8skp97uQJkDX2hho1mjGfe15GMsGET57D7PCXpkQiZip+LiJlgABkQ+
 F6nMx1CCg0t/O5PTXAW1vGQF3g/zDMSnrTlVoPOeeKQcPjjRHaMHjk8EN0Fdskhu74M0
 MZf53ry1fch6ypQ5yI1TM4Xi2/OEknn2zD9usOssDHCMjjTkE48s0eMYDm/4m7OtvfrQ
 cb+1ZbFD5HFzSChIvrKAajL3/vFpLb/gGGsX4hgrBg65ql4MGgYX/AUqKbxzeHYx9Z4H kw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2m2ju4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Nov 2023 11:39:30 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AGBRT29039137;
        Thu, 16 Nov 2023 11:39:29 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxquydsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Nov 2023 11:39:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fR8uIXAmzlNHnzhEx6YFIYzLZCzMkWb6KBo3A46RILj8lANkrvbEg/YG7GgTphdXBp2WLDzw4c7ApiOKWXmVvMdLDuW1Es+eFCW7H4/fh7AF0sGCuwshIL9hRuntixt7YwUA8btRZDZ5YWEaD98iDV/y0TC2p5IVueqMsV4pYeP/wNHWMYr7uNMrxJG8Bkc7Mt/NQMyyAZUzO/882ph+zAq98uo2v5W803FUhz1Mt8uxvzWvy661uZXZQPvkjXgPEzzKY1n5ee5yE6kJEV9R73EbEbdvme9swoOo26QxN7PkAdfouXn9i7ZrxCjS+WcIlskhWtuqgf4K7BTxjqOwmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OlkjC9B458HC1Gf0gkzNZ9U7CSwYKe7zdP0yLXqUfYo=;
 b=lrjnp/cnoYh0UGcm5eRVPlXlQisaonZ9KyCMElUtvz12gxxmT3zeJyjgkE5s0zmpX2WcAvSDHU8Tc+a0fY+c+uzsny5hdrG6MpVMuaWQ7hRdx92gbrkJ/gur7jeNSdNSIuH3eUQY8JnNlnHOokotJYOrkRvCWJj8pkOG6Qwvs043Z5ruomlcpIMZwrHvZI+e1jYxe3NZdGv4zVwpS0IrWC0sdh+1mWCNUdf6KqwzBsJchtTMKTZqKXUvIME0Q47FC6KRKcRvLbepb+Jjr5/jn5aUfUIGfh+bBM92t8SZtKaL+zS6zh9KH6upUDZvEvRZQZKdN+dPP9Xm7rAJSebwCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OlkjC9B458HC1Gf0gkzNZ9U7CSwYKe7zdP0yLXqUfYo=;
 b=viKr+8k9wxKhuOllK6CPxPCVvx4eGJ+umvZwY2RX/GXEBbkZKtzkXdiXLwqvgfRQowq1LDlGaxNxeZa2Myz0dwDsjS13FlHP2FmtXAhsGxBVm60Nrv6mPMHoS+Yhcc4Ths65pf488m8JzYY4PL9rWa9CS4xaMxDG7gOV4NR/Nu4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB5229.namprd10.prod.outlook.com (2603:10b6:5:3ab::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.21; Thu, 16 Nov
 2023 11:39:28 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::102a:f31:30c6:3187]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::102a:f31:30c6:3187%4]) with mapi id 15.20.7002.021; Thu, 16 Nov 2023
 11:39:28 +0000
Message-ID: <89938a66-7203-4809-8d45-c820b5a21d4c@oracle.com>
Date:   Thu, 16 Nov 2023 11:39:24 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 04/20] scsi: sd: Have scsi-ml retry read_capacity_16
 errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20231114013750.76609-1-michael.christie@oracle.com>
 <20231114013750.76609-5-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20231114013750.76609-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0210.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB5229:EE_
X-MS-Office365-Filtering-Correlation-Id: ec59a4f8-8c32-4dd0-2530-08dbe698b0cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JsKug0CW3xi/87SU+q0/xmnQ2R1AzyS3gM4LA0QKJ+2nDCFAZeIfXQ5+n1mBgbIom3dlTG1R3GPkDVffGFEu5xVSoxGsbfMmVcidxxn8INT5wK00zEAD8Atd1LJ7JUIOu2SpXQYR2IX7DQIAqp7j5QIaTImJo6FTg6w61L26uQXeRLrRGOhxflDpbP/0+T0jQlBE2PSnGva4e7Zd+FByf6CmN523nEEpQ4VCXUFHAxUvXAxEXvzhj9qP4vWsSspu+PfntwmQGCR/0976z1w0U0qfH4VOxtSVCusWVbxVGWUkJWKs6Cy949SanE0ntfvmiVJqbt0b6H3oaX50DBIf09GmwKB4/jiwHB4dpkscdkRouU+JYAVQOLZ5IdWt/BcphbHqm6uhDCGceFrfBvHCCM1nt69jjoY2fHNDzTyM7SKp/ezxCMdA7nxU+/0lh1qZlOFbGm3oPRLi7hVqGZvCZq/owDYl0pWjl3VDeMCtHEzJrFb0t1mWiUJhSPNDudX5CLR3ZTMyBXLrQtbbHL7C6ksQ0M/3KSlrEzJV65u2e5W5Nzf6ALPkfIJO5/a3PuPx8k4GO9hGMJ8YtnXpGhpuMVhrSJmDQ81xGGDyh91u0OEI6VLMC6a+xtfECbXJOn4MONys2Cgeix3lcwADcKolOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(376002)(346002)(39860400002)(136003)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(66946007)(66556008)(66476007)(316002)(2616005)(83380400001)(26005)(478600001)(53546011)(36916002)(6666004)(6506007)(6512007)(6486002)(36756003)(38100700002)(5660300002)(2906002)(4744005)(31686004)(41300700001)(31696002)(86362001)(8676002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUwrdnBZM1llQUJFQjJyR0xSd1d1MzdpSElQcXVVa0ZQbFFuNGZIY3pJRWNJ?=
 =?utf-8?B?WGg5b3laR2ZhUG1nQ25adWVYQnZCSHBmOVVNUTFueGVyMDg4aDRXaVNNc3VB?=
 =?utf-8?B?dXZ6eUc5RHNBdW9tcFc5eXprdFBVTTdlZ2swdXljdGZLaDcwd2FEUHdQak1P?=
 =?utf-8?B?WnFvWG9XUnZhQjNaOEYyWUs1SWh3STdVK2s5S2NUWjBrZGN0Y3YycDJaeFlJ?=
 =?utf-8?B?bzBkYWZ5aHNaNkcrZzVjb0ljMkRpY3YrY0drb3V1VTN4VnFyeGxUZXYzWkk1?=
 =?utf-8?B?eWpWNFAySXlFdkkwRjgxOWVTMVRYR0ZQeENtVjBTdnpMaG1WZTRFRlppeDBy?=
 =?utf-8?B?Q29Lb2hiZWlpL2xZbUpUNVBLcmtnR2lZZnBFaUFkZ0poR0U5ZnR0VnN0MENF?=
 =?utf-8?B?TTdOQUhFMW5JMVN3Zy9NNzVYVkxhaFVoY2RHUnJGZVFpSlRUb0VxN0piTWZM?=
 =?utf-8?B?TEtpbnZmcVJqRWNLSlpYVC9yQmVEN1R5UXdtdDh3ajU0aHF4cjgvMU9UYmtO?=
 =?utf-8?B?ajMxWW8zTmlFcHhlQTVuZEg4WlByWExOQ1ZaOUxaOG1Qa0FEdzBhclE0c3c4?=
 =?utf-8?B?TTYrSXlzanhnSDRMMzFXejdKK2JDbWVySW1rdFNybU5pZEdNRnlpVXpIVlRG?=
 =?utf-8?B?RkVuYmJoK0t4bThaREhHdzNIVUxYdHhRTExqUjk3ZVFOeXRkOEpJNVU4Tm9x?=
 =?utf-8?B?WXNzL3pUUnRVWGk2cHFQOW9YL2Y2NVptTjFCckFIdVpnL0tqNitoWmkzR25p?=
 =?utf-8?B?VXR0VVl3V09kL3RFd3dzUFVsYzViaFQ5ZFNSY2h6d0tHa3UxTjRJcERUaWk3?=
 =?utf-8?B?WHpuZWR2RVBWNTBGWXRwUEZlc0E2eGgrdmFTSHVKYTFRYi9BVi9yU0NobVkx?=
 =?utf-8?B?VkdtZThveU9JMGc2MTl2OEZGeUxYR3JzUFBYMU9xQmp0UGVtOGhUWGcwQmp1?=
 =?utf-8?B?TjVYeEszSFRubVNFblphc2diV0pLZGczSVYxNm9JK1FTZEFJcTBOZFd6RE9k?=
 =?utf-8?B?ekJOOEQ4bFdsMUFYdWhmNm1HVnR0WS83TzlSeW5xY1hHL1lKSGZrUzJZVkJT?=
 =?utf-8?B?dFowOVQyaGpmT3g1ZzVlbmVJOFR1Tlk5Vmc2bEVUR0VyUjNJWjUrQko4STVa?=
 =?utf-8?B?VFVLNUxpVUNacGVTYXJ5SGJNTWxsVnpsMitVVWRrdVc2cU5QaUtEY0QyVW5Y?=
 =?utf-8?B?N244bWQ2NmdkRHl4aWZLb0kvTTMzYmxQL21VUFIxT3Rvb054aXhSdGd6MmE1?=
 =?utf-8?B?cDlqaXRaQmk0MmFqVUxDeXVOYWdya0ZLVmJsMmZpWWJxZ3p3M2I1eVpQRjhM?=
 =?utf-8?B?T1Jka2poMkhlOEQreHdoWHlJWHR6M1FucGl5bWhhK2NSSEpmSWwxK1cyNGlo?=
 =?utf-8?B?SlBSWU95QlQ2UEZqUm5aK2pRckVUWjBCZnBxLzRma29KelB1M2xCRlVmeGlz?=
 =?utf-8?B?NzF4cXZnOUlSRVdJYUlUVTBvRWFNbjB2L0JFVkw0MGY1SUNvL0FpVlJQUWtK?=
 =?utf-8?B?UFhSMnE0RTF5R0ZTQmw1NFVaRitHSm9kTGdxdW54YnpBWm80bnA0WFVwZnJh?=
 =?utf-8?B?S0gxaVdHb1dQeEQxQWdkME5NYTZRMnRQdGdhNlhld01sbkdHMGVHeXB4d1Z1?=
 =?utf-8?B?bzhITTZqbzJRYTRYRW9mc0F2QTM1WE41dGhicUhCM2pWTlBRS3kya3lmVDFY?=
 =?utf-8?B?Z2lsUWoxRTY2d2RTdnMwR1JudVpJdkNZd1RxZ3YySlpnRENDZWRkWmR5UzNn?=
 =?utf-8?B?WE1JOHMxNU9YS3VJd1FQd3FoQjVzZ1ZIKzIyQUFyVkpXd0dpMUxKblNCaGFO?=
 =?utf-8?B?Nk5tWCtaeTlDSU9qbFFEeGZBNzZWUHFvU3pJem8xRnRMRzZsaEN5bUlLYWNK?=
 =?utf-8?B?K2d0TWhVSVkxWFhRVnhzS2lYaUd0RFZvRmxpSndNaVBjWFNpTitzWWJ4dkx4?=
 =?utf-8?B?NHhnam1TZDdIdmlOQnhDYlJseGRhTUJPOVdPRDJ2czZzSHNDT1dJRE4vNHlO?=
 =?utf-8?B?Tkx3dGh1K0VCYWZZdkE3VlB4SEZoUTlXSDVrU2RiQ0k4MzlwVzNTOVdFalVF?=
 =?utf-8?B?VURjSkQyVmhvSCs1UENsazJmQWZsNFBLMEgwVTBRUDV1TXBMQzZZL0ZoOGZK?=
 =?utf-8?Q?3URKeptkG74rcxmDg6l8/pIuC?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jp0IMtnPniPQNR+GEMyF9IeZOSQtLwnBu+uUrvKLgq2a01zsWRGF1XdsjOP5ikzdgAyPVpr7nlW1vhTYwOjngenuo85N1Q3WNM+LmiPQrcuAMzbnOvPdeFUN6fwne7PNBpWAkOpFVeQPO4XzCIE2OY09ylV+3bjU3axYy4I7IaBDsEsPJBlrQ2pFPh26vCm0yh2w116DbYijaX4oa4jkDPBgOjcOfdFsqpUA3yV1gvxxN1v7fDz34Zi/S9n19djFWc/S9xbIDrR6HmFCDlTVVZSqTkJzvTy0AUH3b4K8AL2tn7UWqeX7Q78fOWfp5qF+3/iwg14THatmAIZX6Kp27/mlweBcBPf52RRrPzgtWRRx3vNpD7E03DtwAgfhqzV6k4pkanN6dVCg7xprakY7vpGkmvuD6Zx0yBhxQM0dhPDJiQKpRcFAfcS0fFFqW+PiGvwzA2LXFdRnJnMEvGL36beERJo0EPdNKNXsOjOku4XzQwcilEMoLapIU1juTCOucqB3s37RWJUfrU1nt/Frt0aGPnOVsUDk2t35pQ9df1nZfBUp+8dwy5jL1pLLjrs8wdVBiaWYNBRF6YDD8Tj2RM4w0cUyTGaoO7MZQ3RHZ+67MyP49OWXkR+4Ut+YQSM7KV6LvoRA8Bt+s5vFdlk24AwYbFrGj4nfl2e1WDFyegZrE4aC3RZ+8gzE8dxqUqrVy3C3FNoIH1ExiZB+f48eJGnmc7aWFsGoyj/W4maWKF+Hu31kBJ8tHkeDl+I1gruZWR//WM4o+sYaPidEdCme2OMuY8UU8Eh+iey8oeK9EIyK00zJI73sxjqgoJu/7A9r3NCCxbsxx1QHcvDDR3HZTw8iL5s+FpUqYeDNgaWJUQ8FO6pTmZUES85HsBUq89xW3lwzUAdBXRezZa9ibNHDWQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec59a4f8-8c32-4dd0-2530-08dbe698b0cd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2023 11:39:28.0849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SLTPqU+CAN4jDQuWFvtn8EnCMwWFTHQhnffTolf8SupfJRgoNgRX0fcpp17FoF/H8BmevLhI3aUmJN3xPwMhEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5229
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_09,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311160093
X-Proofpoint-GUID: cCp81sMYO7P8HIEyFhxBrrVE14x8KbMP
X-Proofpoint-ORIG-GUID: cCp81sMYO7P8HIEyFhxBrrVE14x8KbMP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/11/2023 01:37, Mike Christie wrote:

Feel free to pick up:
Reviewed-by: John Garry <john.g.garry@oracle.com>

> +	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
> +				      RC16_LEN, SD_TIMEOUT, sdkp->max_retries,

BTW, some might find it a little confusing that we have 
scsi_execute_cmd() retries arg as well as being able to pass 
exec_args.failure, and exec_args.failure may allow us to retry. Could 
this be improved, even in terms of arg or struct member naming/comments?

Thanks,
John

> +				      &exec_args);
>   
> -	} while (the_result && retries);
> +	if (the_result > 0) {
> +		if (media_not_present(sdkp, &sshdr))
> +			return -ENODEV;
> +
> +		sense_valid = scsi_sense_valid(&sshdr);
> +		if (sense_valid && sshdr.sense_key == ILLEGAL_REQUEST &&
> +		    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
> +		     sshdr.ascq == 0x00) {
> +			/*
> +			 * Invalid Command Operation Code or Invalid Field in
> +			 * CDB, just retry silently with RC10
> +			 */
> +			return -EINVAL;
> +		}
> +	}

