Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44BFDC197A0
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Nov 2023 11:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjKPLOy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Nov 2023 06:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbjKPLOx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Nov 2023 06:14:53 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E79A8
        for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2023 03:14:46 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AGAsew1007659;
        Thu, 16 Nov 2023 11:14:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=0AsJ4vWDr8rL3McTMa+1QVlfn8Y/6h+nbF2A+pJ6sww=;
 b=xM3NFRoSNZIvOoppNTJkaBaR3VxY/Q5+aoLWM33gGIkAG+xTw8xoTOMcwHDJKroctRHC
 3mSM3G8/1KoHjHiU9fjACDqUrFE1r5kZ1K+OC4MtNBCOVIn6MvLchJlNGOegqkvoNIHu
 OWjG7rMk0wF8tmJgVFqmoTJvlSBb/wXO1P366FyU3BcLzSU3wFMUu58uk3N1zNm3D3WH
 DB1D+0ETvbKLWSqZzHkd7pxnBs6V0lT8seUv2DYY3/x2QgYCbjstEzQMPRQ6O+x9CBnR
 91ZGLKwOgUc6vpvLfG+u+BN5qJkmhUB2i0bY0bMalIih2lbz9ai4Eb0r7+yQpRIWqg9r Dg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2m2jsxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Nov 2023 11:14:39 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AG9bYXr006314;
        Thu, 16 Nov 2023 11:14:27 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxh4ptex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Nov 2023 11:14:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NzkTRIxu2WCIKFfvnadfwy/HjMC4klnLloKEipFfCEqemMBczuTq26iR1Ht2LKsByazXkEZ7SC9l68iUGsB16xdRxQGwS32rrEcNqBfxR9nYhjP8hde3nJceoQtHBf4WEiMoPPOv5Tsqu1Bhx8hDAToUTL4ZUXQ0g4FVZFJwLeHkQ1B+Uj9HAbwh4joTatXvuw1j2O6gS/i182CJJtXnh8DTa8014p+22nT7YhOnI1IpvRsbI5FJ15Jobj33ddUozAouADhQFKbSgdxlRcuSuEEiH4MzBqceV7OFeQF0+ayup9xfJtkL39GuBcJ1AJtTw8bWuP7iyZiSQJHQoM29XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0AsJ4vWDr8rL3McTMa+1QVlfn8Y/6h+nbF2A+pJ6sww=;
 b=l2lsi0IqcZp7cu6Ekdnx9oQDNcTA2Syx8b5gGM+CAfZPKF01CgNMHU0aflj/B8uqT0CuSmK9+narX++E7Ws/xDFQxdFC46jrHxluppO8tsAujazLIdwc9sb8ZolDBgqqLQiHPtEEX1yzwQd0IOEm+WaVHYxLenD6dGC6QQSgMH3sLX0Ly8EAqytXTxo3NzKalmm6lzbngd5sFmaJrRLpOeH06aNuK0CB2it7Mbs0ZYEH4DK2vRwplLD3QTgzIdQe2x55i9JSiYd2UH4pyoPYYiwh7enxMJsgM29KR4/JkgGtZlEs3WS9RujMOnjKVSSH2vpmJiAB8u5JrXGeQyz2uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0AsJ4vWDr8rL3McTMa+1QVlfn8Y/6h+nbF2A+pJ6sww=;
 b=yiPieqvGhXzLXXcfzCMAs6yXz2PB1gWcy4+75MI5SDZle4GPCAAq9iv//gArREvSrhZ+RCKZHSzyXcf80f4p3vXerJEw5OBLZ7lkRfED10EdSGjgX872WyrRvYwh3SR/LbWJye24StzNUmqQvBKB5bMJT1rgfu+bTtg6xsSy9Jk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB6779.namprd10.prod.outlook.com (2603:10b6:930:9a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Thu, 16 Nov
 2023 11:14:25 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::102a:f31:30c6:3187]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::102a:f31:30c6:3187%4]) with mapi id 15.20.7002.021; Thu, 16 Nov 2023
 11:14:25 +0000
