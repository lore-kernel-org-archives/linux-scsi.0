Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE2CEC6FD19
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Mar 2023 16:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjCPQE0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Mar 2023 12:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjCPQEX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2023 12:04:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F309E30E;
        Thu, 16 Mar 2023 09:04:09 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GFuB9h025204;
        Thu, 16 Mar 2023 16:03:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=OF6gQaEiqtTz7yUCFUZF+YJMYzPnH1AAv/yAyGZkirs=;
 b=PxzyqVTKHZFAKYv8RCpiNDNQjc7H7N9fH8kHhfPHKh4faYOVf02umdrEODMpvwOydXMI
 NB8CtBoGJxe2BQBWqRZNjs0VASo3cxjWmaroiyOG7ROnJoLke3shRWMjw0vJBpNoqsLQ
 zLhFf+E6hcfaqfLdVjmoWav2PadbiEanDdUKaNUaTMOUL2Ejn2fiSPRqp5rVZuidA08a
 SUy5yzQcj6bIbI1nCaiFZT9jCnFP4E3JxVZkqJ6DqQ53jOOCA9fipMlVaRziHkdn4Epd
 T0JzuylOfwWOcDpljei0kQ/iObVQAIcxtoo1wqV3QeItLpMld9WE6fEDKyaC0cFd+M5o 4A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs2asfws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 16:03:58 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32GF4B8f020513;
        Thu, 16 Mar 2023 16:03:57 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pbq46h6gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 16:03:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XBuJR1dy1BBY5ksrpLv7r3dPx4rdch+WyiGJ1aKSNdO4YA7+nr/xtoEv27rQXSmfHKhujUYsqE1cdBrddq19s8ndy1FdtP5yIPb6HqNHW0tZr9BsNtf5080aZjOVIbZ4/sddZzUTvC9p7bC1PpVGVJl0sDCgTQUmMmJV8TIsjDn9pmNa/4sG7Twp5LUhYMQq7rUnEOBCo87BE5sIMCpOWo1Lj1X989hxT3YyeDZsvD+feyf/bxy9xLuFnSXiInronbqVUqH1AGa2t76F7qEZWZnqXVN5P8MHTahP+iCTkE5W7zldwxmTNUodeihucM5TLWDoY2G6gs3UTTOP1Sa4Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OF6gQaEiqtTz7yUCFUZF+YJMYzPnH1AAv/yAyGZkirs=;
 b=UQk37Z98vsnkgTr7Dcllvsla6vMQiPIXHN36Md9moCVJd0AVRFxOS30a2WF+1jrcQNzjsuvcJtFG3l1AzBS/0aQmM1cZo0eb4LoHBVKDbGxw5quuU0RNbRxwCyHAbzVfVtWvUJd+ODsSPxiKTDjyJbYmCe5AUBgTG3EYmR1n1XaKIsO0CYCyN97HaKFCsFXcb2WN0ooXif5P2hdwVCzQShqQ+p3jp4N4HiJI8WHZN1mwajQ9QSLp3uOvIXf1D199s3TorMKDczW6E0vd74OK5Qe3ugLjFCJNeTBynz3pX6XtTP3GixTmRvgVrLAgbfDb3vuXzLrAqPQH7zTFzJPNUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OF6gQaEiqtTz7yUCFUZF+YJMYzPnH1AAv/yAyGZkirs=;
 b=bYuzxaz+VceexZpCJzEAxG0em37s2DEvwxl+zpMD8ZETU18jDhu70lRgYMWWvHYGILQgpfgzjA4+s6rt1qmGjviteT27Eab+S0UaF1bcEuJ0IDad++W5Xzi7OtNHcVwIB2BsmtYS9VVrXNuwOVfQLNHQ25pW7NpF6ekfVDSPGtQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4554.namprd10.prod.outlook.com (2603:10b6:806:111::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Thu, 16 Mar
 2023 16:03:55 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 16:03:55 +0000
Message-ID: <414b0730-fab7-a9d0-1002-ad88c8e712c7@oracle.com>
Date:   Thu, 16 Mar 2023 11:03:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 13/18] scsi: target: Fix multiple LUN_RESET handling
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20230309223312.94595-1-michael.christie@oracle.com>
 <20230309223312.94595-14-michael.christie@oracle.com>
 <20230315161301.GE1031@yadro.com>
 <50afe378-c0e8-7914-377e-ae8c91f82455@oracle.com>
 <20230315191141.GF1031@yadro.com>
 <5a1c2ac4-d7cd-b7fe-cc74-7e58e8fca968@oracle.com>
 <20230316103929.GG1031@yadro.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230316103929.GG1031@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR01CA0020.prod.exchangelabs.com (2603:10b6:5:296::25)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4554:EE_
