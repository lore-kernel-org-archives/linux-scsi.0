Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E0F8C61DA4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 13:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbjCFNL0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 08:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjCFNLY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 08:11:24 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FDE2CFC1
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 05:11:11 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326CxPtq021967;
        Mon, 6 Mar 2023 13:11:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=KbOiDsXgl1AkBqPd81HSjCQKg0c3wguk+npvl6TCItA=;
 b=NPqgbMiQrDFLCPAwyQ/UNMFbGUlPWDY4qoSB2lzJBhvymMVXNQENXg4NywTchTmjiMwU
 nUasQhaETSjKiJXR3RxJIAuA0ONfcrjCSn7j+eKZo+yXLw1Vz4ZJ7CLaG4KEqJNrELnR
 g8spxysP1ClrSsLHMhuUsVhuIzP5TlaUfi3g9gkmC0tVafBc97oqdolZf5/0C7nv0H+f
 lGd09gmVm1Vn3OgaYIe0hBhvM8NMhDGSuVA6Y14rt2t058HWaB/EII3S1/nzsjpF/TUc
 tANPdpfuo9AjqLBOfZIRNVAcHlsyWrenUIQOqKzMWJcccqbi1ZLZc/j5f9FAIZqpqHl+ wQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p418xtug4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Mar 2023 13:11:06 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 326BwLoI029145;
        Mon, 6 Mar 2023 13:11:05 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p4u1dfm3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Mar 2023 13:11:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXp1YuepWYKi8AmD+SBighFl/GFnNicmScNxueurmPFwYi9yN1UOzUSceME2uUIkis9n86njwgWzcFIYzI58tlRtmkwVq7Ep7MmSxRPPWKtVQTtGHmOVzv45E/FO1JS/jCa/TX73W86pJD2HJeZd1aZrtm0ogl7ieFprcCEBwawdQCDLtrnc3GT69Eg2zlEvrJpYCOHpR99fYb2yTvebNZo3mrVSjT0qHmaaLpTwmZfaozdtUfU8KMcjQmusI+phFbIzqbsiLoxnYnXWsRFCHK9QWO1SxBgKEvpF6ZLUQV8KXjzqa2R4lymtn/vtM5tLrz5BukUV1/R/nY29LYCnIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KbOiDsXgl1AkBqPd81HSjCQKg0c3wguk+npvl6TCItA=;
 b=j/gefeyC2sS4YrIUqgkHijhJ3auDM3Bpy4P2XOr9xcSwt3kXGs93ipBxwxlibYlmIAZNZrKpDl3mkcnQqJHFftgfYT819/rwAb284xQjvw0geYUm2AtKTc0z0fYtmDl5cA0BEjsw4jRMZeCkUcb+2g1D73NjUBsT+3PsNzNIQNcPlCdv2s/ikBqXPGWkzXyRX8434V9lGxymZMh8YjEDRkkYjshoHSvUxzyZLVeuwAt24k9/FamTAMp4V4yjeqqCkog1lFDY8oDrH+Uf9wpRlh8Ze/fWZ3S1D5KVLD0YmWDUajVvlgjUzikxGtxr39c1DTN0hOZ4AV0bJft1Mpc7+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KbOiDsXgl1AkBqPd81HSjCQKg0c3wguk+npvl6TCItA=;
 b=Xl1FySmXHzDxG1Due56shbVuVnxm8RMPK9kxcSQGmGwsv63w3neP7bpGFlNyNuPSKDPaNrh1QAX1N4vcUt5ZwEsiaospwSTQXqPBNeIRQG58AdGgt+G/zKQ9lE2cOJv9leMW7yGJMMrrdUQ5+4tiGMK7akJ45xiKCvgAj+WPIjo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB7168.namprd10.prod.outlook.com (2603:10b6:208:3f0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 13:11:02 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb%4]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 13:11:02 +0000
