Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EFCBCCA479
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 22:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236835AbiGGWhv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 18:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236631AbiGGWht (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 18:37:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D6F1036;
        Thu,  7 Jul 2022 15:37:48 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KCn66015540;
        Thu, 7 Jul 2022 22:37:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ljweCFfruHPXDZhRw5wS0OVzM7MoByTTi447x4qeEcU=;
 b=pxMARZCHp/VuKFlTT2fBGZq1JMhzLn0ZvzNI6uk9PRlmvPEThKqxycMsG9imXVYv/vQ8
 C1H/XDiX6R+TVVJvpaU0zZxxFxeaDknfYHRPCd6lwlUd2rkCzYW9GHngcJHQCgT2NuGm
 eG5gS118Waxc3hXa6+qDWpvKPOCnRjAa3EaBmepBIy1y8miUOJk1ivIKj2tXZIIs5s1N
 3qVJKV+xNMHDrsNvHMp3vuSMWsXHoJKsOCU2Ybh1Uv+Ju4MVAbpM9f2Z83HAld4GfNS6
 rsdGtDBqv4CIQJY9jwrvFp6SCKNb1d2e9JYZymBHhFNL4+wPS96ugQzpLVeZOT4gkQBm XQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubyxe25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 22:37:47 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 267ML4UZ017115;
        Thu, 7 Jul 2022 22:37:47 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h4ud234tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 22:37:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2tyedbQ0g5sE//Z/VnIRVr1XnyuFw2LAp6vsc7XK78aLkzS7U91bruI/1zrzJO17/xEnfkOfXLcve+0U5bIQeHLsGLqliw/+lSLEDE/YHlzMs9wg+coOiX3kQ09VpkIEuohRExhh5gi5YbR3X0S9aD3+VchLZjKYtzirzmsmRrY5b2Q8kWrfun7mOgLmoE2NST/0weU861hTUJH53w6tjmHOGTFkzBhecr9aARgMNVR1N9cdCm+akc1SDvzWGsVJXdVOEWly0tV/9vv22xlHirXOew1fTRm6laKHJfAHmmnY80zxnpTTFBcZWY6zf9bwZeztUO7aYxUsjSBpByAdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ljweCFfruHPXDZhRw5wS0OVzM7MoByTTi447x4qeEcU=;
 b=TWqHUxhzsilC1p6dQcopLxLk63mxvGguWalrwMqbTZMozHA68qQlIM0g5+YPfYVwwQRoAYOO/iBAW96A4OMbj4tePuvy+g73zpNP91s3is2/zzLdMzMTCHAJ3/1FCe/BY/hiSrDcVSNi0WRF0cuPolMrxImbqiJSoauEaC+bRzzCZaf4pM4Bl3wPEfwRRBnE6kAc6cAAbALRyYfOe1TRG6FxnT8TItNZhJRg1vmTBvqL4N2qzsemfT08kG7ee8GNGnwThA3YvcMbNdMmaYJ1BjoYLdlbG22A2Trzq6b+Rv1qwEERtE/hg5Sl2wikEsDLf2wTeHhcL0NxGCBnWPSxuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ljweCFfruHPXDZhRw5wS0OVzM7MoByTTi447x4qeEcU=;
 b=J1NzTSBMNRe5pEyWD7g/xv/0rZd4fZmJfFg+S86L4S16Y7sXcVTgfN+z0kfQBJKATSwtoUSH0P77NViBcdt8Roc71b5V5NHpmlQ7fkrR1UiGbzqh9aiFnSp6umU4yY6gLSQK+AthVbSpS7fxyGvF/nrH7Vu/mWRQv7KPDBXGLQ8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5052.namprd10.prod.outlook.com (2603:10b6:610:de::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.15; Thu, 7 Jul 2022 22:37:44 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5395.020; Thu, 7 Jul 2022
 22:37:44 +0000
Message-ID: <be03459a-2063-a1fb-122c-b82f73e5c62f@oracle.com>
Date:   Thu, 7 Jul 2022 17:37:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.1
Subject: Re: [PATCH 3/3] target: core: Change the way target_xcopy_do_work
 sets restiction on max io
Content-Language: en-US
To:     Anastasia Kovaleva <a.kovaleva@yadro.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com
References: <20220630122241.1658-1-a.kovaleva@yadro.com>
 <20220630122241.1658-4-a.kovaleva@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220630122241.1658-4-a.kovaleva@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0225.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7cc0b05-2d16-454c-ba46-08da60694f6b
X-MS-TrafficTypeDiagnostic: CH0PR10MB5052:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w8+MeoaFhzy+dLXhP75ZDZHCNzDx1z3hf4djx29nth6XS4f0KI6vRVM7xl+7DoPSzHUMY7Q8MkNUJvF2B7+U+26wvWl8BzK2B2O+weZulHJyoKqRmTxVNR6AGKps9HijQU0wayxu59ikxcEIkHJkRShWKj7+ktIwA8KB2e+8OPfvqvpcsFbXVfSI/nLODxVaPJOffDdEqnTohtspjFeZoqMMznsuxrV+Y3RPQWKGtIiBnOjqlG1OU3ElLFAsEf84AweSKNP6Z0OEqvp3Iy7Kci4a9++QSZOrQwRJaaRPUTOd90pwXSBUley29H/LGd0w5FKJE6H7hyrNO1AIv7M5I9VFFYLanBmV8XtGst873Q+6HBr59qr39ZoygmCT5MJH2e4XBuxNKGoKKPh74KA/yYrdCG832th5VqZF5oSD8th2YnOhoFpiSN8ZmfXBm00N22ECBLkIHOE6SU+ArAc2tyWs61SlbJ5ZyP4vmx7hBEk8slM8umL8mQTFKnfqJCZfmO+dXL8ELZr9B42D9UNL1U1dYnaONDWshHG21jvFDCmA7WFpYmEx1sVdRv2Gc2r4NdCar1+I2CS+1Zwdd8JE0HXCv81SczL1t2F7wytvlyOs9nRHBfkRlgG/9iH8sEHs/N0pm4utOvfOVG6X/vc3NSYwsCkM8FmO5JSj5bW9oqMAZSHmFUjcXgOHHcC4ZtKwfvNP2E65JaWfFKiw8vaCPhUe3TvbaNj9SDJoCmq8z7lOTkSslsBb+4cyte2mvEn0vi3hSXtZNfaT8NOrIzLQA7uaaTcEhT2B6Atixk0q0niiLvHgL4QkB6gEuZwe0A2//4A7yXe3wWL0d/5/ft+l1e/GyV71/YUu/RnAObtReJk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(396003)(346002)(376002)(366004)(66946007)(86362001)(38100700002)(4326008)(478600001)(66556008)(2906002)(8676002)(6506007)(5660300002)(31696002)(53546011)(2616005)(8936002)(66476007)(41300700001)(6486002)(26005)(316002)(83380400001)(31686004)(186003)(36756003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3dCd0FzSkUzOEFEVWY1ejVvdHJuM2tzdEJ4VDFSVTdJeUZIcXgvNmUvZ1lz?=
 =?utf-8?B?cE5tU3BJU0RJK0dMV3RrVCtXZW9kN1VMQWRqeit0MXYxTE10Y3ppVW1GejlI?=
 =?utf-8?B?czRrYitWaERkU0VScXFHdUpWVEZrdWQ3RVhOblA5MkRMbFFITkFCZytWbTh4?=
 =?utf-8?B?ZEJaT2FjM2h2bDZlMEQ0cUVkZlhJbFdMc1hpQUtFbXlCdldIdmlFSUwyN0cw?=
 =?utf-8?B?NWlDczdVS0s2amlpQmJFR3pzMmJRdW5nRUFtMzNxcjdmOENLK1dFdXpaSWJG?=
 =?utf-8?B?WXB6ODM0UkVvM1NEdmgrVzhGaXF6T1JHMFFXN1lNMWZtY1pLbTlTSEFPczhW?=
 =?utf-8?B?YzFvTmNVMnBsZW54TU1nZk5IYmxnd2hpT3k2WWFLMENPNzIvRDVKQ21kYlJ3?=
 =?utf-8?B?MUkwbkQ2RUtNelI1TE9LREZOMkVvV0V1WUI1NCtxRGRhcTBlSGhCMzZvSWhJ?=
 =?utf-8?B?a3lhb2JFMjNLSjN2M0JFc0k5c0hRMjQ0bzJ6N2F1M1JUeFZQY255Tml3d2t6?=
 =?utf-8?B?RUxhb09MNm9qMVJjR0NlQytNWGNKRWxvdERnbmhzL1A5WThHdU5hcjUwM1hB?=
 =?utf-8?B?Znc0em9RNnErcFpOMWtiQ014YkVBN2s5Y1lNU0N4N3RxaUJ2UVdHUWtqSi9z?=
 =?utf-8?B?bVhac1hYR2lCUWcxZlNDUXJ2b3gzWUF5cXp1ZkoydW8wNm96RnByUnd3QWRs?=
 =?utf-8?B?RU9ScFd6ZEtxczNNSnBuc3lEZTFEdDZlb0NNa3gzMmFxM01SYWpncC9BWjdv?=
 =?utf-8?B?QVdPaDgyWksvYXR6QmJ4KzlQbXR0U3UwUU9NMGYvM29KV0RYbzI0Z1RDaU52?=
 =?utf-8?B?UnBjeElNeTFPSDdRN0srdFA2SW9PWTJJVHRwdWN2SlZZREUwM0VIZzNUSWE3?=
 =?utf-8?B?STc1amRhRGNMalVLYWJjL2w4dGdhZFdXbUNCM3Z0Wm9pc3RlR21mMG40VHhD?=
 =?utf-8?B?cWxOa0tqdkh1N05mZmRyWEhTNDlUaGlocUhrSmhYRmhUZjJsaVp5OVUyaXlX?=
 =?utf-8?B?bHZYTU0vSFhpWE1ZUXBxd2wwY0cwODlBbHFUQnlpd3I5Wm9WN3JVV3crZ2pE?=
 =?utf-8?B?N0NZRTRNaXp0YkhFQWJaenVBUzV0c1U1SXRENFVzbS9GM2Jidy94Y1NKWDJQ?=
 =?utf-8?B?R0FrN0trTlZQMTBIMzJZOVZnT1E2bWgxcjQvSjlDY20ya2RET09zT21jNEdB?=
 =?utf-8?B?RDRFYUdkcjNMckt1WjJOYUcyY3JaZjFiUlVxdWlPdzJnRFZjamF6TVhiTXZi?=
 =?utf-8?B?d0tic1pJSy9wVlg2OWRnWlp3WHloL3A1Qm5VTThFcnlWQ0gyRk50cTBreHRD?=
 =?utf-8?B?djRWa3JCTjF3dncrT2xrbGVzZG5uSGNMaFJ1bVRVVVhhbWdZeTJHL2lrOE5x?=
 =?utf-8?B?a3g4Lys1QlVVckttTWw4UEJqK2w4bjQwSU1DbG9GTnZrOUNRSHBhN0MrMjZS?=
 =?utf-8?B?cXV1MHVTVXR5STE2SUROczJGVFB6ck9BYWZrV2E1SG1rUzJzdVpvMTVFelU1?=
 =?utf-8?B?M0hWNE12eENwVXF4amdQR3VzeEFMTElzL1c4Z2VrSUhMRXJnam05SVVVMk84?=
 =?utf-8?B?MXRrZUhsajlBUU9wS3VhU1pPN1JCSHN2S3ZZVGVDR2dWSDJySWVmK1kwdUgr?=
 =?utf-8?B?TVBGZHJ3WlNKWURSNGVTVkRRa3QxaHd4NHpjajJvN3Ryd04wOWY2NTVMMUk4?=
 =?utf-8?B?Y2ZXcWk1QVZ3NVJkaFBOZC9CTmIxMjJDL3RPZ3RwaStyL0JIc1hlK2xDdnEr?=
 =?utf-8?B?QVJnUE5CMk1qKzhKU3RFNnA0Y2hCNVdhM3FOVVJJUkFlVmovam0vTlFCbGV1?=
 =?utf-8?B?ZExHQ0VmVGpoY2FBWlViakVQa1hzZUpzQ0xRT2c1bCt2V3JGcjdOMGlvcGZQ?=
 =?utf-8?B?OEpSOGR0Z1NlcFVRNzhpaGNpbDZUamRvZDc5Rmw2Zkx1b2E5V0pvVzVyQmwv?=
 =?utf-8?B?OVU1eG1GaFoyQVVyVE16WG1SWmt5U0RZbksrQWlyamVuSlhHRGhzMjVXc3BD?=
 =?utf-8?B?WlAyR215RlVRV1JoV3k0RDZ4bWhtT05CdDF3QkZGY0dZTzhXRkl1bnBIYTRG?=
 =?utf-8?B?REdIbXZmRm1meU1RUzBxMHJ1dmVqcEpjTEppd3VoaXNGMHNYbVpXRVl4akFp?=
 =?utf-8?B?QlZJNGlGa3I0K09XWWxZZ21WdVJoamd1RGRJcU1oTWgyZ1llZ0k0N2VnQmlL?=
 =?utf-8?B?eVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7cc0b05-2d16-454c-ba46-08da60694f6b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 22:37:44.7732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1wJeDu9n1+e1s2hBykWtxi5upVtRJVKdf9glNS/u2kQKWXm5aeSRwYtJjIIR3ZHmy0nNb3kGWx14GsTOfDS5jBKxSGxNMrbDlW7V+E4rrH8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5052
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-07_17:2022-06-28,2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070088
X-Proofpoint-ORIG-GUID: 5jYhnUFWwPi3nrRlFz2S_uTcp1rUJZPt
X-Proofpoint-GUID: 5jYhnUFWwPi3nrRlFz2S_uTcp1rUJZPt
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/30/22 7:22 AM, Anastasia Kovaleva wrote:
> To determine how many blocks sends in one command, the minimum value is
> selected from the hw_max_sectors of both devices. In
> target_xcopy_do_work, hw_max_sectors are used as blocks, not sectors; it
> also ignores the fact that sectors can be of different sizes, for
> example 512 and 4096 bytes. Because of this, a number of blocks can be
> transmitted that the device will not be able to accept.
> 
> Change the selection of max thransmition size into bytes.

I think it's "transmission".

Run the scripts/checkpatch.pl on the patch and fix up those warnings.

Also don't forget to checkout the kernel test bot warnings.

> 
> Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
> Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
> Reviewed-by: Dmitriy Bogdanov <d.bogdanov@yadro.com>
> ---
>  drivers/target/target_core_xcopy.c | 68 ++++++++++++++++--------------
>  drivers/target/target_core_xcopy.h |  2 +-
>  2 files changed, 37 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
> index 6bb20aa9c5bc..c9341a92b567 100644
> --- a/drivers/target/target_core_xcopy.c
> +++ b/drivers/target/target_core_xcopy.c
> @@ -582,11 +582,11 @@ static int target_xcopy_read_source(
>  	struct xcopy_op *xop,
>  	struct se_device *src_dev,
>  	sector_t src_lba,
> -	u32 src_sectors)
> +	u32 src_bytes)
>  {
>  	struct xcopy_pt_cmd xpt_cmd;
>  	struct se_cmd *se_cmd = &xpt_cmd.se_cmd;
> -	u32 length = (src_sectors * src_dev->dev_attrib.block_size);
> +	u32 transfer_length = src_bytes / src_dev->dev_attrib.block_size;
 
It was nice how in the patches you added a bytes/blocks to the variable
names. Maybe do that here and the other transfer_length you added? I
wasn't sure if you just forgot or maybe adding a "block" in the name made
it sound weird.


