Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08DA9CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 22:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEBBF20659
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 22:24:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VGzt1b8P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfJYWYu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 18:24:50 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35653 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfJYWYu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Oct 2019 18:24:50 -0400
Received: by mail-wr1-f65.google.com with SMTP id l10so4007896wrb.2
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 15:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y2LnyFghzXjjC7+4FSLTVcGhkUmqicbsu210rhpTT9c=;
        b=VGzt1b8PyzZOuhb0Yk1xw/Fz1Kb/u0vB7bDu55W1vHSVbFGSpZN5cAOJDi7KXzJtnJ
         UqzRbUiEvYXWZO1XZDDRvF/HJpdoSTA8C6bsKFkoH0BvQDWcFMNsRSb2GrwfIyJ+Mqog
         N/y87eQwc0c3bWShoTU9RIniyFSouEVT8aKSuB+qsRHacHVqA/F+09hdi7KFX3TsVdWf
         m2aZaXh8gcus62J+bvA77JyoPEPC6OeOCKtQQ6PrBF2CQUyrRL/vAuGGPfjOp27qY6Uq
         ElRsMHCsr2tedMMhCE+HD/CQ7m/6qoIMGFsb40H74W/GeFLJs2p3NqVsYLgzuIeTRhmp
         c3LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y2LnyFghzXjjC7+4FSLTVcGhkUmqicbsu210rhpTT9c=;
        b=VqCyT8gB9pMExYeY8saNrmo4cd+K2GZhRuxZjWrVJMf25E14egkNzZDUUSatDdh1OC
         o7e3MGtcvw7meB/QE32HhvK4+/j9hlqVSNjCYGwJw1K6plIHMuVVw3LRVv6UJA7wWe3x
         FpSuMsagt/S8z966GkXhh0vrvqPjcg4t9uTKg8VOj13maVJ2e43EYURq6DKeETKqL40D
         az4fYYfPTpbu6YyQil00wg2kEcJIQ9ifYeHN1VlMKRnyMk0sXFDQYXD+YdpC6Llp7eyS
         ETjEPrxnk6lKk24ejNAtBZhcVGWsOCaSUlVtKfQjj/SszvMs1PdDZ8Om2cAaMxhgDa9w
         ICCw==
X-Gm-Message-State: APjAAAWhY2s5gaSbENlkkznFpCJQxY3ofbVH3j1ZJcJSyBmsktwUga7f
        KUDn/mIX6DM77+b/qSXCmJawljkr
X-Google-Smtp-Source: APXvYqx1erVA/+pzxnAAsqH3FwGERci0Lr14sl490gHXGryEdR8R9qquIxwWAfn1Z4ZaBsAmsc/bNg==
X-Received: by 2002:a5d:51c3:: with SMTP id n3mr4939185wrv.5.1572042286215;
        Fri, 25 Oct 2019 15:24:46 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u1sm4479003wru.90.2019.10.25.15.24.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 15:24:45 -0700 (PDT)
Subject: Re: [PATCH 04/32] elx: libefc_sli: queue create/destroy/parse
 routines
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
 <20191023215557.12581-5-jsmart2021@gmail.com>
 <20191025153520.w3rppjka4jpcqfvl@beryllium.lan>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <81af6fa7-6ef2-8f39-8aab-087c1db9af51@gmail.com>
Date:   Fri, 25 Oct 2019 15:24:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191025153520.w3rppjka4jpcqfvl@beryllium.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks. We mostly agree with the comment written and will work on the 
changes.

Exceptions or answers to questions are inline below.

-- james



On 10/25/2019 8:35 AM, Daniel Wagner wrote:
>> +static void *
>> +sli_config_cmd_init(struct sli4_s *sli4, void *buf,
>> +		    size_t size, u32 length,
>> +		    struct efc_dma_s *dma)
>> +{
>> +	struct sli4_cmd_sli_config_s *sli_config = NULL;
>> +	u32 flags = 0;
>> +
>> +	if (length > sizeof(sli_config->payload.embed) && !dma) {
>> +		efc_log_info(sli4, "length(%d) > payload(%ld)\n",
>> +			length, sizeof(sli_config->payload.embed));
>> +		return NULL;
>> +	}
> 
> ...this logs something but what does it tell? I suppose it has
> something to do if a data are embedded or not.

yep - if its too big to be embedded and there's isn't a dma address to 
use for non-embedded format, it's an error. We will make that log 
message reflect what I just said.


>> +	cqv2->hdr.opcode = CMN_CREATE_CQ;
>> +	cqv2->hdr.subsystem = SLI4_SUBSYSTEM_COMMON;
>> +	cqv2->hdr.dw3_version = cpu_to_le32(CMD_V2);
> 
> Is this now a the command version? Shouldn't it be V0 as the
> documentation writes?

nope comment was wrong. We'll remove the comment. We won't bother with 
routine names reflecting cmd version # unless the driver has to use more 
than 1 version.


>> +static int
>> +sli_cmd_common_destroy_cq(struct sli4_s *sli4, void *buf,
>> +			  size_t size, u16 cq_id)
>> +{
>> +	struct sli4_rqst_cmn_destroy_cq_s *cq = NULL;
>> +
>> +	/* Payload length must accommodate both request and response */
> 
> Is this common? Is this true for all commands? If so maybe have this
> kind of information at the beginning of the file explaining some of
> the inner workings of the code would certainly help.

For the SLI_CONFIG mailbox command, which is a wrapper that issues a 
bunch of other mailbox commands specified by subsystem and 
subsystem-specific opcode - yes, it's true.

We'll clean this up. Likely remove the indicated comment and say 
something up in sli_config_cmd_init().


> sli_cmd_common_destroy_eq(), sli_cmd_common_destroy_cq() and
> sli_cmd_common_destroy_mq() look almost identically. Could those
> function be unified?

We'll look at better commonizing through small service routines and/or 
macros. We'll see if unification falls out.


> So many function look almost identical. Is there no better way to
> create the commands? Or is something like a generic command creation
> function worse to maintain? There is so much copy paste... I stop now
> pointing out the same issues again.

Same as last comment. A few helper macros should distill it to the items 
that are specific to the individual commands.


