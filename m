Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD0DC001DC
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Jul 2023 17:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjGVRLL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Jul 2023 13:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjGVRLJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Jul 2023 13:11:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E8B19BF
        for <linux-scsi@vger.kernel.org>; Sat, 22 Jul 2023 10:11:08 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36M2s5kG015115;
        Sat, 22 Jul 2023 17:11:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=RXiZfwv4s5nJ17/yF4gdDrs2Ap2APsOPEpUbvQQdBZg=;
 b=SwjSrLPyFjYWSd6EZrAfNYy377Y8nRsP7ixI/iEyF2+6kx9MKiBD6CLfWiuFS5AOgV+M
 DsdZoYYHgy/G+ZgGGrgaJ+0eRcdW5git8NRNmOWsYBFE8dSnMmq1WaSOjiX/AY6dVI9+
 j5Az9PoJglrwxnlzVvaqUzsTfe39sLbwY8RCBbOeoSVBoSPJR7SVXfu9Uc8z9pgp18ku
 toP/dvCY9hawX/6CLHB4RnB6yT5klFpVWZoXiBUF1zxI4KGiP/SDTufIsrYa0anDvnoA
 aOPRcD5oH+oZWmD19y9E5+c9pJWkmvDAqe8qrnptE68woxUMXeDWCsdEmYWTH9GJcG0I 7w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s06qtrj73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Jul 2023 17:11:00 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36MDum0t003821;
        Sat, 22 Jul 2023 17:10:59 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j1ykd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Jul 2023 17:10:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kFJuOBaAtg0K1HBqaQR4jdz0BjAfIwlrC+SILAhvSiinBFkuOCFZWY+JGIzHL7szUp6j0bm8lBhtCWGTIy8NgVGkiV8TVocfh60LKcXc9ObfCE+Wp5rVJOSs7tn9Z7WsIOT3W30pXVsg40JHqItVkqc/hmAoPYfxXw5puGYhzXfxKL/khPQuKhaL7gWnmoia743lSIRgsUHpQvFs8kx70wB/4Zaox9L2WmPmC2fQ23kA6GTCYUvMfFHE4fU8P5c02GGLUnykY9XF9B9rMw4XEALxO60ASIL+eWlrJkjmdxva/J6bPqGz837KhZT2X7iCKGKC+8MepW4xlSZ6XrB0ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RXiZfwv4s5nJ17/yF4gdDrs2Ap2APsOPEpUbvQQdBZg=;
 b=A3RRMVnjNvZfgJuDPl2eNiuwlT34rjiL5XKMjhP7JA5UERi93JNGTboqGI2NcY6rkBXqj7OaisJ6jD+6uPCE2ZlOhmAsSR1Jfgx+t0EitI82ODSZYMrmzV9f/HFKT36zniHBkD8HcwEXai/76OabOFirPIK1q6q9PAfjhycPNrc7BWOJupImUKQOigOots/kEFMK69Xc9tfHVxKZsrdjiti53Z4X1N+Lh7szZeWItooUO/ktJemVUc6nfP7ZSN1+BDlWbTQXJedytmir6wFVleVt2Av2pkjUH376dtHqmuYUeoSJR8ZnpogUk7fg1kq+6phCv5p4G5OkP4z8mnFRTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RXiZfwv4s5nJ17/yF4gdDrs2Ap2APsOPEpUbvQQdBZg=;
 b=O7ZRsS1UrD1c9NAIN2djSmt4Yne2I2EvOlB3Pz3X+0VIvYIJxn6YANQUUvheAQDE//KtXlOSL8C/lPDMIX1rbOntnnvtuvdXrEGOqCILcd1UWa/gVAZWZT3aC7b6Huf+4G5hJiJzI+Y82At4yD6vZtx1YbQf39aaMUSsinKw8Gc=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by PH0PR10MB4805.namprd10.prod.outlook.com (2603:10b6:510:3b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28; Sat, 22 Jul
 2023 17:10:57 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.031; Sat, 22 Jul 2023
 17:10:56 +0000
