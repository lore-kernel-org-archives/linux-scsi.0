Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDEA5C77B73
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Apr 2023 19:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjDSTYp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Apr 2023 15:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDSTYo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2023 15:24:44 -0400
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C591527E
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2023 12:24:43 -0700 (PDT)
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-517bdc9e81dso84400a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2023 12:24:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681932283; x=1684524283;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qt+0nOuWQum9gauro+XDaO1ugZk7POfRWZG6C6OMIo4=;
        b=XB6kjDX7vGUKAjmKLp9ERAu+wnQbKN2zw5bmNYF9cjuSkq4iNlqYqSg/IbLMuc8jrA
         /iZOhvXD7tqnlB8DCDXe3PCWUrZYdBKjvBoR44WOG2lEjYiqfVTIE5FlZM5k7af368h2
         s3fE4M/G7MQhQ3jmAk3yaudHubDjuYM3Cn56aMlWY4RP8iNXSY5aidJ1dz/M+tX2eUuZ
         6+Yb+wyF3LKTg5BvVW/pWGjizcFljKKUjOAVQorqhUVvCy/oN5BTUL+m6YzxXP5IWrJm
         i4gVrXYNcuAnzyZ51S7bDZQZywmgzbz2eqb8G6fdvwnNb18FpyUV13daNn1f40nxAUcX
         +wCw==
X-Gm-Message-State: AAQBX9eDL7F4DSp8MGlyvTNdp4WI/n+a7Y3VOCAoGsJW81KeRmrCRbXz
        qDel7cvXca2BrQrqbBiStk0=
X-Google-Smtp-Source: AKy350beYQsV706B9DF2BnTC1LL+GyL4aZVIrVMqSaXNphK9cZ4ysNUJ7/QyNwo9mFNKGT9F5B+OFg==
X-Received: by 2002:a17:90a:bb83:b0:23d:a2a:3ae4 with SMTP id v3-20020a17090abb8300b0023d0a2a3ae4mr3894362pjr.44.1681932282952;
        Wed, 19 Apr 2023 12:24:42 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:d65e:8f40:1b48:5b0b? ([2620:15c:211:201:d65e:8f40:1b48:5b0b])
        by smtp.gmail.com with ESMTPSA id w3-20020a1709029a8300b001a66c4afe0asm10391687plp.255.2023.04.19.12.24.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 12:24:42 -0700 (PDT)
Message-ID: <257074db-72c7-a04f-bdf3-f5b90ea2781e@acm.org>
Date:   Wed, 19 Apr 2023 12:24:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v2 1/4] scsi: sd: Let sd_shutdown() fail future I/O
Content-Language: en-US
To:     jejb@linux.ibm.com, Tomas Henzl <thenzl@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>
References: <20230417230656.523826-1-bvanassche@acm.org>
 <20230417230656.523826-2-bvanassche@acm.org>
 <cdd6b413085dc606c351f3c10ea82774498171e1.camel@linux.ibm.com>
 <4f59864e-d5cb-2590-99a3-2314873216f4@acm.org>
 <2ecb60b5a17bd15a90d0a4a1718c202f3a1374e4.camel@linux.ibm.com>
 <a2195da6-5d41-789f-091c-6d38c9d7d7b0@redhat.com>
 <392c0fc3412bd39d37a6b87ba58b505095c56f7e.camel@linux.ibm.com>
 <5429f579-1512-b6b5-771a-70f3d27959b2@acm.org>
 <3f1cb05d70ea9a060951b8b2cd4ce84d8fb62174.camel@linux.ibm.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3f1cb05d70ea9a060951b8b2cd4ce84d8fb62174.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/23 11:33, James Bottomley wrote:
> So if we can't reliably get it right, let's not do it at all.  The
> previous argument you made was about problems with I/O to shutdown PCI
> devices.  That's not SCSI specific, so either we fix it for everything
> or decide it's not really a problem for anything.

The reference to PCI devices was an example only. As mentioned elsewhere 
in this email thread, sd_shutdown() does not do what it should do, 
namely to quiesce I/O. From include/linux/bus.h:

  * @shutdown:	Called at shut-down time to quiesce the device.

Bart.

