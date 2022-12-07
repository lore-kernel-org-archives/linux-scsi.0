Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A0DC47089
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Dec 2022 18:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiLGSaE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Dec 2022 13:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiLGSaC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2022 13:30:02 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509F36A759;
        Wed,  7 Dec 2022 10:30:01 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B7GDvQ6010303;
        Wed, 7 Dec 2022 18:30:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=HRG45PEH+hJTJ5MEALjweGxX7pSV0FryiClgE4VSeuQ=;
 b=Hn9sBd7KLx9Z4zzgVRey1ZUS26Ookre88IXrTee8g4YfmNAQQSrV5e0evBUEmjBNUHQW
 aIQGUUz+3+rxofgHYMDivNVRBeluR1QSwuNKPqp4/6tPEhK+wpDpEicK8icABoOEBKlK
 5YteHeQEqZOcgHAfBLdg/GQIQCBI7Wq5tr2xQn7eMDAOZwcPGv7Q8ZakBgelmmLvvrHa
 ajv/GbOi4p5eluQAF9ho7L4avvsmNAd0DGxLSz50CMP5MBtZReckZIKQ6Bv/6fsPR/HV
 P3oWdC8jQA+kb0n0z+JBdVA8dofdKY8ZOvqcB1KSJM6KPjbB94CmI/ORQx3zMjxTb2yd 2Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maudus194-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Dec 2022 18:30:00 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B7HWIhX033891;
        Wed, 7 Dec 2022 18:29:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7x02xw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Dec 2022 18:29:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L3Kw7p39FWnvSp3iMakiaiHLa7B0h6VNaRMD3+92wN26TuGzoilXLAWOrTJr+zbwPCwDcPgQ2b93v6VvuqeCR3v1ljZCbGFVo3AJfD/lvvgawXw1Vrgk90TlI9hdcUyP/m4HXI+BC+XjqL+nwGXShHbZDAyOIPHx+LeXDS6xzwI8dxyCB5OHdwXwRg0Ckhk18FaYpYuUXXBQ9Z67djbYc2mBRJQ1Bsbc9hAWYhD2TUVoQpykG70V2JxfZd63RtcV6DGmbQvZ0kuYxzH/XMtdgeOKiicTv693iP53MylFgKILSDchLRWzNX6tJT7VW/4OVnnSSpJ+WewOYKnMhGcAoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HRG45PEH+hJTJ5MEALjweGxX7pSV0FryiClgE4VSeuQ=;
 b=kcvT55E0p4hNirCSCmIMY9OUC/ugZwHFKYZ/c0Q/whSAZFTiNcxc5TnhNsYiLyWwG6plEOu8HLmvzjWPNj8aYLTnIS8vFep/vhGjHl2BzsdMaRBRYsFJlBIiY2CEaERD4yySADqMlp+/q4fkL3YkBixGiJFgsRCHtn3O+2qAnbmyn7pB6nh3CznMmla7JO0UMZSsMnU9+x9NuW8+/cc9bZ4krB/TLW49Fhbt0vHy2ZILokCkHbKW0xX5GKzfgodhVZOtWc5Tc4rKgjRoGWZ1KKAggmWELgWw9gbVyVHb5NsPxTzLZwkYXeP3pNwiH/cJrVq68HaRRWwNQ7kY5eKNFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRG45PEH+hJTJ5MEALjweGxX7pSV0FryiClgE4VSeuQ=;
 b=ketOAdQvg6zCQR5ssrJbOYV8AgAaIShX1s35iwoaqA5/3LnjXPYUWPq591FJW342cF2pgWFKrKUTxUj0lDVhKV4ZP0GYRq/ISb9v1hMw4F42CGO8vQgjdQd7B76oqOZtkElzoUjMuOObYQHNXgvqpnVbfnsmqzE0qmiYYkIxvdk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5321.namprd10.prod.outlook.com (2603:10b6:610:c9::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Wed, 7 Dec 2022 18:29:58 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372%7]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 18:29:58 +0000
