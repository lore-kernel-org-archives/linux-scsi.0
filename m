Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B28CC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 19:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiKITgd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 14:36:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKITgb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 14:36:31 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165F3205EA
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 11:36:30 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9JSOlv031055;
        Wed, 9 Nov 2022 19:36:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=HOZjjCCiVto0a5rYaKZKUd7kafLtyJ0o5l2ysO47mUM=;
 b=paEiUJv5R5OlJTu6BhVxVv90FOlWcvthWP1MtkjIgXlQot+SynHMj7iOnPYUOS9ZeWoz
 TFnziQk3YKQD6bmWiUGBO6VdfPszB3wNYsJ+VO0iquKQca9Mgj8jqDs3yrVK7+LjVg4A
 O0t1yDKuFGBDmzpWUV412XSPqhjcdRjZSD+D9Xu5qZU1+nrfzk24oon7xOyOzY8hNVQd
 QE4pXbZIoXSrbOi4pv3jOZgt6EjaLYGenZNLpf5WRhrQihHW4ABv2Sk+/EMpNWh6t09j
 yT//7XJuxe8KkEL5fraEOihRny8c+6QCzJ+mMtlBGJjv6zIu+fJpsuksGfigf+QvDvjr 9A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3krjd3r10c-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 19:36:09 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9Hu8qf004326;
        Wed, 9 Nov 2022 18:40:15 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq3t2cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 18:40:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xl/TRGQ8CpTk31AZquHa8CKS3NyWMWPTiv86vzrRLDI6EOOiNvHC4QFVsWZt+lXYgPNJmoBpBXONyy+JKRynRkpBwBfX/2JOmy07/5MIkTTijMLBi08kkwsMZ0h6DKnPvBKpcp3l0QfTSwX8BsWBAwPSBivZUF639c6hXuF5Yv25rTEmCuQiGNzukWhmvOEjUZhv1kiAF07xcQ53KnwRGTGTayY3EU+XAxr7tHrHJToU7DqbCJXiy/36pc+kMYVQIIZTtllqLkkjnf0OArKQvcXtNnaiQONlC4KEj2sv+CeeoX0WUvyJXQ167e+YBCFM1OP99elIMVhTVa1RPHUEvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HOZjjCCiVto0a5rYaKZKUd7kafLtyJ0o5l2ysO47mUM=;
 b=B0FT9JVeIooDWJiM//NuUkVSnI48iWZ8Vj60mOiq6/oHhHbBGkeMarYriOhRSDtTV4+MDOHNZiNR7E8JSEkPSpditJUt/VmNac7+iEypdpzbcXFYusVrSuN8O+2bbFilcKZa5LW0YLDBslD7e7tEjMwBXe3Gsd2POFsQ/OKn9LJkrfYedBOEMdt492XqY93qkqEhrJHioJPRlT7mNXNa1ceDr+zU1xRFE7d0+EyWgRjvG87a4vYyYJnnk5eXVOQfSn+xv9No4CCOS+BJfzu5MpRF8O+0a7BqxWSZ+rzD1ti8wjYdH/jMGRUZYaMs0EH9s0u7lpAxTxa1jKZq7jUI9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HOZjjCCiVto0a5rYaKZKUd7kafLtyJ0o5l2ysO47mUM=;
 b=ILYYFV+3Tccx8ARVYZRZQ8Nys4OY4y8rUuqICptSOUythQ+7kuVn+R2spY6Oghv7vdLlOmo3Rq9KM4c2N/IpsWHKNltJ2OH9e+uzaFCW4egKlokb0i3ed7iLTa2bXO/OOeeKLmnSFokEqfRnmVmk+Cy9YRPMtz4Pcp2lCBWjMB0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM4PR10MB6109.namprd10.prod.outlook.com (2603:10b6:8:bf::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.27; Wed, 9 Nov 2022 18:40:13 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 18:40:13 +0000
Message-ID: <c4b77a0f-c53d-42fa-8d42-a08a12f59667@oracle.com>
Date:   Wed, 9 Nov 2022 12:40:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [-next] scsi: iscsi: fix possible memory leak in
 iscsi_register_transport
Content-Language: en-US
To:     Zhou Guanghui <zhouguanghui1@huawei.com>, lduncan@suse.com,
        cleech@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
References: <20221109081917.34311-1-zhouguanghui1@huawei.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221109081917.34311-1-zhouguanghui1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P223CA0004.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DM4PR10MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 865f3865-a418-4b32-4a40-08dac281d68b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6dVp6QkcuVxCvVxaaccXdQPYTbCd1lmA3DWkqukaK4mKIHLpu9WD+aCtRO8MOHOJPJRpv0Dikv+qoX6iykV5mco//kw5lCATROuIfQT4YHTKxGZIe+w6ruDzgC2LYGYWGkg8NC5ADlUpk0TXUR0TMWMl/S2Lv05GxB1lAh0NiUIfskZVvqpCeSbX8MD9XDp0KK8713beXJwdaRLk5RCXRpyS4RL2arEfHdqjSo0CvX/o4H5WgonMBUHhTQkTdJDOQj2fihBVhweJC7pKGMW8N2V2NFSZNOaTbD7Y0SkII/8Fj7hgn/qKJDtM9k3nFuzXT0LugR2DuXhcI/uxQJw82ConOrf2cgE1JZ7kiy/3HYc2EIrobTu4tmbHMKZEVJGMFEGg2dXaBEY+7SiUSkIP3Vu3Q5AIimopgjQQiKv7yXtqLjtmMMDHSLlcbauo2TJWlPNR9Lo+NFM66DrPJ+N0pxOZziTZ6BcxGDbOHwJbmfN0uPDANVYByyVq3nQbUTPVg5WFZy0UJDt7IAMHmZ3Bzpt8J+TsM3WIbzrAU1JsPNyKfpANlPKPvngoScPAF8eNCfQHDp89egL6maXidU7UuPiSO1DSn3/fID3F4zsdZjfnODcWjqAY4oWjk9qlAHvz0rOvanV3MRUc4eEKIkNs7q2W8rRuSDZARhzlPXQgvkDcK3GfozUc9GvufdAVlt+Rqoj0P4XMatv3EHgCP7v/1+bsUZmXO4OYqhJgCBTZQ5bKwJ/QuKI6oimhw8FOESHp5UDTkVjSksnhNlTz+1sQouZSwhL3Q3+ALhF/uJz/ag8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199015)(31686004)(5660300002)(66556008)(478600001)(38100700002)(41300700001)(36756003)(66476007)(66946007)(8936002)(6636002)(6486002)(2906002)(8676002)(316002)(4326008)(186003)(83380400001)(2616005)(6506007)(53546011)(86362001)(6512007)(31696002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3lRSUFUSkw3ZTlaaWZkMFZBcmFicmMrY2g4aEFiZUQ5V1dadWVxR21jUlVj?=
 =?utf-8?B?L1JWTE41Q0ZXaVk1cjBKSUhqRkZPTXdnOC9WTzFtdEFud3plZmh3RXJqejNL?=
 =?utf-8?B?aW5sWllQTkhEVE1udUVrWGVicmp2dmwrVlRYUVJxazdVcjhISWxaU05xd254?=
 =?utf-8?B?M0FkSVcycE5TK0NaS0pnTk1HcWd2bEJEMnorOE9oZHJoQWt1T0U0eVIxQkdr?=
 =?utf-8?B?MnF1enNRb2dyc1psaFRJd0JwQ3IxaFJXS3B1WlJldFowQnRqS1k2VDMxcEVK?=
 =?utf-8?B?V2ZHMndNMHRJeFZDalg4eHZOYngwT0VQT0c3b3BFMHlXQ1MzNVVjUjFZVFZm?=
 =?utf-8?B?cFpLRER1NlFHVXhMOVMzdzhTRnY1ck9wclltT3FoMmo3blhkOXRFYzFORmVj?=
 =?utf-8?B?aEhnbjc2a3gvS1BVRTdlaHhkeTV6WWRTL202bTNCY3g4QzZRMUJhQnEvdEFY?=
 =?utf-8?B?Z0RMamVWdk94RmtNRnI1UzNmeG9FQWF1YlVQL2pSTk56UThZUUIwaTZESktD?=
 =?utf-8?B?K3E5cm56Z1FhWGM1VmN4L2NSeDN3MnErTDhLQTVURDRtUmdHU05FV2V3Nkky?=
 =?utf-8?B?OER6S1JEYk1FdW8raDNKb25nUnduWjVtOUppcGk5UGgvRmVrQkZmeVRnQTRE?=
 =?utf-8?B?bFh3TTZTT3pjWitZZ0RlWk1mRzJsNGhrVVBOWDhidlZVZ1h2MFFwR000WGcw?=
 =?utf-8?B?d0tQWklPdWxxN1YvTndZaUxsS3c4cWEyMkRWQytKOTdzdWU5SHFKaEcvbXgw?=
 =?utf-8?B?Vi9RUUQ3bjhGNHJ1Ri9CSFR0L1BpWjNYNFBvU3J4eTY5cWFiTmJ6YTBBNzlV?=
 =?utf-8?B?Ryt5UnpwRU04UmI4b0w2T0M3aGNUaU5HV0tpUGVsU05LSTd0b0Rta0lHaCtv?=
 =?utf-8?B?NjY5Qk1NdGtrQ1ZMd3RUZWtiTGJxcjh1bWNWSGQxa3p2eTNkeW1aUjVZY3Jr?=
 =?utf-8?B?VlVKK3FkRjRpdEJ6cFUvQjJZTVBNVEtBblVIMlJsNDcrS2ZreStsc3FLcEJ3?=
 =?utf-8?B?VjFUTjFsWHBGL2cyTWN3dWNNOWdTcW5TZi9RVHNwdFhkblB1M002bExSK2xM?=
 =?utf-8?B?L1k3RHFRMTczV3ZaVzhHamFySjRaOTVEZ3ZoZ3pHcmN3VnBETld4S1JCZlNE?=
 =?utf-8?B?U2U4SENFVWpkZU1ZRmkzc3JwVGpJZ1NPV0NxRlV2MlNkT0pUczhFK3JYV0hh?=
 =?utf-8?B?OUF3dzFTSFdsc3dpM0p3ZTlqeHJUdGFDSmZoUUZ1RE9zN0tOWHA4NUFLa3dL?=
 =?utf-8?B?VUt2UUtGYlpuYURqTlcvbFBOM2tZZEFQbnJjR2FXZERoYThjd3ZGTllHWGpq?=
 =?utf-8?B?TE1VdDgranNGci82aktvbzZJTFh6eHFSWFgxT3psd1JBV3paVkhSb056KzFC?=
 =?utf-8?B?SDhpZHJyZGdBTTdESDNFenVFTW5Ld2xoaWtUdnFTOEFJbkNqbXNlNHBqc1VM?=
 =?utf-8?B?dU9kbklPazVxODlwa1dWVVVKek5lL1F4SnRLRFpQQjRBT0NtamtxTnJ0eVYx?=
 =?utf-8?B?M0xNd1pFLzhsVFpzSU4zdnEwMkQ3UDRsa0RCTW1KS3h3RWhUSnRlSE11K3Rx?=
 =?utf-8?B?OE13RmlkbEJRUy9HUnhVUTRKSlJyNWtkSG9tbmx6eEJQcFY2UkQvME1NaFFD?=
 =?utf-8?B?bkwrTFJwZDVxMUFySXZ5c25VTXpWZGc3K1lMSVQ5bEtzWVFQT3dpNlRvUm9N?=
 =?utf-8?B?UThWVks1bzIrbXFDU1VQVHpuZVRtck1nTGlQN1ZuT0hlbC9qT2EzSnlTdTli?=
 =?utf-8?B?ZExReXZIbGFQYmtrbWhGNnExRVROc0V4bHV0aUVNUlIzL1YwdGpxUThOUG04?=
 =?utf-8?B?bDF4TnZxYWJRUVZwNmxjYXZqYUxVWis1OWNQclNBa0JxdmF1NHVmWnlNZitr?=
 =?utf-8?B?WGMzN2hzcU9PbTdNbytGa1AycXBPSUt6QjJ4SXV5c2V1dEpHNTFnZ0JBUmRr?=
 =?utf-8?B?dW9OTzRlQWRJVFZPQ2pmcFMraDhFc1l6RklYRnFQblh3WWx2bERvSXBQVndL?=
 =?utf-8?B?MFFPb1VKTFdqd1Q3U29zV3ZmYVBXZHMzVHRqaVBKd2VlaGwzaFhGb3NkRTQ5?=
 =?utf-8?B?S3h6YXRUQkZsdkxyNVJ6em5EZDBSdjc1dTdrRkdTdjZRenZzbEdLUklsYUVO?=
 =?utf-8?B?YkhLVmhOeWtNb3lwcU1lZjlCaGNueGFoRjRmUUhvVnVJUjNQMENLNXB5S1M1?=
 =?utf-8?B?emc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 865f3865-a418-4b32-4a40-08dac281d68b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 18:40:13.3931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rzhSyQvXFogwLJSa4k0q5aby8/Mq4sVYmA/ABbHSDWO/Py67KJfd/vHw7RPl3bT0A19+jzrawvo96BulRaPJ71c4EfRTcssLhfjvKWVHj9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211090141
X-Proofpoint-GUID: PrBJiQku4PiAj9DAtGcYP5iYpIX2V99M
X-Proofpoint-ORIG-GUID: PrBJiQku4PiAj9DAtGcYP5iYpIX2V99M
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/22 2:19 AM, Zhou Guanghui wrote:
> "unreferenced object 0xffff888117908420 (size 16):
>   comm ""modprobe"", pid 18125, jiffies 4319017437 (age 73.039s)
>   hex dump (first 16 bytes):
>     62 65 32 69 73 63 73 69 00 84 90 17 81 88 ff ff  be2iscsi........
>   backtrace:
>     [<00000000f78a13b3>] __kmem_cache_alloc_node+0x157/0x220
>     [<00000000200a51a4>] __kmalloc_node_track_caller+0x44/0x1b0
>     [<0000000033ea4d64>] kstrdup+0x3a/0x70
>     [<00000000ec6d2980>] kstrdup_const+0x41/0x60
>     [<0000000055015f6f>] kvasprintf_const+0xf5/0x180
>     [<000000009dd443d2>] kobject_set_name_vargs+0x56/0x150
>     [<00000000f3448e98>] dev_set_name+0xab/0xe0
>     [<0000000080ab8992>] iscsi_register_transport+0x1f8/0x610 [scsi_transport_iscsi]
>     [<000000005e2c324d>] 0xffffffffc1260012
>     [<00000000df6e6a36>] do_one_initcall+0xcb/0x4d0
>     [<00000000181109df>] do_init_module+0x1ca/0x5f0
>     [<00000000b3c4fec8>] load_module+0x6133/0x70f0
>     [<00000000feb08394>] __do_sys_finit_module+0x12f/0x1c0
>     [<00000000ca6af44d>] do_syscall_64+0x37/0x90
>     [<00000000132e1a8b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd"
> 
> If device_register() returns error in iscsi_register_transport(),
> the name allocated by the dev_set_name() need be freed.
> 
> Fix this by calling put_device(), the name will be freed in the
> kobject_cleanup(), and the priv will be freed in
> iscsi_transport_release.
> 
> Signed-off-by: Zhou Guanghui <zhouguanghui1@huawei.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index cd3db9684e52..51e2c0f5e2d0 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -4815,7 +4815,7 @@ iscsi_register_transport(struct iscsi_transport *tt)
>  	dev_set_name(&priv->dev, "%s", tt->name);
>  	err = device_register(&priv->dev);
>  	if (err)
> -		goto free_priv;
> +		goto put_dev;
>  
>  	err = sysfs_create_group(&priv->dev.kobj, &iscsi_transport_group);
>  	if (err)
> @@ -4850,8 +4850,8 @@ iscsi_register_transport(struct iscsi_transport *tt)
>  unregister_dev:
>  	device_unregister(&priv->dev);
>  	return NULL;
> -free_priv:
> -	kfree(priv);
> +put_dev:
> +	put_device(&priv->dev);
>  	return NULL;
>  }
>  EXPORT_SYMBOL_GPL(iscsi_register_transport);

Reviewed-by: Mike Christie <michael.christie@oracle.com>

Shoot, I see the comment about using put_device in device_add.
I'm not sure what happened, but I made the same mistake above
in 4 other places.

Do you want to send patches for the other ones? If not, I'll do
it.

