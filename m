Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9FBBC54FCB
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 04:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 965EB20747
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 04:41:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c3UJZf4+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgDVElp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 00:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725811AbgDVElo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Apr 2020 00:41:44 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE043C061BD3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 21:41:44 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id ay1so457918plb.0
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 21:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lVc46FahIO2w5AdiZH6z+Y4ZrK0VNzDcRJE1FjI8GeA=;
        b=c3UJZf4+2XnaiQxhd1YV8WmstEnyUqeQj+a2DJYFlgW/bo22HNYkkv/gdi64kyJUxn
         tthfn+rxMSn96TQ0YpUxNc4eRjYcHS1TQ/q6LuJrQZC5Z2WVbW+BtSBW2heHjBUyLVpp
         PljrILSCOfmwF16hTW0JIUznVZ//8GysD4NxZOmjIGHVkz/awg8A5QAceeRKIkXgyhlB
         DdlwlOIgkrp1644fWYcLvdcmqHChX/2HouKG24vBeiiEKT32VGvqVCz4jYwIynSPtQx1
         qbh0EWW6gFVYS4iBedGPU3LNRdJKPGp6Jj/oXfIMGhO8xPfc46fGsqAil09dp/s5apiv
         0RHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lVc46FahIO2w5AdiZH6z+Y4ZrK0VNzDcRJE1FjI8GeA=;
        b=At67S/1dq55X5MYOqFtmYB20gu8OCx1wPY449VQPb843hFVYT2EIbfP0nJHYbmJb20
         fX4OazGfzS2obeslIMdzFLT21AYIWNri3l1bF5vnPpd0VUlXR4WPjOAWtHuR3wkv/HA2
         R3ZquzYaTPPfT1IdLOvTe98GWtz1NkaYw6M9oXCy6Ewp8nIhmV4NWLkv36izchOCZBQq
         kL3LJu6ks0lBzTr/RQGWKTDihYnc1eZcUxVpP3VyTU4UNMbmp+BXTIqz+lfOY6r1P5L6
         MoxxMclxrghUS6b3E3W9wtjtK9cQZNh/MR0Z2vB1Tblgk85RKOW+35aZ7PValaEtTrU5
         Ep0Q==
X-Gm-Message-State: AGi0PuaMnfN7PC/CyfIDkn4gWtWOEKBRHPgHVPIk6EQTdQnKwVVqkWwq
        hRlc3hJQMap3gkAfLQZQDe8=
X-Google-Smtp-Source: APiQypIJFbXngBw4favDX+n568hKYD6B/co6Gh932ETIn+0jQFMzhlXYPs/UXqi/gH1EThzbmOcNgg==
X-Received: by 2002:a17:902:347:: with SMTP id 65mr15228449pld.21.1587530504263;
        Tue, 21 Apr 2020 21:41:44 -0700 (PDT)
Received: from [10.230.185.141] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q145sm4107102pfq.105.2020.04.21.21.41.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 21:41:43 -0700 (PDT)
Subject: Re: [PATCH v3 02/31] elx: libefc_sli: SLI Descriptors and Queue
 entries
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com,
        bvanassche@acm.org, herbszt@gmx.de, natechancellor@gmail.com,
        rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-3-jsmart2021@gmail.com>
 <20200414180221.3n2eqicptmh3gsyt@carbon.lan>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <25a9b874-3e46-c3c0-cc20-f04259b9baf9@gmail.com>
Date:   Tue, 21 Apr 2020 21:41:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200414180221.3n2eqicptmh3gsyt@carbon.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/14/2020 11:02 AM, Daniel Wagner wrote:
> Hi,
> 
> On Sat, Apr 11, 2020 at 08:32:34PM -0700, James Smart wrote:
>> This patch continues the libefc_sli SLI-4 library population.
>>
>> This patch add SLI-4 Data structures and defines for:
>> - Buffer Descriptors (BDEs)
>> - Scatter/Gather List elements (SGEs)
>> - Queues and their Entry Descriptions for:
>>     Event Queues (EQs), Completion Queues (CQs),
>>     Receive Queues (RQs), and the Mailbox Queue (MQ).
> 
> There are a definitions which are not used at all,
> e.g. DISEED_SGE_OP_RX_VALUE, sli4_acqe_e, sli4_acqe_event_code,
> etc. What are the plans with those?
> 

When defining adapter interfaces, the interface is usually defined in 
its entirety, whether fully used or not.  Not only is it not always 
clear what will be used when first added, but it seems cleaner to review 
for correctness (comparing 1:1 with a hw spec vs 1sy-2sy vs N in spec). 
In the case of several of the items, there will be future features (DIF 
support) folded in that will utilize most of the definitions.

I know it's not as clean as "only define what is used", but I would 
prefer to handle hw this way.

Agree with the rest of the comments and will address.

-- james