Message-ID: <ed3e5f22-dd2c-2952-dc7e-c47bccf66611@oracle.com>
Date:   Wed, 7 Dec 2022 12:29:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] tcm_loop: Increase maximum request size
Content-Language: en-US
To:     Nikos Tsironis <ntsironis@arrikto.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220929115504.23806-1-ntsironis@arrikto.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220929115504.23806-1-ntsironis@arrikto.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:610:b1::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB5321:EE_
X-MS-Office365-Filtering-Correlation-Id: 81b21962-7af8-4fbb-a0f1-08dad8810b37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pVRBQTzPpKNbjo6qhJydqV61qynE7hJB2J7n3afMkgnZVu2bnFqt1kOVH31zB/TmZ6vQcsaH7/IBblhdFZh2gZDT2Ztk5KgExr66XuQGIqwg1Y6n2C7uJRNpoDSO2Ss/H2fy4ET801TJesoW43uCmUW2ZYyxlxjH2P6pw55AEbDz8DTPqGdgx8d0uENBRtF3CeQ4lPc6ohAxTHqdPdowdyY7Vyo8hPspkpC58B7fWEqHYNQXF2spOLSydumnFuq6w1PizP00jMe1mMnzWhGcbjzKAZYJ+xyMftfVuM/oFTmHeDoMB1Y7qqjlHnhMGIfNaqibUe5pIB248qr6Wm7DaTDKr8B5Ke1HGpS4BF9thQfzrBNwL8/vz+2Xhi/IWG+A8aWVCrLm/sBuJeR016trQVLJxOoxuYA+9MoilECN699U4g85QEuRCmPklvhJXL/5Y9KtksVaqPy4UAQYTSd4rF3qSi4Ss0vmKKorUix7WW3Jpb6y0op6tTG9y/fUsJfVybRpHn0o9qSC50a8VZDFw8gthACgUHzNbE7GAYg7jsDKDBoL3BzvjcqgjLry/BhLtsoe+1WgemD8lUQsevmEeS2PCyAtLV+mblaVJZA4jvcqIprkfV1fS7/I93VSd5XYZ0kUhIaTX2Grpsdt19SeGiUorenXW51NKoO4Tl3SRmgksX+Qw3BangkHQ7dju8nTPdG46Ik8v+Nz7koENYjkYPq2wWLix8QS3hiviEOlTGs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(376002)(136003)(396003)(366004)(451199015)(6506007)(36756003)(38100700002)(86362001)(31696002)(6486002)(478600001)(53546011)(8936002)(26005)(5660300002)(41300700001)(8676002)(2906002)(66946007)(66476007)(316002)(66556008)(6512007)(83380400001)(2616005)(186003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWxVNnhoc3RIRW1QTG4zZnlmMFZKR0JncXpVclNTUXFNUXJQR0prUnZqNGp0?=
 =?utf-8?B?ckNpeVo4amxlbzYyMUF4L1piS1pPVmZiR0JXOXVQR1ZzdUZlUkZSVlh6QWwx?=
 =?utf-8?B?T2VzT1BTa2pXOGs0MzZIZjdZNzR5NEdPY3JwUURZQjlxTU9pUHh2TitPYndC?=
 =?utf-8?B?N2M5UE1wZXhJcENLZWliMUtRTS9HZE9jYW5qejdXbmk5MkhWR241WG5NSERI?=
 =?utf-8?B?WmpVdGtEcU1Kcm02dTM4WVptU0tTaUxkWWpkRGJ3OWZXOUo0VFIxeHE0M2NU?=
 =?utf-8?B?SGdVT3pvaFcvVHBjQ1FiaURnSlRqcjA5RnhKMEpJMzBnMFBlRERHdmUzVys5?=
 =?utf-8?B?eGdvTzlrem4vUHVMVnpHMm40SS8yMUJva2U0ZlF5QlJ3WmJlaHpLamdBZlZO?=
 =?utf-8?B?VGZSbWtHQ0VIT2xQK0dDSTNrL1Q1SmEyU0hHek94WmZvVlF0MUZIeDZmZGdK?=
 =?utf-8?B?Ri9UVCtHMGFsblF5U1E1cXNYN293Njl3OUlCRVFCbnpBTmsrKytQeDcxcjJs?=
 =?utf-8?B?MDlxb0RtbFdzVHB1eUZ5c1kxYXZvejhWZ3pNUUs1dzJFNTJOSURCRTF3YS90?=
 =?utf-8?B?eis2QlFBQ1VDcjNKMTlJNzdsT3BFKzZUTWY3Y1dTUmVtUGJqK1Fsa3JRK3BF?=
 =?utf-8?B?a2hBNUlkY2FuajlRdHVJMzhxUy91ZmNJVFNCV29LMHlwS2pzV2R1Z2l0SVd4?=
 =?utf-8?B?SGdzcUtXaE56S3RFWWlnN3RBVkhQMmhEUVMrdEFyWVJMQ2dBOVBIcno5WjN0?=
 =?utf-8?B?WlZ3ckRhNGVNcUp0KzZWWTNXbWp5dkozbjhjUC9qM1V3RDh6OGQveTl5cHJU?=
 =?utf-8?B?a2RqUWRGc1orM3RzMDJpSmxXb2VvRDFkSGZuVmd3WXJycXVOeUpZb2dJN1ZQ?=
 =?utf-8?B?WTJhSmVlUHhtTTJ3RHpJQzdYdXZjdkdTUWJxR0xWdjdvakNmSXhtSlJGcGUw?=
 =?utf-8?B?eHJWNmN0NjNXNTFlZVVxbWhBQ2w3QzJFSUl6TjkxUGpnRVpodDdCMlFTUzYy?=
 =?utf-8?B?eWdnZ01waTZVclMxR1VxL2VNSjd3cllaeDNBbFZzYWlpMysyR3NYN0hrQ05C?=
 =?utf-8?B?ejVpRmRyMm56WmRXdkVOZWQwdHZqR3I0ZGhRYkpqWi9FY1hCV1NITVBkdjRJ?=
 =?utf-8?B?NlhFK1hncEcwbFV5dy96MEpWdDNXbkkrQzhzUTRlUEEvV0RKZ3hxTkxxT3kr?=
 =?utf-8?B?MTE3RTFISGFyZFRTb0U5UldRai9iQ1MvK3VzdDZ4SWprejBsb2doWHNOc1Nv?=
 =?utf-8?B?ZGZPdDBmc0ZPRXFtaXhEc25rRVRPSE1PYUxmMFR4dGgyL3psdjZzTHl6WEd6?=
 =?utf-8?B?WUVNd2lDci96cGdaSExlcktHbWZLSmk1Z256c1ZPMDdsWnUzaWkyWmVPN1Zs?=
 =?utf-8?B?RS9DSWJiK3FQaDhla1pNVkExNVVyWGRlS1hjNU02RkdVV1J6cUVrRWliYVAx?=
 =?utf-8?B?eGxVOS90Y0FKZmE3OVhtV0l6eG9CQU1GTUJwRnpSaHNLUEFsdkk2bHhQMitn?=
 =?utf-8?B?SlU2THRYUURiN3hKdnhVaTFFUVNDYVJpQ3JrUzM5cXJvVk1DckFpckdaajlM?=
 =?utf-8?B?emNKQ2JlZVRLVnpKWFRRTVRXY29GVm8wUTQ0R3RHZUlaUnFLKzA3TFY4N3BC?=
 =?utf-8?B?TklWV2RYemM4ZU51YlZLT0FlaDVUTXFxQ0RuZkdydkt6R3hvL3BWOHFQR2ZU?=
 =?utf-8?B?NDcrNUN5dDhIbG1yZFZlMzZKeGZpdzhEQVJEUmhyQ0E5MnoyeHdBUENZc3lr?=
 =?utf-8?B?Y2RCWWJrVW5PU1UyQUZlclhjUTdTaVd3azg5YkFZVkMzSk5XK1gzSCt2M254?=
 =?utf-8?B?aTRCVE11SFptS1NTZXd5RjdveU5rbnI5WjZtYVI2RWQxcy9rM1dxcEFmL3hm?=
 =?utf-8?B?RFQraEkxR09ETmhpbU93bitidVgzZUcyRDRySXFQaGM2aTB1T2xIYUxvOTBq?=
 =?utf-8?B?aDhPTkZwTWU4bUZXY05admplYVc3YXZVY3IrMU4xVThDY2FjRkRETjhkQmpn?=
 =?utf-8?B?L3MzOUNpU0NGVkluRDdMalB5YXZjNFBjbWo2VGk0cmE1b1lKNlhCUDA5czFr?=
 =?utf-8?B?ZGk2SWJuSmFvdHJDTW84RVUxVUdHOW5pL0RYRGh3aFlUWHJBUWl6SUJIUklE?=
 =?utf-8?B?c1pJc1ZkVi9pS3c5Tk5jVC9vYzlUNjR4T3JqYmR3eWlEYWJwSnJxck9yOWFi?=
 =?utf-8?B?WUE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81b21962-7af8-4fbb-a0f1-08dad8810b37
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 18:29:57.8953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2hp6Z0GMyXm2c8mmzP5jQzV3CpUORmDv91Hv8LvkSvrPImq8Cm/44wvpf0UIHbqqZMBXPJYRQ1ipibnw/jGVk4nq8ps6Ey128tVJ6Zc2S2M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5321
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-07_09,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212070157
X-Proofpoint-ORIG-GUID: JhcZimXkeF2-jlvefa7Vs9yGDRZfmts7
X-Proofpoint-GUID: JhcZimXkeF2-jlvefa7Vs9yGDRZfmts7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/29/22 6:55 AM, Nikos Tsironis wrote:
> Increase the maximum request size for tcm_loop, by setting sg_tablesize
> to SG_MAX_SEGMENTS.
> 
> The current value of 256 for sg_tablesize limits the request size to
> PAGE_SIZE * 256, which for 4K pages is 1MiB.
> 
> Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
> ---
>  drivers/target/loopback/tcm_loop.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> index 4407b56aa6d1..6d7c3ebd8613 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -308,7 +308,7 @@ static struct scsi_host_template tcm_loop_driver_template = {
>  	.eh_device_reset_handler = tcm_loop_device_reset,
>  	.eh_target_reset_handler = tcm_loop_target_reset,
>  	.this_id		= -1,
> -	.sg_tablesize		= 256,
> +	.sg_tablesize		= SG_MAX_SEGMENTS,
>  	.max_sectors		= 0xFFFF,
>  	.dma_boundary		= PAGE_SIZE - 1,
>  	.module			= THIS_MODULE,

I think you need to make this configurable.

If you use loop with pscsi, then the sgl that loop now gets might be too
big for the backend device so we now fail in:

pscsi_map_sg -> blk_rq_append_bio -> ll_back_merge_fn

So some users might be relying on the smaller limit.

