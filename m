Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D83BC4741F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 11:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F8F621481
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 11:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601552913;
	bh=0SS/1CUEH6KOZaR1vNXQSO0iQE6lB5yr3hxEdMoHOcw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=fIRbKxihSTTHLqD+uW1W6MYEMb7SG1qYnRqODFTZ8QyXo/yrtB/FZlhbc1wPJRwuB
	 UkO3DVd0I6JMOGYcyVs6EDywAmLQLHuop64VXhGDDBf0+XxDGlq79wN43Dj5VpuZX9
	 JKkCEaOToc//DV0AHDnPpU51PVgKdjkhqHwy6PwU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731921AbgJALsc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 07:48:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731826AbgJALsc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Oct 2020 07:48:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 320DA20B1F;
        Thu,  1 Oct 2020 11:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601552911;
        bh=0SS/1CUEH6KOZaR1vNXQSO0iQE6lB5yr3hxEdMoHOcw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qfP2ToTp3qu+2pfCjVkt1eSreNq9ISTIAj7AbmRHBGl/973Ouzr27DvwRf3sJhLxL
         0VGuBQCqBfM7iUfu/svafiF47/iDbmQ4+cMY0VA8E55WdV7OSeromPlfrrF8/r+oa8
         zRMOSfScuJbcZ7fxpTIAHoYo78QvlmNTCDnFgmoo=
Date:   Thu, 1 Oct 2020 13:48:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tony Asleson <tasleson@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [v5 01/12] struct device: Add function callback durable_name
Message-ID: <20201001114832.GC2368232@kroah.com>
References: <20200925161929.1136806-1-tasleson@redhat.com>
 <20200925161929.1136806-2-tasleson@redhat.com>
 <20200929175102.GA1613@infradead.org>
 <20200929180415.GA1400445@kroah.com>
 <20e220a6-4bde-2331-6e5e-24de39f9aa3b@redhat.com>
 <20200930073859.GA1509708@kroah.com>
 <c6b031b8-f617-0580-52a5-26532da4ee03@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6b031b8-f617-0580-52a5-26532da4ee03@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 30, 2020 at 09:35:52AM -0500, Tony Asleson wrote:
> On 9/30/20 2:38 AM, Greg Kroah-Hartman wrote:
> > On Tue, Sep 29, 2020 at 05:04:32PM -0500, Tony Asleson wrote:
> >> I'm trying to figure out a way to positively identify which storage
> >> device an error belongs to over time.
> > 
> > "over time" is not the kernel's responsibility.
> > 
> > This comes up every 5 years or so. The kernel provides you, at runtime,
> > a mapping between a hardware device and a "logical" device.  It can
> > provide information to userspace about this mapping, but once that
> > device goes away, the kernel is free to reuse that logical device again.
> > 
> > If you want to track what logical devices match up to what physical
> > device, then do it in userspace, by parsing the log files.
> 
> I don't understand why people think it's acceptable to ask user space to
> parse text that is subject to change.

What text is changing?  The format of of the prefix of dev_*() is well
known and has been stable for 15+ years now, right?  What is difficult
in parsing it?

> >> Thank you for supplying some feedback and asking questions.  I've been
> >> asking for suggestions and would very much like to have a discussion on
> >> how this issue is best solved.  I'm not attached to what I've provided.
> >> I'm just trying to get towards a solution.
> > 
> > Again, solve this in userspace, you have the information there at
> > runtime, why not use it?
> 
> We usually don't have the needed information if you remove the
> expectation that user space should parse the human readable portion of
> the error message.

I don't expect that userspace should have to parse any human readable
portion, if they don't want to.  But if you do want it to, it is pretty
trivial to parse what you have today:

	scsi 2:0:0:0: Direct-Access     Generic  STORAGE DEVICE   1531 PQ: 0 ANSI: 6

If you really have a unique identifier, then great, parse it today:

	usb 4-1.3.1: Product: USB3.0 Card Reader
	usb 4-1.3.1: Manufacturer: Generic
	usb 4-1.3.1: SerialNumber: 000000001531

What's keeping that from working now?

In fact, I would argue that it does seem to work, as there are many
commercial tools out there that seem to handle it just fine...

