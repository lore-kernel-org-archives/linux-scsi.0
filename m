Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47323C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 12:27:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24EE860F59
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 12:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhJUM3Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 08:29:24 -0400
Received: from outbound1a.eu.mailhop.org ([52.58.109.202]:27650 "EHLO
        outbound1a.eu.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhJUM3X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Oct 2021 08:29:23 -0400
X-Greylist: delayed 24369 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Oct 2021 08:29:23 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1634794858; cv=none;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        b=dsJmQp3NCgxK/Dh2WpfvQMZ+0y9BBku3hh5uMADqoHCkgMXIlfy7SA+oJ5yVNbsRBBfGM7zbZOwI6
         NM61uT2SODckcRyOwAvIlxrWd6vcsELB79+2R+ILJIZ8L3sc8pzCcoxum3aASyuRBn5S7JkMjHWscE
         X8lqK9YjJXknkd9CST/M+XyeEdP6aoY+Vm91Nq7UnGGPQZWjgdJZeShv6LVo+hJD0bbNyOcp8HECS4
         cRvnykvhD8fqyd/kKKWb0Td66q9svF85yujRgv27iHaWMQu/0I9D8yj1CbN6Weg8KjxmmsFmemDQsT
         uNSniLbJkzBTrFj06gGIkkIzQOYl7JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        h=content-type:mime-version:message-id:in-reply-to:date:references:subject:cc:
         to:from:dkim-signature:dkim-signature:from;
        bh=Wm/mSyAdMli/ns/hpQBzw2lo4egn1yDdmLFSKKT5H1M=;
        b=FwNiyh8t+K45ZlWRKbLcU61Jy87bReswffEbCh7SjporVJvGnunFlk2/8nN5fSIwQe7erup3yommv
         /RgV5rhIzDSyuIGnECrFyN3f64c4ALgxMe/GOPhKiOMsIaLj7AASMtgCu9BJgPPNYd3bAjbyClokRA
         HTHTbhDPrRajvFguF72M5VJT8kCjSAEXCTa9dw7tOf/NX9IyVlZTruoCxvgHiNg3MDvnCzwhOmjnWL
         FT13vuGv99kdtJxB85u45ZQXYBfXSew5T4BAPKUmzhteeevRMlLH8ODlqDCgvhygjDExKkVPQQf7Jx
         akhbHM0XRJCyTut7fIH+AoHFaHamB2g==
ARC-Authentication-Results: i=1; outbound2.eu.mailhop.org;
        spf=pass smtp.mailfrom=stackframe.org smtp.remote-ip=91.207.61.48;
        dmarc=none header.from=stackframe.org;
        arc=none header.oldest-pass=0;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stackframe.org; s=duo-1634547266507-560c42ae;
        h=content-type:mime-version:message-id:in-reply-to:date:references:subject:cc:
         to:from:from;
        bh=Wm/mSyAdMli/ns/hpQBzw2lo4egn1yDdmLFSKKT5H1M=;
        b=mrCwtjMM51QDLXmfQjqPnavnc7GL9yQqJFce7hTYiDmw2ex4asb+hur2oZ49VapM/YetifJIiUyjd
         AjTFCQiHAux1IsgQfg/u8gEJlzXCR0+soJNysABFeKnSTKwJm/oYlqJxv/nmif5aTneTRQiCkoF5ko
         d1E9HaAlOlSKGJVA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=dkim-high;
        h=content-type:mime-version:message-id:in-reply-to:date:references:subject:cc:
         to:from:from;
        bh=Wm/mSyAdMli/ns/hpQBzw2lo4egn1yDdmLFSKKT5H1M=;
        b=BcroR4RtALfzRZFC1PHfP5+BKiAUT3SQQ+1Q0zUoFhFUKw6htQL5vB/YFBS3Vlk24hgI9hZP61Sm6
         MYa10tDkev1nUb4PCtYZWwuN6nqqNa7l/1841tjL+t/3PIvjaUPFN9Jj+Jqwfegcacr4NiiBp329WW
         66NagK1wslaLeHitJI98/d3WpjKMlGVAGkcWHdKt7ySN7jsDVp7o0v/wUQv3XpuT1/dBWZ6mxudUs/
         t7DdcpwKmZn5uctILiVEUddTMbQhIgPKRTmetsZQU6buPcmh9AVTbkHb0JvpuopX/K7oSG6EbbVyNp
         ESvEWK6pr4U7HuhUN7tzI5EvyG1dcNA==
X-Originating-IP: 91.207.61.48
X-MHO-RoutePath: dG9ta2lzdG5lcm51
X-MHO-User: 7372ed69-3231-11ec-a070-973b52397bcb
X-Report-Abuse-To: https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information
X-Mail-Handler: DuoCircle Outbound SMTP
Received: from mail.duncanthrax.net (propper.duncanthrax.net [91.207.61.48])
        by outbound2.eu.mailhop.org (Halon) with ESMTPSA
        id 7372ed69-3231-11ec-a070-973b52397bcb;
        Thu, 21 Oct 2021 05:40:53 +0000 (UTC)
Received: from hsi-kbw-109-193-149-228.hsi7.kabel-badenwuerttemberg.de ([109.193.149.228] helo=x1.stackframe.org.stackframe.org)
        by mail.duncanthrax.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <svens@stackframe.org>)
        id 1mdQos-00BsFc-Je; Thu, 21 Oct 2021 08:40:50 +0300
From:   Sven Schnelle <svens@stackframe.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        Helge Deller <deller@gmx.de>
Subject: Re: [PATCH] mpt3sas: add NULL check in _base_fault_reset_work()
References: <20211019191208.6546-1-svens@stackframe.org>
        <yq11r4f84er.fsf@ca-mkp.ca.oracle.com>
Date:   Thu, 21 Oct 2021 07:40:48 +0200
In-Reply-To: <yq11r4f84er.fsf@ca-mkp.ca.oracle.com> (Martin K. Petersen's
        message of "Wed, 20 Oct 2021 23:08:29 -0400")
Message-ID: <87zgr30wbj.fsf@x1.stackframe.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

>> My HP C8000 (an PA-RISC based system) crashed with an HPMC. That
>> triggered the HPMC handler in the kernel, and i got a crash in
>> _base_fault_reset_work() from mpt3sas. It looks like this function
>> calls ioc->schedule_dead_ioc_flush_running_cmds() without checking
>> whether there's actually a function set, so it dereferences a NULL
>> pointer on that system. The c8000 actually uses the mptspi driver
>> instead of mpt3sas which doesn't seem to set this handler.
>
> I'm not sure how you end up in the mpt3sas driver if your system uses
> mptspi!?
>
> Can you please send us the HPMC and the output of lspci?

It doesn't end up in mpt3sas, i was just confused because
schedule_dead_ioc_flush_running_cmds() exist also there. If you look at
the diff, you see that i patched the mptspi driver. So the description
is just wrong, sorry.

I'll try to see whether i can reproduce it once more, but the question
still is whether the if () check is okay, or whether that needs more
work (i.e., a handler for that)

Regards
Sven
