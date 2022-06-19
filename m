Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C972CCCA47A
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jun 2022 16:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbiFSQ0s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jun 2022 12:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiFSQ0q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jun 2022 12:26:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2091BA475;
        Sun, 19 Jun 2022 09:26:46 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25J9H2wq029320;
        Sun, 19 Jun 2022 16:26:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=aNZFAKyN0lsvHCPSZoiumsUYSJxYdNG/QphWr7pxRgo=;
 b=FGwEKdJuYa7HgoSuqCuWKlf2B+C6N3MteS03r28SuuT5bniCi3t/oht9WpUr/rRrVRdY
 mVs/lsASZQvkdUYhsKTdMbREEHy7Fi/3HUGbVmuB874FvXdBPffLHyVrR60fdNcOdpPP
 p+arik6FOrcr2CglayxHjKCeFluisVa7SbYUKgwlqv8n6w+Pj65H7pkJNU0DoRubKxRZ
 OKwIaPE9kNBzxZ6D9pZvG2jB5Ot7DXadcfTyoP15zXkteRiCEZeQT+hAG4sL5Fqu+R3o
 Z7Cbcmbs+AvejK1Fb/A86s5+rmf5du96QzHuenvFddQvW54dWhrz29eHQAPSI/FouisW pg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs6kf1kvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Jun 2022 16:26:42 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25JGAOhI031132;
        Sun, 19 Jun 2022 16:26:42 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gs551eqqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Jun 2022 16:26:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XFDMSsaajJaYrAhaRowOvCfX2E+DTxuVB/3ZnUMqyxYXNiwETkpAyERLHmdvPXPMm9z37dxTj7qMOqAe1i4O7BHrw1NYU4mFBduQGmSO6WnA5eAN8xpOqcDOgMuLNGRFCM0taUCFsUh2fih8G64FGWQ+vjfGiIqckHxsct2GzFB78pwlCfMHHFa6JwEcVTS2ASWlREbeuH/7VKIgbiWC6hqYKhFINASosxYIGMVczMxwPOUhjUNK1I7wybsZmSsRw/uiVJkLZkGeOV9THVaHKcuMdw2QV2iWmGUgTHLu4N0phmriwHegWRPXfO4qJJLwa/TMCtH2ARLiAPFyg8CjXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aNZFAKyN0lsvHCPSZoiumsUYSJxYdNG/QphWr7pxRgo=;
 b=i9GNMy20q7HFn9kcKXcWAruvTCxV1JAVjE/tlYVnG9U6oa7RKIyyM2yIZAjnWasxdcLqrFB+oVR1bJB8UwMhRSPYQByRx64vlcV7HIDNhr3RcOn4RnUoXPxdcSl1JnV4bjn5fZ/L4d5tJ93LqTFEKGDqj7VBaPV+ye9QgnoJb2VDFUcHqWLy4iBmGBQ//MEYgOSN4vYo2BPSV/Wdum9thtGnsKrOiD8fzlwU/7Ij8RUz1wegTFgM/wMqAWzgNAs0ZPQ7xQrNGEgNgM0Juc0Gy+JRYr6vgkN2qkNMQGE4eYVurr7PJ+9lDfGcBqqCSd864cgZ0Kkr4HXTkarNgxrKrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNZFAKyN0lsvHCPSZoiumsUYSJxYdNG/QphWr7pxRgo=;
 b=uvrv9WDZUmghUvqEtpUyQuWG1AVhed67WAJm3lObuzj4AXQ9Pv7OuMOWP26OW6GaP48RhTQveVQH4m2/aU+SN4QIeSlIAASqRZLQYT5+CNZhn70BMFhOncwokxhR0ss8ojdgk14T+UhpUinC7rDOjGgWTgZpwEjdRNUHRRH02jU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5302.namprd10.prod.outlook.com (2603:10b6:408:117::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Sun, 19 Jun
 2022 16:26:40 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5353.018; Sun, 19 Jun 2022
 16:26:40 +0000
Message-ID: <5f6d0dac-5eb2-ee02-3786-bfb83be5a3f7@oracle.com>
Date:   Sun, 19 Jun 2022 11:26:38 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH 2/4] scsi: target: Fix WRITE_SAME NDOB handling in file
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220617030440.116427-1-michael.christie@oracle.com>
 <20220617030440.116427-3-michael.christie@oracle.com>
 <Yq7BU8EpZZh+C1QB@infradead.org>
