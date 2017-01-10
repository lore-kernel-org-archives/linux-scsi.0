From: =?UTF-8?Q?Dainius_Masili=C5=ABnas?= <pastas4@gmail.com>
Subject: Re: Advanced Format SAT devices show incorrect physical block size
Date: Tue, 10 Jan 2017 21:42:10 +0000
Message-ID: <CABhjJhPCFRgpxcBDDCrkcCq0KMenUoOo0+J7je1Q=RM0Rdp+kg@mail.gmail.com>
References: <CABhjJhOp1GB0KXupWhDh-5v-+6N8=qA=rE9L21AANhdN5C0Bxg@mail.gmail.com>
 <Pine.LNX.4.44L0.1701101551591.2462-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:36636 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752620AbdAJVmM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2017 16:42:12 -0500
In-Reply-To: <Pine.LNX.4.44L0.1701101551591.2462-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Tom Yan <tom.ty89@gmail.com>

On Tue, Jan 10, 2017 at 9:00 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> It is used for preventing the kernel from issuing a READ CAPACITY(16)
> command to the device.  Normally the kernel would do this if the reply
> to READ CAPACITY(10) indicated there were more than 2^32 blocks (about
> 2 TB).

Ah, OK, that makes sense. Though that's still not a proper solution,
and if anything it's confusing for the users: if they plug in a >2 TiB
drive and it breaks, the user will assume that it's the fault of the
drive and not the USB case, or that the case is incapable of handling
such large drives, whereas the true reason is completely different.

> In theory, I suppose we could change the kernel so that it would
> default to READ CAPACITY(16) for devices that report a SCSI level >= 3,
> or something along those lines.  In general we hesitate to make changes
> of this sort, because they almost always end up breaking _some_
> devices -- and if that happens then the change is reverted, with no
> exceptions.  Linus has a very strict rule about not breaking working
> systems.

Well, the problems are 1) we don't really know how many such
misbehaving drives there are, since only those with >2 TiB drives
experience it, thus it's hard to know what effect such change would
have, and 2) there is no way to make the kernel output the true value
even if you know your drive is working fine.

And when a drive breaks due to the 16 command, is there a way to
revive it, perhaps by trying to reconnect? That would allow the kernel
to try it first, see that it failed after that command was sent, then
issue a warning in the log saying that this device should have a
quirk, reset and continue with the quirk applied.

Also, is `sg_readcap -16` a proper test to determine whether the
device works as expected?
