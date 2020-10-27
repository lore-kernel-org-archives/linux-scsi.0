Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E97C4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 02:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E52D82151B
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 02:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390913AbgJ0Cm7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 22:42:59 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35656 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390723AbgJ0Cm7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 22:42:59 -0400
Received: by mail-pf1-f195.google.com with SMTP id b3so53069pfo.2;
        Mon, 26 Oct 2020 19:42:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=An4TvOhqUe52P41FYM/iDoXlcKhP2c2muSbjR3f0bZ8=;
        b=Lrj/Nvku/yhu/tMmsE88D9MYgXS80EusEJiU7HO7NPUebGy/ieRZMrUgmRH0oNMvZI
         E9Y3BdDXh1jF7AN+rbLUSbUkoqJBpmwohPvfGsGKY14fompZCXvU+J5LOChDHHVhT8Eo
         AjlN3fz/OfyA+RN6mG2+jStxpszm5NHen18hm1blt9VmT7kcMpdavtClJg1ki6GFSkC2
         eIgWVWa6kv7/LZLC/X9HQ1djGHgRjS1EM+9M8kvN3ONNiE7o/PPCKdp4Rtl30bWO4+1D
         /AiX3Bv7rFZVS+/MHkykVe3i9HMVIqFn9diKaixk+QLWX1SlOioOBFBLkWe6rh+txjC5
         zztg==
X-Gm-Message-State: AOAM530nyJI+nVDu92wD8RZ4i7dUP5fQFyZRiHmaIbGFHh1Oi9sLdvth
        3WWpXNsfq10PnZCGal/v2SDZ2MsYdtCtZw==
X-Google-Smtp-Source: ABdhPJyeczwqtLLZHJNmCXfPRAkwaFDuTmgJP1vIB2R5tnQ7FO4tPKPWK+8abfENbtcRr4Qmu40JPQ==
X-Received: by 2002:a62:2c8a:0:b029:160:d7a:d045 with SMTP id s132-20020a622c8a0000b02901600d7ad045mr56483pfs.65.1603766577881;
        Mon, 26 Oct 2020 19:42:57 -0700 (PDT)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id z6sm125112pfj.48.2020.10.26.19.42.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2020 19:42:56 -0700 (PDT)
Subject: Re: [PATCH 3/3] scsi: target: core: Change ASCQ for residual write
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     Anastasia Kovaleva <a.kovaleva@yadro.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux@yadro.com
References: <20201022172011.42367-1-a.kovaleva@yadro.com>
 <20201022172011.42367-4-a.kovaleva@yadro.com>
 <e2b215ca-0aa8-bdae-e5bd-292a09d8282e@acm.org>
 <20201024121315.GA35317@SPB-NB-133.local>
 <b831a7db-1da2-c293-a8f6-d9c62f68c224@acm.org>
 <20201026131226.GA88490@SPB-NB-133.local>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <270e2edf-49c9-942f-ac3d-b6dfa0aca8f7@acm.org>
Date:   Mon, 26 Oct 2020 19:42:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201026131226.GA88490@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/26/20 6:12 AM, Roman Bolshakov wrote:
> Could you please elaborate on how tape software will be broken?
> I have no experience with tapes but I've looked into SSC-5 draft.
> 
> I haven't found anything concerning the writes but there are tape
> variants of overflow/underflow for reads (G.3 General read rules) called
> overlength and underlegth, respectively:
> 
>   If the read command requests fewer bytes than are available for
>   transfer, then the read is an overlength read. If the read requests
>   more bytes than are available, then the read is an underlength read.
> 
>   The amount of data returned is the smaller of the bytes available and
>   the allocation length.
> 
> And the next paragraph defines cases where CHECK CONDITION should be
> reported for such reads. However, GOOD status is also possible, the next
> chapter of the annex (G.4 Examples from figure G.1 using variable-block
> transfers and various SILI and BLOCK LENGTH settings) refines many cases
> depending on SILI bit, whether block protection is enabled, if the
> transfer is FIXED or variable-length and if BLOCK LENGTH is
> zero/non-zero.
> 
> As far as I understand underlength and overlength are always suppressed
> (status is GOOD) for devices where no "default" block size is defined
> per SPC (7.5.7.1 General block descriptor format):
> 
>   For sequential access devices, a block length of zero indicates that the
>   logical block size written to the medium is specified by the TRANSFER
>   LENGTH field in the CDB (see SSC-4).
> 
> The cases are also summarized in annex D (D.3 Summary of length error
> conditions on read type commands).
> 
> Note, that if we talk about SSC over FCP, then "9.4.2 FCP_DATA IUs for
> read and write operations" does additionally apply. Perhaps a) from
> "9.4.2 FCP_DATA IUs for read and write operations" works well for SSC:
> 
>   a) process the command normally except that data beyond the FCP_DL count
>   shall not be requested or transferred;
> 
> The clause allows to accomodate variable-block tranfers from SSC.
> 
> So, what if we return CHECK CONDITION only for SBC WRITEs with
> residuals?  Then it has no impact on SSC and other device types. In
> future, we might also add a patch that would fail SBC READs with
> residuals for sake of consistency. That behaviour would be beneficial
> for SBC devices as no host could corrupt data or itself by forming,
> requesting invalid data buffer.

Hi Roman,

Maybe I'm overly concerned. I do not know for sure which applications
rely on the current behavior of residual handling. All I know about
these applications is based on what others wrote about these
applications. An example from
https://www.t10.org/pipermail/t10/2003-November/009317.html: "We have
customers who also use overlength and underlength transfers as a normal
mode of operation."

An additional question is what behavior other operating systems than
Linux expect? There are probably setups in which another operating
system than Linux communicates with a LIO SCSI target?

Thanks,

Bart.
