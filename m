Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B13C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 18:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C774364E16
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 18:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbhBJSgq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 13:36:46 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35148 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbhBJSej (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2021 13:34:39 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11AIPJ9K147034;
        Wed, 10 Feb 2021 18:33:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=j7FfLfoGiC7HX3XH5eWwfUWpTiPHVrkLIg96K3U6oJw=;
 b=OewQPh/Tw83CgfYqRUfFLMfB5Ds8uw0qzjHJqfvSRdxahHh4znKRZHB2I+tFW0+574q/
 iIdTkxdfWgNXXzQKbvAWfifrmSUYcTsXCDvD+iwWcdvfd1nY8/WOws23y4plN+AqYf/A
 LYVCpq7eFE2vXkgNjbTJbJBLXFj5Z/I/7IHY4t7pxUJg65+8HiFDkd6nc7rT/3NuOXCX
 UM451UcRTL+7qrSI2r19vanzmPnsvsjzhlSZlR3bidIQ4ZQwW+5HS/fWSoeQaRLj7I9m
 7I2M3/HPOytJNj2LWVjyqq0MBnq7UmUJEC731381is+KfFv/EBT/EYExUjWWPO+0MEy7 yg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36m4upu3up-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 18:33:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11AIQiIG182675;
        Wed, 10 Feb 2021 18:33:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by userp3020.oracle.com with ESMTP id 36j4vt684w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 18:33:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXbgWJu/SzYeYfamlzxIvtByVEJ0BszlMRIaAruCtn7KZewMVZDaTIRPmRyzalKOFBY0oQAyMvnnlvYxCZyx8TTu5HY6IFxsavIKZjXl9DSEprenns5lXuxAatN/cwn7jYz8aqqP1FKzUZlx3pjLfhmTiRQaBldES+NFv874GNm0ko0pAKLQc96iyrpKrP9x2uh5i3fYYDB0+Q1Qqe4drNxLUBN0POxn08DHnDhwrSJBRsjiy1Szxx7EnQWW9RtFb+6XodO3gL1Ne/l3YHuOvffkZlxILzQTxV9K4Z7FA7g48ewubUWoU59J50RazzFXe3h27cceLxyH4foyi6B4mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j7FfLfoGiC7HX3XH5eWwfUWpTiPHVrkLIg96K3U6oJw=;
 b=AnxSI0UNkrXyg4ytN80Hh+UedmrRPc5amcae+2GZ+g/f+NuqS38yZ7dkgZ24UZrR/LdJL5SW5Hz7j5BrUhj04+1nWD2WXBqomkTigYKI8zBq4w8hs/0ncjRVICuHEiabD2+13IJJWfFvj+kpmO5TjxyTH04Pa7Kqs0DanLy+8nI4Fy5NOlIhJHPXajUCyCq57ar3KzHo+Pg4M5ITHU0M9XVaaeLWLr1tChLzoly/KINvc4D/9aIhSqGGRPLlxuSdGhaCLEXxVjeEu09RXDcEGkaLZ6qQqWsyWE6TuXzSWjHmoMDA6zpvx0Cm9LhIZVhLoxDQTNCleiGS4lIIFVfAHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j7FfLfoGiC7HX3XH5eWwfUWpTiPHVrkLIg96K3U6oJw=;
 b=wJlhnNFMMPabkxEJuZdraTi4lGwbEFXod1P0d4esKaujQks0rOzp3xCJKn6uOhNQpJw+/Tcqt8o65vD4q7teXhHz0T8r8x/iWRapZQnFv4W7NrKNsvWNfT4xzGAnzgGIAEp8tp9a90VHI+ILHk7Y6gnCwbavLVei8W3KZUSmTiM=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (20.179.63.32) by
 SJ0PR10MB4589.namprd10.prod.outlook.com (20.182.112.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.20; Wed, 10 Feb 2021 18:33:37 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 18:33:37 +0000
Subject: Re: [PATCH 11/13] target: replace work per cmd in completion path
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <20210209123845.4856-1-michael.christie@oracle.com>
 <20210209123845.4856-12-michael.christie@oracle.com>
 <20210210084241.GE2045726@infradead.org>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <b5e150b3-3fa0-ab37-1b45-cd4bafce7e9c@oracle.com>
Date:   Wed, 10 Feb 2021 12:33:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210210084241.GE2045726@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR03CA0217.namprd03.prod.outlook.com
 (2603:10b6:610:e7::12) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by CH0PR03CA0217.namprd03.prod.outlook.com (2603:10b6:610:e7::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 18:33:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62cf8799-9e51-4c18-5f24-08d8cdf26143
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4589:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB45897BC4FCE60D6EC75A5F6EF18D9@SJ0PR10MB4589.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SymgM0hPsoyRtc/akhxEx6NhYapM+OlkI2Hpw9vBR11rbgogMYNuzJJShff5UXGcyVcE/8SaaFaMTx2N7rpudxVCPiQKZ1E/p3R+pWTMmJajq4LcxzSs/Y6YPB3x39eyNT3VdJleDiHFm1kM48Cm/M5aWDAJfo+/GSUm3nF0+MOU4WV9Fbd0RoEGdMUNNzYMxDd0X+9yamJbsOyGYSFCq3YecpAdcRReMHrt1T+OMpOs1tx3C2eDXv1vbyh3sYy6VfvChQE3fBLejdtx2kkhasO1EYW45pL5PQONIFPA9ZAoJ+scgzSYrOnCc6vKL2ho9B69GwwtJKg7Q/cKcW6MkUHN1cbfnPUPFx+FC5DGKsNH61K3ZBxHwvg5uEptV5Zur/y/jQXXMiqeBh8wvdtgqNax3gHmOQjw7PB6NMJg4bOs8wqWBfqtVUX/gPPpDlF6BmC2+feU4ugQGPo7OL1KtsyhUuYUYwamUJOs+XvxBEqqnRAysKiGkL8hS3FroS7z383SOThUaZ4jkYCjoijheW96z+Le1zTUPhmrJVihnsfBfv3Np2L3Yb8aU5RRvH5JjC9oqJl32kJy/1mwMnjTw9ULMTJTF5ra7KhLY/FHP4YIno/DriUtJqh6gu3kLd6e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(39860400002)(376002)(346002)(86362001)(26005)(478600001)(5660300002)(2616005)(956004)(186003)(36756003)(16526019)(31696002)(6916009)(6706004)(8936002)(6486002)(16576012)(66946007)(316002)(66556008)(66476007)(31686004)(53546011)(8676002)(2906002)(4326008)(83380400001)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NVN4dHpDZ29oc00rZE1FcGtmS290N0lGdys1YWxqSy93K01UdFFaejBMOGJ6?=
 =?utf-8?B?TFRzcGxuSi9nZUYvNzhxY0ZZNXUvSFVBVHZwUitXU3Q5YWI3Znp6RkhsUWVZ?=
 =?utf-8?B?amR2c2xDR1ZZeWcyTFB3RktkN3I3K050YTNVZUsxQW1kcVcwOXlvYTZGUmZm?=
 =?utf-8?B?NE4xQld2aVNsRWVPalFGWnE4YUhDRGJtS2hsK0FGelJwTGl1VE9JZW9VbTVr?=
 =?utf-8?B?YWhpY0dobW9WM09jcmlwSU9Zc2d2Wk9YYU9RS1YvQlV6Q3BtbGNUNEJpQUtI?=
 =?utf-8?B?Mm5UZzdjcHNWSXpuNGt3UXdLWU5JK2JSbXBQaWFyN2sycSt1SmovZ0g1QWtJ?=
 =?utf-8?B?ejkzR1EyRGJRTk1aWnh6K29mbEdhYWhWRnZYTlRmRThaak4xMmlZRTFmcmhn?=
 =?utf-8?B?cit3Q1l2dks5a2ZqSlJvQlFvSDJXRmdUdjc0Y0x2MHJxZVoyS2NIbXpuVEg4?=
 =?utf-8?B?blFoWDVkUWp6OGJLMWVaWDNEWVQ0cU9xbk41cUw1czJhaW1RNmxTWkQycGMy?=
 =?utf-8?B?OGsyRDY4cGFxZWtDMFptOUMxaTZVL1JKOHR1dnp5TnlETWlzcCthenh6WDQx?=
 =?utf-8?B?NmtwVUszMk94ODNwZ3djOWpuRFFZeVY0RHNCT1F2M000Z1Z0ZzhoSERWZHNP?=
 =?utf-8?B?VzZkaVhwK2ZsR1lPdEJSdUVlVHdnSk4wdTFBaU0rRkpQZTY5Y1gyd3M5T05m?=
 =?utf-8?B?Ny84d2VLdklBT2E5ZkZxenFzVXl2Ylo4VWgyTXB2dGxTTG9weUJzb2VDaDd0?=
 =?utf-8?B?V3JRTGM2Nm9wM25EbWhpRTZvZ3JQYVhSM2lxWUxCYnl5N1hNT1RaT1ZTMmx6?=
 =?utf-8?B?WUJoU09sRG1aQWtQbkk2WDRFc0YvNnE4YXNnNlNTZGhMTEh3TjFSK2F5SXB1?=
 =?utf-8?B?UzNRaUZ2WUlYTlFMb2xWSkhMWVBTOEUzVkFwQUJLdnp6c05YcFg4cTE1K0ZV?=
 =?utf-8?B?ZFJJbEtRRE9VY1pGd01mbnQ0VVh6Q21ndXAvR2RwaTErYzNUSUQ0RG5mazdt?=
 =?utf-8?B?YWVzLzZRYkNFWUt3a3ZnWGt3WnRrZXlDd0tveDdlajVYN2JBSnlpMGRONnNh?=
 =?utf-8?B?VEt1SHpobVBtb1lDZkFJcGI0Wm5OUENXV3J6VXBzdGs2Z3JpVDZZUHNwN1Vh?=
 =?utf-8?B?QzNMYzhyc2dCVUowU09rZ3hFTGQ2bG5rWHZuVjhqbDBCSTF1d3JQMkZsZCta?=
 =?utf-8?B?OUZIY1hPVGQzMFpZZlpwakZYWnI5U0N0MlFZZXpTRVhiSUhrdXpONzFQVjcw?=
 =?utf-8?B?aUZsNTFjcDBrTDhCQjByS1Fhb0Z6RTFjcVk2cXc0cnNnZlBOQXhpdUlOSFJD?=
 =?utf-8?B?SlVmU21wb3pQVG15SDVQY3JuUWxUMGhTbnNOUnJtankySko3ZUs2K1ZleE52?=
 =?utf-8?B?Ym4wOWs1dk9RSVp2ZVU0QXBNUWdRRjJMRGhRWkUyTGhMOWg1VHRkcmlWNXhL?=
 =?utf-8?B?d0pQOHdSSzhUMi90NU1sZ0FqZGFaYTRUYk5TZlQyVlMxSGVrZkNybTFkdkZR?=
 =?utf-8?B?bncyZHkrRnIra21OejBtdGRKbWtSL2ZVOC90WU04VElIV3JvUVBPS3F3OXpj?=
 =?utf-8?B?WDUrVzZ3TW14R0hzZ1VsQUZTWUhXUjFKVjFSYzAvOEdDNUkvWXdBcjBRTmxS?=
 =?utf-8?B?VGRjTTlBMU90ZFI0ZjVPQ1RyQUV3dXp2aW8rY0JhNytvYWJidytLZzRTYUN2?=
 =?utf-8?B?WnZHTnlzUG45L00yVkVGTmhXUkhwRmdyWkpKdXRPTEtSUG5Jb1BqcUpDS1BV?=
 =?utf-8?Q?djCjD4jFAzy9aN2OVL8h7mvX40tQdptXFpD9JrD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62cf8799-9e51-4c18-5f24-08d8cdf26143
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 18:33:37.3998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3BhbYC67jLlQ1CE59LhiDpFlJxbJcGhGk2s5O8I4NYl5I6fiLsrms3p8hImm6wKADta4feffq9HcXr2zYxjtrG2fY9x1xWV9klnrofLo5Lo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4589
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100167
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1011
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100167
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/10/21 2:42 AM, Christoph Hellwig wrote:
> On Tue, Feb 09, 2021 at 06:38:43AM -0600, Mike Christie wrote:
>> Doing a work per cmd can lead to lots of threads being created.
>> This patch just replaces the completion work per cmd with a per cpu
>> list. Combined with the first patches this allows tcm loop on top of
>> initiators like iser to go from around 700K IOPs to 1000K and reduces
>> the number of threads that get created when the system is under heavy
>> load and hitting the initiator drivers tagging limits.
> 
> OTOH it does increase completion latency, which might be the preference
> for some workloads.  Do we need a tunable here?
> 

I didn't see an increase with higher perf setups like 100G (really 60
somehting) iser/srp and even using ram disks. I think it's because either
way we run one cmd on each cpu at a time, or if we do kick off cmds on
different threads they still run on the same cpu so latency didn't change
overall.

1. Without my patch each cmd has a work struct. target_complete_cmd does
queue_work_on which puts the cmd's work on the worker pool for that cpu.
With faster drivers, workqueue.c does the equivalent of a loop over each
work/cmd running one work on the cpu, that completes, then running the next.

If we get to the point where the workqueue code runs cmds in different threads
on the same cpu, they end up sharing the cpu so latency wasn't changing
(I didn't debug this very much).

I can't tell how much the rescuer thread comes into this though. Maybe it
could come in and run cmds on a different cpu, and that would help.

2. With the patch, we add the cmd to the device's per cpu list, then do
queue_work_on on the list's per cpu work. queue_work_on then either hits
the pending check or we run like #1 but on a per device basis instead of
per cmd.

However,

1. While I was checking this I noticed for commands that set
transport_complete_callback, then I need to do the per cmd work, since
they can be slow. I'll fix this on the next posting.

2. For the latency issue, did you want the cmd to be able to run on any cpu?
I think this won't happen now under normal cases, because the workqueue does
not set WQ_UNBOUND. Did we want a tunable for that?



>> +static void target_queue_cmd_work(struct se_cmd_queue *q, struct se_cmd *se_cmd,
>> +				  int cpu, struct workqueue_struct *wq)
>>  {
>> -	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
>> +	llist_add(&se_cmd->se_cmd_list, &q->cmd_list);
>> +	queue_work_on(cpu, wq, &q->work);
>> +}
> 
> Do we need this helper at all?  Having it open coded in the two callers
> would seem easier to follow to me.

I can do that.

