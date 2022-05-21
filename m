Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A311C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 21 May 2022 16:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235933AbiEUQ6i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 May 2022 12:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbiEUQ6g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 May 2022 12:58:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1EA62A3A
        for <linux-scsi@vger.kernel.org>; Sat, 21 May 2022 09:58:35 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24LFOUna006981;
        Sat, 21 May 2022 16:58:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=klpuvwW6+h2q63AeSwIAb+W2wMKTy/M7pJKWX9/EjFs=;
 b=ojSa1+b/fFAMx2HCPqdWpVKibcTECvdQk1JGgbrwmr6Me0RNGUe7t3dPqO06aXy/cFVd
 sw01T7gWKjKaZZwfCyLbsPxF+R6xIYY85+FuthvRp7+Uxv28kEse8mdP4JUszWA62fgC
 s4UG0KGawVdCohgc5158uDn8/uoORryu6rT7tdvy9ZOuvFF6OaNEf4guRNb3v/truoRc
 3aqdEMTa0wLWpei/vZnQUX0UWp7+SCJhF5prTYau2F8OlfFANtMLvofrbSeLDnwFGp/0
 ge9+unWhJi8T7/SqW6cO3RVgrElM2/yIYsoVo4JvmByGYXtgoYv9fz31R4BIellRWMUx 8g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6qps0n44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 May 2022 16:58:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24LGwRmM031971;
        Sat, 21 May 2022 16:58:27 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g6ph64vtt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 May 2022 16:58:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kQkeNwMmJ87BZpFe0uvWsUniGzYvszQnq1Jthj9pnsm5h/T3Ehueo3MjIWHoICx4kn0O8KFlykWIbJypOLKtGW/R0eTXB3cq7mBewqtr9FyJkODbeKVtIYRANxMI+/PwZj7rIoaHJ8CP2fD4kWYrefNuEBnN11yOQ5XQTicWAczib5EB2bW8kQHa+ipPBB0+1lhSQgO+StmBaiEkhi+c+650mZwW+nfyyjgfuPcmg9OOei6Qj0ruZFYpbE4SWyQ9GBcmJpWfAzjs2HR96p6tuCVZ47KLwPpfld4SokMe9xClfDppq/qTQ2aeBvTssZvuBzA1eym94uTqU5rRylnAlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=klpuvwW6+h2q63AeSwIAb+W2wMKTy/M7pJKWX9/EjFs=;
 b=MgmzLt3Zx1zagr+t5ONoKfFThtHbcuOTtydZQe5Vwfl9dYJYsC8xTqzHTQTiPj9MyPnGjWDHTXnJ23yEaVOK4I14n+XfNkw3DCg4WF5YJlfAPfbY4vMqrqseTdIgHb68FzwSdeWyFeP5rwu9CYfakhMV8LVOzxQ2oEL3b3+oPKEITWtGPITQ+XMyy1PdJuCvCz5fG8KBuArf/w1o9BeD20HkIVdTQ+u7YT3+DCs6+4cPrH3Cgy04P991zF6HsBTjmX7oa2lJgnUYWa5dJymLmCf/PNgbeGpo9M4FwlZ6jvj26aLsNQCKZ+xSC129OrA+YzO6sy9VEvil2Saskn4YnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=klpuvwW6+h2q63AeSwIAb+W2wMKTy/M7pJKWX9/EjFs=;
 b=n7qQNVlgISEd3Fd82Ao6iV7bMckSiVAVydSPCPTncvsWWeEOZKg56ov9IQDYszajBYUyj8JLXbDerNsfb1RAyCuXmbBRYkhANSdABW7T/6WSN1jKh4G4+foKSeMQOPJW5Dfsdgu+3aVGECPQ2JUyYFyN+zKTnB2DFCwbLchOBWc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2905.namprd10.prod.outlook.com (2603:10b6:5:67::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.15; Sat, 21 May 2022 16:58:25 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5273.017; Sat, 21 May 2022
 16:58:25 +0000
Message-ID: <646bdacb-4e8d-7004-f29e-33c613e3ba78@oracle.com>
Date:   Sat, 21 May 2022 11:58:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 1/1] scsi_dh_alua: properly handling the ALUA
 transitioning state
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Brian Bunker <brian@purestorage.com>,
        linux-scsi@vger.kernel.org
