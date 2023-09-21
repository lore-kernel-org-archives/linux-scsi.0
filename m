Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10DC0E7D0AE
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 21:48:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbjIUVsy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 17:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbjIUVsg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 17:48:36 -0400
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6135B7ED3;
        Thu, 21 Sep 2023 14:36:05 -0700 (PDT)
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-578e33b6fb7so1101206a12.3;
        Thu, 21 Sep 2023 14:36:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695332164; x=1695936964;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2bH0FvAOfZCYOziXqawr8K3AdJv2Y7+Qa1FRajCGhCg=;
        b=tDl6tO6H8XR3KvovHF0mumcWwn13V5MzC19sJrMXdTCKWSkLXHSwB7HgaAajxIUzL5
         AnmWJU1VKGw12WcsqIs3FA6rKdFDzrUTNouUTuzG+Dd/fl0aeI1GKG86EDQVnYqjtEej
         2d5uhzD9IsdEYd5C/7mUsWRo3JJ44y8mG5ZEsSh3f5OfqboYiCoeKRwT1YM9tSZrVEFz
         cLTWE+8FrpfVoOF7BJwICyqoJOs0Lw9zbPhQU4vVMtXBxhvNx+STjKEgxJ9ZYJH3Jc9P
         W6KaIHm2oSfYyO5U6L+XZKg7U+3LT58LMlWIfJTdLeBxiUXvpQT0TV6kswek8mRfL3M8
         PzsQ==
X-Gm-Message-State: AOJu0YwLTJ4iu6h+ZYPdwRZSRYJyHFl+YHIoVKduT6Gn7E9SuDIxbPUB
        ETbCi1VLMkaUVuEu7koAY7JphEdT88c=
X-Google-Smtp-Source: AGHT+IEptsFt3jsmIU0zRiNDGbuvy6BGXlw0Fy8skDjaMSvpaIuYTVDQj0DnKr8UjKPpe55kEnUX2g==
X-Received: by 2002:a05:6a21:35c6:b0:15d:9a73:b146 with SMTP id ba6-20020a056a2135c600b0015d9a73b146mr990056pzc.54.1695332164503;
        Thu, 21 Sep 2023 14:36:04 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:6903:9a1f:51f3:593e? ([2620:15c:211:201:6903:9a1f:51f3:593e])
        by smtp.gmail.com with ESMTPSA id n6-20020a17090ade8600b002680dfd368dsm1887873pjv.51.2023.09.21.14.36.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 14:36:03 -0700 (PDT)
Message-ID: <daa44a6b-59fd-4735-b881-7d182a7d2a41@acm.org>
Date:   Thu, 21 Sep 2023 14:36:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/23] scsi: sd: Do not issue commands to suspended
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
References: <20230920135439.929695-1-dlemoal@kernel.org>
 <20230920135439.929695-10-dlemoal@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230920135439.929695-10-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/20/23 06:54, Damien Le Moal wrote:
> If an error occurs when resuming a host adapter before the devices
> attached to the adapter are resumed, the adapter low level driver may
> remove the scsi host, resulting in a call to sd_remove() for the
> disks of the host. This in turn results in a call to sd_shutdown() which
> will issue a synchronize cache command and a start stop unit command to
> spindown the disk. sd_shutdown() issues the commands only if the device
> is not already suspended but does not check the power state for
> system-wide suspend/resume. That is, the commands may be issued with the
> device in a suspended state, which causes PM resume to hang, forcing a
> reset of the machine to recover.
> 
> Fix this by not calling sd_shutdown() in sd_remove() if the device
> is not running.

Hi Damien,

I'd like to look into an alternative fix (after this patch series went 
in) but I couldn't identify the call chain in the ATA resume code that 
results in removal of the SCSI host. Can you please show me the call 
chain that results in SCSI host removal if resuming fails?

Thanks,

Bart.

