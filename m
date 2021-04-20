Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D58AC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 03:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17A3D61073
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 03:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbhDTDX0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 23:23:26 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:45953 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhDTDXZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 23:23:25 -0400
Received: by mail-pg1-f169.google.com with SMTP id d10so25652332pgf.12;
        Mon, 19 Apr 2021 20:22:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G5zgAtg+8AAIdFSTqHn1F5QUpBZ54SSkCbJVAt2DCyI=;
        b=QK+xPVR/Qs6jnXqqr72Vu8Qa22MzG4OfvdS8ZmQ6/U1OFTRcjDjzBmRdtK9txa5kwv
         BzwnJimzI/Us4Bdtow9BsQDuc5PLNbgftWA4LO7/RyarRjdMDt1svMPutw/2aiBD/8CY
         lI0YVpy39G/eow/aU2w/KFl6xekIEu735F0l+7qA5FapAwHcwjAC1CBkECAT5fd6N0U8
         /A8ScNM9+VEXo3RQqetxgBW8DD7H3PwvVsjgnXn2N60H7Y5GCLC6JpjveNxbcOVIJlJD
         rMhCIGy6kevVcdUrMedi84r/P7f7KKZuUXC8UI5HaeuAWfE6xQ9aM2+Yxvpep4rLSF0F
         P6/A==
X-Gm-Message-State: AOAM533cdhW+b5TytzM6tK5UvSkxWxeez6bcQbo16IzFr5K25Sm0d5jW
        3NuX9ydOYNBZKuVyVFNxbtXd5HTePIVMAQ==
X-Google-Smtp-Source: ABdhPJy6yzmvRMosHHJMw3JA4NoRCD2eS+iAnIWlCHZWDiFqIemLfn4TKB/QeLnyHnhS4bB0eWqtDQ==
X-Received: by 2002:a63:150c:: with SMTP id v12mr14955758pgl.344.1618888974720;
        Mon, 19 Apr 2021 20:22:54 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:3e77:56a4:910b:42a9? ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id ir3sm733264pjb.42.2021.04.19.20.22.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 20:22:54 -0700 (PDT)
Subject: Re: [bug report] shared tags causes IO hang and performance drop
To:     dgilbert@interlog.com, John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
References: <9a6145a5-e6ac-3d33-b52a-0823bfc3b864@huawei.com>
 <cb326d404c6e0785d03a7dfadc42832c@mail.gmail.com> <YHbOOfGNHwO4SMS7@T590>
 <87ceccf2-287b-9bd1-899a-f15026c9e65b@huawei.com> <YHe3M62agQET6o6O@T590>
 <3e76ffc7-1d71-83b6-ef5b-3986e947e372@huawei.com> <YHgvMAHqIq9f6pQn@T590>
 <f66f9204-83ff-48d4-dbf4-4a5e1dc100b7@huawei.com> <YHjeUrCTbrSft18t@T590>
 <217e4cc1-c915-0e95-1d1c-4a11496080d6@huawei.com> <YHlNS3RqsYDMA3jQ@T590>
 <89ebc37c-21d6-c57e-4267-cac49a3e5953@huawei.com>
 <ccdaee0e-3824-927c-8647-e8f44c1557dc@interlog.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f9b143ac-c5df-eedc-13da-8e0c2399abb4@acm.org>
Date:   Mon, 19 Apr 2021 20:22:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <ccdaee0e-3824-927c-8647-e8f44c1557dc@interlog.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/21 8:06 PM, Douglas Gilbert wrote:
> I have always suspected under extreme pressure the block layer (or scsi
> mid-level) does strange things, like an IO hang, attempts to prove that
> usually lead back to my own code :-). But I have one example recently
> where upwards of 10 commands had been submitted (blk_execute_rq_nowait())
> and the following one stalled (all on the same thread). Seconds later
> those 10 commands reported DID_TIME_OUT, the stalled thread awoke, and
> my dd variant went to its conclusion (reporting 10 errors). Following
> copies showed no ill effects.
> 
> My weapons of choice are sg_dd, actually sgh_dd and sg_mrq_dd. Those last
> two monitor for stalls during the copy. Each submitted READ and WRITE
> command gets its pack_id from an incrementing atomic and a management
> thread in those copies checks every 300 milliseconds that that atomic
> value is greater than the previous check. If not, dump the state of the
> sg driver. The stalled request was in busy state with a timeout of 1
> nanosecond which indicated that blk_execute_rq_nowait() had not been
> called. So the chief suspect would be blk_get_request() followed by
> the bio setup calls IMO.
> 
> So it certainly looked like an IO hang, not a locking, resource nor
> corruption issue IMO. That was with a branch off MKP's
> 5.13/scsi-staging branch taken a few weeks back. So basically
> lk 5.12.0-rc1 .

Hi Doug,

If it would be possible to develop a script that reproduces this hang and
if that script can be shared I will help with root-causing and fixing this
hang.

Thanks,

Bart.