Message-ID: <2d3bee15-fda0-4838-bdcd-4970f7cf675c@oracle.com>
Date:   Thu, 16 Nov 2023 11:14:21 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 02/20] scsi: Have scsi-ml retry scsi_probe_lun errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20231114013750.76609-1-michael.christie@oracle.com>
 <20231114013750.76609-3-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20231114013750.76609-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0275.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB6779:EE_
X-MS-Office365-Filtering-Correlation-Id: c7d0cd96-41cb-465e-718f-08dbe695311a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D02xlZEWIr0WrvH/u5FHfhK/vAdPoTnLyALrR0QMP+NMQfWSs1qsnftl1GxxZbjdOXKIdPP6v/cQCy2lJlsn/CPolmIQvhERnSgZN+jZh04+0crju9hb60lVpG1juZYExAD0NjvSCVSRWJu6++/LYNR5GLz8Pnb1oHXP93PODqDaoRe5snux+JKXjDUxsUPl5EBUX21TtMvs/4ivWr2WCfr6mzawzabJUO4ekuRAW4Q4FVMNe6cS2uWJQvZcYGvL4GVdxWhMcVfabESl5FtgA+NGxJZhFvglxprjEjvWyNuupNxuRjF6+uYQsaapWozGPlSb/OiGBHXUhuL12Cr9uL0Ur8vgmkmy2XOlorVofFecJ+NGNeecMJ6T36NlGvVp8Z/BQwR6zWIeKBV+90/fjhpEc3+AG1Zpn09iVRichh4YTncWa5+SpveVJZXOhMatN3ZkHqDuR4A7vJ2kcAOvElEFyYyzXv/imW3Jgu4qFDaHcS8U0Omkb1uHaEo/8llCai0u1msJKbeoD+c65q3tH6LxupuAtAWNVVidDVxuJ81IlBfi/q5MTKMqDpM/gO9M9sP8NDE6UY00trju0WXd3dVrmfP59L84NnAWCBdM6IJ6tjsCoBC0EUecDnzTKio8+RUCrKQPeL7turm8MowOzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(346002)(396003)(39860400002)(376002)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(4744005)(2906002)(38100700002)(86362001)(31696002)(36756003)(5660300002)(41300700001)(31686004)(83380400001)(6506007)(36916002)(53546011)(2616005)(6486002)(6512007)(66476007)(66556008)(66946007)(316002)(478600001)(26005)(6666004)(8936002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3dEWXFHYjZwdlFSSlZpNFlXVzBXczdicW5aclllTkRlcEZNSnFxTG1ra1M3?=
 =?utf-8?B?SDNPMjRsMFVJZi9Mc2dtRmpwd0JyeWt3LzY1T2h5ZWNoWHp4RjdhUCtjM0w5?=
 =?utf-8?B?ajAzMHE2eCtDRmRLd21aSElKOWx0K1dkZHBFeWh3dFlPNVJMQnFLcGdKeXF5?=
 =?utf-8?B?SFYwbHhyYVlxelFxaGU1VzdRZTVIRjZROXpFMkUyUDM2UW4vdkR5LzJ4TExO?=
 =?utf-8?B?RXJuWktHOTBNK1hUaDRFSjBDb3hVN3FoL3VsOFY5cXIrSzVRSjJKUEZORnVP?=
 =?utf-8?B?ZkNtY0dLMzQxOE1GRWw4N3JQeUFqUzV6eC81Rk4wUlBrWlV5WTI1U3F0eU9i?=
 =?utf-8?B?S3IyVG5IR2VCcVlYNHpmQVE0blY4OWZpWXR5d2FhdGltWldmbGp1cTZMeXRB?=
 =?utf-8?B?djNuMld6K0xTY1EvK0ZCOWI1K3JWbjhBSU5JMWdOamtCbGhjTDNrdmRiMVIz?=
 =?utf-8?B?bUh0MTJqRjdmb29ZS1pqOUZoSEorV2R6clpZVHJOZlorSExrUG9ady9yOE1u?=
 =?utf-8?B?ait0cHhRR0p6MWxYQXZ5ZDg2S0FaYTBaeXArdXZvVlVjTlVYVjVReFgwZVdP?=
 =?utf-8?B?cVpZc1NZN2hnWG5tU1RTKzBXS3dCUGdnWkE2LzBOcU9DRnBIMnpXOSswWDBx?=
 =?utf-8?B?L0pMMlU5U1VMOFNidFFFTnhVRzhXSisrUHdaQm9nK1VYQlZnd3BvWUx0NXQz?=
 =?utf-8?B?SlIzVmp5TjZ3ZS8xcDdWeTlvTVJHdGMzamZqWkF6Q055YmdTV2FaK1ZpNzdD?=
 =?utf-8?B?dUdvemhVTjEyWkZ2U0ZSZ1hYK1lKU3ZmeitycDJERjI4MGJES1JNTHdEa2dn?=
 =?utf-8?B?WjNxU0FMVGpYeGVMV3dBZW5SZ2JwTnEySXAzT2pqakJsRTNlT2RjcFB5R2Nt?=
 =?utf-8?B?bkVySWpER1lxamVSc0hzVDVReGk2ZXlxWWhEWTBicUpRV1V2RTdEWVJXTWYy?=
 =?utf-8?B?dW9HeGR5K3BtZXhsREUvd0tFZU1NYnd6UkUzSW8xRFRpdEFXaGRNV1MyWjZK?=
 =?utf-8?B?NTRhOW1NclhCQlpJSDh3V0swVXVlYUZYdzJXWjVzZFV6S25PS3VmZmg2c3Bs?=
 =?utf-8?B?bThSMVpBMTRSQ3gxdnJOZU5IR281NWtsQmljazlkZmZEbWVqOW5xUHNtb2Uy?=
 =?utf-8?B?UzFLdC9CclFybnkxbFFiZnUvVHR5ODd5WDdVSmlRVnQrRE9JVkNnV0lsNHR1?=
 =?utf-8?B?a2tSZy8wSFJYL2FtWGdLazVOQ3BOOHRaZ2dLSE1zUlRqWERnam5aWTJRaHVh?=
 =?utf-8?B?Z0ZYa0tidXZHM0l3WkNuUU5vRHAzQUVmcjFRbnhNcDVKM2VtdHlPUG1vMDc4?=
 =?utf-8?B?Z1ZmbVlzTVBqZkFCaFBQbFU0QzVzZlRBMlNMMVEvTVRjQlYvdkJsM2k4KytQ?=
 =?utf-8?B?VU04RlY2MkQ4Z3A0cTFHZkZGL2VUK3pSSXRJZjJSdU84YktFbG9tTUZGUTNP?=
 =?utf-8?B?QnlEYktJSFlaUjZvamVPQmd0S3Rod05uN1RzSkZvQlVSaWdNZm5ydzh5ZVgr?=
 =?utf-8?B?TnU1WElHUStMQlZQdHQycytqWmVXcG9aaE9NY2pZbWVOdFFSdmxNYnBRdDA0?=
 =?utf-8?B?b2J6VXJLSGtQTDB4Q3BZY0Nza25UVEZwVmpvamY2MXovRUZGN2dUWWF6RWVT?=
 =?utf-8?B?SExEOGNUcVRPZlg4QlAyakZoWEtLYTRmTEdHbkoxZVhtMDZoOUdsV3BEY1Yr?=
 =?utf-8?B?V1A3YUFhSjJwc003SUhMek9RT3BVckppc0dMUlEwZG5sa1Y3ZGNUcjFJWlBq?=
 =?utf-8?B?TTdoNjdQaXVmTlJOVXFvMGI4b00wdXpvM25RcENVVmlQYXJJWFVGVERxeWFo?=
 =?utf-8?B?aGEzOVhZaVlIL094UkhGWkR5ZG1pMTR4N2JCRSt0bFZYREplQkhpVU5SN203?=
 =?utf-8?B?Z2hmNmpLQlNUcEEydjFLK3FWVEJWODV4aEk0dkgvaXNNOWRUL0Y2SjVsem12?=
 =?utf-8?B?S0xBWWU5VTVEU0NYK0IrZFQ4dVFaeEF1d1o3aXFhM0RZcVFwTnB1MnBGU01P?=
 =?utf-8?B?ZmNHVWs4WkJkMjhDTmc0MXZZQlVPWEZJQTBSbzl3K3NKUzl6ZHV4RndBMUlu?=
 =?utf-8?B?ejJKbWwwMG1NS04vN2FxL0Z4T1o4em5XTkxPUU5ROXAxOGRLWENIQ0oyOWF0?=
 =?utf-8?Q?Uiv2VdE67N2ua1llzrGDC4pTi?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Poyhka5BsJfk8rWiluMhudfYFP7NkY0Sa3l7rdVWAkhdVNc6Imla66mT4fwrCA42oK4C8i2TlVYXVXQrX6T0i2teH6Ki6Kj6ef4DUBqKb/uSnfj/CtEEAA76s2oTxMElteSaS1Qq8gh86CaaUMji9RPzC4U8fmx37/uqRvrgpTCdjVb0357pyrnfPfrLjpGYVDU72PvcuGIeaT9HjOQkESt7U5zCXKwOvuhapwh431okkFcizntd+LQ+tYsXiY9bdSC7yyfpMmwkedGFRaqlhVtFTd9sj69MaMzC1ZMjSuWuAf4VqP8l/PW1xFyQfcf9T/vj2/5fqxrXkHghFyEimtexRew/6iuP7+gCFB8lqYL52vgh5lQJwYSaWuC0+Swdugzkbzum0skqxYA62XDYNCJWEavJ06By+Pk1UkHu2Yc61y0mnd0NVgJBv7TGOWOXLa5FKNYsivBaX5DACV+J6YPdotdNXF4ksGtBmt4bJiI9lj+6aqPAJujarHod7fq0OXxPRxJf/p/uzagPP6JVN0d/M4vhymDPb4eKrY1wu6SlKnADjEHvgfmki0F+Zg9lmn/LA1kHSDZUP9ImPTJsXaQa8jKHHX7KflAfgWTqMCKNtxOQF6w3YelHWB5hOFy1eUqr38eQqnc6ndZmNfPIUD8xmDBIRSGzaXIYyWp9ebHU2V7ihSTyVbzJIzs401LU8a+IBl9ZJZRTOSUgNvdJFY53TZoszy7Jl0uJmRpriyyhLwFWTN0sBzRWTKJni9trAUHCgf/NQKAxyhMDqjfyH3qYl7nVN1TYer1RfUpeJftnBJwGxQzHQZ5CcVm0uzKPfYJiicCRfoYpmbDdF2Bk3lqk8qRaz6dgk2kyNSFbM7whmHKAcxyPysxSiojz28b3EovzqpF413KrpRvTGlD40A==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7d0cd96-41cb-465e-718f-08dbe695311a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2023 11:14:25.4668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PwRwcjYhnOL1WrRN/MiAYPU5xxvLek1WGISfO4WkxkeKAAMtHSQZg5JcCCacZmuuM2QXf5brLmVb0J52uQM0aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6779
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_09,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311160090
X-Proofpoint-GUID: b6Ij9NuC9mi10pYUXeHU6XEXNf4NMYmx
X-Proofpoint-ORIG-GUID: b6Ij9NuC9mi10pYUXeHU6XEXNf4NMYmx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/11/2023 01:37, Mike Christie wrote:
>   
>   	/* Each pass gets up to three chances to ignore Unit Attention */
> +	scsi_reset_failures(&failures);
> +
>   	for (count = 0; count < 3; ++count) {

So do we keep this loop for the USB workaround (not shown)? I just 
wonder why we retry in this outer loop as well as now inside 
scsi_execute_cmd(). Maybe I'm missing something ....

Thanks,
John

>   		memset(scsi_cmd, 0, 6);
>   		scsi_cmd[0] = INQUIRY;

