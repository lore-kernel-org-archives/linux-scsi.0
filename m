Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD0FFC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 17:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbiLLREN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 12:04:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbiLLREI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 12:04:08 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2799D26EB
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 09:03:35 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BCGwr1o002674;
        Mon, 12 Dec 2022 17:03:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=FongXQ7MToZxlyUFWuaAQ1X2MRoAWpFSCPFUIqThr0I=;
 b=EwgBsDrzCsb+E8O3qnbYWBSVaZ4MStxB/q1l2ZClxclDzOgt66y6iILO/3+UHgwUCmli
 FxCQAgaMths30IvbJnt/UIXOylqw35tfd+XWuX91QdAW1MDmt4iKybqsIDspaTF5ji3i
 MWEi5xEwMhq12KO6RiuScRgdGCVGzBfhBXwD1ON0JjWSTMpHS3Hoe2sPY9tEyQ86k/Lf
 GBF5IkoAuyNmNHuzrTQsXiJD352G0tZu/8XiVFS29/ZBhxzUPUlzraL9XBMRcKg+JnfL
 Sq6o+2JhLPG55BJT4/lvqffqWk6z2rKqYdC6whNxut/VKX9iVc/xAmR30o8avIsmo8pm iA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mcjnsu89c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 17:03:27 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BCFZdx7034812;
        Mon, 12 Dec 2022 17:03:26 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgj4b65r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 17:03:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=At5OZjAq7EyjbjN2euhA08CAudsvqeMyvV0j1xkifaWzF1WhIpv7AzBiE32JojOgHNGg3N6mXvukaI882TOgVIb/x3rRrmmQ1BM6EHFAJCrs80xIDYbBXRkbU4hsXgpP/S8ae3xMNiXqFJRp+3ZDuvpuQHZVtp3MidpsRuhqfehSs1LRKFwDc0aflFDXlsBJ7DftmOXY+S+p4zagAb3JIJAJiosPagsDq31Ofo9hkooBmRBe18wBmTDkBlJaooofgLGrrfnXnWs4oW9b5JEopWXXJieZA1M/dKLE5eEPcPSQOa2fBUFxmCjYUHjGwvKbXkx7nRJmN1RVGArbTdZL0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FongXQ7MToZxlyUFWuaAQ1X2MRoAWpFSCPFUIqThr0I=;
 b=kA+Cg6tke0VSpjBtUqDgQpu+6mJC7ledQW4cPpRMX5B8504pYHs7CKoqVUxtjwf0Y3LOSTmSCULGTM+yeX9GWP3TTDiv/H9Fv2xGddhhte+mOSHJKcjyHZh92SabES4Qx/N2RGj7+bj3aHuDb24RCQLVCJybiOybXbo4mQUJCVJZ95jUqPLUwdbef0vl1GADpwDBtoJcIhLjFpM5rynAURKO9KofW7cOt6p+8EmIwwD+1mbDYPVs8CCHPJOw3eWBWpByeeDflXYaMYgyyN/SLYnMssLQe/FOhvvuJLOviqAXQnRFGeMlx+ytsz7tHYF6CL03aJEiWfYRvBEYo4DVdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FongXQ7MToZxlyUFWuaAQ1X2MRoAWpFSCPFUIqThr0I=;
 b=HyW/ktt4top2UGYSy/l59ZleYGblbMIzPQKt5DYd5ds00O6jeE7RS7PLObQrZZMmLwYSD6PS2V904XbrnnseI87NZkUpe4QUpNOKcWhHsFLVIOJha5TMK8wqfmKS7JDSD9NUj4Wfvl59/+acxp13gy5g3yjw9OfqMj2JO1edPTw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB4971.namprd10.prod.outlook.com (2603:10b6:610:c3::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Mon, 12 Dec 2022 17:03:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372%7]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 17:03:24 +0000
