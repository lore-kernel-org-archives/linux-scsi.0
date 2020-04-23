Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E50C55191
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 02:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 519962075A
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 02:50:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kR+yMa8p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgDWCuM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 22:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgDWCuL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 22:50:11 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BA3C03C1AA
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 19:50:10 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id y6so1792235pjc.4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 19:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ErA85lbtaZU/aGpQlQnpee7uHma/eeIm2x66Q+hpSAk=;
        b=kR+yMa8ptwXjarA7wFgTcxicOGOEklw0FJdQqVtVI4mUrlUSKrV/BHbcyXw1C6J7Zr
         +12FO55YsVZ3pp6H1PKx0NrqkLrK2vooCX7PLZcmg0wBx9v8AjalZg4s808FJv08io60
         h/dYqA5BnxUucc6hUVh3hxJM7ZNc2bAjp3vu7cGJgGk/VCRAVD0e71IsN3t4rcaS76UM
         9azYk6pyH+tyiEWvkDUFHo4M40GC1km9bsI3jmnmztF5XCnwj91Ya+PFkF1hHKDf3q6f
         ufemipYeLMf9oX1w5g9TV4eNWcF7ajgCZ7wWTBUfR0NeIqU2zUuowLQgZ3gvWhDVgk9s
         N9mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ErA85lbtaZU/aGpQlQnpee7uHma/eeIm2x66Q+hpSAk=;
        b=fbVOB6p524XRsCbDxX+W4aB6aCoqR/Ip4k3CkbYZtAQVi/6zkZM+MyMOjbFreJAvQn
         Ahy566nQ4+QS0P7Q0Ks3TiWGp/qhHtyVGmSqR63X+NI84wxvcGJtg9mmOC/EfHwJoNlP
         oO3FnZ95QuxEpWTzMTvLLEX4NieTSw9uN52i0SSbiNYxMZQjSmuWcnQQi11SeyFlGj9x
         ARlYUbqcYKt4c+JPxwKx/Avm7l9yXweWdcNaHr0P/UWte5QqctgXQJlnB3B4P846xbC3
         rGDub9eWb3BKhcxiDVu91wovfUzzj7B5A7Jr/k4m5Oi8HHxs9ur3LUOFs9dCuvNw9Wkr
         licg==
X-Gm-Message-State: AGi0PubcnCS3OEKSmxJYpBRP1+Z6BlQFsC4Y18gXGj3tTn+zCoabUFOY
        nIfvLuFfBOZo8PmlV3RvpjQ=
X-Google-Smtp-Source: APiQypK2g0HlbV697c1ngA9uSzmHy+29Q2zY9ke2w/ulHrUOrHmSXM0pn5sUuTq2O/S/n40rF/47iQ==
X-Received: by 2002:a17:90a:cb0b:: with SMTP id z11mr1884454pjt.62.1587610209677;
        Wed, 22 Apr 2020 19:50:09 -0700 (PDT)
Received: from [10.230.185.141] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 185sm967798pfv.9.2020.04.22.19.50.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 19:50:08 -0700 (PDT)
Subject: Re: [PATCH v3 14/31] elx: libefc: FC node ELS and state handling
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com,
        bvanassche@acm.org, herbszt@gmx.de, natechancellor@gmail.com,
        rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-15-jsmart2021@gmail.com>
 <20200415185603.hoaap564jde4v6bt@carbon>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <d18094a8-32c2-f024-db46-7cec0cd21754@gmail.com>
Date:   Wed, 22 Apr 2020 19:50:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200415185603.hoaap564jde4v6bt@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/15/2020 11:56 AM, Daniel Wagner wrote:
...
>> +	switch (evt) {
>> +	case EFC_EVT_ENTER:
>> +		efc_node_hold_frames(node);
>> +		/* Fall through */
> 
> 		fallthrough;
> 

Actually the patches that went in for -Wimplicit-fallthrough wants
/* fall through */


Other comments are fine and we'll address them.
BTW: Same goes for comments on patches 3, 7, 8, 9, 10, and 11.

> 
> I run out of steam and thus stop here...
> 
> Thanks,
> Daniel
> 

I understand. Regardless, thank you for the time and effort on this.

-- james
