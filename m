Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D87C33C9E
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 01:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C3BA206F0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 01:29:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h1l6KuGr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgAIB3y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 20:29:54 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44422 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbgAIB3y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2020 20:29:54 -0500
Received: by mail-pg1-f196.google.com with SMTP id x7so2382928pgl.11
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jan 2020 17:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BEbypwH2JLufMgg+dDYmXUbF982ojEWsl2Xlfq55ey8=;
        b=h1l6KuGrYme02lMFaxKQWnBeIGIW/nt012OjscRevfIkhQCzYvrhKM7b1Z/ny/8Wac
         43qXBsfcLv77iFiVvUMlg5snWTkHJeCJo2+1fDeRKrX/3E9iLYuJShIJoLjmgkqQLurz
         WpetouourZEDQH9p43LOjQPuio+nJv6lCz7yW7SlIzsMA4Vx7uzjgQ6ABI5CW8lS+0kJ
         OOuBjYX/UjSpkNMr5fwZUSeLluMh2z8wz9d6LpQNivE7UGsGdwoeAqtbgc+dqQjGqXel
         Sp0S0zdBWfFphNxj9mOeZG7H1RmnsvHvx74SXWZ2vKu6GxEQhk6NRlEHOpYC8PnTHQrH
         EEgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BEbypwH2JLufMgg+dDYmXUbF982ojEWsl2Xlfq55ey8=;
        b=iiuoxQcgMhRGacsg9tIxFzmW/bz3lV5StST1V/xHvNEBYhRMD+McPoRmi8wh95MynU
         sdHS/AoNuXdF+3c8jkAU04DyPu7LbdK8J985b86StwwaoONbM27lM7Ek7REFlSMu6Ci0
         uwC2dcU7dGGTHp7B/56rs3FJm//SWQOt2dx0zJn5pHkn3MLpzfg44flCenk+MSvM/IbO
         k+8fwV2NMfkiq848W2Ru110eFqTIIOwKTAC172/gO11WVzRD259kTx66ffIbM+7sICOn
         zx7qw/t09aqu7kUUViblh1SwCilFuZ9DuRZnhWJWqUPQtG28LPldTKGmh9E0Mq7hBllO
         ykiQ==
X-Gm-Message-State: APjAAAVEo8TPq6fd9uiM0wc/ZRfN/IPJ82pedu4llKS6QIIFTgMVwJNp
        zeHE8yflB0SFuuzYQJiJpE2Vi7j5
X-Google-Smtp-Source: APXvYqyneh8ayhpwa0wihMYCcPgNl9a4Q4lgRpbeXr7FK2Rg/ee1JC6MIUdP0aLdZxPb6qaUky9k1w==
X-Received: by 2002:aa7:8193:: with SMTP id g19mr8501529pfi.172.1578533393495;
        Wed, 08 Jan 2020 17:29:53 -0800 (PST)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t1sm5188937pgq.23.2020.01.08.17.29.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 17:29:53 -0800 (PST)
Subject: Re: [PATCH v2 07/32] elx: libefc_sli: APIs to setup SLI library
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        James Smart <jsmart2021@gmail.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-8-jsmart2021@gmail.com>
 <8fa86591-9c1f-9b64-3641-b8eddb2a5c62@suse.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <5e5c9113-efdc-ef77-2518-05f338a4df36@gmail.com>
Date:   Wed, 8 Jan 2020 17:29:51 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <8fa86591-9c1f-9b64-3641-b8eddb2a5c62@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/8/2020 12:22 AM, Hannes Reinecke wrote:

> 
> boolean?
> 
...
> 
> Same here?
> 
...
> See? It doesn't even hurt ...

:)

...
> 
> boolean?
> 

yep - we'll convert them to boolean's


> Ho-hum.
> Maybe 'extend allocation not implemented' ?

ok


> 
> Didn't you mention extent allocation is not implemented?
> So is this a different type of extent?

kinda - there was a comment header that tried to clarify this:

/*      * Tracks the port resources using extents metaphor. For
          * devices that don't implement extents (i.e.
          * has_extents == FALSE), the code models each resource as
          * a single large extent.
          */

regardless - we'll clarify what's going on.


>> +#define FDD 2
> 
> Oh, come on.
> You have defines for everything but the kitchen sink.
> So why do you have to define this one inline?

yeah - there are a lot.

Agree - the define will be moved to a header. It's a dump-type selection 
(function scope or adapter scope; only newer things do function only).


> 
> Please use defines for the return values here.
> One has no idea why '1' or '2' is returned here.
> At the very least some documentation.
> 

yep - will do.

> EFC_SUCCESS is back!
> I've already missed them; none of the previous functions in this patch
> use them.
> Please fix.

yep.


> I guess you can reformat those; the linux line length is 80 characters,
> and one really should use them ...
> 
> Cheers,
> 
> Hannes
> 

We'll fix the line lengths.

-- james