From:   michael.christie@oracle.com
In-Reply-To: <Yq7BU8EpZZh+C1QB@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR07CA0147.namprd07.prod.outlook.com
 (2603:10b6:3:ee::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b6357cd-3ba3-48a6-cd0d-08da52107d2e
X-MS-TrafficTypeDiagnostic: BN0PR10MB5302:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB5302E2727FC13866BD584389F1B19@BN0PR10MB5302.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mJd00awK6SkSeTEKmnenir1n0aP37nx3k/0Y9nRIV/zYTmUZ7lCbN2zm3OlTMb9uMvClZIL2UbZadf4apYnZOmZmdX1dHMOamVhRjLR1QEP0j5W1ixiteEZMwq2/Y3vYP6Rsxhc51WZrKJh34f5LHJHsUkFDzklP+gFPvKHY9OORixQMoPDTC1SZ0/BKpkAityZjll/uWWNXvyxr1iD8Yet1Kde0qMeczKnbV9BRNO701amKV/vUgHPCfBDof4p9iM3UyhKArA5FIOSUTQhF14h8s/bhFQ4l7a6+QAzMfIxxnMgD0y4HU6zQ7zMy+KYZh6L/VpmU4zN7hCYljMEeHV2yN5rBHbN8wZEQ4gKuDVDMwEQg3vx4Zg2CLjs+Vi3t86yNwH5YkxO6rPVT47qRaBPOXm4WCf8oM8Xm4Kn+fU8IBZraF1pqjTXUIVcwvL/aYfy/X4j/Aoqotc3LqmxgQB3BXUbvy40IXcivkZVml1K/B3Pc3wCb3GbMb73AvTGZmMZz/0DWl6SISHme3E+lkywKTQ8C99FDVtWM3dNGzNQpyMTEfzugeRzBHXz04g4sPYU1nbWgGKOKf0ddWpjx5htWavHlSoVFrFuo/ZL2bATWEALWCpCSD6uYO+0jxi6X/PhRNkQRPCU7US/zGX4+0PyJyF+n6Bi4Pzb/R6lYuNBkMM/Z1ruNeR7+9ZuCtWTCgNnzTQt+0nG3uEQclHBPDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(6916009)(66556008)(53546011)(186003)(31696002)(6486002)(8936002)(6506007)(4744005)(31686004)(4326008)(8676002)(2616005)(5660300002)(66946007)(66476007)(36756003)(316002)(6512007)(9686003)(38100700002)(26005)(2906002)(83380400001)(498600001)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3J3VXlDVDZDZGNocVROaHdoeU5KSzFMSFZNUlhhS0Jkd25nNFRjMW10dmV3?=
 =?utf-8?B?OGdUYm9lR0FScG5udGtYR0NIWXFHaXlJNWxtMVFBdVd5RDR5STJuODJsazBB?=
 =?utf-8?B?NWJmeGdiTkI1eVBjT3lIV2hwSFNRUkRGMmZKeGVEbGNuRUViNzhNWXQwSVJ4?=
 =?utf-8?B?L05QcDQxNjVNUlFVdmNJNFN0cElMc2I5aTVUOGhodDc0Q2J0dnozdGh1bXBW?=
 =?utf-8?B?dWFaVFU3VDQ5UE5nZEpZK1VUOUJWT2o5ZHNSaUdTWHZWRjAxYmRBYkJaZ1lX?=
 =?utf-8?B?RVN4RXRyUzdXMzliVTFoaFdLMzdDckVyQjZGeGxIQno1TEYrRm9OeG5EWldD?=
 =?utf-8?B?NktVeEdmNDdWRTFNN2FaQjlBWjZQcHNXT08weVpYRHJnZlR0V2E2THVSSnVK?=
 =?utf-8?B?WEx5NGFISGJ0VndzK2tDZkhKL3gvNmZOYzRGUHNmUXhKNXh4eWtLTmF1OE9T?=
 =?utf-8?B?YjQxNGZFMnhXSjZTRHJkY0dOM2lkSi8vbWk5b1V5K1RmejI0M1NlTjhEZnRL?=
 =?utf-8?B?ZGlxN2FIcmNkdWQ2YzJXTXpUVDBTaGh6ektCTzBBa09GeDRKVCtoeEpweXVR?=
 =?utf-8?B?eDVYdzhTbFYwRXVtcCtXRmpUeE5CUThPU2Z1U2gyUEFsOVVCOTZQWjhmdEdm?=
 =?utf-8?B?M2dSM2pEUXd0dDV0NVBCSVM3a1BCcWRmVTlsUDRvZ2xxeTZYTzRyQWhHUVpz?=
 =?utf-8?B?ZTZUcmpwdFZnSGFaQU1KRm5KQi85dmpnWGNYVytXZTZsTUYxMnlzM0Z6RW9a?=
 =?utf-8?B?QXdzbTROUlR0b2RCb00zd2ZLTVRBd1ZneVQwZHFkckVlcHg1WmJGZGw3Y2o1?=
 =?utf-8?B?NEd5T2JodnJuaGJ2blhxRmxkdVFiQ3g1UzRIck5qTGZ5VUtmeXAzUHVEOCtj?=
 =?utf-8?B?dWlCU0xtdEdPeVkvbGtwTWE0eHdaWXFnMVoyNmt2bUh6MURjbldjbkxVeVJJ?=
 =?utf-8?B?TDVrbHo1bm1kK0lEV3JGUXB4WnRPMk1YNlVESkMyT2JWWkcvQ1FjNlpnOWlt?=
 =?utf-8?B?YWxiVmxMNGtxRG1SUVhJa0VGNkRjMmpPZkFqalY5bElQRjBzWkRtNVVvZjBF?=
 =?utf-8?B?VjYwL2lTSmx5RUFrTjB2L21UNWZqUFA5WkNMT05wMEQ5cG43TFZDaTZSYk9P?=
 =?utf-8?B?d2VKK0xONXJoMU5rT1BIejI4eEpYa0c4bVgrbXFoSC9sc1VrK05uVG52K1pW?=
 =?utf-8?B?S05tTjRjQzZoM1hJT2x2R0JjM3AweVdqNWI0VDBwbXF6bDZ1akEreW9RZVJV?=
 =?utf-8?B?WDRIQ2NzcFpTWGFhR0c0UlpZai9tQXJBSm96cGRBZ2cwYzFLT2FZNG14TW9U?=
 =?utf-8?B?aFNISFJJNitiRVNJbStPSFV5WTc5SlFleWhNSGIzSy9leElsaVFsZW5VQTk1?=
 =?utf-8?B?S3BCQy9ZOHczVElra3U2UVMvME81SFozUmp0aFVobjV3SEQvenFnc2NFYjMw?=
 =?utf-8?B?bW9TOHZQQ1NLc2ZtbTlVS0VkUTRCTjNkcmo1QWhqQWRtcU10alhjVk1OeVpR?=
 =?utf-8?B?TTM0OGxNZHMyWVl5NzIyczBhSnN2amx4K2pFQkdybXIwRzlCTERhenJTczZZ?=
 =?utf-8?B?UnV0aWZubzhqWGZvTC9DQktQb1ZSTmw1Q1JYUFpvVXhVeXliNXhRcEI1c1FP?=
 =?utf-8?B?Q0EzbWt4czZ6NnpPeEo2OTFSdUZTd0VMWjVqSUkwQi9qWGMwZFUreU1ET2lm?=
 =?utf-8?B?REpKVldhRUZKcS9ZdVgyTTlqdFUxTEQwM0RKOW1OMnZvbEZCdWowQWF4STh1?=
 =?utf-8?B?bmJmUUhnSWlWZVB4VUFZU1hIaTJ4d2d4L2hGRHFWbkJMdE1qRkJ3NVVRdUl2?=
 =?utf-8?B?T2V4RWEzclluaklrZXg2SWlYdS9yckhYajJTaHNMc2I0U3JzL0xUdVpNV1gz?=
 =?utf-8?B?K3lVK1V2cmhENEZUaEtaVUh5dGdVZjJzSVpZQVdiLzRCeDhpSGpxZmdhVGhN?=
 =?utf-8?B?WFAzSkJSQUVIZXRkeCs5K3hrL0k3TGlZS1ppY2trY1ZmRWpWVUNOVGZxV05D?=
 =?utf-8?B?NXBUdnNMSVNkbHdMS1c2emJnNlhWQWJ2Q29nbVA4VHk5U2N2Mk4xOFB2TDRQ?=
 =?utf-8?B?NnVEVkN6eGZiWGZOaGNYa1hmeDVsYXoySjY1QzgwWGZWY00vT0c5SmxhRDFL?=
 =?utf-8?B?djFZY2MwamZIOFpqZGVUdnRoMnZpVmxNcmZGYzZtQnVPNTl2UzF1Zkk4WHJM?=
 =?utf-8?B?Tjg4K2VRbjJKejFSR1VTNm1LZ2lOeXhhQ1lPQjk2VWJseWsyVDJ6c1V1WDFr?=
 =?utf-8?B?WXh3OFRGUUUyVjNVcWpuZ0FKMEc1blBTQS9GKzlEYnk2QnlnWUEva1pyb0Rm?=
 =?utf-8?B?SUQyUXFVWnIyNVR2SjArZzZXV2liUkFyeWNCbWkvTkllY3UzSkxWRU5LeW03?=
 =?utf-8?Q?nvbTxOxL7j8fqxAs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b6357cd-3ba3-48a6-cd0d-08da52107d2e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2022 16:26:40.0457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 70oM4RloK3z29URO0VUdTIDfIwdURAuKgULqPm4MT0gTD8QlOV/L8Zbgn+NEp2BeEF+Sn6OpBVDsAbV8o9+3YX4/C2JLM9jrkrUkI+2Agsg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5302
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-19_08:2022-06-17,2022-06-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 phishscore=0 mlxlogscore=979 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206190080
X-Proofpoint-ORIG-GUID: VTbgHlbNlf1_cXznuk8jGi7xkbyWSD33
X-Proofpoint-GUID: VTbgHlbNlf1_cXznuk8jGi7xkbyWSD33
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/19/22 1:25 AM, Christoph Hellwig wrote:
> On Thu, Jun 16, 2022 at 10:04:37PM -0500, Mike Christie wrote:
>> If NDOB is set we don't have a buffer. We will then crash when trying to
>> access the t_data_sg. This has us allocate a page to use for the data
>> buffer that gets passed to vfs_iter_write.
> 
> But only due to the last patch, so this should be reordered before
> that.

I didn't get that part. You can hit this bug with what is upstream right
now. You don't need patch 4.

> 
> I also think this should just use ZERO_PAGE() or even better switch to
> FALLOC_FL_ZERO_RANGE as a first pass.
> 

Ok.
