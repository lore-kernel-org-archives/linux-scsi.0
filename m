Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 291F3EB64DA
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 08:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjGTI6W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Jul 2023 04:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjGTIr3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Jul 2023 04:47:29 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FC5269A;
        Thu, 20 Jul 2023 01:47:27 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36K3O2SF008745;
        Thu, 20 Jul 2023 08:47:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=vgPSim/BJsTmn8Xv/woxSEdV84u8vuqxn2UZeSvmzWc=;
 b=3eKrDNVSrHYAOkMmU860BWI7317glKX3ilOv/E+RkZNv5mAITkgCNmVgwXK2rxJK8Qzy
 DmBVFdMQ6TDvdqYr5yjyYq5G/MYtkQHBDmWMVnGkhP/8bSP1EvbqqhT0JJvqFwHKbn0n
 afXXamxOIany3NvatWy4SBc0U7YZnLPb7JyYtVqy61uLf0MEiQ25+khYsCGHLk02YZS5
 AvRd8T2WvMIARbpvBDolCdGdrsnjFEie/o9Uiv+bBJ+9X+TumSLC3oOcx2kF+vvYdyx6
 wwvGoZbCx4uuu3pSMoWmgpFCRaiCFAGqwdDOlJe8fdbtEEeM/OTr+UmCKQ/QfrFyvCJH 7Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run8a9a6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jul 2023 08:47:16 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36K815Ab023985;
        Thu, 20 Jul 2023 08:47:15 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw8k44f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jul 2023 08:47:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bInW2yKtaugQjufRu9PYAnRgqssqGmcsfl9mVV68O+fe4q8pP16lwvR9y5NsC1rpJGvc9MalLoRp9myxhAadrOaO/Eh6fcrgc1Elti4yKwfiwoDD4HoHcRkDK8wFCWUEj/dLxBHRzH7pActtFh1U/HbNqQXsH+I3rLGkWR1lEtTGamLJCDZ2yAF1hLosSdhj0XQX2PMGq72SNsMygi7934gv4TAT6LlIIMk8WiMcoCXO4gPM+1ztvJ/O8PC/wgoLOYB8J01z0H5DpwPWGbngnCqR3MiWwpwbcW+IsnAi007VQvPOf/UDxvsvonqYz+QciHFzqLmoxnWJdUs9rGRJaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vgPSim/BJsTmn8Xv/woxSEdV84u8vuqxn2UZeSvmzWc=;
 b=g8v1Jdic5bXOLAaQR0icLDCiFJJKeVMbtVYD9I1RSiFPn0/N3vfqKBlAMa62jwVbFs42T0locos6JY51vRV/DGgn7M+TG7BQK928KVWTyEXhzC9h+m8bZdjuVg1VdxSxnkOWjsoxVT4QTcD7KUUQkviCjyfDZlyRI+70i/Q+ZYfsiAoK5VwcNwxvDBThrgkKS/dr3duTjoYqyTMBkqgDJdPAdWjrSmQ6vW1Z04qNRlgK2Zb/ZIEHSHiA+gK0dNIhFCykzNe/th4QBc7EWGWOdPrQWpBvmiEQqcpYci8Cy1pF7dcOwrkWYMOVeW/UPox8VBLOdVLiqpQHQ2WZLjw5Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vgPSim/BJsTmn8Xv/woxSEdV84u8vuqxn2UZeSvmzWc=;
 b=Uf9f+H4CUJl6RmSFy76cT8xO/LvOfePR0GCvnClXxx1tpHaSoqvm39/Ty1zoGXhUHXcXr8O6qFVpIvRiHRCZb+XMnlgoyNX8Ox8ldvh6IZ9pJhFptebrT21IXXVdzLTNKtiDC2vKPstEquFHdr5s0JIl8rZgKw/HP/2orqh3RYA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BY5PR10MB4324.namprd10.prod.outlook.com (2603:10b6:a03:205::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.24; Thu, 20 Jul
 2023 08:47:13 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb%7]) with mapi id 15.20.6588.031; Thu, 20 Jul 2023
 08:47:13 +0000