> >> We've looked at user space quite a bit and there is an inherit race
> >> condition with trying to fetch the unique hardware id for a message when
> >> it gets emitted from the kernel as udev rules haven't even run (assuming
> >> we even have the meta-data to make the association).
> > 
> > But one moment later you do have the information, so you can properly
> > correlate it, right?
> 
> We could have the information if all the storage paths went through
> dev_printk.  Here is what we get today when we encounter a read error
> which uses printk in the block layer:
> 
> {
>         "_HOSTNAME" : "pn",
>         "_TRANSPORT" : "kernel",
>         "__MONOTONIC_TIMESTAMP" : "1806379233",
>         "SYSLOG_IDENTIFIER" : "kernel",
>         "_SOURCE_MONOTONIC_TIMESTAMP" : "1805611354",
>         "SYSLOG_FACILITY" : "0",
>         "MESSAGE" : "blk_update_request: critical medium error, dev
> nvme0n1, sector 10000 op 0x0:(READ) flags 0x80700 phys_seg 3 prio class 0",
>         "PRIORITY" : "3",
>         "_MACHINE_ID" : "3f31a0847cea4c95b7a9cec13d07deeb",
>         "__REALTIME_TIMESTAMP" : "1601471260802301",
>         "_BOOT_ID" : "b03ed610f21d46ab8243a495ba5a0058",
>         "__CURSOR" :
> "s=a063a22bbb384da0b0412e8f652deabb;i=23c2;b=b03ed610f21d46ab8243a495ba5a0058;m=6bab28e1;t=5b087959e3cfd;x=20528862f8f765c9"
> }

Ok, messy stuff, don't do that :)

> Unless you parse the message text you cannot make the association.  If
> the same message was changed to dev_printk we would get:
> 
> 
> {
>         "__REALTIME_TIMESTAMP" : "1589401901093443",
>         "__CURSOR" :
> "s=caac9703b34a48fd92f7875adae55a2f;i=1c713;b=e2ae14a9def345aa803a13648b95429c;m=7d25b4f;t=5a58d77b85243;x=b034c2d3fb853870",
>         "SYSLOG_IDENTIFIER" : "kernel",
>         "_KERNEL_DEVICE" : "b259:917504",
>         "__MONOTONIC_TIMESTAMP" : "131226447",
>         "_UDEV_SYSNAME" : "nvme0n1",
>         "PRIORITY" : "3",
>         "_KERNEL_SUBSYSTEM" : "block",
>         "_SOURCE_MONOTONIC_TIMESTAMP" : "130941917",
>         "_TRANSPORT" : "kernel",
>         "_MACHINE_ID" : "3f31a0847cea4c95b7a9cec13d07deeb",
>         "_HOSTNAME" : "pn",
>         "SYSLOG_FACILITY" : "0",
>         "_BOOT_ID" : "e2ae14a9def345aa803a13648b95429c",
>         "_UDEV_DEVLINK" : [
>                 "/dev/disk/by-uuid/22fc262a-d621-452a-a951-7761d9fcf0dc",
>                 "/dev/disk/by-path/pci-0000:00:05.0-nvme-1",
> 
> "/dev/disk/by-id/nvme-nvme.8086-4445414442454546-51454d55204e564d65204374726c-00000001",
>                 "/dev/disk/by-id/nvme-QEMU_NVMe_Ctrl_DEADBEEF"
>         ],
>         "MESSAGE" : "block nvme0n1: blk_update_request: critical medium
> error, dev nvme0n1, sector 10000 op 0x0:(READ) flags 0x0 phys_seg 1 prio
> class 0",
>         "_UDEV_DEVNODE" : "/dev/nvme0n1"
> }

Great, you have a udev sysname, a kernel subsystem and a way to
associate that with a real device, what more are you wanting?

> Journald already knows how to utilize the dev_printk meta data.

And if you talk to the printk developers (which you seem to be keeping
out of the loop here), they are ripping out the meta data facility as
fast as possible.  So don't rely on extending that please.

> One idea that I've suggested along the way is creating a dev_printk
> function that doesn't change the message text.  We then avoid breaking
> people that are parsing.  Is this something that would be acceptable to
> folks?  It doesn't solve early boot where udev rules haven't even run,
> but it's better.

I still fail to understand the root problem here.

Ok, no, I think I understand what you think the problem is, I just don't
see why it is up to the kernel to change what we have today when there
are lots of tools out there working just fine without any kernel changes
needed.

So try explaining the problem as you see it please, so we all know where
to work from.

But again, cutting out the developers of the subsystems you were wanting
to modify might just be making me really grumpy about this whole
thing...

greg k-h
