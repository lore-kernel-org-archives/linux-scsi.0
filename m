Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7752EB64DC
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Jul 2023 15:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbjGQP00 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Jul 2023 11:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbjGQP0L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jul 2023 11:26:11 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D211710
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jul 2023 08:25:20 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36HF0W58029461;
        Mon, 17 Jul 2023 15:24:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=iFlUV7tVP59nny7i6pPn7u93Q11csTbtEzDaW/OVLpk=;
 b=Ay+VDSBzie2F3Kt2AtRMAZqOAaEdeKK0KeyP5hzXWc9FDdXX0cA1MgJ254RzOu2XnY5R
 P4NRwHh9N5Jw8b85U5nwlHR1N1aK/HHSH6jQAW8JfMA9GQXS9irbKWXaIUbxvIULn6Hp
 JwXTFE6w3yxSWX+CFMJ3B0ECZxDZfhzMQl9G/TwkFsQXTkDRwhNZ+eAJ1WT6uNBmHrkh
 BO4TRyGFlY75r7bqmo9ps4qaLcIaYJ87KsAusT364QmUJGSWgys2c+znYbG79iRWH3oO
 yy/fvWCPYkWOsiIj5HitCH5m5p7HNxXJJh5cjujHehB4wux0YL2vi0LHb/Ithh7LJwB6 uQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run89u08q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jul 2023 15:24:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36HFMYDi008009;
        Mon, 17 Jul 2023 15:24:52 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw3j9hs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jul 2023 15:24:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZbrrmrWWF0T+nai2GYpvM3rhyZ6RDcdrA0exhoVJuzObizLKicTdw20BSj486QezUXkqK/ZfXVRBXftr1UsUBwJB4c1q2cCC7XUHJ0DY/3ccWnaqEIMQUuh7t3USOgZtBxuownsWlijor1W41PNc6QUZZD6cLakwpKZm98t+rX3HJX93ihV5Q/S8ybjl4xCuWh51vY2rBlyyOwMnKffRGbMaH/5lKdeJKgiAgUgQBcRaPHkiW2KYgLhln66f8Ic36bGHlBtXLLEmpXyDOIBMBQbu/JNaYsTWJtY1iVcBKMroR3CpX7UASOW0laV0+luz3Qpr0fYM7HmCn18IUoZsQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iFlUV7tVP59nny7i6pPn7u93Q11csTbtEzDaW/OVLpk=;
 b=CJ7OWq+SM2H2DGYYQOp/q3rWBljPLaFr8XGA6mTGMBEQ7cAFVD6EtZgF5Npu1bzhsbK4ZKXM8ILKVBPZfx+90qH0A+yOux9Cmpp1RnuqZTQS7pEe8OTFsGoMEiLceh5RpF2e6/IynvyuxM6dbskSAL1/HFtbmByx3zjKL4JWD4FI8pKTOvnzUa94AGgDlAcpS7gN/OuEf5F2CywJDMwrW6z9ASxi5LGQo/wwrXV+tWNYmvDNY9WYQLKACgKdcz/1z6ASe0nHB7OQWclxfm8IhhG69VvMnEyAPnnoCrnkJDTMiclncONu+Ga9au3n8/RzG7Fkbp3Y+S05wQsH4fhxDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFlUV7tVP59nny7i6pPn7u93Q11csTbtEzDaW/OVLpk=;
 b=JkXEnWAXDg+9dwMrfre9GGq3MQhSu0s1KD3bUAB781w6OpFpw4VeiGWazCGjUMXKN0RjO6NPEA+Afi8SdT7xB2NVu9H/kMU9Y0th20tRAMOwQmlWjitxrLBM5ufkj5t27yUt9ysUV7CJBQrXuSV3iqPut79iRWzn3KKMvFQO+LE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV8PR10MB7727.namprd10.prod.outlook.com (2603:10b6:408:1ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Mon, 17 Jul
 2023 15:24:49 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb%7]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 15:24:49 +0000
