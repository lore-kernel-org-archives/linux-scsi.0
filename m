Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 227DACCA479
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jun 2022 16:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243754AbiFTQDm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jun 2022 12:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiFTQDQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jun 2022 12:03:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4792DB22;
        Mon, 20 Jun 2022 09:03:16 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25KDDqti031145;
        Mon, 20 Jun 2022 16:03:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=F/PVqZcyTzNldMcBUtiheuDu18RSq1Z4oX8DxaaA+9U=;
 b=w9I2rdryzwYwvZFaMpOHwPg/GsGbsiEY2SjMVcRb4fDqvwt5vqESY3BrP2Fyqc1mkdpm
 t8w6LuZTu6+kDIxbkwulMtAdmcIf4SBjhwBGThv1D3h3BL4DfaZXRKf8lCCfzs7QES3x
 LaZnlDUL1sichB4pbnaMBIdn3EoVLaOdclzB1nxZ5mo/5ScLWdytm8zjhKNIP4UfQCUj
 ZHV0Z6bxwYBLiF8IjSX2T9txQ78lMeSuAck0nD3fOUr8uNb5/97KYs5kabeZ8+2lmbHG
 aL0cLeBJxHi+8jQUFOipiKyGirtjiH6e4m5pGiTXEO5g3KrmA+7RIPoGWXcf+q3Ud4Ib HQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs6kf3k8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jun 2022 16:03:10 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25KFugbC025636;
        Mon, 20 Jun 2022 16:03:09 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gtd9tbnh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jun 2022 16:03:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kRw8qUNIV01iijYijpx0AhO5FPHXO0wGp9TfuOFGrFAjae6smaeldjP/HtBw8A9kYmEBAIqLtyjGpdcgxrfHJDqk5UiRnevORng1YBlF8h4sSJpBivUYZyoYOxmwD+SuFlIf0djhNEC8Fi2oa4Lls7LqE5JF+u5rj2PuEVMEOmVPRkj+T1k5Z7sTmokWq9/nraka4/qtlUoDcyOVpDL4Giwp1oQXX18btUiJ09+Cqx5/ftO5Acr4Nph5r4wjdGww5p+DSU4JTLFqeqtP90fYOsHwc2NE+WR+zWvA3cVRTFe1+fN9ku6/GVzIe0QcxVjh7ZJQ9Qp1yhZmhJcYxchm3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F/PVqZcyTzNldMcBUtiheuDu18RSq1Z4oX8DxaaA+9U=;
 b=iM6yC/JEwLa8GRXL5M6pFGaaO4SNFd0pVePrg+GCVWLRwlSTHtFJsexPSiKu0YRUUiSgtMq4rPOJAm4IdErjVxbB69tC01SvB5188RCRjV5QetS1qjV/6EK+pAbB8U1nzpLu4zitQmTjd2T+X1/Vy9ZOw1GOQQRrulIL7JcJob+Z2HDMnMHgwe7I6NiQSl/qzMkLsXPhnQvl5fP/N2FZnR+Vj2dw+yOL8MqPMK44vqVykZswKGav74w1yDZFZB8CmmwA+FmFXJxvTXHOsdp5pBgzUYFlyMe2x432iYhsouA6kjI7lGhevACYe3SgD+5fKR0BG/SMmMBx5NjUf08G8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/PVqZcyTzNldMcBUtiheuDu18RSq1Z4oX8DxaaA+9U=;
 b=IPQcZAHmDIeh6beC0GM2T6KQOsSz97P913P1elVSQCu3TJU0ra21ZIBIEGqFisKYnAKEk4RAOQ/+YwhX1Hh+sHXzcdXfNPAWb6EaNlPKhAQg5UVhNo5MY4/8ZedD3KzYas2SmvJmZRV77GfMjE2rnGblFDmGV7BT1YBgKm3Q0xI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3980.namprd10.prod.outlook.com (2603:10b6:5:1d2::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.15; Mon, 20 Jun 2022 16:03:06 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5353.018; Mon, 20 Jun 2022
 16:03:06 +0000
Message-ID: <2de356ad-2b40-b3ad-57bf-2194e1decc64@oracle.com>
Date:   Mon, 20 Jun 2022 11:03:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/4] scsi: target: Fix WRITE_SAME NDOB size check
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220617030440.116427-1-michael.christie@oracle.com>
 <20220617030440.116427-2-michael.christie@oracle.com>
 <Yq7AmRBWtkyqzt0g@infradead.org>
 <b154e89c-6b83-2d8d-0505-06fc3615e8a7@oracle.com>
 <YrAXdTWu4/xsdWgq@infradead.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <YrAXdTWu4/xsdWgq@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR21CA0032.namprd21.prod.outlook.com
 (2603:10b6:3:ed::18) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30e4663c-3588-4720-d99f-08da52d65cc1