Message-ID: <e593026d-f803-ebcd-f9dc-3b2758432817@oracle.com>
Date:   Sat, 22 Jul 2023 12:10:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 13/33] scsi: rdac: Fix sshdr use
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-14-michael.christie@oracle.com>
 <f0822be9-c4be-5e3a-c260-2a97999a0e3d@oracle.com>
 <aef4186b-fde1-cf3f-c491-f2747f08f426@oracle.com>
 <e4b26cdb-9ef8-1633-86c6-81f2aa270d69@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <e4b26cdb-9ef8-1633-86c6-81f2aa270d69@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR03CA0099.namprd03.prod.outlook.com
 (2603:10b6:5:333::32) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|PH0PR10MB4805:EE_
X-MS-Office365-Filtering-Correlation-Id: e9a0f6e0-346d-4703-f09c-08db8ad69cef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zX2jCgDZVpET++hMFtBDTYBciQD/Z5mpu20osz7rNy5iXyBmma6av9VVOg4NHR/rceipwy6A1FqsJe3q6R+QwDnnHqgMFNrIetVKOREgze8tF8Wy+bl70+RQXE1j3+Yn/AJ90jRmMIpSUThmfGmXFJ3EoTR5gYnYnJkM5v2PoSO0HMZv7KME2YqTLf3JbUXmHdYzCvgprjeSjvN1J28eZHIibtADmAxUh6UHaAwfOgBGrLiqQsC7mihpU+bvLV7eUTZH7hoRSzWOwbNaSympiOcRBGQlhwMpoVVroG7lJxuZz1kj4tQjiCQe3gtXDpoAikYM/SpYYJAzUpblGqWTw6yi5HvvAQkJvim/wgz2Zde7hE9NpmNDGboN9ss18zRjkYN1svBLzSobh+NHleDqmSoKZCf55dJcqdLrQ4qU9j8IlY7LcLOGk//bJWBq45su1mUyNSgkhajo/avE9lZfKEBnftt3VeJAJuLXy9VX0h2nu8d/57I2qFYZIpWq79utO9J+Sfc9pGjjEs9+Wr/J3o8oAhzaog19Xsan7p6zb5jTiTqYnMQBWbsBtwk0IxldlHHwEc9B790o/hpNlhP8m0ozzbGLpCWmLFIzhphRVoYgFI2M769nV6kpB2v/QnbyzCam3T2whApCXdzsnnkQOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199021)(38100700002)(86362001)(31686004)(31696002)(66946007)(8936002)(5660300002)(316002)(2906002)(66556008)(66476007)(8676002)(478600001)(6486002)(6512007)(41300700001)(36756003)(2616005)(53546011)(26005)(186003)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjNvTzY1dG1NTlFvU2poUk9CVk1heElmTitibjZZWWVuNURLTnBpWDBDc3JR?=
 =?utf-8?B?L1crQlVILzFQVmRXQ2FWeDhRSXgrb3o1NFhiK2pHWEtJa2lpY1BPSExocENX?=
 =?utf-8?B?UjdmTnVjVjBFaklsU2RKSnVtc2RBc0g3ckNpNWx3TmVJaUpwTEhsWDdrVFkr?=
 =?utf-8?B?Um43ZnNhZ0xnQXFlTkxDRjJpSzhuRzMvbGI4NjlidkFsL1BZUmNOS1JReGIx?=
 =?utf-8?B?NW1idmpXeC8xTGNFenFwK3g0Zm1ZUjFFRE5ZMTU3bGNTQ2U0cUVtaGZVYVVl?=
 =?utf-8?B?OWlMYnB2K0JFRm5YaUxMV0NpQk8xYlM2WjQ5aXhac1VXVWJqZG14b0g4Y3FE?=
 =?utf-8?B?b0NPRnh5VGE5ZVllYTBVNlVGMFFzVFpuVDlLWi9tVldPUWdwWFk0R3dSd3Uy?=
 =?utf-8?B?M0hnUDdmZHQ1Vm9NdHM4b09NV3Y3T0EvM1NwV2x0aXVwaUsvNm5KR1p6UXFJ?=
 =?utf-8?B?UTVocmJJWWdMeW9RYnBDdGR6OEFKOTJYa0xaUUtXS2RheXlEcnVVL29lcGJT?=
 =?utf-8?B?TVNJRG1wSmxDM09BQ3JLdW56QjlPcjhxMU5ZYzZ1ZDlaN2pCdzhjREpHSVRq?=
 =?utf-8?B?Y0kxNjN6MUU2NDJPTmQvczFsTlU1WFBuVW9OYlRNY0Q1OXBwV2NZOGxRbmpa?=
 =?utf-8?B?T1phQTdmQVNscEhUTVlhSXVhUGU0RUIrbGhxdFRSczVQK0crZ09jUEZGWlY0?=
 =?utf-8?B?Q1orTHBVMmhsa2tEWFBDeHNLaFFEZEZLS3pmWW1JZWwxZW1hUERsS3Yzc2xM?=
 =?utf-8?B?SG9zWDZMQnhkeE1PS2JhczJhVTQzdkVWM1pRQmVNYzRxYi9tSjIyNDNraWs1?=
 =?utf-8?B?SU9iVW5GdGpIUUw2SEZQRXdaYW54L2kyeXZPRlJidVJzeFFwRjJ4K0JkeG82?=
 =?utf-8?B?VFdsSFF2NFZoMVJORkdGYXl3V2phL1ErMkxPZWVpZC9yS0wxbjVlRys1cGtk?=
 =?utf-8?B?cXA2RTRhL015Uk5BSTFxMWt3RUJzbkNkbzNJK2o0UUZUV0FhMDczdllaZW9C?=
 =?utf-8?B?ZmJrU1FiNnpsbFNQVE9sbGZISFcxSHhiaUJlZkQvc2luUjBRZzdrQlZDaUQz?=
 =?utf-8?B?aUtrUXBxWE5PNFBUNWUrbi82RmFjOStzUENRRFUwYkRNM3ZxeTNEcXh3L1Y3?=
 =?utf-8?B?TUVFZy94K3IvU1FYTFBxWlpRZm1KVWZOSzdxOXhTb2h4N0pjVEtVNlhud3kw?=
 =?utf-8?B?akpZOVhKN0NHM0VWOTNwdTVaVm1WYXFyZ0plNWNZSE40Qk9vT2VnOHBjeSsx?=
 =?utf-8?B?TGdEOUFYbE1pM21xTCtBMFNtckhyVHBiNjYwK3M5Vy8rajNUYVpTTkFKRXZE?=
 =?utf-8?B?ektoWUhocFBpYXpOMnN1cjVlSEUrVGcrWTArZFQwVGxiUWxWYjBFUU1JdXk0?=
 =?utf-8?B?bDJGZFp5WkNxNFd4dE15K1owblpETzRueTVtM20rbU9KT0NlcU5LQ0VETHpw?=
 =?utf-8?B?eENWSEJzNXdyYTVyTDJHSWFVSDlQVzJUTkE4RHc2UU50dzBxQjdUVTdrdDNQ?=
 =?utf-8?B?OHVKYnhjZWxvZitwTnpaV1NmYWRTcTlhRm5DUHd6WHBubEc4Z0x0NjNDVlB6?=
 =?utf-8?B?VEFUNkpLY2tpOVcxY3R0Nmk5ZnU3VHpCcC9VUkJ6Q3ZpRGJSbXFxMTVYTzEr?=
 =?utf-8?B?bmlyakVhWEViRVFsY3RoVGxsTHRIVmJtcERSZU1nRmVTZWZ0L2VsVFl2c0dG?=
 =?utf-8?B?WFllY2dJVlE4OW1QNDltM3BvRlplWVdpNElGYVZzYXN6eWY4OW9veVg3YWtF?=
 =?utf-8?B?aUhwcjNJVHRWSlRtZ2Z3bXhJZTdSbkpDYkQ2WEdVWW4rb0RSd0xZdUhHU2I1?=
 =?utf-8?B?dnFWRHJkck45SmJpQklvbkt0YXY2OWlJa3YwMzZZejBKRlExQncvWk5qT3ly?=
 =?utf-8?B?SDlTWXVHdExEZ0Q4bjBGMXcrQ1Q3Z1pvR0k4RHVBR0ErS0l6OXhvaEJ4cFRo?=
 =?utf-8?B?dFNWK1Vjamo4R1JOQXZVcjByaHg4aUJSNkhrWG9uS1FiQ1pYVlIwcGc3WUxQ?=
 =?utf-8?B?Vk9RYTJoMGhLQ3JLNU1rUEd3dm9rOXJrNDU3S0hRZ2V6RU4vUVh5K2xMaGFE?=
 =?utf-8?B?Tis3VHlRQ2VTWmZrdWVaWmthb041THpqeUZjQXFEMUdsZXFvM29xd3l5anFN?=
 =?utf-8?B?ZzB3UklIT3JPMGdqVHZUNVRzRnFVSGVSU25rbHJ4cVJTZzBTVW5zZHZkblRF?=
 =?utf-8?B?cWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Hkx953rscWw4z9twApzevykK9nxbV00f3MvZGANdOY487KjHj9fvQGn3QQBJ6b3dWixOFOxdMIIAfK39EjSOtL5Roys/5L+jCKtznKgXIJw5Ibk3UAWjiJZS4Sf5DT0PDYfEiDkCiy9XGC/VEp3/P/BxuH6tW0UQnVid1R4LXT+fBjeD2rlldTKLd80BKzfj93NaNFzgMC7S7fl48Xndldqw0UhMDuiZja6LZa3RYRYGE15aUNhZuaUdT0BFwnwI1Ln8CM9DEE1GOiqQcdDzqmrlEWz9MZh+Itz/obH/bRAs8yySAoF9aHscmumaPOGXUz0VQx7WHuigyUnUgU7mI9o2Fnvq7V1Oc//T1RWV9HHanL5gv+RCE7W9IUPRwQoqP27h2uRx653dQqhl6PMmDkQ57qNj8HxnBAO6WGHysyY/bCx8azypJ55Ss5+MRTNvAhRfx8iAffKQD+clk/EJIkhvw64nXNYeGseI/oTFVTa1D7WvcJvU2DAM1U/iA5ZYOpOty3ZQQ2D7qY7R84EPthaA8WjoqSi0ls4xBnq6Y+Gii5n+8jvSl8IREW83i/Z18meq6QB/YUY5UQrGHtT+cLb8ZeiVT4cEFbTHi5WVfT5Jn4zgFKFrMoqmwPyBquA2DME0fh+Dk+PZ352kTjv22ATvQ9hGvntgVoFuL8unp3NNTshUOn5uHICqsOEtQUDgpBFIwmlAA0oaZygBdWoC2l3BRw1NhqxYfBqrnt61lPhBB4EP400AaWp54UjSSFZPL1bAk8hHqjwmTmuY6uDzbR85DMkd+7PzJTdeY35TYm81/3hsyX1NTljvTyMLjrTfuOAc4CgMKgrNsDPbNcASeyvanORfTE2tz/JlrFVLeBLq47yHtJ9De7a2MlUitZY6
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9a0f6e0-346d-4703-f09c-08db8ad69cef
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2023 17:10:56.6423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UTE07YtQImd8cXnRqt8wWP8env9G2RxqPL8ywsgNlqCariMCbgOgYjmrJSw6Ql9EtJMX6P/Qitv7gDVhc2MGEpEsYVJTj87dEw9dZ6KNVKg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4805
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-22_07,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307220157
X-Proofpoint-ORIG-GUID: vYjqHQc-EWhGaLaJ80sLe2ZeABAm3GjJ
X-Proofpoint-GUID: vYjqHQc-EWhGaLaJ80sLe2ZeABAm3GjJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/19/23 9:44 AM, John Garry wrote:
> On 18/07/2023 16:31, Mike Christie wrote:
> 
> Hi Mike,
> 
>>>> +
>>>>        if (err == SCSI_DH_OK) {
>>> As I see, err is initially set to SCSI_DH_OK when declared. Then if we need to retry and 2nd call to scsi_execute_cmd() passes, such that rc == 0, then err still holds the old value. This seems same as pre-existing behaviour - is this proper?
>> I guess this has been working by accident.
>>
>> When that happens we end up returning one of the retryable error codes
>> to dm-multipath. It will then recall us, and before we re-run this
>> function we will run check_ownership and see that the last call worked.
>>
> 
> I'd suggest that we fix this up as a prep patch, if you don't mind.
> 
Do you mean just change the description of this patch to reflect it fixes the
second bug? It already is a prep patch. The second rdac patch is built over it.
stable can take the sshdr fix patches without the API change ones if they want.

I just put the sshdr one next to the API change one, so reviewers wouldn't
have to jump back and forth between the front and back of the patchset.

Do you mean move all the sshd hdr patches to a separate patchset?
