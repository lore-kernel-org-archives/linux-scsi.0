Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55FD1C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 01:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BE232226A
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 01:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbhAEBsu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 20:48:50 -0500
Received: from mail-pg1-f170.google.com ([209.85.215.170]:37962 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727511AbhAEBsu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 20:48:50 -0500
Received: by mail-pg1-f170.google.com with SMTP id e2so20276664pgi.5;
        Mon, 04 Jan 2021 17:48:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iUVK5navqb95pupmgd9YzX87VeG3u/6V7I7N2PejYtg=;
        b=onWKYqFZHqCjJ6rKdtU+eY/1dWf79scDQwOR5rBBKS5RtgjthOjkPDnZx1NsyD2AeH
         0MsAXbmNj6N3vUvCT+xnDEoSCLtn4YqXhduPJetgMnt+UECp74vn3l3kWGP9ylBzDsOg
         S12gbmHit5E9Aa2FAuWP1HUOXfQAt+8FtQjodjHvbkjobAEovEPVt3UiMm0R5nptrH3h
         pzGgE98S/syFlmNMk5hZzanCvAE8Z3br7pj4nBwDJI25RDE/aTZJ86KCPl+0agtXhNWS
         Mo3JhZUHebxIAet4Q9zn8MRqXI/8gjn4+T5TuaeHnPIeTodwq0/Jw/OQ4E4UH0pZJUEJ
         xgtA==
X-Gm-Message-State: AOAM532UyNf5rALmy1E+lUEWnZZFUJlUx/SqE6GuufJpw/m+QLIC8zm4
        rO326kHeKI79Q4PNk8G2lVI=
X-Google-Smtp-Source: ABdhPJwzgRX+RGhlnQaIjfArrJuHlMKAMOxe4eTbuOyxNFW7vMhZmvmjR2h5swJDzjjpRU13PM4MEw==
X-Received: by 2002:a63:5d7:: with SMTP id 206mr75322598pgf.384.1609811289105;
        Mon, 04 Jan 2021 17:48:09 -0800 (PST)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id i7sm56827951pfc.50.2021.01.04.17.48.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 17:48:08 -0800 (PST)
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
 <e3b5ce6a-0152-01b8-89d2-80bcdb9c1c57@acm.org>
 <alpine.LNX.2.23.453.2101050840010.6@nippy.intranet>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9103b316-8848-2350-7c0d-b742c8d8c83c@acm.org>
Date:   Mon, 4 Jan 2021 17:48:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.23.453.2101050840010.6@nippy.intranet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/4/21 2:50 PM, Finn Thain wrote:
> On Mon, 4 Jan 2021, Bart Van Assche wrote:
>> Additionally, there is a good alternative available for the sbp driver. 
>> Every system I know of that is equipped with a Firewire port also has an 
>> Ethernet port. So users who want to provide SCSI target functionality on 
>> such systems can use any SCSI transport protocol that is compatible with 
>> Ethernet (iSCSI, iSER over soft-RoCE, SRP over soft-RoCE, ...).
> 
> Ethernet is not always an alternative. That was already discussed in this 
> thread. But let's assume for a moment that you can migrate any and all 
> users of this driver over to an ethernet driver.
> 
> Why would the maintainers of that Ethernet driver and its API accept that 
> plan, if adding users would extend their maintenance and testing 
> obligations? Do you think those maintainers should pay the "kind of tax 
> that all developers/users pay to all developers/users?"

Hi Finn,

I cannot speak in the name of the iSCSI over TCP/IP or iSER driver
maintainers. But since I maintain the SRP initiator and target kernel
drivers myself, I can state that I would be happy to help SBP target users
(if that driver has any users today) to switch from SCSI over Firewire to
SCSI over SRP over RoCE or even NVMEoF over TCP.

Thanks,

Bart.
