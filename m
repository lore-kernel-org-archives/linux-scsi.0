Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B57AC43603
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 03:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70B7A2071A
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 03:19:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZptXpSDh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfLIDTD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Dec 2019 22:19:03 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:36748 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbfLIDTD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Dec 2019 22:19:03 -0500
Received: by mail-il1-f194.google.com with SMTP id b15so11469808iln.3;
        Sun, 08 Dec 2019 19:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZP/DTKsRxd9x57rsuKi8rjLFwHgduCkLhdBpzRruD/w=;
        b=ZptXpSDhjq8fSMtsFkMdbzfmlB939M/2rbME2gXYrx419Yu8kgJxcJVzTcYzXavcYm
         Ed0GRd/uxVxTj5vKNdiUgpwmPDZEHML4kMMtAmlOd05dIBpH1xqwMlD1MdOtDDEua7eQ
         kyLjuaV7DH6TXgGqS5RlJxQwZmjCkvoisiLGb+ygv1nxeXTabKCji2imYOXkmcEmtvBP
         B2K0iR7PZ2/4WMIcKVyYgUANVebXvotyUry/5ge/inl6ZdJkNDDPPkLpX1/Vi3l57s8J
         1q/PT919jpr9DTfP1vy9GblNmCz87eG+sbb3FBRQtYekYdeTvfeSLgN2bK244NzjRiVl
         QPaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZP/DTKsRxd9x57rsuKi8rjLFwHgduCkLhdBpzRruD/w=;
        b=P7vFI33wjkczLSRBfJp0SFgm2gJSKX47XZCTQ5lSwChkHHFyuY459kKM1Ae2nkLJPL
         1InGsRJPVydoOAZ1dKIFdW/bmS44i4mK3npFZei809gxUQagn/KMA4g++RsEblNPhlgO
         Xl6MOS1OakeD+5CnYJkbivgxuvMCf34DQRgjNnTA6GXQkAbiJ+zLfcc+y+Yve/Qf3nJJ
         wcaVg2Z0msDCUz0XC7EMdzy+aIGBJak+Vm5K665OCTd9xATWQKE9qLRTlkrK6RH/t5hZ
         RsBj+HtyCcXnJpHADjMLRXTGfXRIiMerXalpUcCE16jG8cl6LlEp/illNKpUHtL3e9cJ
         gslg==
X-Gm-Message-State: APjAAAV1QmaD2Zj661saXA5PQxMBJzyuC12YEjU8EPXiggUigITRmxId
        CR1pugD9793PSQLHAMfJpBT1NWYJsNfPTPIXKL0=
X-Google-Smtp-Source: APXvYqw1T/CjK18NVu5fCfSpv0DdJ/Q859PkDoWYZRQARGF3edcc+8tR3ocf9sjDqKEeeEb0bzfe+p6ty4AHsGBag1s=
X-Received: by 2002:a92:d642:: with SMTP id x2mr26470036ilp.169.1575861542470;
 Sun, 08 Dec 2019 19:19:02 -0800 (PST)
MIME-Version: 1.0
References: <30808b0b-367a-266a-7ef4-de69c08e1319@internode.on.net>
 <09396dca-3643-9a4b-070a-e7db2a07235e@internode.on.net> <CAHk-=wjj8SQx4YzS8yw7ZJJKiVLBY0g=d8rCSyPCM=8Pzmz+Zg@mail.gmail.com>
In-Reply-To: <CAHk-=wjj8SQx4YzS8yw7ZJJKiVLBY0g=d8rCSyPCM=8Pzmz+Zg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 8 Dec 2019 21:18:51 -0600
Message-ID: <CAH2r5mvAv651DcX0--8oRYR8BXmBr8F=ymeBVDXm5YoQfcnK2A@mail.gmail.com>
Subject: Re: refcount_t: underflow; use-after-free with CIFS umount after
 scsi-misc commit ef2cc88e2a205b8a11a19e78db63a70d3728cdf5
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Arthur Marsh <arthur.marsh@internode.on.net>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Dec 8, 2019 at 8:23 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sun, Dec 8, 2019 at 5:49 PM Arthur Marsh
> <arthur.marsh@internode.on.net> wrote:
> >
> > This still happens with 5.5.0-rc1:
>
> Does it happen 100% of the time?

I can reproduce it (although it was a little more difficult since WiFi doesn't
work on RC1 on some of my hardware - due to the 802.11 driver regression oops.
I was able to reproduce it to Samba localhost).


> Your bisection result looks pretty nonsensical - not that it's
> impossible (anything is possible), but it really doesn't look very
> likely. Which makes me think maybe it's slightly timing-sensitive or
> something?

The bisection result is implausible.  I just did some experiments and
it looks far more likely is that it is related to commit
72e73c78c446e ("cifs: close the shared root handle on tree disconnect")
so added Ronnie to the cc.  That patch added a call (at unmount time)
to close_shroot.
The idea of that patch made sense - although tree disconnect (and then
logoff of the session)
will indirectly free any open handles on the server for that session,
it is a little
cleaner to close the cached root SMB3 file handle explicitly.

void close_shroot(struct cached_fid *cfid)
{
        mutex_lock(&cfid->fid_mutex);
        kref_put(&cfid->refcount, smb2_close_cached_fid);
        mutex_unlock(&cfid->fid_mutex);
}


Taking out the one line change in the patch from last week that calls
close_shroot from
umount (SMB2_tdis, ie tree_disconnect) I don't see the problem so far
more likely
that it is related to that commit.   The problem seems to be related
to servers which
don't support directory leases.  Will spin up a patch to fix this if
Ronnie hasn't already fixed it
