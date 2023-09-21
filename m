Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6071E7D0AB
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 21:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbjIUVwD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 17:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbjIUVvj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 17:51:39 -0400
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C2AEA9B;
        Thu, 21 Sep 2023 14:45:41 -0700 (PDT)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1bf6ea270b2so12399675ad.0;
        Thu, 21 Sep 2023 14:45:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695332740; x=1695937540;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1LPrsNGq5boi9mTTl9FBwqXIkZb8sPgUWflUeQRr3Ok=;
        b=W6XnAANUCZZPDRKVYXrOvRouHpqrtUYaKN/rPKdyWW/qddHm8mgKdaQOqt3rGL7XGd
         62+YjRP4q+K5SuAc0WkE7Kx0RprIkr+f74XY9BTo+0HYG+P1lYMsgiqcLy6uIZu5yo62
         ZMmT5g9sxBhsp2D97diqOJX3MBASUvyG8Gi85DzxTtujAJGA/nT7/kBkhMw3GPGxAkl+
         5eYdJEYzzvlZKfmdtr7CVt4G9/vJbxlTVsYfNLYZAxWunR/NpGg1QEMjTh/2Mbknd6eM
         XEvmxoxqpSQmQjDDbbXtNsD0cW6Nr1nm6VW0OZzt+O7Au6dq5pCIpB+LFv+FHVwW2OqA
         SQRg==
X-Gm-Message-State: AOJu0YyqUNJn9CSXHrswWvzLkfWZd1stri3XzTC7PYUHIxtX0wtU9Iuh
        hfzZXRbGm6Lully24ctegMQ=
X-Google-Smtp-Source: AGHT+IHcny4NbNWJJDSxqpc/G4dbD6t73q0FM4Zb41m46Rdpjj6k8yQlsSrvlgoB6ZgJZ0dPH2UUMg==
X-Received: by 2002:a17:902:7202:b0:1c4:588f:5971 with SMTP id ba2-20020a170902720200b001c4588f5971mr4772696plb.29.1695332740302;
        Thu, 21 Sep 2023 14:45:40 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:6903:9a1f:51f3:593e? ([2620:15c:211:201:6903:9a1f:51f3:593e])
        by smtp.gmail.com with ESMTPSA id f9-20020a170902ce8900b001b86492d724sm2015994plg.223.2023.09.21.14.45.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 14:45:39 -0700 (PDT)
Message-ID: <3cfe137b-59f5-434f-a40b-2ed14b4aa408@acm.org>
Date:   Thu, 21 Sep 2023 14:45:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/23] scsi: sd: Differentiate system and runtime
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
References: <20230920135439.929695-1-dlemoal@kernel.org>
 <20230920135439.929695-5-dlemoal@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230920135439.929695-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/20/23 06:54, Damien Le Moal wrote:
> The underlying device and driver of a scsi disk may have different
> system and runtime power mode control requirements. This is because
> runtime power management affects only the scsi disk, while sustem level
> power management affects all devices, including the controller for the
> scsi disk.
> 
> For instance, issuing a START STOP UNIT command when a scsi disk is
> runtime suspended and resumed is fine: the command is translated to a
> STANDBY IMMEDIATE command to spin down the ATA disk and to a VERIFY
> command to wake it up. The scsi disk runtime operations have no effect
> on the ata port device used to connect the ATA disk. However, for
> system suspend/resume operations, the ATA port used to connect the
> device will also be suspended and resumed, with the resum operation

resum -> resume

> requiring re-validating the device link and the device itseld. In this

itseld -> itself

> -static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
> +static inline bool sd_do_start_stop(struct scsi_device *sdev, bool runtime)
> +{
> +	return (sdev->manage_system_start_stop && !runtime) ||
> +		(sdev->manage_runtime_start_stop && runtime);
> +}

This function wouldn't be necessary if the sd_suspend_common() callers 
would pass sdev->manage_system_start_stop / 
sdev->manage_runtime_start_stop as an additional argument to 
sd_suspend_common().

> -		if (ignore_stop_errors)
> +		if (!runtime)
>   			ret = 0;
>   	}

The old code was self-documenting. If the name of the "runtime" argument 
is retained, a comment above this if-statement that explains why stop 
errors are ignored during a system suspend would be welcome.

Otherwise this patch looks good to me.

Thanks,

Bart.


