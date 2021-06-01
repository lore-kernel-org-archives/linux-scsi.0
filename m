Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C4FC4708F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 17:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FCC8613BD
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 17:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbhFARyb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 13:54:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55338 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbhFARya (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 13:54:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 151HnTQ6122319;
        Tue, 1 Jun 2021 17:52:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=YAjV14OEm2zr6z+jcxVRowZzXXyLlrdNZntZEv3+hcs=;
 b=FhoQLsa1BPSe0D0iKVXaVsFr/q2k7nIMir22I/KtAGJbkvf1cbwAKjsUb9xS2Hv3OoRr
 do25L40S7fwoQlKkNmHEHX6dK72TClWUnT6+uXivyU6aEE0+wWIhc7p4i1XnTIOe7zlw
 4s0P/vpbMNjJczvWg+RxaeQjDTn8ejS19bnNlWt62KIRV3TWHwDQ5yy/PQ2QDbEEJTKz
 +W+zEnKtQRI7mAGyiyRFC7174JDEBpFVW1AKhnCfQ6ouBoeUTk9SqmUDuqLldJx0mdZk
 MF21iFYL2p/qtlhc3k0wS3nNT4zZtRMowfXa1vyYGiBT7/Ipx02J6aRTulsKOd0MovHp QQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 38udjmpb0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 17:52:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 151HoSKH069362;
        Tue, 1 Jun 2021 17:52:47 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by aserp3030.oracle.com with ESMTP id 38ubndbvkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 17:52:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QXV+Q/6od/LhrtEZfoTOiCHMOMD8hqryBKY44bDgoVSFCvZZZ63sjZRpyj2xW3J/yYPvwrrxZzDDW9EfqJ6s4Ld/lgY4fvtLVBrXldoANb6UCqyxGRca5DQGAltKDeH3RaH1ABNLd1Os4RXm7A6T4+lOAmumD7eCKQGC9MQgrnZ8zwmkBsQF0I10JgQwdBe3vUgIG0iKVdawZsLS5esY8ahdPxuQoiAVpDiFIO/3Nr5zGPgxLFDyLIvLHtVJ8c3b+H+kZwvU2S5EHi6PwTRcvOMi+qItllUoJ2a3T5FMaVYMENECwQmDwG9nYNBw8UhIE26IpLsyAb3IMuOojW/RNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YAjV14OEm2zr6z+jcxVRowZzXXyLlrdNZntZEv3+hcs=;
 b=JqyxAu42nE0TtrHe4zhg4O4vJ9OZ3JInMWn5FXU+t6fB7FB4u05eYPU20YEy3WGkieHoOb1Cqoowy2kP7nq8pZNQm0PKrxz347SyfochMIQ/Zw55ouc36XFC3shU0PY8tRAXad+U5nPYzbXiBHlfTBHylPcVi859PRcCA4wReMqPzE3ZBz+vnNYcCFAsc3ZLnjAChoBSaLPo3gZgpSvvGGdMlUw8ooC6n+s7/qcW+hA5CD827hPj06MXSrv7drXmzCTLzcecdZ/wQ1r5wHPUOU98mR/aWMWuBvdn6sUYqsqmGcig3XNKF3aCh8yY3Y/dpwGLSz5dFT3GmCGBwNSPaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YAjV14OEm2zr6z+jcxVRowZzXXyLlrdNZntZEv3+hcs=;
 b=WihNyr6JBBNKRcSlUdI7PiGWZEBdXmSNdcebVeN7HQXoEcqsyv3H4mAH+qyXyt7ILzwBuo9RRqhi4k6oDAMiI1qPP6Pgj67Gylqmi0M98VPZ76M4RIxZE4YZnqvEjmTyETYJyOFh7CayQQOAFPSKhK7FzvqmylnEMH9bIJyQo0o=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4811.namprd10.prod.outlook.com (2603:10b6:806:11f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Tue, 1 Jun
 2021 17:52:45 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 17:52:45 +0000
Subject: Re: [PATCH 1/2] scsi: fc: Corrected RHBA attributes length
To:     Javed Hasan <jhasan@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20210601172156.31942-1-jhasan@marvell.com>
 <20210601172156.31942-2-jhasan@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <dd421a80-36c5-337c-d786-a3039183e534@oracle.com>
Date:   Tue, 1 Jun 2021 12:52:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210601172156.31942-2-jhasan@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2606:b400:8004:44::27]
X-ClientProxiedBy: SN6PR08CA0031.namprd08.prod.outlook.com
 (2603:10b6:805:66::44) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:2001:92:8000::a72] (2606:b400:8004:44::27) by SN6PR08CA0031.namprd08.prod.outlook.com (2603:10b6:805:66::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 17:52:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 549de296-3894-4cb0-6fae-08d925260f96
X-MS-TrafficTypeDiagnostic: SA2PR10MB4811:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB4811EC6DFDFEB4816FC5EDEEE63E9@SA2PR10MB4811.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WP3+V5hjXNLctpGoc1kDM8qh7WkGvyQwdz/htRrcfyjh2nf3mwd++Q5wENpxMAONqtmMeU8td0R1A0xsU+Op43DFs4CQeGTynoOCk85qgbW/hH1avs5pHNRZYn0RLeIvQHnGPplJnfV+tp1nWaSK9xGdfqEey17XnsJZubq79tuwOltSCYh0kcnuHf3cVJo7ljUrPWyPDBgBPEJmWmeyzqm8TkXpA10T+0YMS9jaQLAu4HuoKc7nNtu5x+LcIzeD5BFdqMfcBTd8cBVqb3cRyQ7lWUBCwxyI5a6V8uYvqHEK4N+G4nqivOIvAaI5clONPPyxag8mmnUw6W2C5bJukXOkHGzbVUMs/4rz9cKV41r5nkm+CUkiaBMH4YyIYWsjDierceb0o08Jbufdku13HO+phYfW50Bbu8B0vCU5qcpL2OAUCx9l2lsxBlVJdNTz+q51Mb3dPWaggW3Oa91tJ2i72h3IB0puLkkYHUobGCxO7ugDlEVT5nMbCU7zDxaYuC/4Q2uutSKRy9GANrcZsqY6H2jumgBfolr9luXvmIBDo4IzoM3cQfu1pFezqEAvYhQCLoxXYamsMzyzTK40k/tyGmZr2+hSgm51Ak4xnCKnXRnYregP9Ve55n9mNBCIuaemdjVM1NfgURh2RfokgHR12z+3goA+zIsaXFGUrCU7bowxZcT4IRxnnYkXIgrO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(396003)(136003)(346002)(186003)(16526019)(53546011)(4326008)(31696002)(316002)(36756003)(66946007)(38100700002)(44832011)(2906002)(5660300002)(2616005)(36916002)(478600001)(66476007)(66556008)(6486002)(6636002)(31686004)(86362001)(8936002)(8676002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b1pnMzFkM0xLZVJibU0vRVphRkRyV2R3bzUzZkJaYkRMWFRVaURSNnNTQy9m?=
 =?utf-8?B?TytnelpLQnJOeEdFN25TMDBFRWxLM0tCckFXclkzUGxneUlvUDhrZDQ5UlNq?=
 =?utf-8?B?UTVVYm5zSmhzekl4anIwVk4vQkxFWkhOdUJSRmkrYTN3QVZFWGhaR3QxRU1i?=
 =?utf-8?B?VnBYNHY3RU02TlZoTTAvdkQrU0N3SzBNZVE4WnFzd2dKTmptcE8rajVOL0xy?=
 =?utf-8?B?UkI0MmhTK3hTS2xZdTVIV1cwSWdUaWl4WGJqNFV3NWN5UEJIanlqUjJ0TWZh?=
 =?utf-8?B?QWxMZzU2WVFPWnQ0MTk4NjZpTUNPcVphUm9vTU12NTM1cW5QeFBWT0tTSHZG?=
 =?utf-8?B?UEtTUWROWEl4blV4Zmk4Nk1tNEt6aUxxbmhBRE01K0w4L0xveWNFQWJtSm1i?=
 =?utf-8?B?WC8yUjBTSFhUTjRZeFVTQ3JNVUFzV3lvcWxCcWtUZkN2dEJVTGZJWkZyb3dk?=
 =?utf-8?B?WHNkVm9IVkVNdHIySEJ5YnpVVE83RzZGVVdGS1huT3ZzRDV0SWV3dWorTkpS?=
 =?utf-8?B?MWh4Y2Joa3VhNTVZejRDbUJLVDlVWG5aSlZiV2hoWEhhUFI3MDM4b3I4MHh3?=
 =?utf-8?B?Z0ZXM3NaaFZYOVVhS0NtNDJlUTcxNms3MGRIWWVyRjJEZFptb3RhZDBUb0Ni?=
 =?utf-8?B?bFZ2OVl0MThOQ095RzN3MTJ4WWw0eTA4YXBzNDZvNERhNVNqWk5QaXZ6N0RE?=
 =?utf-8?B?a3k0bzlDSFU0WGRrUUJkVzVjK0xYUWs4RmFXYmJKd0FjdG14NFpWenp0UkxN?=
 =?utf-8?B?T3B2TEJodEdDZ1phQWVxQXB2NkVORnFtVG9uUWlrbXVwM2NwV0Irb2NONDI2?=
 =?utf-8?B?aCtzODVtUXFuanlNYVdNQlptY0xkVHNWaGk1MThGN2hzazhtRDFrK2d6azJO?=
 =?utf-8?B?M0UyLzMyZUR2ZlJRYVMvK095S1RTVjdaU1V3NGIwNGlJTDNlcUp1MDBka3Jz?=
 =?utf-8?B?VERLY0ZqTVpHSCtiZGljSWJHZG13OWpabUVndVFZTWtvdkVFTkdUbHNRcndR?=
 =?utf-8?B?UEJ3eXhJdnlqaDgrV0NQQ2ZSWWZtOVRvd2crVTlocDdCeWlLUTQ3OVVSME5j?=
 =?utf-8?B?MkJSRisvVGdQcXBkeDZPUjJ1UnUyNnBjV3B0eG5LK3cyL21pQ3B4N2ZRZTAv?=
 =?utf-8?B?enZ3eUxKYkZiaTlBNEhXWGNCMjYydVVLVFl4U0JxZ2daQ2tXUVlCQzdra2VC?=
 =?utf-8?B?OXlrcTJ2Yi9kUXVFVWZhYlA3VTJ0c0VqT1I1d09QN1RxcVJtLzc4ZHN6RDJx?=
 =?utf-8?B?TDB1WWhJeDlEaWozaG9VN09NTGxjRDlyYUpvS0NPUnJwVG92d1RWdHFPYjk1?=
 =?utf-8?B?NUg0WXBhQkwxSjdWK2NMLzdqWDR6eXd1RGdvbUl2N0diQURIRTlEakFRQkNy?=
 =?utf-8?B?YjB5VEtYU2hnREdVcmNkbVR4MC93ZXcrNFpvd3AxNGpMOVJoTXphSWtrU0pR?=
 =?utf-8?B?Tmc2VXczNTEySFVKQTJna2h3Ny9kbDYwcFpXTEYxMzZjV1NOUnpYRWZFMnh4?=
 =?utf-8?B?eVoyNkU0MUtZMHgya2E4MXUzcHFBL1VFVm45YVFOMGJGSjZkU3FzV3pEQlA5?=
 =?utf-8?B?STdBVGRzUDFVcDh2MHVyZ21pTkNlTkFCL3l5bmRXWXhITnphVFpDUUR1ZjlL?=
 =?utf-8?B?N2F0NWFOcE52U1R5dlVRbVlRVnNjRUhtOWU4OFA5dVJaZS9tMVRmQzVaK3dD?=
 =?utf-8?B?YzcvSmNqTkduS0FhaEJZZVpmdElzVTd3ZDFSM0duZC9oSVNYdWRXa2JWOGYx?=
 =?utf-8?B?VE5veFc1TTc5UjU5SitWNUE0Vlp4KzZDZ0F0ZTBITjBNNCtsQWhzdUhFZXVv?=
 =?utf-8?B?dE1TVFlDbHkxV1dzTEI5QT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 549de296-3894-4cb0-6fae-08d925260f96
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 17:52:45.1957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EnkOsnDjgL7Ke6eCscjAS8V8gcHB11hO963mh4tBlCog2QEzwhW01GDFWxnCWi7KOgwEwV3Lq3CvtJH64z4hM+6/kOI8uNRpL8BjxQhELew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4811
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106010120
X-Proofpoint-GUID: uJME8T2G8I3LYrUa7xcyGLeFKin3Litk
X-Proofpoint-ORIG-GUID: uJME8T2G8I3LYrUa7xcyGLeFKin3Litk
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106010120
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/1/21 12:21 PM, Javed Hasan wrote:
>   -As per document of FC-GS-5, attribute lengths of node_name
>    and manufacturer should in range of "4 to 64 Bytes" only.
> 
> Signed-off-by: Javed Hasan <jhasan@marvell.com>
> 
> ---
>   include/scsi/fc/fc_ms.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/scsi/fc/fc_ms.h b/include/scsi/fc/fc_ms.h
> index 9e273fed0a85..800d53dc9470 100644
> --- a/include/scsi/fc/fc_ms.h
> +++ b/include/scsi/fc/fc_ms.h
> @@ -63,8 +63,8 @@ enum fc_fdmi_hba_attr_type {
>    * HBA Attribute Length
>    */
>   #define FC_FDMI_HBA_ATTR_NODENAME_LEN		8
> -#define FC_FDMI_HBA_ATTR_MANUFACTURER_LEN	80
> -#define FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN	80
> +#define FC_FDMI_HBA_ATTR_MANUFACTURER_LEN	64
> +#define FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN	64
>   #define FC_FDMI_HBA_ATTR_MODEL_LEN		256
>   #define FC_FDMI_HBA_ATTR_MODELDESCR_LEN		256
>   #define FC_FDMI_HBA_ATTR_HARDWAREVERSION_LEN	256
> 

Looks good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
