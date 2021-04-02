Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB3DAC433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 15:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93FA160FEF
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 15:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbhDBPJZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Apr 2021 11:09:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50004 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235327AbhDBPJX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Apr 2021 11:09:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 132ExVIX167807;
        Fri, 2 Apr 2021 15:09:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ajUD3ySaok0x7JLeaVbUDqJhe1maCl7vbEnUNMLLxOg=;
 b=ysotftw5oYLoFmJJPPglbFqp8RcejBzezL0fPfwmWTYbyXrgO389xIwXmdkGzGGzoO5p
 MVBEWS0BVDRTOL2t61Ff05JT4wccxgJVJq9Q5buO9qvMvQ3PvoRWzeJANxaOgK9O28FN
 VRw4unCwsnCS3JtRKJlSPpcLofQ25Qkkyn2jZ0Xnl7OF4KqWB44HBcorosUtymttLtO7
 /J1Dkt32MQsWseRBDZuxZYSVu3byb3PISUnkW/o9EVMmslh81UPzNGF2w2OXrOxAgkp3
 8BJIErMgiNTuaziz+ABK3sy6Ib/Ki4lX7jg3DU8C6MtnZmKV0u8ZshJlOKTrE6El4xyu vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37n30scuwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 15:09:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 132F11G3160114;
        Fri, 2 Apr 2021 15:09:19 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3020.oracle.com with ESMTP id 37n2acj55h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 15:09:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HrCV6dxKquW3L3BCGzipivvWjgqOVDsX5Si2iQV5QUH8nVQsKaH47z1eVMSt+kXOg0eELKCTX+Ji861S/jdyrZ8nXVZ3GWFaieWa8xYYbkCNN0UKqC2bS0Na8Rp7rD7KYe1SE2lbIxNcXI1XglJ/fq/WFSc81z2/M+Ns/gJqyviIKUYeB7EOhJXKeZW2DXecIANbqKMl2dE+oo9YG+rAEe3IK+QA+KwBC8OTu9FxaH9ZULBntKhrdXMWGmiPIa/wJeCgsZzZXGvHtq3+GduTCqhtD7dIuwo4XV4l/eRYd6Q32pbOgiq4sw5t7Z+ImHky4OnWTLHZd0o7pzFeJb9bng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ajUD3ySaok0x7JLeaVbUDqJhe1maCl7vbEnUNMLLxOg=;
 b=jVXhTWFTYP8cpOVH2MWRT85CSV7jq7yEDh63GLVZNAoq3eRDI90hcFJBjLWydFLslkefgGBtb7pmr1BieQzg9UZaqDS6mu/QZvJMUyskv2Y7gzOSiEm89wOVW21WkdzjUbV6QfhxlJCV63+yavWgHJK00VDQFxo4GBQCF74mauuFCI9QXreL3KGbMMtwovN3xPYlPXlF5SWTTqepJ1iFYNu9HhdrEz4b8dUw+7mhGIiEHJNgRX9EgANioRhrN3zsYEBBAnATfJjoi7cSzh9OygzzU7LPv1aq0tPEZBzvv+/mIDD+QRubx9gKXbsPegO6fEDQ8g0t54ansCZquuNEgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ajUD3ySaok0x7JLeaVbUDqJhe1maCl7vbEnUNMLLxOg=;
 b=XuBcge9ENiT0nbxkjGhVGdtiAKUHT2/+FXpsPQcE71Lg76DYpSPxcwTRn+Ud6lB/ENuIhxQGFwSSVzDkTrW51ZgT0ALMbpGOLxzLmwWCNmAuQgc4GDh0U6qPjcjB8BPgqbqTUuVGpOn9u/JuWyCHiEyznNhzom9IPwcpXOi37ls=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3892.namprd10.prod.outlook.com (2603:10b6:a03:1fb::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 2 Apr
 2021 15:09:18 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3977.033; Fri, 2 Apr 2021
 15:09:18 +0000
Subject: Re: [PATCH v2 0/2] target: Introduce dummy devices
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux@yadro.com, linux-scsi@vger.kernel.org
References: <20210322200938.53300-1-k.shelekhin@yadro.com>
From:   michael.christie@oracle.com
Message-ID: <279be44c-cfb0-7ca2-d9a0-a88327e25140@oracle.com>
Date:   Fri, 2 Apr 2021 10:09:15 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <20210322200938.53300-1-k.shelekhin@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR02CA0080.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::21) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.5] (73.88.28.6) by DM6PR02CA0080.namprd02.prod.outlook.com (2603:10b6:5:1f4::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Fri, 2 Apr 2021 15:09:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d64c8e94-1ac9-42a6-db2b-08d8f5e9493b
X-MS-TrafficTypeDiagnostic: BY5PR10MB3892:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3892C593A005B3B9797FA893F17A9@BY5PR10MB3892.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cHuc/4VjZ1G0rRE4TFWyFXjDx1YBFg/51I6XeieO8aAfvV1yEV8rCzEWyINhKYdQhb3kAAM7/3TI1Zcq4NBZQsswmnXGe7URp63M8Py3DZE/1DuC1R5fdBm4UUL4cnhYGRo1U0FK6XC1SEh4rEGrpbWNxcXga/+DnsVuwr4i1xTMWnzhUexem5y8rMiqZcoekfUX60OUdKFhRyVzPYYp4g1Fw3ngxu5E0FvuS77wdfFIXWepguBBd6mu/9g9E9tw9zSxT5WiCfyj6qdZEFcqqwHebF4P2oCp4INlYtM2Zh3NKmMMJaSVjrVogp9AovePObfiGxhClPeFFu2dB9S65PiX1ad73t/NInPgx9HoJW1xMqNu0DDgwRJOfqmuuZVLJCnZ+CzlmXkq0g/DbqaUeyB1083+veSw9MbIwW+ZUT8YLC3wQLvNwBgJIukGluZ3/Qn781IsSSWuZvLodJ+biNCD1ruuOV0ZcSNHCRF6nvO/wNyjuvbiUO61Qg8onrLdXowmh1PSWAfz8VYkpZT919Tks8VQ5uIerHn2oLlnMan80sPdXFkrUcU/htvplX6y4tIrlWVuEaKYkqGLhftQHn7U6aJYRCCC5RCpJfpUn3IGW39I7xbMz/nwCDKfZlNOrIPE3YHW8aGCX5adnPfAsDtB4jtI7J6CHPS1Qkh8mIYekYUDIYYw/Pxgue5SVYwV0t75Z5fAhkUxpRtA8HOfNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(376002)(346002)(39860400002)(36756003)(86362001)(31686004)(8676002)(38100700001)(186003)(110136005)(16526019)(31696002)(6486002)(53546011)(2616005)(956004)(66946007)(16576012)(4326008)(9686003)(66476007)(66556008)(6706004)(5660300002)(83380400001)(2906002)(316002)(8936002)(26005)(478600001)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UWpIdlliUWVsTElGK2xoYXU0WVYvS0tZUXZWN09DZ2Q1OHQwdHpuM3QyTDBN?=
 =?utf-8?B?UjdCOEJVR0lkYTVBQUZIR0xNek9VZUdnUDY5bU9QaDNnQWRpaXdpTGRBZ1dr?=
 =?utf-8?B?UUZHT2JxYXFidXFIUUtqVlcrelZuaVhiSGc1ampFVmxuQlJmTmVtd1FzK0g1?=
 =?utf-8?B?ZW5PZ2I4K0drVDBxaGFMN25MbHFESExwQ2F0TTlpVkJwN1lPclBkdWhETnhU?=
 =?utf-8?B?dWN4a01aekhaTEVTcHkrK2REUVlXZTVPMEtBVlNKZllXWjJqWWoxemF3NUph?=
 =?utf-8?B?TE1nU2JCblp2eEJPMEZIKzcwbFpVR1p0WUJaMVdod1JNb0FMS3FIU1VGMGt4?=
 =?utf-8?B?bzRFZlBLLzhjbWU2cC81b2h1c0xldXhHQXZJdUtVQ2ZIUVZvbm91bFByUHpG?=
 =?utf-8?B?NlREUjRwR0lGSWl1RVBWTlNMbThNZUhDNWoyMmxqdW5CbXd6ZG5UVXMxY2hj?=
 =?utf-8?B?SkxtRTllZXgvUUFIRDY1YlE0OHUza2tJSWNxVkJDNnlHaEZZdmF6QkFNMFFn?=
 =?utf-8?B?aW8rZmhiT3lGbUttb1JsVjE3K2Q0UVZET0VPVEY1blVoWkY3TmVmcEk4N3d3?=
 =?utf-8?B?ZVlzeFRES2J5UGpqTDJGM3cxeDlKMWFDa2ZRa3h3SDFtdjBwRTZ4U01oRWJ0?=
 =?utf-8?B?UDU5T0tpTjNPeXBrOWtmN3lYdGNrUkZqNUhIQnkxb2xEd0RNbFdvK3JPR2hn?=
 =?utf-8?B?RllhSTkxa3dJUytobnlTY3A2d1hjQnFyNDkxWWsrM3gzYWNiWVJhUXRrUHlO?=
 =?utf-8?B?a0xZeDd0QTFmeE56OGJ3ZE1EZ29URGJxNXhHV2hLWlpGSGVzd3pSRE1nZGJm?=
 =?utf-8?B?SFRYMnpoVjBid2NVM2tsUFg4bmQvc2h0MVN1Z1RnNGNuREVVSXV5S3htMnFH?=
 =?utf-8?B?STNxVDN4TThlM09ETE5vZW4zb1hlb1ZMUnVLQzdtQU95WUNrQ2F5ZXlFQndS?=
 =?utf-8?B?bVJjZUxVVU1rRGVXaXVNTC95SGVPNUxLQTBSQ3dXWDdjb0kyeVBwQmF3d3BR?=
 =?utf-8?B?L2dBVGMwNlFrVFpDekQ1eW1EQU92RU04ZDFXbENKejRVODVVSzFRU1l1QXdT?=
 =?utf-8?B?UDVoNFh4a1dVNGZMTWd5eGIzcEM1dEJYR2c4cWZHeVZ2Z2RDSjNyWThuQ2cy?=
 =?utf-8?B?VVFiMkg0RjdmWHJnQjB1SFVaNGt2QTA1OEZsQ2hicnFtdXp6QTJJa0U2N3dk?=
 =?utf-8?B?T3lkOGVLZk4vR1dTY3d2eGN6SVg1bHgvYVcvWGQ0bWVuRUZGWURLQTA1Zkk4?=
 =?utf-8?B?U3ZqZkRadDlqWDZsbmJWRXRpMk9vTUt2VzFLblFmSmd5RlJLb29qU2M3K2NK?=
 =?utf-8?B?djI2RHBuL3JmSnlaclFVTXN2K25DS2FYVUZxU3M1NmJUUFlBWm1ab3BVMEJ6?=
 =?utf-8?B?eEtNekxxSGdrYU9UNFozQ28yd2dha1VLVHhUVXQyaTVuU0FjOGRwcTR3RWNm?=
 =?utf-8?B?VWQ3c1FBZzh3Um0zWFJFWnlOandQank4S3B1WVJwVVcrVVR4WXNuVmRFQ2ph?=
 =?utf-8?B?MWVXWFlNSmxKQzZIOTVGWXByV0dCTk1VSGIrWHJmaTM3bFlsL0N3V0I3OWJG?=
 =?utf-8?B?ekVwNTQvNDQxeGtKcGtHMjI2bGVtT2hlTGs4OHNyTkJ2ZjJJTzBsNXF0NmNr?=
 =?utf-8?B?ZlV3Q0FYSVZzRFlRaURGSnU5bEZuY0JuVnBsVkN1ZDhTSzlVMXI2OWE1Wjk1?=
 =?utf-8?B?ZU11ZHFFRjdpSTNvbG5FMzhuUzVrU1pmcUJMOFVEQmx1RGNETFloUzlVNUpB?=
 =?utf-8?Q?TbllYgQ+sujJG7pzmMyReGaU2ynUfTyDOEMd9l3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d64c8e94-1ac9-42a6-db2b-08d8f5e9493b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 15:09:17.9878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pCff1zkVpa93xqY7CD8FG2yIr098HBXgt2PL5r1Ees5V1s9tmVceBceRYuQc48n2b5QD+2Fuloq18wGuM63mRFMISA+wxZyPBpAg/XVG6bg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3892
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9942 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020110
X-Proofpoint-GUID: 50kwKB9pJjIzOCGEv61kh4dY2uclBrAe
X-Proofpoint-ORIG-GUID: 50kwKB9pJjIzOCGEv61kh4dY2uclBrAe
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9942 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 spamscore=0
 clxscore=1015 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020110
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/22/21 3:09 PM, Konstantin Shelekhin wrote:
> This patch series (inspired by SCST) adds support for the dummy devices
> via the new DUMMY flag of rd_mcp. The rationale behind the change is to
> give a user the ability to create conifgurable devices for LUN 0 with
> custom WWN values (like vendor, product or revision) as some tools like
> QConvergeGUI use LUN 0 to identify the whole storage.
> 
> The advantage over simply creating a NULLIO rd_mcp device is that the
> DUMMY device will not be seen as a block device, hence less confusion
> for the system administrator.
> 
> Konstantin Shelekhin (2):
>   target: Add the DUMMY flag to rd_mcp
>   target: Make the virtual LUN 0 device dummy
> 
>  drivers/target/target_core_device.c |  2 +-
>  drivers/target/target_core_rd.c     | 27 +++++++++++++++++++++++----
>  drivers/target/target_core_rd.h     |  1 +
>  drivers/target/target_core_spc.c    |  6 +-----
>  4 files changed, 26 insertions(+), 10 deletions(-)
> 

Patches look ok and tested ok for me.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
