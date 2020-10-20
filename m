Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A5A2C4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 16:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92BF022249
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 16:55:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="MIufYH2B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394983AbgJTQzt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 12:55:49 -0400
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:42509 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389219AbgJTQzs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Oct 2020 12:55:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1603212944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=s6pMjsDifXRifyN/4uZJ3w+lebdAyljxziHuJYcsfBc=;
        b=MIufYH2BfbVQ43bCxBxDLOg8PIRbsePCMg7PjVNs2Ndzo18AaxfrwHwKDdGurWa9jLpN2C
        qU6y0JaJwHhsx9s175Jnv4/cZbhA+XPDW6XnaW9lvtxpy464jZRH2ieDuyn0YZo4r8JHQH
        69f+UGjqg3OHw14iQN6V7TLw2z+PqCE=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2052.outbound.protection.outlook.com [104.47.1.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-7-RP_qwwvqNROJVpMlzD8E7Q-1;
 Tue, 20 Oct 2020 18:55:43 +0200
X-MC-Unique: RP_qwwvqNROJVpMlzD8E7Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUeblDIIqeWrYVuqir5geJSp63r48gZqKi9rkjveyZEaV3cH+yv5doSYRs0jRhTDhdduJ9WceclYweEWbMkTFHpETzKJP/q+UQ1G3BVDC0H+fz9wvZ7rxh2FyAj0JaRghTDr8bWfI6qTzK9EyTXIR9ckHR9bOqPEc2d6xMzhUCUqxX662WKSy6GAfKMPYKdhHgJSOnfG3O05boasAorbg2iBrS+KrBDQDC5Bizbr8++YaHSxzUhCVNL7x9KYUcWWIoGgOIAKg8qP8ndyl5nvMhcM5d8h5sX9xuVzm/uzIyJbQYfV7pVEAkQvKQdQtyIOkQNXz9DPK8yP0102aW6zRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6pMjsDifXRifyN/4uZJ3w+lebdAyljxziHuJYcsfBc=;
 b=Pyh+gtC/i/oEYa+qiXKcj1SbiM6/QqyNTprXRstub+mlRO/zsU2krgxGhZWxgoLFI6wdaLJIJfas+YVUPlI2O6+pd0RPySj7cmVfB68jtA2W1NcKcJbyMSmkkt80s6SAbJqU+VipgzSzkxbEYAZa9P1u9lolZbB2stbWRZGu+VAkZNbb5VsGZkWQA4g1ocVwZQLziEnrJovj53r6ELC9aj+CRDE6mZqGn+VAiyt+mztJhvFynSQ4CuZVzU45JUURfxy9nUk5MWFSmA/eUbCHPrtfc6mG6XAklPFGqp9bmQKhIgJRY6/0uIE+xL8ZUZR1GLr380EsQoYMY40oJkO8Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM5PR04MB3265.eurprd04.prod.outlook.com (2603:10a6:206:3::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Tue, 20 Oct
 2020 16:55:38 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d0f5:2f85:a7f2:2952]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d0f5:2f85:a7f2:2952%7]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 16:55:37 +0000
Subject: Re: [PATCH v2 1/1] scsi: libiscsi: fix NOP race condition
To:     Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com,
        martin.petersen@oracle.com, mchristi@redhat.com, hare@suse.com
References: <cover.1601058301.git.lduncan@suse.com>
 <02b452b2e33d0728091d27d44794934c134a803e.1601058301.git.lduncan@suse.com>
 <5e1fb4eb-dd10-dbad-3da9-e8affc4f5cf0@oracle.com>
 <47eca384-b54e-63cc-0f84-7ed6501f427e@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Autocrypt: addr=lduncan@suse.com; keydata=
 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
 Xd8p+B+giaT8a1b5hWuz85V0
