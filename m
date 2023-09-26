Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2D5BE7E65A
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 18:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbjIZSHK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 14:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjIZSHJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 14:07:09 -0400
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1047910A;
        Tue, 26 Sep 2023 11:07:03 -0700 (PDT)
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3ae5e6a536bso472902b6e.1;
        Tue, 26 Sep 2023 11:07:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751622; x=1696356422;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O4h3glyafNratQ6PLmDtCxCOMTVFUaWeD69YAlktx1Y=;
        b=Vxx3k1Idvf5pD15x5S2Iu2+Q2NbSQXcProMUyet2OJ07XfijvLUQDcvtUYYAfyxSoe
         mHA139d1IqX7FxbmYCPPjcdSOwhVEubbP97JLqdza7dK2Nw8+uwpMVZ7DPLrfz2PBRVN
         EYI79tHEHCO6VChVrNenBeu6tD0bODdzhCqdMJRcFXv3QoFFYKgIkapCwIwJ8DCde1v/
         fCsSLRRUD/L/pBeSLwDbG8Z/gmUJnruVbD58nL0L8YoGL75c9MxrIz7BC7t72N4a+BjE
         ZsVJiTqX04czz/43CUhG21d44EXIu+hrE6JPmg4F+Jq0VdScJSENzGaB1Ngq+2erq8F1
         UrOw==
X-Gm-Message-State: AOJu0YwmvmbgvuSkq6HK27v/GEL2iYU39LUTJgstQtBqQZm/29nveoVK
        qrQj9CDGt3YENviMZZvc/fY=
X-Google-Smtp-Source: AGHT+IG5S4/lhxlx6yu/G49gBcpwTq6Isq9X4JnyrafkQqc7tzfCkpC92vJgVYEecYRaIyV7vjb7hA==
X-Received: by 2002:aca:2208:0:b0:3ad:fc5b:464e with SMTP id b8-20020aca2208000000b003adfc5b464emr12737107oic.43.1695751622265;
        Tue, 26 Sep 2023 11:07:02 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a80d:6f65:53d4:d1bf? ([2620:15c:211:201:a80d:6f65:53d4:d1bf])
        by smtp.gmail.com with ESMTPSA id a10-20020a62bd0a000000b00682a908949bsm2998067pff.92.2023.09.26.11.07.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Sep 2023 11:07:01 -0700 (PDT)
Message-ID: <e0784522-3e6a-4cda-b382-5d731c12eb0e@acm.org>
Date:   Tue, 26 Sep 2023 11:07:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/23] scsi: sd: Differentiate system and runtime
 start/stop management
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230923002932.1082348-1-dlemoal@kernel.org>
 <20230923002932.1082348-5-dlemoal@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230923002932.1082348-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/23 17:29, Damien Le Moal wrote:
>   static const struct dev_pm_ops sd_pm_ops = {
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index b9230b6add04..b7df1e6da969 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -193,7 +193,8 @@ struct scsi_device {
>   	unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page 0x3f */
>   	unsigned no_start_on_add:1;	/* do not issue start on add */
>   	unsigned allow_restart:1; /* issue START_UNIT in error handler */
> -	unsigned manage_start_stop:1;	/* Let HLD (sd) manage start/stop */
> +	unsigned manage_system_start_stop:1; /* Let HLD (sd) manage system start/stop */
> +	unsigned manage_runtime_start_stop:1; /* Let HLD (sd) manage runtime start/stop */
>   	unsigned no_start_on_resume:1; /* Do not issue START_STOP_UNIT on resume */
>   	unsigned start_stop_pwr_cond:1;	/* Set power cond. in START_STOP_UNIT */
>   	unsigned no_uld_attach:1; /* disable connecting to upper level drivers */

This is probably a good opportunity to change 'manage_system_start_stop' and
'manage_runtime_start_stop' from bitfields into booleans. Although unlikely, a
user could try to change both attributes from different threads. If this happens,
because bitfield changes are not atomic, this could cause one of the two updates
to be lost.

Thanks,

Bart.