Cc:     Benjamin Marzinski <bmarzins@redhat.com>
References: <CAHZQxy+4sTPz9+pY3=7VJH+CLUJsDct81KtnR2be8ycN5mhqTg@mail.gmail.com>
 <165153834205.24012.9775963085982195213.b4-ty@oracle.com>
 <c8e9451c521573b1774bd47f7a4dfe911fd80f8d.camel@suse.com>
 <32404e1c-bbd3-d3fb-c83f-394bc3765e7b@suse.de>
 <2f6d93fd90c3e78166a1803a989b4dc6064fcada.camel@suse.com>
 <7d0140a6-9ab7-9b88-9601-4204ab8a88ca@oracle.com>
 <234ccf5fc9f36fd837b3959057691a716685da3b.camel@suse.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <234ccf5fc9f36fd837b3959057691a716685da3b.camel@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR03CA0337.namprd03.prod.outlook.com
 (2603:10b6:8:55::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfc226ea-c22e-4e75-53a3-08da3b4b1eb1
X-MS-TrafficTypeDiagnostic: DM6PR10MB2905:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB29050E0CB66F4A4C7A7F0827F1D29@DM6PR10MB2905.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +WVkE1UUW63sxUncQkmzoHsqHDqgrGOnNj34AH7ZPHjS+jRUxCI9Us8wVwIqKSErp+yraH4qbuXlMWgSY6g+tS/h0Xd03cr37h9VETe9nHZhGZAAkK8y1NR85egkh5wakRIYWExSivkAenzzwv3yijLrogT0wlBQrPsP0pkSBda4m8JWWbRLQMvBV/nWArUQH3EqpvMV2ZbkCTvb4I7aK3accCnBlHu1SBma50MOko/VGJRJgHo5KO79Taumg4O4RZWxiRmv+I1vi6332jAbzDSe2K8RIau2gjkMFfUJtns2g8dsv9FKsmcT73iLNbpX3TkJGxNOfSg+gRmXxhbErzusFYuO3RjxH4jd8Fon/uKDXOr9DXITAeJG5UWEztcG7lPJ1sqgXA0SWOUWudzcrfKtSdMeVzVdymU40Ra4OUlUaOe6VFa7cYtoO79zHxpLRhS7w+JggHrmwyWR2E+O562ah3KvIeY397sde+V5KEk29hTAFR1KxXlQ4JA5FLDTktRyLFc/J31uI1ri/xeDefaba9XwrsID93ejKXH+NafiZ4DyOmT1sCPxSgPw31Hqg4VujhLVI+JhsL8/5nSrCxzpxnnFDSNzwyZk5mb0rpdTlMseq9ASddayVIjdxwiLFHcM7Iq+yOqoTqB+qUl949o04c7RAM5Dy/VTs7PmwGedzlPTTn4zCjb3gVoiHP1Kj36Kq0phH1cU2/rBDbwNIdyEg+XouUXRLVzDt58SZ+k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(83380400001)(2906002)(26005)(6506007)(53546011)(38100700002)(186003)(2616005)(5660300002)(6486002)(66476007)(66556008)(36756003)(31686004)(86362001)(110136005)(316002)(8936002)(508600001)(66946007)(8676002)(4326008)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NkhMR2FWZG5nUm5OYVd2dnBvN2F4M0RSVytTNHBiKzNWTGFZZUdOUVg4Sm9z?=
 =?utf-8?B?QnFoRkZyMkFKdGNSS1hKKzNYd3hTNG1HR2V2aCtEbmlWdERQMlpxalVyeXlt?=
 =?utf-8?B?Zk5lNmtsSG9TQkllWEFJSEdNTVY0dzNWcWNxYk40ZE53VFhtdWtyL0VmcldD?=
 =?utf-8?B?eXY5LzFOaVFHOXdzMXIwMmp0cEt0SHdYTnlmR1J4ZWR0R3dHMGZ3dCtQSGZU?=
 =?utf-8?B?V2tpVXkrL2N6dzg1OFFVbVo2bzFvZEptMDJFUVRjNnZKU1JjUDJ0ZU9XV2Uw?=
 =?utf-8?B?cTllSWpXaC9ZZ2dpMk8vUXY1QzRzaURHYVhndWYvSlRULzB2VlY2ZHJHR3hI?=
 =?utf-8?B?YTNiTVdDdWhjWVN1b2NRK0NwSGlQVHJTT3hvN0FRa1dERGxuT3hMQmx3Umxn?=
 =?utf-8?B?bFRvOUVtTWZGYm95TitXOG9YRUk2dVhocVRDU2pPS3FkK1NGYjJlUm5wOWFp?=
 =?utf-8?B?YUNhK1Z5V0Z3TDN1Z0ZYeXdYd2RQQWNwbkxSNzJ5bUZKemVyc2IyZ3pkMG1z?=
 =?utf-8?B?MmlUQlk5dTFTZ2ZtdzNQSldOQ1d6U3gzTGpDdVdWS2JaWXFIUUUzSjRURzl0?=
 =?utf-8?B?Um45Unk2TndoSS81UWpROUNJbldicVFKVXFtWjZyM0l3Y3VXV1k3dTRMUUVF?=
 =?utf-8?B?TDJYcnViNHFFLy9RR0tVNFFQaGpKSloyQk9UZU9XNkdTZUNra2xESmhqN3VD?=
 =?utf-8?B?dmlFbUdzamxSMVh2MjA3ajliSjJETVVVY1BNa2lVZFg5ZXhkSkk1eGRHTkJj?=
 =?utf-8?B?QmVhZkhHU1FGeUJQQ3UxNUppOGcrdk5jZXE1WEFiYnZEQUl0eHBVY2ZQLzg2?=
 =?utf-8?B?a3ZtUWx5ZGRYR1Z5YmFackxod1BVcmxCRXdLZFpjT2k4bGkyRDh5L0NJanV6?=
 =?utf-8?B?d0VDVHdBK3RkT0xGa0dRei9wK3A5eTA1dGFNVGlqeElJK1NQTjRoSUJhRVFx?=
 =?utf-8?B?Y2t5R24xMXNKWmNzeG1JRkdCNzZjSVBsOUJ2UjBZRHlHUjMwcldwdGxsZ1Nk?=
 =?utf-8?B?ZjVhK0t1NmRhbGhZa2s5d1YzTGl4L3RETDRGSkJPVi9Sd005T2JRSFVtd2Vx?=
 =?utf-8?B?NnQrVEdkVGZVa1pSQkN5b1E0QVpZWGVsL2VXQ3hhQVJRTGJDQlNZZEYzTEhV?=
 =?utf-8?B?YmMwK0JoOVJXeTk1bitqZFhONXRPN05XVEhTNDVYSGdvVFNtbGxQVFM5TlFi?=
 =?utf-8?B?SkNGSlA2a2dva3M2bkVab1Y0cWo3N2VrT1dYbHNVSGtQb25OSm9OclZUZjFF?=
 =?utf-8?B?ZFN6WUh2Z1M4WGhlWnA0eW5jTm5LdWdHTFBMWGlYT0JKd2VlZTJWaHA0K25O?=
 =?utf-8?B?TkRCYkgxS3FyUUs4VEdoY0xOYWQ3c2J5dkVwc0tQR0FHVFQrcDBWeTFRQlh4?=
 =?utf-8?B?UEZ6bTFSNm1JY1BpWHM3YmREd051YXBIdHA3dmE0ODhpM2cxN2pzVmdpVjdB?=
 =?utf-8?B?cDZjYlJZNTg5c2JFa2d1eUQydTNFeHRFZW5FWDdSZGlmOXNNMkpwT29oY0Rt?=
 =?utf-8?B?bmtqVjVkMC8vekNxZlNXbWxQaGRQZDUrM3pZSDIzRG9ENi9jU00xcGxKTjNX?=
 =?utf-8?B?NkEzVU0yd0x2aW01dTZjaUVKOXljSE5Kb2l4czNlTTBmTVN4UEExUEl0djQ2?=
 =?utf-8?B?NUxMdU1vTWYvb1QySlBZZWxKZzRzUUFHSXY1NzF6Z2xqZlA5V0xWL3NmcXV2?=
 =?utf-8?B?bkEyN1NIejRxU0tySStLVDBweWtFcXlWYm0walRLQnpoOW44Q0VMalZManBQ?=
 =?utf-8?B?cnRtR1UzWmo0ZS9RcDF6eXZrYVJuUndaZStZOEgxcTNLbUtVN0dYdjNQVWg4?=
 =?utf-8?B?dVo5VmErK1VPcU15eWxEcGtTQ29McjYxclNUbkwwc1Z3dEhLbUo1MVAwSmVz?=
 =?utf-8?B?UzUzd1VGb1dWZVhDOUZ4eDZGVVhqNitFNFhCSzVJSHUvRE8rNFZiQWJsaWZR?=
 =?utf-8?B?Z1cwT25VR2IzS3N4akhSeXBEeFFDTzhTZmJUUzIyem0wUG5Ja2FlSERMZHZv?=
 =?utf-8?B?TGlqU0dCZnRUZlJ2OVpvbjZjdktQbUw1WGovZzVNaWF5ZFhUd1U2UHFkaVFv?=
 =?utf-8?B?N1ZFb09KTjdibG5wQnozTlRFemtmdkMyNDN6Tks0aExCTU1lRDI5OEltOS9r?=
 =?utf-8?B?L2grYTZoSDRHUEVVVUZSeFNZd3lQRkxWOExGWVdlZHZ6VnY0Z3kvTENyMEdC?=
 =?utf-8?B?RmticEtuaEM0d0p6LzdUcW5pZks4c2trUjBTR1RvN2RTOXlBcVdYQzlLWXpM?=
 =?utf-8?B?MEpRRlBMaEErL2pKRlpLM3RTUFJlRlVpbVFtZVI0TnBMVndIeHVmdzZONkY4?=
 =?utf-8?B?Tjk4N09tcGZ6WGM1ODloQ0dyZ0pRRytrd3hoN3QvRGV6NFVRT3RFdG9PaE9p?=
 =?utf-8?Q?2bq7K8+NfRgMp3qI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfc226ea-c22e-4e75-53a3-08da3b4b1eb1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 16:58:25.1901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W61rgehRA9gDn4d0mD3rMC+Gbse9TKM685ZAlxRO7KQFH+1n67SIicMs863E0UeP7Vl0oi9C8VG/9xjhvDX9/8dIeYLOgN2rkIG98BT6i0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2905
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-21_06:2022-05-20,2022-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205210107
X-Proofpoint-ORIG-GUID: 9IKc4KNZmJkumLjmmY0nXYmzMjnKKzc0
X-Proofpoint-GUID: 9IKc4KNZmJkumLjmmY0nXYmzMjnKKzc0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/20/22 3:03 PM, Martin Wilck wrote:
> On Fri, 2022-05-20 at 14:08 -0500, Mike Christie wrote:
>> On 5/20/22 9:03 AM, Martin Wilck wrote:
>>> On Fri, 2022-05-20 at 14:06 +0200, Hannes Reinecke wrote:
>>>> On 5/20/22 12:57, Martin Wilck wrote:
>>>>> Brian, Martin,
>>>>>
>>>>> sorry, I've overlooked this patch previously. I have to say I
>>>>> think
>>>>> it's wrong and shouldn't have been applied. At least I need
>>>>> more
>>>>> in-
>>>>> depth explanation.
>>>>>
>>>>> On Mon, 2022-05-02 at 20:50 -0400, Martin K. Petersen wrote:
>>>>>> On Mon, 2 May 2022 08:09:17 -0700, Brian Bunker wrote:
>>>>>>
>>>>>>> The handling of the ALUA transitioning state is currently
>>>>>>> broken.
>>>>>>> When
>>>>>>> a target goes into this state, it is expected that the
>>>>>>> target
>>>>>>> is
>>>>>>> allowed to stay in this state for the implicit transition
>>>>>>> timeout
>>>>>>> without a path failure.
>>>>>
>>>>> Can you please show me a quote from the specs on which this
>>>>> expectation
>>>>> ("without a path failure") is based? AFAIK the SCSI specs don't
>>>>> say
>>>>> anything about device-mapper multipath semantics.
>>>>>
>>>>>>> The handler has this logic, but it gets
>>>>>>> skipped currently.
>>>>>>>
>>>>>>> When the target transitions, there is in-flight I/O from
>>>>>>> the
>>>>>>> initiator. The first of these responses from the target
>>>>>>> will be
>>>>>>> a
>>>>>>> unit
>>>>>>> attention letting the initiator know that the ALUA state
>>>>>>> has
>>>>>>> changed.
>>>>>>> The remaining in-flight I/Os, before the initiator finds
>>>>>>> out
>>>>>>> that
>>>>>>> the
>>>>>>> portal state has changed, will return not ready, ALUA state
>>>>>>> is
>>>>>>> transitioning. The portal state will change to
>>>>>>> SCSI_ACCESS_STATE_TRANSITIONING. This will lead to all new
>>>>>>> I/O
>>>>>>> immediately failing the path unexpectedly. The path failure
>>>>>>> happens
>>>>>>> in
>>>>>>> less than a second instead of the expected successes until
>>>>>>> the
>>>>>>> transition timer is exceeded.
>>>>>
>>>>> dm multipath has no concept of "transitioning" state. Path
>>>>> state
>>>>> can be
>>>>> either active or inactive. As Brian wrote, commands sent to the
>>>>> transitioning device will return NOT READY, TRANSITIONING, and
>>>>> require
>>>>> retries on the SCSI layer. If we know this in advance, why
>>>>> should
>>>>> we
>>>>> continue sending I/O down this semi-broken path? If other,
>>>>> healthy
>>>>> paths are available, why it would it not be the right thing to
>>>>> switch
>>>>> I/O to them ASAP?
>>>>>
>>>> But we do, don't we?
>>>> Commands are being returned with the appropriate status, and 
>>>> dm-multipath should make the corresponding decisions here.
>>>> This patch just modifies the check when _sending_ commands; ie
>>>> multipath 
>>>> had decided that the path is still usable.
>>>> Question rather would be why multipath did that;
>>>
>>> If alua_prep_fn() got called, the path was considered usable at the
>>> given point in time by dm-multipath. Most probably the reason was
>>> simply that no error condition had occured on this path before ALUA
>>> state switched to transitioning. I suppose this can happen
>>> if storage
>>> switches a PG consisting of multiple paths to TRANSITIONING. We get
>>> an
>>> error on one path (sda, say), issue an RTPG, and receive the new
>>> ALUA
>>> state for all paths of the PG. For all paths except sda, we'd just
>>> see
>>> a switch to TRANSITIONING without a previous SCSI error.
>>>
>>> With this patch, we'll dispatch I/O (usually an entire bunch) to
>>> these
>>> paths despite seeing them in TRANSITIONING state. Eventually, when
>>> the
>>> SCSI responses are received, this leads to path failures. If I/O
>>> latencies are small, this happens after a few ms. In that case, the
>>> goal of Brian's patch is not reached, because the time until path
>>> failure would still be on the order of milliseconds. OTOH, if
>>> latencies
>>> are high, it takes substantially longer for the kernel to realize
>>> that
>>> the path is non-functional, while other, good paths may be idle. I
>>> fail
>>> to see the benefit.
>>>
>>
>> I'm not sure everyone agrees with you on the meaning of
>> transitioning.
>>
>> If we go from non-optimized to optimized or standby to non-
>> opt/optimized
>> we don't want to try other paths because it can cause thrashing.
> 
> But only with explicit ALUA, or am I missing something? I agree that

That section of the spec mentions both implicit and explicit. For
implicit, the target can want to rebalance resources for things like
a resource is down permanently, or you add more ports, or we bring
up/down resources dynamically based on usage or maintenance.


> the host shouldn't initiate a PG switch if it encounters transitioning
> state. I also agree that for transitioning towards a "better" state,
> e.g. standby to (non)-optimized, failing the path would be
> questionable. Unfortunately we don't know in which "direction" the path
> is transitioning - it could be for 'better' or 'worse'. I suppose that

For implicit, the target knows. It's initiating the transition based
on whatever metrics or resources it has. We want the initiator to let us
complete what we are doing.

For explicit, then again the target knows what it wants to do when
it gets the STPG and we only it to set the paths to optimized. So
if it goes that route where it completes the STPG before the transition
completes, then goes into transitioning, then we can just let the
device do it's transitions.


> in the case of a PG switch, it can happen that we dispatch I/O to a 
> device that used to be in Standby and is now transitioning. Would it
> make sense to remember the previous state and "guess" what we're going
> to transition to? I.e. if the previous state was "Standby", it's
> probably going to be (non)optimized after the transition, and vice-
> versa?

You are referring to the issue Hannes mentions where multipath can pick
up the transitioning state and it might get confused, right? I'm not
sure what to do.

> 
>>  We just
>> need to transition resources before we can fully use the path. It
>> could
>> be a local cache operation or for distributed targets it could be a
>> really
>> expensive operation.
>>
>> For both though, it can take longer than the retries we get from
>> scsi-ml.
> 
> So if we want to do "the right thing", we'd continue dispatching to the
> device until either the state changes or the device-reported transition
> timeout has expired?
Sort of.

Ideally I think it would be nice if we blocked the device/queue for
normal IO, then just sent a RTPG every N secs or msecs until we changed
state or until the timer expired. We then unblock and either fail upwards
or dispatch. I think this is a lot of work though.

The problem with constant dispatching is that on low latency systems we
retry too quickly. I had to add a little sleep on the target side for this
or we hammer the target/initiator too hard and we got warnings (I can't
remember the exact warn/err).
