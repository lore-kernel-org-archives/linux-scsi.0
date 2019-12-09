Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2EB8C43603
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 03:28:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B90CF20721
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 03:28:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GJ0pnG1f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfLID16 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Dec 2019 22:27:58 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:38709 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbfLID16 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Dec 2019 22:27:58 -0500
Received: by mail-io1-f66.google.com with SMTP id u7so13214711iop.5;
        Sun, 08 Dec 2019 19:27:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0FouoOQuKK8TWngYJA/GA/cY7odjlRWi1G+ri92AHok=;
        b=GJ0pnG1fwCKvZfvUNbmR+mXbDxy7BDiJ8XjhFpM4PDyg8/gsH0Lk7kx7OVwjyQcttF
         n0UHUF/IxkMIvtz/WsvPZCZXQXAcK4JfFI6wpzWPgUFutBzzPwTsbVeNW3AqlZnKcM06
         3UgLdjBiKL2FH0994RZ8l+S4hruLeq2ZrQYFvA7s8wsBaVOD7MdmodOvjqHqAZwLdiEL
         BlepVE6oQDNXI5vcEvseqe52VkgtxigV9ZUftuukoRrUcUb+GXYauv4CNvy8OAq4tBvL
         2/21cQ7CXH/4v7qkZWGmtzMEH6dX0/ChY8JcFjV9QOmBGHrttbVhUSIWPqD6MhqIMG21
         yCDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0FouoOQuKK8TWngYJA/GA/cY7odjlRWi1G+ri92AHok=;
        b=JwACYYIrG+bGTUTaXeuYy8xnjA4azM295CKW56QZZTTYOYH52gSlCPNJArETvPh1Bi
         6iGUdDQgTdH/sFg0+U8mMsFLUk6JVYAT7HRcGM1I8oHE0B4DkGvYVnNys2vasGaGstbN
         PZIuuciLkP4swy/Cr0NaeE0GpD05KW3vqsGUOSzv/l1e5UgWMiua6S2mteHEWYayKDbK
         RNOolipqYmTQOa4994QpTWiiLKAQJyiVPryUFb5mln3Gdq39cRDNySU+2rX7aloTti7e
         603NENQlWBrJpzzSCeNGqXUD1S9efmOmpp0EzyesYT5pvAshsonvCL3BTK2fCjmrvY2b
         nbrg==
X-Gm-Message-State: APjAAAXz1iBoDSYvclIZ04G3F/mXfLU+ygDldorvhnrEEZ7MuHSPyE3P
        zqwrHVQpjZLq9oVLaXO1BNGKVyD5D3gRjgJ4uYU=
X-Google-Smtp-Source: APXvYqzgeB29ALYb48m6slSqtGesqdCe/hGojRRnRSwzJbuXt6Jfknw5Veq4Xd3737fp7gWA6f/hBlJXlxPC9W/kQ3o=
X-Received: by 2002:a05:6602:2504:: with SMTP id i4mr19728124ioe.173.1575862077258;
 Sun, 08 Dec 2019 19:27:57 -0800 (PST)
MIME-Version: 1.0
References: <30808b0b-367a-266a-7ef4-de69c08e1319@internode.on.net>
 <09396dca-3643-9a4b-070a-e7db2a07235e@internode.on.net> <CAHk-=wjj8SQx4YzS8yw7ZJJKiVLBY0g=d8rCSyPCM=8Pzmz+Zg@mail.gmail.com>
 <CAH2r5mvAv651DcX0--8oRYR8BXmBr8F=ymeBVDXm5YoQfcnK2A@mail.gmail.com>
In-Reply-To: <CAH2r5mvAv651DcX0--8oRYR8BXmBr8F=ymeBVDXm5YoQfcnK2A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 8 Dec 2019 21:27:46 -0600
Message-ID: <CAH2r5ms_BXSYRUxWvzNiwYHZFTqRoqo8gEfdz+ZcT1fYmLUgUg@mail.gmail.com>
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

Arthur,
If you want to avoid the issue which causes the oops you can remove
this one line change (see below) but I (or Ronnie) will post a patch
for this - but wanted to discuss with him briefly first.

# git show 72e73c78c446e
commit 72e73c78c446e3c009a29b017c7fa3d79463e2aa
Author: Ronnie Sahlberg <lsahlber@redhat.com>
Date:   Thu Nov 7 17:00:38 2019 +1000

    cifs: close the shared root handle on tree disconnect

    Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 05149862aea4..acb70f67efc9 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1807,6 +1807,8 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
        if ((tcon->need_reconnect) || (tcon->ses->need_reconnect))
                return 0;

+       close_shroot(&tcon->crfid);
+
        rc = smb2_plain_req_init(SMB2_TREE_DISCONNECT, tcon, (void **) &req,
                             &total_len);
        if (rc)

On Sun, Dec 8, 2019 at 9:18 PM Steve French <smfrench@gmail.com> wrote:
>
> On Sun, Dec 8, 2019 at 8:23 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Sun, Dec 8, 2019 at 5:49 PM Arthur Marsh
> > <arthur.marsh@internode.on.net> wrote:
> > >
> > > This still happens with 5.5.0-rc1:
> >
> > Does it happen 100% of the time?
>
> I can reproduce it (although it was a little more difficult since WiFi doesn't
> work on RC1 on some of my hardware - due to the 802.11 driver regression oops.
> I was able to reproduce it to Samba localhost).
>
>
> > Your bisection result looks pretty nonsensical - not that it's
> > impossible (anything is possible), but it really doesn't look very
> > likely. Which makes me think maybe it's slightly timing-sensitive or
> > something?
>
> The bisection result is implausible.  I just did some experiments and
> it looks far more likely is that it is related to commit
> 72e73c78c446e ("cifs: close the shared root handle on tree disconnect")
> so added Ronnie to the cc.  That patch added a call (at unmount time)
> to close_shroot.
> The idea of that patch made sense - although tree disconnect (and then
> logoff of the session)
> will indirectly free any open handles on the server for that session,
> it is a little
> cleaner to close the cached root SMB3 file handle explicitly.
>
> void close_shroot(struct cached_fid *cfid)
> {
>         mutex_lock(&cfid->fid_mutex);
>         kref_put(&cfid->refcount, smb2_close_cached_fid);
>         mutex_unlock(&cfid->fid_mutex);
> }
>
>
> Taking out the one line change in the patch from last week that calls
> close_shroot from
> umount (SMB2_tdis, ie tree_disconnect) I don't see the problem so far
> more likely
> that it is related to that commit.   The problem seems to be related
> to servers which
> don't support directory leases.  Will spin up a patch to fix this if
> Ronnie hasn't already fixed it



-- 
Thanks,

Steve
