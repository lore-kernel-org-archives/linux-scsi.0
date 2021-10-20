Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E80C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 03:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B20F6117A
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 03:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhJTD1D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Oct 2021 23:27:03 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:36729 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhJTD1B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Oct 2021 23:27:01 -0400
Received: by mail-pg1-f177.google.com with SMTP id 75so21276808pga.3
        for <linux-scsi@vger.kernel.org>; Tue, 19 Oct 2021 20:24:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4QlSRP0DK6tTbHtJD2pgWVhPY9BmUjCEkWpfSo1I4UQ=;
        b=AfUzEKOjYNNilcE61agItWatGDVgWA2JFH0gQrO4CG0zSyG0TnntpX4kuD1qcBqB3D
         FK2ZIwQ2cuBzCjEs6eVIdhOfN9BUXk+k9WYv6u5rshpXl7PqNHgRN4+5OvM7Uewy4Dsf
         FjExMy9OgM1cRlcSenJKIeKFiIjkBdd8DiMluRNNIrnIM2+Cknc02iMpTb0OYAMAem+n
         CrZX36N2VeRogkcMk9xOOU9sxLu8whqy6hg+LI2gZNH7JPQQrgg3vgp7szaDpmXOqNmE
         fToFSeTaZYfPDrG9PmtcQM5krBm1OOHrcb5NdkYHFQNyKK5/IK0w2CHJbys8XwfJjZK+
         6jLw==
X-Gm-Message-State: AOAM531OEsjHTTokhmYylHsi5UDbJS0CaXacaW7MH3jUaVpSBl+a/UlS
        fREJBbhd+DFqk31/M/e6kDE=
X-Google-Smtp-Source: ABdhPJw7TI5iM8lrodz8qLXB7tvgsLy7J68ccmcEpX3xU0J3P6opB9ZsagznvU4kxTUXBfiA2nyCTw==
X-Received: by 2002:a62:e51a:0:b0:44d:67bd:53ab with SMTP id n26-20020a62e51a000000b0044d67bd53abmr3804856pff.86.1634700287397;
        Tue, 19 Oct 2021 20:24:47 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:3394:3c51:c06a:8f0b? ([2601:647:4000:d7:3394:3c51:c06a:8f0b])
        by smtp.gmail.com with ESMTPSA id p16sm569158pgd.78.2021.10.19.20.24.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 20:24:46 -0700 (PDT)
Message-ID: <1abeda89-d7cf-9164-d8a1-3c764fd870a4@acm.org>
Date:   Tue, 19 Oct 2021 20:24:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] spraid: initial commit of Ramaxel spraid driver
Content-Language: en-US
To:     Yanling Song <songyl@ramaxel.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
References: <20210930034752.248781-1-songyl@ramaxel.com>
 <cfe5b692-6642-e317-39a7-f38c1460097c@acm.org>
 <20211012144906.790579d0@songyl>
 <6cd75c09-8374-7b9b-4ecc-3b3781cbe074@acm.org>
 <20211013065012.02b76336@songyl>
 <9d9d2f95-7782-85a7-b79a-ce481292c451@acm.org>
 <20211020003323.61323f67@songyl>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211020003323.61323f67@songyl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/21 17:33, Yanling Song wrote:
> On Wed, 13 Oct 2021 15:00:07 -0700
> Bart Van Assche <bvanassche@acm.org> wrote:
>> Please take a look at the bsg_setup_queue() call in ufs_bsg_probe().
>> That call associates a BSG queue with the UFS host. That queue
>> supports requests of type struct ufs_bsg_request. The Fibre Channel
>> transport driver does something similar. I believe that this is a
>> better solution than introducing entirely new ioctls.
> 
> I wish there was a standard way to address the ioctrl issue.
> Unfortunately ioctrl is the only way to meet our requirements as listed
> in the above.
> As discussed in previous megaraid's patchsets:
> https://lore.kernel.org/linux-scsi/yq1inc2y019.fsf@oracle.com/, that's
> why every raid controller has it's own ioctrl.

Why are ioctls the only solution? Why is a bsg interface attached to the 
SCSI host not appropriate? I haven't found the answer in the 
conversation about the Megaraid driver.

Thanks,

Bart.


