Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D0FC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 21:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1CC620708
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 21:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732319AbhAYVJl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jan 2021 16:09:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732415AbhAYVIA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2021 16:08:00 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3D3C061574
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jan 2021 13:07:19 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id q131so9111885pfq.10
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jan 2021 13:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HGw05zA/pd2eBKukAgDLbM9NGJ+BfrSrfgfG5GSt9rA=;
        b=zAqzonaLBsAJMCw1ZHhG6665Eu8oGucSk87NQjlhprK7oMPNKEOhwWiD10nbipxDdB
         NFBwGXFca7yyEGBunPfSJQPCVCKU+lE2dTsjKiHWy6jjqqMWZ7dIObpMMe4T9dUi+WIu
         ph85eEaN2hw0DVxDEV2HjFWg6DLh2isUf79hjRwsVpt6BfcbPmBSWGBzhzNG6HmJxw2V
         HBxymMYVWaP9dIQ3P4TPMGeRbEsJmKBSwAWGTxc088ah1AK6zphHt1bkeOoMYFRUlD12
         ENulZ7ozDedypaj9zUXnkIaivGyfothqaQdUIGhg/yGTenUzPZxHG/T5mt734tc9E/h+
         o0fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HGw05zA/pd2eBKukAgDLbM9NGJ+BfrSrfgfG5GSt9rA=;
        b=kCKAIqkA1v/sJaYVlpBaW0h7NZWiZozI+yXMhGGYkDGVZ1NCxthAkKe+iRVH0q6OjG
         RM/tYeri4DFkdud3x756QMUjsTdfsdShG/lZvfija0itP9XzWeTzXIccjEKw5VKD1vRQ
         QoNo47/eayqPWuclJPZrQxb7uTWuyFVhTXRSs3okcCg/NfYqQxIWwT9n9fUdvyAOhCMQ
         jIgcN92IR9bQ1uIijXhL5MdG1G/wUSOrUZ4jVPsjPlHEREGfgL2s5zIdVJXrdciK+bDe
         xKaMQg+azZlSdaT4dg6w2gIIpRqCilB/MMUD4FF4wwLCyzUS5VWyTsPJIvZVxAj2GjvA
         mi7Q==
X-Gm-Message-State: AOAM532+qTFG88ACLk4EdkLF6tLD4W+cKvtnpg4dT6+izUU7mx/H0iRx
        HDqG7LM54npPdq6Zmz9CuD14OQ==
X-Google-Smtp-Source: ABdhPJzFGOY5iDZliF+XsijM3lvUm5mKjqT+ZECePYQBdwXGnAFIbhKdmjKPiWJE2iLflP2T8NfyjA==
X-Received: by 2002:a62:7f12:0:b029:1bd:d6e7:e2ba with SMTP id a18-20020a627f120000b02901bdd6e7e2bamr2030253pfd.65.1611608839460;
        Mon, 25 Jan 2021 13:07:19 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id 7sm17100222pfh.142.2021.01.25.13.07.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 13:07:18 -0800 (PST)
Subject: Re: [PATCH v2] fio: add hipri option to sg engine
To:     Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        kashyap.desai@broadcom.com
References: <20210125202651.346783-1-dgilbert@interlog.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fde36155-55e6-d502-d3e5-ea23886a9d19@kernel.dk>
Date:   Mon, 25 Jan 2021 14:07:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210125202651.346783-1-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/25/21 1:26 PM, Douglas Gilbert wrote:
> Adds hipri option to the Linux sg driver engine. This turns on the
> SGV4_FLAG_HIPRI flag in recent sg drivers (January 2021) on READ
> and WRITE commands (and not on UNMAP (trim), VERIFY, etc). Uses
> blk_poll() and the mq_poll() callback in SCSI LLDs. The mechanism
> is also called "iopoll".
> 
> The Linux sg engine in fio uses the struct sg_io_hdr based interface
> known as the sg driver "v3" interface.
> Linux sg drivers in the kernel prior to January 2021 (sg version
> 4.0.12) will just ignore the SGV4_FLAG_HIPRI flag and do normal
> completions where LLDs indicate command completion with a (software)
> interrupt or similar mechanism.
> 
> Update fio.1 (manpage) with new hipri sg engine option.

Applied - but you forgot the HOWTO that I mentioned, I added that
one.

-- 
Jens Axboe

