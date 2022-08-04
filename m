Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15082C19F2A
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 16:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbiHDQaM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Aug 2022 12:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239255AbiHDQ3c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2022 12:29:32 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3482D67CBA
        for <linux-scsi@vger.kernel.org>; Thu,  4 Aug 2022 09:29:27 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274GO1X3026572;
        Thu, 4 Aug 2022 16:28:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=V/1158QJIFpuX3W+sP1DlmhMCufoQz5aF/W3WQxMfUE=;
 b=nxWoXqGHkGhZn2hSQJthgmuQ5dLMTWeaeVedjgNV3nBTF91DeiqeYuCWdB1KQqiekcO4
 FBMPu0GOzsi7rn9Tss0uviaNQX0ev3rAMFmyaCCU1tS9PjMVxZNGz1/cIY0gsSRGbAIy
 wSfwXQvxCk21N9NccC5UyfNhTZdhg6v8evkGQtFbfT8Tq//UfQJTSnFUQEAzqQs97kXJ
 JuKcbhLgdFp+NDRnzaXE3PwJdn+FT5O2flpOeO+oMgrkdV3fYvpEA8+Fqa4NxlvD90SF
 pfDb6B9x8D6bgGTFL/vwM06OzvEW1NXXtAkytfL/3Mdyr+guFnHWWUB+zacdy57KeEl3 Og== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmv8sdg6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 16:28:39 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274FREYg003243;
        Thu, 4 Aug 2022 16:28:38 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34fjwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 16:28:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fe/XIvnHzwibeO+t1w5KTO0kH3wZ3lpwsNTSIt9iJUyizViwKaazKhLDfOmX8yS87yi5WmhJAkdb73KlkkQjZBbOFxAPa/MeXAABsIOQ9TMVpsV1VKFxutv/lOze+cJdGZJoh6HATNfVeSKOS3A6G7WgdwcvwyyOY6oAgGUzF4fOeBUs1/w9p4CkqILUwBpOBgTuSrO4NbT1kW9GplAU0Lz9NImWShidw4H8B8MyUmhWOhF0dguZ8V6Wj8Xiqn8WpcXCsFGY/yP7znn2yucUOb52Ob2CrBIWu6p3ljOg+h4MEPIidxeL0P9YOBcYzghl6Lfo2n6xQxVLCg1nbekLSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V/1158QJIFpuX3W+sP1DlmhMCufoQz5aF/W3WQxMfUE=;
 b=Jln+CnOVhAGOJqsjpe1sItv1iB3L62hZrMoL6xPc0qVzeIQ3jPHx5uVHpZEITAH6ZfUMFxEpkxIorddCJX2qJrEZQyWmvxyfqQAIWF5zX8nW9T4sprboCKElbcPZnBu05UBsJEy3gMhD1g4a00uM5P1i78Ml1VpwE+x1U8OSOEk1hLdCPjjlz35of4IwMps9BEtJBzIWTAA15rYk+fzvZmlDR4ZMLYdKxUnOf2EqbmvIww5UOKeuguaWis9hZPYrc8trhmReGIbfYjbHa3ZFBwkvWfvJS7unW6wpqHAH3oRXdvQhVbPjlVH/ZTgKFURe7w4cUww2trFKexcVA6jjLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/1158QJIFpuX3W+sP1DlmhMCufoQz5aF/W3WQxMfUE=;
 b=r3vbjMLqiXcEcgFIJVIQJ/YyG2xRZ7shdQnncGUo0O+kGcXQypbdOR30j4eI50lDrqp5r4p3S5/sD0xXetjyBI4b8AiuelNcg+4m6XQ431VGmn9cT5D1dIMs5Dhe7ksJUdqTMcSf8x7N6Zsc+LQKSPbihPZVcq4cG90FVZi/YMg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN8PR10MB3681.namprd10.prod.outlook.com (2603:10b6:408:bd::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.12; Thu, 4 Aug 2022 16:28:37 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 16:28:37 +0000
Message-ID: <e037decf-26d1-e60b-2815-9e330d0b6c47@oracle.com>
Date:   Thu, 4 Aug 2022 11:28:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH 01/10] scsi: xen: Drop use of internal host codes.
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>, njavali@marvell.com,
        pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
        stefanha@redhat.com, oneukum@suse.com, manoj@linux.ibm.com,
        mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220804034100.121125-1-michael.christie@oracle.com>
 <20220804034100.121125-2-michael.christie@oracle.com>
 <b4b91e8b-d6c7-fb5e-6a96-f2b6780dbfe3@suse.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <b4b91e8b-d6c7-fb5e-6a96-f2b6780dbfe3@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:610:b0::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 570ec12e-962e-4adf-0bac-08da763661d4
