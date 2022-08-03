Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708B5C19F2A
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 17:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238236AbiHCRhJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 13:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236811AbiHCRhI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 13:37:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1CC11819;
        Wed,  3 Aug 2022 10:37:07 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273HDlDI023854;
        Wed, 3 Aug 2022 17:37:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=1ggANCwJKO+y5kUrEvgujshJO86Xc14mj4/bRxVZFIU=;
 b=bn1RSxE2qtWsjyPvmWPvEHQWcToR9Dc53PeYbcmgaPXS9ZiQZSZyIJwvzLS6ehh0aMZB
 2NsfzTu8Jlus+LmMBHYWssVbrgbW2fN9RAFA/omJQEGHkraZYE/0S8+zHNiLFhSQEdwy
 QTiItZ3COTqmslHNejFhWAED/Z0KOGRDDWl3TlSk90VjY8yFlnSttO6FnDdR/BZB/E58
 JeAHI56dRrUKl1VPktRxbY65xV2iYoXGx5CMWHk7jVfDbGGK0g9ajogBVmGB3enEjYdH
 0t1ykA5seqHex8U+Dzgrb20qi0anAgrMQ7mtqVvQOqiA31SDevaZknXs24mqI6XF3XOL kQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu2caggp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Aug 2022 17:37:06 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 273HAMC6007327;
        Wed, 3 Aug 2022 17:37:06 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu339141-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Aug 2022 17:37:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JSPcRoPp8uU81gKkO+8Ag908MbTkrl5uS26T2LY7pF4FqvkasAC0W7p4u9N2V1b4RO5wwbIunhpDAdfTV2rNLrABHkDvmxIXVkUsSd3n/adxw8mNPSUg1odX9/z4At7qMy9gcE4527c6q/5sNZUtivFYBJBm3yp1HuCy22gU7YaGHBKqYywe0MaYPQQO8rt1aZnGgFzEMnOcBg5du+XAGD1z9sZ5Ub6TEOOHthEIDACwrkU+9557qVc7T3Och6obm/Cvs4OTVMh1mhS2xLfyxwt8yff2Sl0yJaJQ2pQfV5yQweE5LPSjhN3Ur6cSOtwqHAnLmzkdmZzug5qVxn/cGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ggANCwJKO+y5kUrEvgujshJO86Xc14mj4/bRxVZFIU=;
 b=aaEYwUO5srwPg1XdHi+rTK2/IgtxFsbDzvmnFpRUA3rPxSDBypkR8dsWZ/OVUefF/xftLJs486EvktKDzEx28wXh17RcgLwwmEd0/sesZQrsufuKqlnjelo0ZejZZ9M8rrLjBGY9z1JDY/6rICe+de0LM7wmGzaRmJ1IKUcmasmRQl/58w+fEOWuZ41UQGAjjUgqm61Xxl+kHRmhQgxF++clVkZncrHhmEiVFxmLJt1Z1oB2LRaJi8Ov8h0RwW1NXEWSQQfM+k/tQOTn3slXuBrxTPZN82RseOGEEWpqu/jQIH++4a4UcL5luEF6JQN9psV9dMb+OWbPf+GifFAlvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ggANCwJKO+y5kUrEvgujshJO86Xc14mj4/bRxVZFIU=;
 b=mI8TjM3Xksz+PKXYG+QNixsaFQ4ZE8fwQIrIYOKxeQ1IQw6JhdCsR9J35Tutn6K0sNOEJKLbmX9vSktNn6Moktvk45YgM8Kz/BqY59y1lHFHszYSxxB0ZEBlrD8nTJKAiqpSe9n4m5tkKD7CuwISpWS/pXltdNEL36aXctDbYDA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN8PR10MB3348.namprd10.prod.outlook.com (2603:10b6:408:c7::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.12; Wed, 3 Aug 2022 17:36:58 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.014; Wed, 3 Aug 2022
 17:36:58 +0000
Message-ID: <21a0a64b-ad8b-f6c3-a958-9d4806ce9fc4@oracle.com>
Date:   Wed, 3 Aug 2022 12:36:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [RFC PATCH 00/48] Target cluster implementation over DLM
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com
References: <20220803162857.27770-1-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220803162857.27770-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0297.namprd03.prod.outlook.com
 (2603:10b6:610:e6::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a56bd2c6-e6a1-407e-529f-08da7576c411
X-MS-TrafficTypeDiagnostic: BN8PR10MB3348:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0L1pJEjJudzemFufXcOcS5rNJ+ICxcDpbA/3Cjkq9MuvQ7sn2QmDabNXDYRt5B14hdH9pGU4h46zuB0OkpD+Lel+PcurJ/CuBiUHvLFEqhIvK/DfpXG080mgjDXGXqx+nM+PSdkQXx97SgYaHa3PET8jipuTlcW3t5NdEltTiCN6UEIGEG1QD53cc0fnCrTW7KDaC0wndrYIKwyi3TNPqK3QP8ThkUN57lLJhR9TBzJJK5NFnOCwhKNHs1lqg2U01qk0jIe3gHkNFCldf8pVlDcr2cAvfQmx9YcYvzYHDilss6FMp68wQrrd40vCNgBA39sydS3Ut3szWZqki7D1nuZkaOJ9vChJs3tqnzOrNK23pS7rl7q6Bw35XeiqF6e+OTiZh59gCSP4bG6nkcX6iLhSLbW8Gc1y6/qEEPpIG2mX66Bq8KlcB+MI1qifUaRaf+YR8eXAYejduxHkbrVgTFmHRC60ZozRnEtQ4SKvBXVmA6xLRq7EwzePZwjI4KGAFP5d0KEHKrZJMZPYO3SRuv1wjAz4ZeBkgZwG7qykqpl/ONzzhyX4ha7gd05/yt1fZCr1g/1OgtHJH9I4odT9bKgp+UJM9t7A0nR1cyaVr5ndvKP9IOH7rjg4tEQ5WPT3/bigHzZYTTPFf1KKT+5BeIGvcXiZPfrLmf9bgBMdslDenV3qOudV5HJdnZjMUakZaSFYx8SDPQ0AtSkIpEPDTMRNkdGT3z4M59S7KAdRmVpsb3kAEtUJJz0S7gdpEkLkslKH/I+cP+HqTg9JVQxZ2ECaTlC09DyTfrLBeP3jmnX+FiKoL73IzR/nhgCwerT9/8PWnhtBx5Pn3M0QX5OWtw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(376002)(396003)(366004)(346002)(53546011)(26005)(6512007)(6506007)(31696002)(86362001)(41300700001)(110136005)(316002)(478600001)(6486002)(38100700002)(66556008)(2616005)(186003)(8936002)(2906002)(83380400001)(66946007)(8676002)(36756003)(66476007)(4326008)(31686004)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NlV0UXQxaTJHU0d3cHBGR25NL0ZQdHY5MlRmYldZYTRLdUxhV01XMzgzemJn?=
 =?utf-8?B?aDRmQk1nQ2R2L1Y1d05WRC83MVFaalptN2dMODlnUnhWcFNTWlREb1Vnb1ZI?=
 =?utf-8?B?SnlYbzU4MHVrNVczcjJvZEVJek54bWdKckVCd0hLNytDOUgzcjNqTHdWblRG?=
 =?utf-8?B?cG12VFdzK1UwM1hSYzZUSUNsY3h3Y21vbm5QRGdud1ZtbThnZ0VpbTgxWnFi?=
 =?utf-8?B?VDdVaGIyYTdsQ0FyUU5GMDd5VjYzSm9XTmNpRSsvMU16dnJKTWZmeVNjclox?=
 =?utf-8?B?M252dy9HRmM2RG1GTXA1MTVzam1na25iMm9nZlJ4YUdGb1VCYkk0NHpCeVAy?=
 =?utf-8?B?QlUwbVlJVXh5dURZNzZpbis5THgxWDFaMzVRL3BKS2UzK1JyYW9TZmVsZytI?=
 =?utf-8?B?TnFMQUVEQVAyQnpEcjNwdlk0U3Q1RlBsNDAxbDNOSGFmRUtLZUJKMmFyV0Mr?=
 =?utf-8?B?Y2JaK2xBMmc5T2M4Mlk0WWN1cTlld1lmeXBQVUFuSG1RRDlvOCtQNlN6c0dW?=
 =?utf-8?B?U1VOV2FZWnl4VDhOQS9rdFI0RDR5bCtEeEpaN21EQnI4eUVCeHFTK3dybkMr?=
 =?utf-8?B?Z2ZvdmhvcForazNnblRncjcwWEFxeTBPemlNcC9OVll5TEovMGxXSHBoUTB5?=
 =?utf-8?B?cFFWc0hRZDd5b2NDWmdmVE1DcFVaU1hDZVU2c2ZrRTVJdkYrWldxU2w5L3F4?=
 =?utf-8?B?cVlwV2owNUI2bnRJSEhwd3RNcjk3bUt6VzJCQWJrdTA2cVlXT0tNZ0NxVkIv?=
 =?utf-8?B?QlhhVnJvNzBsRWtKUXhEMFBlZHNlZFd1TDlLeHAwRlVYeUxNdEFEV3JoN3Ja?=
 =?utf-8?B?SlluKzg4eUlQUEFZVFR0UFRnK0ZRQmx1aGt1Y0hnd01TY1Yyc1FkcG4rNkJj?=
 =?utf-8?B?MW1BSHFSeUhvUEhFVG5HU1hpblk5S2JMRUhweURibVlLMktUK1RyZXc2aDQ5?=
 =?utf-8?B?MUNTc3RVYjZsT2oxVDdVWk1DeTNmT2cxcmJlVUZ4UFYvME1TMW04Ti9Zak5a?=
 =?utf-8?B?ZmpTSG9TbXJkbzVXRnFyZ3FZaHNidUlRdytYcVdWSHNJb0RqZ096bUhlNkUw?=
 =?utf-8?B?N256S0dGRUxFM2F5enRBUFFmYmMvRnAxejdnbzZWUXUrenpBSHVKcHRHcmxK?=
 =?utf-8?B?TElkU0tIa3hTbXU4RTJyT0tlVTFWcUcyYUpmV0xJWnZUTTl4ZndIaDQzaWF2?=
 =?utf-8?B?Zndzd0ViNmRPTlBqenZUV0xKMjhRcTVwTUNubUlvUk9SNzVpSk1PTzRhb29J?=
 =?utf-8?B?ZGxlY3RnaWdmZ3N6YlRubVZBdVB3S055UmZuWkV0ZS9tWXB2ZkpNODYzcDdZ?=
 =?utf-8?B?WjhkM3hEYVU2ZmZtbEo1ZllqSDJEZmh4RkRWdnA3RENpSklZUkIrWkFpMVBq?=
 =?utf-8?B?L2Q0SkE4V0c0c01rc0tkNUpUalp5Q2pMN290THU2NkpDRUFnWlg5blIyZlNj?=
 =?utf-8?B?VWxacHJvNTM3WDIvdy9xYU1Lc2FHL0xYakdkYWtEdjZxdkNrd1ErR0N6bkF3?=
 =?utf-8?B?Q1ArRWJxWGZlRGR5dmJlUjFESnpHUHNhWEVuZG4zdkEyWkU1UmRGVm1Xdzdq?=
 =?utf-8?B?Q0JaMjlVc3dUTmNIUXpjUEo3V0JNd0JUejN2UWk2NlVBcXM4WTRCQjVoUnJT?=
 =?utf-8?B?b09OWnRiNW1kOVpaeGZTZzNXWURtZzd6VnE5a1A1a0lVOUFzVUhyZ0tXQUJD?=
 =?utf-8?B?QjhvU3owcTZsZ3RxTWtvSnF5aDl4elB5RW9kY2pRVE0ydWxjSFU0S0lVRHF6?=
 =?utf-8?B?bnhwdmh3UUI3QVVLNjEvT0dKNXdKQXVOSkdhR1JFOXpMclRBT0pnUUNyQ2l2?=
 =?utf-8?B?c2lOc1R4dEcxc1NTZkxrWHV6WlI5K1c1VUJSYm1RNFRKU1A2empWL2lqdmpt?=
 =?utf-8?B?aG5kV291VklIRlNuR3lINHdNRUJydUkvUE5FeWNhaWRmUmt6NXB3U1NOUTQ5?=
 =?utf-8?B?WjZqWTdwS3B0YlEvYjVDUDh2eHA5eEg4Y3JocEd0R2JEMjEzenl1dmZ1Tkxy?=
 =?utf-8?B?VFpxN3dDVWNpcGYxTmlDUHM0QmNHQkRvM1UzYTBhWDl1MjJjSjRCaHJkVUNE?=
 =?utf-8?B?R2wvUVJEWGpBMi82MXBHc2tGZ3dkVXoyRlZ1UWNsa2xpZHJBV0ZncDZ4eGhK?=
 =?utf-8?B?d1gveXFiN1JzV09rSXNVYXdqeUxVVmJ3Njc2QkpibWs5L0VBVG5YRlgzRnRa?=
 =?utf-8?B?Znc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a56bd2c6-e6a1-407e-529f-08da7576c411
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 17:36:58.3812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KSfRSXT/I/oEUMY/S/6TiDbUVOx1GsDGsyeCk9nuI0F/kJWvO31luOIf0WWSGLbRIX6Sm/BL1+kw4/S0o4B3iN4O6FVO4lQDxakI86sVJ6w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3348
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_04,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208030078
X-Proofpoint-GUID: N1I3H3Q9M4syXw4DzeWedilGqoC09kJE
X-Proofpoint-ORIG-GUID: N1I3H3Q9M4syXw4DzeWedilGqoC09kJE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/3/22 11:04 AM, Dmitry Bogdanov wrote:
> Hi linux target comminity.
> 
> Let's me present RFC of an implementation of cluster features for Target
> Core that needs for backstore devices shared through cluster nodes.
> 
> The patchset is big and of several subsets, but it contains some arguable
> things and it would take too much time to discsuss them separatelly.
> 
> Patches 1-9:
> Make RTPI be part of se_tpg instead of se_lun. That is a must because
> there is no possibility to assign RTPI on a LUN.
> That data model is different from SCST and current in LIO but still does
> not contradict with SAM and even is more according to SAM - a whole TCM
> is a SCSI Device, and all its ports are SCSI Ports with unique RTPIs.
>  + unique identification of TPG through the cluster.
>  + possibility of assignment of RPTI.
>  - number of all TPGs will be limited to 65535.
> This patchset was published first time 2 years ago [1]. In previous
> version the peers RTPIs were put in <device>/alua/... folder. In this
> version the peers RTPIs are part of TPGs on the remote fabric (patch 35).
> 
> Patches 10-29:
> Fixes some bugs and deviations from the standard in PR code.
> Undepend pr_reg from se_nacl and se_tpg to be just a registration holder.
> Make APTPL registrations (not linked to se_dev_entry) be full-fledged
> registrations.


What are the arguable parts? Do you think it will be the DLM part
and coordinating it with nvmet developers? Or was it patches 1-9
and the multi-node support? Or both :)

Is it possible and would it be valuable to at least kind of break this
up a little?

I would break this up and post the fixes in one set. I'll help you get
them in as soon as possible.

For patches 1-9, I think I remember you posting them before, but I was in
the middle of starting a new job so I didn't review them. I really needed
something like that at my last 2 jobs so I think it's a valuable feature
and I'll review that as well.

If we could at least get those 2 chunks separated then it would make the DLM
parts below easier to get eyeballs on. I'm ok with the idea in general. I
think every nvmet developer will see the massive patchset and not even look at
this first 0/48 email :)


