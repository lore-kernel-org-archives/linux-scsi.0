Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D656C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 21:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6805161438
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 21:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346203AbhELVNz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 17:13:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37782 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236199AbhELTLi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 15:11:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CJ93PM083711;
        Wed, 12 May 2021 19:10:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=RUkwLcup//TpUeO4zmt53NGQ2LY1wVKtt4rFkGpNKEY=;
 b=V5sHuhE/K071silQpG9RbKdjwGUC+1DJA0fYPSEGGX2W4V/9I/dxY0hpAnWFKP1N8bfV
 8Iw/49ZbCur5/yhYxHJUY9N5RrZJums1kzhwGfxVYJZUPFJkOsWK1FML7TNtoqeI6V1f
 bEwl25tnnnY3TTTa6FhW1rvV6gtBhWuLfEe5bthU/Q8Q9AmabCEL/UnIIRyCuDpyPLY6
 dpKAFvs8SmQ8h9fgVXm+NyN6tz6VL7VqPyl+a3mQ1k6H2oOeCJizLbf7R2Uj7ewCjKAU
 Ac/c0jx8Aqxu5FHoq3NTUM/dlOb0HSsdvrnsGPLQWaLdjwDmwXhglERcFN6uq64KGcIV 6A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38dk9nk0cn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 19:10:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14CIimCG186346;
        Wed, 12 May 2021 19:10:15 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by aserp3020.oracle.com with ESMTP id 38djfcncnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 May 2021 19:10:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MIxtk4niJ2Kos8bhV5N9xlzfHG81nSc/kgII7oAG7BX00dNpuScpXAdt+RlvmIHb7Xj0rjbxW/vpgUhmWhSrTHC6gHfZLUct8R85qP01cH+UzjzXd8Tq3rzGiJrW81Dk4X5yAVSgb97rFAgjCIs4Qx1BC1TFgr7SY/sKWmCSphqLrMfX5EoycZbqDTJfWeivMgLA5sTNqe/lXYaYN77mF5nzsQK4e0P9mnbjcj0IvDdtIiudVbz8rGL1Rf8SclyS+20WJ6C2zxPXwU+cJEJ+qiOOY5qKcfnrUW/LLI7Yynao/guECISDJa+nJP9hCcWLVKk/kWO+4Ty6E/QfQihRJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RUkwLcup//TpUeO4zmt53NGQ2LY1wVKtt4rFkGpNKEY=;
 b=nt+LJf8vzqQHxe+UkE4RBipE238Ly+QurNCWyrwjtSrxgVRcj9dSUt13fSyURBQkzRPlonfO1hY0pA1sAPpCaGd8BAHkXKbTtFdONX6OMkfvAbOjBqP/eqsWFxYR9GgVMLtAlUXZjwhyAUXXGBtHBO8BhVS1DdeF8QdSc1gWqi148rjbxaZHT7yBgdB2dafcLmlgHvqGSE21kVN5AmDdSoe7bIV445pw/6JXIHvrzryxeWftMN9nwwyzovYLVuRvekK8bFHysfKONQG0D/qygTRqttUuIQxCeY7dcKD9yLGm/0+uYrQjJo0ODVjLlskT2GcY74cu/RcRRsr31wIXNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RUkwLcup//TpUeO4zmt53NGQ2LY1wVKtt4rFkGpNKEY=;
 b=iuP5YLku3+jtrMw0vKlu8JU4qfrUkKvl29E8zFvCFKEOlYVCIwavjhJ2+xMngJi/flOAHkZ2hrlMcGSV+Uky8wf/DzuXyqIs8nmGaWGVQvfJedcu1ShvZO0yLC/KVVJQ9v7GYKxXBpdkt6E1T1P+L3RhW76m2xbdSjxws3/CNvU=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4638.namprd10.prod.outlook.com (2603:10b6:a03:2d8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 12 May
 2021 19:10:12 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4108.031; Wed, 12 May 2021
 19:10:12 +0000
Subject: Re: [PATCH v3 4/6] scsi: iscsi: fix in-kernel conn failure handling
To:     Lee Duncan <lduncan@suse.com>, khazhy@google.com,
        martin.petersen@oracle.com, rbharath@google.com,
        krisman@collabora.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20210424221755.124438-1-michael.christie@oracle.com>
 <20210424221755.124438-5-michael.christie@oracle.com>
 <3a8f6c7d-bc08-90c0-4899-ba336cc4cefe@suse.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <9b44d767-48db-bf32-f561-68524f8db437@oracle.com>
Date:   Wed, 12 May 2021 14:10:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <3a8f6c7d-bc08-90c0-4899-ba336cc4cefe@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM3PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:0:50::31) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM3PR03CA0021.namprd03.prod.outlook.com (2603:10b6:0:50::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 19:10:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea9e5492-e04e-4925-1f38-08d915799153
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4638:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4638A2006E90DD331C0C0637F1529@SJ0PR10MB4638.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h9F8rUpxcr5eB8AtvjEIwr6Rb9hiaVnbAeLIy1Ey9xlwrkutkpkkTeu3lDhVBACOJKCGP7hZ6H0yZZKMGoqEiltuSkGLjp1gsl4zRNdcekAyhJ7IFaH+x2enX/C4ag3q78LUvGqZSvYmDraAnRMg8y0ycdfdbppM8LV4sDOIZyS+h+6V6pI7UbktECQQtzbbONLrgLp72PMsl2RLXunNZ+lHh/I2lSJidA+fsONF9FOznDJcyx9MvpAmwCkWHm1o6KnlMW3RpttYbNMipJXfQU6rRet4ZVX/m98jPXS2FVrS1gj9/ME2PLOkLqG3v4UXxLIqAMXcpDYJ+tlpn6DHw+y+tWDuuFKAOAMCUmPCHcjoFFViECbkkF+7FoGzFKBHqcGSBuJHkZgUvbxwVjRwurlEvlXj+wfzEdVHMO6FeJJsrFmiIzTRR0RUd51z6LhriiNWgUf+pG0qGjYwWTHpOdnKFK4nIHNLW1fWSjhet/uhc6ITa8aSgEtCJm6rn1BlnVGyuccmKCiFPBc+BYqnkkR8eqGLfYQmRQIrdm6ptgX7bq3LdXh3AHSa1cw1rdEROh+LyB8evF14i7Y2bUnUn2gkgMO0RKgNTaJFha/36Bs1u2GnNwEsxH1EdynmOB+SSUJ46hBc8S0FN0pATpi39g5uq/gXTXFvoY7ocYr7eUiP8AWjdolZ0UTJBGghD1sOSIhS3/2XlKD4awStxPZPaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(136003)(396003)(366004)(956004)(2616005)(36756003)(26005)(16526019)(5660300002)(66556008)(86362001)(66476007)(186003)(16576012)(66946007)(316002)(38100700002)(53546011)(2906002)(6706004)(478600001)(31696002)(8676002)(6486002)(8936002)(31686004)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dnFCUzBHajJiTG53bkpBa1l3VVh1UEF3Nzl3REY1ZGlQNnhwQW8vdGxVTGRE?=
 =?utf-8?B?ZDA2TmZQRW02bk13Wi9XZmI1NGpTTFQ2ZFRLdXoxa3NvblQvRGowejlYSm44?=
 =?utf-8?B?eHI1d2NvOXFGK0pDZU5DSjdtTVVvMTZWOCt6SGxEOTBuTmovK2pzY2FFN3pD?=
 =?utf-8?B?enVzTmhaZE05S3NORDBieGxoaGlqY0dvRHFlUXAvL09jbkNxcHpBa1JSL3ow?=
 =?utf-8?B?NzNCY0xtQ0E5SnRhejlUR2J5QWNOZndBNUw0ZGczMDIvK3p3eDlZbEViNmtk?=
 =?utf-8?B?eUJjWnhoS2l0SkVzTS9FOXZxM216aUUzRkNMY1FacHlrM2s4aTVCUTZkRmNa?=
 =?utf-8?B?NmZFNUNrRmdnUFJVbW5UbHFOVkYyTEp4Yk0zTmpXSm85cUdBVlh3R3RVSGR4?=
 =?utf-8?B?d0UvWGp2d3BHU1FvS2lVS1pRREhYVG9SZndwRU1BVGsyNDJFdmZ1eVQyVEVT?=
 =?utf-8?B?VFZPcFJVbTY1NVFWVER3bkoxcEdvbE4xTWRWVmJtYWhJVTQ5OVMrOGtaZWgr?=
 =?utf-8?B?dlBBc2sxcnBkdHMxQ1NKU3VMcVlqdmJMeUIyTGw4UmJ4a3Z6TllaTC9TUFBi?=
 =?utf-8?B?K1lCYk1NN2dIcWltVnZDeUFBTktnNm9YYWJlVTA3ZFdzNXd2T2Z5ck81SUJm?=
 =?utf-8?B?dlJaSm41TDVOTi9KYnBIRDM5dysxZHVFN2ozUkx3MnREV3JoeVFjTFMvcEpn?=
 =?utf-8?B?RjZ6RTd4MWIxaG5QUWwxK2puQktERzZpNHozVWMxd3FhSjFJS3FDYW83eVZN?=
 =?utf-8?B?SHNoOE1xT1drc1pSUWJsTjBxRmg3bVA4RTFjcU9uSEwzRnR1ZjRoWDd5UExG?=
 =?utf-8?B?QVZha3M2ZHRuc1lvaDVqa053V1N5WGMrYnZOYUE3ajA4NXNKUnJHVTY3VWhP?=
 =?utf-8?B?c3JVNVVKVmxScEF4NzkreEFzUm1MNGd2S2M5N3FVeThHNWlPSkxBS0JjbW5I?=
 =?utf-8?B?MmE4MStCdFlkc24xdFVSVFZhZ2VtaEtJK3ozRDV0ekJaNnBvVnFWa0kwanM4?=
 =?utf-8?B?L0xrcGNpWFR1cGFOM205bGRtWkdZSUl5ajVEMDE2aXNraDRpbUI5UEZ3T2tB?=
 =?utf-8?B?L1lZb29wT0RmK0paRkgyemJubUVmR0Q0TlRCMzF3akxaL2lIV0dhbTlwMkIy?=
 =?utf-8?B?UHpkeXZMeUtEMzVDblpyWmt3U0JzSW5lc0RUTms4MUNEVTdIc0g1aERKZm5W?=
 =?utf-8?B?NGJFN3pMN0ZndGFpTXF3VjZQdllRSXdaOTlwZlpraFJFbzArall0ZCtNKzln?=
 =?utf-8?B?Yy8wZXNidERhL3o4SG9iZ0VvYkMzWUN4MUNQNlA1aFRvQTRPeGFBWnYzc3lI?=
 =?utf-8?B?cW1BeW56YlFVa0J0YVEzVlh4MGl4TzE3dk90WnBVc1hjdmlaZHJITzlVOWty?=
 =?utf-8?B?b0NvZjYzUnhnSlprMGRNT1ZFUFljek5aNDB4WVdyK2d6ZkZGK0ZNN0ZOb1Ez?=
 =?utf-8?B?WllrZVM1UDNERk9aR3g0aEhxNjcrbmNRZ1VNNy81L1p1UmlOZThDWUpNbVMr?=
 =?utf-8?B?YXN5Z2dvUkZwYzRHT0txbkl4QUNGb3A1ODFpMHpSRkJNS0JsYXI1Z1Bza0px?=
 =?utf-8?B?SUxzTGJnTnJ2MTFKT1ZjWFFTMVVZR2VYR0tlWU1Ka1NmSzN3cmhNbEdEZkNj?=
 =?utf-8?B?MVp3TWZiejFQdFR3VGZMQ2pOZEVXUHg3bmpMNHhlYlRtUlJtTVBRWFVpT29v?=
 =?utf-8?B?cVZoYktxZUtxSmxoNUx4NUZORnI3THBGQ0NrWW5qTzVnRHRYMUtHNFhRWmtV?=
 =?utf-8?Q?w+4hWRkQ2pcAwI0hfj/z754RsdqByEm3lxtkQZf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea9e5492-e04e-4925-1f38-08d915799153
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 19:10:12.5564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rg3CJdBpy5lMDXlW2AIMKa5ZqFLKnOJF67FKf4ERwmkU4WVugYQlLxGIH+DB8cOyd+ucL7YEahNy66SSNBZMRaDLCdjJcYPbPNVd26XM9GE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4638
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120121
X-Proofpoint-ORIG-GUID: 5VI4sv4_qguLncmCwW93qSrqg2P4Pfvl
X-Proofpoint-GUID: 5VI4sv4_qguLncmCwW93qSrqg2P4Pfvl
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105120122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/12/21 1:33 PM, Lee Duncan wrote:
> I can't remember if I replied to this already (what memory?), so just in
> case:
> 
You had 2 review comments I'm handling:

1. I was setting ep multiple times in one function, so I'm cleaning that up.

2. I re-arranged the code in iscsi_if_transport_conn so it's clear why I
separated the 2 types of functions (ones that need the ep_mutex and a common
check for if a conn stop is running and ones that don't).

There is also a new one:

3. While re-testing for #2, I found another issue. Most of the bugs I was
handling were what happens if the in-kernel conn stop runs late due to iscsid
being overloaded. Because we do the conn stop in the kernel we can of course
now run a lot a faster. So we can end up cleaning up from the issue, but then
the kernel fires another event for the same root issue. Because we already
cleaned up from the in-kernel cleanup, we think it's a new issue instead
of just N events for the same root issue.

I'm testing a fix for that still.
