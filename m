From: Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Mon, 3 Feb 2014 23:15:43 +0100
Message-ID: <CAPXgP13yiD3Fk7NpgRqac5vj=OVuav=P1LXLp4Lty9G2ws9pnQ@mail.gmail.com>
References: <1391157974-17512-1-git-send-email-hare@suse.de>
 <52EBD2BB.8020705@tributary.com> <52ECFF7B.7000401@suse.de>
 <60EE5D9C-A799-4C8D-8962-DB9D7C1C8414@kolumbus.fi> <52EE2F2D.1010300@suse.de>
 <52EFACA4.6060001@tributary.com> <52EFB06C.8010101@suse.de>
 <52EFB0E7.3000504@tributary.com> <CAPXgP13dn+VGpu0OLHatUvP4TRDp2YEgCXYB837ReADZTWg_NA@mail.gmail.com>
 <52F010F9.5090305@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:52783 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaBCWQE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2014 17:16:04 -0500
Received: by mail-qc0-f169.google.com with SMTP id w7so12361462qcr.28
        for <linux-scsi@vger.kernel.org>; Mon, 03 Feb 2014 14:16:03 -0800 (PST)
In-Reply-To: <52F010F9.5090305@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: Hannes Reinecke <hare@suse.de>, =?UTF-8?B?S2FpIE3DpGtpc2FyYSAoS29sdW1idXMp?= <kai.makisara@kolumbus.fi>, James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Doug Gilbert <dgilbert@interlog.com>

On Mon, Feb 3, 2014 at 10:58 PM, Jeremy Linton <jlinton@tributary.com> wrote:
> On 2/3/2014 2:51 PM, Kay Sievers wrote:
>> This is not simple and not going to happen. Sibling devices in /sys cannot
>> have a relationship in udev, there are only parent/child dependencies.
>
>         Ok.. so if we can't ignore all the "spare" device nodes in a given /sys entry
> for a given device. Why open the device to scan it?
>
>         I've often wondered why the serial number isn't part of the data in /sys
> along with the manufacture/model. The last tape drive I saw that failed to
> respond to inquiry page 0x80 was over a decade ago (probably manufactured in
> the early 90s). So enabling it just for tape is pretty safe.
>
>
>         Matching Manufacturer/model/serial is going to be better than anything your
> going to get out of 0x83 anyway. That data is guaranteed to be there, but its
> also guaranteed to be unreliable (every device, and every port has a slightly
> different set of descriptors they choose to support).
>
>         Plus, your not going to have issues accidentally rewinding a device, or
> resetting a tape density, or accidentally turning compression off if you don't
> open the device.

Well, the predictable symlink for tapes stuff is all pretty old, and
got through quite a few changes over the years. Not sure how much the
/dev/tape/by-*/ links are really used in the field, and what people
really expect here.

(Mis-)using one of the various open() flags which do not make sense
for SG_IO or tapes, which would prevent any state changes still sounds
like the most convincing option to me. In the end it's always the
nicer interface if the device node itself can be used to identify the
device, instead of jumping through /sys or adding more proping caches
to the kernel.

>> Hannes, can't you just drop the weird auto-rewinding device matches from
>> the persistent rules, is that really useful today?
>
>         The relationship between the st and nst devices is leveraged by a large
> number of backup applications in the field. If you change it, its likely lots
> of breakage will ensue.

Sure, but do they really expect the additional symlinks udev creates?
We are not talking about the primary device nodes, only about the
additional /dev/tape/by-*/ links.

Kay
