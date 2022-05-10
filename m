Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC9F5C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 10 May 2022 19:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbiEJTiQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 May 2022 15:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiEJTiO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2022 15:38:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A25E21B15C;
        Tue, 10 May 2022 12:38:12 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AHpiDV024511;
        Tue, 10 May 2022 19:38:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=1YUck7CC76QmAA8KlBzrE4W6+Wg2Lc71ha49Y9hQVw0=;
 b=kVvyo9TUl/M4nUbKVLeB21SXVxgvhlzhr5kK3XKgg0fm2hxKHZEDpWhwIDEE2B3A60II
 GH8K6ZodBf0osjiUzJHF9RnfomzYSlAXRYT/y8GylcqXlRdlVEXPprkCpNflAv6KPKVW
 OxkILqA549srz1MHDwFnIAVF5hPDNBJSzaEFqt/U0pJdWDPYjPKMr/oVNFEG4AUIcDwl
 cnB1+YS+oOVmHRriNZlsGXj9WTLXegqSQgzP9vxZTUoSTYjlJU2U9mbLbdqlzleGuxz+
 2s4OsioB470p5hOiJdKR+qK/CEIVu6s9NRqECuCvaosEKnqWvDdCJbXmCFPzLlIXVRy2 /Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwfj2ftv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 19:38:11 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24AJVONg012586;
        Tue, 10 May 2022 19:38:10 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf72q8u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 19:38:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RoOReMnhLBe3fBDMe3lXZ1CMjsdeag87uJ8ygSGVd3pak4543Z4GJ7rtFvh9PtejgtXevi3OTp+riLMvVrNZxuR/aT+pZ5bkGQ5gzf99bI8xvNnGwsVrxtnIAGbkU4FhsHfDnxVsgCbxVqyhi+XVfVdt1M3DZ3FgZvQUvyPUK/yEJ7ZnLqKdYOh2o/2OHiS8fAnorwqWVboqCmKR7SNaLRVEbDBHMyyiJfc63nHzjEScDWQazxGjI00n8RgqFpwmm+lX9jP/I1qdDF/HDxvI1P27AOb9+5Ylpum12OXpFevjt+eOgWZ96gqbDKJla1jqYapbzgNZts/NKekdpmBWqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1YUck7CC76QmAA8KlBzrE4W6+Wg2Lc71ha49Y9hQVw0=;
 b=mpmhXYuQFr/Fm1DAsKGKA8u2V8e5yMZ2JMxrmPaKS0gqMVtRZ5Y+9JCEbVN254W9axg+BOFw7JdZAme1aYt4ClJMjXew2C726yGluB5xqJ23bvlzNbcutQ94R6Inac6n7Svg7tmPEPiU8r8DdWMpN2hK2+N5C88EnWsTZ+5AHMrTxAIQvm0g8QIfjrVAGkvX/ONzNQzdeZXFRvACQy4RjolX9/JIwPR9Qddlp4Kc5My0e92w1H/JOXCsNdkYwLPh0SwAWrpYmrgrqJKCWwqBGW/QUvQQTs42gt5GtksmC1r9rZ32qWhFki4AZNmmdJB6SAtW2TgEqNSd8mavm3HtxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1YUck7CC76QmAA8KlBzrE4W6+Wg2Lc71ha49Y9hQVw0=;
 b=rW69sBapP1ycliPJ/t3jqOMjN0M924t7UNaySx8FEYauhb51rS5zen2K8XqMBpXePvUwDRTIHScvWfJ4eQvhRZu1O0X1BK0TjQbBygpag+FiWiIMJjtNdJ9SObjq9wcTIq8p7/Jkrn98Xp9Y6Pio+R8iedK6JsBis+l6c4OnTOY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BL0PR10MB2802.namprd10.prod.outlook.com (2603:10b6:208:33::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.21; Tue, 10 May 2022 19:38:08 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 19:38:08 +0000
Message-ID: <13b31988-766c-14ef-ccda-e04290af9400@oracle.com>
Date:   Tue, 10 May 2022 14:38:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3 0/3] target: iscsi: control authentication per ACL
Content-Language: en-US
To:     Dmitriy Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>
References: <20211019071843.14890-1-d.bogdanov@yadro.com>
 <ec9e01a3-73d0-a06b-8c20-ae492c0c3313@oracle.com>
 <15af5f6f490a42c5a02c9d9bd79f1a28@yadro.com>
 <bd9e50adcc95404c94b4408117a94b0a@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <bd9e50adcc95404c94b4408117a94b0a@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0345.namprd03.prod.outlook.com
 (2603:10b6:8:55::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ff2d3a1-f6f0-4a63-b8fc-08da32bc9c35
X-MS-TrafficTypeDiagnostic: BL0PR10MB2802:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB2802B1BA2E312A69DA2C182CF1C99@BL0PR10MB2802.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iQ6V9M5h9XwKNhnWPSkjxjUq6yvOHMBWAvtdec9Rqdj94VAZOon02UBevzhMHjQnbYriPLNHg0msI8ULgiA6NabXFqYFMWLCquV1PrnRFjtIb5BTLrGWn8NR4ocu4/KMuLfUeL5qOfJrLrr0cfBhz0oblPWmxiWVU8VVK1Y6wgnFmOwoOQfPJj5pGofatrf0WCmBaVCo0z3tXCzg488cJfNk/GNn4vE1SJI/oxJMoMCQzvIyGBZr87e7l6Ta51vm8fNcOooL/d2tQMOJ7mzI8SwbCAx3e0fTPEiYeSA6UFCadTERQTQXT6uYXJyGWUey9F7nIxGk3FY/Q/ejNEFB6ZfDnX1AamuhVeQ2GKKv/nu7MtQKX/BpmE289mYXd0l+43L8U+HhMZSijQTiaPrS6bp8rsDBdnOtrUzFmmIZKRO2t8fQL0DDzZLjDFWoRVmbD+0l7Crzj3U7d4HQrrYwH7rvFJSKIA10BTRHfZJgM9CRvimHJgKGoj5fikKHoQ1rUluyqeQ8p/EoJX6euAmhggLHT8SyiSN75EtUgEGNYVmyjALtqgsiF/dMfRay/6ub0cmuK3S8PjVbI5d2m41FdpElv7mJe/Q3KAN450dP+5tA03aNRwZk0ZTWU+amEu3cNQEHx9y6xiJpM6wmkNajHhkOANWDo5v1X4ZcXqcwa3j+uOYr1ynBc8TTCgqCGzhzGaS8qgwkMsmjKAGoC+v8kMz1azQDy5QHotgEhk5Bdzo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(110136005)(4326008)(8676002)(31696002)(86362001)(66556008)(83380400001)(66946007)(66476007)(508600001)(6486002)(54906003)(316002)(38100700002)(186003)(6506007)(53546011)(26005)(2616005)(5660300002)(31686004)(6512007)(36756003)(8936002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cEhRRkdVajAva0U5ekpZNVJnYmVJV2RweUZ3Y1RqenQvRG1nNm5wd1g3aERM?=
 =?utf-8?B?anR2VkdwTEI1aWpzNERBSmE4RURBa1dsYWoySGhkbG5pYldqTDBTbnVtaWUz?=
 =?utf-8?B?eTFXNk0zb3lTcWxIdHdaVHRhZFhSaWI2RlpWblZuWU9MNTRtOFdVOUpUendx?=
 =?utf-8?B?cUZHZ3hnRFlqOUM5Ulc2YlVtV0hHWitwRHIvM3d4SktvUlBRNXJHUkU2NUxC?=
 =?utf-8?B?aXRRSXBtVjMxVzBLL1VxRjI2ZytSazhLcjdzSy9MWWhNMVRLT3kwV3gxRzdt?=
 =?utf-8?B?Vlh4alZSelVCTlZWQUE3OFR1aU80ZDFWeWxpOE85MXYzbUxsWldJbzVYSHNK?=
 =?utf-8?B?R1p4ZDJLbWtINEp0dnNiUHh1V0I1dURiM3VhZzNzRlN1blJJVVY0dGg2bEJj?=
 =?utf-8?B?cGEyRkkwS1d6YUFnUUIyUlRteUJnQ2J5VHR1WnlJVVd3dDBNK21tTVdUNjF6?=
 =?utf-8?B?WHd1RE5GOWpDQThvbnBtSGZscFF4b0xHZTNGYTRORXRZYWM0d29jYXpQcVpo?=
 =?utf-8?B?ZFdHRUEzalBrdG9aeVlTRzNFVTdQKzdLMm5VWkVUUkZpT2U5bzAwdWpVd3N6?=
 =?utf-8?B?T2Q3bjVBWEF2UURlbzJocytoRm5rOTNWQ2R0RUlGa2xQNjhEei9PZWxKblBn?=
 =?utf-8?B?T3FlQW93VWJ3ZVBLVENRNkV6cmo0M05Ta2lKNHZRYWh3YWhoYUUwYTNpNHla?=
 =?utf-8?B?OWRzQ084YjZkK1JnWEMzUG9mVmdXOXlNcndGR2RuZ3ZzcEoxcDBJVk9jVElO?=
 =?utf-8?B?ZHFwQ05uRlN4Z1Q5NWI4NjdOWTc5V0Q0emJWS1lQc3NoMjZMQVJQR3dQOE1n?=
 =?utf-8?B?aHRTMUhzbjVybGttS3JkMXVpODhFem5KNnFPRm04blhyQkhZbEU3MDJTYVR4?=
 =?utf-8?B?QzBkUDNYY1FER0djTUNOU1RKSlVvZTZIemg1aXBjTVZINnRDZE44dFp5d2ZE?=
 =?utf-8?B?Z1JodTBHTWlxUURLZlR6MGQ1eDR0ajVGRm1xa3V3c1pldE04NkhhQ0dUTmZh?=
 =?utf-8?B?VkpidjEyYWRJMkM2V012MjRVeVRNa0UyYk9FRmJLQ2x4RnBETkl1N1FTMnpk?=
 =?utf-8?B?U0xOOE5vRlVXSVdJOThCdTFiQjJacDVwbEQ3OHdNL21HbXgyYlZPZTcwdG9P?=
 =?utf-8?B?ZkdiQXRmeFJYVVQrQmlzcXljelhTYVlBdlhOc3k4TEZQYW9OcWdkYW94MU9X?=
 =?utf-8?B?SE5vcWhMZXByMTZMWEJhcU5QSlcyLzBrWTRYZXp6NTNFU3BOOW9HYVNZbTlD?=
 =?utf-8?B?QiszWXppZ2hwWUdXWVcySVZ2TWpVZVAxaDJ0MmZpZE13Tk5kbllDTEJuM0Nx?=
 =?utf-8?B?WE9aZnhxN0hIYTZhVnBGME9XZVFXODJWR2orZnFPbDVQNGRtcmNVb3pXN0dW?=
 =?utf-8?B?NElaSURoUk9NWWhWQVRJa0dZeXY5UG5NQWhIMHpVaGFrcGNYYUlMRlZIWkoy?=
 =?utf-8?B?bmNsUUFZUkJjdHFjbG9mVDJEb2Q2cUhNVmFrMm53clZwMW9jdjFlVlVsaXlW?=
 =?utf-8?B?dmM2VlZnUVBSU0Vic1JjOG9zNHRvNTlhZThaUjB4OVlaQXd1clNhOUw4aVZ2?=
 =?utf-8?B?dW80MlN5YmRBY2NMSkZpVFlYWWRQYmRSd2M1enhIY0xldCtJWnVJbUZHK2RO?=
 =?utf-8?B?TkJRSENxZkFJWU1kUWRiMkNqTHFKUXhZTEFYUzR4eVlaM29SdkZSZVJuRTFF?=
 =?utf-8?B?alIxYzU3byt0ay9HOUp3WjczdWU1c2pUc3BXMUhvWU9HclNHZGZqU3h1bW5Q?=
 =?utf-8?B?VVk5RnB1OXliVjFoVm84UVd1V205SW5CaHNxRGRUWmYvdTJPaTR1ekQ1WWhu?=
 =?utf-8?B?dWhoTWdtQ0FQR1RjTXNWWW5jMGNnZnJMV1N5MWpEN2pnbE9zdVpwMFJJU1lR?=
 =?utf-8?B?NlpPSWszVzU5VWoyWVRsQUtBME9ycW12eXl0US9nNkRwZ2d0WDJTZ3cybk9t?=
 =?utf-8?B?d1g0Z3hsdlJ2VDBxWUQ2NFVmamlUclhPWTFzUmtDckJIMW5hSkVZTm16ZzlW?=
 =?utf-8?B?Wm9IdHNld2lpK2xjdVJzVHZvVTJSU3Z0Z1RXZVhPNmZLZTR3V2JLeHBXZWpz?=
 =?utf-8?B?dDJ3anlXS3NnaVU1akh4SjhZTGt1WCt5STVPelJqbXdXV0U1Yi9ETHhrUUNn?=
 =?utf-8?B?V09oMkE5U0RPM25nUFZNdmJZaTBITE9ERlRQTnN4ZEZEMnhTTjRZczF3WEtT?=
 =?utf-8?B?RnRmMERFVmpCQjJRUWgxWmNxY3NJVExhZWRhL2xEUW9JeEkrT0gyVTc0ckVx?=
 =?utf-8?B?N29tSkNQUnhzVTBldGpUZ3JVZ3VKQ1VDeTcxSUg2Y1dnVzFRVDBET0Y3bWdj?=
 =?utf-8?B?WE1ZRitjSEphTDBVSEtYRllrckxkb2xSS2djV2xIVjhXa0VZMUhLa0o4Z3Jm?=
 =?utf-8?Q?d73tv9oGLcx0k9VQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ff2d3a1-f6f0-4a63-b8fc-08da32bc9c35
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 19:38:08.4540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /SJeRUisIlT1Kknrs05Z4XHBAriYcTVfX4Ui8elCovsS6Lx9h6pAOcz7MetN/Hn7oow4/NeYvx67dwPbBBR508UcRJAoPNkTpZ2ak9tClz4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2802
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-10_06:2022-05-09,2022-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100082
X-Proofpoint-ORIG-GUID: 6Yue_92emgZjrI5yqSvkuWmIpOIKkEfL
X-Proofpoint-GUID: 6Yue_92emgZjrI5yqSvkuWmIpOIKkEfL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/22 1:02 PM, Dmitriy Bogdanov wrote:
> Hi Mike,
> 
> I've just tried one more time to reproduce your error and I failed again.
> With your config file the behavior is the absolutely the same for both cases with my patchset and without my patchset: 
> * for dynamic ACLs - target fails the login and shows the bellow logs.
> * for the registered ACL - target succeeds the login.
> 
> Could you, please, re-check the patchset?

Sorry I missed your reply at the bottom and sorry I messed up
somewhere while testing the patches. I can't replicate the issue
I thought I hit and yeah I agree the config file I attached in
the last mail didn't make sense.

The patches look ok, but you need to rebase them.


> 
> BR,
>  Dmitry
> 
> -----Original Message-----
> From: Dmitriy Bogdanov <d.bogdanov@yadro.com> 
> Sent: Friday, October 22, 2021 10:48 AM
> To: Mike Christie <michael.christie@oracle.com>; Martin Petersen <martin.petersen@oracle.com>; target-devel@vger.kernel.org
> Cc: linux-scsi@vger.kernel.org; linux@yadro.com
> Subject: RE: [PATCH v3 0/3] target: iscsi: control authentication per ACL
> 
> Hi Mike,
> 
>> I can't seem to get the patches working with the targetcli config file below It worked ok before the patches.
>>
>> I get this error:
>>
>> Oct 22 00:56:25 ol4 kernel: CHAP user or password not set for Initiator ACL
>> Oct 22 00:56:25 ol4 kernel: Security negotiation failed.
>> Oct 22 00:56:25 ol4 kernel: iSCSI Login negotiation failed.
> 
> This kind of error is reported for the unknown (dynamic) ACL since the config file have not have
> userid/password configured for TPG. Your config file looks strange - it has generate_dyn_acls=1
> but has not credentials for dynamic acls.
> 
> Login from the configured ACL in this config file works well for me.
> 
> Could you, please, describe more details of your usecase?
> 
> BR,
>  Dmitry

