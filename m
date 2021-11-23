Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C02EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 21:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240409AbhKWVTu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 16:19:50 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:37948 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239630AbhKWVTt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Nov 2021 16:19:49 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ANL0VuG026050;
        Tue, 23 Nov 2021 21:16:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=V492AM4CVUjp7Z1Q8pC3Rb3DFmn3GcRpjt4JIfDqSmw=;
 b=E6eZwE+5dqKMRnPPyWxFvWPVhCo+xp/wYpKIHmxd9YuOlweMl6qbYZ5LRNpzLu9sKbF7
 dfOE7Ef5hz8VQPOPx/xxbx7oAhAGpJuORdvFgvDVQsoS2y5qs5YV3k9QMnU9KsqJYB7r
 x+9sIIy+PlF2KKY4u0rMl1B0/7cHwBkLg807fBSDVdlh6KGbiWOudMqU/j7loPd0nBlu
 rVrTujhO8JDMGVXOAhr0XEOxl9rtWW8tR3WnyFk8EH1exWgdT//L3Fn9jgsxf0CSshtg
 rXViR8dmR1FtjfcSm+Fc+k0QSUVlQXFuiXH1CGy1McbEzZpr1tddH+8fiy2Pw45Y6h+h 0A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg461m36y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 21:16:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ANLBV6N068533;
        Tue, 23 Nov 2021 21:16:33 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by userp3020.oracle.com with ESMTP id 3ch5tg65jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 21:16:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXMovI6InEuc8KiOp1s1Sy64tG94NTtsK9cZdlHmwZbngYs3fosMypLQgaUiwc8kgkYcsbcPSOZETNdeU1wfmafU22taYICvMOUSVISJLsepK6Xd2M0odAHcWq9L1YnXirn4KjMZaPdup2QgBBKt8bgZ/6sE0bKbav4yo/uNPLuIo6sVZib/GUsAU4xQWlwnTaZkSqi7OyZgfV8HHcmD35KYxBcqa32hVVjoNqWZB1OVgbW+T2c/aafx8H6wd84BG6vbdSZ3VwVqndXQCcHbX7i6aDTGqldohW068wvjg8/j16rxb8X8W1nBN8k5fo79xn3OpnPpxGQ1H8/ohxxF2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V492AM4CVUjp7Z1Q8pC3Rb3DFmn3GcRpjt4JIfDqSmw=;
 b=CT/n8LKA3zgVAP7wM7w513j43u7eJ7+JqSXrFYYvvI9YlOgKfyP0EgvYdckrF/9YJMP5ZNmWWJSW90+WTN4nN9HxJFox7z81NxwFniSUcFPLsuXwW/dICPJ9bohhMbqvNGRZJ1AYPINMxkpDkRVLgoEqSWaEnrWvqWXtGadH/txdcadQNMctquWFXwO7hFxaHfxzr9AaLrA6aUOL/2vE9F7RJ6oBBbVq7xw+7fiG7OEkNqG0dUAAGIK6l5AKO/b6e+I1S4uN9azDKTfA7+1zeb3HlE1QlVrxxYlcA8kP4uktDhK1vjB3jA+2BD67Z+/x6Z3U0+Wb+qC2UT7W5SnFRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V492AM4CVUjp7Z1Q8pC3Rb3DFmn3GcRpjt4JIfDqSmw=;
 b=Mc//oczng2rh7Pse89VEprJQUaEogr5Lg2HYoxgXkV0xVIX5GjYWNzWToLOrqPSd/yMFPkWMDIYz3H2X5tzrIV7K1cLaZZxVsAYdeo9h/YB7koXsCE2yypOhTtEu/CcL+BDZ/c5vpzXQNEYUpsEYOASGQJM3RJYLQKul3FiFRk4=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CY4PR10MB2037.namprd10.prod.outlook.com (2603:10b6:903:125::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Tue, 23 Nov
 2021 21:16:30 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::e4fa:3603:8ecf:a91f]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::e4fa:3603:8ecf:a91f%4]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 21:16:29 +0000