X-MS-TrafficTypeDiagnostic: DM6PR10MB3980:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3980274AEB4F1E8693233966F1B09@DM6PR10MB3980.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nx8mshSoTgHEc6o1LZ+MoIdk/CxeOHX3i/aPL6Ssp+0Y6zakqbBmlL9SEfL0GucPN8KI+4+lwX/FLoZIzCOLisNKVLhSJX5Q3hXxyjmnH1588RRVTUEg2EQV52htHLc+Jww3oJ4pSBw0C4wRUr24+l8RdN8kO4ZdgZnzLgD439YKb34Fd9gktzSDNJ5kq0PpPXKRTTguVScOJsTU+MNXD1vBAtqGFDxrpxGMj/dQuEyiabsBwewjfFVk9+d4sm3BbC+HbcNvzTe0cIYqvNIxxQKq2cV/uP8t4MoiDipctJG4YvHhciOcptOEDrXWWfmW+2SamscOFkKyhUQaWidec/SQlHMfaQTe+NpqHlXfKYzcTZ7WaNQSktxNUOEKk8zRLaqfcVLUVAfDYwUU+vHR/9kkKBiEHNUgr4pjyYL5tktbj5mK1QXbHHV0nNpwwINGp45L7hSC/3tfbjXMghwcSdby3bGRDa+4DG1ZAOcCcGxwieMH9C3sp3wXBGm9mdKP7fgeim4NuXJeG/a8sCRjvbePzXeAdvbtzaTc4BlJXTTMpZTkjShJSoXoyjxhupSKjpW3GE+B1q6AOBc5G5MBMDnqiqst0T6YZig+3jJUV+k/gwnYwZz+WFE7A5G3SmiJIAezlDCuyJN22q9tIcnLpVg1lwQWWj/AQwlLXziLtOw4PfhoLBy90t8YhitJGyvbhQ8rcEQvSgxuO6gOT0UeZZuE3znPM9ygDuSEzQE/7gw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(346002)(376002)(136003)(39860400002)(66946007)(2906002)(8936002)(6506007)(66556008)(6486002)(316002)(6916009)(4326008)(478600001)(31686004)(53546011)(6666004)(66476007)(86362001)(2616005)(36756003)(83380400001)(41300700001)(38100700002)(31696002)(6512007)(26005)(5660300002)(8676002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjVEOU8zWXFubGJvSXlhODVKZ1dZbG5ab0dNYnBscnFhSHpuRkx5Ni9mZS85?=
 =?utf-8?B?bDBWN3lkTXZHcmpyWTE0VEl0bSsvMUhDV2VTbTJnOWRZMlFuc0xobTlFUlpx?=
 =?utf-8?B?QjdUeEJ3MXhKdG5qa0NBNzdBTkdUbDNpbnN2Wm9Na3RhWHBuOXpFTWlpRmFv?=
 =?utf-8?B?T2ZpeHBBUDRMMkdvYUVRTmoxcnBNQ042NlBYcVBUODhBclU5M2Z1NGI2QkFh?=
 =?utf-8?B?TTNDMTdpWUt2UHBMMi9YSnloNnE5MnhENDJOeW50MTNEZ1p6d2VEcEtkeVR5?=
 =?utf-8?B?UG1RczZvbjBpM0M1L2pSUnZLbVdOODRDVklMM0FzdUVqTERYNE9RaDQ3Q2lM?=
 =?utf-8?B?UVI4VlZZYVhWVVdqa1FxRWlSNnhaeGVYTnVhb1dEaFEyM05rSE1FSjFRRVBv?=
 =?utf-8?B?a3BwZ1huOEV3Q2tac2lscjZvcTVhME10bGZnaWh6UDlVOHNmRmRxc2hsQ2k5?=
 =?utf-8?B?K2RETmlVNHhQYU13eXNvYWZlZnZPQ1M5Vno4bis3YkZYSlBvY1dGS3BXWXBw?=
 =?utf-8?B?aXBRa2tlLzRkd1BOODRQb2hsaVFwQUN1a09QNEhYQUY3Y1VWYU1QR1VlOHlR?=
 =?utf-8?B?UWpGbm9td2lBQ3p2MUtTcXBxZ1pYOVM3QWltY0dYYk81dkh0emkxLzhMQld1?=
 =?utf-8?B?bitqWkh4V044bm5hWlVCZmpZcEw2OE9TaEJpQ1JmWTdCN1FwMGtXcVJHWWVD?=
 =?utf-8?B?YUZObHFWOUlERUxmc244bHJid2g3NjhFRmMvTk9MaFc4bVRINnJKeldzZlNz?=
 =?utf-8?B?bU1yRUxUSnl1TVNWcE5ERlpmaVBBRklqM0FvUlJrODY5YW1LZDBsbFMvc0NQ?=
 =?utf-8?B?RHFweDdNOFNzY2pvUE5YL21pYURlSkMyZFNTWTdFbDBua2Y2MjFVdkFrYndI?=
 =?utf-8?B?NTNJVDNiR3JjYkxiSmEvczhnYk14aTh3d0wxbno1OHM3SzFPNDRkQkN3V1F5?=
 =?utf-8?B?cmFUbEt4WTR2czdkZHduclU1ZGVaaDhidVlRejRQUDQ1T1FrRVFTTUVHWW9V?=
 =?utf-8?B?alhjaDZ3cjcxSGFGNk9mWW5HZzRTWm5ZSEJDeGh0L3lHTUFCMjhMVVRWZ3RY?=
 =?utf-8?B?UUlIYnFoeHk1MUxsYkVUK040ek4rZThSeDlzOEMrWmZzTTI2QVBua3JPNE9E?=
 =?utf-8?B?SmlMT0syemgyMVRXQXZ5SUI3ZEl0Zkk3YVVjVFBaQ2x6TFZCeGMydXpZYk1W?=
 =?utf-8?B?SnREandQUGFkc3JYTElQeXpDOUdYdHA1bzZBUFM0bi91V055bGpkWXh0WFls?=
 =?utf-8?B?Z3hPbmlGYUtzdlBVWElabHpFWG9iRll3QkYxdE11N0Z5S3NoKzEzK1oyOTBC?=
 =?utf-8?B?ZGZMdS8xYm12S0x3azZDWGpGNzNvT1hWRWQxTm1DQkN1Y2xaM1MvNDJ1TUI1?=
 =?utf-8?B?S1ZCVENuWTRGc3Y1V3cydmphNm56a1JlYzBXYm91T1c1WllQQnl1TVdVTjQw?=
 =?utf-8?B?M2NPMHB4OTFTb0tKYWhkVjJucGhpS0tKdFJ1YVB0VGFuejlBUHRWbTFRYWZK?=
 =?utf-8?B?b2F0eG1LVDlCUWNqMlBTdnlWODZSdlJ5cG0rTUtOZWRIMGw0UzNDWlN3b0dy?=
 =?utf-8?B?MmNZMXFqeVoxd3JNYi9BRkRlemozNGt0Q292c3EzQTIrWVM0VFFQalZVWFFx?=
 =?utf-8?B?eFU2TllEVmFFMUVxT1F2ZFd1YVRvQU9qUlBnNnV6UFBkcjFLM1poZU1PVE9n?=
 =?utf-8?B?SldRTWd0YTZoZGlQOFgzOTNoVTYvTGxvOUZKYlVHNlIrNWoxbktQbzRMSU1B?=
 =?utf-8?B?b24wVC9HdEtCK1JWWis2aUxtK3czRjlIQTRCRGhheDkzckt4NkdRYWNVdE5u?=
 =?utf-8?B?dmM2TWsyRkJaYS9wYUtydjkrcTlFN2wvYzZPR0RNVGluTjlzR0dRc2xUSW1Q?=
 =?utf-8?B?cjVGSkVtUVdUakp3VjBVZ3VNNlgwL3N4bGxTZ0NxaThjVktUTURLdmU4ckx4?=
 =?utf-8?B?QlFYNGFadjgvTGpzdEpUVnlyZmk3T05OaUlJL3lYU3h3UE81RVNvbFBCYW5p?=
 =?utf-8?B?dHFnS00xVnF0c21jRm5aZElobHZ1UkJHYnZ2VUFyejJ4WTk2VzR0aTJNL1BB?=
 =?utf-8?B?Y1pJbmRxc3hnMnpSWDBrbXgzR3JLa01rdjRWSTJwWGFza2p6ZCtrRFpkb084?=
 =?utf-8?B?aW5YQ2JnT0FWdmppdDRZZ2JvWDFSUkM5bnp1aUk5dCtCbWxETi9LaHoydDlZ?=
 =?utf-8?B?Q0pjeDcySXJXUHZ3ZWRyN1U0ZEh3cHk0cnVJUk5tWERKTFAxTUxJTzlleVNV?=
 =?utf-8?B?OEE0TmJhN240V1Y0Y3ZOVDNMMHlPMHBRaGY3SXVKc0NTYSsrQ3BSUkYvbmRJ?=
 =?utf-8?B?NTlteGZmbVUvNjYvaTd5N1pMWjNQSUN3YmF0MU5obUZ6ZGc0ZE1VMS8zVU1q?=
 =?utf-8?Q?CfueD1MeCGkocB0s=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30e4663c-3588-4720-d99f-08da52d65cc1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 16:03:06.0908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fEtTpOLICK30oljfFtkWS6clsBHKkJ16LLZW1UPFV79O9ZeFRuhNoPaK4ckbyDLCa1lEYlvg+hoNhCQuy7Ku3XG/vAX/j4WB5bKRd6a9fVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3980
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-20_04:2022-06-17,2022-06-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206200072
X-Proofpoint-ORIG-GUID: Vo9pK7kAfrBQIe46HlHCmIaTOTVtFZ4-
X-Proofpoint-GUID: Vo9pK7kAfrBQIe46HlHCmIaTOTVtFZ4-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/20/22 1:45 AM, Christoph Hellwig wrote:
> On Sun, Jun 19, 2022 at 11:25:33AM -0500, michael.christie@oracle.com wrote:
>> sg_write_same allows it. We found the bug because some user just decided
>> to do:
>>
>> sg_write_same ... -nbod .. /dev/sdb
>>
>> and it crashed the box.
> 
> Oh.
> 
>> I didn't know about the MI_REPORT_SUPPORTED_OPERATION_CODES part of it.
>> I don't need support for the feature. I just want to fix the crash.
>> I prefer just returning failure since nothing ever has ever used it if
>> other people prefer that as well.
> 
> I think the feature is generally useful, and I know Martin had patches
> to use it in Linux.  But I think a minimal fix for the remotely

I'll work with Martin to find if there is an oracle user to test and on a
longer term feature addition.

> exploitable crash has the highest priority.  Where does it crash?

It crashes when we first access the sg in file and iblock's
execute_write_same functions.

> Maybe we just need a better sanity check somewhere if a command
> claims to transfer data but has not payload?

I'll look into it and send a patch.