Message-ID: <fb29154c-fdac-8b45-1e8a-4b4e732e4dd7@oracle.com>
Date:   Mon, 6 Mar 2023 13:10:57 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 01/81] scsi: qla2xxx: Refer directly to the
 qla2xxx_driver_template
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230304003103.2572793-1-bvanassche@acm.org>
 <20230304003103.2572793-2-bvanassche@acm.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230304003103.2572793-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR05CA0011.eurprd05.prod.outlook.com (2603:10a6:205::24)
 To DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB7168:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b59043b-e244-4aa4-dfe0-08db1e443c92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q4wKgMGyyDuFzJ5ZSgyTzuhBfugjW7sO4ZSVG62E38efEQKkASOQleDya913VrGfkK1xhPJQIlB0TCMopZK05zFcKKrYktlFYkGYXt40QhR8wxi01KOXNRQQ9P8l/2onjD8BYUK+2mJTP6HqyH8Rde6K/xWMHyQcNau9WYBQ/MZtDXk1hoT3Cy/clampUi8y5TQ0mkvRDXVRUVEVKIYeQmehynfQ0+GlyoEJf4S+WdEKVJ/OydfikSE8QuAIApedpf7ruzp5v6HTjZLa3Nv5hetDUIq2vHi/YehTMDamrpNQcSELxb5JmGhH65PFP336zcolba8yFrnb3p8vRnqL6MxHiFb6OCO7ZJaoBkIJCHA5pSqhS7XbVJdEsYgrRkNSoH6HeJmOkNBUpUqCHOnOWlqwwaEg+XtYYu0nTA5Wyern/OVXYINego8DGoFOliETrbNNNeSslhWhVqSnwJHLNv3EhWYGJjuvSyZVi36OyUshoU6xBJ3PiHmZasF3pOu1Y7X6sFJe7A3X+TaUy96+sCIF4ovZEsLlrTdls0Q3lMLHkRUahn7tvLO/U5eHiipBaqrNjkLrqhhCqIMs9UzrFYTY7XoEW+SpfnfI/NP2uGwo5c5I7ubs/62AL6oXJFJdGaulzs9ZIxkGhPO4YZDc5EJvOCP8QBpLp0EuUWT5eHg6+zxlEQpydIUfEN9/1S8kn+OnOoqm0RBAXfxJAiMh3zZVdSHAeCTMp2DP0uWTRBw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(346002)(39860400002)(376002)(396003)(451199018)(31686004)(66946007)(66476007)(8676002)(36916002)(54906003)(6486002)(478600001)(6636002)(110136005)(316002)(5660300002)(41300700001)(66556008)(4326008)(86362001)(31696002)(36756003)(186003)(26005)(6506007)(6666004)(6512007)(38100700002)(53546011)(2616005)(83380400001)(8936002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkY0UHpGV1R1aHptUmxHeFA5RDVqS2tpQUJyNUMxL0dYdTh2UTFBZWxSbTJa?=
 =?utf-8?B?REJhRzR2eVAxWkVrdUQxZXlvU2RrUkoxMDJ4Wml4ejJXbzJSWWI0Y0EvbkQ0?=
 =?utf-8?B?QlFEQzB0UlFvWGxRM0dHSG0xOUZCTmxLNUpYbzBUVHZDWHlubE8wK2V3RUlI?=
 =?utf-8?B?MVFLVFpDSFQwY1R3a0ZpcjlHcXdDOXpoMVUxRnVBY1BuNlF1V1lkV3RqMUZ0?=
 =?utf-8?B?ZTMyRWJOTmZobGdwZW04L2EwSWcxZjJkTS9hamxXRHcwamY0TVRqd0pVMVk4?=
 =?utf-8?B?NHBnR0p6M2dVWldLSzJFaTc4UXAyci9WQkZmWUV2T2srQy9Jbzg3K3htaW9m?=
 =?utf-8?B?STk4NU0rUGVzYVE1Y1Q0YTdCTzNLNFJnTXpPSEpZd3lnczJxOWV3d1pkN1o1?=
 =?utf-8?B?eXl6cGpKR1RoYUxRblp2Y2h0SjFwQVlHbFZlbHZNZ2NtWWFRSDlaVWF0VWxr?=
 =?utf-8?B?cmxKOVZ0SnE2RnJzTFozTWtKejhNMG5nNk5YUWZaYVcwNldxUS9ZTCt4UXFC?=
 =?utf-8?B?V1QzV1lIcFEvTWNPMy9XMWtwaE0vQ3VsR3dkNGpxNVJBU3BZQmtLMjl0alpL?=
 =?utf-8?B?eitUN1dwNU9PdjAwc2kvb05IdENCTVl1RkVUL1ZGbENmbzZnRno5c2RySCtD?=
 =?utf-8?B?TEtvU0N2Rk9VMFFxMnJzNEoyaU5nTDNKNmFUbXorZ3ZYbE1sMXNVWHNQTUV1?=
 =?utf-8?B?WWdKS294NnFydmgxQVVuRkZoL0Z0TEVlVlV4RVpoZmh3V0JETmV2b0k1NEor?=
 =?utf-8?B?dTBBQjc5Zk5FeWtWQmxyVEtxWkxXVzVEM2JURlovWDBDSzhFVEp2NDRCaVRV?=
 =?utf-8?B?UHN2ZzYvV1pxQTFHeS9hSzRNa3Y1ZyttVHd4amx4Y2s0ZGoramh5OFNmQncz?=
 =?utf-8?B?VkUxdXlmUjR3ME9HTHJlMituU2lVUUpHc1QwVnI3MlBtbXVETTViQ2ltdjhY?=
 =?utf-8?B?TkM2TUhQSHRROUE0K2dSTE5pUEpwa1M1UWdYRzl5MjF6bnlzRzF1Z2dza3VG?=
 =?utf-8?B?U3BuaUxCT2UzM0pXRVV1YUJkc0pkTU05aExzOG51QUhTM2NES1BJVk1iK1lh?=
 =?utf-8?B?NGlxcTNQTlBQZHhUc1hHS0JLVUtHVlpYMmtPS0JNOGF2QVRYd09EM1REeXND?=
 =?utf-8?B?Uy82SzFQY0JwdVlhY1U1RXZtaVMxR1BWWVpCanIzZ3o2ZCtDVGRaYUZNTnpr?=
 =?utf-8?B?YWlFc2YwYnBDWFM3MlNIc2tQVWRBZUZRUWx4OEJZTXYrY1h1N1czWGN0a2VE?=
 =?utf-8?B?eTYrZ2lWelFlaFR4RlFIUTMvN1Z1OS9HV1Fmeld0K2ZBNE9ub2VCVVNHZ0VY?=
 =?utf-8?B?MXdobytYcWhUMmxYdjFtU0J4L2wzSThRUUhKRjBpZDlZQk9HTENXYzNuS1hl?=
 =?utf-8?B?VE5LMkZqbi80Ukx0enMyWlNBemh4aGpoUkNrUzNEbW9ZVE9HUDJhR1UyYnlE?=
 =?utf-8?B?ZTlONWpPSm54ZWYwWS9HWjJwNkZWRnlzT0xKUkdVOVB6NkFGUW1xa1pIZm43?=
 =?utf-8?B?YTJWdDlOaUNNQURkc3pZcFNZRWk0eS9wWW45NUR1QVhhOXcrT0JCNkovbDFF?=
 =?utf-8?B?SXZhUEFEWkZkc0ZOaE9wN0F2MERWVkp1YTY4cE53Y1RPclpYVjJ2RGNqQWw1?=
 =?utf-8?B?akV3bCszenhiUE5pajJMQTRSMERFNjh0RDB4NTBSTGtVR3lHWjlmMk9TWnRh?=
 =?utf-8?B?a1AzVWZGRU9tWFJOWFN3UUF6QkFhK0ZoM1R6K0hDbzJyRS9Ja2JGYXcyVHJW?=
 =?utf-8?B?WHlGS3dJR3BtMVJ3TXBRb0NqQW1iQzgrbTRkMFYzd2RvMDFvUHkrZklUWEln?=
 =?utf-8?B?dlR6SlNGUkFldHl4Y0RGUlJxMk4zQkZjeTlHOXlwZUdabXhodTRSWVUrZ3JV?=
 =?utf-8?B?cWMvcnpQdjlXZW03aG41TmNjMWkxaEtNakhONDJMZEo2dldOa200bVoxUUpr?=
 =?utf-8?B?ZHg1ZkU1Q1diQ09XSllaQTVvQ3dJQnpYT21TTEdGNUMwMW8zZ1ZFbEZTRkls?=
 =?utf-8?B?cnJnN3JjT1YzRlZaWGpYbk1LSnB6VXd6N0VCZHlFNTFxaHU5M0tOVlNaQ25R?=
 =?utf-8?B?NjU4Q3k5VmxvSS9aRU1PRkhjTnVrMHFCcUdUTzd2cmxSanpGVVFPbFVWVEdT?=
 =?utf-8?B?TGZYRFdPZHUxUm9FMENlYmZFWVRleFRlUFBBVy9zaUdiSCtkQ2twK0hZVUVG?=
 =?utf-8?B?T1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Nw3WhX82RkxSJavPJsKxDeWH+S2z2hdqvQc1tiiKOPzBnUyEys1W6HFMO8tWEQYozJV2m0sUIfi2/tR3gDgLLYuDtsx4MXWw9zEc0ZrdyDQfQ+z5yAyRtUgJ9t0nU/JnsXZKUD54ttXnSRLKtIrHuShvyWgO1UcB3ZK2v2xy61ISaii6KL5RL78GbdS0EW2MvFl8mBcpgOwaCZeSRP9wcrr3znlOJx++2EELI0RFVrhhhNAiKUYhM8aQPS12BHqjBfH1nYt1ScOVEmj2SNTbG+QPOcLt5CtVn+eqAk4FbBxk9PDXQ/QG42svECNEJ7HJjVxQn3ldNETdP1OTZkEWBWMftBOpATCTAa1E/LcRX0e+It1xNjmSc5wZomGwDZ8uOPSWtQs7LJOoDz6w7ifj+XCpS7nn5zOWjA2lkk12W0eBmR369UuTeL00jOzlkIFWiTQ6LX7ng2D8y3zCObaWJSjQfS4PE563sEJK6FanetpC+AfEv6G324Xy3MiV4u5mMITHA4nMphQ7Hh0P6i1FvnGcEIAxu6AnJRP26qrrfnVXEh/6NelDcpYgRzloVw3TPoNgQF3Yeje9zKF1xMCaybDXYFr2SIeXH/AumEQguI3R/HkDugIscIpCrG3i7hqRkfu1OaOcybGODzyOp+8ydjHcZJVchqhk6Lq4ke6Dj8ImweiVAfvd950RWInyAhRWgCRBamm3MPuskfgLFJ5EMcJwYX5qMtTyZ9mbQLG74mlkSQWO+chEW5n7RapePt55XTu+MTiEs7hClALRU1joipQfLU1d0Qn/m20vS28UqAaueBXDHvmyGFHZtj4kRWdll+1qofUhKg4AZ+0/qbMhecl3o4lv4ThmjFEw2mZELmk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b59043b-e244-4aa4-dfe0-08db1e443c92
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 13:11:02.7643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7+ETUD9chEX8BIjGq4LbJtJpS+eRHX7tV0ZlBZQKARQBVLPzFxcKwtWTvDmGK4SWVdPJ4QDsuN9DrVat3lRHXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7168
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_05,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303060116
X-Proofpoint-GUID: GYvplA2zw9ssPEmg8pMcJj6o_BYdOWj-
X-Proofpoint-ORIG-GUID: GYvplA2zw9ssPEmg8pMcJj6o_BYdOWj-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/03/2023 00:29, Bart Van Assche wrote:
> Access the qla2xxx_driver_template data structure directly instead of via
> the host pointer. This patch prepares for declaring the 'hostt' pointer
> const.
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/qla2xxx/qla_target.c | 4 ++--

Hi Bart,

>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index aa0cf5ca6c1c..8d9a6aa3ea61 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -6395,8 +6395,8 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
>   		return -ENOMEM;
>   	}
>   
> -	if (!(base_vha->host->hostt->supported_mode & MODE_TARGET))
> -		base_vha->host->hostt->supported_mode |= MODE_TARGET;
> +	if (!(qla2xxx_driver_template.supported_mode & MODE_TARGET))
> +		qla2xxx_driver_template.supported_mode |= MODE_TARGET;

So we're saying if that MODE_TARGET bit is not set, then set it. It 
would be neater to just always set it, right?

Apart from that, I will say that I haven't studied the driver in detail, 
but my impression is that we should just set this flag per-shost in 
base_vha->host.active_mode, and not the host template supported_mode 
member. Indeed, we don't even seem to be making this driver 
scsi_host_template as const in this series, which I thought was the aim 
(and I assume because of this).

Thanks,
John

>   
>   	rc = btree_init64(&tgt->lun_qpair_map);
>   	if (rc) {

