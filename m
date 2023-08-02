Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9ED9C001E0
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 19:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbjHBTvU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Aug 2023 15:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbjHBTvT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2023 15:51:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33D3E5C
        for <linux-scsi@vger.kernel.org>; Wed,  2 Aug 2023 12:51:17 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 372HJ1bS020872;
        Wed, 2 Aug 2023 19:51:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Uji72pvm/puFh5sI0tYvAzGhMsuqvsI4akb9rS6YeZw=;
 b=D3wDSP7pfjtWi2sbbjux4sgVW9wD4YlJYHCvNPC+w/BgrLswY1LvbXxX3P/Ifd/nHu4A
 ZKNtxlglsaa1UyMBJjN1Yfo31BNg66QjuzJrkjQre47YTCjRrgvTI11mvEO7oNs8O6Rp
 OHrLPo4BFhWFJe9biW0/QKruZeIKdf89T2x9zbHUQNQZyZQS9LTG602Qg45tQCeMLxaJ
 OQ+ZWW7YJfC1z+gAJLceaRDzwXNwlVsnN4mb6MjErMXM5Y+lJj2s3S8ZfdBFa1V3HzcD
 X1rnVztSgUpif1yj6qU6WqfAg2pbxJQVs9Dilewoj/s280dEyId/UyyQ71nv5OSb4YlL Ug== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4ttd86xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 19:51:14 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 372Ig0bw020534;
        Wed, 2 Aug 2023 19:51:13 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2043.outbound.protection.outlook.com [104.47.74.43])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s78mmf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 19:51:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7bIbzNz6zC79xIN1cRUnKhKEAqZku5YhOSrWD/5ah8Ai+A7pmGtBJmMPZMuoTKD4CYNzuOSSsERcO3FCqqjeQLjb+zdJzRexaPLN7E20ZmI0LDHhmKOVjvI/tQs6g5nAn4Cvie7feaSjmqcDWYz3V2Mj2R9CoBwX4AydAbEumBJxJ1SbGej0PgahQLxjjbg/bKHaOWoAqzSVkcC/9mbpCYorflZNDUVhFviklU3vyvJ1b42dTwmApogE5M2QcDgiebRTewJQq4RjgA6tfQwKlk59wgqDzgq2ZtcvyYiWsVBURBNwiPbcYihFObuqfhRync2Oo1TKsR7qLhmp2ztrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uji72pvm/puFh5sI0tYvAzGhMsuqvsI4akb9rS6YeZw=;
 b=Xa6WEbSHov2zM1LhCG6tlZTHLcKngUg5obISRngW0CG1gtknJOdS6EaT9qgs2r96FqqMEXGMCN5dPbvfM4V4uINhH/qW4RmeDr61iNUU/sfhEHE63tt3Ha67PNuhlnnLmx+wHRQDqdaTF5AYRuwJDlmwnUtDOUxzU/vlU85FftAXQG180/lsOlP15yjv5BVidw87T2+QM1VGJQlUiTb4/sxV40X+Rw3/903WsdxwSJEE1y/2M0jcj7m8jlPwWQHrXSm2S+LKMJK7SNPQGy6DQCZ7qGcP+WS4QEWCCdFzdZV6+KTefspdsmcFksG39IEbGa8u4qEfXbQtdnZe83p40g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uji72pvm/puFh5sI0tYvAzGhMsuqvsI4akb9rS6YeZw=;
 b=p+Ce6j2sRL2KSmTbSk2hmmOI4b4WfmumbQWBzZRGlthcwHwSNd36E20GRUVTn0IA53cwWfrChOBziHzAhFEDSn242YotNzEzrDjdzaYiw7PMavBvzfN7XYE7LBFJ4TeQrR0qmU6E2iAxEspPF/736dtZZqTchbHeTAjh2VbiY0I=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA1PR10MB7830.namprd10.prod.outlook.com (2603:10b6:806:3b1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Wed, 2 Aug
 2023 19:51:10 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::31b3:ba23:4678:9f5f]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::31b3:ba23:4678:9f5f%7]) with mapi id 15.20.6631.045; Wed, 2 Aug 2023
 19:51:10 +0000