Message-ID: <9c21c019-d6ff-a908-80e5-51b9c765d118@oracle.com>
Date:   Tue, 23 Nov 2021 15:16:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] qedi: Fix cmd_cleanup_cmpl counter mismatch issue.
Content-Language: en-US
To:     Manish Rangankar <mrangankar@marvell.com>,
        martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20211123122115.8599-1-mrangankar@marvell.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20211123122115.8599-1-mrangankar@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR01CA0013.prod.exchangelabs.com (2603:10b6:5:296::18)
 To CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DM6PR01CA0013.prod.exchangelabs.com (2603:10b6:5:296::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Tue, 23 Nov 2021 21:16:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0d4e620-6374-455b-c524-08d9aec68458
X-MS-TrafficTypeDiagnostic: CY4PR10MB2037:
X-Microsoft-Antispam-PRVS: <CY4PR10MB203764263C42FED3E419AF6AF1609@CY4PR10MB2037.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o8FSItu3CdeL8fnwhOmxH5qkJUKB5AjzLrrmjzKnP4s14Xt6WN8eegJWT9V3Wq6CNb6uaZg8vX9O6fQNZm4KkpyA9T7Kh04cxiDJyzLwzGwIpLh5xMjMBAwhQLxw6UWyYmrTup8NMksiIjXFoAN6N9bAQogaTnyTsnXjSIVBcL2uJy5KBYynTjtpPOW61zCOkbR7atxawBRErvkYh4mbrEe3qkgD+5DmwJHRi0V9/nyAOpDVpQ7aFnXrQWH7tMlLG++yH9MbHfz84xZCVMCW5WBVysSoMA9gfOUad9Lqmeq4puDdcKcBRhRrUtxZ7ocuQ7NvBDxlryfd7yZYbGJBisYnDCKlkeJxbotuA5stUDN/jm1ilRrzcji/DWkKhxTkabmEIJhgsZegz0yyCxcC9c9W7M8OFROKc5QNxjluqOtc7PdLMHhWDbsmPghDJLgSlz80cqvSP2gW6+la5SQECGfKYfZELC6qqjknm6WXqjXdTVAu42z3QSFVzC23cXkixTXtvxAKgRPazwm++FTHWDN+z9Q+bIow/B4MeZKCF7MhyHKApH0FnHhxd1pdIn+cBni1oeXMOZNovRckALYh8AHRQSnY1Dol3QfKEUiJvRsKYVsfX1+5ze8WJi2ia6UuG+JKGj2OM/uQOSEqaDYJ1nWbUKzg72ArixkmyxnH3ImRJlhkeKV89eJOeEvniQDN+D8FyK80ebMnfG9VRy+34ui6Q44VyMd4Vfx1asSZPng=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(8676002)(66476007)(66556008)(6486002)(2616005)(8936002)(38100700002)(66946007)(53546011)(86362001)(5660300002)(31696002)(26005)(83380400001)(31686004)(4326008)(186003)(316002)(36756003)(956004)(16576012)(2906002)(6706004)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LzdUR1hqeDVNbXI5Y0t0a1dYNElRb0lsZm9QTVZVOCt6U1pncWpESG1Fcmtz?=
 =?utf-8?B?VVdSTWZObGVBcitSMm1rVHpNTzdSb3VQZXlHd3duSWdNT1pyRlhldGZsYzNk?=
 =?utf-8?B?dWJIQThtRzk2YzRuTGprTERjeDBDRVNzVlpQSVFrU0V6dFN0TzRYU2pBZDYx?=
 =?utf-8?B?K09ONXNlZkgyOVRiRW8xS3o5RkpqUHQvbDNGam9taldySW8yWUhEWkVTdFJl?=
 =?utf-8?B?eE02WlZjYjgyaFpWWEZMV1J3NHdBY3ZUa3U1YkNZL283TnQ0Wm9XSUxFNVhh?=
 =?utf-8?B?Q3dzOENqVVZmU09Bc2t0ME80ZVNvMHhzZFJ5WVdscmp6dXBFN21UdWhlbC9s?=
 =?utf-8?B?VEx5bWtZZzZPU0hUeDRKcTlTaXY1R3RrcDI3M3RtWnlObVZiMjVBQUNDV0Jr?=
 =?utf-8?B?c2F6dnUrZmk2Nk1zQ3h1OCthQlMyS04vYzhVNkd2Uzl1d281dkNVckVwUlJ3?=
 =?utf-8?B?VnpqZFdRVlloQ3ZuL0RrWTEyS2R0TGJROU5pUXFXRmZjVEo4UndDaytFbTJJ?=
 =?utf-8?B?NC9TSmQ1ckloa0FsSnBSNk5EWi9jZjh3NzR0aHhwS2lXQjNnU3FzT1NoVE5K?=
 =?utf-8?B?WjZ3YWxYdTQwRHRSYVpQZTR6b3pwUDdPRzhjd1hIaHhYb0JyUzBYckc4MTFL?=
 =?utf-8?B?aktGdTdTSTBqNllybVVRZ2Jub2pSSCtDZTFrZWdiZExhLzYwUWVqdnF0dFpS?=
 =?utf-8?B?WENKb3BORnRxTmdzYzREVW5tRW51YjkyN2JaakJaeVljTUdJSDBmZDlUeXpW?=
 =?utf-8?B?d3c2TmtYaWd6Y1dmUUJ6ZkVtWTBaN1RseUpxRjlzaERiT2sxc2xFbVRNUlNO?=
 =?utf-8?B?c2tESno4VzdEUHVIT3pmbDNLSVZCV09QWmlVcUZYSXB1U0VrdlZRNFB4YmF6?=
 =?utf-8?B?ZytkTlhvYXBLMG9mNnovQ2I4TlZQNnJRUUNOQ3Y5TXlBVkRlUWp2Y3Q2ZDNC?=
 =?utf-8?B?cnJvTWxROWdpa1gxV2JVNnhnRjBPSTVHRTJQMURPelNFbVh5ZVRscEpuRkE0?=
 =?utf-8?B?aG83Sm1TVitpbkhxbFVwaGFTNXR6SWRTZVViTkFhbjEwcU1ZUUhIeWRzMVoz?=
 =?utf-8?B?RVB6SU9xM0tLd2pDYjVUYk4zaUt0MSt0N3ZDQXJHam9oMWUyRnlMZlpXMlBk?=
 =?utf-8?B?RHFvc3NQS1JFUWF1MzBHWVkzOVNGOGQwOXNSTjRBKzlqM0NTbVM5WDRIQ2J0?=
 =?utf-8?B?NVRJL3QydjZ1djVpVlFDSFpuRnp4cWFzclFpcktDNngwYVRmd0hIQm9XbkMx?=
 =?utf-8?B?T2lDZmFNZlVCMUpLTGF6YWUyWWlra3lxSjAyYW9vcXhBa3p1OFFidjBQRVFJ?=
 =?utf-8?B?SVUrbFhZZ3BPdy9kQzJwSkh3YVZXQ2JoVnhqQU9xdFRlQmpkU1I1bmh1T28y?=
 =?utf-8?B?ODBKZmE1dFcwRE1GNkhvWmVRZmg5ZjRveVplUDI0bkJnRXE5Ny9wbFFhNHhH?=
 =?utf-8?B?NzU1NFJDamt5SklUNlg5anBISUt2eFpKckd4Z2h3Rm9jMHJwRFRLUmJoS0tw?=
 =?utf-8?B?bTUxNGZBKzArMytMOUVjUE5IeE81b1Z1ZVNvaGhBYUwxbm5aQjI2UXpFSEQw?=
 =?utf-8?B?NEdiTnFmbzdpSTRER0QvcXM4aE5MdHU0RGIyVUNGYlZKK2lCRk0wVW5HZW1I?=
 =?utf-8?B?U21QMlpoRStGeS9VOEQ4bFJoeDNpM3dEcXhUR1htYXpNb0Ftbno4emNmMU9V?=
 =?utf-8?B?K0Flazhaai9zRk1KVThwcUQvaGlxK1lOSlN2MC81Q3pTTjVWZGZIOHJiQ09D?=
 =?utf-8?B?Y1U5a0pkTVpvbkZGaXN4M3hyR1BXNXlWdDMwa2ovR0Z0clpzWnpHY3YrYVda?=
 =?utf-8?B?WXBVN1lKYUNNVmRpTkQyNmlNQTRNd1V0N3ZKUG1QS1Mxc0ZOcmRtc0tKR3M2?=
 =?utf-8?B?dEtPREdRVTZ0UnFLUmVyc2ZWZGkxTmQwdGpBN1pLVnhpRlViSG9XV281RjJV?=
 =?utf-8?B?RERLODExVE45SnQ0SFFKQ3ZScG1lbXVvUEx0QlZVWS9JQ2QrMkR2MHJsTm1s?=
 =?utf-8?B?N2JibDd3N3JBNk5YMXlYMmtDRm0yUzBvVVZ1dE5wVUxielNsRXU1UFFsSmNo?=
 =?utf-8?B?QU01MzRvamVnWlQzMXhGcUQ0OWlvc1kxSEt4bkd0RGFMMXNha3NBUHA0TkM2?=
 =?utf-8?B?dTdIWXArdnR3bCtGSlkxeUdNSmJIKzNVSW5BTGlZOHA0WjFrWkxxQXZlWnVs?=
 =?utf-8?B?ZzQ1TEFWTjJhMGJ1M0tJdUtaVDYzLzZuZzdtcDExSm5Pa3hSTnJVbWFzZkp0?=
 =?utf-8?B?eG5SWTFjZUVFbXdBK0lsWEk4TEpnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d4e620-6374-455b-c524-08d9aec68458
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 21:16:29.8312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wzpc+BESm2TQ2T+Rkne2liXiEYPNOcCML13vSowHYzuAdvmGaQI9o1jzz3/0AkjxoP0L4bS9E4+a9IvZd0tXnCuxSZN4O7UxsvqD/aT5390=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB2037
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10177 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111230103
X-Proofpoint-GUID: C6aV0BaLEVikaZx7JKeTkUfetYuR9pMk
X-Proofpoint-ORIG-GUID: C6aV0BaLEVikaZx7JKeTkUfetYuR9pMk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/23/21 6:21 AM, Manish Rangankar wrote:
> When issued LUN reset under heavy i/o, we hit the qedi WARN_ON
> because of a mismatch in firmware i/o cmd cleanup request count
> and i/o cmd cleanup response count received. The mismatch is
> because of the race caused by the postfix increment of
> cmd_cleanup_cmpl.
> 
> [qedi_clearsq:1295]:18: fatal error, need hard reset, cid=0x0
> WARNING: CPU: 48 PID: 110963 at drivers/scsi/qedi/qedi_fw.c:1296 qedi_clearsq+0xa5/0xd0 [qedi]
> CPU: 48 PID: 110963 Comm: kworker/u130:0 Kdump: loaded Tainted: G        W
> Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 04/15/2020
> Workqueue: iscsi_conn_cleanup iscsi_cleanup_conn_work_fn [scsi_transport_iscsi]
> RIP: 0010:qedi_clearsq+0xa5/0xd0 [qedi]
>  RSP: 0018:ffffac2162c7fd98 EFLAGS: 00010246
>  RAX: 0000000000000000 RBX: ffff975213c40ab8 RCX: 0000000000000000
>  RDX: 0000000000000000 RSI: ffff9761bf816858 RDI: ffff9761bf816858
>  RBP: ffff975247018628 R08: 000000000000522c R09: 000000000000005b
>  R10: 0000000000000000 R11: ffffac2162c7fbd8 R12: ffff97522e1b2be8
>  R13: 0000000000000000 R14: ffff97522e1b2800 R15: 0000000000000001
>  FS:  0000000000000000(0000) GS:ffff9761bf800000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007f1a34e3e1a0 CR3: 0000000108bb2000 CR4: 0000000000350ee0
>  Call Trace:
>   qedi_ep_disconnect+0x533/0x550 [qedi]
>   ? iscsi_dbg_trace+0x63/0x80 [scsi_transport_iscsi]
>   ? _cond_resched+0x15/0x30
>   ? iscsi_suspend_queue+0x19/0x40 [libiscsi]
>   iscsi_ep_disconnect+0xb0/0x130 [scsi_transport_iscsi]
>   iscsi_cleanup_conn_work_fn+0x82/0x130 [scsi_transport_iscsi]
>   process_one_work+0x1a7/0x360
>   ? create_worker+0x1a0/0x1a0
>   worker_thread+0x30/0x390
>   ? create_worker+0x1a0/0x1a0
>   kthread+0x116/0x130
>   ? kthread_flush_work_fn+0x10/0x10
>   ret_from_fork+0x22/0x40
>  ---[ end trace 5f1441f59082235c ]---
> 
> Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
> ---
>  drivers/scsi/qedi/qedi_fw.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
> index 84a4204a2cb4..2eed2c6cf424 100644
> --- a/drivers/scsi/qedi/qedi_fw.c
> +++ b/drivers/scsi/qedi/qedi_fw.c
> @@ -813,10 +813,11 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
>  
>  check_cleanup_reqs:
>  	if (qedi_conn->cmd_cleanup_req > 0) {
> -		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
> -			  "Freeing tid=0x%x for cid=0x%x\n",
> -			  cqe->itid, qedi_conn->iscsi_conn_id);
> -		qedi_conn->cmd_cleanup_cmpl++;
> +		++qedi_conn->cmd_cleanup_cmpl;
> +		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
> +			  "Freeing tid=0x%x for cid=0x%x cleanup count=%d\n",
> +			  cqe->itid, qedi_conn->iscsi_conn_id,
> +			  qedi_conn->cmd_cleanup_cmpl);

Is the issue that cmd_cleanup_cmpl's increment is not seen by
qedi_cleanup_all_io's wait_event_interruptible_timeout call when it
wakes up, and your patch fixes this by doing a pre increment?

Does doing a pre increment give you barrier like behavior and is that
why this works? I thought if wake_up ends up waking up the other thread it
does a barrier already, so it's not clear to me how changing to a
pre-increment helps.

Is doing a pre-increment a common way to handle this? It looks like we do a
post increment and wake_up* in other places. However, like in the scsi layer
we do wake_up_process and memory-barriers.txt says that always does a general
barrier, so is that why we can do a post increment there?

Does pre-increment give you barrier like behavior, and is the wake_up call
not waking up the process so we didn't get a barrier from that, and so that's
why this works?


>  		wake_up(&qedi_conn->wait_queue);
>  	} else {
>  		QEDI_ERR(&qedi->dbg_ctx,
> 

