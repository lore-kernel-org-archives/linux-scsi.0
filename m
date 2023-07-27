Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DEB6C00528
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 09:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbjG0J2a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 05:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234609AbjG0J2K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 05:28:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67C230FF;
        Thu, 27 Jul 2023 02:18:54 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36R0s9Bg016850;
        Thu, 27 Jul 2023 07:35:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=HgY406vWUt6W02NZlsEL3bliR4PIKGDxV2AKFU0DUEo=;
 b=IVcG1qnTwkLNWhnYjg9RBBdY3hYV4TprSFZRfNioMR3YMA+5fA30iDh6cA7CTpxh7GY+
 L7XDbscmrZEe1B+Fljkq2Afh9v79pMoVO9RqxPgHW0IQgThOZDqqEVmCyhi9LTMRWSHk
 dHo6MxkT33vAtW33mYwx7UpJvDoua3t4UX8cnYNsD/atvBU4rZwhH0ytFAjSQZSSPoHx
 y44FjWqJYuPPdspXkc0pwkHKYTOYkT6OuArursRUSCmVCgrKdoN4/ZHaE+IxnQhl53g1
 Ckm+MrXdrx+s+iOQ9I/hHjH0vSlJ7s7B3x3WyqrR1QD9dn0bmSfdf5UFwwnPGAuO8j1J dw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s06qu13sj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 07:35:14 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36R7MAn6025523;
        Thu, 27 Jul 2023 07:35:13 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2043.outbound.protection.outlook.com [104.47.74.43])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j7s7ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 07:35:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OIr3UZA21KmNvFWPoLVQOUjFDB58TSndUKx9iy4oijV+9HgwePY3ITixSIAYgt+ewJHF0V/IZdjlWSR7nLgXmQmEM7YR8tqQMcrjaZLSPBuadKd9Afz32rUho8cfFob66/hTKF9wkr67CUkuqOO9ohnTRommyAJxA1WdNAiU370JwHbEt3T1WVRD51mSOR5P+2YJi1SIhZWrJXztt9NvScnweTNW9ULCs812zPwrWqlyys5++3zCiMwtFQE4p6IVK3Od7GZEHa4hsoQNKhOHQLXciFpse0hNKO+0/8UmQ3Zsf8bSrREnDAL8fH611N+tpBCUn6FTzRlVtKuygG18Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HgY406vWUt6W02NZlsEL3bliR4PIKGDxV2AKFU0DUEo=;
 b=jh5o4jaR6QVu0/8Er+g6DMhyB3iAs8+fx1XqZCtvIEGcuNGrTZZwjuqinR/hvbfQ62ztQEDqjuHiTftHylzf7tl72OR6vYXi1+gx4tALeQ68Hrk+43VYC9DHx0nBMlOjofFR4Z9oPOlE5a7GiXerX0qvUUSXBqC7D+UnxVZJwyzHtkPHOH3+Ye/8H0tqhHVQKf/qO5tEX4ztH2Sd8HxUYjiNxK7/wbiJR2k7+dqKRCVsboV6oFbXG/XL3ZXk1CjpoAt6FTBuyenwoxB5MbCAkrpxB5VwiSwCxCb4naSf/QwWdVPZZhRm/ATw83WphlH5y7DCGvGK0FDB/pnUSfP/dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgY406vWUt6W02NZlsEL3bliR4PIKGDxV2AKFU0DUEo=;
 b=zJuseeY085wewNPV/47wXLDC+60m9tNhqk6fe5AK6rVQwB/6au8XzqW+hT0U3HtHZmnx/iyVqWQ8sfDM8LSFpsOcqlLP7meO5C44/UV1cKEEHBpueCoZ8BgzcvqPYDuxMIN+fgYfT/W7bOkI5YmNWvaUnxSRhMYPJwO3AJYZmgI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB4565.namprd10.prod.outlook.com (2603:10b6:510:31::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Thu, 27 Jul
 2023 07:35:10 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Thu, 27 Jul 2023
 07:35:10 +0000
Message-ID: <44b1bd30-426d-db85-4b52-4f079948e52a@oracle.com>
Date:   Thu, 27 Jul 2023 08:35:06 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH V2 5/9] scsi: hisi: take blk_mq_max_nr_hw_queues() into
 account for calculating io vectors
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>
References: <20230726094027.535126-1-ming.lei@redhat.com>
 <20230726094027.535126-6-ming.lei@redhat.com>
 <07f84570-5307-df3c-99ab-a996bfcbf83a@oracle.com>
 <ZMHFQm2BpuGjjlTm@ovpn-8-16.pek2.redhat.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ZMHFQm2BpuGjjlTm@ovpn-8-16.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0526.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB4565:EE_