Message-ID: <4a6ed965-e233-4529-5685-778948f73987@oracle.com>
Date:   Mon, 17 Jul 2023 16:24:43 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 01/33] scsi: Add helper to prep sense during error
 handling
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-2-michael.christie@oracle.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230714213419.95492-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P251CA0021.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV8PR10MB7727:EE_
X-MS-Office365-Filtering-Correlation-Id: 3003b236-35a8-4fbf-73a1-08db86d9f5c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2im5YH7ZPNmXgJd68IIGsW1jkglkmblkFYKHQKJ8IT6fhImdHU186TXN0fOwVTZVhBcC+dEEtYQSZ8VXz0WViCHYa8A0a581qUgB7hFXFaqUpk3XXmePrPA09uE+OrtALDVQs/97KHmtKgKWDtqhFkWZLGWRCzoAgHoepWAgIxPXQRUXuELtY8a7kQmycIrYE6hbaeLAYv0SI68/qf3MsLdcvfef3GSUriuYLrm2mTuu+rssR1SRn9OOhdkLmZfoNn+vpe1L7jJSOFhjVCzAAc8KPEiW38P2/H4B4v/pHt6re44+dpv97q8po2mpss6KqnlL2GrqYSLfExNVmfy+P/i02ZGwNlRlhCxPi7u8MOdN5Pcs20JVAsJANgHpAa2Skwb/KNgTib7bOqki6fX+gsdgUeZCI7P3ZPRlTLkC49u1A9U7ytEVfi6SNa0Gvrme6GjRqqRLplTnGMVFdRu8C7UKezpbqN5ZUxidK+eMI195GQoIC91izuZ2qewbmR6aO6aq0okWWVz4ZlIJQwt0+8nYqlRbTtV3F4WGMflf9vMeZcYzJ9yPCdVo5G4V4Jjocm8P7Cizj+3gINCDuChqV2o0lZPF0ZAkzluldm6Fbf0Qwu4YBFgrt9ekFzkbGeEic/mcvZ38nmh5Q9lMb6Mqwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(396003)(366004)(346002)(39860400002)(451199021)(53546011)(6512007)(26005)(6506007)(66476007)(8676002)(8936002)(5660300002)(316002)(41300700001)(66946007)(66556008)(38100700002)(6666004)(36756003)(2906002)(36916002)(478600001)(4744005)(31686004)(31696002)(2616005)(86362001)(6486002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3JmSzA2V3hXNEZpRjAzRzJvd0ZIVEdUYUhhZG8vL1NNclBENXRHckJ1S09s?=
 =?utf-8?B?eFVwT2FtQmJjMkhsZ0VPM21MOEZBYkFrU05LV2ZiYUN0YTZtUUxzTitONlJJ?=
 =?utf-8?B?T01BTGZoNTA1QUw0VUZvMGVHNlRYN2g0WC9IYkN4SFlYb0ZzNFNNUEgwdkRk?=
 =?utf-8?B?ZlVKRUV2NHd5UEorZFVKcFNTUCtyYUE1RjhvbmlNaUhYdEszS3ZBTXZvbERw?=
 =?utf-8?B?YWtJWXkxSGJ3Ti9LV1NRZksyNk8yWUhhZTNraDQyOVV6OElrNzVhcGhCVkdY?=
 =?utf-8?B?Y21JbEdVcWtKWWduK2NsMXYyRXBqeDI3SHlEMkwzcDlYVTg0L3lrUXBSVkJa?=
 =?utf-8?B?SVYyalc1QWJjMS9RUzM3ZEREUkFaOXBRenlGM1VOaS8vbFBFSzZtNC9WYzRp?=
 =?utf-8?B?MHExWUp5bEZnckMrbDdsdDEwenZXNnFuZHd3cHRScDJ2UkoyWHlCbE1IeVdQ?=
 =?utf-8?B?K1ZBWlhpT1pkSm9EaTR6RG1TbldWSHhFSHRxS3YycFJjWE5VdlBxV3BPeEJB?=
 =?utf-8?B?R3dHVnVpZHVQZ0pVNTNjYlpLdnBXVHMyM1pXL1RHcEkxdFdReFBTbmlMWmZh?=
 =?utf-8?B?bTZKUTFmR3J3LytLYllScVBncGYxYlNHb0R1U2svNnZZTDJWZ0ZDUmZHakw2?=
 =?utf-8?B?NlVpaTVDNGxid2pNZWpOWW9YYTZXLzlxOElKNmJUVi8vRWNPUDN6TWdoc2dO?=
 =?utf-8?B?eVhtOFljUUx3eHRNdW5tRWhvb2JLSmVNOS9OMzJLRUNpQlhUcjJZRmNmSkVl?=
 =?utf-8?B?Q282ZTdPelp5Q2doTkRxVmZ1MWZ2N0tiTHF2blhLVTAzRlVCVit0WUljSFNs?=
 =?utf-8?B?NGR2bFRLTmpoVXMzSklRcktCUWg4cFVrdndLeEFibHp2T2ZsekQrV0YrRkpk?=
 =?utf-8?B?YzFUSU1oa2VZdVpQd1FDM1lSYXRjS0ZnRmdDRnpTeG5wWmFhOVo1QVlCMlFD?=
 =?utf-8?B?bzYvdnQ4Sys5UWdPLzVRNVFuYmE3c1gxd09ZeEhzNzA1MUp1TVR3TVZUcjVl?=
 =?utf-8?B?MDU4SGNpeVMxUjlZMkVWODNoQWEyU3ZBa3FWN2NCOWp2ZlY1L3Z4QTZOdm1D?=
 =?utf-8?B?V3FUZ0pjT0FIM3B6RUJPQmlMTTRmbjYrbzlBR1NqS0haNE8zSVFUTlNsS3cw?=
 =?utf-8?B?VjRtRDVEU0prN1RWT1JwMllleXFkOENQelpNcTZxa2ZnTm1NZGREMWFXN1Rj?=
 =?utf-8?B?UTlNSnhoOUQrbmNja1NGczRpVHdiU2xXUlhuVXBCTnZLOHZwaE55ZCs4MlNx?=
 =?utf-8?B?ekVjM0thU3dEdFBENTA0SEg0ekNlcXhwNWlQN0UzRlkwY2lqaTk4ZG9NVkJO?=
 =?utf-8?B?SGN2eWtWeDQxdE5YWEE5cjBNdmRIMmV2eEZIY2VzMkoxTFR4bU1rT2VKbzJa?=
 =?utf-8?B?MEdVdklDTlNpSW9zK3dHKzdNaGRWOGpoOGJFV0ZxY0xwU0Q5ckozOE8vVkd3?=
 =?utf-8?B?TktxWjJ4bk5IbS90Ti9QdHNYWDQ0SVJIQmNUWk5EaWFvcW11SWhhQkZLYW1S?=
 =?utf-8?B?bjFpUm9UR0FBNDZaSXJJanpDRDd3dkVJL25YMUdwYzFrM24wWVhDNUJ6VW1P?=
 =?utf-8?B?NGFBRjlhMWpvdDBUcDlzSzc3dFpBRk1HaEVnOGxkM1gzbXhGZjE5L25rcDB1?=
 =?utf-8?B?UHp2WmNRMndvc3FxQnVVeXY5QkRlckNpaEpmL044WThYemNQZklNd09mRGhi?=
 =?utf-8?B?TmxFUWQ5U0pRVC91dElxYy9neHNxL0RnT0piRXFHTEUwaFczVEJFUzF1dFN0?=
 =?utf-8?B?UFk2NnZYZE9ZTDNmdjZiMmRwWEVhTlR4UVVXS3JQUDNHRGFoSjhVN1pKMks5?=
 =?utf-8?B?b2tPZ0prMDdvU3o0TWN6NFliQnZZcjVGbmdGbnBBY24xL1c5MzBWaDdZL2Fm?=
 =?utf-8?B?MTNrejlFUWhPaHI0V2FjazZiZEpxMEhRRVpjWDFhRENucFVtUkgvRlEyY25r?=
 =?utf-8?B?dmJBbmpjcVdrUUpUQVZUQ0NKQUhQQUYyRlVnMDhodEVJNi9jcUdqVU83Qndv?=
 =?utf-8?B?UVhQSzY5ZHJyMXRDOXpSd0txT0pHK0VmYmh4K3hVZFVGTTZ6T2FXa3BrVjFD?=
 =?utf-8?B?U1RLZEN3ZkxrY2RXM21jZmozR2J0REp6bkZMUkVRV3U2NCtjT2x4cXYxQmRh?=
 =?utf-8?Q?Q4GNUYYwlNFVCSk2dMTEX5GWN?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gnRdwarXqkFL3LVFtqQK45zff2MS+V5VYy5WnM9fo1GrqGdNdMQJbH+zV/qOeVLY7APqAYaZ2Xwo1ZVtTOFRyLF74zPgPW2337t0vioc60i8HsejQQGEMPbeYoK4pNUnH1dYNd+fH5Z/V0tQ6sgLEL1oHLsHzJZTFR959kklJcUrl2sdhwgHZtFltjihpQ3vbjJq9KPN9MJ4RP+ADSujUg7KcYKn9cXtQdyH1igASIo0G2SI2xPi/0CAmdxVR1B8N2y1XxYAKm+GNR70IF095QVr2VCJqrTFrj6a1SDCvu2VGIApQ8dDo0Xb9nsJFJJPfoStEr9UxIplkdmqp7gQih1LDwgjVrvQyqS7dyemIrWlQzWleYqgXJqGNvrOyQWjOPKgMqv4oPIr0P5BSjjWLFr9TlvP7xGJK2KPE9KrkWK1ObF7HUNm4lbB2LtdcNRTxzDG+Vt8obEw5vFK/NT8TTymqeOFaNovK4EJom8NPuE1wYK1bKu4H4a3ziJiB6YufOyI5ScVH6XTzAzH0fdFYpJFGDJ4SjfQ7vBkurQaH7/KbmlIe8gZ/4PBraadH5/6iP4H2QMJsQgg7UwSZbzqVEjEVMBBEuANGj/0ze3n+voMCJeG17PB8MyMYY62wexQDth08nZ/L7vG1QPVjrMXQXyp+rMwNE+ZpfwNnByLVd2WtT1pGQCijebe4KRv+YpTbqd5phxFLst2HT0L6ok+DTXp1UwmUjrW/gGeoLOJY9zCWsS0Pv8JkMvh1Q0WMghCAgEiykMEYChdjBFLzE6xjKI8WKzZwkjGCZzULZTUqCjSTpppwyooRa7sCMUjNIVdyZMFnUK+aMA3EJOuT+E8uVVU4Q7i1CXGDYD61jpYO+IquP1LsIXsYlDe8h0Qmqw1
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3003b236-35a8-4fbf-73a1-08db86d9f5c5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2023 15:24:49.5362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xKbSDonp3BSLyJ2v33pLgvRooR2sLdY/3P0V1h8BagBrTwj28Xfd80H7YHHf2XUoqRiSMuYQZeIgD3EVrfqNZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-17_12,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307170141
X-Proofpoint-ORIG-GUID: 7SQFPywE2mst3TDzMH9Ry_Ajk3U_n27q
X-Proofpoint-GUID: 7SQFPywE2mst3TDzMH9Ry_Ajk3U_n27q
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/07/2023 22:33, Mike Christie wrote:
> This breaks out the sense prep so it can be used in helper that will be
> added in this patchset for passthrough commands.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>
> Reviewed-by: Bart Van Assche<bvanassche@acm.org>
> Reviewed-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Martin Wilck<mwilck@suse.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>
