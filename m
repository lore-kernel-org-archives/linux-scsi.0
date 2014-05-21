From: Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH 0/2] scsi: hyper-v storvsc changes by Ubuntu
Date: Wed, 21 May 2014 15:24:36 +0100
Message-ID: <CAO=4fJMamZvda-EKQx7SwH8yf8Q4YMR+gkhH7Yy0mUYHZZM0iA@mail.gmail.com>
References: <1400254748-21573-1-git-send-email-abbotti@mev.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:41974 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaEUOYg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2014 10:24:36 -0400
Received: by mail-qg0-f51.google.com with SMTP id q107so3281519qgd.24
        for <linux-scsi@vger.kernel.org>; Wed, 21 May 2014 07:24:36 -0700 (PDT)
In-Reply-To: <1400254748-21573-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ian Abbott <abbotti@mev.co.uk>
Cc: linux-scsi@vger.kernel.org, devel@linuxdriverproject.org, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Tim Gardner <tim.gardner@canonical.com>

On 16 May 2014 16:39, Ian Abbott <abbotti@mev.co.uk> wrote:
> These changes to the Microsoft Hyper-V storage driver in Ubuntu Saucy's
> 3.13 kernel look useful for the mainline kernel, especially as they
> enable 'TRIM' support.
>
> Andy Whitcroft (2):
>   scsi: hyper-v storvsc switch up to SPC-3
>   scsi: hyper-v storvsc -- host takes MAINTENANCE_IN commands badly --
>     elide them
>
>  drivers/scsi/storvsc_drv.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)


The back story here is a little complex.  The main issue is that the
Hyper-V drives claim to be SPC-2, and yet implement the SPC-3
extensions for TRIM.  We did attempt to upstream quirks to allow these
features to be negotiated specifically for the Hyper-V virtual drives
(minimum regression potential) but these were NAKd, and it was
suggested that just overriding the Hyper-V drives to SPC-3
unconditionally was more appropriate.  The first of the patches here
does does this.  This has been sitting in our tree for some time as it
was not clear that this would be entirely safe, though the SPC-3 bits
are in theory at least mostly detected.  That said this change has
been in Ubuntu for a full cycle now and does not seem to have caused
any issues.  If KY is happy we should likely submit it formally.  The
second fix I believed was already being submitted to mainline.

KY?

-apw
