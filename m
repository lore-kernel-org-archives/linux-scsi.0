Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE5AC4361B
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Dec 2020 18:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10DCB22571
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Dec 2020 18:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407604AbgLLSNd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Dec 2020 13:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731634AbgLLSNd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Dec 2020 13:13:33 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A502C0613CF
        for <linux-scsi@vger.kernel.org>; Sat, 12 Dec 2020 10:12:53 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id f9so9258363pfc.11
        for <linux-scsi@vger.kernel.org>; Sat, 12 Dec 2020 10:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5eAISqvfkmOn++ITl10B8x6QLhTwQg5u8IJ6e8re5Iw=;
        b=JbAFEoiVfdFJaup+7ebU01Q70BfwrBLiixMf2Ot0TQcGVaE/8qOCA1KPx9DSQvpa+J
         +iNCIEtAjfgsImO8VWDrO0m4R4O6Q+x+1EQBfGsqV9oDTnvG4xcLe0UQ4Ns/ReoEig4G
         uDcimW9gPtWcnJJih2wuxulM0csTkjuc4b33FAm3of2GingLivtkhizu60f4RhY+KhzO
         bmVJJQmF1kiJSCvwlzgHqAwqLtlxcISe6bZ7KaELTjmzzX2JzJoP55dIIMelKPGOMcTh
         7ABYYtL5L2KL0gOH27rSIu6VtDIV5+fTLjkZ2phuxxud6Lyl2Q82oP0r8APbyDTrfUD0
         HLeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5eAISqvfkmOn++ITl10B8x6QLhTwQg5u8IJ6e8re5Iw=;
        b=Gk9QxIYai1gF2YMRxWGP6T82lOS6B+Gdon2JdXJ3srsiJY/vQqnoVjrIMKXGHVAnWx
         7nMaWYUDfbXjUhcoKNZlsECgqZv5vDvLW2LqO2FR+LNnpdPI8+eyFFpY8pZhI+xtMOlq
         EkW75mRgeZi+78mKNUJgWGKUN/5O5w48N7Fvy+r43D1ZUi+QJWqvTOnKfdUTzzugl66q
         XvqvevaqBYVte0R+H2GsVWCPTPS2B7X4iF8ZIGr+HL5/edWl4MqfVvTZQLfJuLaDjD2W
         6HuNgZt1VUuXuLxelNL2XAEOoWj8NvIw9wcG1pelHkN8b//orqwTnBK6ICcBOY0Yzbv6
         yMhg==
X-Gm-Message-State: AOAM530ABMYtLDxQNOJ6rQnV/1NsuIZuVfWJqZsCRT4Rpgt9fpD7vOI5
        /8Wr5vGXk3z4xbgP8m25qRZ2JQ==
X-Google-Smtp-Source: ABdhPJwed2ITpNCS6LAaJ5DjKRinq+z3IawhawvRDxYoWw2T5Lu9iA8QaHOvAkJI7vfFW9/YGsjq7w==
X-Received: by 2002:a63:308:: with SMTP id 8mr1487880pgd.15.1607796772522;
        Sat, 12 Dec 2020 10:12:52 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id i11sm14936688pfo.129.2020.12.12.10.12.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Dec 2020 10:12:51 -0800 (PST)
Subject: Re: [PATCH 0/3] Remove in_interrupt() usage in sr.
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20201204164803.ovwurzs3257em2rp@linutronix.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c69b3d26-6fb7-674b-a3a6-bec80da2cff4@kernel.dk>
Date:   Sat, 12 Dec 2020 11:12:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201204164803.ovwurzs3257em2rp@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/4/20 9:48 AM, Sebastian Andrzej Siewior wrote:
> Before v2.1.62 sr_read_sector() did MODE_SELECT to set the requested sector size,
> issued READ_10 and then used MODE_SELECT to select a sector size of 2048 bytes.
> This function was used to serve ioctl()'s command CDROMREADMODE2 and CDROMREADRAW
> which do not use 2048 bytes as sector size.
> 
> In v2.1.62 sr_read_sector() changed to use READ_CD first and fallback to
> MODE_SELECT and READ_10 if READ_CD was not supported. Since this version it did
> not reset the sector size back to 2048 after the READ_10 opcode and
> instead gained a lazy reset in do_sr_request() and sr_release().
> It kept the new sector size and only changed if needed. On closing the
> device node sr_release() reset the sector size back to its default
> value.
> 
> In v2.3.16 the ioctl() (CDROMREADMODE2, CDROMREADRAW) were consolidated since
> both stacks (SCSI and IDE) did mostly the same thing. For the ioctl handling
> the SCSI implementation (doing sr_read_sector()) was removed and the ioctl was
> now served based on what the IDE implementation had to offer which was
> using cdrom_read_block(). cdrom_read_block() was also updated to use
> READ_CD and invoke the ->generic_packeto() callback.
> It is worth noting that READ_CD is now mandatory by the software stack.
> The old function with the fallback (sr_read_sector()) is only used
> sr_is_xa().
> 
> In v2.4.0-test2pre2 it is no longer mandatory to support the READ_CD
> opcode. A fallback mechanism was added in case the device did not
> supported the opcode. The mechanism had a small variance compared to the
> one from v2.1.62 and did: MODE_SELECT of the requested sector size,
> READ_10 and MODE_SELECT of the _requested_ sector size instead the
> previous sector size. To quote a comment from the changelog
> area of the file from when the change was introduced:
> | -- Fix Video-CD on SCSI drives that don't support READ_CD command. In
> | that case switch block size and issue plain READ_10 again, then switch
> | back.
> 
> but the code did not switch back, the changed sector size remained. The comment
> around the code says:
> |/* FIXME: switch back again... */
> 
> which leaves me puzzled. My interpretation of my archaeological research
> is that MODE_SELECT + READ_10 + FIXME was added first as the needed
> workaround. Later within the same release the FIXME was addressed by
> unfortunately using the wrong sector size, the FIXME comment remained
> and the changelog comment was added.
> 
> This is what we have today. Lets move on with this background in mind.
> 
> The in_interrupt() check in sr_init_command() is a leftover from v2.1.62
> change when the delayed sector size reset was used. It remained even
> after it was no longer used after v2.3.16. 
> 
> The sector size change was introduced back in v2.4.0-test2pre2 for SCSI
> devices that lack the READ_CD command but it was implemented
> differently. It sends directly a CDB which is not inspected by
> sr_packet() so the ->sector_size variable is never updated as it used
> to be back at the time when ioctl() was served by `sr'. As a consequence
> sr_release() is not resetting the sector size nor does
> sr_init_command(). I did not find anything that would allow to update
> the sector size at run time (other than a media change).
> 
> Side note: sr_init_command() is often invoked indirectly by
> __blk_mq_run_hw_queue() which has a WARN_ON_ONCE(in_interrupt()) check
> and acquires a rcu_readlock() so sleeping is not allowed and not
> detected by in_interrupt().

Applied, thanks.

-- 
Jens Axboe

