Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A99E5C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Feb 2022 22:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355594AbiBCWaq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Feb 2022 17:30:46 -0500
Received: from mail-pg1-f181.google.com ([209.85.215.181]:36451 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiBCWaq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2022 17:30:46 -0500
Received: by mail-pg1-f181.google.com with SMTP id h125so3470881pgc.3;
        Thu, 03 Feb 2022 14:30:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7laOSOTRIKfgB81WkljSRpQ1Qs5RJtS6DOO8SbNq8dc=;
        b=BpCsZUz/REWiArgCBhrtz9TK5CEWRkECOccUnxyK8n29TywMgI1ZAmvktvvRxOY5Do
         4x+VSUl/nhbVl+1LgP7ewIb8GVvJtS1TOM7QPnRmi3xGubgH0P2V4vCPkjiEfOjV3AXZ
         6+eUH9bmeSX4VQDndXoJYAvfTmAmIi9j7tRPrjL56TvZjLn+cbcWKxP3jF8MpRb9GZ3l
         TnkuLOxsKeEjupabhKiVaidsHVTkoguEZ9ujFVlhSfOw/faMUWzBIhG083LkIeJLvG7J
         s8qswxPKmXokcNxBeCvcoi+lFVTaLSvgpoFEsOqm3S9hVNk6wrASeEsM/ivpt+k3yW59
         QCYw==
X-Gm-Message-State: AOAM531K3y5IDWqkcPByk/xUAsP6FYVOEPjX25bsKU8EXHMV+byZa16k
        rxeXfBI9dCPrXk5S4jbMA1OkrkH1W7k=
X-Google-Smtp-Source: ABdhPJwsmUgNHSp9NKx8vcK4gareU4i+aBqbeCkiE0fyUloViWGqIdpZzEwCDfLPGyVjD0z8dWE/+A==
X-Received: by 2002:a05:6a00:228e:: with SMTP id f14mr244581pfe.16.1643927445629;
        Thu, 03 Feb 2022 14:30:45 -0800 (PST)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id f3sm43443pfe.43.2022.02.03.14.30.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 14:30:45 -0800 (PST)
Message-ID: <086ce37e-22d1-a07e-7de5-7cfd927a5c8d@acm.org>
Date:   Thu, 3 Feb 2022 14:30:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 1/2] scsi: Add scsi_done_direct() for immediate
 completion.
Content-Language: en-US
To:     Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc:     linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20220201210954.570896-1-sebastian@breakpoint.cc>
 <20220201210954.570896-2-sebastian@breakpoint.cc>
 <c8402f76-7397-77c3-232c-c825c52ea826@acm.org> <YfwxJPUFCo5/55yI@flow>
 <Yfw7JaszshmfYa1d@flow>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Yfw7JaszshmfYa1d@flow>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/3/22 12:29, Sebastian Andrzej Siewior wrote:
> Let me see what I can do.
> 
> Something like this perhaps? The compiler not inline
> scsi_done_internal() so we maybe provide scsi_done() / _direct() as
> static inlines?

In general declaring a static function inline in a .c file is frowned 
upon but I think in this case we should do that. With that change 
applied, feel free to add:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
