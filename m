Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14212C43217
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Nov 2022 16:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiKAQnZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Nov 2022 12:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiKAQnY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2022 12:43:24 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442C9E3F;
        Tue,  1 Nov 2022 09:43:23 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A1FQUau026156;
        Tue, 1 Nov 2022 16:43:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=CgzCL+ZCs4K5zzF4uyDp5hBZ1chathtB9tEIF3C34HM=;
 b=MwxnTaNw6svtO/V3yTcx5ZfKvNOtl97wZ4Cf1zhl+/B8IgEi3yr4ncn3Z+cJvsAYNWxA
 n0ZSTgOejmKd57OUQ0TZRS48C6WHHk/QqUbaT5wfKwE6lYoC5wzSH1Ry1ZKGWSKDHgFC
 lgTufAd9GCsDqtIx7zPaLkriJ2fwdQG5yWMHJKkPQnS0nip/B6cP9qq7CWhVVw+4QZA/
 mxHdvMn8HsVisFCWrxzKvoRkq6BP8GdJRmHIvPD5XkNkIbfpPRbQjfNz3kuWcb2edC1z
 90pqxmbiDY8plYkAoqmyxQLqIPfR+A26oJ0iAvxmmseOoNZ4v0bA93Cph+06KEq0Xy9w fw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgtkd703j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Nov 2022 16:43:08 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A1FbpSf013949;
        Tue, 1 Nov 2022 16:43:07 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtm4m2vk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Nov 2022 16:43:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E0xeEWGJLKxK0Fe/7hzFgnT3O5N61dfc5BVzvymcmKNk5zdaBGlGB06ycUw29aKp8Kolh07NkQilIZrskYC0IJLBJoDqp/BM1KGZPqDT3FDcayEF9dD25V32XWFTJ5zWgpOKa77g2C5I4P+ZAd+TRfBNGpoTK0/VcEEOk/cmaaRs2+qcwS/IyjqdQC2z3dBB06i0mtLlOF6YS1CdMQusY8zbQWN5nY9aHv/W7c6zc23bCgCe2/Ic/cVdaIcff6677nx9qHfMGwaoQ8cdNynIN48whjR+ilqqPgwU/jLEyZqt72Lg/S9pvqEY62T6swZ4fbzm3qGTlCpBaSLcJqJs+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CgzCL+ZCs4K5zzF4uyDp5hBZ1chathtB9tEIF3C34HM=;
 b=mKzjnv7NiCQ8d4q4Dd6ps6ICPxNRQv+/dOl6BQDdzU01pS/srThqFMtWx8vDrIafL1SO2UAJGs2mTV58PMV8pFtOsVWEDIdOF8J7eQ/K0VpbEXCTL1IKFsFX4mocYdf4J2zIqNDsPE7MP3Ecdund4I8ZYC5n9QjEURtz8cTGaeb2ZNLk8EiIBj0Ew5NNzaJPRnNvyqCezQBcwkz7Y/M+1UsTLVXb0vgvfsPC62oT3G11orhZAh3GWUl9wSBllqrn4H6unu+1zc8HDaKr1w2cd8ybZJj6DVTCvnCMo6qbvfQoCTqYBOKnDp1hwLx5x95OT/H7r34qUPEf71/FC+ovHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CgzCL+ZCs4K5zzF4uyDp5hBZ1chathtB9tEIF3C34HM=;
 b=eH9vmW9+nHCqobekBtUlKUdFjEs8g9HvHlTHT18sWwu0/rRgcI/qmA+Fdv7qXOdg3izJJQWy0BDeSVTtUUUvP31dkcQGFu+u3Ijs5t3TS/Hm65aGYTtC9uiDMatHHZKaWm9Q1fHvTwI7MUVT+Oe5WItGzvOZiHsfLs8Km4EomTE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB4781.namprd10.prod.outlook.com (2603:10b6:a03:2d0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Tue, 1 Nov
 2022 16:43:04 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5769.021; Tue, 1 Nov 2022
 16:43:04 +0000
Message-ID: <6d29c713-47b1-a924-651f-e54b6b1d4785@oracle.com>
Date:   Tue, 1 Nov 2022 11:43:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v3 03/19] scsi: Move sd_pr_type to header to share
Content-Language: en-US
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "hch@lst.de" <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-4-michael.christie@oracle.com>
 <7f837cb5-8439-a1e6-48c5-d1df039d77ef@nvidia.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <7f837cb5-8439-a1e6-48c5-d1df039d77ef@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR05CA0005.namprd05.prod.outlook.com (2603:10b6:610::18)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB4781:EE_