X-MS-Office365-Filtering-Correlation-Id: c8fbcf84-4853-4932-edd4-08db26380b33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0h3AsMq2ojZbgV37UMnwXJEd71eFhJgJRtxQxp77nlMBxLfZ1gcYvd30T9oX9TczAtEWwNWT78mke/FHEfJs0f+bp8VLok8rsGBihcukrre+ZV44XHDCUsk7tjLNQD9TQ5T3Bytt4+wiYRsdqH13ZepEdIcr5xQMeBlERFvGUyLtw+H5RZdp2CVvMn0e8xdliJJinzUuklwUH6t0tsoX2OMxIg4yidv1R4EA6dxuZKbv7ydBNVfOYim4Vj0iIw9DinWQ9JWekOQSchaXqEzvJklUUfCBFrOIQfZEZp+nmM/H6C4mcJfEfoFaL0iqKCrqIWud6gW/ypJhrk9EDBYP1CWdfYKp+Ctey7z3cxrpD6QBQ6KfxNpa9KTax0+qbsdnIwQ518gOaoXIt1TALdjXmhwqD8m2Wkq3b6ZrwuzFuPyiHc0eA1HTPLbz97EGo5UcES7PfNz9FkAOEtSl/ZHl4seOUrUVldLf5/e0+69Yhp3TrYf8YYFUGtjVFP31sBkOm8AlKkYEIb1sabGvwpmeaQb2Lg18H0D6UwhcDo7cK+U8O9SifSvOvpzjHuRbFPN9snDyv2U58ZW9kEUJtqU7SfpdlgrjzlhCQJJDbkC+VFtMfNyxazv8Eq2UL412P9SleFmOcFcldTkPMsviXL3DptJzTrrPHNvwNLt/Oioz0kObkMHWl3xuF2pyIxRTD+pQI7ebZoIpK8Yq9n9G5+VcegVoxM5ZMxVncslCeJE/nqk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199018)(86362001)(31696002)(66476007)(36756003)(478600001)(66946007)(4326008)(5660300002)(2906002)(6916009)(66556008)(316002)(41300700001)(8676002)(6512007)(38100700002)(83380400001)(53546011)(6506007)(6486002)(2616005)(26005)(8936002)(186003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z01jWWJaa1ZOcGQ1cHJyMmM1a2J0NGowOE1pc2JQbmFjRGJCWjV3cklhSkVX?=
 =?utf-8?B?U1VFVFgrb2JtMHV3NTRwa2djTGhuUkZ4d25Va1dXajhRYXRCZElNVjJ0N0R5?=
 =?utf-8?B?emhvTDZyYW5tVUxPRnF2THFOdXEzVHhZL3hCVHhDNmRzcEE5alhXS1NvRDhG?=
 =?utf-8?B?Z0lqVW40RjlTOThmWjNmWXpVbzZNdlM5Wm56akNoOEVvcm8yZ0JzaXRiT2xX?=
 =?utf-8?B?NWh3WFVpQUFqRzlhOVg5M1VPRmYyeVgvWStUNFBnQmNGN2g1QkpMR1NGK1pX?=
 =?utf-8?B?WG81RGFUdDliOHpiTjljRjZILy9GTjhpN21pSmQxbFBhK1hzV1ZVTmtwa2Fz?=
 =?utf-8?B?L2hDL2hDRWF5Nm9tVzkvWjlyWkhmc0dDcmdneVQybVJ3enNJQkFxQXFEVE9l?=
 =?utf-8?B?TmhmVUhyZEpVU3VycWpUYlZNK2hTL0plOGlwWnlvNHBRWVc3NzUvRWdWems5?=
 =?utf-8?B?NGxaeXBpa0tMbTZjYzV0ZXhLNVhZNnhicytNb09peVc0VjdHVlJHU1lZRXU0?=
 =?utf-8?B?WXZheHBmak9oNDVMUDhHMDVzTWp0dmQxMzRrbWR0NEJJLzdzY3pKWW50dWkv?=
 =?utf-8?B?RDVJanpEdEZ2bUZCWTVxLzBPc2VuUkJ1Y0gvMGpnMURWQ2hIcGpSL3VGL1Np?=
 =?utf-8?B?NlluYlloaTBpWHhkdk1aWTYwa0c2bmVhQkdpUTRadnYwckdBRFFsemxWR3kx?=
 =?utf-8?B?ZlhmaGRXUU5ESFFIRG1hQ2VSM2hLayt5VGhiZVJIRzRrejdVVzNSSmxTbVNM?=
 =?utf-8?B?OWRtSDlMcktSNU9NRVN6SjFJVGRCOWxaV1NlbElYVE5OcG41S0dKNE1rUlpu?=
 =?utf-8?B?MVpyMVlFakdJeXdjejJjTTlEZVRXNjYwSU9PUEJYd0hLL0lFbFB5N1poYWtV?=
 =?utf-8?B?cGMxblVlMTZwMndGekpxYStEWlh6ck9TR0JIVnVVTkZFNk1paUtJZXZXU0NB?=
 =?utf-8?B?UEc0UThWRzFPR3MrYXZoc0lNKzZTZWlwclFLb3FqUWtyVmFrVlpmMWtkV3Qx?=
 =?utf-8?B?UFhucXdMRWxoSzJKWGVnM1k5TW9PVnNBZTlHb1lMb0FyRGVSOUR1MFZyNXZz?=
 =?utf-8?B?UGQwb1RoRENWT3ZoejZ5NDFWSFpaUWZlSVZmZkdKNDVZUXhtY1J6UzUyT3RO?=
 =?utf-8?B?SVVGUHJjSFNudEtGM2FTK0JQMXJxaUVaMnVDZy94bnpoVitlY3NldUxUT1d5?=
 =?utf-8?B?NHRwTVBlMVdWTUxPekhuQzYwczNJLy9pUkdaTUhZZS9BZlV5cllaL1BiZm0z?=
 =?utf-8?B?ekJCdnNHcDk3aFBSSjRMdDEvemlwWEdtdzRHOWl5b3daZFNYekFsclVqN3Rw?=
 =?utf-8?B?Y1NtQThhbzJjd0V1aXFnSmpKQ0JMcm5aWVNhUS9QQzhsa1BWZmY4R3RNQzBt?=
 =?utf-8?B?Wk82WVNvWjZWNzQ4cGNWTklvRFM0dnVpdVYzWTF6d3dPNzJGS1hWT1R1Q2VR?=
 =?utf-8?B?ZzhiaG9aVDBraGpFbXZ6ZDZON3l6bGhQSnFnTnBDUVNQUlowQXdnZzdqYmVB?=
 =?utf-8?B?ZWtNTGpMTFhUdnVhWGdRM2ZRNCtCaHdwSDlGcUJlL0dGKy91amovV0JvZ3Jl?=
 =?utf-8?B?Mm5td2lMd0hWZCtmeVMyOU9UVzUxMGZQMkRMT215dVEzeG82QnpRenJ3M09j?=
 =?utf-8?B?NFVYcFBlODFUTGNOdXZRNXpjTVJjVXdHSWRxS3BlbnM1dGh3azRIZnNVdk1V?=
 =?utf-8?B?NmhJVzNXZlZsRlE4K3R6REFRZjJTSHRFZFAzU1dvLzdLSG92Q3NIYjl4Vmhj?=
 =?utf-8?B?ZWFsT0xMc2F5dUJ6R21WYUZmbWhCeTBBVDlQMURnTWsvemh0VHVacHp5L3Rz?=
 =?utf-8?B?ZGYvSllWcHNLNjdDUEIyQUswNDg4dFBMSDVXOFNDTmkyTXVxazFyRUlSc2cv?=
 =?utf-8?B?Q2pxbVI3cWhJaW11THdubW94TGwxcXJlQWZyenFoWTN5TG1HaHM1TE1yeUNZ?=
 =?utf-8?B?MGc3ODRKVmpLcE15TCtYNTZDUmllOWVEUVpkUVVjV0puMzNMS1NPaHA3MXo3?=
 =?utf-8?B?TjEyeWlqUVU5UjNFY1hhd2dycy9Ea2FuZStDZVJFYVJHYWFBSnQ0cDhMakd6?=
 =?utf-8?B?UUZ1MVlKWEYxeEhnZ0hFWW9PQnpGdGFNdm03QlJ1UHhKZ1FhbU9PTjFwdStG?=
 =?utf-8?B?bFhXMG5lRG1qb3JTYUJGUGxiK0tQTjU1Y2FIeGVQcjdtbHo0MWJINWljakhu?=
 =?utf-8?B?RGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: YF6HUEPHPLF05hGGAq4ILf9ETE2yKUfcB4tNJ8UvXhODuqL5T9Am4slDGxhMG2Vz2bV18xitb1O/Uiz0C9vV5tS5Y85hmSLrMeRjnIIzXlvxJVoeOfVJ1Y6M73vZkaO2o7i6c8EVDMX5C1hHhni3jo8u7xNK1wZX8s+GFOoTUNekF6uaKR7bNbND3Duqd7KxqpmQe9I7aq2pihWF35IncxOl59KrbTgI61ZBaDkyYiHV+jpez/EfsLS1s1BI/hi8BJbIyyKju9Qj6GtDsgIRzaog5iMEjswyheD9snpA7/V+h6JSWVe7WWT6Q3H4spkeWa/P9piJk0XspKAKc4x9DLCZkmxg/Rjx9P0IePcfrDV4Uo9N46a+6qd4KUfXjQGuX4k19vMXIT1yGwIBacm7tW0OsanBHKpsYnXcfjCbpqVte8cqLr56yvEiqVJY0WSbMp/M3RXofLjRvov8KKPBB4QLiCi3KsbDdgabIhgqUlMZGL7cYducT6QsqbLnwFxLKtJ2hOeALLp2dskYlGV4DIdJVKEm0qWbh/weVR6kukHDbzCDqe4yTn9tinhxvO6xksUad3XdOmo93RdHI/Xoliti3t70vSrwt39TFxz/FkgxyQ2xMreX8WNBIW1zLOIGq5rFHDl9qu81JOoRWuRTrYNmdXMTnYS9UHN4L8yoUIE4lHnO9K4W6HBLDg4h03X/0wNA8B9ACppWaVnPv+kIYnu2GE1IM41kvWxBEU1rKrcGYJM4C2JIpu6Rf2jAVSy8p+9jtMsn2DKvNCpPP7CcIu9YRp5DwgYCi6+VR02+MUjoe2Arb1IWk1e0IJmqfHKQc5ETyitbZoqAlK66ZgY1nIXt+NXegZE9oOpzYId7gIpu7wQX5Hwbs+ml/K80k4/J
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8fbcf84-4853-4932-edd4-08db26380b33
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 16:03:55.3221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jbmIZvV7diVe2lHhsAseOuKvtlMrYGv/TL4VXP0e5Km81PiBzZkbh6QFsDh1zVU5YBwDzEXNaZAmVIfpQCIQBtqGXZHDis2IweGyrKRvfCw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4554
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_10,2023-03-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=510 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303160129
X-Proofpoint-ORIG-GUID: C8wBEYCc0kYONTz1wfZC0MGMAYmG2oEM
X-Proofpoint-GUID: C8wBEYCc0kYONTz1wfZC0MGMAYmG2oEM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/16/23 5:39 AM, Dmitry Bogdanov wrote:
> On Wed, Mar 15, 2023 at 04:42:19PM -0500, Mike Christie wrote:
>> On 3/15/23 2:11 PM, Dmitry Bogdanov wrote:
>>> On Wed, Mar 15, 2023 at 11:44:48AM -0500, Mike Christie wrote:
>>>> On 3/15/23 11:13 AM, Dmitry Bogdanov wrote:
>>>>> On Thu, Mar 09, 2023 at 04:33:07PM -0600, Mike Christie wrote:
>>>>>> This fixes a bug where an initiator thinks a LUN_RESET has cleaned
>>>>>> up running commands when it hasn't. The bug was added in:
>>>>>>
>>>>>> commit 51ec502a3266 ("target: Delete tmr from list before processing")
>>>>>>
>>>>>> The problem occurs when:
>>>>>>
>>>>>> 1. We have N IO cmds running in the target layer spread over 2 sessions.
>>>>>> 2. The initiator sends a LUN_RESET for each session.
>>>>>> 3. session1's LUN_RESET loops over all the running commands from both
>>>>>> sessions and moves them to its local drain_task_list.
>>>>>> 4. session2's LUN_RESET does not see the LUN_RESET from session1 because
>>>>>> the commit above has it remove itself. session2 also does not see any
>>>>>> commands since the other reset moved them off the state lists.
>>>>>> 5. sessions2's LUN_RESET will then complete with a successful response.
>>>>>> 6. sessions2's inititor believes the running commands on its session are
>>>>>> now cleaned up due to the successful response and cleans up the running
>>>>>> commands from its side. It then restarts them.
>>>>>> 7. The commands do eventually complete on the backend and the target
>>>>>> starts to return aborted task statuses for them. The initiator will
>>>>>> either throw a invalid ITT error or might accidentally lookup a new task
>>>>>> if the ITT has been reallocated already.
>>>>>>
>>>>>> This fixes the bug by reverting the patch, and also serializes the
>>>>>> execution of LUN_RESETs and Preempt and Aborts. The latter is necessary
>>>>>> because it turns out the commit accidentally fixed a bug where if there
>>>>>> are 2 LUN RESETs executing they can see each other on the dev_tmr_list,
>>>>>> put the other one on their local drain list, then end up waiting on each
>>>>>> other resulting in a deadlock.
>>>>> If LUN_RESET is not in TMR list anymore there is no need to serialize
>>>>> core_tmr_drain_tmr_list.
>>>> Ah shoot yeah I miswrote that. I meant I needed the serialization for my
>>>> bug not yours.
>>> I still did not get why you wrapping core_tmr_drain_*_list by mutex.
>>> general_tmr_list have only aborts now and they do not wait for other aborts.
>> Do you mean I don't need the mutex for the bug I originally hit that's described
>> at the beginning? If your saying I don't need it for 2 resets running at the same
>> time, I agree. I thought I needed it if we have a RESET and Preempt and Abort:
>>
>> 1. You have 2 sessions. There are no TMRs initially.
>> 2. session1 gets Preempt and Abort. It calls core_tmr_drain_state_list
>> and takes all the cmds from both sessions and puts them on the local
>> drain_task_list list.
>> 3. session1 or 2 gets a LUN_RESET, it sees no cmds on the device's
>> state_lists, and returns success.
>> 4. The initiator thinks the commands were cleaned up by the LUN_RESET.
>>
>> - It could end up re-using the ITT while the original task being cleaned up is
>> still running. Then depending on which session got what and if TAS was set, if
>> the original command completes first then the initiator would think the second
>> command failed with SAM_STAT_TASK_ABORTED.
>>
>> - If there was no TAS or the RESET and Preempt and Abort were on the same session
>> then when we could still hit a bug. We get the RESET response, the initiator might
>> retry the cmds or fail and the app might retry. The retry might go down a completely
>> different path on the target (like if hw queue1 was blocked and had the original
>> command, but this retry goes down hw queue2 due to being received on a different
>> CPU, so it completes right away). We do some new IO. Then hw queue1 unblocks and
>> overwrites the new IO.
>>
>> With the mutex, the LUN_RESET will wait for the Preempt and Abort
>> which is waiting on the running commands. I could have had Preempt
>> and Abort create a tmr, and queue a work and go through that path
>> but I thought it looked uglier faking it.
> Thank you for explanation. But I think you a not right here.
> Preempt And Abort is used to change the reservation holder and abort
> preempted session's commands. A preempted session is not allowed to send
> any new messages, they will be failed anyway.

For the ITT bug, a preempted session can still send commands like INQUIRY,
TURS, RTPG, PR-in, etc. If those commands have the same ITT as the command
the Preempt and Abort is waiting on, we can hit the bug.

Also in general for the ITT bug, even if the new cmd was going to be failed
due to a conflict, it's not right. Eventually the command the Preempt and Abort
is waiting on completes. The initiator is going to end up logging a message
the user almost never sees about getting a command response but no running
command, and drop the connection, and bug people like us :)

For the second issue, if the LUN_RESET came after the Preempt and Abort on
the same session, the RESET doesn't clear the registrations and reservation
So it's going to be sending IO down that specific path, so they will be
executing.

Agree with you for the no TAS and RESET and Preempt on Abort running
on different sessions case. I was thinking the path that got preempted
could later get registered and start sending IO, but I don't think that
makes sense.
