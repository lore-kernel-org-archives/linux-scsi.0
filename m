Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E4B9C04A94
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Aug 2023 16:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjHNQiR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 12:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbjHNQiK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 12:38:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679F794
        for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2023 09:38:09 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37EGTkDW003679;
        Mon, 14 Aug 2023 16:38:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=cxzYdbJcTM5zpy75Casl5hbi34l1q1cCWO87mw9l1nA=;
 b=xj4Glzl6LNzLH25x5dWtKp35HO/QU9PVBuY+VzEmoKfDxITPHcg1V5bU8Y72uft1kHRt
 ZTT1EdGBhZdCb/TbTcQINWboKD2PxNNERjB7ilXe6dz0pZZgaI+ufjXkx0uvfdB2YvZp
 Gb9CSv/ayF9FoV7HTVS3HrXOd+XW4RTMUfl8Nl1hp/JYMEftmQ3AVbHvARESYBh9XTrC
 G0dEzfNsENvgS/z7i2JGcLfyzMHVVsSeqFjdzvw+D4JkwFO/XFZNGhluJRvEg8Dkq3dX
 d5lqW3qpH/DXxuBLNwXRFoSFPDomZ2xtemPOES4h+ME3EmwFxeKN7l9o5co0peu+z+s7 ZA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3se2yfk2jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Aug 2023 16:38:06 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37EF3Z7e019891;
        Mon, 14 Aug 2023 16:38:05 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sey3ucn1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Aug 2023 16:38:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YTUR4N332l16Zaq+0M6jxXDGTUPJbL9P9rltWWZEfp3u/1tDgaVPzUIKHgYRsc4ZchrtNdveCPMVqw25YcspilV4Qa/hlyxA7MHTT9te+WUks5K62aoOjaMOiVIN7V/1OOgyCMsVOto9WuUNUo2m5x5S4MuQsSHUWToGqvdna9hSKB9r8wYkt0Vtj5YzUxc9Ec4OU8w/7x5xd9CveA2/FYUO2wW6cXadhyHLc0sVitVfGGHwFcuPIw2ZuHP8Q7qL5VvyZAc5zKfZqfmAu7n7+eoCrnTRG4eew/H+MAtmV7cqzADIoED0s4nRb2+5t7M3kyZLclTmbBeNJMhfWQVa9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cxzYdbJcTM5zpy75Casl5hbi34l1q1cCWO87mw9l1nA=;
 b=IAAsNPcM/vTbVyyJQmkY2jzimYuMbYhrq9arGPLAX4NUUGX+aSZvChiMWIlYjiI82xZsYhrGxZxo6fqxinI4zow+6qbXNQkhCUlXL9TkulwwhXwv3HaSnrV5E/w0u58bXHuTvkr02VCjG11gGreJn3GOeOEYcF+orzvSWVLaE3zxZRrdf3hQr26MjAhnOCBXWZ1hCODcWKrb4KOZO0Z5BVwtcguhfA2aLulIbcjWR5SeSz2DybhSjrI9KhExTlIeDNPrgHjuzJ0//kwMN5saqzaZEYUMUlHM0WwHDZfsxME/fBLUL4APQFbxkWM1ouIQWASOMC+u3v0HrO2gO3n9Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxzYdbJcTM5zpy75Casl5hbi34l1q1cCWO87mw9l1nA=;
 b=dPa+37x26UkNUJ3MwwnUJNQ865lTY20KqTLYIoygGprQDUy47HU9nZrk4sJZ6Je+e6wYopNLv9Z3L6RYZQpgeFfCykfRxvcUcGUu0QhDW4QKL6Ef6oxkoF46YgyTEe+ddbnXFTOiHvH72aiWtaGi57MZjUjBMlCSIRL7TbEp2pY=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA1PR10MB7555.namprd10.prod.outlook.com (2603:10b6:806:378::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.24; Mon, 14 Aug
 2023 16:38:03 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4fb9:2712:d1eb:243d]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::4fb9:2712:d1eb:243d%4]) with mapi id 15.20.6678.022; Mon, 14 Aug 2023
 16:38:03 +0000
