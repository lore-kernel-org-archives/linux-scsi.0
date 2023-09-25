Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F6FCD54BE
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Sep 2023 20:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjIYUWm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Sep 2023 16:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjIYUWl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Sep 2023 16:22:41 -0400
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6BD10E;
        Mon, 25 Sep 2023 13:22:34 -0700 (PDT)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-68fb85afef4so5702713b3a.1;
        Mon, 25 Sep 2023 13:22:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695673354; x=1696278154;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fn4PvOS3cobLZw9sn1qRokgQm99iBveZqnHYoHWO0k8=;
        b=vR+BpMIqRk3eS+ezN1rBv93+AtfWa9iG/67H306mNXC3cpY9iGlPyDmDEthEzAxBLn
         tyCwy51MzMTf/YZEVhjEARYk0VFZ87VNkPtaKIv5GUEhQqpow1oA2sull37ZMXlfgLLq
         urn66FJBnN6qcXwUnfF8fQh6U+F0DFe5iHq9GGC6+b+L/dhgL85ECCs8gw9kjUgv1DzQ
         fQlbFqLsCq8gQSDn8Vun+/PKvrbEnpj2KKvtIObSID7FT51Z13uGOsN6ZCc6eUMqcUpq
         ecxNcDHFwnm07TGXaV5TUdjRthRI7xT/tsO4EYDMOgbrBkwhWPT3aPVMaxAu4bnsS0hw
         +nOQ==
X-Gm-Message-State: AOJu0Yz58//ATIdmc0SkkzOTn/O6zb5IW7gJbtUsgUF73IEfFwmXpdU5
        H8MQjFcFarUxGMMoLuxms7M=
X-Google-Smtp-Source: AGHT+IHlKM29M22c5XDkMSjpHEGx6k9+wPkuzNPNMPrPOeClikIfF2Q2Y8z84YUG3zl7O6tqKh0ZKA==
X-Received: by 2002:a05:6a20:8f18:b0:125:517c:4f18 with SMTP id b24-20020a056a208f1800b00125517c4f18mr6789496pzk.8.1695673353853;
        Mon, 25 Sep 2023 13:22:33 -0700 (PDT)
Received: from ?IPV6:2601:647:4d7e:54f3:667:4981:ffa1:7be1? ([2601:647:4d7e:54f3:667:4981:ffa1:7be1])
        by smtp.gmail.com with ESMTPSA id n5-20020a170902e54500b001b8c6890623sm9348733plf.7.2023.09.25.13.22.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Sep 2023 13:22:33 -0700 (PDT)
Message-ID: <ca064bd3-2496-4d79-b68c-beff775228c3@acm.org>
Date:   Mon, 25 Sep 2023 13:22:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 09/23] scsi: sd: Do not issue commands to suspended
 disks on shutdown
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
 <20230923002932.1082348-10-dlemoal@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230923002932.1082348-10-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/23 17:29, Damien Le Moal wrote:
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 5eea762f84d1..4d42392fae07 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -150,6 +150,7 @@ struct scsi_disk {
>   	unsigned	urswrz : 1;
>   	unsigned	security : 1;
>   	unsigned	ignore_medium_access_errors : 1;
> +	unsigned	suspended : 1;
>   };
>   #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)

If the 'suspended' member is retained, please do not use a bitfield for the
but use type 'bool' instead. Updates of instances of type 'bool' are atomic
while there is no guarantee in the C standard that bitfield updates will be
atomic. Bitfield updates are typically translated into a combination of &,
| and ~ operations.

Additionally, I'm not convinced that we need the new 'suspended' member.
The Linux kernel runtime PM subsystem serializes I/O and system-wide power
operations. No I/O happens during system-wide suspend or resume operations
and no system-wide suspend or resume callbacks are invoked while I/O is
ongoing. The only exception is I/O that is initiated as the result of error
handling by suspend or resume callbacks, e.g. the SCSI commands submitted
by sd_shutdown(). Even if sd_shutdown() is called indirectly by a suspend
or resume callback, I don't think that it can happen that a suspend or
resume operation is ongoing for the device sd_shutdown() operates on. If
scsi_remove_host() is called from inside a resume callback, resuming of the
devices affected by sd_shutdown() will only be attempted after the host
adapter resume callback has finished.

Thanks,

Bart.
