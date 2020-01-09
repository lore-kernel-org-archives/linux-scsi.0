Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B92C33CA2
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 00:59:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0BBB2067D
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 00:59:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QEeSrtfq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbgAIA70 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 19:59:26 -0500
Received: from mail-pj1-f52.google.com ([209.85.216.52]:50358 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgAIA70 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2020 19:59:26 -0500
Received: by mail-pj1-f52.google.com with SMTP id r67so373076pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jan 2020 16:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jTWfbYrEYGVlon/9KpjQwSnZYuWAbbzZ8xybmNY1fkA=;
        b=QEeSrtfqZUtKlV3rfkfmwyma3CMewuiw3XmBI+tUp6oSmR+5by/CIwgDaydUBoySp9
         W7NN6iiIbJ0lBeJcJ6sOS6j+EspYxyzxSDuLyab6AuWa1JG4tDDX7ugz/xPiNLOQ80w1
         OfhSYT1B5f7CAK3+u02BBhpBsh28rs2gwafTT6WWAFhb3qwQFUGKbr/5Wuzrh4g4A03v
         Wndvm2i+MJMP+hrknPHRDgkEyE/qDefhi4U6/eTsaYHEbBAkiRRVbepZBIFEByVDayTT
         6GimCnCr4K1VZNgbgZfoGMCSOShaC5lme9nY6TzN+pqQ8ipWF2dPyVtnFzz+gtQDxwIY
         MYFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jTWfbYrEYGVlon/9KpjQwSnZYuWAbbzZ8xybmNY1fkA=;
        b=UA0CjRqIhpP7iFG1nnfIMrgCCI6JR1LiD/chAVW0xpmweTSmC9M3tvDEJQYmDWnvIS
         Bgy9AKvDpH40kjEIrXUVJl3GENjod/1xZIMvmM7hoOQESYT+0Ex6peK3utZ4b424APSB
         M5lUMmDs2mNg8n1SIM83g8glY9wIocrxrDQNS1L29/tiTJTK93eNshUPW7YgigbmyJhn
         xF7xrHZEOTpELSiSQw0qhS56Plr8koTnEz2HIJxmuBUCTntyc6sIb3Le5gm+5ahqfjcy
         bQnbDQIHmhgDJoBl57GE2dfZnF3fn9GPMJSay8m8YWazJxL/WrvMaBYpOkZOTYtiruxq
         07mg==
X-Gm-Message-State: APjAAAUvosS/GJgVAtu12lqC9huAEmX2j2G2aJIHPhN9qXNX8k4tJ2Xf
        byffbUeOXLbox+cHzuhWhP8=
X-Google-Smtp-Source: APXvYqyJWyHsEiltE4t88o1FxYE74Y67pffBaEDHOXejM0cjKCXAB7wHIkwFbjZ717GS+sB1+Hk42Q==
X-Received: by 2002:a17:902:6b8c:: with SMTP id p12mr8471637plk.290.1578531565734;
        Wed, 08 Jan 2020 16:59:25 -0800 (PST)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o14sm4464730pgm.67.2020.01.08.16.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 16:59:25 -0800 (PST)
Subject: Re: [PATCH v2 01/32] elx: libefc_sli: SLI-4 register offsets and
 field definitions
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-2-jsmart2021@gmail.com>
 <3d984e91-49f6-dd8f-ed00-82fcfdc9b95e@suse.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <07ff4a51-8a58-d3f4-fe67-0ff8a7e74b04@gmail.com>
Date:   Wed, 8 Jan 2020 16:59:23 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <3d984e91-49f6-dd8f-ed00-82fcfdc9b95e@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/7/2020 11:11 PM, Hannes Reinecke wrote:
> Please be consistent here wrt _SHIFT and _MASK statements.
> Either have them spelled out (as you do in this case), but then please
> change the first hunk to avoid an explicit shift.
> Or keep the style in the first hunk, and change the _MASK values here
> to use the _SHIFT values
> (ie SLI4_EQCQ_ID_HI_MASK = 0x1F << SLI4_EQCQ_ID_HI_SHIFT).
> I don't mind either way, but keep it consistent.
> 
> Cheers,
> 
> Hannes
> 

We will do the change to spell out the _MASK directly.

Thanks

-- james