Message-ID: <480f8554-b13a-45b2-98b4-dec4762d093f@suse.com>
Date:   Tue, 20 Oct 2020 09:55:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <47eca384-b54e-63cc-0f84-7ed6501f427e@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM4PR07CA0005.eurprd07.prod.outlook.com
 (2603:10a6:205:1::18) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM4PR07CA0005.eurprd07.prod.outlook.com (2603:10a6:205:1::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.6 via Frontend Transport; Tue, 20 Oct 2020 16:55:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9bf13d1e-0dc1-4c7e-9c2a-08d87518f800
X-MS-TrafficTypeDiagnostic: AM5PR04MB3265:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM5PR04MB3265FA7E722B653DB8621347DA1F0@AM5PR04MB3265.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r0C9DcgX+Mlk8HlDxc8xg/Tc4DenZbL9jm95d5uEEw9awj2He0xY5HUqE6bOwu059rzosMOOTvB0GggpMkzteXB9S38jPhogacN6cpDRZmn9oXYq36B2og+rpZit2CUrqnCDCTeOrArNNmbMbHx0p64qWgjOJjGJgIqKY62+gs9zEQmal619APzvoJ+jJdxpmWQaSDqbENjcCx7ZxyCs7QtQxmVqyKqHyTRn/lmy/eoChqFIxc9UDumWVS6NtzONDp7VgC4/bcNic/qquTWp6n4zvfeYucf0T2D58d9VhOx57pINRZyz97OyPlgl2Ajlip4Gl7/fK6HcYihfGtfD0pY0E0AbRlOy+HX7mLpxxLAzU6LK7grQOJy9Nj3jfixl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(39860400002)(376002)(396003)(478600001)(956004)(2616005)(8936002)(83380400001)(16526019)(186003)(52116002)(26005)(53546011)(2906002)(31696002)(6486002)(86362001)(6666004)(66556008)(66946007)(66476007)(316002)(16576012)(31686004)(36756003)(8676002)(5660300002)(4326008)(107886003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BDqgrVAa+dlBKqTFnIE+ix/2BEByQ6NZcBbZSXEogYE4eHl9OgMCSbXIcM6CIJsswwZCqMIm/zpM5amr2NCNwIcckHtVKYP6T62jgsypoYV1hd/DrScN2CIeTueveO1AWAX08sviN8V5bVLOuY+NEix7Mu6n1p2EW/QSk/pNAEQ3ebpFeOcfapWGFtlmSKWw3DH2VTeYokvrTdCHjVQcvSJC7kP5iQeVniCaSTvOM1wjzI7pqm4FPFD6SC9x98W7wkAevnZSEWVbqVEmXYgJjRaxP0dTXz8hKM9cdo1kZjQeDsOM/f5pEHqYAEAlM9gug0OVo81FNweKmYBunjtM/4VnIcInfn+eu0jTIC4gR1DoI8rAxrYCDnfJ1I12x2MN+90SZIau1ktMdXLujqMuCbo5SV0WnoHHrCTM9TgLkRf/JgH+y4WUztJzgruNr5jmBeWyP2d8gPs2GWtl8bYZTJIM41qklNkLIuas6b5afhlOj/UA8zNjXQTzBqwKWcR3A4MCilNfj1b88EFhtdlaxmVZo5fWQZbcR4LgKbT0BMRQ8ckmVSKc9IEniOglxsy8ZMkWoxhK94994AujMX+bI1x+e3jiFmDf1mrDxVQ9hrE0hmKya744NGB48VDOfXnkwWY5eCEFsuEs1ifqX4Cofw==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bf13d1e-0dc1-4c7e-9c2a-08d87518f800
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 16:55:37.8276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dKa30Vv8XKQmJSUnLUSPHIPkXUsdpaCRVaaIzUvnJb3rFAJnNLwFJHZyzByeZ5gEefuJsietCaB0lJPwIGi5dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB3265
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/8/20 1:54 PM, Mike Christie wrote:
> On 10/8/20 12:11 PM, Mike Christie wrote:
>> On 9/25/20 1:41 PM, lduncan@suse.com wrote:
>>> From: Lee Duncan <lduncan@suse.com>
>>>
>>> iSCSI NOPs are sometimes "lost", mistakenly sent to the
>>> user-land iscsid daemon instead of handled in the kernel,
>>> as they should be, resulting in a message from the daemon like:
>>>
>>>> iscsid: Got nop in, but kernel supports nop handling.
>>>
>>> This can occur because of the forward- and back-locks
>>> in the kernel iSCSI code, and the fact that an iSCSI NOP
>>> response can be processed before processing of the NOP send
>>> is complete. This can result in "conn->ping_task" being NULL
>>> in iscsi_nop_out_rsp(), when the pointer is actually in
>>> the process of being set.
>>>
>>> To work around this, we add a new state to the "ping_task"
>>> pointer. In addition to NULL (not assigned) and a pointer
>>> (assigned), we add the state "being set", which is signaled
>>> with an INVALID pointer (using "-1").
>>>
>>> Signed-off-by: Lee Duncan <lduncan@suse.com>
>>> ---
>>>  drivers/scsi/libiscsi.c | 13 ++++++++++---
>>>  include/scsi/libiscsi.h |  3 +++
>>>  2 files changed, 13 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>>> index 1e9c3171fa9f..cade108c33b6 100644
>>> --- a/drivers/scsi/libiscsi.c
>>> +++ b/drivers/scsi/libiscsi.c
>>> @@ -738,6 +738,9 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>>>  						   task->conn->session->age);
>>>  	}
>>>  
>>> +	if (unlikely(READ_ONCE(conn->ping_task) == INVALID_SCSI_TASK))
>>> +		WRITE_ONCE(conn->ping_task, task);
>>> +
>>>  	if (!ihost->workq) {
>>>  		if (iscsi_prep_mgmt_task(conn, task))
>>>  			goto free_task;
>>
>> I think the API gets a little weird now where in some cases
>> __iscsi_conn_send_pdu checks the opcode to see what type of request
>> it is but above we the caller sets the ping_task.
>>
>> For login, tmfs and passthrough, we assume the __iscsi_conn_send_pdu
>> has sent or cleaned up everything. I think it might be nicer to just
>> have __iscsi_conn_send_pdu set the ping_task field before doing the
>> xmit/queue call. It would then work similar to the conn->login_task
>> case where that function knows about that special task too.
>>
>> So in __iscsi_conn_send_pdu add a "if (opcode == ISCSI_OP_NOOP_OUT)",
>> and check if it's a nop we need to track. If so set conn->ping_task.
>>
> Ignore this. It won't work nicely either. To figure out if the nop is
> our internal transport test ping vs a userspace ping that also needs
> a reply, we would need to do something like you did above so there is
> no point.
> 

Hi Mike:

I've read this a few times, and I'm still no sure I'm parsing it correctly.

Are you saying that my original patch submission is ok, or are you
saying there's nothing we can do and we're up the proverbial creek?
-- 
Lee Duncan