Message-ID: <3b5e9b02-785f-240e-5da2-2c2fd0bda2c1@oracle.com>
Date:   Wed, 2 Aug 2023 12:51:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 03/10] qla2xxx: Fix fw resource tracking
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
References: <20230801114057.27039-1-njavali@marvell.com>
 <20230801114057.27039-4-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20230801114057.27039-4-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR06CA0002.namprd06.prod.outlook.com
 (2603:10b6:5:120::15) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2943:EE_|SA1PR10MB7830:EE_
X-MS-Office365-Filtering-Correlation-Id: b3d78f52-6e79-4199-e585-08db9391d1f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Akcm2jnNMZwGNPwUyTi4XrkuWkaS5yAejmiIOcsInLj7d64HqQfQOFPJX/UvlOE0N5YNRnVre1QL6PgTK+9W2VJBuCMi4cPK/q7Lgwbo6I/5yGYWD2j9U/1EnSYhwAhUkmxwbx9QGjF2Kg40bbF91XyVWhKTtjipLgjj/X329Ktmyp+qzxBpb00LTn7+VE4y0ktvcfeoZ2LfbCJqPdgLHw42Vkwmjwq2+UZSbiTZcZrrDtkaAp3ObA4JKOYkJe7huomTpEXtUcJqSHNabx7MayqpjkeqcFcvXnnrzLcWb4UrYKHHt/3vBSSjzzlhX/3txb7qFeUIzdBAT26ace8D/tUlZHLAqECx+Evp6Iu9cb78n1h34EI9HA7NRVWvXst0qhaJrvCG85CIZWeOjtUrgkR6KO1QiHvqQkoZ+D8fyTGXFa99gQby0eDr8K6OjpH68AjfriGAR5ZHaAmfwZX8TR91+NMVrvFqCVRdvnToygqIIHwVvT9h08on8ocAVUlS/3JvR39/AcXAnlMQHDf22VjSe1dadg9DumvZrhBU9vfSpyCLaOAzrH7o9KQ6bHYzO0xMEeSjFR/96YZsR36WEuv47w56+oWtKNVewfjzvX3kidBKLGF4msO1i8y2Aqs0xAWstfBv+uGwit5S59OjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(39860400002)(136003)(366004)(451199021)(36756003)(86362001)(31696002)(478600001)(6666004)(6512007)(36916002)(6486002)(8676002)(8936002)(41300700001)(316002)(31686004)(5660300002)(6636002)(44832011)(4326008)(66476007)(66556008)(83380400001)(38100700002)(66946007)(2616005)(186003)(6506007)(2906002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amtzTEQ2V1J5ajhPSkRYdlJwMXVZTUhEWWZUdkt4dHBkVlJqSTNVb0dyRmFi?=
 =?utf-8?B?alNjeEoyUmRNRlhEQnpKaGUzSVdCdjkrYkdtWFJuSDFrdzlwTFp6STJ4blRH?=
 =?utf-8?B?VHBhT1VUWXFYaFRYdW5XS2NXM2xaSmJSbGlVTW1PZ2JuUGlUSWRiWlhjM0g3?=
 =?utf-8?B?c2lKZVpnNmpBakx5ZVRnM0s5c1QvdTRGVzNIaDFpQVpFSTIzc1E1OCtKSUdB?=
 =?utf-8?B?NVUvdVl2WUNnTkdXbGpndkhpdlIwN2pneWNrc2E5d0poRFpOcFpXc1d5elN4?=
 =?utf-8?B?b2RsRzVCb2t0Z29ORzhDT0RQcXJoaGEwZWlzTjF0eFFDOFBYYVhyM1E2ZG9I?=
 =?utf-8?B?YjE2YjZkOElQWWZtS1M1WE1hR0I1VXdxK2E2UlFxMkpsVXZDTmZyVFl6OTBX?=
 =?utf-8?B?K3pxV0VVL0IxR0hrb1hyNVNuNzVvS1VKZFBaYjZUbjhBNlp2MndUVVpxQ3ps?=
 =?utf-8?B?Wi9nbFNncHVITk1XQ0ZkN0ZsWVdCbnVPc2FRWU51YkhWUVdjUUNodVZTQTdU?=
 =?utf-8?B?UU1uN1ZEMk5XYjlldmRmcDlqNWFObVpXb1pGL0VKb0R5RjlTL1ByY09FMDdn?=
 =?utf-8?B?cHFzbVdOTDhkaDFFclMvQVJ6WTRXQlZPcm1iU0tQbmxNSW1KcUxXb3Z4MmI5?=
 =?utf-8?B?dVhkL3Y4cXA1c0NSYjhJc0lxQmZoWEVDUXJZdzdrS2FFY2ZaTUZhRlYzL0x4?=
 =?utf-8?B?REpMUGVBL2I0SENmdTBsZmY0ckl4Y2xxVTZDVUdWditjSXRVTDQ5OGh0amlG?=
 =?utf-8?B?SVRyYnc5REl6dzlucWszZnQ4OTJLUG5NNUZDL3o0aTlBZUg5QUFEOFNCbmds?=
 =?utf-8?B?UFZYRk1QVWQ0UWFoaDJFTGU2STNtYVlCTXdrc1hIWDJ5UkhCWGNLY0F0cEVC?=
 =?utf-8?B?eDNtZ0dmY2s0TGQvaWhuT3NuL2N4M0tpNWFtaUpURFhiUXpTWExOZkY1eExI?=
 =?utf-8?B?S0orejAyMnZMVVM1NDZsaXJ0RVpLcndkRnVIV0JSNlN2OHlobGYvTHpXZkdk?=
 =?utf-8?B?aXVuR2lsVFYwWFJabjJlY0l0bERTZDVzaFpScGc4WXNaUGNIenh2VmtqMEVJ?=
 =?utf-8?B?MWJZVktEdHZuR3JCLzFlU0g0MGY5QVdtcUFPZDc2enJvejBROEZJUExnQVds?=
 =?utf-8?B?VjBMMlpJVTltMVRNMkxtQnNuUWFveHp0VWlMeEtBcDl2U0ZZVURIWjNJWnhU?=
 =?utf-8?B?SlBVME5BQXJNNWprajIxYkZvb3plSVRmQVVYN0NUeis3YzZ4MW12ZVJPK0VJ?=
 =?utf-8?B?VENHKzJqQzRNSWRTS1hwZngrME1QaTdYMHkxSHNaUGZORFFZOHkvbFp5cFNz?=
 =?utf-8?B?bFdJY3g1UWxqckNkT2dvYm5PL3hDbll3U0lzSHcxN2ZLaTZ1WXlxWXlsaHYr?=
 =?utf-8?B?QjJ5djJnL05oZC9DKzF6YVRXajI4Sk9HaVV0MjlUejZRdGdMRFRjWFZwR2Q1?=
 =?utf-8?B?QXpsYnduTDRudGNJbDhqbGVUY1J4MDlydmRYaU92UlhwL3ZaY0J5SHJ1czJv?=
 =?utf-8?B?OXRzSTBTdGxpWEszc1kzM3ExNjF0L3ZsL3lTdHpzSHlZWFpDWHRBc2JqRlFW?=
 =?utf-8?B?cldIR01JUkZRQnRIWVdoVm9vQko4UjE4SEkzTFgydjZPd0RwM091Vi9Cc2lo?=
 =?utf-8?B?V0pXVWxOaUlHOEtRMW92YmpDSkllRllXYVgyakliVzdFcUJvYnppaGRjdnZY?=
 =?utf-8?B?NWx1WFE1VzZmd2cxa1N0amJTYnY1OXFIOHROVWVnWFFReGxTUXc0S1FTS2pm?=
 =?utf-8?B?Sk80ZVM1UkhkSTc3RkpPZVJpT1BSRlFEVU1tNW1vMGhJcHZIS2tycGUxaVRB?=
 =?utf-8?B?Y3RJR0xEeDE0U1BQRU5KTzViRExScFJ5ZmIyYmhKclJaQ1EwRm41am1OUnIv?=
 =?utf-8?B?bmdYeTRDWVlqNnVtNXZYWC85eUZMdm1EMkVkKyt4elJhcVJzNUpJT2wrNWN1?=
 =?utf-8?B?MWJ4RGFsTkRDT080SGFhWXdtNjJodDVMUzdZWTFQWTk1K2c2Z3I2dHRFOFV1?=
 =?utf-8?B?Zi9zMEk2aGJlelJmY3ZDWk5OOEw2K2cxcEI3MVVtdVBiRERDL2Jjem9WcmdO?=
 =?utf-8?B?RXg5TnZ6cFUrWVczWGcxOHpzdEtESUxjRnUzWHNFWUhPRkE0VnhqUHFJZ2ww?=
 =?utf-8?B?aTJscXJkeW1qTFJYZ0VaaWtVR2RmWnB4VFlzSG1RRWY1R0dwR3l5N2tqaWFI?=
 =?utf-8?Q?Ka2N78j5tHeI+w/WqE9YyQ8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Y2R1ZH1Op+JQhJj7fVUmDbzJG7ICJObvyiYt5RR9iLhqZdyPUDC1djscehdbchagZ4KjJAS4wMq3N/Si6vBPCPwiO64E+8tog00cu1zCmaCOZUO/8y7w+X/vtN7aXhp2mhSB6XF62/iXvjdkvQtO8bNeDCZjz6DpibLslYD8UFraz0aFIcnND5hSFvfvxp7zQ5G0G1sVOiKCVbCoERo5lvb2xEXxixiM0e+IcVC6IEbUrqgkDaKZjK1A06h6nenOz2cQ1fdcpn3xncNfgqsFecZHL8QUiclFnEZ4VkeiTnXjlbF3BkBGuBW+PprE4FdXQ4XMqKuO8peACrOxufq5YIzEG+K08e2h1aFbjsF4Ml4FGMerl1cLGpKcBCdx0OcCGpuRVqYSn6HZdXVgJyJrT+VEp56taxzkFRSnHLe7x2/SmLggJrBidrYAV4hQ75wG5fZ6kMO5kbgBCu0/J7CxE1s1UkzIebQuVdDZ4yTHjGfEG9YxfKbyBWQGhMii0gETTf7/VAF7pfx7Y6Aqtwt5VSTcZWXybfSbNjct/pSDZKKoMuQwmU5kcAugbDczn1zNvrDSb4n2yYdMLCWAX7wT9oQSQrMCjI8+d9WJxsvMMUDdoa2Uavlwuyw7ARQOjNzBV1lWPNVIqmZ8FCgBEDJGKCmF/Rif9VAjxRYV5RWEgwR9gAruxuIoCeM+8FGLHbUzUVW24LqmRDgdl3WnQ4dSkTDLcR57XxZQicOZANzs07QGj5Xy3U9MspjspOOwvBdcTihLBU74GyWdqzGLLcSkCWZcl2qZ6F95EsqSkRAQWYo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3d78f52-6e79-4199-e585-08db9391d1f6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2023 19:51:10.6848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LfrCBmvibMGpDYO5St1t6YiPh7k/Z46mVncpWgTN4la2qaBMj6Ox1HZySxjgOzhzw6Y8sfNO0v+Z2tywen63OmUYY6QZ+xxoriJ8d8X+PC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7830
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-02_16,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308020174
X-Proofpoint-GUID: EU3untnei5Nda6Los3xY_43TTJ_uRqcg
X-Proofpoint-ORIG-GUID: EU3untnei5Nda6Los3xY_43TTJ_uRqcg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/1/23 04:40, Nilesh Javali wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> The storage was not draining io's and the work load
> is not spread out across different CPU's evenly. This led to
> FW resource counters getting over run on the busy CPU. This
> overrun prevented error recovery from happening in a timely
> manner.
> 
> By switching the counter to atomic, it allows the count to
> be little more accurate to prevent the overrun.
> 
> Cc: stable@vger.kernel.org
> Fixes: da7c21b72aa8 ("scsi: qla2xxx: Fix command flush during TMF")
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_def.h    | 11 ++++++
>   drivers/scsi/qla2xxx/qla_dfs.c    | 10 ++++++
>   drivers/scsi/qla2xxx/qla_init.c   |  8 +++++
>   drivers/scsi/qla2xxx/qla_inline.h | 57 ++++++++++++++++++++++++++++++-
>   drivers/scsi/qla2xxx/qla_os.c     |  5 +--
>   5 files changed, 88 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index 5882e61141e6..b5ec15bbce99 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -3770,6 +3770,16 @@ struct qla_fw_resources {
>   	u16 pad;
>   };
>   
> +struct qla_fw_res {
> +	u16      iocb_total;
> +	u16      iocb_limit;
> +	atomic_t iocb_used;
> +
> +	u16      exch_total;
> +	u16      exch_limit;
> +	atomic_t exch_used;
> +};
> +
>   #define QLA_IOCB_PCT_LIMIT 95
>   
>   struct  qla_buf_pool {
> @@ -4829,6 +4839,7 @@ struct qla_hw_data {
>   	u8 edif_post_stop_cnt_down;
>   	struct qla_vp_map *vp_map;
>   	struct qla_nvme_fc_rjt lsrjt;
> +	struct qla_fw_res fwres ____cacheline_aligned;
>   };
>   
>   #define RX_ELS_SIZE (roundup(sizeof(struct enode) + ELS_MAX_PAYLOAD, SMP_CACHE_BYTES))
> diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
> index 1925cc6897b6..f060e593685d 100644
> --- a/drivers/scsi/qla2xxx/qla_dfs.c
> +++ b/drivers/scsi/qla2xxx/qla_dfs.c
> @@ -276,6 +276,16 @@ qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
>   
>   		seq_printf(s, "estimate exchange used[%d] high water limit [%d] n",
>   			   exch_used, ha->base_qpair->fwres.exch_limit);
> +
> +		if (ql2xenforce_iocb_limit == 2) {
> +			iocbs_used = atomic_read(&ha->fwres.iocb_used);
> +			exch_used  = atomic_read(&ha->fwres.exch_used);
> +			seq_printf(s, "        estimate iocb2 used [%d] high water limit [%d]\n",
> +					iocbs_used, ha->fwres.iocb_limit);
> +
> +			seq_printf(s, "        estimate exchange2 used[%d] high water limit [%d] \n",
> +					exch_used, ha->fwres.exch_limit);
> +		}
>   	}
>   
>   	return 0;
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index ddc9b54f5703..7faf2109228e 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -4214,6 +4214,14 @@ void qla_init_iocb_limit(scsi_qla_host_t *vha)
>   			ha->queue_pair_map[i]->fwres.exch_used = 0;
>   		}
>   	}
> +
> +	ha->fwres.iocb_total = ha->orig_fw_iocb_count;
> +	ha->fwres.iocb_limit = (ha->orig_fw_iocb_count * QLA_IOCB_PCT_LIMIT) / 100;
> +	ha->fwres.exch_total = ha->orig_fw_xcb_count;
> +	ha->fwres.exch_limit = (ha->orig_fw_xcb_count * QLA_IOCB_PCT_LIMIT) / 100;
> +
> +	atomic_set(&ha->fwres.iocb_used, 0);
> +	atomic_set(&ha->fwres.exch_used, 0);
>   }
>   
>   void qla_adjust_iocb_limit(scsi_qla_host_t *vha)
> diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
> index 0167e85ba058..0556969f6dc1 100644
> --- a/drivers/scsi/qla2xxx/qla_inline.h
> +++ b/drivers/scsi/qla2xxx/qla_inline.h
> @@ -386,6 +386,7 @@ enum {
>   	RESOURCE_IOCB = BIT_0,
>   	RESOURCE_EXCH = BIT_1,  /* exchange */
>   	RESOURCE_FORCE = BIT_2,
> +	RESOURCE_HA = BIT_3,
>   };
>   
>   static inline int
> @@ -393,7 +394,7 @@ qla_get_fw_resources(struct qla_qpair *qp, struct iocb_resource *iores)
>   {
>   	u16 iocbs_used, i;
>   	u16 exch_used;
> -	struct qla_hw_data *ha = qp->vha->hw;
> +	struct qla_hw_data *ha = qp->hw;
>   
>   	if (!ql2xenforce_iocb_limit) {
>   		iores->res_type = RESOURCE_NONE;
> @@ -428,15 +429,69 @@ qla_get_fw_resources(struct qla_qpair *qp, struct iocb_resource *iores)
>   			return -ENOSPC;
>   		}
>   	}
> +
> +	if (ql2xenforce_iocb_limit == 2) {
> +		if ((iores->iocb_cnt + atomic_read(&ha->fwres.iocb_used)) >=
> +		    ha->fwres.iocb_limit) {
> +			iores->res_type = RESOURCE_NONE;
> +			return -ENOSPC;
> +		}
> +
> +		if (iores->res_type & RESOURCE_EXCH) {
> +			if ((iores->exch_cnt + atomic_read(&ha->fwres.exch_used)) >=
> +			    ha->fwres.exch_limit) {
> +				iores->res_type = RESOURCE_NONE;
> +				return -ENOSPC;
> +			}
> +		}
> +	}
> +
>   force:
>   	qp->fwres.iocbs_used += iores->iocb_cnt;
>   	qp->fwres.exch_used += iores->exch_cnt;
> +	if (ql2xenforce_iocb_limit == 2) {
> +		atomic_add(iores->iocb_cnt, &ha->fwres.iocb_used);
> +		atomic_add(iores->exch_cnt, &ha->fwres.exch_used);
> +		iores->res_type |= RESOURCE_HA;
> +	}
>   	return 0;
>   }
>   
> +/*
> + * decrement to zero.  This routine will not decrement below zero
> + * @v:  pointer of type atomic_t
> + * @amount: amount to decrement from v
> + */
> +static void qla_atomic_dtz(atomic_t *v, int amount)
> +{
> +	int c, old, dec;
> +
> +	c = atomic_read(v);
> +	for (;;) {
> +		dec = c - amount;
> +		if (unlikely(dec < 0))
> +			dec = 0;
> +
> +		old = atomic_cmpxchg((v), c, dec);
> +		if (likely(old == c))
> +			break;
> +		c = old;
> +	}
> +}
> +
>   static inline void
>   qla_put_fw_resources(struct qla_qpair *qp, struct iocb_resource *iores)
>   {
> +	struct qla_hw_data *ha = qp->hw;
> +
> +	if (iores->res_type & RESOURCE_HA) {
> +		if (iores->res_type & RESOURCE_IOCB)
> +			qla_atomic_dtz(&ha->fwres.iocb_used, iores->iocb_cnt);
> +
> +		if (iores->res_type & RESOURCE_EXCH)
> +			qla_atomic_dtz(&ha->fwres.exch_used, iores->exch_cnt);
> +	}
> +
>   	if (iores->res_type & RESOURCE_IOCB) {
>   		if (qp->fwres.iocbs_used >= iores->iocb_cnt) {
>   			qp->fwres.iocbs_used -= iores->iocb_cnt;
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index a18bcc86a21a..7da13607e239 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -44,10 +44,11 @@ module_param(ql2xfulldump_on_mpifail, int, S_IRUGO | S_IWUSR);
>   MODULE_PARM_DESC(ql2xfulldump_on_mpifail,
>   		 "Set this to take full dump on MPI hang.");
>   
> -int ql2xenforce_iocb_limit = 1;
> +int ql2xenforce_iocb_limit = 2;
>   module_param(ql2xenforce_iocb_limit, int, S_IRUGO | S_IWUSR);
>   MODULE_PARM_DESC(ql2xenforce_iocb_limit,
> -		 "Enforce IOCB throttling, to avoid FW congestion. (default: 1)");
> +		 "Enforce IOCB throttling, to avoid FW congestion. (default: 2) "
> +		 "1: track usage per queue, 2: track usage per adapter");
>   
>   /*
>    * CT6 CTX allocation cache

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