X-MS-Office365-Filtering-Correlation-Id: 247e5414-fefb-4643-7c3a-08dabc2825c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L7F5VPa+9mWv34ckVVjcDWrIn1uLtxY8hkHJM+31ogUcxq2yqLenSnQt5h5LA4dbNySd2aSBchVgxfIZfpEu+M/BKAH+8M7Jnv+iO6vha37u1nNOx6joBQj3A9f4w/57TaKfew+LqurFXDRKz4txD8fSzw08s5MzfSzSp//Kzcf6iXE35dVvqMSE55LMFCuOcSGY2wLvEieoNyIjYjtVKUTyvOZq1Jnem3Su0eWqwDIDLXRVajl2AubNIV0fzBfhx5vCJpCgHz8ZrtD+vDmWKZWpmNkuVKwZH9Gu12xa8WcvTLu5G5+PQr/2RVE5Km4lFdH+DUSSulyjVGPdgs2Ejdkjv+3Sfpz78Ubb8NZ91AdD9KI2lLTmaPxycrfeU3RjZCJYV7QHnVsfNJnjysQWDBEM68sAuod8J9pvMqlOzZ0EZmzYHivqkz2YJYy+MMDb7lyfbavf+Pa29MiB7RV98xVjy4zgJ79krqDRWUvPmyh+X1wZARoegEI2UR/S6Tm5XclWnQVJGG5r8poyASn+CunJmIOWXQSv+gNjAnKpZEW6n7hKZD7sfmrFdKFsVyFZu8+ZLBzzA11y6jsnypLp1Tdnlzx8tzZbGeBX8UR5IvjMdY+O/+AK3Yr3jsVLDnEZEuaGzKLQ1wkZZA/THaqw65v8nTfg8fPh+5lcdn1TS9mTle6TiVBtpBk+mXDeuArKgjSh/C/CRmqbXfpQOM/rDDbotHK0wS4noNg1I/ymtf/bfz+sB7PGeazB4wqLRxKPdlUAPh0ozY2b+DK7yiAt5M8c/nBAuWy9Eq6EdpYLrMG2fZhaPV2Eb7NmcvFYaMlx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199015)(83380400001)(66946007)(86362001)(5660300002)(31696002)(8936002)(38100700002)(8676002)(53546011)(6506007)(66556008)(66476007)(26005)(2906002)(41300700001)(186003)(316002)(6512007)(110136005)(921005)(478600001)(2616005)(36756003)(6486002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZEEyaW5YVWVXcXVtWEtZeERQTnFhTGhpbG1vc2RaUm1IWGpOa09GcS9kMnZa?=
 =?utf-8?B?eVh3bnRVUWZBaEl6L293RWVZTVF5SlhrZzMwL0dGOW5keVFWRjZLYnNxTUtx?=
 =?utf-8?B?VGVkSytyaGh2TlRhNDgzWFJSdDQwczY4VFEzbGxSeG9Fa3piWTRmZWtLL0Qr?=
 =?utf-8?B?eEJRUDRDMFFvMDQ0am83aEUrK0Q4LzlHOXVMUFdibk1yN3krS08zbnMvcXAr?=
 =?utf-8?B?UGx2a1A3NFZWMHphTUJTM1RmdUM0MFR4M3FZSFd1OXNtSlhndDdtd0E5cXJi?=
 =?utf-8?B?OWZmd2lNL3M2dTZvLzlQa0ZMTllFQjZ4d0tPbzFlbDVqKzRCaE1OWnNnK3Zy?=
 =?utf-8?B?STZ2b0xxS1JVOUFOZ0FLREJwRitMMDhFUHpEZ0hyUVVTZloxYzhtY0dSSXph?=
 =?utf-8?B?bFk4Sy9XQ0VMaWhTYUZoTENzWFVHNnN0bzB6czFIVEpmYlYyYnNRb0N2OFVy?=
 =?utf-8?B?YkdWZ0ZraXNvZWF6VGNacnNHeXJPMWx0aStJRlFleEordG9pTnpDYVpra29v?=
 =?utf-8?B?Sm9yT0ZKSCtrOGdzc2VYbkJSRDFwb0VyQ24xL2lKcHFacXBUTGVOeWo3NVhn?=
 =?utf-8?B?UXZ4WnRPb2NPWHBUK255L2MxWGRuTmt5bU1oN3Z2RFVreklHaXp1TU5SNUxj?=
 =?utf-8?B?NnFhNXpnbDZncnI0VE1HRjM1MjY1NCtwS25EaWxwdG1nbVNkTk1kZzVpZ2VH?=
 =?utf-8?B?UmVHcWRSQTBjRXQ5REhFT0NBNEZlWWlOY1dKWW1KV01naFRxNDhXNHdFQlFS?=
 =?utf-8?B?c1VpZHJpNlFZbTJSaitTb1JDSWFsSHJCZDlXSmxGK2tnQ1ZpcFRIVEZXVTlx?=
 =?utf-8?B?a0YrcnR1MXNQdEhxZjZ4bEluclg4a0dTRHJHdlhnR2NtbGJWYUJKNGJ0eFk3?=
 =?utf-8?B?V2tqR0gwSUMxSUxwcnJqWklTWjkrbVpEOERpLzNOMlpUZzIwWUt6TWQ4bmV6?=
 =?utf-8?B?VldEVUNKTTB3YkdvNjVsZUxUa3diWlY0ZG9RdDQ0T3RmSUg1Z0Zrd2N2MUg5?=
 =?utf-8?B?OHphNmZEUk9TRUtScjhIVVFaNmIyenJGK3ZwLzFuMWdYR3Z5TUlNNmJCamxa?=
 =?utf-8?B?ZjAzdUlWT25lcnpTc3VqZWtaL2VabVFrVU8rQkZGQlQvczlncUl2eGJDRXJ3?=
 =?utf-8?B?dG54QVAveCtJaXUrZGN4TXVrK2dDbGM1U0cvQjBzaERKWmwrb3JON3V2K0JT?=
 =?utf-8?B?S2xLZnpvRkt4eFkyV0xHQ0V4TWJlenZkVnQ4Ym41SWhNT21acGJlaUQwcUNY?=
 =?utf-8?B?ZFhHQlFaOStwSTR5elpUbVhIeTIxdHI0ckNlaGVSWU5hT1F5ZmplSS9yWEZX?=
 =?utf-8?B?VXBsQTVoZUJzMUVhSTQ3MHpkOUhqQm5rcmFhSVlsRUtlSVJyZVl4bjF5aFBG?=
 =?utf-8?B?SnV1UUJUbzA5d2lxUHZPRkdRVUl1SFgzL29KMDlRbFowSm9Yc1R0QzNmQnFp?=
 =?utf-8?B?Nm0zaWlTVU5LdFRoYk42eko2LzFvVzhpek5xRjJaUmJQTDVDNmVVeVArTUZa?=
 =?utf-8?B?RHYvRzdHMFlUcXV2bDdyZzkySGlxV3crMUxKbi9zdGtjd2pjNVk3RUxqc2ky?=
 =?utf-8?B?WXN5QXVXSVR5TUZyUlZLTWl1eHFseDBuZDFZNVBpVTNlSmo1RWZYWnFKcElT?=
 =?utf-8?B?dzRlSERvRFluTFJyQzNUbUVUeXhnUHIzdDV2OW92RlZ1TlpVSTRkM25IOTBn?=
 =?utf-8?B?RjZGUndNWGp3NUZ6d0M1NDl3KytkaCtFVFdXUXZ1SGtsMTNrYlRaQ3J3cXAv?=
 =?utf-8?B?eW1sRllJWStwOEl1aWoxQ3ljdURMaHlreFg2NmVQajYzSDRTMHM1ZWV2NVhQ?=
 =?utf-8?B?T1h5d3lRY21UZXRRTnZ0Uk1MTFN5MnNQUDJEaTlSM05sejFpMUlQTjdPNDRN?=
 =?utf-8?B?ZWIxWWcvT3MxN0MvMFVXVStSV2w0aENoZjBEZzBOWVptS0h2Z2VBNko2RUNQ?=
 =?utf-8?B?T0gyU3Qyb29JU0FQTzN1WE1EaytsVjJNVWUyY2lWUWtsWis4OXYvN0MyUXhx?=
 =?utf-8?B?eDIwTHc2QTQ4eWU4dkpiZS9FY2YxTC8rNElQSUZ4Q3orSlhtdjZzUXZEaTY1?=
 =?utf-8?B?cy95TFVsbnNRVFljZmpUZXUrTzRjNHhLdmt0aDFUTE1jTVRwYXI0L3pSajZY?=
 =?utf-8?B?bnkzeU5COTcwU1Q1b21UZGFtL0sxOFpNUXBHaVo2Ym1NVjU2d3puQVMxMHVz?=
 =?utf-8?B?S3c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 247e5414-fefb-4643-7c3a-08dabc2825c4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 16:43:04.6100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SqoNJRi8X0TGdfedGlKcyQ2WtTLI1c+eQgzFlL+rok/DkU/OwfLBtgpnBe4a4r3ZhJ51+a36kRdi56MRldSdrqtk3x6rAWLUW0ZK0ekCbd8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-01_07,2022-11-01_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211010124
