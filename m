Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB75CC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B95E760F0F
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 05:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbhJVGCP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Oct 2021 02:02:15 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:42238 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230086AbhJVGCP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Oct 2021 02:02:15 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19M2qeBJ019167;
        Fri, 22 Oct 2021 05:59:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=VI7RTPgFIYlfd9+iE0cWwOukuOfS0O1582E3VUyumqU=;
 b=oLzJfvR3vFTaSGgAFu/152vXxruz8UuSEPu1fkckghQ3r5ssuv/F5c53555Kibe8IL/9
 U2634gDCE2CVmXcG00Ge+zgRPOqWKgCOAjhefnbYtqfDvtpaNYYG7VoXWQdobBhIYm2w
 tUn5sFtttZJf8huWS2SeKSwSHSRLFdMynupUnGXihi3hctsdW+GX3chcSX4M+tlbEqk6
 3/mB0X1eFczyow8RSfvWMQiZf7QwyM2A7EqVZZCi21AcMOpCVrAbbyYHMZROlyIEVGtS
 2G5q46eTU98HVt2thYMMYeokc9aGedCz36aM4O+txNqSjZzydQ4LElOFKiuEc7JXuLSy Zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btqp2s4wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:59:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19M5tIal072871;
        Fri, 22 Oct 2021 05:59:56 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by aserp3020.oracle.com with ESMTP id 3bqpja2u72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 05:59:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HUWSXemQsP9beoeibcMy3TFdPHxFhC+v5SIVa7Ku0mz/33DXW9UizvIzZcb48aTrWZBC7GlCGcaij/NjyYly3vKF17XzkO1G0LTbmM+imFWb0kj57c/6mt9gjyUcb5DDDkgUQLVIGA0k++v1jSM9erKa4xCkoxKRu6P4Cwom1E4Y6lgVAjB47j/hvOH28nuHSmd+d1dYlAxNWYOcOtPL6voReTBByqVSz12a0uzC9zHCZ0z9Qjs0ksnMcnRCm4dpJA6mcc76YnOullUReY2DCa/IZ4N2RJb/GF8bNb0ffC4BPo/1abJC7ZOUMqQnAPtUynDji6El47jJfYHr8Pyr2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VI7RTPgFIYlfd9+iE0cWwOukuOfS0O1582E3VUyumqU=;
 b=mfrU8b8+hXRZJ6GlYfjUQWb33+JHAQDl56UPUl6quXklLSmoEyx56O9r0kyuz8eN7sxJ7TYwxUQXWddA+QpziRAMXxlwPFcHNuy4J5iOAzxoN7GFLbz5zDxS4Rd8VX2WxfKuav+oMKFowTkr3Rw4ulE/Y5ZUJvNHe1y01jmLJdqxHm6dDeeSeVyusceGpUzQBdNooEv6hyj4xc5yOlo4ms21s1YkSFo56esDDi2TRZ8oZMX3mYZ2ldw4dxDMpydi/L/YJMKYERtdi+hYvmzDWdeeJtmRs+otLGCVjMzv4Zg+3St2+0KlhsBT4b9pMmOPgzxwiaHzRFsQBRCr+VMRxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VI7RTPgFIYlfd9+iE0cWwOukuOfS0O1582E3VUyumqU=;
 b=wDzXWwJ57GRX+b1R6TV/2/n8C238Xv0fV01gS0RDNNZY9aR2u2Q8BfDe0wZsfUt+ajKV/NuevgK0aWPmNXxTPEXbD42NB7EtggMOqH8/lwhukIpCdFg8HAz4bqiQ9Y46/J8AU2edk4bGZiDP1HQUC/vtB1ljXknVwAfAPtZ+dH8=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5184.namprd10.prod.outlook.com (2603:10b6:5:38e::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.16; Fri, 22 Oct 2021 05:59:55 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 05:59:55 +0000
Message-ID: <ec9e01a3-73d0-a06b-8c20-ae492c0c3313@oracle.com>
Date:   Fri, 22 Oct 2021 00:59:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 0/3] target: iscsi: control authentication per ACL
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com
References: <20211019071843.14890-1-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20211019071843.14890-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM3PR14CA0137.namprd14.prod.outlook.com
 (2603:10b6:0:53::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DM3PR14CA0137.namprd14.prod.outlook.com (2603:10b6:0:53::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 05:59:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb8fa0c1-c74a-42b5-86a7-08d995212b8a
X-MS-TrafficTypeDiagnostic: DS7PR10MB5184:
X-Microsoft-Antispam-PRVS: <DS7PR10MB51842953967FCD9E0C06A634F1809@DS7PR10MB5184.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DIiVeyzMi28ltkzW6Tac9VkGbOAced6lJVw4vZFCF7y08J3vaOx3bzRMxVRuktoQUkJGEEVX6oGEA7mkOw1auZcTq8aAajlgS3QNELIiZ+W4W8zZn2fV39EUDMLu2Yz2D0x2W5KCyxe2JWm7yILJjjoXKp82gUTqJ5IrIQAUtlbsO5bnReGfc7mXkxCzZ23BvNlF1ksWBTliTh0cWmo8fk/Wr0Rhb20nar1I1muf+FwIjIKWjLhDw0Gok0iLp8HPsLnDW2wZLnoo9U4VlY0ESYfK9izSmG0AUrmlb8m1qc+q8ZYKSdLne0Yh+UeqdW09oz5b/W8hWFcJrHmuk6L1ODcRe2O01fEYaiUj2TRIPecmk9gZIa9ZJBC8w/+gM3nqkUl++riOvFBfxfTMPSdb1gdMq8s2scT17LK58J62tRg/DTRDZs3Nuv8UIJWfIXWXiUm1vH1dX+bPG8xK/FKezcrOV2F08CoOe3aAa2cAsRhWQfQJ09PRYq+0kHKN+Z6U7Q8VNBZ9bF7GFOU/Z/Q9OUgNqoRb3nHJjCtda6pkAe/kYf/mqtc2qQtlvwMKOj5HOa6nOtjNoL9ZJhG9aHXC/0HYDHkRYkaCzYsd3BxTO9SZLZZljuT77f7GLaV7kKwuORDasli1R2BrOoLWASQQndiXVg+S/xd3rqWukCFoqJB094mmK8JwseSQbiXlVdkhsfjTasLmOZ5GtkoQDRg8c3/kzqHwIkbiG+Wpmnvy8RDbx05IAnXSKHvOknVn+ZdKUJfoHygZB79XNCAOdoSJ0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(8676002)(2616005)(8936002)(83380400001)(2906002)(66556008)(86362001)(26005)(5660300002)(186003)(508600001)(16576012)(6706004)(53546011)(66476007)(66946007)(31686004)(31696002)(110136005)(6486002)(4326008)(36756003)(38100700002)(316002)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFhFdXpCUUZSNUVGMkZsTkJkSkxtMTRDaGQwd0NpRlNST2U3M253R0hoc2Vy?=
 =?utf-8?B?YVZ4YWxuMy9ranpUcERFMHVOS2NWejRJQWcxQkdsQzBPeDNSUmxhcEI3R0Uw?=
 =?utf-8?B?eXk4d0hxMCtxVVZXQzV3TVpDWnJXdWZQc0wyQzNLZlladElWTGlySUwwelBk?=
 =?utf-8?B?MURkY0JVM1FWSVhNSnllK1oxc1JTKzR0K283YWMvUytwTDkzd012MEtiSkds?=
 =?utf-8?B?a1ArZVZxWVdFeHBMYWk0bVByM2VIZURwZGNOQ21PU1pWeW5JVTBLSVkzSGhN?=
 =?utf-8?B?K3ZSY1o2VkdEc0k4OVFybnQvMjQzdjVLUUt1Q0MxQkJFUU14TVhDQVlMcW5P?=
 =?utf-8?B?dFNpZ0tuUGt4bVdnR1VNTmIzRDA5ZElleVpWcHJ0T2JXL3hIWUhXNDBqc0NO?=
 =?utf-8?B?bnZwek05aXBMVjFJOVM5RGF6blZIT25zRitBTnBhY3ByNkZxWE9yeDkzY3Nr?=
 =?utf-8?B?YVZmQXNLZ2RDdzBtRDhsaVVSQ0NxbGxvMTZsQ0ZtVnp2RFVnWkpEQjdhRkVv?=
 =?utf-8?B?T1dLVzhlUzRQOHBXcHRXNGp6VWFzbk16NVhsa0pIc3RFUXdqWEVNcTVhWXhs?=
 =?utf-8?B?L2M4Vms5MWt4SDhNTzRONlhva1dDV1ByWFkwazRmME52NmF3bWJJcVpjSGZZ?=
 =?utf-8?B?cmdyRnZUczQvRmRvaWhUMzVrNUdtK1owMmt5NnMwVGQ0ajBhZFUyNHBGNWRa?=
 =?utf-8?B?amV0SlJ3eTdYcUtwZkEvdXdwcUMveFhkcXBYT3ZaSVJ2eUFhUGRrVEcrWmVY?=
 =?utf-8?B?N1F2UXF1MzFyOWE4dXZ5YThaT0lzT0JndDkrY2paOTNzbmhRZXVSWFpEWkRU?=
 =?utf-8?B?OFI3Q3M1QTJZdEpLUTNueUkvVjdoQTJNZmFsS1V4MXNyMlk2eWJtdE94TE1s?=
 =?utf-8?B?YXB2RmNjZ01IL1RRWTFOVjh4Si9MSXl4YkVJOGpkcFdJeVMzL0Y0QVJPZ0cx?=
 =?utf-8?B?L2dBR0hLelNDbGhXK3ZpTGFJZ1pka0E0NEx6d01TSkprN2dZZVhRZWI0WTlP?=
 =?utf-8?B?ak4wSVU2LzVReXpTVk5LTWhSUVY2ZXVySklndjdQNXNqdUJkMEZwVWFKSHlw?=
 =?utf-8?B?Q0dVSHA1OWZUTGRTdjR1MWExVGt6RXB3QUFuSVg2T1lYcXA3VllydGpLN0o5?=
 =?utf-8?B?WGVJTXVrOUZBQS9yZ2RzeCtuWVlFaU92OS9XUzg1Y3JrUHhXbDZHZVVERlNj?=
 =?utf-8?B?Ui8yK0Jkdk5YeWVER2YxdlJzVFlaN3BDT2RFbG5ZNXYyMXgyR0FKcytRcmNL?=
 =?utf-8?B?WUpDUy9UK3ZVL2JKc3FzczE0VStueUZoS08raVgzcE5ZdzNHazhqRW42TGJE?=
 =?utf-8?B?VlBITTE0VzRXT0hIMGh3UlFZOWxIWWNJekZTYWRQbDQ1Zml6aS9nTXVtNTVh?=
 =?utf-8?B?S1gzMHFacG5CalY4eGExSnJzZUV1Y0w0NUZnQk5HLzArWFIweDhzc3RKRW1r?=
 =?utf-8?B?aExseWlWM0hjUC9ObnNERkNiNmlmSXBDcjR2OWpFNkQ3bkNUWncxWnlLYi9Q?=
 =?utf-8?B?bldRQVowQkV1UDRoWHVFOXhXVWNoQXF3NXljMlNPc0pnMDVRQjFKUkM3S3Ba?=
 =?utf-8?B?R0N5ekdNWk5yYituRW9uOXIrZFd0di8vRDNCMGQxK0pQcU5LdmJ4eitvamND?=
 =?utf-8?B?Qk1PeFZkbmNUSDNwMFBINStheFRiNWQvMXlKdUZiejZvQnRjS253NjZ4YytP?=
 =?utf-8?B?TGZlWDdiMzY4dWJWMHBIT3VhQ01Cem1JUEtpcG00clRJYW5ibkRjSW5DaFRN?=
 =?utf-8?B?UzVIclVhNTUyTm1lTUlMVkZ6aVRWQVJYTlpEWHgxVkNBOEJtWERPaXlvYXN1?=
 =?utf-8?B?WmtYaFAvWUVVTklQcVJuM2hpcFpJSWV5b0Rtd2NRRG81QUwzUGFxNjFXdDN1?=
 =?utf-8?B?MWNWU2ZpYXhscVpaUTNIeXNSOXRjK2lKZXBYL0VPNDhEYm56UVRuazNaUHJE?=
 =?utf-8?Q?98s7bKvEVzBZNskB1Y+bBLDAVOvIi43z?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb8fa0c1-c74a-42b5-86a7-08d995212b8a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 05:59:55.0672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: michael.christie@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5184
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110220030
X-Proofpoint-ORIG-GUID: 3AhvLM1QwMaExwuzRDO7RyEjk4-QcGMg
X-Proofpoint-GUID: 3AhvLM1QwMaExwuzRDO7RyEjk4-QcGMg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/21 2:18 AM, Dmitry Bogdanov wrote:
> dd acls/{ACL}/attrib/authentication attribute that controls authentication
> for the particular ACL. By default, this attribute inherits a value of
> authentication attribute of the target port group to keep a backward
> compatibility.
> 
> authentication attribute has 3 states:
> "0" - authentication is turned off for this ACL
> "1" - authentication is required for this ACL
> "-1" - authentication is inherited from TPG
> 
> This patchset is intended for scsi-queue.
> 
> v3:
>  fix warning: no previous prototype for function 'iscsi_conn_auth_required'
> 
> v2:
>  show effective value (-1) for inherited mode
> 

I can't seem to get the patches working with the targetcli config file
below It worked ok before the patches.

I get this error:

Oct 22 00:56:25 ol4 kernel: CHAP user or password not set for Initiator ACL
Oct 22 00:56:25 ol4 kernel: Security negotiation failed.
Oct 22 00:56:25 ol4 kernel: iSCSI Login negotiation failed.


{
  "fabric_modules": [], 
  "storage_objects": [
    {
      "alua_tpgs": [
        {
          "alua_access_state": 0, 
          "alua_access_status": 0, 
          "alua_access_type": 3, 
          "alua_support_active_nonoptimized": 1, 
          "alua_support_active_optimized": 1, 
          "alua_support_offline": 1, 
          "alua_support_standby": 1, 
          "alua_support_transitioning": 1, 
          "alua_support_unavailable": 1, 
          "alua_write_metadata": 0, 
          "implicit_trans_secs": 0, 
          "name": "default_tg_pt_gp", 
          "nonop_delay_msecs": 100, 
          "preferred": 0, 
          "tg_pt_gp_id": 0, 
          "trans_delay_msecs": 0
        }
      ], 
      "attributes": {
        "block_size": 512, 
        "emulate_3pc": 1, 
        "emulate_caw": 1, 
        "emulate_dpo": 1, 
        "emulate_fua_read": 1, 
        "emulate_fua_write": 1, 
        "emulate_model_alias": 1, 
        "emulate_pr": 1, 
        "emulate_rest_reord": 0, 
        "emulate_tas": 1, 
        "emulate_tpu": 0, 
        "emulate_tpws": 0, 
        "emulate_ua_intlck_ctrl": 0, 
        "emulate_write_cache": 0, 
        "enforce_pr_isids": 1, 
        "force_pr_aptpl": 0, 
        "is_nonrot": 1, 
        "max_unmap_block_desc_count": 0, 
        "max_unmap_lba_count": 0, 
        "max_write_same_len": 0, 
        "optimal_sectors": 4294967288, 
        "pi_prot_format": 0, 
        "pi_prot_type": 0, 
        "pi_prot_verify": 0, 
        "queue_depth": 128, 
        "unmap_granularity": 0, 
        "unmap_granularity_alignment": 0, 
        "unmap_zeroes_data": 0
      }, 
      "name": "ram0", 
      "nullio": true, 
      "plugin": "ramdisk", 
      "size": 8589934592, 
      "wwn": "9ea6da68-aec0-4560-baa8-834383f1cc6d"
    }
  ], 
  "targets": [
    {
      "fabric": "iscsi", 
      "tpgs": [
        {
          "attributes": {
            "authentication": 1, 
            "cache_dynamic_acls": 1, 
            "default_cmdsn_depth": 64, 
            "default_erl": 0, 
            "demo_mode_discovery": 1, 
            "demo_mode_write_protect": 0, 
            "fabric_prot_type": 0, 
            "generate_node_acls": 1, 
            "login_keys_workaround": 1, 
            "login_timeout": 15, 
            "netif_timeout": 2, 
            "prod_mode_write_protect": 0, 
            "t10_pi": 0, 
            "tpg_enabled_sendtargets": 1
          }, 
          "enable": true, 
          "luns": [
            {
              "alias": "edb6aa7bf4", 
              "alua_tg_pt_gp_name": "default_tg_pt_gp", 
              "index": 0, 
              "storage_object": "/backstores/ramdisk/ram0"
            }
          ], 
          "node_acls": [
            {
              "attributes": {
                "dataout_timeout": 3, 
                "dataout_timeout_retries": 5, 
                "default_erl": 0, 
                "nopin_response_timeout": 30, 
                "nopin_timeout": 15, 
                "random_datain_pdu_offsets": 0, 
                "random_datain_seq_offsets": 0, 
                "random_r2t_offsets": 0
              }, 
              "chap_password": "myiscsipassword", 
              "chap_userid": "myiscsiname", 
              "mapped_luns": [
                {
                  "alias": "76dc7c92d0", 
                  "index": 0, 
                  "tpg_lun": 0, 
                  "write_protect": false
                }
              ], 
              "node_wwn": "iqn.1988-12.com.oracle:ol"
            }
          ], 
          "parameters": {
            "AuthMethod": "CHAP", 
            "DataDigest": "CRC32C,None", 
            "DataPDUInOrder": "Yes", 
            "DataSequenceInOrder": "Yes", 
            "DefaultTime2Retain": "20", 
            "DefaultTime2Wait": "2", 
            "ErrorRecoveryLevel": "0", 
            "FirstBurstLength": "65536", 
            "HeaderDigest": "CRC32C,None", 
            "IFMarkInt": "Reject", 
            "IFMarker": "No", 
            "ImmediateData": "Yes", 
            "InitialR2T": "Yes", 
            "MaxBurstLength": "262144", 
            "MaxConnections": "1", 
            "MaxOutstandingR2T": "1", 
            "MaxRecvDataSegmentLength": "8192", 
            "MaxXmitDataSegmentLength": "262144", 
            "OFMarkInt": "Reject", 
            "OFMarker": "No", 
            "TargetAlias": "LIO Target"
          }, 
          "portals": [
            {
              "ip_address": "20.15.0.204", 
              "iser": false, 
              "offload": false, 
              "port": 3260
            }
          ], 
          "tag": 1
        }
      ], 
      "wwn": "iqn.1988-12.com.oracle:tgt1"
    }
  ]
}
