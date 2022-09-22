Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E3E7C54EE9
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 16:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbiIVQ0n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 12:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbiIVQ0l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 12:26:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892702B189;
        Thu, 22 Sep 2022 09:26:40 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MFxBfU021737;
        Thu, 22 Sep 2022 16:26:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Hb46JsrDCpdTgZhk2UMgoGy3yrvAJY2uCr1EsMsksJ8=;
 b=03t0EyggJPePqsp5aFyxzzyaTz8ds8kf7Zh3A5OmT6gTrObacok/P0hcJtSCMmT6OiQm
 bm90JBKzx/Gvs4BKOLjiEriAWtd/WEkCmAhX0hxkrGwEy4M/RrV4/IDnPREy0T7VQ0QK
 LEGX+rRTdQkBgdl3k3sCXOFqhMwfcfTO/mmuTua4ivqCHhHJlUcCp8NT9pWanOG1c9zS
 VuSGlNNiPzOGKKVmHFqZGvmHb7suKsCG3x6KCvWlQMUmRU64/6yqqhhQLjWXORSh9PzE
 gMFn2ALRWv14Tu4N+lk07FLAsgCtf2kPogbmGglqwrvDa96HZDC/uSss9+/8vEyRh2IT xg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn688ng1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 16:26:37 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28MGEGJx028969;
        Thu, 22 Sep 2022 16:26:36 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3d4stt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 16:26:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kPy47szx4A1r2BQ7MTCXxKoc+d4barX25woiDhvz5pdCYanQENNbOMe24bUfGaGK3Yjuxv1lFQgmzg3cTUZyKk7LBeWLsjjQcFzuCmFnW3CG0Ok4LnZkMHfYBIqAyKvgpa8yKRMgmLYdeSaQ6C+DCtIzmwW+iBS/3TYqr5JOMkQsLKYuouZgIl3eI9gAU3CUFT1/PUp3KvGA7a6l2ADC30uUywXRih8R2Ufrt1ko+llp85Lgmg/TsKvfC4ImN/J3dZ6opbHGlYosDuF6rJiAE3k1l1CO6GnLirf+2EUVGkGtfNuOn+DnZ+8qVeESkMmfupxxBkBzME7JoscSFNNxyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hb46JsrDCpdTgZhk2UMgoGy3yrvAJY2uCr1EsMsksJ8=;
 b=nz5NbgGD6GAiBHDR1z4Q8J6a/PwL4A6Rt4YYgiNnBsQZWhVh/iCNLhHRLXS3UXJlJAu4i6y1lOE6pLpg7dNaPhDfp9OPSnKH9GYBszf6e56R6KP8pFaVTGO6CZ+fSsTRWCXC6PQk6iNnGRlzritrvWWi2KE0pH+rXQtzZexTLsJQlXpsBcB2k333H7ekesVqzauQ/can5nb6dlrIaQ8FC1hdYXasvpVcnnRyjlk/KNKdZM/iyva5o1K6PFHU4gtWfbzP8ojEQdVO5/ZIMDvefj4A1XgD9ym9upgkYdjiNqGzF7zNablLZii334a3nPt0CtKJtmaCV+ivLyeT7OsB9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hb46JsrDCpdTgZhk2UMgoGy3yrvAJY2uCr1EsMsksJ8=;
 b=KgJwvmgm1ZMO4YkGImT6yD8qEgknyfFs2sknkimBh3jiqgbgvXmPqjfr+0wozr9kv7qLCedbyK0c/zuihkb39eh/R+ORkzfBcEdF751/8KgPW/rFFeLeYnzigg/EfzI6G5jkBXZ3GlRPCYCls8lPhQ1cbiCqEkmBsWdh2B/FLhk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6339.namprd10.prod.outlook.com (2603:10b6:510:1ce::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 16:26:34 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 16:26:34 +0000
Message-ID: <e84419da-2950-3750-e6a1-af873c1253ac@oracle.com>
Date:   Thu, 22 Sep 2022 11:26:29 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v2] scsi: target: alua: do not report emtpy port group
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, linux@yadro.com
References: <20220912125457.22573-1-d.bogdanov@yadro.com>
 <92f6024a-7898-e281-099a-c79b67fecafe@oracle.com>
 <20220912214521.GF9218@yadro.com>
 <82d31d9d-700c-d961-d284-a5a117487adc@oracle.com>
 <20220915060840.GG9218@yadro.com>