> 
> Patches 30-34:
> DLM_CKV module that uses DLM and provides:
>  * Cluster Lock service (pure wrapper over DLM).
>  * Cluster Key-Value service in memory storage.
>  * Cluster Notification service with a blocking acknowledge.
>  * Cluster membership callbacks.
> This module is supposed to be used by TCM and nvmet to implement cluster
> operations.
> 
> Patch 35:
> New 'remote' (in fact dummy) fabric module. Configuration on this fabric will
> provide to TCM a view of TPG/LUN/ACL configuration on a peer nodes.
> 
> Patche 36:
> Introduce cluster ops and functions to register a cluster ops
> implementation modules. There could be a several different modules.
> The device attrib cluster_impl regulates which implementation to use
> for that device. 'single' is for default (no cluster) implementation.
> 
> Patches 37-48:
> TCM Cluster over DLM module implementation inspired by SCST.
>  * Use DLM_CKV Lock service to serialize order of PR OUT commands
>  * Use DLM_CKV Key-Value storage service to store PR cluster data.
> Sync it after successful execution of PR OUT command.
>  * Use DLM_CKV Notification service to notify (in blocking manner) other
> nodes to fetch PR cluster data. The handling of PR OUT command is
> blocked until other nodes read the cluster PR data.
> 
> It provides:
>  * Cluster lock per LBA for Compare And Write.
>  * Full support of SCSI-3 Persistent Reservations including
>    PREEMPT AND ABORT and REGISTER AND MOVE.
>  * Normal PR APTPL imlementation (persistanse over power loss)
>  * Shared LUN RESET
>  * Shared SCSI-2 Reservations.
>  * Unit Attentions for all TPGs in cluster
> 
