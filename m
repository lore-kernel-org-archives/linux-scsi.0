Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 101B7C2D0B1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 15:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E22FD21775
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 15:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbgBFPVq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 10:21:46 -0500
Received: from mail-pl1-f175.google.com ([209.85.214.175]:45950 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727325AbgBFPVq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 10:21:46 -0500
Received: by mail-pl1-f175.google.com with SMTP id b22so2460002pls.12
        for <linux-scsi@vger.kernel.org>; Thu, 06 Feb 2020 07:21:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qvoSjwC0CO1ue/7U97vMUaJY/5IhR0hcz6dv1YULU/c=;
        b=CMv2qQoDiKlA4/JnSFnUfrCaNmVlC6t9I9NKdHAlrJp70g+b5gVrt37z2GFCN+XJml
         hrqjJQsQDoU1z211MaFT3KoVOr4Etj53FtKbnoEn2Om97JWdCcBE8/G6OhJWD+h2k0wS
         3JNSW6P7X9RdJKCSjBVRdPKAiYqLL9mGfBZdO6naEb8Ibr11wkj4Hy61+gfaY+mHDns4
         cWsLN/jQxrWZTaXiGAbNUNgbXKBaYpX/nHcjwZ/oiurl67QAKXayLDtjLS4GXTiN/MME
         s+S1S+OdchWjfhQY1YUwpJVSurh2ka2qZsBtyrvtzFpgXLRrAglpH4jXBXrYqqKIxLwv
         bscg==
X-Gm-Message-State: APjAAAW2my1BLdw4ecJUzs7Rcht9TfL8URyXy2DS5PNyCgZFJ/aszb0f
        zgSPKEQRTNGTtwLxYRtHgLKjvi5WfmU=
X-Google-Smtp-Source: APXvYqz8gufvv+9abHHPdzRwcQ42mXuwWAioDWlMBlgf5y+hYCbhqoYb2BpIkt4s79N6eRMjc5FYgw==
X-Received: by 2002:a17:902:9687:: with SMTP id n7mr4345979plp.33.1581002505144;
        Thu, 06 Feb 2020 07:21:45 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:af99:b4cf:6b17:1075? ([2601:647:4000:d7:af99:b4cf:6b17:1075])
        by smtp.gmail.com with ESMTPSA id e6sm3929444pfh.32.2020.02.06.07.21.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 07:21:44 -0800 (PST)
Subject: Re: return value queuecommand should return after an unplug
To:     Oliver Neukum <oneukum@suse.com>, linux-scsi@vger.kernel.org
References: <1580989463.21862.11.camel@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <47c9af75-d7f6-bdf1-195c-e0e1f6c3757d@acm.org>
Date:   Thu, 6 Feb 2020 07:21:42 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1580989463.21862.11.camel@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/6/20 3:44 AM, Oliver Neukum wrote:
> I am looking at the queuecommand() mathod of the UAS low
> level driver. What is a host adaptor driver to do when
> it gets a scsi request for an unplugged host adapter?
> 
> All teh return values I see say that something is busy.
> But I have the case that something is dead and gone.

Hi Oliver,

I think that the SCSI result has to be set to an appropriate error code, 
that >scsi_done() has to be called and that queuecommand() has to return 
0 (success) in this case. Examples can be found in virtscsi_complete_cmd().

Bart.
