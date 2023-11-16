Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 474A7C197A0
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Nov 2023 17:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjKPRPh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Nov 2023 12:15:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjKPRPg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Nov 2023 12:15:36 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D129310E0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2023 09:15:32 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AGGYf4C023910;
        Thu, 16 Nov 2023 17:15:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=ttaklBmP9ur/Loqo2JLlwcsFBmTU6apPoxCdb4Y81gs=;
 b=yxgNg83a8ScVZiGw/Yg/pzhF3azbdoW56kSzh+2XtYDoHfl9ySxD0peJYMpOs2YfOWts
 j0S2/tAtZcFbHJAXTz1cBOj/zGZ14lPk4cuE4Xvrq/kIv8O0nZsE56Mr9oPD0rUis2hu
 Vanoc/Ko87w+IDVynaHO0AhViTby5Liv6ggxJXMV3iLoIJSPfJ3LxwLBpS76FFKXk4Tl
 ikfNBMkKexmbqcRwM7lZNH70K3m9TkeekGMZgEMUf3k0hz2X6Bx2UOWe3QvHOBDBNglh
 6qk44xuBNiTKJupvBEin5wCnYhEyZzOl8dI1ChYmoE3RGQFMQ0kIlIY1SSe8Sa7kMJX8 dA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2stuk2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Nov 2023 17:15:24 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AGGJamE031658;
        Thu, 16 Nov 2023 17:15:23 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxh56w6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Nov 2023 17:15:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sfj9WI0LYsred/9EB/IbmbyHYRunb/AgxMVLDSGKXATGvmLu6ePnrTNeLkbiCruDkcu58ct6cNUrPhCSQORboCBVYoGw3d3bNukAhDo7mdsjKUB3nxOAU8K4U6Iv9jJW9mTEUuqDraN1RHiiM/7KotibP3Wuz7BaKSgldO0eowQiZEVIXjzxHfQPr1PW+vRqkJ1POHa6s9Qhk2kp4+ZIJieeriIuDb2r/FfeMr+3ewIVwKT0vRxn5r7nJF55Xlw15Wn9FKvNo6/aNSWNiSUP/DhTd/rh1GtkgaJ/wlwwC590bJlc2PsxGozszO4qVEaGJ6fdd+lqQtbkQXapfa8NoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ttaklBmP9ur/Loqo2JLlwcsFBmTU6apPoxCdb4Y81gs=;
 b=AxWZiONe0ccxZuXf8cQwAHFcjyoVx9gxVHI6Y+1Pj/iN8zUd45XAsb6ks16siGg76x90pGrjJQUVXLwhmFz7ERUBZpNbgUvT1lBmLFNJj22nXiZokM2aBRPh3cxqeTH5JAf+HYUBwhXEf4aFq+4Gq7FSRPL2XgF7KCI3KVlAygG9OVlzUrdSdcjOsGAwG7bSpdghZ865ATHbMweisOF8z6N/ytKQv4miDdibwiE+NxmK5RpdGf0f4jasyqKKPLgKQ0q2wsSbubtFZBhXz/w4omwKhTzFc/hPb+vj0eEuq/KDKvZ+gpJT0KrpIDLQzBXJ8Ai5QDpXpQQq/FHzyeM0dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ttaklBmP9ur/Loqo2JLlwcsFBmTU6apPoxCdb4Y81gs=;
 b=qZW36FT8KkVeXD91bzX3fUTR2JlcVLE4a+LPZtl7ebS2RiuOK/XPG4FcYPy1VO5oS7Yyi4F/c9U8Yvw7/YR2tWmP+K+Mdm/U3PbOn8NjVdwvAWgb100tm0mOV4sb1qZFrfNP6KasI8u7rAJLNzgqWiEgG/ZkmZmIqn0NBwyYWLA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA1PR10MB7790.namprd10.prod.outlook.com (2603:10b6:806:3b1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.17; Thu, 16 Nov
 2023 17:15:21 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.7002.019; Thu, 16 Nov 2023
 17:15:20 +0000
Message-ID: <5ac4a93d-4aee-4378-a93f-a8b00293b00b@oracle.com>
Date:   Thu, 16 Nov 2023 11:15:19 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 04/20] scsi: sd: Have scsi-ml retry read_capacity_16
 errors
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>, mwilck@suse.com,
        bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20231114013750.76609-1-michael.christie@oracle.com>
 <20231114013750.76609-5-michael.christie@oracle.com>
 <89938a66-7203-4809-8d45-c820b5a21d4c@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <89938a66-7203-4809-8d45-c820b5a21d4c@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR03CA0327.namprd03.prod.outlook.com
 (2603:10b6:8:2b::35) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA1PR10MB7790:EE_
