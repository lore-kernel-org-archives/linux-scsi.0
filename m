From: Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Mon, 3 Feb 2014 21:51:38 +0100
Message-ID: <CAPXgP13dn+VGpu0OLHatUvP4TRDp2YEgCXYB837ReADZTWg_NA@mail.gmail.com>
References: <1391157974-17512-1-git-send-email-hare@suse.de>
 <52EBD2BB.8020705@tributary.com> <52ECFF7B.7000401@suse.de>
 <60EE5D9C-A799-4C8D-8962-DB9D7C1C8414@kolumbus.fi> <52EE2F2D.1010300@suse.de>
 <52EFACA4.6060001@tributary.com> <52EFB06C.8010101@suse.de> <52EFB0E7.3000504@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:34448 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbaBCUv6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2014 15:51:58 -0500
Received: by mail-qc0-f176.google.com with SMTP id e16so12167752qcx.35
        for <linux-scsi@vger.kernel.org>; Mon, 03 Feb 2014 12:51:58 -0800 (PST)
In-Reply-To: <52EFB0E7.3000504@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: Hannes Reinecke <hare@suse.de>, =?UTF-8?B?S2FpIE3DpGtpc2FyYSAoS29sdW1idXMp?= <kai.makisara@kolumbus.fi>, James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Doug Gilbert <dgilbert@interlog.com>

On Mon, Feb 3, 2014 at 4:08 PM, Jeremy Linton <jlinton@tributary.com> wrote:
> On 2/3/2014 9:06 AM, Hannes Reinecke wrote:
>
>> That's due to udev. Udev is getting events for each device it should create
>> a device node for. So for 'st' it'll get a series of events for 'stX', and
>> another series of events for 'nstX'. Udev will treat each of these events
>> separately, with distinct worker programs handling them. Each of those
>> workers run fully asynchronous and cannot access information from other
>> workers.
>
>         So whats wrong with the simple solution? You throw the ones for st away, and
> create the st handles from the nst worker.

This is not simple and not going to happen. Sibling devices in /sys
cannot have a relationship in udev, there are only parent/child
dependencies.

Hannes, can't you just drop the weird auto-rewinding device matches
from the persistent rules, is that really useful today?

Kay
