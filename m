Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C4CBE8FDC2
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 01:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbjJDBFm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 21:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbjJDBFl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 21:05:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A86AB
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 18:05:38 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 393I52OJ019594;
        Wed, 4 Oct 2023 01:05:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=XoIrNDjtJPzioL95GR+PcmapTepgK4kpRb1l1LnwRBE=;
 b=Z4AJ1HlC6Z8IRRXyYhEZp5q1Ya5fpZ1NZuRQLijpx3lpcvrvw72/eNge8p/8TmKaVKXs
 YPR/XPG2JNcYTfLuS7PLq1od52nWi02OQ054gLN3JvDoSA1lLHNrTD7QkQcWoHXOt/fO
 R7our4LIotm8H5VyIUaGb50rbnaDwcKKFDjbEvLaKZ8Mm08Zd5VPtlQe5LK0tjMpSwzz
 jgZ/zm+5GDJo7Gug32DeB3fmX+V8g4iqsbbbOkV4jfnJ0/5px4TPsi8qLk5NX3nWYJ27
 1AqYbOPJKE2yXZMpy7b7IYr8qYYOltOzs0cDfKfDsm6XRSQThV5K5jsY11znpyLZVoGk 0Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tebjbwx93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 01:05:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 393MU0fX025820;
        Wed, 4 Oct 2023 01:05:30 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2042.outbound.protection.outlook.com [104.47.51.42])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tea4d8r3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 01:05:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UGdGHjxKmuC9BPm+b/CmgLZ6d7KaIAVSFWLaUKILLgvA/eA/nJ8H967ZIR5rvABiTIxc6yZkrcrLUVUXL/pD2tuIi3wU4s0basB/9Sa1z7b27i4N7dpjoNWKhN3BJ4joGCPTVniEFGf0WQCd1kdOznZg2vajY0yghP37XDaCvqKUW90PMeza4wsIUF4N/K0q5++4m4hK6GCBOxUW1Ery+MCwr4KN7fSb+b4cfOVR2LDp2ujhP0MzcWr+/304MWlLzmb+Y7photEx5IAAh2L11bvpig6DfXkHl3tpPuKPRBobw1WmwrISc9YRknEv3f1nGO1ygrSWnvmnUgIZg8yUOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XoIrNDjtJPzioL95GR+PcmapTepgK4kpRb1l1LnwRBE=;
 b=kt+GAk130v4iBMv3q+Vs06e9oim0BH97wwSzqPbYPdO/MkWp50uBCn6J36SWdSUgWBbTEvQ2QHOT27ui2k48mRuIxQIkhwEQaMZlW7UkcQ5Jug1A+njbYYRq9sUY+6gpC7/GbbU6iviFt23kY7VfbWzgOGOWGpxHfTS0lhvHCVKrRLJ3gK9jnpTkcrSFP99QRxinMqEHg99lPzV3SrRyD1F3jvvNnxLHzmnPekaYhZlDmvYTafN1diflhMmR23om8m2GwInilgf1ddWd9cqjhp3RNHwF9bQSK/0xo24C6jOvSCU2pekRsGDD+gFqY2zDQTHlHKtKtjQ96v3znOO8jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoIrNDjtJPzioL95GR+PcmapTepgK4kpRb1l1LnwRBE=;
 b=UiCPY23/qf05otTYM4FKHIt+pLTE9bb3dc3Xo6B6UAhCvokLS3ZZhVsPBT3g7UPd58UDStAHSaQIn2wFES4N5bpjEuT4HvjmCsN7ltGJkw9K2nuLPgC6kcZzhVrCr/NTnrwhisMf/R4OViwCQvD5wwMXUIy17g4/5Nnjx8Vb2/w=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DS0PR10MB7204.namprd10.prod.outlook.com (2603:10b6:8:f3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.34; Wed, 4 Oct
 2023 01:05:29 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Wed, 4 Oct 2023
 01:05:29 +0000
Message-ID: <b2d4a530-457f-131e-0319-369639627b65@oracle.com>
Date:   Tue, 3 Oct 2023 20:05:26 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH 00/12] scsi: sshdr and retry fixes
From:   michael.christie@oracle.com
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20231003205054.84507-1-michael.christie@oracle.com>
Content-Language: en-US
In-Reply-To: <20231003205054.84507-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR07CA0019.namprd07.prod.outlook.com
 (2603:10b6:5:3af::7) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DS0PR10MB7204:EE_