X-MS-Office365-Filtering-Correlation-Id: 9213b40a-bf54-42fa-cd17-08db8e7401ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CuaYzUropqJWAODmabZDpYLAaLqtvzir/5RXIBoCvHy3goHp9FdoYvYZ/fBQEzvK6EvE+Yr+HLTduQLa+EiL37oXWrkdRTpsBj2l1aGosjm7RukvypEKEj6wXk0vnLQSgbASIyfn2DsHTITlFsS+CgbGP17own8On+2654Sj0qj8/F8tFmIBf56xWevqJyJHpoHIJOdLwpmTtpKD3TENdREZ8PaUv8oGxdzPvEWBYrxLcNJvYvyS1HqzvPvBI/u4JCK65irzB42e8L38nookaG4zfMj6k4e5TWSGiVXb1Dt5/7GVhg+kkIF0o+GD9wd63ioOk8PRc7Rp+heCf2/2cfQnr+B09scBK5pt3q+A84rMkMrgPLmEB0dhqCvqCaoDGd900Pmbi+Heiv41HtRqW4JBCzet5W0RC3LzHJY37fbrdSJ/hLEkkCL5cuhUcKs/TaHPsep0UIJMS3uTUCa0/RVwezm40PXyNz7e7/tvB/poILw0edBa9jcIhdtzRiplnRc0ygzX7pEwv7WVOmrDBUDkqRNAsOHeoDRYcXtghxVzHgNM2cjD5+ts954J0i/vPx9pNSL70PlWK4Eq0joT8z91bZ+kY4RFe+opc0mk8EeKr7NOvA1+wV49EWosJhnPGq8gOHCRjaJwi0djUgyfFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(136003)(39860400002)(396003)(346002)(451199021)(26005)(41300700001)(186003)(53546011)(4326008)(6916009)(316002)(2906002)(83380400001)(36756003)(6506007)(5660300002)(8676002)(8936002)(15650500001)(2616005)(36916002)(6486002)(6512007)(6666004)(54906003)(86362001)(31696002)(31686004)(478600001)(38100700002)(66556008)(66476007)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3FzYnJXR0dobDBxVEVISFBaN2N4REtwVGhya2N2Tlhmb1FvZU1TaTc1b09j?=
 =?utf-8?B?T2ttY0g1YkZYTFZXbEhLQ1BjeXBHVmU2TjhWNVE4KzU5NnhYdkVpeGk4bjdS?=
 =?utf-8?B?M3FGa2hnc0M1RmFkUGYwdHAybWpvOHZHdXJoTGQ2Z3lHYkJ5MzdubEttQTkv?=
 =?utf-8?B?VitxM1BpQmNYKy9OSm1ISXB4cS9xRVd5VUpuWFhPWnNxazI4Rll2YytvS0pY?=
 =?utf-8?B?SGZLODc4TWRXOHRQNllQYnV0MGpYR00yaTZUTWlOWEZXc1AzQVVRY1R4Y3Nj?=
 =?utf-8?B?UGVDT1E1b0tsVUlNd0F0T0JwZHVlVHhKVGtRcjI4d0g0dUpkZXhHMlgxRHJu?=
 =?utf-8?B?S3p0MEhWMmV0VDhrNEZ3Q05SZjVkeGw0a2tpTk5KVXR5QnJHNUR6WWY4VXQz?=
 =?utf-8?B?b1hpaXRQNEwyRlI1Si9SZ3p2OFNRQ2J5UnZYWGEwRUFCcDM0ZVVVUkdFM2xY?=
 =?utf-8?B?NUdKdUhRVFc5djhHcHlET21xQ256U3JKUzV6cHJUZEliYVVaYU83aW5ZME1V?=
 =?utf-8?B?b0xzejk5Y0pDS1MvcmdHTXpxbm1QVXRnRkpONUExSWhvK2lLNE4rcFRNRjNQ?=
 =?utf-8?B?UFE0RjZUTWhTaWF6MDBQY1VDOE81a1JKaUNRcWVmZm1lekNHNGdNZVljb2Q1?=
 =?utf-8?B?bFlIb0FvTTBGTTU4V2U5eFVmWk1tVWRuN05JeXY2WW1XeGJrNElUS2FBS2xm?=
 =?utf-8?B?U05Wdm1OM2p6VFRnQ2R6eWdxOWZpRnFtUW1BM2RpTTB6RWRLTUpsVGwva2lF?=
 =?utf-8?B?NGxiYU5oVzdFQTlHL3E1bUtaSzJobVhJeDBnZXVOQmx4eFlhMlg5WlphY29R?=
 =?utf-8?B?WTdaZktuU3pxR3hmWkR6L3N3ODV4cFQ1L0NnRnY1QlE0bE1Vd3U2V0dDcm5H?=
 =?utf-8?B?TTF1N3g1Mmc2ZElUd3VkNHoyR0tKQ0w4cCt0RHN6SjU4MzV3b1FTVWozVE01?=
 =?utf-8?B?LzNnWHMwKzgzOElsS2czTnRiVDhOL3NUVWpHRE9scW5vWDgvMktLMStMdStL?=
 =?utf-8?B?NWdnbXE0UGxqcFU3dzJzMkhkd0k1SktTZ3dRTXlGMzRQd1p1Z2RkaXZrRWYy?=
 =?utf-8?B?V2hwdHdaLyt4Sm1nMURYdFhTbkxWZ2F0bGJqYWlNOHdJOGZlY2tQVW1TbUNj?=
 =?utf-8?B?R0pjMzVORHZ4ekVZTUxhUitJL3h1OGdSb1hVbkV3KzM5NWhQUWtlK0IvelZi?=
 =?utf-8?B?ZlE4NWZvU3J5MGEzZWZMNFc5TnU0R0JRZmw1N0JrYzI5TDkzZVpKa3QrWHRV?=
 =?utf-8?B?Z255dCtZUU5BbDVDcTN1WlU0bjZwTm1jZ1N0MDFWRXR2VEVkYkJoRzcxUTYx?=
 =?utf-8?B?NVk5WnVnTUFLbisxZXovL2g1TzVCOTFNZkg5R0JJNkQ5UTJHcERBMEhNc2dN?=
 =?utf-8?B?d2Evam9SYjkySW9ETDlrNEpzekQyZ1QvY1Y1S3Vrc08zeXg3SmdybG1VT2pR?=
 =?utf-8?B?aURxWTRNZHh4THFkNG5iaGdRRWpwVHI3KzZwQnlObXA3OUoydEo5RlZSdkw1?=
 =?utf-8?B?enU5WjRWZyttOXJjaDJrZFBva1VCL0h4eVlFVTA1MEVBbEVNdEJnSTYrc004?=
 =?utf-8?B?eWtRSU9jaFhERWJtaWc1ZlBEdGtmNVZ4N055NkdUQU80SUpyOTdTVG84TERn?=
 =?utf-8?B?QWwvcGhpSEVqN1BqeWp4anNzUjRPVi91dEk1Tlh5RmV3TkN1VGhBcUQ3VTVx?=
 =?utf-8?B?a29DdzJCVmMwa1RiMHprM0xPeWYrTU5uYi80ektYOUEvSEZEYnJ3UHRTdzhu?=
 =?utf-8?B?MVNrclBaZ0NRUXUxNldOQ0REM2xLb0JZdUd6NEpOakhMWjhucERqWlQ2aUlp?=
 =?utf-8?B?ZlVON1VpSzdaaVZPUTFQSXpqZXFndjhXdVNUcW1OYy9GSnhyblUzTzZQQmVF?=
 =?utf-8?B?QjY4aWcyOWtrNU5na0hZTkF0L09IZmVDSkdNcEkxS3dmMk9zcFgzMTZZUnpk?=
 =?utf-8?B?aiswcGFKWkpkQzBINGlIb0Y5MUdYSkZmb1psWUo4WE5JMkFnS0NrR0pUYktN?=
 =?utf-8?B?Z0EvRkxqajgxZmJUbVFFLytKWXNSQjhCYmMzb3JOUHVwY2pkZUd2bTVkTmp4?=
 =?utf-8?B?bWxnMXlOV1JrTi9ycFE4ZVZlMHoxRy9VcXBkRTJwUXpHblFvL1BNcmp1N3BJ?=
 =?utf-8?Q?5ugCMjl9MlFjhymXph2Rx9LPc?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?YW5MUEY1RUNrenRBWlhEbDlmejYzbkFuTjFCQWs4MkpTc1pYSStQRS9GaWJu?=
 =?utf-8?B?WE4yZDZHTjMxUzJZaVNxRXI2bG5teUhVOVE3aWNncnpXZ25NMTBYTnhSTXNB?=
 =?utf-8?B?cTNWR2FqTElqbmQ1Ym9tTlBvVkhsZDI0MmUrRytCQkk4enoyelNmcDFWYjdZ?=
 =?utf-8?B?VmdteEZXaUp4UUcxRHVFU2hZSnhXTGFnQTE3bk5hUlF2Mlo2RU5OOTEzbFdK?=
 =?utf-8?B?WVJIbloyeUdzTlJNQ1pVY2lnS1dPTWl1SGlkU1YvNjVzbWZIZklvVGNKRUZK?=
 =?utf-8?B?aDA0ajc3dk8zTnNXVEdpVURjTTdxYUFmbWR4cUxkUUpscFdDY3A2emU0dTND?=
 =?utf-8?B?SDRXZG9Fa3FPWml6L3FrRDhLTU8rVnY5MUNpdFNIS3kvNmR6cVJuZWVpc3N1?=
 =?utf-8?B?NDlXT3ppYmJ4U211eTBvYW5vTjIvS3VWSVgwQUs2aVlYWWNRUS92d3loZEtu?=
 =?utf-8?B?eGc0RmFMOXh6ZkZUTFgrbDQwWkwwcVVFMERLd1ZkOEhDV1h4WUx0aEFLQTl6?=
 =?utf-8?B?QU5TVjk4emtWdHZoc2V6enJ6ZzBFeVcwY2xBbDBtL1NIQ004YjJHZmlpdTZt?=
 =?utf-8?B?TFp1cW40K1ZhZXZLK1NHc1FLQlFkbzluMlh4WFUwNlNyOG8rUGpOS2dUeEJJ?=
 =?utf-8?B?NHdMa1pCT0ZaMjRsVnlFeldXcDFpRlAyTFE5UXYwK1IzR2dYcFBNVWllaWVw?=
 =?utf-8?B?Y0RnRVU2N2lZdkpxcDBWdStSbXhjTFl2YmdQMEhpakFvT3RFM0V1ZWgzZWlS?=
 =?utf-8?B?dnJMZkRieFpoY1F2MFpBSFZORUtya2t0aXR2eTVJWGtCK2ZXMHRSR3dmNnBC?=
 =?utf-8?B?SXBwZzJJeTY2N2VCWFU2SHFVcGZ5aDR5dHlSK0xpTFhwZmpaZTNlL3d4aUJQ?=
 =?utf-8?B?Unh4eUVhMTRsUXoxczFYVm1QQkVqVStKVy94eENMd3JPYWFnT0VLZ1NMYW1n?=
 =?utf-8?B?TXRhTnphaEVpYnVuekJ3clA1Mld0ZXB6SGo0Ung4d0xwR2ZrRFN5Q2FHbkk0?=
 =?utf-8?B?Qy9wYXhLQWdGY1pGRXBJUXNESG9IQ0t3WUFMN0JlWkEvdW00TkZlQnM1Sjd3?=
 =?utf-8?B?UlVzQzRxSlZQSVFSME1BbzlGTHdKaStzZGtnSS85MktEdXhlOEdrWXNLR2NJ?=
 =?utf-8?B?Mk9EaHVWVkMzVEpmTTJaZVFSaU5TcjFucDQrRzRqMDdhUjZLWS92VjU3TmJ2?=
 =?utf-8?B?MmE3eEVKYWhqNGxyRGQrZ040MW93UU1mRUJSM3QwOUlzNGZ1LzJQR1N5d2U1?=
 =?utf-8?B?OERDdERBejB5YzI4Mk45cWtLYkVpQ1dxZW1ac3YxNTdmWkRESUlyMml4bWtw?=
 =?utf-8?Q?XSG9W/l61MgFg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9213b40a-bf54-42fa-cd17-08db8e7401ef
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2023 07:35:10.5250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aX3K9HTsPhl+GXBTCCRTmcQWL/T5+8px6SQbKB99xXg1zJu2NmimzAbs/dn7Smwh3rGUQGWb7rncIGLneSoD1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4565
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-26_08,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307270066
X-Proofpoint-ORIG-GUID: N_CBnFSG-14jvo0g8CxgIiI6lkjRx4fK
X-Proofpoint-GUID: N_CBnFSG-14jvo0g8CxgIiI6lkjRx4fK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/07/2023 02:15, Ming Lei wrote:
>>> hisi_sas_v3_hw.c
>>> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>>> @@ -2550,6 +2550,9 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
>>>    	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW - hisi_hba->iopoll_q_cnt;
>>> +	if (hisi_hba->cq_nvecs > scsi_max_nr_hw_queues())
>>> +		hisi_hba->cq_nvecs = scsi_max_nr_hw_queues();
>>> +
>>>    	shost->nr_hw_queues = hisi_hba->cq_nvecs + hisi_hba->iopoll_q_cnt;
>> For other drivers you limit the max MSI vectors which we try to allocate
>> according to scsi_max_nr_hw_queues(), but here you continue to alloc the
>> same max vectors but then limit the driver's completion queue count. Why not
>> limit the max MSI vectors also here?

Ah, checking again, I think that this driver always allocates maximum 
possible MSI due to arm interrupt controller driver bug - see comment at 
top of function interrupt_preinit_v3_hw(). IIRC, there was a problem if 
we remove and re-insert the device driver that the GIC ITS fails to 
allocate MSI unless all MSI were previously allocated.

Xiang Chen can confirm.

> Good catch!
> 
> I guess it is because of the following line:
> 
>     	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW - hisi_hba->iopoll_q_cnt;
> 
> I am a bit confused why hisi_sas_v3 takes ->iopoll_q_cnt into account
> allocated msi vectors?  ->iopoll_q_cnt supposes to not consume msi
> vectors, so I think we need the following fix first:
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index 20e1607c6282..032c13ce8373 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -2549,7 +2549,7 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
>                  return -ENOENT;
> 
> 
> -       hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW - hisi_hba->iopoll_q_cnt;
> +       hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW;
>          shost->nr_hw_queues = hisi_hba->cq_nvecs + hisi_hba->iopoll_q_cnt;

Thanks,
John
