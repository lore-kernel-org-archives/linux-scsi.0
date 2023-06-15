Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B4EEB64D9
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 15:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237974AbjFOPmT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Jun 2023 11:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238814AbjFOPmR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jun 2023 11:42:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73C62728
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2023 08:42:15 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35FENsuB012969;
        Thu, 15 Jun 2023 15:42:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=uAUVoFKlI9A5CRJr6SLJKlpZ67hUHYXj2Ilm5qSIw+8=;
 b=d5RJCPrtoSObh6fLmMXQH4Kjn3cnffj11/FXr6amwX9LkBg1cfUfkfNeURxpHTUhpjoB
 dseAH/rW3XhUw8kTNo4RttytPfGSRAKEA5dTuYFD8ZsVCoGuOuTZ2iPUk/p+dtks3rKt
 32inw+MdZsNJJidKCVAnSy4iYhj6KUuOtjlET1FASLayb/5Z7/Cqj2HyOim2ELOaOQC8
 0i9lUu4XDu5A4eI8hAukRPGEmU7kWMApUSG4Ud2wrst1wIj1dDDWbHSBl72YD9B/VsNS
 L8myF51P0boJAzhb51zClgJyWJTUrh9EKg+PX4GtGZ6f5nUeIv0SzA0GV5NjX5W3l3IH CQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4gsu28ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 15:42:05 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35FEaMZA038864;
        Thu, 15 Jun 2023 15:42:04 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm6u86q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 15:42:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SSa106xDpb/ZYd7JPFekDhLU3bE84X126KMvgRtIxHO4wBgzFURFKXnaCIx+4rdgVp3JvRtk23lbGifEFI8A+GQeVSkflmYogXtFDODxyFdrxPAOhXL4SxA5MZSjqh9jhPhG81WnOgQnSw+PHVq/V96JUBMPInbD/1plnC0tVaD/XXR3WJrYhiPsd0dpNyrTv6cuHJl2RgERyMHDz3h1PUJEupUVeYBw8dTd6RFjPs7PNhCeM1/pVHiZuQdpQZJZLIYbDa7x/lmPv4adbDS1+C+NF0jojzhPqsvkOUK/NfsfJ/1sMM4dcx+4E/jyYhc+6rXuC++K8LYw/ctcg4A9EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uAUVoFKlI9A5CRJr6SLJKlpZ67hUHYXj2Ilm5qSIw+8=;
 b=Dx3+DR3bIT7K7/ibgkzq5JbU6UmWTi/D5Q71eO4+5kC9HNKIKJWP36n0rb4CKg9acuItfxIp0KGCWeVfnnQ/jY4glgSsQj28ASVD3qfuvFwY9XfJQivy6uLdNnlk5VBmBqlplbag0Ff+eT5d/gXE1h5kUGWhUdy4ZcO/74C7TTx6qKwFTwIBjjLNyo7i5+79LHVRbQXY90CJ9ekHvlKLaa8n1XuP8LVmwFko6EdjvBRzUhdPJc788+RlxiAXd8sfGETj6e0rKdxTBVsjJDuxk3oLcyaXEWvDKkQP0zG5wkhfIAcqXhjtE6u7DBX3qnN79XNk7tAnLqrOwajDuzN/gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uAUVoFKlI9A5CRJr6SLJKlpZ67hUHYXj2Ilm5qSIw+8=;
 b=bu7NcjsVdYlYULaKIAspoejGHx+prmYgz4aibJ8LPb16pZ4loU1Iq1B6vpxP4KOLBBWUW0uHhO3Q2IQ1UmC3w3Q2j6v7D5cUoxTvHcrROS4dqi/uD/nuJBKro8Dx5nEyMMzAVd/i7rZ9Eb0sfctlMoFTNTv65aTyI3hV2mCdzII=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB4934.namprd10.prod.outlook.com (2603:10b6:408:120::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Thu, 15 Jun
 2023 15:42:01 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb%7]) with mapi id 15.20.6500.026; Thu, 15 Jun 2023
 15:42:01 +0000
