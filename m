Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD8CFC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 14:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D2C422263
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 14:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbgJSOR6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 10:17:58 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:53021 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728311AbgJSOR5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2020 10:17:57 -0400
Received: by mail-pj1-f67.google.com with SMTP id gm14so5403809pjb.2
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2020 07:17:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0D2naNs93dat1CMqAGEmswZHrWfuQZY62v5bkBUMftI=;
        b=uld+KNWGZSFaEKseomxcuz1aQWEhKkfmocP8pmFg8XZyoX8xVCQGbEKxraDiGTgyfC
         Z9N2CklyKpoAENRCRg5gTye0tz1EcxJn55zT3A2+z0wqdN3hlB5vygpKu1ld8+RGjNa1
         NldGn9RzP95iz5CqT+qzpaKt6Za9Epp7bHOYZi3gXDPdV/KIjD9a3BsZryAkHlNwEdCG
         F2e2NeRbchIHoIpIwrbfDg0viSVSISx8BTGVG2baUxPCh4kTdt6oHchjhDQbWUv+vZGB
         dBWEYUmjERoURGiXs1YG0ANWpDjcSV/Axq9Ky8lTGkZGKVvhTyt4P+6ph54/RVkTilev
         GYww==
X-Gm-Message-State: AOAM532vGKX7HaxBvejtr7kaRyoS5bNs5yRk7B+5yo1kpbi4xLCGrU59
        EXcR+QHfQOH/OWmiKjMDafI=
X-Google-Smtp-Source: ABdhPJwqU8Qccp3Shh9xJdstprWj8kcrUhO3RuN1OKcaVSYbz5O/4f/seS0/FIxF5y5zHuTHpQSkfw==
X-Received: by 2002:a17:90a:4ece:: with SMTP id v14mr33051pjl.70.1603117076868;
        Mon, 19 Oct 2020 07:17:56 -0700 (PDT)
Received: from [192.168.50.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id l82sm80098pfd.102.2020.10.19.07.17.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 07:17:55 -0700 (PDT)
Subject: Re: [PATCH] scsi: core: don't start concurrent async scan on same
 host
To:     Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
References: <20201010032539.426615-1-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ff55dd89-f48c-2900-d967-8eb6b1e33289@acm.org>
Date:   Mon, 19 Oct 2020 07:17:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201010032539.426615-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/9/20 8:25 PM, Ming Lei wrote:
> Current scsi host scan mechanism supposes to fallback into sync host
> scan if async scan is in-progress. However, this rule isn't strictly
> respected, because scsi_prep_async_scan() doesn't hold scan_mutex when
> checking shost->async_scan. When scsi_scan_host() is called
> concurrently, two async scan on same host may be started, and hang in
> do_scan_async() is observed.
> 
> Fixes this issue by checking & setting shost->async_scan atomically
> with shost->scan_mutex.

Did you perhaps mean "by serializing shost->async_scan accesses with
shost->scan_mutex"?

It is not clear to me why the shost->async_scan assignment is protected
with the host lock. Can spin_lock_irqsave(shost->host_lock, flags) and
spin_unlock_irqrestore(shost->host_lock, flags) be left out from this
function?

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