X-MS-Office365-Filtering-Correlation-Id: 0399b302-bf9c-4ed3-a253-08dbe6c79ce7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IGrobqfxmCv3DzQnGn5ePeQmEh8c6SN0TLdVAh2a4xF3zPabUteqbLWwVP9XluSWnUoNp5v2MJIDOJnLUSSfAAX68+AIxHYqVzm6lrF+rN9CWAe7HBiywosCWMSkktZX+2pWcBx9A2h+h8wlxwDjMBzlMC6LK19VebAJkrOWMVQvq2pjqiAyRKcEjivzauzdCMq0h6/+yJFByo4+6wXsllBmFQKMCGx0RAcTRyrEPDjOIW4rtodZ+S0HqM4+ERgvNo9eqrNiGUx28pEQPfWvNNr3Ulg9v0ClbSZ8S+ignM8Hq0TDtT2A3uCJJohkB2Qr9WO9MM7VXeU/C18RMV7ScEczPzmq5HxkH1wxAHJYiET3JOVcQBaMGimzbpJN2FUVHIyOVf3VR72S64alBFiIu8zF2Rh7LDRKiMj3ztRces/LxNkhHZeWcio8hIuUDqCwXDx/2+1iSg9nyVOSpcxcd3CQuqn1QYTMYCy4Sspkj6lTEBUnccBwMX73C+to/+qv341E+v6dgVViGyqRs55lv+zD8hrDzxwPu7gwemZif7ULCYqPnE5JQ55wIPVvOYd1dIRSNuvIJ1aXi4WHpTMSgXR6wkZEAFk/58AdZ1UTmF29kXLfKVqzIhbKD+gug4BjS1ITKaThVo5bNKUcCP16mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(366004)(396003)(39860400002)(346002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(31686004)(26005)(6512007)(66556008)(66476007)(38100700002)(36756003)(66946007)(31696002)(86362001)(83380400001)(2616005)(53546011)(6506007)(2906002)(316002)(6486002)(8936002)(478600001)(5660300002)(41300700001)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Njd2aDRXTm42NlBJWXY4RWg1TFJmejJhdHNydkt4b3A5djdmbERrZ2svNTlX?=
 =?utf-8?B?SHFvdFp0U0VQRHBGN2tpRHRLblg5MW9yVURiSFBVR0xWczl5VUNqVnBucGpK?=
 =?utf-8?B?TjVJckllMTZrQnZvVjI2WlNXMFZTNVkxUWtlaXlCY3c1ZWVCcTBkTlY4Rmkv?=
 =?utf-8?B?aG40VHc0dlJkQVQzVkRxdjZTY3pHeWdHUGJzOHhPZFAyTjJqWmJWZ3VNSU80?=
 =?utf-8?B?NkxnenRUSmNrUm1hUjVOMmR6VEp5cEhBS0FCT05XcXhFYUxlYjRHaEVwUjhX?=
 =?utf-8?B?ejRERURCdnR1VXlXRUVPb2wyVkZ3bzVHTEZlRlRIVmVMemUvYTFtdlBqb2xN?=
 =?utf-8?B?aWF5djFpTnRQSkQxdENyMnhaTGd5SkNhSGF5cnpua0drc0srZHZpSmtrUkN6?=
 =?utf-8?B?d2hVYks5MzlKc2NuOXNhSWN0aWtvd1gxVTBOczRJbFdvSk12czNpTzZ4MUdp?=
 =?utf-8?B?WWNKRVgzNUx6ZmgxcGEzU1N1U0MzN0NjYTlDK3F3RnFaQXEzTUVXRTFHOTli?=
 =?utf-8?B?M2E5d1M2dnpuV2pzKytXaWtpVUtiTy9jRWVlRG1YektYS2x5bGVlQnc5bjJ6?=
 =?utf-8?B?OU9XeEIzeWRqSDl2WU5RSTl1WCtDQlFVTlpUK2RkM3JCK1F5Ym5DV1dFeGRC?=
 =?utf-8?B?Qk5CbXNwdzhjeVBjbnZKNllvN3lBYjUyVytJUDBoc3BkdXBob2xhNzFXeVRF?=
 =?utf-8?B?OXJwVWh6YVhwUXJ6UDBmS1Z0QU1IYnI3NmFOS2FhUEhrc29DUCsvTzQrVEd5?=
 =?utf-8?B?aDc0WVRTU1BsMzNSTnNwUWo2OWxSd2FVK3lLdXpLbU53MGVBYUordWlZc0hv?=
 =?utf-8?B?ckQ1WHgxNmVJSzV1ZlUwNjlmRWFLeWFvYTJ0RmVhMHRlUG10alBZRVhzL2Rj?=
 =?utf-8?B?R051R2tLOE1QaHQrQ3B1QjhaTFVtZU9QdENYVjFvZW0wU2NsMEJtK3VDVkpH?=
 =?utf-8?B?NzVyZ1ozczRVanpXRTF2UjIrYUZpRk9WTGcxQ2V0ODYwMGNEaDFVb2UzN1pv?=
 =?utf-8?B?NzFwU2sxYzFYcXJRR1pKcXRJbmtnTmZZdXNvdWhPN1BuY002OHFBSjFlR1pi?=
 =?utf-8?B?MVN6OSswNFMyVDVqSVpUSmx1UXZRVythRTZSY1JqUnM3eUw2VWlPZnV5WUtP?=
 =?utf-8?B?UWQ1OXYreU5xK0FhUXdmSWcyTVhzQVo0UzdzNUlQY0ExWWxsb1BQcE9OK0Nw?=
 =?utf-8?B?eHlUQWVsYjBUOHBFVmJYZThSNWZRcjR3QlBUU3NnbjNiWUcrUGE5bkI1UldO?=
 =?utf-8?B?RGlpVU5qdFhpOVhlbk1CcThMTGlxTXZwckZ3MEVlYy9zUFlOdzFVM1JVakxM?=
 =?utf-8?B?WEswYnhkQnU3QWlNblFOM2NsUmtSc29RSEpSZ3R3c3F2YnNZSkExNGtrd0la?=
 =?utf-8?B?NFZPVlBlL09ydW9sNFJxenNiczQrcjhUTlpialVqcnR2eUlhTnBTRlpjcHE4?=
 =?utf-8?B?YWRUOURaTE5LMFU2TDFjU0pTYkt5MERZK1YzOFpjNE01eHVqQkpGL2ZmaXVS?=
 =?utf-8?B?WUYrZVUyYVQ5Nm9DRmFFdC9QdXJwYWI2NnpqcUpjQmQ0bG94czJQUk91dmRO?=
 =?utf-8?B?aW13TGFyN01qdmdIYkFVL1BQcFEyZU9CN1VOUlZwd2VCTXNGWXRFRElPTUlm?=
 =?utf-8?B?M0d5YWZOV2FzcW12NkdCQitEcC9FeE9KcVhIUzAwdlY1ZFFTeWtEaHlaK205?=
 =?utf-8?B?R2dkQXBoQVp2ZDF4b2ZUVHJhZEFKYzNPZ1FvQkgxaGU2WS9zSGhkUTdPemdw?=
 =?utf-8?B?aUVGMFBGSUdDTEFxMVkyWnpzSUVROUFtR3ZXUjlWY21RemRlQzBJVTZLMU56?=
 =?utf-8?B?bzI1UzIzSUlnWGwrL05IRDVvUVdjSGlNa25jb1hkZW01N2VTK0VkdG1ObzU2?=
 =?utf-8?B?RGVUTmkybDBFWVJMTjZWbm9BMjVDalo5L0dUekVxcWlnSy9qV3I2QmNEWTAy?=
 =?utf-8?B?OXh5SVVPM0F2SlhFcmwxZkUxeTdvcnNxdGYwN25RWE9IcG5BT2J0MkcrblhO?=
 =?utf-8?B?WnQvZTlhekVwa0hLZWpIb2FXK2FMZU0yVlVhd1c4anRScWlrK2J6Q1hlMkpi?=
 =?utf-8?B?MjUyUFl0OVdFYWRhckwxYTJOS21Zb20zS0JTNmNoS0JwOWRxdTJtUGxDWlVa?=
 =?utf-8?B?ZlVRbEFnMERjb3RxR25ZMHBmR2ZWc3BOVFI1cDJvanFHMmltd1FBY1VMSlpZ?=
 =?utf-8?B?aXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: k4e2qYoWfCb8fMI+VyKNeR2pPfy5Z/HileUxg65QLt2Lhvj3/jJKw3XzhnZaDCmV2XGp7dgJGEgG7s9A+T8xSteRxg8joYCZIn8dl3DEbsL/TL/Z27qRBNcqeii726HAUygQjpSDqZx8sP0VLR/jalKrOCtKj5+ZrnF0PgXk7vuxrl5nw6pDuNicV5c2X8jSgdyY0JmWij81/7Q/NvdlfmBiWYBVfq3toI4ysRZVt6HDH5vfbgXtIDdwh2m932IKvdZzUluhTy+cXueYUhiONILElQhc57n55+zYnDWR5Qshan+MMWT9s873bKbD7q8pnIBGjhz4/iEbSLf1G8up4MgAuBEK+daxfZUWrYaObPPd5Djao+KKubUkIOsCuUV9hk4dmFJPv6Nf1utLCNZl2a/NaU1mafM5xcS+zFOHep3oTRSXX1FpH7Ea0K6NxZnwbNeQgM5zwtF7yw2bJzqGS7cSfvQY/hsBf3f2DP0WnTODrTDZag+Z+wtxKJM8gYL+O5+bMXMIbZvDp5ROmOiISQwgqjnatMRtMBPAA4/mf4xc7+y7O9bkOHeHQ2RPYD5QyJJg3Yg1ZMID5YvCdkMUQshl0v1KI41V/V9JBmxfNdY8YXJxKfy/ymSxVozuF0cS79jFI9Sb/aPJ/CSsxI2gXCSZhHgMlbZ1rK8IZGPsXKVE0UsqDxqcVcq3orYgGWOVfP6EeJMGK/IicquqvPsanJ8OnWxKRMTy3w7Ni8LaLlqS1i10jB+a9n0QVsSZGzkMIGhJWPGmh0WU6nxGJuDxhZEmtAyg4GBq9XpuIR6jww9y0rFQjwS7Qxi4vI2bxGeSvLTiqn+GMtA46o2wBrkbtyxaVPg7EWX8vEObSgwflip3AQrE8WtVsjOogzBhWE/t
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0399b302-bf9c-4ed3-a253-08dbe6c79ce7
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2023 17:15:20.9418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i6tGkyUWneErWEa42535g7SLfdQlkxSB9E2bxpf7MAC0rP+1K0ODD5lT0k/reEgDYTpQpKFObBp/07a3YGcw+VrFxpc3AjeSL9OYeRaD+rs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7790
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_18,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311160135
X-Proofpoint-GUID: vc1e_uVyMBQcG9c-xNRRlDc140v8qjVi
X-Proofpoint-ORIG-GUID: vc1e_uVyMBQcG9c-xNRRlDc140v8qjVi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/23 5:39 AM, John Garry wrote:
> On 14/11/2023 01:37, Mike Christie wrote:
> 
> Feel free to pick up:
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> 
>> +    the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
>> +                      RC16_LEN, SD_TIMEOUT, sdkp->max_retries,
> 
> BTW, some might find it a little confusing that we have scsi_execute_cmd() retries arg as well as being able to pass exec_args.failure, and exec_args.failure may allow us to retry. Could this be improved, even in terms of arg or struct member naming/comments?

Will add some comments.

Martin W, if you are going to ask about this again, the answer is that
in a future patchset, we can kill the reties passed directly into
scsi_execute_cmd.

We could make scsi_decide_disposition's failures an array of
scsi_failure structs that gets checked in scsi_decide_disposition
and scsi_check_passthrough. We would need to add a function callout
to the scsi_failure struct for some of the more complicated failure
handling. That could then be used for some of the other scsi_execute_cmd
cases as well. For the normal/fast path case though we would need
something to avoid function pointers.
