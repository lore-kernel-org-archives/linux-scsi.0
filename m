Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0854DC7EE37
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 02:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbjFLCUN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Jun 2023 22:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjFLCUL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Jun 2023 22:20:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EB81BD;
        Sun, 11 Jun 2023 19:20:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37D4960BC5;
        Mon, 12 Jun 2023 02:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FA3C433D2;
        Mon, 12 Jun 2023 02:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686536409;
        bh=Hzy/vgJNkQScV+ALV8v/Qr/31Jnpc4qyg8qMUXzPsBE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=VGFt/nHRTelGRYQgEdPhZoM8pLwRvTnPfmZkfUWZCxydP7pOBbSIqdCDhKpgYHDnz
         51SOj+Mw4kiMSjL+iKP/AlBNSwqpacX8azijmebbkOhcjV4MCRb6iRPKc+/pxGLNX/
         /QbliMuEA4as1uRijJo8w2pEGgXOsFeppPvOoQCVKnNrIvKirT0TRJ6aLPe6EjSQ/l
         7b4tzXLKm4t9Xgdc4qDMnmoMB10e7Vv5WVWJ8dMUCjklh/sEcnOk6Tkw3cGXxfjkNe
         Xw/MoArUFrXlwX4Z3sPs8H6V/AdAnySuuEORGGIZy8HhAbfdelXNCuCjZU1Rw43U2X
         pIJJi2t/bq6qQ==
Message-ID: <36d32720-569b-4172-0c8a-aef846541185@kernel.org>
Date:   Mon, 12 Jun 2023 11:20:07 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH RESEND] block: improve ioprio value validity checks
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
References: <20230608095556.124001-1-dlemoal@kernel.org>
 <CACRpkdbmxoUwcwHdw4bcgaDy633ZKLOZ3z-d1qjzBF42omC1CA@mail.gmail.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <CACRpkdbmxoUwcwHdw4bcgaDy633ZKLOZ3z-d1qjzBF42omC1CA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/9/23 16:46, Linus Walleij wrote:
> On Thu, Jun 8, 2023 at 11:55 AM Damien Le Moal <dlemoal@kernel.org> wrote:
> 
>> The introduction of the macro IOPRIO_PRIO_LEVEL() in commit
>> eca2040972b4 ("scsi: block: ioprio: Clean up interface definition")
>> results in an iopriority level to always be masked using the macro
>> IOPRIO_LEVEL_MASK, and thus to the kernel always seeing an acceptable
>> value for an I/O priority level when checked in ioprio_check_cap().
>> Before this patch, this function would return an error for some (but not
>> all) invalid values for a level valid range of [0..7].
>>
>> Restore and improve the detection of invalid priority levels by
>> introducing the inline function ioprio_value() to check an ioprio class,
>> level and hint value before combining these fields into a single value
>> to be used with ioprio_set() or AIOs. If an invalid value for the class,
>> level or hint of an ioprio is detected, ioprio_value() returns an ioprio
>> using the class IOPRIO_CLASS_INVALID, indicating an invalid value and
>> causing ioprio_check_cap() to return -EINVAL.
>>
>> Fixes: 6c913257226a ("scsi: block: Introduce ioprio hints")
>> Fixes: eca2040972b4 ("scsi: block: ioprio: Clean up interface definition")
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> 
> This makes it easier to get things right.
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Thanks Linus !

Martin,

can you queue this please ?

> 
> Yours,
> Linus Walleij

-- 
Damien Le Moal
Western Digital Research

