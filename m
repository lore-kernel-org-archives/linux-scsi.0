Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 652D3C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Nov 2022 13:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbiKKNqs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Nov 2022 08:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbiKKNqr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2022 08:46:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC3A5F85B
        for <linux-scsi@vger.kernel.org>; Fri, 11 Nov 2022 05:46:46 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABDhf4G002885;
        Fri, 11 Nov 2022 13:46:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=J1mRg3kdPhdjzFpyvxMnZV/7PWBXl4fFPfhWdkEL23s=;
 b=FmvqqWUyANyld/xOKQJ+CAbSRLj3gu5vYbthZgAoa8Uj2lUINJKBIV6Q+jEE9zmPLu+o
 d3kJRyzTEYDMpShxOIuQIrCZlayjdPnCdjAqCCNSIkskUMxUwgYXLpQ0w5htvt24A5P4
 +Z2oN3V+3tyHyw7aOZp4CImD3/8Pf8+0HEHNbDaYnc7Ah/D2EW82vaU/qE9+YaHPRTER
 2SKmfYNA1t1r5CVk/EvNx5hK7i3pQVRYVPfmWcxfosIaDewyqpz+6P9l8bvd8vSfAmTL
 VzFkNgo8P3DLLVx+HzDed+X4nhWxoe5DKrkr4rKMlaCKNLhmFY5gtBW2uCRzJLDpi8TV hw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kspygr490-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 13:46:39 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABDWorb022311;
        Fri, 11 Nov 2022 13:46:38 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcytc1w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 13:46:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KtoT7GG4HFrdHO9MQjmF8IMM8HE6izR8isyVQVi+qMiqOz25x6BIkS4NgajKV/03iQPKmeRMBL5EBxhuYx8Kl9ch43hzqe0sGxS1A4EgcQEhs+xaE3L58dK6F50VSjVuJeZchI5BYxuZTUNyU4GU4NGkTUyHnH0n2DjQDqPUx3of7Yo9qOP74BPRXc/+X9bCePfIOOBdPlzp382uVNmwNEIgHbPcL0o+AAqjcA+viRfe9pZkq/SttzClxkuJd0UmreqeuMwsg18cT4+x1kVCOvB0r/YiZd+iBmyAb8vYmMOvL/E2PjfaX09a6UTUO13BqfhTrjCj1VLHvSi45Axm2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1mRg3kdPhdjzFpyvxMnZV/7PWBXl4fFPfhWdkEL23s=;
 b=eSOmuInN+2CmLRKXucoM59v7jhI4qA3yxuyXDW+R5ZaWqePZ7Aj2HWidRoQOc9CZrckVifWv88dpZ/0DhDWdWyKeZlboS9tp/fgSf3ewjUSpU5uGHXNb8yWpQGei9QotHWqPEd7UAPlFn/osRfyHqujrOZV9HyKHGXCpbhSStLI+tCWymftTuzfGK7FeD6P2iA20WN8ucc1SXMETcb+k7zlra9Sh533EMWezxROXu1ChzFjPPMpIgjiyS4fsda4c+kqzy2rvuYb2sHwe0y/HIZ3kkL+z89ouTENrksyH9tPtpJWq/RoHpuZSnEsrlMGFq+8U+C/6iP00HxgIuIdZbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1mRg3kdPhdjzFpyvxMnZV/7PWBXl4fFPfhWdkEL23s=;
 b=qIWWeyyTzg8PTrRRCoT7xSlrsd09MpBWbPyGrGp++p1cucdtBmND+yaVPqJjMNBl/PUcLJxITRH8zypOn4GpATurgToFX1eliRXhZpY6ucJf6zj4FFsjfE42C9I4ytXVbtUvc4Y+CxiOxWJ832gdr9w/MR3be5mJWMADSv2y3bA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB6707.namprd10.prod.outlook.com (2603:10b6:930:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 13:46:36 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::d0c4:8da4:2702:8b3b]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::d0c4:8da4:2702:8b3b%4]) with mapi id 15.20.5813.014; Fri, 11 Nov 2022
 13:46:36 +0000