From:   michael.christie@oracle.com
In-Reply-To: <20220915060840.GG9218@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6339:EE_
X-MS-Office365-Filtering-Correlation-Id: d1f0b90c-4a9c-4c9b-959b-08da9cb736ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Eji7Cg+DqSK0Sui4o/3EjfNYLgZdhArYCfMRaTxs5Rn11YXMayKGgIDlS9u7bj01I1qdaigZORSQqMGmTX2HTQVrLHr405rzjSZK+0uy45rUQbF4ntB0DU29A8Gtvpr4oDTWZpOdOIUWXj9iNgLMKgjE51Dzay0fVnQogNtyzikI4pGDnkvMwLRx/4tMZ1D4x+45QFJaEizh9ZvQImvGbPOnbSKmFwmsUdV1r3hkK8uWdBw1ZTQ9ae1bUR/pn+/jw3NQaDvcUd3W4f5qDKLjXOE+S2/3/ucizJqNsGqY2GjWzT+UvcJDmUWzLZktL2BwxL9wKi5a7tf4ToGsOPQRmEZk+LF45pfNV72mdqXlLCvSSXd3gK/ri1jAI1jbAfqSao4+Wz9zcTlJf4eDZLt3Q1mnWD/ur7tO1WyTvYxvPbB/9bpvbdwyv2AuOgPbSawLVRxD53NoLzTeh6xo4y5ZU3S36SPCFLvnTM4XVyjibKW2Xzk8sjO2xuSM6e+dGg1O7IHfzzZPRkdv5TrMqNjyOhg0jC+GF4dzFjEjLSm8kM1xHZ5ZFtHltxQqRA9hgbD2A4/iDTvQSqPH07Q1EGUkyaZ284HK9bEyWNIgNNwt7ye/3C/AXbZWG3b0AqXp8t0hG5B4ph1+p4oT7RAA6IWt5tHK5F+qFaaBkvfnFzVy7XE3k8EYRiYWMpH1TgWU5faDw9t5MwhWNKWp4MkBFKWkz9lMwt7itrZmRROagbxUoaPkKsd5QdeigvxdZxpbCdoX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(396003)(346002)(136003)(376002)(451199015)(4326008)(41300700001)(6666004)(66946007)(478600001)(8676002)(53546011)(6506007)(6916009)(36756003)(6486002)(54906003)(316002)(38100700002)(186003)(83380400001)(9686003)(26005)(6512007)(2616005)(86362001)(31696002)(66476007)(8936002)(66556008)(31686004)(5660300002)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1AxM2dpV0NDSGtPSlVLY0tFYTh1ZDNkaWQrNm9ienRkYTlQQ1p5RWlLbWl5?=
 =?utf-8?B?T29pM0VqUU5ydStWZUIzSjRIWnJZd1V3M2VwMVEwMVY4S1RzdDJueWphaEdX?=
 =?utf-8?B?MklHbGZsVnlEek51bmxZT3NBaFRQOG5HQWVTSnF2MXR5cm9Ub09xL2szUDVG?=
 =?utf-8?B?ckVKeGhLTjNOa0k4UHBoOUxJdDlFUVlBQXZjVElVY2RRbVdHYitTV296Qk0r?=
 =?utf-8?B?ZTlUOFdSM2t0aHNiNURpOEV0VklPYWlkdXM0TE54eDcvUWk1NU8zdlZjSW1h?=
 =?utf-8?B?b1hIcXovZXY3Zi9rNXdnQnI5VWFqd0FqTng0Zk5TTnl2T3ptemg1WGM5SVVt?=
 =?utf-8?B?Wm5iOHR3U0NpT3FVc3loeEtFem1tanBHNEJGL20yVmtUSVdDVjh0bXYwbURX?=
 =?utf-8?B?Ri85MjA0bzd5c2VuQ1Nydlh0VDZVKzNyYTFRV2RkanQySTJpUnpicVZMLzg4?=
 =?utf-8?B?U1lWajBSaDAwN01nT2lxWWlZMC82NUFqbUdDc0luNXpYYjZPaHJXd3dwcHdz?=
 =?utf-8?B?TzkyYlplTnVyTk9xVjh2RHhlS0w2ZCtGTVlPc2ZVWlh4dFNMM1lFdTVOTlpT?=
 =?utf-8?B?VjBVbDR6RGRnM0d4Z3AraEV2clZzd3l4cEtDeFZVRDVHNFE3dWpqcFgzMkdJ?=
 =?utf-8?B?SEY2WWZFdnAzTHdnU2pjOFFFdXJLWFpZaWZuYUJsR2ZxTWYrSUFFRUZCM3RR?=
 =?utf-8?B?alFrb3J1bXF3a3NOSEgzZWNvblFiUldRMTVVbDRsb1p2L3NCNE9XaGsweFFS?=
 =?utf-8?B?UFlUQUNmK1d6NlFHR09GbTBvMVU4WmpJWkVXeUtyTlVERTNQZ2ZHZGZhK1A2?=
 =?utf-8?B?MWlzYmFMbkNvUmxnanZ5a1lieGFiVGlvcDVvRmx2c0RMNit4bmlaLzIyK3Qx?=
 =?utf-8?B?M1oxczNSbEFvSGp4d1Y1Qmh1UmJ6VGNqT0lET283aVFpQ29raUp2YmJmWHdh?=
 =?utf-8?B?UDRLdThwVE5mTWcyd3gyajMvQVIrSnVheXo0L2xMTmhGOU9XSldXQW85cytu?=
 =?utf-8?B?OHcwN3BteHdqK2loLzVQWlNaM2JXQkpDYlYzOTVIZXJHSjUzMVBWd3NmNGFC?=
 =?utf-8?B?VmRqNGJ4OUc4MVpUUmQyQWJYeUlqR3NjQmN4VDhKdjNwZjk0Y01yd3BLZnp6?=
 =?utf-8?B?aHI2QS9kY3FCZ2YycmwxOUlxN2xKd0tzYXBLcnc1MVNZVUNPT0FPRDlBS09B?=
 =?utf-8?B?QVQ4UWp4UFh4dnl0dGJxNjFHODA3d2NMU1RWNkNGU1hPUDRqaWFUSXBIbFpD?=
 =?utf-8?B?eUl6eE1NbmoyWkhuNVJMOGsybXFmTUxMUEdTVGpCRzdhZ2pxcEUrazJBS2J4?=
 =?utf-8?B?Y1JXcmVIL0x0VkNyeTRoUGdqQmFsbU1tWWo4d3NPMlg1SXFXQ3JXZU1BS1A5?=
 =?utf-8?B?MW83Um5mL0NXbk1ha2FrSXcyVUx4LzBpVC9LaXkzSlVyV1RNNFpQZmhUNGdh?=
 =?utf-8?B?SVArQVhJeHhDcTJUYVk1dENpWXFRWHVGMEtORmRLbUk3bmkyc1lweU9yRHJG?=
 =?utf-8?B?dUN6akdZRUlDVWlLM0Ewd29Nd3dwT0RGSXkxMFZDQWVBcU1QdFp5YU1kOVNY?=
 =?utf-8?B?N0huMjl5SzVlaDZDM0RiUHJhMXpEeUowMkVuNno5SkNJRWd5eVJabm1QWmtC?=
 =?utf-8?B?bkxBR1lwckcyQzQ3TnVPRDgrbXUwUzE1Q3V0MTUzWWVyN0pETHdCVnZDcmZw?=
 =?utf-8?B?TnkxbzBrVGt1bWc0SzZFenpkVUtRcHhNbGxiLzJNNC95OUw4K0ZheTZ2WE1l?=
 =?utf-8?B?UjRzdnVqNHZEVlFrNS9iQ3hhbldrczV3S1V4Y0w2NzNBc05aZXBRcDRBblNv?=
 =?utf-8?B?VEpIS3ptUEoybEpySUlmbGNadTUzSGpzNDVwUlkzNTdBL3gvNC9kTi94UzVq?=
 =?utf-8?B?SWxzMkJMdDVrU1pKS25IMHdUK09OT1d0TGFMRVh0bkdxQURTSy9VcGVnUlo2?=
 =?utf-8?B?TkwxUUpZZHI5aExNNVp3S0kxcUJCVjRVbWR1K1dTL0xra29welplKzRURHMr?=
 =?utf-8?B?MW5QanZxMjJYbjVuUnhsR29wSVA0dnVvQ3YyaUd4TVhBMzZWVU9IMERxcXRR?=
 =?utf-8?B?eUtjOFlybXJybjAvRk1QUFVwbzU0dUlpZnBOU0pQUzVldzlDc1JtRk5Cb1VV?=
 =?utf-8?B?RjVFTGVXL1lWWTBrSDhXTlcxWFg2MUhxSUdpWGVhQXFOREU3WVg0TjI1VWho?=
 =?utf-8?B?bUE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1f0b90c-4a9c-4c9b-959b-08da9cb736ed
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 16:26:34.2553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PzuKGXxhRl8anefVTCmIV5yzIhSBcUWCWpONF3Y+xxsj9tOddHEhVfjS2oYjbFn5sqjij1CJCktHwSneT7Nm6fQFFjaQp5dip8vMyoaC0Tg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6339
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_11,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220109
X-Proofpoint-GUID: rxBLTi-rhOQiQQ-4O2m-6PJvXV7EsY1G
X-Proofpoint-ORIG-GUID: rxBLTi-rhOQiQQ-4O2m-6PJvXV7EsY1G
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/15/22 1:08 AM, Dmitry Bogdanov wrote:
> On Wed, Sep 14, 2022 at 02:18:40PM -0500, Mike Christie wrote:
>>
>> On 9/12/22 4:45 PM, Dmitry Bogdanov wrote:
>>>> Remember how ESX used to send a RTPG to one port and expect that it got
>>>> every group and that the state info was all in sync (basically opposite
>>>> if what's in the spec now)?
>>>>
>>>> The spec and ESX were updated, but I don't know if other OSs did this and
>>>> if/when everyone was updated. Do you know this info? Are the old ESX versions
>>>> that worked like that end of life?
>>> ESXi is kinda a pain. But fortunately it has nothing to do with that
>>> patch 😄
>>
>> I didn't get why that is. How do you set up a distributed/cluster/HA target? I'm
>> probably missing that part.
>>
>> Software drivers like iscsi I get, but for HW drivers I didn't see how you do it.
>>
>> For example, if you have 2 systems/nodes running LIO which each export the same
>> device via 1 port each where one is active/optimized and the other is standby and you
>> are using qla2xxx, then on the local node would you create 2 groups:
>>
>> [root@ol8n4 alua]# pwd
>> /sys/kernel/config/target/core/iblock_0/device0/alua
>>
>> [root@ol8n4 alua]# ls
>> default_tg_pt_gp  local  remote
>>
>> Then under the mapped lun:
>>
>> [root@ol8n4 lun_0]# pwd
>> /sys/kernel/config/target/..../tpgt_1/lun/lun_0
>>
>> in the alua_tg_pt_gp file you set that to local. That would then have tg_pt_gp_members
>> set, but remote would not.
>>
>> Before your patch, windows and ESX could do a RTPG to just one port/path and we would
>> return the default, local and remote groups. We don't want the default group, but we
>> wanted the local and remote one returned. With your patch we only return the the local
>> one now. I wasn't sure how that works for drivers like qla2xxx.
>>
>> For iscsi, you could just mirror the remote node locally, so you would have a second
>> tpg:
>>
>> [root@ol8n4 lun_0]# pwd
>> /sys/kernel/config/target/..../tpgt_2/lun/lun_0
>>

>> and in there set alua_tg_pt_gp to remote. Your patch works fine for that because both
>> groups then have tg_pt_gp_members set so if the OS just does a RTPG to one path/port
>> you get all the groups.
>>
> I use a virtual remote fabric driver to configure wwn/iqn-tpg-lun of
> remote peers at each local node. In that way 'remote' alua port group
> will have ports(RTPI) too. That allows RTPG (and other discovery-like
> commands) report all ports in all port groups in the cluster.
> I sent it within the RFC patchset:

Ok shoot. I think this type of setup is not common, so the patch should be ok for most
users. However, I know people did do some complex setups and I'm worried those might
break.

I think the remote target patch is fine. Did that require any additional patches?
Maybe we could add that patch and your patch in this email at the same time and we
could migrate users.

What's your take?
