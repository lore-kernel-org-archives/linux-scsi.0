Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E7FFC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 06:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76DF8610A4
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 06:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhJVGEq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Oct 2021 02:04:46 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:14246 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229484AbhJVGEo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Oct 2021 02:04:44 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19M5rQMd010951;
        Fri, 22 Oct 2021 06:02:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=SS74qK9oId2LrnRmeYdCoIslc0Hc7SdAKjAhKnY0v3Y=;
 b=e2na9hqgxbsSCBJ7BPf7jsxjQI0h8EbauGtxry/4trFFTfLDpVYRjqHEVj55tu7+f4Bz
 UyWUpndIQhPchyfyC3/8C4LI1Zpvsyl3AKHx8uf6USGDkRrFwkkVkqKXjVWZYWLLrNG4
 O4YsdXjsrolx3yttOBbjJHdAd+uCCrts/uQ+jK0S7UGcwULkNx2xKcsq8irqBl3zvNvt
 kjbwOf31xwf90CAX2HvJaSHOleyaR6E7k2Lj6zsParSEMpY9A39JGQryp6seThdruFKy
 ulu7bZedgoEulOwEoJnk+tjurB0CfwovuGdvLTo/kANvEwIAVkzBBNNuihmyBkH9PQWM ZA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btqyps81k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 06:02:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M610BR189437;
        Fri, 22 Oct 2021 06:02:23 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by aserp3030.oracle.com with ESMTP id 3bqmskek6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 06:02:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bFsjL6BdjtlKdTWVdH6hcGpvNcdooRmP0/3beVlIQu/z+eoXilaBHfi/tyjbhICf/ehjRKeMGGVEdMsRTi8x3q4SMocr2fuGj+L7deq4I+n9GecK/tF+0+bkgGVJm93ooL3fNPTxdsLaEBtkvPYCxVUrpbw4bEfTy7i2gXfPEJ7Ocu4NcWHV7VmSt/oR2pl3tCwJiuQzguV6nhzJsVNmRnfuoxRWwHXkQjVvthMYaj5BJbrF4/eM8sKiTQsVlcCpU2pijHaK9Md+WCyePjREFfUWizSSee3VGqXACEMv42y6QKKcZ8oe9w0AFSuQvm64JKOMYDwSXE4JaaCsrdsjhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SS74qK9oId2LrnRmeYdCoIslc0Hc7SdAKjAhKnY0v3Y=;
 b=BRRgW4veWS/v+QBwAkpEqYhG7PmM1tVxutRYarqgs9rbZv2s3RYepnUJMloeMrANM9maCylv+XYoTs4R6ti6m6yt2DAzjh/nvaoeX8iZt4FtR1r7O1DwJKB9pyldWio4QVlcZNc6W1xw/4WK85krO0l6EBuoMC00bBO/YPD6ATgO/ZdAQrUSYakum4tdEmfOQpHKG0T1+n8aZOJ3tnjMYd98fdunN7ruzVDXW8E0ujJ8PYAnAse0hymOs+0ZjeXO9p6uGoLzmTl2OA2/xWCS1Vc30bITMIa4ZgCv/ZDReWDlzRlQuJOihqLgGlKQO3FM6KoKIuoJu/6zunkmfXdZ5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SS74qK9oId2LrnRmeYdCoIslc0Hc7SdAKjAhKnY0v3Y=;
 b=Y0tAa4vSerDmqgQGDepUJpUpKa7B7S/DHTSViw0yXEoDmctd35sTYK3skdK3E7ZBOX3jDoYiszjxZdWjp/ifxJ1G08ZZO4Ij7Td2WZOH7sdLU6wZh6rlHOGX7t87haiVMKMUriAxs39Is4LPIAY+Eb+W7KLuKOmJ7RquS2qiBFA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (10.168.103.135) by
 DM6PR10MB4185.namprd10.prod.outlook.com (10.141.185.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.16; Fri, 22 Oct 2021 06:02:21 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 06:02:20 +0000
Message-ID: <14dc15ba-5888-a43d-6a9a-8b5165620d57@oracle.com>
Date:   Fri, 22 Oct 2021 01:02:19 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH V3 00/11] vhost: multiple worker support
Content-Language: en-US
From:   michael.christie@oracle.com
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
References: <20211022051911.108383-1-michael.christie@oracle.com>
In-Reply-To: <20211022051911.108383-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR07CA0137.namprd07.prod.outlook.com
 (2603:10b6:3:13e::27) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.7] (73.88.28.6) by DM5PR07CA0137.namprd07.prod.outlook.com (2603:10b6:3:13e::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 06:02:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7cdbb58-c12c-466c-cf1d-08d995218284
X-MS-TrafficTypeDiagnostic: DM6PR10MB4185:
X-Microsoft-Antispam-PRVS: <DM6PR10MB41853D368828FDC381381D0AF1809@DM6PR10MB4185.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:619;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BYtVgkterE8dHFZAXxNHOXbF5+gy4O+yHA5IMXFeWChIi9s8e1i0VXQat7AVDoKLBy3Xu2S+nUa3H8kSgnBrSTBIbJ+Ylr7Mmgcyg5+nHS+Y/o6EcYZK7xpztyRuvlKH0Ryz93P6viy91NXJv25Tai0V0QlDqs06XRi1VCea8JajQ3dQ8izn6n9SEoXkH5Wt/TxNmkVG1oEVnPhsXO/PT2dQi67SDJL4ld9HHYJa2Ypt6UbJvJkKQFeQ51rw+2xGeHtTYs4NyzDHFn2SODv9gof71kWLY6WZaIuWRqTsV5KF3AraPJs7FwMwmk29Es6E84SVoiLSeAxSSA3hCUgbvWmSt1v9Wst75Lk9IRj+pBZnlbNJODsxGu+8WavQx9g/sB+ZP+LtL47jW7XIbID91rKCKruRG9WZfWVlXVx9Q0VnnqYt7nvPBRgB3okSap1kB1QnJ1V4x0aAr/3d3YziSxJ8tZQtUt5bTzmAFcDgF1Z5jeXZszxg8x6Q5J8jzlfN2yRdYaz+beSASQDVmTnVhwbA/lYTTp1+glrl2g4hygsFxWCaEXolu4cKGVMCJIGTnCOcI9TrbOA4QXA843Vn1y0CM1s/NBftC8zuo/JmZDJ2JIRUlfWRjJpKWtNx/fGdWBgxardnYpHqdeZHqtn57WixhKkLg/InHRxC4SQmIt+lX9/rTrNN+svI6fs1rlndHFSknEeMX7wqr+zZyeQwJdJRtZVkUIDIgxSasBuKrXw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(2616005)(31696002)(38100700002)(16576012)(66946007)(6706004)(9686003)(558084003)(53546011)(956004)(8676002)(66556008)(66476007)(86362001)(186003)(31686004)(5660300002)(26005)(8936002)(2906002)(508600001)(36756003)(316002)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WkdQS3QwV01EMndmZmxSd2tmKzdJc3hHLzlkNGZqbnE5OVByRCthTEJPNXAv?=
 =?utf-8?B?cFBMbHhOZlNrazJ2WUIrT09JQlhKSnltZTBKSUNqM2JZbXYrNkZUeDd4VWV4?=
 =?utf-8?B?VUhxMENmNlZyK016SVpCZG5YdlZYT0xZQjU0R2VHL1hsclRLK2IyYTc5S3ht?=
 =?utf-8?B?QXY0K3kvaG9JYlgrcHZ3RklUOEFIemdVbXMvalhabVY4VDdvNkdOdFRmQzVP?=
 =?utf-8?B?Q0Z6SUNrOUdmNTZJanc3dkdxSWtGTTZ2Q0xwb3FLaGhhWWlPa0hmVUN4UkNK?=
 =?utf-8?B?Wm1RTTFlQlIwTFlwaEY0WFBZdGI2M1E5OFVoSnlUVVlLdGEyM056dEpnY1VY?=
 =?utf-8?B?aGVSK0N1ano0d3dJY1hDMmFSd0QyMlY1bGRLTmhnejZ4UE5SSVhlT3ptVDkw?=
 =?utf-8?B?OWw0blkyMnlFdEUrWTR4cU8zd0NFM3JWaVJhbTJubG5sREl0cHdhY20zQUhm?=
 =?utf-8?B?R283Sk9ZRUJBSThhcnBIaHhRRGJVTk9hVC9vM2VxUzc4eFJDbDR2d2ZHMGdj?=
 =?utf-8?B?TFFqK1haV2pPdGgvMWpFZ1RQclhQbGRGaGcrL2x3UGQ4TFFvV1J4VERReEs4?=
 =?utf-8?B?V0JMR3dzbHNWNW90bm1va1dIcWlNc21kV0tMYjIvZHZXYmQyUS9mVHU3Qlhn?=
 =?utf-8?B?MlMySEVZcThZY0Ira2h1bkRpdFdSSTJFMVBRY3p1OHEzRDZWOEFVdFNDZEFJ?=
 =?utf-8?B?a1diL3RBSkJsdm5kTzdpeEJuYUt6amNhVGdCM1FFd1lWdUFyby9VWWVQclk4?=
 =?utf-8?B?WjdnL0wyTXUyVG5uQytxQStyRkduaDFLK0ViSkhHUFZsVVNyMmZOLzZZRFcx?=
 =?utf-8?B?V1hCQ0g1V1JTdlBaT0U3WjJJTWdzcUgyNmh6OUQyV09rYWRvM3g4SmVCOEpE?=
 =?utf-8?B?dDV6Sm1uT05JM2hYeVdaN3kxei9HRitwbGVqZi8vYTNHVWd3UzNHQ1FlYjZI?=
 =?utf-8?B?enlzOFFTWXBQUGJWaUlzb2pIMW5ISkpUK2NDZi9XdHNEZ2JyZ25hMnNEV2Q5?=
 =?utf-8?B?MHIza0M5S3dOU3VMVHlJY2dndThJdno5bDVPTW9RaWRjNTJPUmd1L1lxdUhp?=
 =?utf-8?B?MEY1Rlp6Uk4yTmNyeVRsOGhlSy9TZXpoQmRBc3laYzMxSVlCNTVOS3hGV2VK?=
 =?utf-8?B?bkdHTFlJeWtIWjBQRE5BZ3pTWnI0UDBZc2dWV091bEF4bnhxNnBTNTRJSGNZ?=
 =?utf-8?B?WnBST1VwaEtkUGJtT1ZSL2t2eWtEeGpQMHJ1cHNXY2pPVE9waFA5U2RwVlVB?=
 =?utf-8?B?N0s4WGIvMWI2TDFWdUsxaVdrSm9BMHlMYlNtdXVJa2VValpUYUVpcktXRWcz?=
 =?utf-8?B?alFUcENlQ1lYajRiYmN6N0NudFI3ZDR0bit0eFRITTZFS0FCVW1PL1RPWThN?=
 =?utf-8?B?Ly84bWRNUHdzbFZmT08yZFhvK0picFluYW5FS1JIemJDNmg3cjZPeWdBMjlj?=
 =?utf-8?B?aE1MdS9LM3huREhpU2VtWFRHM21NMVp0d1dPckpKdUVrK3dkUUpmc1hrOTcw?=
 =?utf-8?B?ZkRDanV0aUdqelpFRThlUGhvbEhVNDFiVkZqbSsxRUZOT1c3amc1dG9JTXpR?=
 =?utf-8?B?UTNDdGg0OHVka3J3Yi8zL0trOVFGNGlNMEc5Z2p0Qml6Y3I5T0VnaWRQTGh5?=
 =?utf-8?B?OTFmdzhLQWJ6RGl3ajByc1NtTS9MVW5zZGtJekM2S0o2UmZRSldYb2dDM2FO?=
 =?utf-8?B?c2RIbnpDOHpFbjdFaENUZmJWVE5oYzFlRUNxSSs3TmcraHdrOUtmY0hXcmx6?=
 =?utf-8?B?TUdJQ1JiaTY4bGJpSURldkwvZU02RlM3MUg5SXdkYUlLVU1OZE5nc2dESmVT?=
 =?utf-8?B?dVBvbzRDTkRZN0xnbmlIK3hYK1hQbUVEMWR5V29TNXN0dWtHQmRnOHZ2L0RE?=
 =?utf-8?B?aEtFQXNaRHVDcG1ETDlUdlZtenhLRXVzZEFWaXpZbDRJK1ZweDYrOTVsL05B?=
 =?utf-8?Q?1eUtMqlfdYh2sQdj9gWvUox3uj8NHvNZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7cdbb58-c12c-466c-cf1d-08d995218284
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 06:02:20.7186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: michael.christie@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4185
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110220031
X-Proofpoint-ORIG-GUID: v7MiTeKQJuZUT4rrymhaJlUmWO15GNV8
X-Proofpoint-GUID: v7MiTeKQJuZUT4rrymhaJlUmWO15GNV8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/22/21 12:18 AM, Mike Christie wrote:
> Results:
> --------
> 
> fio jobs        1       2       4       8       12      16
> ----------------------------------------------------------
> 1 worker        84k    492k    510k    -       -       -

That should be 184k above.

> worker per vq   184k   380k    744k    1422k   2256k   2434k

