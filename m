Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B7FC55186
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 01:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B46BC2074F
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 01:32:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rdy2q1l2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgDWBcR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 21:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgDWBcR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 21:32:17 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02F7C03C1AA
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 18:32:16 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id p16so3081680edm.10
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 18:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wyQzFnJMp+O/i9dF7ucKd6vVMGC6KGdOnUMXsvVVe6s=;
        b=Rdy2q1l2zIgBvpcBRI11iACnNlsn5ugdg6KN/fZN4Y5nd2ws2BvMNIm849xaJu9luC
         GNIsWeVPRuYsffwkwBaI/ge2KYnzQ7ITDRHSk3Fqt2vdtgrGjeMl9S0q+DSAeG+cnZS3
         2W7PihMRKvtptulB3KgQaLx4AIo44qNFkWYXnMQ0sYPQRpCp7gQHWJUK+3fqopUBFFBb
         G11D3Q9Sp4qb8FrhgIIosOgkdD1ttrkdAZUBuUhDoIPVY39drpd8jrQ1GfKKxk/MwJrV
         QMt8DLPhB9PfxcUSvwEgEtFvNTas+nGQ4ZirFTnMqQeMFBVWFbmu4TSzJRrz/Xl31HyF
         WbUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wyQzFnJMp+O/i9dF7ucKd6vVMGC6KGdOnUMXsvVVe6s=;
        b=JIk892CKb84EIrPU9pdU7RS8HstYuvzVjZCF9JYdelQt8+oXH7vDRyC3zLgg1Ieeih
         diMMvjET+/AxcIV/QjU2NUo4ZAcRdiDJY8Y3qm45JYABprWbb0nJulgTQvmqURzFLE8T
         J0hG806kLgozvsmq7NkKKFro7ozoUpxwDbTffBlqRqO0Ob1E6257l2jPirWjAnxs//jG
         DSxjLU73Z5AjFuVD+iVvRQRgu0XdnUc3mm/4A1S1hc4QavtftkPgczENJxHaSxIOjahQ
         XzFKt3o3lIM9+T+awN4vdu7gwyuv499QeF6xAaoH2LUon72W8T0MwOu7gVzyWdPpjAdX
         8awQ==
X-Gm-Message-State: AGi0PuYHRisMzM3S9/SnyBGrLi4BppzWZlT1SjiGHoZmmUk0Mnkke3fe
        8CIPdCvNqnPfFPznOYPH3BY=
X-Google-Smtp-Source: APiQypKNVm+NABCCR179ht63woAju170y8TTL/Og8lCgDV7UilBB7LaBnV5dLjs5Yfu32nydAkTdjg==
X-Received: by 2002:a50:ea85:: with SMTP id d5mr1017535edo.380.1587605535477;
        Wed, 22 Apr 2020 18:32:15 -0700 (PDT)
Received: from [192.168.1.237] (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id h9sm123410ejb.47.2020.04.22.18.32.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 18:32:14 -0700 (PDT)
Subject: Re: [PATCH v3 12/31] elx: libefc: Remote node state machine
 interfaces
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com,
        bvanassche@acm.org, herbszt@gmx.de, natechancellor@gmail.com,
        rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-13-jsmart2021@gmail.com>
 <20200415181904.3v5efamjwjcvs53i@carbon>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <21b21290-2a46-9326-83a2-bf35aad477b5@gmail.com>
Date:   Wed, 22 Apr 2020 18:32:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200415181904.3v5efamjwjcvs53i@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/15/2020 11:19 AM, Daniel Wagner wrote:
>> +void
>> +efc_node_transition(struct efc_node *node,
>> +		    void *(*state)(struct efc_sm_ctx *,
>> +				   enum efc_sm_event, void *), void *data)
>> +{
>> +	struct efc_sm_ctx *ctx = &node->sm;
>> +
>> +	if (ctx->current_state == state) {
>> +		efc_node_post_event(node, EFC_EVT_REENTER, data);
>> +	} else {
>> +		efc_node_post_event(node, EFC_EVT_EXIT, data);
>> +		ctx->current_state = state;
>> +		efc_node_post_event(node, EFC_EVT_ENTER, data);
>> +	}
> 
> Why does efc_node_transition not need to take the efc->lock as in
> efc_remote_node_cb? How are the state machine state transitions
> serialized?

efc_remote_node_cb is a callback called from outside the statemachine, 
so it needs to take the lock.   efc_node_transition is called from 
within the statemachine, after the lock is taken. In general the lock is 
taken upon entering the statemachine and released before exiting. There 
isn't granular locking within the statemachine.

For more background, see the reply that will be sent to Hannes shortly.

-- james