Message-ID: <e3941361-472f-2eed-3ee9-ec429c7fdafb@oracle.com>
Date:   Mon, 12 Dec 2022 11:03:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 01/15] scsi: Add struct for args to execution functions
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-2-michael.christie@oracle.com>
 <0e69ddee-4967-ee07-b959-91d7de7b212e@oracle.com>
 <07f92000-5be9-2168-8e53-55aa706fc276@oracle.com>
 <daebe4f3-fe84-1766-ddf5-53dbc9f47c5b@oracle.com>
 <1ec68506-971f-962d-5d38-214bc94fc132@acm.org>
 <cd1cf2bf-b5f3-71fe-656f-3199c7fa0960@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <cd1cf2bf-b5f3-71fe-656f-3199c7fa0960@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR18CA0036.namprd18.prod.outlook.com
 (2603:10b6:610:55::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB4971:EE_
X-MS-Office365-Filtering-Correlation-Id: 8da5f5d9-1039-477f-8548-08dadc62c7d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pYSzOrYnv/r8VMQ7NjFGCG6YVhGbs2s+//HdydzIehaUbatHMDx5AqHvwDBs+09HE/zz9X8sBo2NrgQpt8ajdoK6epY0VG/s/oivYVcERggwwOlmXmHEgYQ4+pwQf5nn977a6kfAoKMEujjpeigsP7G03hLu7SW8K5KqXjriDqFCz0tYtspk1r3MPF3GD+LVi5hodrM83BSdAz0+S+B6+2mcriYvraaSzr/I/ksTupLjlSErxLFEXzAUhOrO3VwfuMf7at0CFn6xKGd/fsGJdgVxbs/dOBChxxPMq97cdzVeNuNic4iKqvvvKAOc5ci04/RwRR2IdbCjClFtGH77dpnMgHqbByccLhTxi1pmGrGvDWmnLlzErfNq/p+rUtG4RiyZsrgfsQflQoYKZBuTOy7U5jrMF0lC7S9Mu04sGh8oEIBc5I3tHWV1uHPCT+R86vYdeZrnT8y7rgwE39HhXktwpOY4I8/T5MFBAdh2G80Sae72Y1IoPKByh4C8u7iTeWc4yGM3ln7YNH/15fGO/G3MsuS/07Wxi5Hcsi3/Au/KXfJIFfq3u+uIFR85xC/6vrA9xe5nkdLnVHQ04rj6n7AhSanwkQsRqWBnm2Hpq5pKMrtk4rWzStBuMOeI4cIDG6jk6DMYFPJS3rMgT9oTIU2DpP5crvNoq5LuToPRIrWLMzZFnYbO2JxrXpY5pO/KJqy0ICEppXgvWSbT6PRzrKrI9is6ilfWCW1xFef1f+Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(346002)(376002)(136003)(396003)(451199015)(478600001)(6486002)(66899015)(31686004)(26005)(66476007)(316002)(6512007)(8676002)(41300700001)(8936002)(66556008)(5660300002)(36756003)(53546011)(6506007)(110136005)(2906002)(38100700002)(31696002)(86362001)(2616005)(186003)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dnNwZ1NtRE1oM3hCZ3FjMC9kcVhwWVdva0pjQVJXVGg0TktjTDNMaElVWVdJ?=
 =?utf-8?B?c2JDaDdtdGdUM1A3amFPL3VmNUJEdzVPOUFCVHBaN1EyNnJGN3JkMHlnTjdC?=
 =?utf-8?B?UmQrbWdOMzJMYXVvcHpBanVRVnJicWlBSk5NK1hPVlUvV0ZmTkFFb2RqMUlB?=
 =?utf-8?B?d0NiUDJiUkVsZVRENlI0VW9SODdhNVhubW92dWtsaVR6VXgwQnVjTkZzUGFD?=
 =?utf-8?B?SGUxd21mT25SLzdOWCtOZ1U0TFJJWmNQMDlrcVBrbnY3QnJ3TzZkZHJHaEFw?=
 =?utf-8?B?NStEeDA2Sk1TTG93UUZoTFV4dkdnRlJZQjZpYlVtcVdyOHRleFhlTUJYc0dZ?=
 =?utf-8?B?M2ZaWTZHbGwwREZlOFhTNW9GUmcvZXVJZnJUblczNU83dXpqczIvNFBFVGxy?=
 =?utf-8?B?bTgzcVF4cXVRaEtidjBoNjEzM0Q2eCszcFljMEg1a3dVUjQwa3lyc0NoNTNX?=
 =?utf-8?B?K1lGREhRVDBmdmoveXJkSzJoblNORHdSYjgzZFlTMGlCa2Q2ZktxcmROd3hC?=
 =?utf-8?B?cWNSNUh6RmhTSkMzTzV1UkEyd0lhOXYrRzlDT0Fna3BjVkhLa2ZEeU9TT3lt?=
 =?utf-8?B?dGJ1RFBmSnh2S2RoQk5DTkFuYjlqcnZYYnczenlaYVl2TU5ZODN2cjk3S3lX?=
 =?utf-8?B?UW5ydnlGbm5kTUVZZVExcHg3WlVrOVhyMlpoU3BPVVhGR1hCMnhhMzltMWt5?=
 =?utf-8?B?Q0t3aEZka1R0T3NJREdPZGFKa0Z5eVFLRzkzSmd4Q1huWm1kaEQvTUphS2dt?=
 =?utf-8?B?NzBZODY5c0JQSGNMdEU1UnFjR053UU15WjFzTE5RODAxaEtxd3pYbjZPUVVh?=
 =?utf-8?B?TVMyZUYxSldjWWxDcjc0ckhTT1lQTXRTV2JNQk5SSnlXS1AzSmZJZ0kzKzRD?=
 =?utf-8?B?T2VkYlZ4NnEreDk2d1YraE9kWFZxUHUzSkR1UjZmcmh5VEc4TTh1cEtxL2FC?=
 =?utf-8?B?MlE1UXB4VkhveWtCVWtzY1Q1NExIOS9UMUJneWlweWxob2laUEdEdmhNUms1?=
 =?utf-8?B?Y1dZeEt2WDYwcTV3a2pyZjNFRS9Cb3paaWd1NEw4eUxNdmR5Vm9ZcXJCUU01?=
 =?utf-8?B?bTRpMDV6UTRIL3I2eFdJSzg5R3ZMYWx6dVJORHhBSjBxK1N2V0VMdTZhM1Q4?=
 =?utf-8?B?RjdSMGppZ0I5Y0tZQWZ4UVAxc0FORjQ0UVM0WlZjSXZUamV3c3pFeWd5dlBU?=
 =?utf-8?B?VU1GcWhSMlo1Zmlrak4rblhsVDdRUnZRdU9zbGFKTW9BZUptNk03MExBUXNN?=
 =?utf-8?B?YU1CcUhOdHh4WnBXalVpcXNzMzNoOHpicEpaYlU5SEgxZEFhTjZ5Uyt1WXM2?=
 =?utf-8?B?VTVlOUMzVVUvNW0wSjZkdWlzbVJ1WWxUc2thSWptNmlXNkUzYUpvd0lIdlNk?=
 =?utf-8?B?UnJtNFBoNVV0bHJFQ2U5SmlxU3Fac2kyTytKODQwd040T291M1MwcGlhQkRk?=
 =?utf-8?B?eTB2QlNURk01Vm8wVGlQaWg1ZVhyRjhnZlZzeUlycWplblIvb0wrQ1pDZHVm?=
 =?utf-8?B?RGZPRm5tVXY5Sko0VlIvTmRwbzd1d0tUUTRydDc0TksrRVRvVVQrazUxUjNh?=
 =?utf-8?B?c2U2VUpldi8zQmt3OGdibm5DaTNoMERlUVlRc0pKQ1RrOUJWMjVLcXI2Zzkr?=
 =?utf-8?B?QnNOSjJxUTV5eWlGbzdjWGQzdzhLdXJYQ2VGaFhKbks5ZlE1L2dTT3J6bHl4?=
 =?utf-8?B?MCtMRkhPR2RoV2oxR2c4bytWemJ2Y1JzckFQenN4bmkycmwwbHNNMHNzKzRx?=
 =?utf-8?B?UFZVM2NmQ2daZ1VoWFVaZkIvcGR1ZnFaNVA2WWRHcWNOaG9tMGI4WjF3UFlU?=
 =?utf-8?B?T21qckFpTytrdjBkT0F6dFdyZDNLdjRyakQ0N3c2YWFZb210U1J0SmhVanpk?=
 =?utf-8?B?c0szaDVpKzY0SHJkeWJPc2xTVlRXUWNGK3M0VmRYSm1zRURGNU9iZHQybFhi?=
 =?utf-8?B?VUljWnYxaVRvQUs4eXpPVXlmRkVIQlVWNldBWEFDM20vV2JRWmY3c1lIdGRI?=
 =?utf-8?B?YUtUbEd6YUYwTXRGZ0NtM1FOYTROckxZRFJJbFRCWExWRmQ5Qk0vMUtVYzY0?=
 =?utf-8?B?NitCVXg4S0VCL1NSc3pVSzNrQ3FJaElsR1VVeEdMczdCWFRqbmdJdG5sRy9H?=
 =?utf-8?B?Z3ZhU0V4aTN5dXBVY0FZc1E3cWlJZXZxY2pHSUpDZElFNisvNVd0NTY1STVL?=
 =?utf-8?B?VVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8da5f5d9-1039-477f-8548-08dadc62c7d8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 17:03:24.6451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: USccYQPp9b6ULppEvYw5coUa2GvG0VsJlwloIfEdMLewOC8dtYDXhH2GHYNB1F2WjZ9rUVCTTiJwy712sXkmn1HzU4h7NHSjLM/vspvLY9k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4971
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-12_02,2022-12-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212120155
X-Proofpoint-GUID: cYX9l0mtCk3cmkg8-W_rvptje98LXTKY
X-Proofpoint-ORIG-GUID: cYX9l0mtCk3cmkg8-W_rvptje98LXTKY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/12/22 10:17 AM, John Garry wrote:
> On 09/12/2022 18:47, Bart Van Assche wrote:
>>>> around it then we have to do a WARN/BUG. We do the macro approach now
>>>> so we can do the BUILD_BUG_ON.
>>>
>>> Maybe we have to switch to a WARN/BUG.
>>>
>>> It looks like some compilers don't like:
>>>
>>> const struct scsi_exec_args exec_args = {
>>>     .sshdr = &sshdr,
>>> };
>>>
>>> scsi_execute_args(.... exec_args);
>>>
>>> and will hit the:
>>>
>>> #define scsi_execute_args(sdev, cmd, opf, buffer, bufflen, timeout,     \
>>>                            retries, args)                                \
>>> ({                                                                      \
>>>          BUILD_BUG_ON(args.sense &&                                      \
>>>                       args.sense_len != SCSI_SENSE_BUFFERSIZE);          \
>>>
>>> because the args's sense and sense_len are not cleared yet.
>>
>> My understanding is that the __scsi_execute() macro was introduced to prevent that every single scsi_execute() caller would have to be modified. I'm fine with removing the BUILD_BUG_ON(sense_len != SCSI_SENSE_BUFFER_SIZE) check and replacing it with a WARN_ON_ONCE() statement, e.g. inside __scsi_execute().
> 
> Another option is to have __scsi_execute() allocate the sense buf by kmemdup, and hold the sense pointer as unsigned char ** in struct scsi_exec_args; but then the caller needs to kfree the allocated sense buf, which I suppose is less than ideal. However there is only single driver which uses this AFAICS.

I did the WARN_ON_ONCE.

