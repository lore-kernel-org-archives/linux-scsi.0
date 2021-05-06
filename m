Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9DFC433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 16:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 490176101A
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 16:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236044AbhEFQwq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 May 2021 12:52:46 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:37514 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236000AbhEFQwp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2021 12:52:45 -0400
X-Greylist: delayed 55301 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 May 2021 12:52:45 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620319906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZMqJi0Oj+YXjd0hPA8HUsqhgQgM/VXy7dHQLTLUX/vk=;
        b=SzKlxze+S0idqqVBL87EhD5OQ+mQEEGzd4UVqEMCeqijctB5iZ8WArKAe5J/MeSqTAyAWD
        ydRFY2z114fqtNQ06GwYXSw18cJbPIuKaC3dtkZ7Q4UxvRqaqeIKKJ8At56z0wHWuycHcI
        GKQMc6W4CNk5cdIQO08qK33TszO5I1M=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2051.outbound.protection.outlook.com [104.47.13.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-12-SWD9jWZyPgieicR5PcZayw-1; Thu, 06 May 2021 18:51:45 +0200
X-MC-Unique: SWD9jWZyPgieicR5PcZayw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJxPhsinNKOae6+nIkhIBuybwKs3yNjxh8Tzh2zQZCS7+pVAa12Co96P/dOBYV3ZQoCGGof1TsZM1Ci1InQGTiAn6k2AHfBkRqB8SgTBtR69NfpSEHEQC3aszytN66/wr/H38DC3zRaS0k90qnqL1M8+zWhxuh6mMvz80GCvD+fbhh4MJKEgyor3tbc+0QpveRQ3ULcgKCRoA9+kldYaZ8Z8rt1S34a52hIxJtNU3itvxppeT6TF4NnY4nIcqSADF/jA9TEgRg90eURfho7syWm3tMfcukrYpAA7x8cHilyaF7Znd+c4YA2CJO0gzsYL4IOpiCVO18SFgp7+YLLlNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZMqJi0Oj+YXjd0hPA8HUsqhgQgM/VXy7dHQLTLUX/vk=;
 b=X8fAj1CBDBjpTUzv9aHO6fj6MhDwpXQ10SwSQpLVJROkV1GUoee7er1ZEQUDrlGX5MhdEgG6YS9cQNcx3SFnAn5yxOw9R6+BE06q9ny8whZwEEeHPaAAMMvc8F0VofeqmbXOqw0uO2erMNe1U7yB7oXiuFD2J1Eo8pD54BCfLx7NStWp8Pp16fNJqPkpGohTudDKF8UNs6p3o0Uq9W49OTTpXDzGi2iQ62X+VNMfqq5woKmHYfV3jP2EveN6azRsj5NtTqd85drc+Afi4RDRko2dPPKeicPjY3pwwgNQefB6e4NdYN2T+Tkyu3LCA/+6AP9ZUKa5rbwhnf65qpr8bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB6469.eurprd04.prod.outlook.com (2603:10a6:20b:f6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Thu, 6 May
 2021 16:51:44 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.4108.026; Thu, 6 May 2021
 16:51:44 +0000
Subject: Re: [PATCH 004/117] libiscsi: Use the host_status enum
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420000845.25873-5-bvanassche@acm.org>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <e7936b07-a402-f85a-1e5e-a83d1c66fa18@suse.com>
Date:   Thu, 6 May 2021 09:51:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210420000845.25873-5-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: PR3P189CA0001.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:52::6) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by PR3P189CA0001.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:52::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Thu, 6 May 2021 16:51:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cce9c5b8-473d-49fc-c52c-08d910af3ab7
X-MS-TrafficTypeDiagnostic: AM6PR04MB6469:
X-Microsoft-Antispam-PRVS: <AM6PR04MB64698099157C202626122DDDDA589@AM6PR04MB6469.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:161;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vIFS1MO4Bm1jcLbYloNjF1fcJ8gQLqHRisCzTiIPbuzH44DXHwU7ZtwKXXT8OKxfAm+ik5C6QY9oNwEwr2A8W8TRydWSVGIg2Cq15a7mYQ8qR5Mvzfpr4rrE+XrMOoGlDBN24Oq4XsNzD/vVJIwyIzWZuhaysKf12mlT34RK2xFtskpm+I2SGW+L2PQGVGMEobOYwEaTGBv4G13S/RYRuNHQcPjpIcKKsi4XY+CY0bnC7YV0ETQdbGi6ZBvwLZdJFR6zTe970/s6RO1PnwhXFUHaku5vFqiu/BbqKr0AOXiuhJ9EgbgwKZmZ0i8yCH4KfANFJdTGoDbGTPiW2ZAazBtiqCzDvqJIwqVqffNULS0fzmtFPg2/0XC+zrypQ3v5nkzA+Y2lBygf99BdO8nqH9ba81HPsoYkEKInCnJodjp3/8/R1abtI8UGRntSbxVDdWxyUhXaxLlkCYynOxulNyyr+zQeL4hFy6Fw7OZGc4k8cxtbHvBLfkBdfRHS7vpFPngqYo0rwc4nCuNHsoi4733qAhWhhqopXmROE7sEQVks0Uuf8c9JAy16WjrYhhE4BFSd9J+hGDoeo7x3C4GGpVJODtn3bzPSoDrG99G6TLoKi+bvp/lBQSuTbYH+1Y8eXP4sL5+sr3WVv8K6cWRKRfipTVVckfcVZMgDIh/GB5Lt4xEBGNQKKK74emAP0g9HJzQtQaxEbepv9NyIrIjsbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(396003)(376002)(346002)(366004)(136003)(83380400001)(38100700002)(6486002)(478600001)(31686004)(2616005)(53546011)(110136005)(66476007)(66556008)(316002)(31696002)(36756003)(186003)(38350700002)(956004)(16526019)(6666004)(66946007)(86362001)(5660300002)(8936002)(16576012)(2906002)(4326008)(8676002)(26005)(52116002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SXFHUnp0dWU0Ym51aEhYT3EzUHRWVnNGSmMvdkthRmNnU0Rrc3dWN2FQd3BW?=
 =?utf-8?B?c002TnJ4R051aU4ycXpMN2tZMzBxVnlSVW1JSmNNMGw1TGZrZFhqWXR4YUQ5?=
 =?utf-8?B?WXBNWGtJVkgxbkltTG5pKzhVd0lyQmxhamE4cHNNNkN6cDQ4NHZPR3JCSExo?=
 =?utf-8?B?NkgwYS9PNXNKcXhXdzhvcTQzRHlqaitpU3dqalZvdUwycGxhNlZ1YVY1NER0?=
 =?utf-8?B?QzROVHAxUkV6UFlmZUFXSkxiLy9JU1UzTERVWm90c1VXZW1mMXk3eEttTHVj?=
 =?utf-8?B?a2tRcEwwVGZGczlaYi91bUh4NEE0dXp5MVJRZUdnUGtzLzBHcU1jRVE4N0xh?=
 =?utf-8?B?SzVkUVpXcC95NDVFbUIyRWphUHNrZWZzM2lwRTdkbDhORUFaT203c0RMbWI4?=
 =?utf-8?B?L0NkRGkzVWRMT1lSTFozUTlHMS9paVZvNnlyN1JjcnA5cTlScnhVNk9XMUtK?=
 =?utf-8?B?ZHZ0cGw0NlJlN0YyUmRlblVQR0xxM3lwTWdGSUMxQnR2MFh1VXlWdEVaMFFJ?=
 =?utf-8?B?c29mSU55NG5GUys5czJZOGNhR3phN0lhdTZLU0ZqYisvcWhsZlhFTG9sWjV3?=
 =?utf-8?B?NGh1UDlVSkN0V3NBTkdJU1plZ2dTNHRpZWJUd3VFNXdhcG9xdjhlVWRNZ011?=
 =?utf-8?B?UzJHcnIyUnVNOEQyam13bFA2NFdFSE5tRGJPYlp5U1hzYlVWMCtrbWhvY01u?=
 =?utf-8?B?TFpVWkZqamNDdWdpZU41TUxvTTNzOGxRblNxRnhaUWE2SDFKbG5WcGxVL0ta?=
 =?utf-8?B?ZUl3N0ZDVUltMDVqaGlNTkwzV0ZGZmQ3eFQxV0VCdFNTZnA2NzNFc2E0UUw3?=
 =?utf-8?B?ekZNZitwT0YvSHBGYkRNUWR4R3RaMGhmaHV4ZnZzL044empDV1hYTENBdzNu?=
 =?utf-8?B?WkNQVU91ZVAxajVWUyt3NHJDL2xhK2FEWjN2SXUzM1lxRDB4YmVkL2o5THFE?=
 =?utf-8?B?Vm9yamNhUXJVR1ludUpwTGZmV1RVcTJyVkhYV2V4Wjk0SjlNL2hQVlpNRVdk?=
 =?utf-8?B?QWV0Tjd3OUZKVVRrTWR6RnN6TktJVW44WGRIdWZ2dDAyRXV1aDBXSVpaOVZX?=
 =?utf-8?B?Vk1takxSalZzdE5pQjliTDJGZVY4QjlFemVyTk9FVUdxQjROcjNzVWVXbTdL?=
 =?utf-8?B?azBJTkgweVBiWm5YMzhZeUI0RFlSUUZWRm8ra29IUEcyR0dzVklScURtS0Qr?=
 =?utf-8?B?RGV2YU5Ca0lsRGdQTnNqdXVDUlBtd1BSTFBKUGJmcmgzd2JlR3hpMkp3UEMw?=
 =?utf-8?B?ME1xd3hrZGh0YkFoTVlQaXlWcEY4UmxHTzVHOFlLUlU1RkYwZjIrcldkTG5X?=
 =?utf-8?B?SGkwU0tiODhnSkt0aWhiT2RSRDk2Q0E4RE1jR1pqNFI4eFp5eDBJUmZFaTJ1?=
 =?utf-8?B?eVg5b1Q2THEwTC9xMHozemlCdXQ0UlpBYVhNWFFoMzBDdzRpem9HZmVjdnVq?=
 =?utf-8?B?b1pzRVd5Y2Z3WGNQQ1NUU2crbENWV01uRkVLekpLdlJ1OVMreHlPZ01CTERG?=
 =?utf-8?B?UkVWTlo1QXphZ1I4SlVKLzN6ZzhMVzBack1uYTB2aXpSRGM5OTM4SC9WZ2ty?=
 =?utf-8?B?cEQxcldUNlBXVkt0M3FJdkluaGVXTE1MQVVtaGVadUdwcllyajRoNDNnVVVa?=
 =?utf-8?B?NFNSMVkwaVBwbkZPSUVXNStzem5pR0V0WURFTExhcG12bkdCdVN2TkkybWJT?=
 =?utf-8?B?TkJPMzBvYUREN1FHVmRNdmVqc1BxNWd1U0c5N25VZG92V211dlkxOWE0Mytl?=
 =?utf-8?Q?1g3XwsqAyj7UCI4rXIsQi25PrhLWES4LPJ6WNFn?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cce9c5b8-473d-49fc-c52c-08d910af3ab7
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 16:51:44.1478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4F4TL/mea+5bX0m2q0L0yO5LeJbjddxJzNuyNVOAvG6Y4qokrKVgJtu/IdByXfmFGlj9TXI3c+XIAKxMfYI3TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6469
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/21 5:06 PM, Bart Van Assche wrote:
> Allow the compiler to verify the type of the last argument passed to
> fail_scsi_task() and fail_scsi_tasks().
> 
> Cc: Lee Duncan <lduncan@suse.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/libiscsi.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 7ad11e42306d..4b8c9b9cf927 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -590,7 +590,7 @@ static bool cleanup_queued_task(struct iscsi_task *task)
>   * session frwd lock must be held and if not called for a task that is still
>   * pending or from the xmit thread, then xmit thread must be suspended
>   */
> -static void fail_scsi_task(struct iscsi_task *task, int err)
> +static void fail_scsi_task(struct iscsi_task *task, enum host_status err)
>  {
>  	struct iscsi_conn *conn = task->conn;
>  	struct scsi_cmnd *sc;
> @@ -1885,7 +1885,8 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
>  /*
>   * Fail commands. session frwd lock held and xmit thread flushed.
>   */
> -static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
> +static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun,
> +			    enum host_status error)
>  {
>  	struct iscsi_session *session = conn->session;
>  	struct iscsi_task *task;
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