X-MS-TrafficTypeDiagnostic: BN8PR10MB3681:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k3KW4R+mEVHQXR0NGvmeaQk83bRVli9Vkk6I1sKIckyThqwHz63AWAWLqQVxBC/dHX1pRHYiRbKovL8d4hBn2S0S6XHmzyLYmyX/+mbpXcnqP5yRaF3EnbjHBiM/iFRikYtXbgNeGJawaLE/S+WIaCjQ6/YwTkIst8WWVeAcckK5tcA7V28BPgvbIxr1k0wQRbWTSyeLjzibBd9YpSEcVP/az8tCZlJx+kyQresglma3fvM9jomlk1aD59ERE/ULVodacXyKWjL+0KXTAFjv5DRJ/AIq5ACjDYxryn8pY3XYoH+16/YZoX0W16A0OZFQ5Ai9jmvp1AUND7gPLzaCe5HJ2q1JKxs3fhl7yTBZrwusNEBA1ksp0M844xmaGXjnnHS6gKaZxGyGzHBA0/qcvhb8hN5Juysk/Zi5pm8BNAXCaaAgLfa/ROiziTZkNzB/uzkiVZvkVFfZKmvkWVMo/8KGrA2NLgLPGId5kioN4V85Ohr1uRIRbcn+rCXUvomB+wFbs9Dvj1+8lwAloZUXVO1zqDc38ldcEf8LxzYcH9YAGY2nHMUywQxVrlJ6Jy2bXv515kee1RUbTARocIXjgWKl/CGfZ/JHBxALI0mI4/IFTonj7ZeqBVZtz6qJPmoXQynHNmuCu++n/qCUHpkMlOj2OLR6Xmq02Z5RBMMJ9EMUYjDSgE1UcZ1P6X591mtW1WuPL6Bxyd4ym/tVUBCnfFZIyeGVWYkTaKCtEijyrq+j8K+tdYOwQwpSbdtay79eNuzxBLwRUipwvZ/bJxZPipRC+yrRGFnqmXnOhU5teOxyXD9gq8k9IImjwv/jJKYjtp2zTOWt3oi25AcKf5Qy4cwvG6R9yAUZIT8ZJbazJUM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(376002)(136003)(396003)(366004)(2906002)(478600001)(31686004)(2616005)(6486002)(83380400001)(186003)(8676002)(6512007)(26005)(36756003)(41300700001)(6506007)(5660300002)(7416002)(53546011)(66556008)(38100700002)(86362001)(66946007)(316002)(921005)(66476007)(8936002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3h0dklLY2phNUp0MzlNb0srVEVpWEtQMmpxVU14ckJZUTBmM0lFUnRCWTFl?=
 =?utf-8?B?dTVQWFBmUnpQa3FnVk85cDN2YzFrcUZJYW1aV0E3WHhiMFhzUVZ6YTAvdEZ0?=
 =?utf-8?B?czhVMmxNMzdJRnErc3FISjZ3U2JzdWNra3JmV2tzeWpiOFI5b01VcHlqZ0h4?=
 =?utf-8?B?dGNuQ3JhOFVua0p5WGkvRW1taFpRYzFmNHBvSmxnZ3RWcGE0ekl6R3Naamhw?=
 =?utf-8?B?OEdYZUszMkdYaUFIWUF6alJPbTJTYnlhY3lDRi8rWjJkelV4REZvZUpjWFZG?=
 =?utf-8?B?VnhBa1lVNXN2K0lEaC82T2ZJMWtncmZpWkgzT2drdVAveERsK3VIQ3RaUmhx?=
 =?utf-8?B?cVBINzhTY0ZwbWpScmpuTUVaRkEyc1pKZzE5SE5xLy9Pd0RzcUdNckNHOGIv?=
 =?utf-8?B?K1FsejdyeU5Pb0hQY0I5bHQ2RkdBU2hKQ0ROVU5heTdoUUc0WUNsQkNMa01S?=
 =?utf-8?B?eVh6SDZjRTJOYlY5ODJ5czNtNjJ5YktIU3l6aDIwVXR0WWZoRlN1Y3VZbysy?=
 =?utf-8?B?K3RFbnc3bWY0RGVSU25Zb1gvNnhNMG9RR3FOQUlGcXBkS0phNHdjV3E4V0ZL?=
 =?utf-8?B?TGtsT0s1eTNHN0FTY1ZRWk5UWHhDdzBmMFdTam5mS3FHWThFNjdrNzVSU08y?=
 =?utf-8?B?bmtUcHUxMDg4aHY5Ly83VUpTYktVUUhNclVrOXQ5RDA2cDJsVjFyZmhNWHp1?=
 =?utf-8?B?VlFmZ1EwaVhVN090ZlNGdzRVMmVVV3laMnNaVVBaY3VaWkQ2WjNWRTc3NjlS?=
 =?utf-8?B?RThHQmQ4aFJTMjdjczMrOFFxNTZjc0ZYSHB5cmVQMS9xcnVyM0dwaVN1eGRY?=
 =?utf-8?B?K2JMMFJ1SzlwbjZpVm80elo4R0NKeVhLcHY2bzV3eTFnd1RNcFozZFdCNGpR?=
 =?utf-8?B?dkc3Mk1NMXBESGloQWVybStjMEZSeEtlK255SnpjYW5iUXFHWHU0U05kbjRZ?=
 =?utf-8?B?SG5DUnE3dC9uNmxiUVZtN0Eyb1A2d2h4cGc5SmQzRlZqOHN6M25JcGx1RXRF?=
 =?utf-8?B?UG9jK1I3NzVWZ0tMZW4xaENFTy90bWpmOGJyUThZN0NsM1FYNEpoZkJsTThN?=
 =?utf-8?B?VGZ6RkVXOGR0L1B4QUIramNCN3VSaWh1VEFOUUFYMlRxalBHSTU5V0NFcjdq?=
 =?utf-8?B?YVhFU0YyL0RiRmd5eEwrZzRzV2oyUHBYTlYwcjFQT0VZbjFzKzgzdWVvcVZZ?=
 =?utf-8?B?dU9vaDROQnVvREF4TzQ5eWZIK280eDdpMGgxRHk3L0xXNEEzdTZtQlZSUWk4?=
 =?utf-8?B?UkJnNXMvMlY5N3lJVWY4OUtIREtpdUs0Y3NUVG5GejdOcTA4SkVYbjMwdEh1?=
 =?utf-8?B?c3NvMUNpYkg0MVA3SWd2bHUrd1pFMmR6a2VtME1oK3E1TjM4MXJSSFV2RVRU?=
 =?utf-8?B?bS9CYzVYNDlWemNHdG5TM2s2Yk1BM0VabVhxL3hIVlZLbWl2UmVJVTdVMVNy?=
 =?utf-8?B?VWpiZGlCTEIyck1aYmRta3NxUWNHbHBDYnlRU0xtN0RKZGZZWlprQWw0K3Ir?=
 =?utf-8?B?eFlObUlCbWRvUTJCNmVzOTJBRmNTMTFadXZFb1B3aC8xWWlwczRWWnA1RWU4?=
 =?utf-8?B?cHFxQWsxSy80bUdjcXlCdjF3cTBrZ09NMkxsSnp4N2M4UVZDSjYrVExzUnFo?=
 =?utf-8?B?RVdLSHRIQW0ra1h5MHdGM0w5M1gyclhoZjJvNzA3N0hoa3d2RE5seXFZSW9v?=
 =?utf-8?B?QXlJenRmWUp3YU5Ud3lFS1BCdkZtVU9HWnJvYVpUcEtsWVlaQXNFVDBPckJV?=
 =?utf-8?B?dkoydklxK0Myb241L1dTN0FubGQ3NmlrbHRtRFZUMjYvYVNHMy83QUIzNWtR?=
 =?utf-8?B?VW9DNFJOVFcxbngrY3ZNTyttQkttb2R2OWh5MngxN1RjTURqaVBWQXdJYStx?=
 =?utf-8?B?T0w5N1ZXZkxYTkdtRzk3bmR0dklxdlBUS3o1WXZGVnpzWE1vK25PU0dtOU9F?=
 =?utf-8?B?bTBnWWNwM2lwYjhRRS9vNm54OTFrWEJxZ2JTb1BWWUU0Z1B6dGFIMU9PakYx?=
 =?utf-8?B?cXQ0b2hqeUxuUmQwVEs5clNqYWpnaGpKc3Y2K2Z5K3luWHhZM2ZUakRVMS9u?=
 =?utf-8?B?UVQ4UkFHYzBhWmxsLzZQdnVGTEY2MFoxdmM0OElZTVFtSTQrMFRYamxscVd0?=
 =?utf-8?B?STNFT3BoSEsxVlIzQkxiU1dBNU1CUDhQMlB4MjVUK1NZSHhrc0hrVVhxL1Aw?=
 =?utf-8?B?Zmc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 570ec12e-962e-4adf-0bac-08da763661d4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 16:28:36.9819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ku8hJZNXi/HKEaLwTYu1HAYu+l3FCVE26Rfu4Fuy/TvdMJsLTeMHZmc9y87teG33pd20MfaLaj+veYtV73Tg2ckk10XzZQaEWeID0nNzNBA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3681
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208040070
X-Proofpoint-GUID: AqjVPYT__3b0gUwBRcGA8UBZ8dZbO3Sw
X-Proofpoint-ORIG-GUID: AqjVPYT__3b0gUwBRcGA8UBZ8dZbO3Sw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/4/22 1:18 AM, Juergen Gross wrote:
> On 04.08.22 05:40, Mike Christie wrote:
>> The error codes:
>>
>> DID_TARGET_FAILURE
>> DID_NEXUS_FAILURE
>> DID_ALLOC_FAILURE
>> DID_MEDIUM_ERROR
>>
>> are internal to the SCSI layer. Drivers must not use them because:
>>
>> 1. They are not propagated upwards, so SG IO/passthrough users will not
>> see an error and think a command was successful.
>>
>> xen-scsiback will never see this error and should not try to send it.
>>
>> 2. There is no handling for them in scsi_decide_disposition so if
>> xen-scsifront were to return the error to scsi-ml then it kicks off the
>> error handler which is definitely not what we want.
>>
>> This patch remove the use from xen-scsifront/back.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>   drivers/scsi/xen-scsifront.c       |  8 --------
>>   drivers/xen/xen-scsiback.c         | 12 ------------
>>   include/xen/interface/io/vscsiif.h | 10 +---------
>>   3 files changed, 1 insertion(+), 29 deletions(-)
>>
> 
> ...
> 
>> diff --git a/include/xen/interface/io/vscsiif.h b/include/xen/interface/io/vscsiif.h
>> index 7ea4dc9611c4..44eb1f34f1a0 100644
>> --- a/include/xen/interface/io/vscsiif.h
>> +++ b/include/xen/interface/io/vscsiif.h
>> @@ -316,16 +316,8 @@ struct vscsiif_response {
>>   #define XEN_VSCSIIF_RSLT_HOST_TRANSPORT_DISRUPTED 14
>>   /* Transport class fastfailed */
>>   #define XEN_VSCSIIF_RSLT_HOST_TRANSPORT_FAILFAST  15
>> -/* Permanent target failure */
>> -#define XEN_VSCSIIF_RSLT_HOST_TARGET_FAILURE      16
>> -/* Permanent nexus failure on path */
>> -#define XEN_VSCSIIF_RSLT_HOST_NEXUS_FAILURE       17
>> -/* Space allocation on device failed */
>> -#define XEN_VSCSIIF_RSLT_HOST_ALLOC_FAILURE       18
>> -/* Medium error */
>> -#define XEN_VSCSIIF_RSLT_HOST_MEDIUM_ERROR        19
>>   /* Transport marginal errors */
>> -#define XEN_VSCSIIF_RSLT_HOST_TRANSPORT_MARGINAL  20
>> +#define XEN_VSCSIIF_RSLT_HOST_TRANSPORT_MARGINAL  16
> 
> Please drop the modifications of this header.
> 
> This is a copy of the master from the Xen repository. It might be used
> in multiple OS'es across many releases, so it needs to be regarded as ABI.
> 

How do you want to handle scsifront_host_byte?

xen-scsiback.c will never return those error codes, but can some other
implementation? Do you want me to add translation from the XEN_VSCSIIF
to some other DID codes?