Message-ID: <917fcfe7-8306-0d23-253d-cb43353520be@oracle.com>
Date:   Thu, 20 Jul 2023 09:47:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 1/8] ata: remove reference to non-existing
 error_handler()
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20230720004257.307031-1-nks@flawful.org>
 <20230720004257.307031-2-nks@flawful.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230720004257.307031-2-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0159.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::27) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BY5PR10MB4324:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a5e6f4d-8ba1-4f7b-26fb-08db88fde9ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o2mZiaaXGpSUjjRX2nuV4MZYn7HuQQzKw/idt0hCq2cxe3FmxUM/aZ2WoIXsQ9cpwJ2Iwa7f9eFkYptkD6mM2/hcq0F/elNaZ6wvMRaso5/GAwfgLMhT4N8A/Mn0Zvr77qLUFI5tv/2Mpa+JyUEsW8yF475NR8d2/aKNUutGL8RQ2kJ2wLsPmUtTt9wGiUn99m8DKoZRZcpG8Ax/utsHdlmoSPUbjlbXDiL2nfbwAG93elVrVYEI093PIYbpmjzQUb7bt7smbLDC8Lq7wtsqGVdkvNzDs4fTUhI4sFDSoKrfUmuy2jPs4/qxZJODsUkC4SLKVut/cjB2ahQNcI77JCB7aRuOrC1ChSnWmEA3LWer2JvuLR8vNTlC4ZkgMNGoeeDKZHaS41oYm/kCURk+dQYvI+9KyikA5nIc7a+H7gq+cB3Z/bWeMLJpdvTle3LTdbeM6bvrbyba/3x5VbMYguFhioGnXrS9JY9q1g1Mm4hgBDRcA6F4sibhnxoeaJRH6DDYfh3yWGUQ6fyO0aixCOQeqGsvjD5ZULBXUtwiEphhdrU31BmomGrhLJ53aFIXnLHYjvBbrDdxMH/ksKcr6VRFd3w3JE+By62M9202lNFxODU20cOHcrH1aWD7FG3RX9S+3+xWbhCnbvEFMloxpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199021)(53546011)(36756003)(54906003)(478600001)(110136005)(6666004)(6486002)(6512007)(36916002)(186003)(6506007)(26005)(86362001)(31696002)(4326008)(66946007)(66556008)(316002)(66476007)(31686004)(8936002)(8676002)(38100700002)(5660300002)(2616005)(2906002)(41300700001)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjdVcWg0Zmt3MVE2bDJFQzl5WitLeW5wOFFtVHAwSG41aUQyYjBzN2ViUVJw?=
 =?utf-8?B?Tnd5SldyZUNXaEtJdlc2MGhnaUJVTmJqUmdpRWlpNURqMHdma0JtL3FEZVZE?=
 =?utf-8?B?NVJqak5nT1BuejdOU2krVjhEbmg3RVFRZWs4YW5EbW83SGpmdy9sZGRJaDdi?=
 =?utf-8?B?Rk9wdDBRMlQ2aHRuWS9aSjVhL2RSNW1wbWtGc1ByQjRwTDhmZlZCaDQ0eDhY?=
 =?utf-8?B?RTlnWEIxN21xNkQvMWRjcmtuVFNQbUhab0E5VVBpMk0zN3Z6Q3UraFJFOVZP?=
 =?utf-8?B?d0Ywc3QyRnNxVEZTMWFOTnJCTFhnVWRuUEw0YktvTnN5M0NRNm1qempqckli?=
 =?utf-8?B?TmdLd2lEV2kwcmRHM0lIdVE1MWRPSVV3MEh2eTZ1RFFjSkU4OVV6K0tHMm5G?=
 =?utf-8?B?WGhObkRIMlMyV2xxZW1qcFNTUW9oN3dhZXVubjRGUGxCc3hma3N0VzdzYm1t?=
 =?utf-8?B?T1plTmk3MXJZcTloSTRPWTNMSnpKaUdmTUlZWGd1RDJJWWR0SFNteStCZVJH?=
 =?utf-8?B?VllmVTc3WXBkeUc3bzBHdXdIQ2VHUU1aWjV6dGFXSWYyK2doWE1sd3haL1Mz?=
 =?utf-8?B?WkRkN25uWUhWQWFMc3E5ZVpLZ0RLMnZFYnNHUXlzb09leTk1SFRubVNTT2tJ?=
 =?utf-8?B?LzY0TjJlNnNDRis4bDcwU2MzZ2NlVlRNUE1xVmcwa0JqejR2YnpaUkROWm1R?=
 =?utf-8?B?dDJ5YnRHMkdYeHRsVm85aGdCellZS0JnZ3JKRjkrZXRQK252RFdlamZxREw4?=
 =?utf-8?B?VHBzZU8vbW9BUXFyS1NUMXRXcXk1c2xsMmlJNjZ0bFU2V3dzM2ZUTUZmYTdl?=
 =?utf-8?B?dHdaSHp6eU9jY3Vsdjg5bEFqRUJENkVqcjl1a1VWWno3K3QvMkwxN0dlZmg4?=
 =?utf-8?B?Uk9Yd3hFVTNWNHZFUUdhQUY2dE5yV1hnQkZxeWpJdWZ0OUNTOW1wZmgwc1Mx?=
 =?utf-8?B?bFM4STFEcE92cDBUTUJZZUVWR3NMbldEUGs3d3Z6em9GVFpQTGFXcW9iZ2hh?=
 =?utf-8?B?WEJkMzFOSlZEUVkyeEF3UnhXYzNRS0lzdVE2ZjM1eitLNGU5NWZucGNwRUpC?=
 =?utf-8?B?V3NvamVxTkQ0amdXOEMyc0JjcFdvd2NuQTZDenlwa09HVkNFc0grVXN2ZVNw?=
 =?utf-8?B?djR0SU1ZVk5UM1F4VkdicTNUc1U3TjJXRnJsUFZ4ZFA5djcvbHlyb3djTHhp?=
 =?utf-8?B?OXlabHlta0FLb3I3ZWJnYUZXNlJiYkxWMm8ydHpxbkFFSWhuMTlqb2VlbVhB?=
 =?utf-8?B?MEVoTEN2YWFHR0FHTSs1VHlvS0tzVW5aZVY5VWxwMzd1L2VVNExQdHNFeGNi?=
 =?utf-8?B?NWtMU2hiZWRlVlYySzlwRzYxb3NweWFiVXlCVHF1enBadWpiK1lwL1E0NUN4?=
 =?utf-8?B?dWJBZU1KOW9lSTkveGpsU2ZnMExWQnp6T0R0ZzZhYUNLS3pqTXpJdkFDcDNQ?=
 =?utf-8?B?MHFLUkVrYVVYWmY4VlRPdmIwVUY1UlduSnRmSmNISjVVZVV2TVpoaTN0aWp0?=
 =?utf-8?B?cDVXZnMwR2FadUVRdENwWGUyOVEycFhUTE5ZZkx1dG5Na2lKVVdBNk4wSlZm?=
 =?utf-8?B?WldJTTZibXFWczdlbkt2VnMzUStIYXVwZzBNNVhuMzF4Lzhrd0dwbFd0a2tu?=
 =?utf-8?B?ODc2alJnZ01ObGphRGVHdHhxaGVYQVlsSjR4cVVhdngyNkJHU2tyYjZOdkdG?=
 =?utf-8?B?bmV5aFFZUEJwbGxyRW5PZUFER1pGS2hzYU5aanFSc0wrUmoxazlEcE95YUtS?=
 =?utf-8?B?azVyaHRaMkx4Tk5DdUhJZnJqZTQyd0FZMjRsb2xMbzhUcFo0L1hlRENvc1Iw?=
 =?utf-8?B?cFR6VnNLRHBHbDBBU3FDdXRsbDBTN3NwTEFRdnNhcE96Smx5clIwYjV3R0dL?=
 =?utf-8?B?UndWaHZCVVV3K1JLUE9UeFRzZ2FBM3JiK1o0ZVZqc3UvWVlGU2hsSEx2WW1J?=
 =?utf-8?B?aW9Rb2E0cVo4SE1CSStVN3RBNUZLSlRldDhIRU16aUNwejVIN04xL2VlanU3?=
 =?utf-8?B?NTdNSEt2RFkvTGFsRG01citBbXR6KzlhZDZBcVlMVEU3bERnSEZXNGtWQXJy?=
 =?utf-8?B?dWxEeWhLTmtsN0l1SURQQUIrUGV4MVNBWWVYZXA1aEFjbjZSb0tGTE5PWTdi?=
 =?utf-8?B?bks5cWRIWldqSVFtYjNraE1iTzljQmhkdDM5ZG9veTlTTmJLcU01MkxTMFNw?=
 =?utf-8?B?TUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 5dEw07/iXb8iN/9fNN1RymRRQgnRT1OU0BwONHoaH5rn4Wjk+IOkhRI0PE8RKbyb7xUCl2Xc5PG2KWzQdTS0XLGsTc+q49OBgJIhRNVFDIYvgiV7IdKl1Alrz2+UHIVi3j9z1ICU/q/bt5jz5/v9+YNx+LLo/MIHReyGd79QnUv398I6XRvCkciZd/zZw9AoH2zH7ZHuoOttRNPy+ti8BrmJ3b4uWItnv3SNO5sSjBgMmMgMVYz6hBzhWhm7MgSk4i8VCTvDuzFDwdmh7p4i6fD0TrK7LuUmVeo5JcTtJzvyo+wPEMHumCa5dJnTGvCoJ4ZO+ABxur7z2WAw4EfQXp+sIHsdBkTMAhFFqrXYhN/pUAMqj/rK9ok8OLQQHP4YNjMgnNfpOlP7Qs5G7R48yHeT3y7+BQSyNjWtfpevI5hv9GOEe45UH5qsmRUh8GQB1JXZY715JaOOyp9sd6WJjhM4fk2zE10ekYNneKu+hsaSI2uFBuxav49eWDku8fuA+C3t6zYIOYq3ilyVSGxXvH2dIdizbxSITdXyNZSm9TQ+RK/Xw9WSaSfGxTP4c/Jz1qxmRWw2LTrUwUPyxOKUbUzHxTCFgf/gwVNb++eMkswMwPgLJhRVeGYvQGIsL1hTQ5nfpiUpAk5VrrVNKJTvaCgDmV41roIHXSXPtmkn1h8oCUJyu9kMDDkH2ayjcBNWmfvO02eFOcC0BrpEgg/21jJKNWi5JrjEBm1OZxEhltzmF//Av4AvgndnOdm18VZYm23Rx9tAxr9N2qva6bQDGWGt5/hUa1+4RBX3YE+nvVZAFUUi1gKU2fTLPgH7GIvWmzrRewGiWYMH5ByW0Jtpfc6trQN1Mc1iHAcW68a3Dite7eqBH85AprOL/oOnvumoaEHTJz6QZJnUcNndyuutQA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a5e6f4d-8ba1-4f7b-26fb-08db88fde9ba
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2023 08:47:13.4277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ic6rWB2jlqUqes1yoZpH29iT5LXAzAFde051kOMSQu/SMGjlDbCa771dIinqIy+50fd1RCx4WbLEBD5eUIeRVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4324
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-20_02,2023-07-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307200072
X-Proofpoint-ORIG-GUID: q2a7sHpR20uzzoe2KycOTuKHbqmEPGcx
X-Proofpoint-GUID: q2a7sHpR20uzzoe2KycOTuKHbqmEPGcx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/07/2023 01:42, Niklas Cassel wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> With commit 65a15d6560df ("scsi: ipr: Remove SATA support") all
> libata drivers now have the error_handler() callback provided,
> so we can stop checking for non-existing error_handler callback.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> [niklas: fixed review comments, rebased, solved conflicts during rebase,
> fixed bug that unconditionally dumped all QCs, removed the now unused
> function ata_dump_status(), removed the now unreachable failure paths in
> atapi_qc_complete(), removed the non-EH function to request ATAPI sense]
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>