Message-ID: <109fa142-1af7-bbb2-d7f1-2b7411370933@oracle.com>
Date:   Mon, 14 Aug 2023 09:38:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 2/2] qla2xxx: allow 32 bytes CDB
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com, loberman@redhat.com
References: <20230804071944.27214-1-njavali@marvell.com>
 <20230804071944.27214-3-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20230804071944.27214-3-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR07CA0104.namprd07.prod.outlook.com
 (2603:10b6:4:ae::33) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2943:EE_|SA1PR10MB7555:EE_
X-MS-Office365-Filtering-Correlation-Id: 29a97ba7-2255-405f-0a72-08db9ce4d46d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xsZ7zFjgd2xOQEgjvftOVbHooeYLdvbE1ngj3VatE7NRkGwExwprXOlSydoRw5oMv4qHxRW5sLk03Dm5xjKNzZyaa8+TiwbdSrHfKzlC0PDuONoR70tBSVWU679lJNLWRGQeAaSkL3hsJdcHYv+1GsbAH1DO26jm4Gsuu6HBOB0eI7xv2EpLGM8XNVgNf9XbFjPp84HA+joU8XWBO0Z0Z1sb8CsNuLtT2jrW1+qsvl2JK9KYbQu6GD8/FhKGNKuicudfoo7+e9ppcxqb12rt9cBSF09nN7C0NA1gDSTa/J723d9ncrnKEEjQ6fksMZStUrusHQMqYnt0DqgUgrhQA0J59dl4nga8Lmvqw6yEAgQvyGuepZt0Cg5RYRKucbbjtXBlyiBAS4qRsp31iYyymGBfejBHpmPT/3P2czlAOts0dPfKoHJw9/5HO0kSe1OndkXVS/TPvjISHIRk8vNQ146/RruY4YkoOMEp/DmZpN/WVG1tDuChbSzep+HPWUeCyJagWSBNwLmSkPMCbnBs2jjUKOgLxTOTeNAmZMrQ1xxR/Uma0wrK0UpAurcM5iU1acwKRQbNmKtSzGNlgBbSRR1GbSSbyDzzT/URP7D8VhimR5JQvZxSEsTvMZ0G4NSrrPKMH06pCPfs/HnD5NgX2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(376002)(346002)(39860400002)(136003)(186006)(451199021)(1800799006)(4326008)(8936002)(6512007)(86362001)(478600001)(6506007)(6486002)(316002)(36916002)(8676002)(66946007)(41300700001)(66556008)(66476007)(6636002)(53546011)(5660300002)(44832011)(2616005)(31686004)(31696002)(36756003)(30864003)(83380400001)(2906002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTN6bUd2SFRMWmZhTWo4bmhyR2pYSW9DMGk1WWtWV1FFNUcxc2M2czFDT1FP?=
 =?utf-8?B?cmpmbDZzeUNyYXhnNVBUbnVZb1FiZHpjcnlvRXd1VFV0YmVtaEtFa2h0RVRZ?=
 =?utf-8?B?RU9vaHBJTktpakdDQXJYeE9MaHFXYVBaWThSSmdoNHlUZnEzcFZQdEVjZEdG?=
 =?utf-8?B?VGFlZVkxMTg5K1l6Sm40QjF6N2twak1LRmVJTmRBUllnUHk3bTVWKytzK1l2?=
 =?utf-8?B?UDI0ZjRHQUNDbFNBMCtyc3BWNi9VR3p5T1JIaVJuRmRHUVQ3K2dCZitNWjRx?=
 =?utf-8?B?TncvOTc1Q2Y3OXJNdnJnUktuTkhUNlpaeFhKODZaa2NxSW1XNFJxWHU2OGgr?=
 =?utf-8?B?elBIbVlqWDJmK3BubGttdksyMVVYK2lVUnlLVjRwaWJQdmV0aSsvcjR4Mzl3?=
 =?utf-8?B?b1Z2MEZ0NXQyVFM2enB0bkJtRzc5enVyNGdQVUcrTW84UEhVRjFvQ2p0YUZM?=
 =?utf-8?B?VVp6Y1VQSC9RanVWa3U2UCs0RjJIWHhsUGdXNUo1ODRMd1ZyMGVWcWJBMjdj?=
 =?utf-8?B?cWlwcUhSMUFIaXFjZmdpWGJnSVpIS3M2N1pKeHNjRG1OWmZTVXpoNjVCTWZx?=
 =?utf-8?B?dVZvckVtamxEc3kwOE5MallDd2c1bWZnbkl0QTVUa0xVWkVTQ0RpYS8zU0t3?=
 =?utf-8?B?dWtRaWNiZ05MYVRPazdJd2tHbWZTWFdCWEV2UzNmVHdGV2xBVExTdy96Y1pT?=
 =?utf-8?B?enc3Q1IxdEl2YnZsVlp3YkZPMlBYZldmcHhyM016RkkwTDdENjBnSjRPVm42?=
 =?utf-8?B?WUVwRXhhZWFoTUZ6M0doVWM1NUVnOWNSdVVYOXRCa0E5RyswejI0bG56UGpP?=
 =?utf-8?B?NHU4Tk9iRzVoUUpZd0dZNmZpblpTZWdmRy9ZMDFDK2dTY3poaGxMdmhmekRU?=
 =?utf-8?B?Rmkrb1JMd2dqLzlyQ1F0OStBTWsxVFQyTVpaUlIxVWpWRmFZeHBoM3ZSWmZP?=
 =?utf-8?B?c2pFV2g3b0VDb1RCM3EwZk90TW1rdzlra2FWeGhUVE85STc5Y3B0L3FVNGl5?=
 =?utf-8?B?ZnQ1eHNMNU9nb0ozYXljZTZiYUVqNU1FbVdmeDFUQjRVd2N2Rm5sUElWMmRn?=
 =?utf-8?B?M05reUNVVlRNTFpTK3QzbHRqajhFUXNhdWtIWFlGajV0NFFJNTJXbkVCNzBX?=
 =?utf-8?B?eW5nekswTm02UForQy9EdHVIK0RtNklGWjB3SlhWY2hpa3ZnaEpRdGlWbHE4?=
 =?utf-8?B?UWpmL3hmZjV5Zkw0ZGFiOVdvdmVUR3ZaMVdXVjVYZERUZkFSNXlTNE9ocDBw?=
 =?utf-8?B?R1MxSDMwV2ZIbjNlRGFBTXFzU0lOZDk0OEx1Q3M5UXZVM29NN2M0Yi9JUlFr?=
 =?utf-8?B?VlhQNHAwajRKbDB1MUUxRzNrR1V1eTB5VUtyN25FMGUzZk53OHloWlhHbW5T?=
 =?utf-8?B?TDhEdlowKzRyS3NvQ3BNM251UUJnWUJUME1la2FKTXRyZW1yenZVR2FUVThG?=
 =?utf-8?B?UXVCcjdhbzFnb3UzR0Z4US9mYXpTQ21rc2pBVlNaWFMzeG9aOTR6eHFsR2Zv?=
 =?utf-8?B?N2NYN01BSkdsUTJOQVpWSkg3S1ZzQlpNd20rMjl3Yk42QllacS9ycGtDSWYr?=
 =?utf-8?B?b3JuSTBCcDQvU2ZEa3VValNxNjBWWW5ZYytLbnVYZk10RnBVWnM3WUlpQmk5?=
 =?utf-8?B?SFp2ZEErUmEwWlZuV044WkhPSVFHaDVjNkVzVkZ4dlZNRENudE9YVmZ2ZDhw?=
 =?utf-8?B?c1dLZFdWVUpiTzdBOE84Z3ZXNVZ3SWtqeDhtUzdBT1BZaGU5WW8yTHl0aStO?=
 =?utf-8?B?ODJsSnA2ZlhMUjV6UEJIQUhyTzFQdnQzZm5RSk9tTXlNQlkrQ3dncERXaTcz?=
 =?utf-8?B?VnJRWVFOYzNGcThmS2JRY1JHbzcrRXZlQlRRQVExbVJjUFk1R0Z2cUFMdDJM?=
 =?utf-8?B?U3R3bGFqc0d5SVdoUHYzSHRFcEVENVpSQUV6WGlXdDZZbFJtVVk0OHo0MitV?=
 =?utf-8?B?Q2pVd3AyaWlhcUcwdUJ0Uk5QZ3NZbGtrcnlyeTByRWQ1MnpqTjdmc0VFM1Ez?=
 =?utf-8?B?T0hkSWRxTWF1amM3ajVxS1E4RTRseVI5TnJ4U1I3SWRPcURwdmdKenpENEVU?=
 =?utf-8?B?YUZnUWpZbHgyYzNIaGJpWlFwWThZSnZQdU5tc2hOR2pNV2NQQzhGeVFvWWNV?=
 =?utf-8?B?VWYxaFNzNlV3a1gvZkxmRFp0WnpzL2p2OWdiRFFUeFptZ01JSGZhdGF5bDdC?=
 =?utf-8?Q?Q4YfPiJKw0SjDjKvhazaTIY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: h2QlCcPQYWEPFbTseshmF0zrxD7NC88LBKso9C4UIdGwonleC+jQ6NBFTlLDcq2g6UEVk+hoF7uwDcfs1dHfB+j6xKPZpuMJ9MV8IyeyCX/sQItiOt0TeurgsqYtEKScN+6xh6+vcY2/5Ap3GDzL7p0sYpQ1J42iyRjCNw5pWMjRyPbg9CVYJVOW00wzmU06Yn6NU/IvA2f6TX0Guze71q4fnmQTpefH861y1nJRzgLSZKr+5eZgifSew8zbcetpnTBawVN4dUwQtjHOoOAZVJg0yJctngLz2Ay6+uick0bLXNB0GaFA0pk+ALkgP+WUuVdKWR+A7H63FQEVkxC7iWPv7EpaOb0EhoDrm00IsdGUvkI81SbArzBpxWiFJuo1JHVyLBP2IexGR34pYcGUH+N79nsn5ALoqUFpAY+wOyrpqGI60ReqkcdKNL2p7ybTznVLm2w1UsS0Xu3SD0h8ZKC0HsMT//lQ9rculoMxjW6r+0209yZ2gqfM+jjm69wRR+e7SlyTtuxEW2IQx+1B2j7NjUrcCVzq4u9iVpXH1+o021zFLruoRud4Er0dwVmgtgQR3uEIlDeR8HfuCX4XyPMf0aN5o4OUwUFxzRT3EUyZ7al7EhMFq8nr0OGED0ntA7/7sv09uUwltUOy2dOA2YuaDKHDKQ1u9BBC9SxoPQwAP7bUURI6MclZbSKEeh8XAMhYhmjgX/Diie/CLukago96k94Eyqi5l9FcHGNbP6LwJ+P+6rqHDF2Q/2Dj7oCxGTlDolmS3/fSa4CQeLr2kV19WsvUESvRIyeXfn7pfLS18vP/mDNQnXMBeo6LJKgV
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29a97ba7-2255-405f-0a72-08db9ce4d46d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2023 16:38:03.5929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0QHSogtC4jr8xarni4EgIrSJuwjp207DkPmsfFWn1r/Ii8WKSnL+gDOL9NbJgFVOUnSVzSZGBXI8Uyw3SxEeOKrcmIRaO2xyMAPaDmvPdH0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7555
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-14_13,2023-08-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308140153
X-Proofpoint-ORIG-GUID: KV6BRlIN8RgZfn-r6MjRg2t5E3FwJHxy
X-Proofpoint-GUID: KV6BRlIN8RgZfn-r6MjRg2t5E3FwJHxy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 8/4/23 00:19, Nilesh Javali wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> System crash when 32 bytes CDB was sent to a non T10-PI disk,
> 
> [  177.143279]  ? qla2xxx_dif_start_scsi_mq+0xcd8/0xce0 [qla2xxx]
> [  177.149165]  ? internal_add_timer+0x42/0x70
> [  177.153372]  qla2xxx_mqueuecommand+0x207/0x2b0 [qla2xxx]
> [  177.158730]  scsi_queue_rq+0x2b7/0xc00
> [  177.162501]  blk_mq_dispatch_rq_list+0x3ea/0x7e0
> 
> Current code attempt to use CRC IOCB to send the command but failed.
> Instead, type 6 IOCB should be used to send the IO.
> 
> Clone existing type 6 IOCB code with addition of MQ support
> to allow 32 bytes CDB to go through.
> 
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Cc: Laurence Oberman <loberman@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_iocb.c | 270 ++++++++++++++++++++++++++++++++
>   drivers/scsi/qla2xxx/qla_nx.h   |   4 +-
>   2 files changed, 273 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index 0caa64a7df26..e99ebf7e1c7a 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -11,6 +11,7 @@
>   
>   #include <scsi/scsi_tcq.h>
>   
> +static int qla_start_scsi_type6(srb_t *sp);
>   /**
>    * qla2x00_get_cmd_direction() - Determine control_flag data direction.
>    * @sp: SCSI command
> @@ -1721,6 +1722,8 @@ qla24xx_dif_start_scsi(srb_t *sp)
>   	if (scsi_get_prot_op(cmd) == SCSI_PROT_NORMAL) {
>   		if (cmd->cmd_len <= 16)
>   			return qla24xx_start_scsi(sp);
> +		else
> +			return qla_start_scsi_type6(sp);
>   	}
>   
>   	/* Setup device pointers. */
> @@ -2100,6 +2103,8 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
>   	if (scsi_get_prot_op(cmd) == SCSI_PROT_NORMAL) {
>   		if (cmd->cmd_len <= 16)
>   			return qla2xxx_start_scsi_mq(sp);
> +		else
> +			return qla_start_scsi_type6(sp);
>   	}
>   
>   	spin_lock_irqsave(&qpair->qp_lock, flags);
> @@ -4205,3 +4210,268 @@ qla2x00_start_bidir(srb_t *sp, struct scsi_qla_host *vha, uint32_t tot_dsds)
>   
>   	return rval;
>   }
> +
> +/**
> + * qla_start_scsi_type6() - Send a SCSI command to the ISP
> + * @sp: command to send to the ISP
> + *
> + * Returns non-zero if a failure occurred, else zero.
> + */
> +static int
> +qla_start_scsi_type6(srb_t *sp)
> +{
> +	int		nseg;
> +	unsigned long   flags;
> +	uint32_t	*clr_ptr;
> +	uint32_t	handle;
> +	struct cmd_type_6 *cmd_pkt;
> +	uint16_t	cnt;
> +	uint16_t	req_cnt;
> +	uint16_t	tot_dsds;
> +	struct req_que *req = NULL;
> +	struct rsp_que *rsp;
> +	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
> +	struct scsi_qla_host *vha = sp->fcport->vha;
> +	struct qla_hw_data *ha = vha->hw;
> +	struct qla_qpair *qpair = sp->qpair;
> +	uint16_t more_dsd_lists = 0;
> +	struct dsd_dma *dsd_ptr;
> +	uint16_t i;
> +	__be32 *fcp_dl;
> +	uint8_t additional_cdb_len;
> +	struct ct6_dsd *ctx;
> +
remove extra newline
> +
> +	/* Acquire qpair specific lock */
> +	spin_lock_irqsave(&qpair->qp_lock, flags);
> +
> +	/* Setup qpair pointers */
> +	req = qpair->req;
> +	rsp = qpair->rsp;
> +
> +	/* So we know we haven't pci_map'ed anything yet */
> +	tot_dsds = 0;
> +
> +	/* Send marker if required */
> +	if (vha->marker_needed != 0) {
> +		if (__qla2x00_marker(vha, qpair, 0, 0, MK_SYNC_ALL) != QLA_SUCCESS) {
> +			spin_unlock_irqrestore(&qpair->qp_lock, flags);
> +			return QLA_FUNCTION_FAILED;
> +		}
> +		vha->marker_needed = 0;
> +	}
> +
> +	handle = qla2xxx_get_next_handle(req);
> +	if (handle == 0)
> +		goto queuing_error;
> +
> +	/* Map the sg table so we have an accurate count of sg entries needed */
> +	if (scsi_sg_count(cmd)) {
> +		nseg = dma_map_sg(&ha->pdev->dev, scsi_sglist(cmd),
> +				  scsi_sg_count(cmd), cmd->sc_data_direction);
> +		if (unlikely(!nseg))
> +			goto queuing_error;
> +	} else {
> +		nseg = 0;
> +	}
> +
> +	tot_dsds = nseg;
> +
> +	/* eventhough driver only need 1 T6 IOCB, FW still convert DSD to Continueation IOCB */
> +	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
> +
> +	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
> +	sp->iores.exch_cnt = 1;
> +	sp->iores.iocb_cnt = req_cnt;
> +
> +	if (qla_get_fw_resources(sp->qpair, &sp->iores))
> +		goto queuing_error;
> +
> +	more_dsd_lists = qla24xx_calc_dsd_lists(tot_dsds);
> +	if ((more_dsd_lists + qpair->dsd_inuse) >= NUM_DSD_CHAIN) {
> +		ql_dbg(ql_dbg_io, vha, 0x3028,
> +		       "Num of DSD list %d is than %d for cmd=%p.\n",
> +		       more_dsd_lists + qpair->dsd_inuse, NUM_DSD_CHAIN, cmd);
> +		goto queuing_error;
> +	}
> +
> +	if (more_dsd_lists <= qpair->dsd_avail)
> +		goto sufficient_dsds;
> +	else
> +		more_dsd_lists -= qpair->dsd_avail;
> +
> +	for (i = 0; i < more_dsd_lists; i++) {
> +		dsd_ptr = kzalloc(sizeof(*dsd_ptr), GFP_ATOMIC);
> +		if (!dsd_ptr) {
> +			ql_log(ql_log_fatal, vha, 0x3029,
> +			    "Failed to allocate memory for dsd_dma for cmd=%p.\n", cmd);
> +			goto queuing_error;
> +		}
> +		INIT_LIST_HEAD(&dsd_ptr->list);
> +
> +		dsd_ptr->dsd_addr = dma_pool_alloc(ha->dl_dma_pool,
> +			GFP_ATOMIC, &dsd_ptr->dsd_list_dma);
> +		if (!dsd_ptr->dsd_addr) {
> +			kfree(dsd_ptr);
> +			ql_log(ql_log_fatal, vha, 0x302a,
> +			    "Failed to allocate memory for dsd_addr for cmd=%p.\n", cmd);
> +			goto queuing_error;
> +		}
> +		list_add_tail(&dsd_ptr->list, &qpair->dsd_list);
> +		qpair->dsd_avail++;
> +	}
> +
> +sufficient_dsds:
> +	req_cnt = 1;
> +
> +	if (req->cnt < (req_cnt + 2)) {
> +		if (IS_SHADOW_REG_CAPABLE(ha)) {
> +			cnt = *req->out_ptr;
> +		} else {
> +			cnt = (uint16_t)rd_reg_dword_relaxed(req->req_q_out);
> +			if (qla2x00_check_reg16_for_disconnect(vha, cnt))
> +				goto queuing_error;
> +		}
> +
> +		if (req->ring_index < cnt)
> +			req->cnt = cnt - req->ring_index;
> +		else
> +			req->cnt = req->length - (req->ring_index - cnt);
> +		if (req->cnt < (req_cnt + 2))
> +			goto queuing_error;
> +	}
> +
> +	ctx = &sp->u.scmd.ct6_ctx;
> +
> +	memset(ctx, 0, sizeof(struct ct6_dsd));
> +	ctx->fcp_cmnd = dma_pool_zalloc(ha->fcp_cmnd_dma_pool,
> +		GFP_ATOMIC, &ctx->fcp_cmnd_dma);
> +	if (!ctx->fcp_cmnd) {
> +		ql_log(ql_log_fatal, vha, 0x3031,
> +		    "Failed to allocate fcp_cmnd for cmd=%p.\n", cmd);
> +		goto queuing_error;
> +	}
> +
> +	/* Initialize the DSD list and dma handle */
> +	INIT_LIST_HEAD(&ctx->dsd_list);
> +	ctx->dsd_use_cnt = 0;
> +
> +	if (cmd->cmd_len > 16) {
> +		additional_cdb_len = cmd->cmd_len - 16;
> +		if (cmd->cmd_len % 4 ||
> +		    cmd->cmd_len > QLA_CDB_BUF_SIZE) {
> +			/* SCSI command bigger than 16 bytes must be
> +			 * multiple of 4 or too big.
> +			 */
> 
fix comment formatting

+			ql_log(ql_log_warn, vha, 0x3033,
> +			    "scsi cmd len %d not multiple of 4 for cmd=%p.\n",
> +			    cmd->cmd_len, cmd);
> +			goto queuing_error_fcp_cmnd;
> +		}
> +		ctx->fcp_cmnd_len = 12 + cmd->cmd_len + 4;
> +	} else {
> +		additional_cdb_len = 0;
> +		ctx->fcp_cmnd_len = 12 + 16 + 4;
> +	}
> +
> +	/* Build command packet. */
> +	req->current_outstanding_cmd = handle;
> +	req->outstanding_cmds[handle] = sp;
> +	sp->handle = handle;
> +	cmd->host_scribble = (unsigned char *)(unsigned long)handle;
> +	req->cnt -= req_cnt;
> +
> +	cmd_pkt = (struct cmd_type_6 *)req->ring_ptr;
> +	cmd_pkt->handle = make_handle(req->id, handle);
> +
> +	/* Zero out remaining portion of packet. */
^^ remove self-explanatory comment.

> +	/*    tagged queuing modifier -- default is TSK_SIMPLE (0). */

fix comment format

> +	clr_ptr = (uint32_t *)cmd_pkt + 2;
> +	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
> +	cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
> +
> +	/* Set NPORT-ID and LUN number*/
> +	cmd_pkt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
> +	cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
> +	cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
> +	cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
> +	cmd_pkt->vp_index = sp->vha->vp_idx;
> +
> +	/* Build IOCB segments */
> +	qla24xx_build_scsi_type_6_iocbs(sp, cmd_pkt, tot_dsds);
> +
> +	int_to_scsilun(cmd->device->lun, &cmd_pkt->lun);
> +	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
> +
> +	/* build FCP_CMND IU */
> +	int_to_scsilun(cmd->device->lun, &ctx->fcp_cmnd->lun);
> +	ctx->fcp_cmnd->additional_cdb_len = additional_cdb_len;
> +
> +	if (cmd->sc_data_direction == DMA_TO_DEVICE)
> +		ctx->fcp_cmnd->additional_cdb_len |= 1;
> +	else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
> +		ctx->fcp_cmnd->additional_cdb_len |= 2;
> +
> +	/* Populate the FCP_PRIO. */
> +	if (ha->flags.fcp_prio_enabled)
> +		ctx->fcp_cmnd->task_attribute |=
> +		    sp->fcport->fcp_prio << 3;
> +
> +	memcpy(ctx->fcp_cmnd->cdb, cmd->cmnd, cmd->cmd_len);
> +
> +	fcp_dl = (__be32 *)(ctx->fcp_cmnd->cdb + 16 +
> +	    additional_cdb_len);
> +	*fcp_dl = htonl((uint32_t)scsi_bufflen(cmd));
> +
> +	cmd_pkt->fcp_cmnd_dseg_len = cpu_to_le16(ctx->fcp_cmnd_len);
> +	put_unaligned_le64(ctx->fcp_cmnd_dma,
> +			   &cmd_pkt->fcp_cmnd_dseg_address);
> +
> +	sp->flags |= SRB_FCP_CMND_DMA_VALID;
> +	cmd_pkt->byte_count = cpu_to_le32((uint32_t)scsi_bufflen(cmd));
> +	/* Set total data segment count. */
> +	cmd_pkt->entry_count = (uint8_t)req_cnt;
> +
> +	wmb();
> +	/* Adjust ring index. */
> +	req->ring_index++;
> +	if (req->ring_index == req->length) {
> +		req->ring_index = 0;
> +		req->ring_ptr = req->ring;
> +	} else {
> +		req->ring_ptr++;
> +	}
> +
> +	sp->qpair->cmd_cnt++;
> +	sp->flags |= SRB_DMA_VALID;
> +
> +	/* Set chip new ring index. */
> +	wrt_reg_dword(req->req_q_in, req->ring_index);
> +
> +	/* Manage unprocessed RIO/ZIO commands in response queue. */
> +	if (vha->flags.process_response_queue &&
> +	    rsp->ring_ptr->signature != RESPONSE_PROCESSED)
> +		qla24xx_process_response_queue(vha, rsp);
> +
> +	spin_unlock_irqrestore(&qpair->qp_lock, flags);
> +
> +	return QLA_SUCCESS;
> +
> +queuing_error_fcp_cmnd:
> +	dma_pool_free(ha->fcp_cmnd_dma_pool, ctx->fcp_cmnd, ctx->fcp_cmnd_dma);
> +
> +queuing_error:
> +	if (tot_dsds)
> +		scsi_dma_unmap(cmd);
> +
> +	qla_put_fw_resources(sp->qpair, &sp->iores);
> +
> +	if (sp->u.scmd.crc_ctx) {
> +		mempool_free(sp->u.scmd.crc_ctx, ha->ctx_mempool);
> +		sp->u.scmd.crc_ctx = NULL;
> +	}
> +
> +	spin_unlock_irqrestore(&qpair->qp_lock, flags);
> +
> +	return QLA_FUNCTION_FAILED;
> +}
> diff --git a/drivers/scsi/qla2xxx/qla_nx.h b/drivers/scsi/qla2xxx/qla_nx.h
> index 6dc80c8ddf79..5d1bdc15b75c 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.h
> +++ b/drivers/scsi/qla2xxx/qla_nx.h
> @@ -857,7 +857,9 @@ struct fcp_cmnd {
>   	uint8_t task_attribute;
>   	uint8_t task_management;
>   	uint8_t additional_cdb_len;
> -	uint8_t cdb[260]; /* 256 for CDB len and 4 for FCP_DL */
> +#define QLA_CDB_BUF_SIZE  256
> +#define QLA_FCP_DL_SIZE   4
> +	uint8_t cdb[QLA_CDB_BUF_SIZE + QLA_FCP_DL_SIZE]; /* 256 for CDB len and 4 for FCP_DL */
>   };
>   
>   struct dsd_dma {

Once you fix comments in this patch... you can add

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

