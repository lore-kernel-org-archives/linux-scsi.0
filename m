Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF51DC00140
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Aug 2022 16:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239260AbiHOQ1E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Aug 2022 12:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239994AbiHOQ0B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Aug 2022 12:26:01 -0400
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D49B1E7
        for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2022 09:25:41 -0700 (PDT)
Received: by mail-pj1-f49.google.com with SMTP id c19-20020a17090ae11300b001f2f94ed5c6so11981410pjz.1
        for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2022 09:25:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=qIBQ/avTaDhqc/URBZ6NzK4lSnN5cymJ2tLja1VRmT8=;
        b=c2e5ZFwrg01tsfgm9RY0SynW88rUBrqOZv4HT2OXIaYEBPJZs182obgmkLUz2A5sSE
         MdTVORLBmuqGr7KvohQj+lDiyJ1xy1pmWeN7cH5Pa1clhcv7cGTcxhFr8eN3/ON++qEE
         joo3asvwHwkxZpp4SOJv1/QF70XITyQ2/liBXt1nykxIljP14/MjuOMBqNjhLhwtRuFn
         Iw85olUxq5sn+I1BmtxS/RuYjsu24KcVs9/3ADCPu7n1TzBsXsEv+fqOlZjPNLJcH/aJ
         zmK1mqLrrUNNPQJrT9BY/M6Nx2CLh/x1bh/NtwHovZX2BohFZoLp2XX2qC4rRRir/smY
         xRUQ==
X-Gm-Message-State: ACgBeo2fhZelsx1HEjv7WFxnWW3lJklSB1JCXl8T5nOu0pNpwgJ9gZiV
        9O/2BLEf3sLHQAtTUNqtNKwHhqeDwoA=
X-Google-Smtp-Source: AA6agR70+EncjGndfL7+K2d4h8FgRaYDAKNIhWsW9ew+Sczlq63n9a97PKjOEfIJDrltlTkk1F2DiQ==
X-Received: by 2002:a17:90a:a415:b0:1fa:749f:ecfb with SMTP id y21-20020a17090aa41500b001fa749fecfbmr7794639pjp.112.1660580741166;
        Mon, 15 Aug 2022 09:25:41 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:c1a1:6549:b273:880b? ([2620:15c:211:201:c1a1:6549:b273:880b])
        by smtp.gmail.com with ESMTPSA id v24-20020a63f858000000b0041cef96cab0sm5911265pgj.90.2022.08.15.09.25.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 09:25:40 -0700 (PDT)
Message-ID: <79dec644-f2be-7f88-8520-35b2bddf760d@acm.org>
Date:   Mon, 15 Aug 2022 09:25:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 0/4] Remove procfs support
Content-Language: en-US
To:     Ewan Milne <emilne@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20220812204553.2202539-1-bvanassche@acm.org>
 <CAGtn9r=QrDBcEssvtwrEcXa6xO-8Jp3rMfJ09CxDNMhc549z_g@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAGtn9r=QrDBcEssvtwrEcXa6xO-8Jp3rMfJ09CxDNMhc549z_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/15/22 08:26, Ewan Milne wrote:
> You want to *remove* a user-visible interface that has been there
> for decades (granted, /proc has its issues and sysfs could replace it)
> because you want to make a kernel data structure a const structure?

Hi Ewan,

I want to remove this interface because this interface is obsolete, 
because there is a better alternative (sysfs) and because the primary 
user of this interface (sg3_utils) gained sysfs support 14 years ago.

Thanks,

Bart.
