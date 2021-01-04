Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09966C433E6
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 17:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDA87206CB
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 17:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbhADRoa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:44:30 -0500
Received: from mail-pg1-f172.google.com ([209.85.215.172]:44032 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727986AbhADRoa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 12:44:30 -0500
Received: by mail-pg1-f172.google.com with SMTP id p18so19486095pgm.11;
        Mon, 04 Jan 2021 09:44:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W41s4SpHuFxfP2VmE7HCI4KFVMEE3WKx0iXTMwP7vnM=;
        b=m9QJ1edukeXN241rEKi8gvQhMIRvwBhPUC7zH/aAtYY+56R9/lYmoGzvdNvs/lmklP
         vdv9cAuBHMNOUwxlMhyjvvh8rvRRWQk11YxRUPal6o9TINKZCQSfjJP+vFaozUE5ntHz
         HUzhxPWN+BFIEseiJt0Rf8yD2GPCNM0Q553RrLiTbNuvOk8P1J9P6XVURet1GSI5xKVh
         2hUmJWsWDJiiHvXl1ccj+A1/ylb63H3EirNgDrQB2kTPiw3zKtg7muJXtLtTwEXzRILY
         R+P5UIUOcodnRdxbrSroIrLFFh+yZmjyl3Of8yuX66pJMuvjhAMA8oj55xDh94tUF387
         sNyw==
X-Gm-Message-State: AOAM5331N0qVoolmrUyNx8+EsWp7af8fljZe3/WaJ00nadkn82655bt2
        s6beDBZQwpdepzCcP42xngg=
X-Google-Smtp-Source: ABdhPJwKTIkHd9jD106iNYsMCjlbG9ke8DsYiuUgJzn38bv0xFujzmC1vyllUPjkZAgfvXQ07hPHdg==
X-Received: by 2002:a63:c1e:: with SMTP id b30mr71096758pgl.72.1609782229216;
        Mon, 04 Jan 2021 09:43:49 -0800 (PST)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id b4sm10376pju.33.2021.01.04.09.43.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 09:43:48 -0800 (PST)
Subject: Re: [PATCH] scsi: target/sbp: remove firewire SBP target driver
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     Chris Boot <bootc@boo.tc>, linuxppc-dev@lists.ozlabs.org,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
References: <01020172acd3d10f-3964f076-a820-43fc-9494-3f3946e9b7b5-000000@eu-west-1.amazonses.com>
 <alpine.LNX.2.22.394.2006140934520.15@nippy.intranet>
 <7ad14946-5c25-fc49-1e48-72d37a607832@boo.tc>
 <alpine.LNX.2.22.394.2006150919110.8@nippy.intranet>
 <8da0c285-d707-a3d2-063e-472af5cc560f@boo.tc>
 <alpine.LNX.2.22.394.2006161929380.8@nippy.intranet>
 <8cbab988-fba7-8e27-7faf-9f7aa36ca235@acm.org>
 <alpine.LNX.2.22.394.2006171104540.11@nippy.intranet>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <e3b5ce6a-0152-01b8-89d2-80bcdb9c1c57@acm.org>
Date:   Mon, 4 Jan 2021 09:43:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.22.394.2006171104540.11@nippy.intranet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/16/20 7:07 PM, Finn Thain wrote:
> On Tue, 16 Jun 2020, Bart Van Assche wrote:
>> As far as I know the sbp driver only has had one user ever and that user 
>> is no longer user the sbp driver.
> 
> So, you estimate the userbase at zero. Can you give a confidence level? 
> Actual measurement is hard because when end users encounter breakage, they 
> look for quick workarounds before they undertake post mortem, log 
> collection, bug reporting, mailing list discussions, analysis etc.

(replying to an e-mail from six months ago)

Hi Finn,

I am confident that my estimate is an accurate estimate since I have not
seen any sbp support requests, sbp bug reports nor any sbp bug fixes since
the sbp target driver has been accepted upstream.

> Here's a different question: "Why remove it from the kernel tree?"
> 
> If maintaining this code is a burden, is it not the kind of tax that all 
> developers/users pay to all developers/users? Does this driver impose an 
> unreasonably high burden for some reason?

Yes. If anyone wants to change the interface between SCSI target core and
SCSI target drivers, all target drivers, including the sbp and FCoE target
driver have to be retested. In other words, keeping unused target drivers
inside the kernel tree involves a significant maintenance burden for anyone
who wants to modify the interface between the SCSI target core and SCSI
target drivers.

Additionally, there is a good alternative available for the sbp driver.
Every system I know of that is equipped with a Firewire port also has an
Ethernet port. So users who want to provide SCSI target functionality on
such systems can use any SCSI transport protocol that is compatible with
Ethernet (iSCSI, iSER over soft-RoCE, SRP over soft-RoCE, ...).

Thanks,

Bart.
