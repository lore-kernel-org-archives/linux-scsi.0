Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4325DC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 03:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388442AbiEFDLt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 23:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232443AbiEFDLs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 23:11:48 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1107663BC8
        for <linux-scsi@vger.kernel.org>; Thu,  5 May 2022 20:08:07 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id z5-20020a17090a468500b001d2bc2743c4so5791717pjf.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 May 2022 20:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5TMrpqP2srI6yzl1i5OcHowqXhWoFaOxeCLx43QJlNE=;
        b=A1jF+lybNdLVVWu0ArJHlh3OCjSPbo2i6N+hiQrs6pUIaKK4Dp8+v7XoAd29pF1y9I
         H9GOorTRXh6WLS1Cl65dMAoiwSb0dvISPb29OFn0JOEUumvqpDPRxSQxftD3Pcm5HyAI
         Xr0CubCEqrlXurPDDMz/aWD/zHeT2aBjRSBn9dfKzP0u241JP9SULQclzHXBB9XhRsC4
         BCVXTGSPqSW0Civc/iMVk9gN1nVjC4auMHiOIIH7J4nwWFepJ0feZeaDbzVpz21Re9De
         FXWLQMrDCj8jRpNfcmBfZLDJI0Ikv9la5hw80YPDhcyVCoL8bblcsqgfaaMQHfuRaHkn
         8CAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5TMrpqP2srI6yzl1i5OcHowqXhWoFaOxeCLx43QJlNE=;
        b=r/G0EN8UeF8ACTIFqVBK+P/NGQluuhg5YFBte2kcZa+fjybzhoQIy0OYQusGDakNtj
         SjKeZRedmI2FmF+oQ/IAxCjnquC62u4gVJ9h/BCYLGsYIXD/un3qYOfPzAAOZ4mGvY6H
         e0M4QwSlYmTo5juR9idIwRnFc+mXDHpckcBVq2m85DEGULd8UFuZe8xqlp6G6iBzLvoO
         9OmXbFMxqkk32Q+ztMMD20bVyms9SjlP5X7TsHIoQ3oACqXq33KckmTQGeRnIQCoMODa
         XrVOHbRWWaWIwXIgYjYF3UN04OaBOiCbKdOR8oJPOZTk4tz+CvWyWNsyAuvVmSh8vPIW
         SsxQ==
X-Gm-Message-State: AOAM5302+u3FD9sIoTxOiGyUfx0vsQsbkHyguC6WYdvuBzH+ER7tr7EG
        qFMUfUdRLnmc7oDuVatapW4=
X-Google-Smtp-Source: ABdhPJyQcwAlj3AviO7/TiCvUnJMJyB4lu+GlmBusQKA4VR67DkOaRAjgHmy2dIszBegsnfUSn0SBQ==
X-Received: by 2002:a17:90b:4c48:b0:1dc:a631:e353 with SMTP id np8-20020a17090b4c4800b001dca631e353mr1699224pjb.218.1651806486570;
        Thu, 05 May 2022 20:08:06 -0700 (PDT)
Received: from [10.230.128.89] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id u18-20020a170902e21200b0015eb690bee9sm360808plb.196.2022.05.05.20.08.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 20:08:06 -0700 (PDT)
Message-ID: <f9b4c954-b5b5-d40c-b3dc-974757134daf@gmail.com>
Date:   Thu, 5 May 2022 20:08:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: lpfc: regression with lpfc 14.2.0.0 / Skyhawk: FLOGI failure
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Justin Tee <justin.tee@broadcom.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        David Bond <dbond@suse.com>, Hannes Reinecke <hare@suse.com>
References: <9d7e7a5613decc1737ef2601ebb2506890790930.camel@suse.com>
 <4a7f19b6330c3017c45074854cf86b04224e7706.camel@suse.com>
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <4a7f19b6330c3017c45074854cf86b04224e7706.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/2022 8:55 AM, Martin Wilck wrote:
> On Wed, 2022-05-04 at 09:11 +0200, Martin Wilck wrote:
>>
>> Hints appreciated. Complete logs and additional debug data can be
>> provided on request.
> 
> Further analysis by David showed that the FLOGI via FCoE was using the
> VLAN ID.
> 
> Martin
> 

We believe we understand the issue and are testing fixes.  Will keep you 
posted.

-- james

