From: Matthias Eble <psychotrahe@gmail.com>
Subject: Re: Open/INQUIRY fails on RESERVE'd tape device
Date: Fri, 24 Jan 2014 22:48:52 +0100
Message-ID: <CAKbOo_J8c3YTg4NjUdtyFhG6WOrur4hFMnRMZ7u7LcL53O=o6A@mail.gmail.com>
References: <CAKbOo_KDVtCw1U7wD7L=aE-qug-3UwQQkDjuvyG2_xVEA8tnvg@mail.gmail.com>
	<52E2886F.3060604@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:49568 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaAXVsy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2014 16:48:54 -0500
Received: by mail-lb0-f181.google.com with SMTP id z5so3003226lbh.12
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jan 2014 13:48:52 -0800 (PST)
In-Reply-To: <52E2886F.3060604@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi all,

2014/1/24 Jeremy Linton <jlinton@tributary.com>:
> On 1/23/2014 4:02 PM, Matthias Eble wrote:
>> So: should open() fail on a reserved tape device?
>
>         Yes, this is expected behavior for tape devices, reserve 6/release is sometimes
> used by backup applications in SAN environments as an arbitration mechanism
> across multiple machines.

You hit the nail on the head. Problem is that our backup application
does inquiry on /dev/nst*,
which is broken when the same application uses RESERVE/RELEASE.

>         Its not that the INQUIRY is failing, its that the st open sequence is doing a
> reserve/TUR/etc during the open.

This is exactly what I am facing. I just thought that it might not be
OK to issue these commands with st_open. But I guess, there is no
right or wrong it's just implemented that way - so applications need
to deal with it and use a generic device.

>         If that fails then you can't open the drives sufficiently to send a inquiry via
> pass-through. In some environments you can bypass that processing with
> O_NDELAY/O_NONBLOCK. Or you just use the sg device which doesn't perform the
> tape open processing that st does.

I guess you mean operating systems with environments, as sg_vpd
also uses O_NONBLOCK, which doesn't help:
  open("/dev/st15", O_RDONLY|O_NONBLOCK)  = -1 EIO (Input/output error)

But as this behaviour has been there for long time, the backup vendor
needs to fix it IMO.

Thanks to all of you
Matthias
