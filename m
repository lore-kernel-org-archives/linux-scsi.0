Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC44C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 15:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349678AbiDUPll (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 11:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbiDUPlk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 11:41:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94562473B8;
        Thu, 21 Apr 2022 08:38:50 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LEA3Nw012445;
        Thu, 21 Apr 2022 15:38:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=PAMeGiEHRJMafRAfDfdWx/7UhAWQ2RNs7fLzk1fqCVI=;
 b=W8tKGZCV5zUuWt/+xEkCEXy68Okon4iiPKh/Kp8e31sRxF0WvOtbSiPsTgE80XNGuC4H
 jglQwmXgOweZbW+vXOPA0VYUC7JCPITcV2XQxhi/ogd5ky9bqj5C/s4g3eO75kxkwJFo
 ymCdEGljZSWsXfwuQptTipOF5p5lEUFoWW9rxcUaLq3D0nNAxihRMYK30SmkOmeyAqEH
 TyAbKR1VbFCvWmDA+LczP98x5MGRmgby/eqncmE0TQ42118S186I+i315BRVVF3OAtUt
 Qu33HCeBCXCbAlMwgmMDXZOwKb8tR3AlbkMSS8x2UDftRkO3HS54bFDZyYlDO8vgSq5c 3A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffpbvcnh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 15:38:41 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23LFb1G2039334;
        Thu, 21 Apr 2022 15:38:39 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3ffm89df0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 15:38:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8Evgpdm1NqBiJ0+zWrUCxZw8ICs+SC5mwYKrLXT9DdhYbqsU/tYIG/JVDp6dBk/1YuAfmGWhNI+zDvoNOowQ+Fvi2QbziqJpbI9gAw5KuowX3H3WeC/ktIRlZp1BI8E91AnoeKsOOR2IAygFzPq/XSWkM4tcAGnTE1FiZ6zpy75cXsYmh4dtLcd2RfYYESNof/6tUzHy+iwIPovw28lW1cguO9fIHALAUeJBgbPWyaF9tBcmm2IH+/ZTeYFoSvU2/gbf1ISFom1W2bkSt35gE5sK6DvoVstsRydu8mlSvOa2qI5UQZ/MIXAfrfMhqiQEFzISyT4Bui1awYC9NEASQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PAMeGiEHRJMafRAfDfdWx/7UhAWQ2RNs7fLzk1fqCVI=;
 b=FfQvsH/YWIkvR4D+N94nl8UFXxgVzBtHYZTg8EXeo2B7WGER0xZjYjnSEAn1OJWHNE8w8o2Cudm8O0QBz3ZUxTZOP50SJJREDUHR+vvlMsPltEzRCq/eStKlZtTWllm6LCmfK2Yf3Bvr/yZuTlsasbWsLJT+4JGiK5pR1SdPim3V+87FMC+LbfaECGvOYkCfxUOpBdlSRl6aTgzgU5j5fujCxm9WNWO2jhOKIRqCA0CFj8GPCfq1m71f5gdjImtjAYpbHE0OxCy+VEItiamYV3bBBsHmJk7Er4wM7vLXRXaGVBkzo9QGeipgIhb9nBPOrlPm5FMp1x4iGNgJiW+5kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PAMeGiEHRJMafRAfDfdWx/7UhAWQ2RNs7fLzk1fqCVI=;
 b=FUU8ubguiliiu9uFkvjW8uy89pDDkcEqSb/DAWDUGSV/AOjrIgD3F+Xz06SpA5oW9ATV4peyMTltgzUTJS7cgR7RKn3VRvSiToMzLYRRZN/DmBRDLRyFD72r+v+4Oe6nK3IPV96tTUqa9mOD8BoAGoMVDODNx7bb6B+DcXmpHHo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4267.namprd10.prod.outlook.com (2603:10b6:5:214::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.14; Thu, 21 Apr 2022 15:38:37 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586%2]) with mapi id 15.20.5186.015; Thu, 21 Apr 2022
 15:38:37 +0000