Message-ID: <af35161d-ffc0-f9d2-c051-ca7f1db7658d@oracle.com>
Date:   Thu, 15 Jun 2023 16:41:57 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v8 06/33] scsi: sd: Fix sshdr use in read_capacity_16
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230614071719.6372-1-michael.christie@oracle.com>
 <20230614071719.6372-7-michael.christie@oracle.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230614071719.6372-7-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P189CA0014.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB4934:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e12b160-33cc-49ae-d35e-08db6db70f66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nDsRlHfonecSfP1fatQ3+Sx/A1fnB3gNH8qbvSN0h28LEJIQuYmj6S/yO+VKGAYfR4PwRvrvgprycXviy5uKFpBPRX0Nka54ZvSOd5/o43nluyTgFOZ2kqB3B4poLhkPPQMYK/H5ms0+5sDohGFCprvGlUZhzY0yRWIfe9/QeT/wEqdIh2z+1riWEl7+ecX8WaP/U4TuSy6kY6MqWcAq+ZN2Zv4D1wKXkjuHn+f5Ya2a8EydXtIT5Caxf6HJtE2XUWbBh8Xmi87VrgQsM0JJC+Re0KDIwvmkGN0j9sptt1ki5KTWpUJ03JYfsLB9UKxuFAobCm8B8w7PgHs5oSPf12sgBVMe5/fiEUSyPE0Z1Nup9aeCjlNk9I1f5egPkHZmb2ZprWxI2GuYFufsdeLpv4KM+5jELo+PMwZyC8M+4hZq7yWTOqTobNLLUGV/R4bMG4GA/SQ4oYywga0ne2faneGqACwG5yS7ZgfQWcCmzgkXBoulUVCrK281XJ5iBhSXsSU7NEBofgJoEOVS1pP/IQDI2dVjS+v+UnMxodCenYN3RSTKbFamZAo/bLp1csGhEaumgexCmLl4AFBxOh1YoUffP1D33Q1PuLCs4k4on3Wu8hTDHBcKl0f48Ha3PCcDhF5k0TbHVFIHkm6fQ4ipJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(366004)(136003)(346002)(376002)(451199021)(26005)(186003)(6506007)(6512007)(2906002)(2616005)(38100700002)(36756003)(31696002)(86362001)(478600001)(53546011)(83380400001)(316002)(66476007)(66556008)(66946007)(6666004)(6486002)(5660300002)(8936002)(36916002)(8676002)(41300700001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RkhieC9DRSs2UXQ3SlUrR0x2WDltY1kvZHI2STR2SjFFd3l1c0I1VHpMR2pQ?=
 =?utf-8?B?UytCZWtHL09mbjVMNjlIMUVETVpEaFBXRUxPVitHK0t1MnE3Q2ZxNSttcldt?=
 =?utf-8?B?QkJEa1dRMmJrZm9Qcmhxcko4S0pVM2pjUlJhUTdxN0pGNHMyUFJXYlFZK2Rw?=
 =?utf-8?B?RTBnb1V3dWZRd2NmaThoSktrWVJOVnhraDh2d1UyQlNJS3cyQ3J6Yjl0UC9t?=
 =?utf-8?B?WXoraHNMUVJkc051bDFCS0JWQXRSUjZVamFIcEtRczJJZXFlVEZLVForTzV5?=
 =?utf-8?B?ek1aUkJTaFRNVkRWVmZDVUljQ1krd0dRQzM2NDRXbU92QUxFSjBCMENaWm43?=
 =?utf-8?B?c20vVEFSWVhoK1hUT0podS9ib2t3ZEFuZnM3aFhtYlZkV1I5MzFVMkx2bHVl?=
 =?utf-8?B?ZGdURnRRTGkzWGQxL2VCNlB0VVM5TzdYZTlveTQ2WWhTTzV1OEh4ZFdjWHNu?=
 =?utf-8?B?T1FQSjZMcitCVm0rTWxwZTd1TEVCMzlWWDlZWW9SQUMvakFkL3U5ZHE5Q29x?=
 =?utf-8?B?ZmxGNHcyalBpdUdXMnNTSWZTQ2lSQ3JtcHI2MjNZWlppbWhlV1ltUFY3ZWdZ?=
 =?utf-8?B?b0FMYnBLOHZKT2tLTFRmcjZIRDdZa0s0TXN6TmJGWG1XQmE4NjJQRWdnZnZ3?=
 =?utf-8?B?RFpQSkEzR3hSUXd3RlRZQy94NjRWL2NnQjhWQWxxbnNBaFR6V0ZYL2JVZ3Ey?=
 =?utf-8?B?SmtGajRGMWlxcitmaU5zTFUzOFhMN2ZHOWxpZ2NkSVRZd2RZZjdUeXBjSWZq?=
 =?utf-8?B?QnZCMm1kSi8zZFZEcjZhOEJhZzZ5YjBqeG1aNmNNTU5EMjdSNHpxMUhMUXlI?=
 =?utf-8?B?ZjVYeWJvWVNBNC93WFdzK3JoeGtield5ZUV4T20xTW9GclJ0MW5iOGh4OUZ3?=
 =?utf-8?B?TEVnME90T1VRS3c0YU1xd3NwV2o2OTFqQU5UQzNlRXdEMjNEWHBXRFZpNWpx?=
 =?utf-8?B?L3B6bGlUYVhqQmxXYitTNDNnOGpvdmFxRW8yTHQwbE5lWjROQ2l3M01hRGJB?=
 =?utf-8?B?RW1DUi9qYURpbDY1M0lCaEI1eXl4aytrOFhUVXhaRDd4bHZubFVhSWJheVB5?=
 =?utf-8?B?TEFIMGJPZ2xDOGczVHp2S0RIQ3ZpN0hKVzdaZ1ZwdVY1OFlBZ2VVeVlmMkRu?=
 =?utf-8?B?M3pwQVFnb29vRXY5RzBkSzA4WFcvZkZGSjVDMkVxb2ZCUng2ZzZCUmxTMmll?=
 =?utf-8?B?clc5SUVtZU9XMEN0Y1JyWVNqYmtVejcxUEZDYm5lUDRMbDJuTkZOVk9rbUV5?=
 =?utf-8?B?QUF6YXN2ZE1NZDRwb1ZRVS9wSmRxYlgza3UvYjZQcWt2MlM0bnpPclloTytW?=
 =?utf-8?B?aFZrRkRRa1pCVjFTdlB1cXQ5WFFmZi9wNlBlNUg5RVpPckdiWEZ5cUVMUkU2?=
 =?utf-8?B?S0cvdEh0ZThTT1JlUkt1cFoyUEpxU0JlQlN5bzNtRXA2T0N5eTZNL3NBVlZT?=
 =?utf-8?B?N3hqRUp6Zzl1ZmwrRFhqaERiT2Z2N1cxTTZIdG82T2dWUmhRYW9BTHpQaUZG?=
 =?utf-8?B?RkU4TU1MYVh1Q2dNb1ZYbWRiZ3JjT3FBOU84WkVyZ0lZVUJ1blRUOVk3T1c4?=
 =?utf-8?B?Ri91ZE8rRlN3K0c5R0M4bDYzbDNSL1Noa3V1RVJvRy9tN2RVd0pLUVcwcVFO?=
 =?utf-8?B?QWp0eDRBcGpNd0F2TUJsQUxST1FzelR2RFZFYnlEd2Y3R1cwQXFSVUluZVVJ?=
 =?utf-8?B?c3NlcGk1ZmlueWVMQm1ZaVJYQkd5eGI0RlUzZjBuSjdDQXNieFpDNk9VbFZK?=
 =?utf-8?B?L1dST2M3M044RU5kMFNudkFCbnI5cTJWNWptdnJsbjlEQ3FUMXdsSVM0U1Vv?=
 =?utf-8?B?U0JkbkZvT1NDOGFSTTVic3RrL1A0RWc5bWFZNlIxUTBkVmFpVmdnOTdIYmtW?=
 =?utf-8?B?MnBUb0VLK2QyNnhoZ2xzdk5YeHNYazM3QlBqZnp1TnA4bXlMWW9qd1Fvd3I1?=
 =?utf-8?B?UzZNMjd1RExEQkhHQzNuWVpDWHRvNG00N3AvT1gzSTFvckV5RXBJdWlNK3ZF?=
 =?utf-8?B?ckpKekxqd2dtem1neU1ET3NEdlZoV09zNUVTdVAyRHhEc05tZjEvai92bzNu?=
 =?utf-8?B?ckpNZ053OTcweU9Xb0Y5c25GTVo5SXpUWXdCSTZHQkdlVWNQbG02N0Q3WXFz?=
 =?utf-8?Q?6DiHerlnr7caotaPjHb17bhQn?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 5VzMRSm+4nLmNq6EOrO+iQKX3ctiZxWyRWoZDt4Mo/Z1TV6WZ8WMcb7J3NMNvW7YCWPVLzLmcJtKJ2cMltCIJZ43RGobLshisk4xQ3sDaoF9OhtErA2nEwTKtYlq5Zd3wiRaoTK7wNfj1qCFzQoeAYqJP672bak/AlC15mhk3HoQQpgFJ6mSQrQdM2wjPIYgEPrtqLc99sTtjpldaGnuBLQlvZ1SPyF2+EVhtED0dBvHf9b68HAVZtVoQNguYJO0zK0X/LKZ7wPTV7X+bkMzyHFo9b0osUNI34U5Ib5QmwOX2p97msUDaX02NcJOkuYvbEMaAEcRL1DRuy37Jm/MjrHa6E4IC/5TvxtDgGTbnafvBDbn7NbE2y5TZdoh1wxMLQyhiGgyw/bnBNboYVHKARBjWi1ENRqdHBg+gjteSaJQH9D9QEmHv9T29eZGHDMY8R/u9YxGRd1CiMOu1y+h1N3TfIsUSXg2O8ydki7t0/eY+QAnJPHPHXiyfXEW5S89x59gZBaf1+WZCrGznpPMbWI5C4uF/9YwqIkm3jdRB+GkIDdQHXcsPengDS1S1EIA89mB3HfsOKTKBGlXgahL0ZujOOAjSqRh13841ARUGDEVZbQCDZWYX37+z4P5omEG8LzAV8XDTjzudPBIsEpiyIsW5FSYiEv8FrzfYSc4dNA4dXd2K04fWuJPugi7hL2xEoysIxgeTR3mEjHmAU7Wn9Ackhxv3bkWvJzLobd3V+4pH1CK8S+J5ur8EyL+2G9jY7UR2TZBka9mvuCtYSOlbwiIDlMq0bkGVqXv6Uirq7P8YXBOobhsCU9SahALk8yAmVdxJkapcbc0RnkcUR+64kAzgFeFQrErr6mQH+r5Tjil3TXthKZ5qWXy3WuNs+Dg
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e12b160-33cc-49ae-d35e-08db6db70f66
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 15:42:01.3719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 61xNVPua0UpUK+4MKfsqfa7Py9GMyf/Y3ZKEgy6gO3k5RkrhJFa/VnMAXJIRcZy5aeZmHPzH8NocH9MDdHpyOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4934
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-15_12,2023-06-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306150137
X-Proofpoint-GUID: 5GT0Xj41R7YWbqhb2wmcwFhneAjAUDyk
X-Proofpoint-ORIG-GUID: 5GT0Xj41R7YWbqhb2wmcwFhneAjAUDyk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/06/2023 08:16, Mike Christie wrote:
> If the_reset is < 0, scsi_execute_cmd will not have set the sshdr,

The code change below now means that we only access for the_result > 0, 
so should this be "If the_reset is <= 0 ..."

> so we
> can't access it.

shouldn't access it, I'd say.

> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/sd.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 84edbc0a5747..a2daa96e5c87 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2428,11 +2428,10 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>   		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
>   					      buffer, RC16_LEN, SD_TIMEOUT,
>   					      sdkp->max_retries, &exec_args);
> -
> -		if (media_not_present(sdkp, &sshdr))
> -			return -ENODEV;
> -
>   		if (the_result > 0) {
> +			if (media_not_present(sdkp, &sshdr))
> +				return -ENODEV;
> +
>   			sense_valid = scsi_sense_valid(&sshdr);
>   			if (sense_valid &&
>   			    sshdr.sense_key == ILLEGAL_REQUEST &&

