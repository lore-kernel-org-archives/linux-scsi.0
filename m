Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 766EAC43461
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 16:20:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E3BC20775
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 16:20:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="qoF6HV95"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgICQUv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 12:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgICQUu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 12:20:50 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E48CC061244
        for <linux-scsi@vger.kernel.org>; Thu,  3 Sep 2020 09:20:50 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u126so3431808iod.12
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2020 09:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IqEAa3RXPtl6sf6fTK0LY8tjXFu+GTSbWB3dzNTdMBU=;
        b=qoF6HV95tE+QXiCAkYIotSM8M2fX4jY2JhnJkN6HUq8906ofsADx8yNGSdAh3h5+8x
         uxKlDv+V0TbMjg9mJ1OxZOiT/T9MuclPHi75yOKLtZjXF7Dm1SY92tvAVZPlFV6nNEvh
         PTKm9WRTA+lhHQzf3hHav4OYWKswH67qITKDPdI4XJvfk9hRx2AINZk/KKzD9jh5BK6Y
         5ZgnSBMn7Zi92xfGMCKs4LDirZcDEEp2TOsTqkXzKjZ00ZiCmdwt2o2h8sNN3imck65m
         snE4wS1p2WqJkjF2hT+WzIqxgMcXk/ACXNzpMNOZHOacA7vLD7+2j/xWmEr8NepJN7Zj
         9bZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IqEAa3RXPtl6sf6fTK0LY8tjXFu+GTSbWB3dzNTdMBU=;
        b=jP+n2ctY9+TnKAsdkTf4oAzROnlYhM6DUyj+m92mlpqUf+Mk5F4ctiRA+ZBGqQWHmY
         SpUxVqp2uf/M1FmvDTka8lvet+AsAaH+CO033eTzfXFDAMY1tnjHPtjf+JOeqly7mPhA
         Mbm1ZvQJdvv5Uk4pAfBnACMOLtexWO3lqWPybO3W8CBm4zT0GUrkCorQGqnvJsJz5j29
         ds46eKmiHdeV3QxCH80GD4b1QR4srrN5WbnQ2A1AznwbKVT61oj6eExb6y/ELvmXJpI5
         XiTc4bcqYcllUBURdCw6ykQmr1sYtp0k8tSXmF3umDqJWz3SdW6l3ogqyey8Venlx4xY
         y3/Q==
X-Gm-Message-State: AOAM531wIcw8HzPIy5s18sebn8zsDOuFzGQwBnw/ZK3PfwT51fem7PHk
        eV5izGv2pWvsgHNsijQI1YcJhQ==
X-Google-Smtp-Source: ABdhPJwBu3HSHBl7bLmROtBfyzGIDcDafn961ylmjGM4hL60F0jm28f+DqyF4gdQ0Z5lZcW1wNgOxA==
X-Received: by 2002:a6b:ec17:: with SMTP id c23mr3807554ioh.186.1599150049299;
        Thu, 03 Sep 2020 09:20:49 -0700 (PDT)
Received: from [192.168.1.117] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l12sm1483155ioq.50.2020.09.03.09.20.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 09:20:48 -0700 (PDT)
Subject: Re: [RFC] add io_uring support in scsi layer
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Philip Wong <philip.wong@broadcom.com>
References: <CAHsXFKFy+ZVvaCr=H224VGA755k45fAJhz5TaMz+tOP6hNpj1g@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d8d14575-30e4-5d1f-cd97-266f8ba36493@kernel.dk>
Date:   Thu, 3 Sep 2020 10:20:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHsXFKFy+ZVvaCr=H224VGA755k45fAJhz5TaMz+tOP6hNpj1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/3/20 10:14 AM, Kashyap Desai wrote:
> Currently io_uring support is only available in the block layer.
> This RFC is to extend support of mq_poll in the scsi layer.

I think this needs to clarify that io_uring with IOPOLL is not currently
supported, outside of that everything else should work and no extra
support in the driver is needed.

The summary and title makes it sound like it currently doesn't work at
all, which obviously isn't true!

> megaraid_sas and mpt3sas driver will be immediate users of this interface.
> Both the drivers can use mq_poll only if it has exposed more than one
> nr_hw_queues.
> Waiting for below changes to enable shared host tag support.

Just a quick question, do these low level drivers support non-irq mode
for requests? That's a requirement for IOPOLL support to work well, and
I don't think it'd be worthwhile to plumb anything up that _doesn't_
support pure non-IRQ mode. That's identical to the NVMe support, we will
not allow IOPOLL if you don't have explicit non-IRQ support.

Outside of that, no comments on this enablement patch, looks pretty
straight forward and fine to me.

-- 
Jens Axboe