Message-ID: <9a928aff-d577-6fcc-701b-cb2ac93da9bb@oracle.com>
Date:   Thu, 21 Apr 2022 10:38:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] scsi: iscsi: fix harmless double shift bug
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Lee Duncan <lduncan@suse.com>
Cc:     Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <YmFyWHf8nrrx+SHa@kili>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <YmFyWHf8nrrx+SHa@kili>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0431.namprd03.prod.outlook.com
 (2603:10b6:610:10e::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e85e12c-d4e1-45bb-4880-08da23ad00c6
X-MS-TrafficTypeDiagnostic: DM6PR10MB4267:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB426772CC059BA2298A0D5E64F1F49@DM6PR10MB4267.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KhK6am6idhaV3u1kGbEDJEQyL+sAzjqeoVWLoyWcVN/pPyZ+Ro3yZWCIcCtvNIZr6+St0P81dIwf3fNksM0alCZJzNBYp+qsigayNZxCZBVBqxmqzunwQuSKiNRlj84cV9p/GBwcnMEMfZN3XOXxfTiTD9/1BYkHseurg5RFSOTyfnMCxvUywqgJQGHSmcdsegdDU3VzwfVcvpemVWJup9oRIesxc+sNGQ40erFrWJfHJ8/leyuVokXcBC2ar7/qqUIw6nJThYg3gKQO1HUzrVd9c5C/ivZAWf5/KjYbZRXhoE9SiVmwd41XEMghb3ZyZAcsNbHhAo+H1nW9Wep+76IK3MU3SQkl0nSFRibv+AsKwAVpwYs5X+JwyIvMQXjRPkWLFWDJ3nMZMaPn+B8aKWzKGJMgTm6l/hd53fbpU/EfjhZsHWkON9ModRKpEjc8WsHuJL07s3MfYPtymHuoAtB7AnJVS1Gz7tBs/uKTeAQzv597Ke2latI8G4P3hE1T/HbfG0DdezKvSIe6YHhLn4mj3gQwXQQ7XzgJthFMgvB7gW7VeVTsy7X6CAtJ3ysp/djgxP0SqqI3DAUx0MiR+cXUEggdVIKNrLYhtd/g+RSt3sAsWh+FOEOxOicDc+TaCRHHVr5iseEfRW113kmAqmSgn7tXcNXBH1EuoPrh6GuUs/j+IHQNqZhXUDOzqgCVew/9rQnImKEM+haas1URQ1oyaMy/XYmO4blcdBWqyfI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31696002)(8936002)(86362001)(5660300002)(53546011)(6506007)(54906003)(316002)(110136005)(508600001)(6486002)(66556008)(66946007)(66476007)(38100700002)(186003)(4326008)(8676002)(2616005)(26005)(31686004)(6512007)(83380400001)(2906002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2xGcTRvR3V6TjBSNUdVS0VraHZzSGFIN2dHTjRyVE9jQTFPWDJtSHp4eUJB?=
 =?utf-8?B?T2RNYzJCdUlJUUh6TCtuV21yTURQMzdtV0tLTXVTbklHdnpocTRpWHhNeGVD?=
 =?utf-8?B?Z3VhT0lLZEpnYndXbEZqT25qcEdRZ285UnRvWGl4VDZiL0VOUDhDVXZoWGw1?=
 =?utf-8?B?VmNwR292cXpiUzllZlRDWG4wQm1IVXpRWk55L200ZWVITlpwcFBhUU5QeDdt?=
 =?utf-8?B?aklEWHJ6TUE1QlB0d1NFUUhmYmFOL0RjSExkTzFNUmNtS2JsbUVwVkwyZG5n?=
 =?utf-8?B?UmRhN01WbStldWYwSnk3OWdiRVp0NzBNbUd6MUxPNEw5TFpoRmFydnEwWEw5?=
 =?utf-8?B?aVQrS2o3V2VHSDA4NjlTYmdGYTJPMHV1UysyZHd0bmI3ZkdrSW9PSjljU1hx?=
 =?utf-8?B?aEZZQXcvYzNyQ2RYK0RBZCtSWGlMR1YrMHlialdIYWxTSk1SM2R2alA3VU1r?=
 =?utf-8?B?VWtsRjBLN1oyUjdJSEVPRXhzczRtcUI4NXY2MXk2TUJzaTZCYnRrTEZseU9X?=
 =?utf-8?B?YUlaOWxwYkZEK3FBZTlZZS9vRVl4RnRyMk9nNmRGT3BuYTBXOXdkZndzcGVO?=
 =?utf-8?B?QnpiQ3pzcnh6MUhjY1RxSml5MWc0VGxpVVRVVFJTL05pZk9LVUZ6NXBOU3Zh?=
 =?utf-8?B?TEJnZ0tOUFJIcXRwMlBYUGg0aENqcEZ0Rk9FaXQ0RmRHMzJjRk9mdEdzNzV5?=
 =?utf-8?B?WmN5Njg4RTR4U3N2WUxhR3dpelEyQjdEUWgrOW45NjVhTS9IS2pUS0FaQzZR?=
 =?utf-8?B?S0o0a2x1Z0Zva3V4cnFMalF5dEI2djdjbmxRNk9GRWJOb1lBQ01SR2lQQkxZ?=
 =?utf-8?B?bTFrVFYwQWZML1JWT0YvWlJxWTJIMWc2WlNYK1c0eFlQRWVWcVl5Y2RSL09V?=
 =?utf-8?B?UXhZVVRnWjhzaFVQbW1HaFZTN0RSVmhyRS9seVhVdmcxcFltZ1BjbHJrT0ln?=
 =?utf-8?B?WVNpVFVCeGR2eGZCWXpHWVV4UStRLzdvNk9TODFib1JjbnJ0K0hkMjJqeWNR?=
 =?utf-8?B?VW9HNXJncitWYVo5aC85dzE1dFhSSmNDUzhGODVWem14MGlmTTNSalpjYXZV?=
 =?utf-8?B?NXVUeGRpcGh1UlVFQWx3cDUybUw3OHdOb0FKYVpERS92K1BOZWd2NkZmS2hj?=
 =?utf-8?B?NHBhS05KUkFKL3Rkb0VNWlo5U2ZPR21zamRadlArQXZhYkNIWGdRaVRsMitx?=
 =?utf-8?B?L05NRzRUNTFrK3g5VEJEdElncHlOZEVIVm5DR1pWSGJscytZcUpQVkZqanJj?=
 =?utf-8?B?Q0pBSGhmdVMzb1lURzR2Z2toWGZ5UnZFbjlDQTRLcDNQdmxZejRkT29Id3NL?=
 =?utf-8?B?c3FXVVd5ckU2Vkw3M1BEU0lpTmUrZVFhWGxHcFBoTDRLVnc3WUxWMmFCcHg0?=
 =?utf-8?B?THo3R0JPTVU5cHZjU3hWZnFmUHFSZkZxMXIvaFpzZUZzcXNuS3VvNlJkSlFI?=
 =?utf-8?B?V3JTTW1XV25TYjFXelFWYy9GcDRzLzN2bkg1QWZZOUxqZG1WY2lHTzBLNG1Z?=
 =?utf-8?B?ZHp1Z2xOUmNvWEMrS0RBZjlqeitxQ0ZJVU1BNUVVWlliSy8wWUUrZnFDakg2?=
 =?utf-8?B?aWllampyM21qcEFwOVZNbUljQm9tZWF6NVZEWXlmT0tRUU03VU1PamU5dEhz?=
 =?utf-8?B?UThLaGZrUFBWVTR4WGQrN2tMZ1M1V29laGo4WE1IektMb1pqTkNTekd0RzJS?=
 =?utf-8?B?aldFcVF4WmpTQ3JQdDFmOWVnQWNxWHJwM1lVa3FzU1I1Smx3MFd0YmR1ajFv?=
 =?utf-8?B?ckVaQ2VPT01CWE44cnB3ZHQrNHZ3VU9XTXZHN05ZcmsrR09KZ2luUzhFTWNP?=
 =?utf-8?B?VWVCRlBsNXgvY0tna1p4RzI5dXYyZzh5ZmduZWpzOGdVVEo4R21ESkdkMkxP?=
 =?utf-8?B?QXRyQURlRnpuVjBNS0dyVVRTNDFEUUtLTXVhOXU0bU9IWXlzWGVDTnZzNU1t?=
 =?utf-8?B?dytWNDZ1RGlUM3hwU21vWFJ1QWp5VldYUmFOMS9CV1lzRnorNlR1b2cyM3pR?=
 =?utf-8?B?dDQrRWtSMGFQQ2psNm0vcGNKcnB1Y1BCTnk0Mkd5a0pmdWlqOC8wcVp3MDNM?=
 =?utf-8?B?R0FjK0IvT0VpT3pyTnFJS2xUZ1hWa1VQR3IvMEhacDNvc1ZTY1gzVklVUW1P?=
 =?utf-8?B?S0t6dVhwTWpnZjFrUjhZbXB6dFZ6WkcyRUN2b2xhanVEd2V0SG9xSGdGeVI2?=
 =?utf-8?B?ZjU3S3hoV3hzY0pOVnZCaEtyZ29iRmkrYTFOZ1krbDF0M3lVYnh6SzJOaUsx?=
 =?utf-8?B?TjlwRWRRbXdzZ0VQMWtzUnBJVDdqK0pQcTR1RGV2WVh3MkVySnVBK3ZsV0dq?=
 =?utf-8?B?Q3FpSHZpaEV5alViUU1QcjNJZUU2NjY4VTJickluWnUrcG5OV24rbzArR2dl?=
 =?utf-8?Q?BPcDv6EEOU5DCRxc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e85e12c-d4e1-45bb-4880-08da23ad00c6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 15:38:37.7061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S0evEgmyYTZlWb0NmQuBQ/go2bUAV7BiOHEoGnZGxzAP6S1Nt4NlParIth6xjuoYfgIhlTxidsKmdBJEMrpF8KeesQ7505HoQ9teeRviosM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4267
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-21_02:2022-04-21,2022-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210084
X-Proofpoint-GUID: vau9OWPCPzlAA1nTP1Ji9ANgnWm6161J
X-Proofpoint-ORIG-GUID: vau9OWPCPzlAA1nTP1Ji9ANgnWm6161J
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/22 10:03 AM, Dan Carpenter wrote:
> These flags are supposed to be bit numbers.  Right now they cause a
> double shift bug where we use BIT(BIT(2)) instead of BIT(2).
> Fortunately, the bit numbers are small and it's done consistently so it
> does not cause an issue at run time.
> 
> Fixes: 5bd856256f8c ("scsi: iscsi: Merge suspend fields")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  include/scsi/libiscsi.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index d0a24779c52d..c0703cd20a99 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -54,9 +54,9 @@ enum {
>  #define ISID_SIZE			6
>  
>  /* Connection flags */
> -#define ISCSI_CONN_FLAG_SUSPEND_TX	BIT(0)
> -#define ISCSI_CONN_FLAG_SUSPEND_RX	BIT(1)
> -#define ISCSI_CONN_FLAG_BOUND		BIT(2)
> +#define ISCSI_CONN_FLAG_SUSPEND_TX	0
> +#define ISCSI_CONN_FLAG_SUSPEND_RX	1
> +#define ISCSI_CONN_FLAG_BOUND		2
>  
>  #define ISCSI_ITT_MASK			0x1fff
>  #define ISCSI_TOTAL_CMDS_MAX		4096

Thanks.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