ata_qc_from_tag() still has a ap->ops->error_handler check, right?

> ---
>   drivers/ata/libata-core.c | 209 +++++++++++++++-----------------------
>   drivers/ata/libata-eh.c   | 150 ++++++++++++---------------
>   drivers/ata/libata-sata.c |   7 +-
>   drivers/ata/libata-scsi.c | 142 ++------------------------
>   drivers/ata/libata-sff.c  |  30 ++----
>   5 files changed, 166 insertions(+), 372 deletions(-)
> 
...


>   
>   	/*
> -	 * For new EH, all qcs are finished in one of three ways -
> +	 * For EH, all qcs are finished in one of three ways -
>   	 * normal completion, error completion, and SCSI timeout.
>   	 * Both completions can race against SCSI timeout.  When normal
>   	 * completion wins, the qc never reaches EH.  When error
> @@ -659,94 +656,89 @@ EXPORT_SYMBOL(ata_scsi_cmd_error_handler);
>   void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap)
>   {
>   	unsigned long flags;
> +	struct ata_link *link;
>   
>   	/* invoke error handler */

Is this comment only really relevant when we may not previously invoked 
the error handler?

> -	if (ap->ops->error_handler) {
> -		struct ata_link *link;
>   
> -		/* acquire EH ownership */
> -		ata_eh_acquire(ap);
> +	/* acquire EH ownership */
> +	ata_eh_acquire(ap);
>    repeat:
> -		/* kill fast drain timer */
> -		del_timer_sync(&ap->fastdrain_timer);
> +	/* kill fast drain timer */
> +	del_timer_sync(&ap->fastdrain_timer);
>   
> -		/* process port resume request */
> -		ata_eh_handle_port_resume(ap);
> +	/* process port resume request */
> +	ata_eh_handle_port_resume(ap);
>   
> -		/* fetch & clear EH info */
> -		spin_lock_irqsave(ap->lock, flags);
> +	/* fetch & clear EH info */
> +	spin_lock_irqsave(ap->lock, flags);

...

>    *	ata_to_sense_error - convert ATA error to SCSI error
>    *	@id: ATA device number
> @@ -904,7 +863,6 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
>   	struct ata_taskfile *tf = &qc->result_tf;
>   	unsigned char *sb = cmd->sense_buffer;
>   	unsigned char *desc = sb + 8;
> -	int verbose = qc->ap->ops->error_handler == NULL;
>   	u8 sense_key, asc, ascq;
>   
>   	memset(sb, 0, SCSI_SENSE_BUFFERSIZE);
> @@ -916,7 +874,7 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
>   	if (qc->err_mask ||
>   	    tf->status & (ATA_BUSY | ATA_DF | ATA_ERR | ATA_DRQ)) {
>   		ata_to_sense_error(qc->ap->print_id, tf->status, tf->error,
> -				   &sense_key, &asc, &ascq, verbose);
> +				   &sense_key, &asc, &ascq, false);
>   		ata_scsi_set_sense(qc->dev, cmd, sense_key, asc, ascq);
>   	} else {
>   		/*
> @@ -999,7 +957,6 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
>   	struct scsi_cmnd *cmd = qc->scsicmd;
>   	struct ata_taskfile *tf = &qc->result_tf;
>   	unsigned char *sb = cmd->sense_buffer;
> -	int verbose = qc->ap->ops->error_handler == NULL;
>   	u64 block;
>   	u8 sense_key, asc, ascq;
>   
> @@ -1017,7 +974,7 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
>   	if (qc->err_mask ||
>   	    tf->status & (ATA_BUSY | ATA_DF | ATA_ERR | ATA_DRQ)) {
>   		ata_to_sense_error(qc->ap->print_id, tf->status, tf->error,
> -				   &sense_key, &asc, &ascq, verbose);
> +				   &sense_key, &asc, &ascq, false);

Please check this - AFAICS, we only ever pass false for @verbose arg now 
(so it would not be needed, and ata_to_sense_error() may be simplified)

>   		ata_scsi_set_sense(dev, cmd, sense_key, asc, ascq);
>   	} else {
>   		/* Could not decode error */
> @@ -1179,9 +1136,6 @@ void ata_scsi_slave_destroy(struct scsi_device *sdev)
>   	unsigned long flags;
>   	struct ata_device *dev;
>   
> -	if (!ap->ops->error_handler)