X-MS-Office365-Filtering-Correlation-Id: 97b56006-01f3-4fcb-6f26-08dbc4760006
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5GE9sAGoIu1lVsP4njqYnTT0IEJ5ugHhVR6V5irdxCFHioYd3FOU3IgsWQyX/q3FtRYTCovuhpzcjgWr3/4E76N9iL++YfCEk62Y0bH1vkKvMDtWqsp7qDp2GdyiF3T2AKJ/vSSOJbGwUbUf8tmyuX7r3OTnbfncXzMeDtogot3JQrTQ1xNHORxxwqgWiE0oM3DTex5BKEAG1ktBJJ+s9N5KBslTNlV+aHnX9S3gZful9Fgk0gjDRHfSETfI0vTNYWacZaULORbydztcBBS2MvYE6fXz+9WCo14rSLCSIvKJXv9d4yxis/qYM2pluOQoPxIRly8QynIXAH9aH1CiHQ+lsarr4LoX/BnKQB4m0vP0eQn4+/aYD8ymnVbgJ07m3fmeQB0S2OauenGBpYxa8qqOqYdbjZ3lDxEnLopVDD8LG+0015AxjzbxDxkmzYjftp2XV69Ay4zs/S0m/Y9ry1KhhBolvwaZZcH7zjEnCo1eYtKt0KdtGa2leSHJxo1JG+I0/7DiqfvPA5+ZYKAHKhD8AhGyLPIqO8rAYrflG+7WqKjgl0izApEtnHw6PlOTz/+yMGebuo2XIjDwcs+1Ng+Ky48XXPCLPzZ7V8PmyxWj/+b2xj1kRYyxFLXkCjY2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(39860400002)(346002)(376002)(366004)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(6486002)(53546011)(2616005)(6506007)(6512007)(9686003)(6666004)(478600001)(26005)(2906002)(66476007)(5660300002)(66556008)(316002)(8676002)(8936002)(41300700001)(66946007)(558084003)(38100700002)(31696002)(86362001)(36756003)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z1ZCODBlVGpDTHVFVlgxS29Fam5oYlhBWEN5enJERTd4ZVBnRHg2RDJzKzNO?=
 =?utf-8?B?bFBObWg1NkVER0theWFQalZqZVUrZWFoVE8rdVQzYkg3NXVhc3NkOVlJaVMv?=
 =?utf-8?B?UzZhNE5IU01sTERuNXdpSExudms3bFN4MDJ2N0U1MjdGVTBFNzZUcm1Hcm1D?=
 =?utf-8?B?b1hhNG9zTWErUVJXaVBPVlVQUUk4eC92UHJ5bGovR1A0WWlLYURlZGlEcDY3?=
 =?utf-8?B?cmp3YndZZkZqejczTUVOWmJVT0JPYjNXSjU3SksxZTdqaHpNZWpNZE56Wk1x?=
 =?utf-8?B?NTBzMWdaUG80bFZjUnUwV2FTbDRSY1cwTXF0MDlXS0xqNldRQThTcHNmUFVX?=
 =?utf-8?B?ekM5cUxTL0dSek9wSTJsK0VBYUNnZVJ5Q1d6OHdCK0VzZUJNaEh2ZlNOVXVT?=
 =?utf-8?B?QVZBVHROMXVkTTUzQWtzbW5TanVMSTZWTUtwMFMyd2hkZGx0Z2x1UXpBT1Ux?=
 =?utf-8?B?RnBKdndxUURUOEU3VzB6eWtKVVl6d2loWUhUVTF1Qmw1OS9WU1VnbG5xdGND?=
 =?utf-8?B?clk3cnFDZ2dGckpyQlpYV09CdDJhd0NldTVDVnpDMndiU2hRT2xwbW5NdEZq?=
 =?utf-8?B?UFF0czRFeUZKMGZFRXpmeERWeDhjVmNxZUYyTk1IVjlSYlFhSmZ1OS9rK0RJ?=
 =?utf-8?B?K3orSE1FaDk4S0xyNEZLWTRjdkRkRzVxQnVvR3A3SHRuTVVVRmE1YVJjQloz?=
 =?utf-8?B?NHlrNDlnc3RvcmcvRnJ0ZTMycEFncG9UQUhXendkSUw3emxCUVY3VDhuV0tI?=
 =?utf-8?B?dXJPQ3lQVG5HTXQxSUp4WldCdktnTkRBSUNKK1JkVFhiS2NweTR2QTF5bzI3?=
 =?utf-8?B?VGlFMzczSGtzOXZCc0tlbmdyNXVKRnJvZXlldG9tK1FmRmVmY0xuK3VZdXJy?=
 =?utf-8?B?ZFBNbk9Fam9iemNxQWh1YlFWVXZJbHFFTUhDaEh4d3ZMVzBCU2FsUHY2Mk9h?=
 =?utf-8?B?c1g4L2taL2RucnJoYjd5a0hCdU1UaTFsZE5jaCttNngzU3ZpSDB6UHcwbjNO?=
 =?utf-8?B?VTZYTVBzQzRFS1FyakZOelYzcE9FMWVsTDVvd1A3M3J0SVdZWXBmZEhZMjJC?=
 =?utf-8?B?anFrNzk3aWZyZVdDY3pnck9MT3B5U0FUYmcvaldGTzBiaFVsdWFlbzF3OXUw?=
 =?utf-8?B?STdwaXdUTFpGQ2s0VnpXSTRBMG1UY0IwZTArZXkrcENJaW03Y2ZLajhTK3RN?=
 =?utf-8?B?UVltbXFwdmhuUExqWDZCdS9IcGp3VGF2VWtKK1RmN1l1MUkrbUgvSDNnL2hP?=
 =?utf-8?B?UnIvQmZkcEZUZTAzcVhlSWJHdjJSWFJMZU4wc1NXOTVFV21iOCtvQVh3d1Fv?=
 =?utf-8?B?TDBPaUFBRms0SUFONVFzUnNERzV6TGw2S0lkTkpGSmpRM3RTa0gxSndTS3VY?=
 =?utf-8?B?SUxSelZEWHRwVEptaDNrN0l2K1BDN2djMlllNHJheVB2eEtDZy9XbkFIOE5l?=
 =?utf-8?B?WHNhQjc0TUY1aE9rQzIrVnpMb25LQzVkSTFsVUxmaDBaVFpMd2VmWm43VGFn?=
 =?utf-8?B?aWQyMEZFWXhiTlNZM0FjbzEzTUNhbUVYOHZoeFpROFRNcjVXK25wZ0p5Q3JX?=
 =?utf-8?B?dURuNktrN0JsZ29oNHdBVmdpTkN2VlgyTEQwTXRWSTV2K0hZcGkrZnE2NjNE?=
 =?utf-8?B?cTdLa1dHS2M0NCtBVnYyaUJYbnFlYVVPQ2JtZFBpbXF5Y2syam1HYUl4dUVL?=
 =?utf-8?B?MWxZdTMzcTE2TmY0VllCMG8vNE9HRmNMQ0gxZis1bDBMUnJKQ3BYTHpDd1Bu?=
 =?utf-8?B?Ry9HSVZEYStGbDRTRHVCUW9tb01KOFlRVm9rZWJrc1MwMVAxdFdDdjNYRXcy?=
 =?utf-8?B?L25UdmIraEJ6dTlvZWZsVUMxdVRSZG5CN1JXUC9kOXlZYTBvTmtEVlBhUC95?=
 =?utf-8?B?NkdDdmEzUzBVTGlWN1pkV1AvTFB4TmV3ZWIxcG9sYUFiYkdkNk1rYkthZlp6?=
 =?utf-8?B?VjRkMWE3cXFVT2FEU1lOZzlJTi8rZmp5OXRvckNjM1Nva0ZwKzR2amh4YVRB?=
 =?utf-8?B?V2VxRmhjWUNCQ1BjVFZrZDBVWHd2ODlTak5YSjYwVG0yZXB0R2dqeHFNQ3k4?=
 =?utf-8?B?bjZ6a1pYY203U2FxbXI4VlMzRzRpT2toS3JtUm5QdGRiZ1UxZll3a2NGQjRn?=
 =?utf-8?B?aGF0b3BRNS9NNWFzMERlTlRKSDkvMDN6VFBVRUQ0ZzFZMVJWb0pkZkhjOVUy?=
 =?utf-8?B?TVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: p5j+cZ6FW5zd7SSfbmIXjMTloGnfeADKoAo/zVrjQdjfFflT+OuXOzUX4uNDVSZImByHMuJfup6xmciXO1yabeS9IKNghDjR+x0KiFi8RupiwO0nbsCz0U9lqGjFFdh2whTcqnlFb5hunA4WXlW+u05tFnqMSsH/Llhkw7mjR5TxlrfpXystpOA8DKcL2zWC5jvxLxVskqg9KHZXNzCe1SMJQXWvUnzkhVwpAGZcaYL5HMiOJuScQPzwA8EL/R2BJ9H0lNsEHZ09DJQknMKljfGiqu73NPbGhgRRdjHXZQo1j+XW0SbIBYM+fF22LvuPk1XrRVxreY2XRon1/4Qr8MSvHMKrlh8Sv5S2z7t2Jzcq0LpEJ3vj6aKWp0GlxS6Re7YpAmqKd7qOhel3Z8jgj/I5IDno+4Rj/R8YT4CVR5WnkfrZ0jxHFipJzdjOxSYG86hL5sou9Z4PRoZdk/171VyoEF5cs6viZ47ela/8Sjj9OTdgqsUWqkUgZlNdjjoklJZTI7uz9TU3H1IkHmub/+F9foRU78o5CSnvxp4xqjzDeLZOzubdNh8Hr2k+TkUSMGwZzgPJ9XgCMLeHtAqbwno3lQdNVY/LmoCGitF/xlY6QtmFJHQ/KNm8qcZ2w8ktSqlzlQwvh9xIaddg88HNgoOZ8rzqjJ1wv/+TvjjtBYXgVnKFdacBTNwB9QeDjHzahL8JHP4m0D8JDF0L53C6BAhqFyZFgNJNvvDxyqiHDQZLSqsngyUodTEF/Iyid5L3MFGw6ohAVMhPVvshyOoqTO66CwV+B8K3F1A9+AJFJV8y3kAvsiyHHpGLKpgLmdM0/olXCOZNZN4VSKno4q6iEO/Q3s5Gg4yZCRU4QZ+/EzEnSh3T9EfEPfuJVpxgi6i7
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97b56006-01f3-4fcb-6f26-08dbc4760006
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2023 01:05:29.0561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U1UGx3Yq2RKi4vYYZJUXZOtBdPtLtAV1RTCL5dFci+hTonthCb8VbyqtoNoo9zJd1u7kSH0mJJLqeouS69tv1NU8w6BrBmgRiXCMUyjci1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7204
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-03_20,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310040005
X-Proofpoint-GUID: y6DsXjuUWvEy12dwodJlgxbX4Y-Z3EM6
X-Proofpoint-ORIG-GUID: y6DsXjuUWvEy12dwodJlgxbX4Y-Z3EM6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/23 3:50 PM, Mike Christie wrote:
> The following patches were made over Martin's 6.7 scsi-queue branch.

Ignore this patchset. Martin's 6.7 scsi-queue branch is missing some
patches in Linus's tree, so the patches will not apply correctly.

Will rebase against Linus's tree.