X-Proofpoint-ORIG-GUID: uWZ_D26lFwzl5bj4tBLyHj2JRpwLij7w
X-Proofpoint-GUID: uWZ_D26lFwzl5bj4tBLyHj2JRpwLij7w
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/1/22 12:43 AM, Chaitanya Kulkarni wrote:
>> +static inline enum scsi_pr_type block_pr_type_to_scsi(enum pr_type type)
>> +{
>> +	switch (type) {
>> +	case PR_WRITE_EXCLUSIVE:
>> +		return SCSI_PR_WRITE_EXCLUSIVE;
>> +	case PR_EXCLUSIVE_ACCESS:
>> +		return SCSI_PR_EXCLUSIVE_ACCESS;
>> +	case PR_WRITE_EXCLUSIVE_REG_ONLY:
>> +		return SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY;
>> +	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
>> +		return SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY;
>> +	case PR_WRITE_EXCLUSIVE_ALL_REGS:
>> +		return SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS;
>> +	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
>> +		return SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS;
>> +	default:
>> +		return 0;
>> +	}
>> +};
> 
> 
> do we need above semicolon ?

No. It was a mistake.

> 
> how about not using switch case pattern totally untested below ?
> 
> static inline enum scsi_pr_type block_pr_type_to_scsi(enum pr_type type)
> {
>          enum pr_type pr_to_scsi_pr[] = {
>                  [PR_WRITE_EXCLUSIVE] = SCSI_PR_WRITE_EXCLUSIVE,
>                  [PR_EXCLUSIVE_ACCESS] = SCSI_PR_EXCLUSIVE_ACCESS,
>                  [PR_WRITE_EXCLUSIVE_REG_ONLY] = 
> SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY,
>                  [PR_EXCLUSIVE_ACCESS_REG_ONLY] = 
> SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY,
>                  [PR_WRITE_EXCLUSIVE_ALL_REGS] = 
> SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS,
>                  [PR_EXCLUSIVE_ACCESS_ALL_REGS] = 
> SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS,
>          };
> 
>          if (type > ARRAY_SIZE(pr_to_scsi_pr))
>                  return 0;
>          return pr_to_scsi_pr[type];
> }
> 

Keith also wanted something like this for nvme so will fix up
the scsi and nvme code.
