Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F25C4C433ED
	for <linux-scsi@archiver.kernel.org>; Wed,  5 May 2021 03:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4BE2613D6
	for <linux-scsi@archiver.kernel.org>; Wed,  5 May 2021 03:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhEEDDm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 23:03:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59478 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbhEEDDm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 May 2021 23:03:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1452xx6x012299;
        Wed, 5 May 2021 03:02:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=4rxgjWVF9vN34NFEQZYP8Mxelx6YE9CDFrlC0+U8HEE=;
 b=YYstrsaspJ9IhKNKIYXxYMbKnYv+TyU1ZtKjYcnKyrstjLjw9YN0hE+scY7OXtrjfQQf
 GcdZLyggsWdSFS3HdKJGZLj+3q2OOykaNMMaOnVE/tXYsGbbmSd9+4cJkKlveJzI2QGu
 grxVc/9FwDgoYFfD8rjKjE5dCOkN/N6PmY0qoNnIBQVV/hvuKKjTNY+0WkLspXn0ejPq
 mMb4DZpmyTdaXgT2sUPwWosFLnrqb7BTk5W1HhHSMVDmZ/UIoL6OFBDCBh5uqWZR25ff
 nbkI/V8YO4H+G0nwh7SpVRlSaRidxZ6MX9T1gJXvP0bUikuAQtEkZnlPmSF5xqSXbTSr Bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38beetgava-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 May 2021 03:02:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14530El3050353;
        Wed, 5 May 2021 03:02:38 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3020.oracle.com with ESMTP id 38bebh95ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 May 2021 03:02:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QvAfOfafKL76oBg/kSdR/0Z01PXXDONA+hADiMn9gXj//TEOWJw5BEtQtiGljvr9GHp/yAGFsxTKTcrCxCNV+/3TizxwGCcABLSnd/xb0mac7xPsH7S+bAfCgZp6IauwxwMCM/E+tGiUubL2cDIGMCjj0vEXY5MsaIVJI1JHXOFbdjzJuBrUWfzt9rLmeMc7XusWUWwXUxSZ7dug8EkM4OvEmSxdbzqFPkQiJFP53p0d0wzXQZxxG7csBex+YK5KjLVKWE7TjL+qkZ39ieHwSJhIvvqCCmAXS4qYouruF2FiMRuVYh9XVuEvr0/T2PpkJgCB3nVEuokOhM+sdL1wSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4rxgjWVF9vN34NFEQZYP8Mxelx6YE9CDFrlC0+U8HEE=;
 b=JWEt+ASsxEp5nROVIFrXQbr8nxpFSZirFVUqCHb2/eDWGLSrfxwk3MZXy5eYuIPejC2u9ujXbTXyGGlkjJZCM6YpXmLn3h0HuJjyp2UTe9U686imcpdoO051Z4pieSiVdAqZY/HTYxY/ZOBFRbIeWGajNrqyS03K5yMUOX5CQy0ueyzuWpzCsmbZ1ZSJVlvg6Iskl4g1GNrVsS7Uff47PRhdqOzD+F7pOTxEDkJ9J8yzcpW9sOczFZnVSjvEOVDZVSyIKH/JI6AmO+aZavPV3LOp9TlyECcUiZ3xJQqX0Wg2G5CSooL52rmqXMrd5sasUZv+JQ7j3NlzpEyACstqCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4rxgjWVF9vN34NFEQZYP8Mxelx6YE9CDFrlC0+U8HEE=;
 b=NpyX5jnZ7/L5TeLFtpj0+fdyp96VHv9UtiID7TorfskIM6sEfLOsB7DN1dj6VHnKd4xhAUrzUQkeVGQG9C6k89vNTuO8jhRhpuIyZGcXWHOpSpPqjvUr+bsHTlS15kd+ECCnTiLapOSXbu3wL3STMIC87pY8P4RGuzBKcjzxEo0=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3576.namprd10.prod.outlook.com (2603:10b6:a03:125::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.26; Wed, 5 May
 2021 03:02:36 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4087.044; Wed, 5 May 2021
 03:02:36 +0000
Subject: Re: [PATCH v4 00/17] libiscsi and qedi TMF fixes
From:   michael.christie@oracle.com
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20210424220603.123703-1-michael.christie@oracle.com>
Message-ID: <2460ea87-be0c-2a99-c445-142218645dff@oracle.com>
Date:   Tue, 4 May 2021 22:02:32 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <20210424220603.123703-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0282.namprd03.prod.outlook.com
 (2603:10b6:5:3ad::17) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.5] (73.88.28.6) by DS7PR03CA0282.namprd03.prod.outlook.com (2603:10b6:5:3ad::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.31 via Frontend Transport; Wed, 5 May 2021 03:02:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c8a6619-5358-41d0-397d-08d90f723bce
X-MS-TrafficTypeDiagnostic: BYAPR10MB3576:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3576E5C9A3042CCCDDC9A19CF1599@BYAPR10MB3576.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2d3L0UHq2vzvaGCi/SKvtGo02XKWaUJofEZ9GEK5uTEjeb5nfGCAAnPPTbJOM/nhH4jAmagZNSHv7S1HLGYoQCIe1ADSMshHRsJ1KLyfN3D9tkE5Bz9jHLwrTW6uPtYnanH3FXVTnZbQtrvnMH1D2nFTPOnqlPHJjECZlvMdoFdThukvpM89pNPpdsExCLMNfIpmOwONOSwakH2oJT/WLAiMyDBVdTDSXGcRxOiKXPN7nuZJol9Hv00WbXn842eTOGfgLYOvha8wLh6zIgV3tRcmnqHurXcvyoj4rHplTpsM2UElW7LGI8gorBaIFKxG8GyMPzajU0PkXhzWz7jFennVbh74yNsV05+vcNSwv/ddbKQEE7uTrzDNDPR49MUtK2NI8N2w+h3/Lx2WWZIvyfFUu5W+bintdzoQdBJuGqxbpGeN5IifF6+DvLa4fjFw/7xL9gNP/qh+9WtNocqWB6ozjoqxQzVPC54xIZ/Udo76ZES4ymj6NR9c8wcQss6saNXcjWjYDMq9E+c+htEMSA5X39TP7vOD4E+Mg/EjXC5aqTc4ZPbyY/efMGhSCESliqLL5I0ixXEQsDNSCXwJcRCDSAfIQS7dIjJrMviNGkjarCjC94XKXHAHjp/u99oJtm1+b55jPi6bGhU/b0Ko50aELJPo8BQykLqVFn0DvlcFjnl7bbsL/UiXiBukpFpD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(39860400002)(396003)(346002)(8936002)(186003)(4744005)(5660300002)(31696002)(16576012)(26005)(478600001)(36756003)(16526019)(6706004)(2616005)(316002)(38100700002)(9686003)(6486002)(66946007)(66476007)(956004)(8676002)(66556008)(2906002)(31686004)(86362001)(53546011)(83380400001)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NVZ2RHg0YnZaQWQyTEZ5OVJQWGN1ek0xZTFuU0xVUWpMb0VRUVRPRkRwZ2d3?=
 =?utf-8?B?bnhTM1FHQXBWNW5sd0NKSmlmZW95R29CZ0VSZEowUXg5blgveElHeUdiUHFJ?=
 =?utf-8?B?Q1Vod1RHbmxPaHpQcUhwUkhvbC8zbjhoTzJrYVcwVmN5b1liRVdoU3dFeFJm?=
 =?utf-8?B?aHFZeVd5Y2RyeHBsenlXOTlUL1dXZXVjdGZOMkVMUUNLWGcwVWMzQ3pNZ3JF?=
 =?utf-8?B?RUpyc1kzQThydWRTc1VIdkpxTzdRWnQ0dm9EaEhKdzdEajdZbzh3UWU1OUxZ?=
 =?utf-8?B?eThxOEZua3NCR0hwQVZzQkNrNVdaQkVhRjlQRjlZUUxUYVhkdjNmUUFETmpX?=
 =?utf-8?B?UjNkNlVnQVJyZUF0Z1FSNVdab3N4L1ZtbTlqOEFGdzFkYS9iMlNmb2ZpTHlO?=
 =?utf-8?B?TkRXbjVwNUgxSXZ5MWx3ZGY5Nlh5cC92WXNBbGlTVUdSdzRrdHZNbENuNm5T?=
 =?utf-8?B?SEhydG5nNTJXSVhDM2puaDR0enNiZE5mNVQ1eVRWWXE2dmgwT1lFd1BZRDQ4?=
 =?utf-8?B?YXYxRDVTR0ZJSzNrcm8zSGdVRGRTM3A3ZWgyd2x1Z29jTUVZUHVUQytPbkxs?=
 =?utf-8?B?T3lyZnZYMEZWZzA1b0J5eE5RU0hJL3VuTTVIeG9ET0c3SzdVL0c3aVdlbkZI?=
 =?utf-8?B?U2s3V3M5eEFKZ1Rham8zVUovQ3VsaklvWWc1ZFpLcUtSZnY0MTFEOEt2RWJt?=
 =?utf-8?B?VEw0RmI5aGgzd1NCMjNFYzZZZHhXY3liMkRoZDFRM0tlWVB0OE9NY3M1MGt6?=
 =?utf-8?B?eThlMnFJakk5ekEwbWk4ckpnbStKb0tsVUpSUUIrV2htaThzZE5TS3g5S2gy?=
 =?utf-8?B?aHNYb0dmRVJCNFRueklFRGtBaHYyTzZKUVpnR25qTy82ekZqbTJJMVZ1T2d0?=
 =?utf-8?B?Zi93VjZQMml5a3VEOXFlUmNpWndLVFBJOTNCTWVnYnFtalBoWGw5Zm9nRkF6?=
 =?utf-8?B?WlI1OUpsZkpWSFViOHR5M3NFQ0h6N3llQnhZSVZ2YzdHc0ZERU4rV0w1UjVi?=
 =?utf-8?B?N0I5SEx1VFFHU1F0cy92Z2R0dEJYeW5wcHB1eTd0cnRVL3BMbVFYTDRwQ2dm?=
 =?utf-8?B?OG1uN3pjaXJMSmdlMEdxUkczeVppeFVFWmZNaUhxeW05d09ZMHJzMWFGU3Ev?=
 =?utf-8?B?dmZXeW1QYkxwcGpBMG1DMFp1Rjl1a2ZHWlVVN0ROd0JhM0RXNFh0UjUxbkdU?=
 =?utf-8?B?VmtML21HQlAwSGFvRTZhZUxYSlUzS3RYYUJIdFYyaDRReEt2bkxxZi9kaTBJ?=
 =?utf-8?B?OGVPZEQ1aWZCdU5LY2hHU1k4RDlSOGtLQUQwV2N3cTQwTXZ1d1pJUjRBRmRG?=
 =?utf-8?B?ZzBJYlZLd1h5MGNBN1JtdjhCMDZQN2pYRU4zMEk5S0FkcVg1NTI5YkRTSWV2?=
 =?utf-8?B?RnFnSUNOY2hoTGtjUUQ1RHh0OXBwaGJGVDVjSDlUZ001QnUvT0NCbktlTWpW?=
 =?utf-8?B?dFlsTEV1U090RlAvb01oRGNOVlhYWVFxc25SYWZPRmRjMUh2cERMcWRORWFU?=
 =?utf-8?B?ZkxFVDd2MUZXVEY5alhvV0pMSkhWZUZiODNoOWpmdmhlTWNFSmlsVFFtQkY3?=
 =?utf-8?B?c0c0VHY1ZUZ3V0RrQ0FCUVdsQ1pZUHZSY0wwelprYU9VRldNc3JjNGV2bVZ1?=
 =?utf-8?B?S21wZWJDdDZNMmlTM09KbVVjaTlBbUxOMVpLSll4MXJJVGlKbVhuN0VtS29o?=
 =?utf-8?B?bVhaMGxERU5uc0VvYlVacVlVTFF3Z2tadmU0OXEvZXl3OHhCeDJ1djRMNXFv?=
 =?utf-8?Q?RsqEMGVlaEuFcgYm2UPUXyTKTOacXn9VlI6Sd3x?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c8a6619-5358-41d0-397d-08d90f723bce
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 03:02:35.8012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IuAnjGefxSORxENicK6O6GfdmmDXn/VKtVpelS00T4EvV2rDmYZOasXdM31+2YWvvWMCfuIvUpBpCFs67930ud5rHEyneO2BdCcI2opdUjE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3576
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9974 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2105050021
X-Proofpoint-GUID: gO7nmswcSqjEs19-9qlHkE4dVt7UuBsn
X-Proofpoint-ORIG-GUID: gO7nmswcSqjEs19-9qlHkE4dVt7UuBsn
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9974 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 lowpriorityscore=0
 mlxscore=0 spamscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/24/21 5:05 PM, Mike Christie wrote:
> The following patches were made over Linus's tree. They apply to any
> of Martin's branches that has this fix: 73603e995a37 ("scsi: iscsi: Fix
> iSCSI cls conn state") that has conflicts with a patch in this set.
> 
> The patches fix TMF bugs in the qedi driver, libiscsi EH issues that are
> common to all offload drivers like qedi and some fixes for cases where
> userspace is not doing an unbind target nl cmd and we are doing TMFs
> during session termination.
> 


Hi Martin,

Please don't merge this patchset. I want to make a change that will make
my other iscsi patchsets easier to merge, and fix a patch so we don't
get multiple error messages for the same problem.

When Lee is done reviewing "[PATCH v3 0/6] iscsi: Fix in kernel conn
failure handling" I'll roll everything up into one patchset.
