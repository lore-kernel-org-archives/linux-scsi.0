From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [ATTEND]
Date: Tue, 7 Feb 2012 19:45:39 -0800
Message-ID: <CAH+dOx+4mL0uMBAjv+zo+XGJvaZvushYT5=Ev=8K8-zVhLHR2w@mail.gmail.com>
References: <CAH+dOxKMwMskM18=GhBmEao4aSvZmccSiZmmnZm42TBMPUFONw@mail.gmail.com>
	<D3F292ADF945FB49B35E96C94C2061B915D0A6CB@nsmail.netscout.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:33139 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab2BHDpk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2012 22:45:40 -0500
Received: by qafk1 with SMTP id k1so133181qaf.19
        for <linux-scsi@vger.kernel.org>; Tue, 07 Feb 2012 19:45:39 -0800 (PST)
In-Reply-To: <D3F292ADF945FB49B35E96C94C2061B915D0A6CB@nsmail.netscout.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Loke, Chetan" <Chetan.Loke@netscout.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, dedekind@infradead.org

On Tue, Feb 7, 2012 at 3:31 PM, Loke, Chetan <Chetan.Loke@netscout.com> wrote:
> I came across UBIFS when I was looking to implement just a backing
> device. So I'm trying to understand if you looked at UBIFS and if parts
> of that could have been used(or if they are used already?). Because in
> the end we need to create an erase-aware FS(without the usual
> defrag/syscall/etc support) and manage that in conjunction with
> block-layer. Agreed that UBIFS is a generic FS. But we also need to
> worry about erase-cycles/counters etc
> (http://lxr.linux.no/#linux+v3.2.5/Documentation/filesystems/ubifs.txt#L
> 12 - all the 5 points). Plus, it supports on-the-fly compression. I've
> never used UBIFS. So I don't know how it performs. May be we could just
> pick UBI's FS part and stick that with your block-layer code?

I don't quite follow what you're trying to do - you want to turn raw
flash into a block device, i.e. an ftl?

Bcache is pretty close to being an ftl, and I think what's left will
get finished off sooner or later (I recently implemented flash only
volume support, it works and it's fast but I haven't implemented the
copying garbage collector yet so internal fragmentation limits its
usefulness. It's basically a thin provisioning volume manager for
flash, though).

As far as using bcache for the bottom of a real filesystem - I
definitely want to do that. I haven't looked at ubifs at all; I was
thinking exofs might be a decent starting point, ubifs hadn't crossed
my mind.

There's a bunch of fun things we could do with it, though. After
multiple cache device support is done (there's not much left - it's
just been at the bottom of the todo list) I'm going to write an
allocator more suitable for rotating disks and then it'll do volume
management + thin provisioning + caching, all with the same index. The
btree is outrageously fast now, too - if there's another btree out
there that comes close I'd really like to know.