Message-ID: <103f8230-077c-7e44-9205-0fdf6dbbfa43@oracle.com>
Date:   Fri, 11 Nov 2022 13:46:31 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH] scsi: scsi_transport_sas: fix error handling in
 sas_port_add()
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com
References: <20221111132452.2385508-1-yangyingliang@huawei.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221111132452.2385508-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0178.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB6707:EE_
X-MS-Office365-Filtering-Correlation-Id: 18f503ac-7e2c-4ac5-5f74-08dac3eb26a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Nzkhsi1BDocVdk2ahImeTH/6VeBPGUfit0hkp6f4WU0SefXSSJZBgANme+SQzuTEV+F2axDe0BE5aPioHJs67xA9SdVNRhEfW/5Q38h0zx+xNOyUYaDe8Bp1+HNf6rn4IZlpb3TQUz4aN0P5UGWoHmw7YkXW2VJ9CnMPa6OlHoum0fpqzTKkpoRrVnTuR4OTiwEJNpR2ADzh+PcYKJrfntUGpu6Tns0mQR45Px5wAS5w0H3iA9AzVX966egmJizHYr2N9PdKr1+v2sMKiDOrpmM4A/MbczWtQv3C2TFDNrVaeVOR5S6aVExocq4mNMEJJ82AlQXYzUoZdGAYI9LOCwBqv0GBstWg/IJtimXs+iokQZLbl6l68hC0wdULkhluMt3lgau1m53weQEe+rpXRy8nl8KrHpuTta1lPqgH9XqF/t0XVzdCVbSHpdqmkts1iXNDiYoIWD6zGhYPanJAwXQ3tITpvugXURojupgOGzbTXimwxN58NEcN/VYKxVG5RXP2ELDhU5DPIlrTl1+FXkXxTRTIQOuMZyzP4aLCAcIclbxHmpelb3coS0cM0UEpoT3omDqQXM/1pD3DpMFXU0ZQPmkTPrH17sQAWJOyEwOOp6v/wCo1BSmVsR1Y2R83X4Ml5EKOQ89l5DbJjXNR+isgfrGSNtJH3WEGnvj3pgFEHkpenpZ8bx+s5kEY8VfccFMAruMKt2wOEcG4DY7TeKjVWQmEbM1ZtK26/o/zRmKbncOwLZHILXdA1awlUX/uP6RoQTr6I0cipxRDDy+6mqmdcJp/QRjo+Wdkwh+MlE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(366004)(346002)(376002)(136003)(451199015)(4744005)(8936002)(5660300002)(41300700001)(6666004)(107886003)(66946007)(38100700002)(8676002)(66476007)(4326008)(66556008)(31696002)(2616005)(86362001)(186003)(31686004)(2906002)(26005)(478600001)(6506007)(6486002)(53546011)(36916002)(6512007)(316002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejQyWmZWTE1vMlNNaDBLVk5pVXdKc3pWeXlka2dpRi9LcmhhRy9PRm55aHF2?=
 =?utf-8?B?bnBRanZEeGZsNC9vV20vcUUvRDhrallsV2l6dy9hWUhRdzFUUUkzNkptZnBJ?=
 =?utf-8?B?ZjZ0ai9VMFg0ekRGcTdiTTdrb011ZVlaTU9LckZiMDVvUTdlNXQwZHVlTlNN?=
 =?utf-8?B?U1d6Rm1oMDBlS0pwY1Vsd05TQXkrRFoxM2xDZm8yZ3JwOXBRNWNFTDNSUW1H?=
 =?utf-8?B?bHdLODFjR3hTVFVOR3dtZ2xsa1VpL3RvTWhIdjg5TFNZU2V6YUVQL0E1UUVV?=
 =?utf-8?B?UDlhVmRxdTNzYUIyb3YzeVFNYVBoc3lRY3FOeUJ6NllpSGRlSTI0YkJnaG9C?=
 =?utf-8?B?QytPNjJqTzhWb1FENzBTSzVtVDloSW90WGVJelY1R0R0RVNQeUo2UzcyVTI2?=
 =?utf-8?B?Z0p3dDJWcnZObE44REhOU0JVMGgwUktwN0MyU3luSWVod1JXQkNHbkliQzlJ?=
 =?utf-8?B?VEdieGdRbHVWTWJQT1hZc3h4MFNmUnZ2ZkFkQk1MQkMzU2VVdlF2eUEwTnlT?=
 =?utf-8?B?eC9HTGJBMTNnUHZQaWZTeWVLZlJ3Ty84TEVhUTFlN1JaLzJueWJEMTlncDcr?=
 =?utf-8?B?SCszVkJ4cDZlZjBOVE4yVjRRK20zQktCNngxcVdaTVpJZmlLckxSTElBVi9P?=
 =?utf-8?B?NklMWVhQZTBud0RoTTJPTXYzdFdYV2wzbWFZQUVrUmRzakk0d1R5QTdxS1pZ?=
 =?utf-8?B?NThQOXZza3hmS2xoRTNacnZ1UlJWS2V2bWVyRVhCY1cyMDl2OU9oTEVRZnpl?=
 =?utf-8?B?OXRTRW94YVd3U09abHo1WXh5UmZmSHNGSmJvcmRBdmxpZjExZDc0OEZwanJq?=
 =?utf-8?B?Lzl1Q1BNcmIySlEvVU5uODJ5MEcvM1lyQ3RtSW5VT2lJZG8xNE9nOGh5MDlp?=
 =?utf-8?B?eWFDcTB3dUNuSnVmaFI1NGxGakgyYmdTUVZIaFdtdC90eHR3YjhpL0s2NGla?=
 =?utf-8?B?QTAxVVA1K0tGSGNTMllFVDlDdmsxak0yYThITWZlTW53anlrZUIxWHJvVnpm?=
 =?utf-8?B?akxzbVBEYjZkQ0NuUVNGWEtIaTNmRFNlNkUwTDdoZWxOTnE0RGZmazlEYTNE?=
 =?utf-8?B?M3gwTkIzYmZDQ1ZWMmc2UnA3Q2YzeUNBTVIzdThRWXROUG1VMDNCN21SQmJR?=
 =?utf-8?B?blFnRXJoeUVqQ00vTGc0L3VtMXREaXRIVm1NNWt3OUxWWFBFbXphVk94bDVO?=
 =?utf-8?B?bEtsa3Q5emdoRE9za2hGZW1xcFhwNjZ3VTNVZ1lTU3lmbVA2ZDlrT1dQUmlE?=
 =?utf-8?B?QTRMemdoU2hKQnBkekNpaXJiUHdDNitIUzR1UXo0Y01HQlBuQWt5K3lCNnRB?=
 =?utf-8?B?MmFiUFNNeGp2c2sybytWMWtYVXR4WFFXdjNvYnBHektZRWVVWk9ib2cvWG1p?=
 =?utf-8?B?L1FsTUZCaHlVdGRpR0laVEhib1NxK2V1R25PTWJ1aTdBbER5UkNBR2VCUzJq?=
 =?utf-8?B?RTQ5bEozVFhTUm5QanQ0ei9KWXJuYkFpenJkTDBpSmpweDV6dW42bjlMY0Jl?=
 =?utf-8?B?bHQwOVFKbDROa3YxbjBSd2RVeUQzcEQwTldDNHNEV2NNV3RiM0c4cXpLZTY5?=
 =?utf-8?B?dXVIWU5qTlNLdkxsMHdabkI2MWpMUGR1eVI4UFRlUHVCWTM3WW51Y25hdzda?=
 =?utf-8?B?Vi9MNXFGY2NSUDFNLy9sTFF5Y3B5THpuMFdWYThhaFYvTjhDa0hQWVVvaFhq?=
 =?utf-8?B?RVZ4WERHSXB4SzNiVU9Kc0lFOVBhUnUxQkZhSE1aVWlCV3MyODRzQ1pMUTRx?=
 =?utf-8?B?ZXp1NUVXT29samxnWXVNeVpiZzZVSlBqaEk2azE5UGNJcUtxY0YreXFLVnNh?=
 =?utf-8?B?ZUZUOS81UTkrT3pxdm5TMUpvNXVKQU0yOXptcTJPYUFzQUNaN0Y5OUNYQVVS?=
 =?utf-8?B?T1p3QlZtVG5pNDlWSFFxN20wWG15cDFxRDJ1bEc3TGRuRkZ2b2tGaFgxS0tL?=
 =?utf-8?B?VFhaa0JHOUVKdnlpcFhtQjFXMldLUUpyNFptQ3F6VjRReDM1UHhDVW9DclVE?=
 =?utf-8?B?N2RUb2oxd1Vjb2tNVXlwV1BNSkFuRmpyUXFHM3V6ZllEcTh0alRwcHFUaVJV?=
 =?utf-8?B?UFhUaTF5VDcyVWs2K0FlNEpJNElwMXNvczk3emNxdDZENUcwMXlITWlsWStl?=
 =?utf-8?Q?eLY9IPRXyh2QXuPurIkmlqdNF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18f503ac-7e2c-4ac5-5f74-08dac3eb26a9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 13:46:36.1586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4LKpZnYDq9UW/gD4BMEjgdguLneTE5cd33bWnGJidArW3wvUwRfKJ8lbkkKN/M6PfLbtl+D4v9qXENM+YrTnwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6707
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_08,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211110092
X-Proofpoint-ORIG-GUID: cO7zh3OCuFHCP-u547-Bx_n2h4prYG1G
X-Proofpoint-GUID: cO7zh3OCuFHCP-u547-Bx_n2h4prYG1G
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/2022 13:24, Yang Yingliang wrote:
> In sas_port_add(), the return value of transport_add_device() is
> not checked. As a result, it causes null-ptr-deref while removing
> device, because transport_remove_device() is called to remove the
> device that was not added.

This makes it sound like we have the null-ptr-deref always, which would 
not be the case.

You need to make it clear that we don't check for an error in the add 
and we may later go on to try to remove a device which was never 
successfully added, causing the null-ptr-deref.

> 
Apart from comment, above:
Reviewed-by: John Garry <john.g.garry@oracle.com>

