From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: st.ko with usb-storage problems
Date: Mon, 15 Sep 2003 21:08:14 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0309152048550.1409@kai.makisara.local>
References: <20030914174104.A20722@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep21-1.kolumbus.fi ([193.229.5.121]:6885 "EHLO
	fep21-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261203AbTIOSIQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Sep 2003 14:08:16 -0400
In-Reply-To: <20030914174104.A20722@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: USB Developers <linux-usb-devel@lists.sourceforge.net>, Linux SCSI list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On Sun, 14 Sep 2003, Matthew Dharm wrote:

> (NOTE: Cross-posted to several lists.  Watch your replies.)
>
> For a while now in 2.5 and 2.6, I've been getting reports of an
> incompatibility between st.ko and the usb-storage driver.  I've finally
> managed to figure out the problem; it only affects certain hardware, and
> only on certain operations.
>
...
> When st.ko goes to do a read, it will create a scatter-gather list with
> (what looks like) a mapping of the user-space buffer.  This often results
> in not-so-nicely sized segments, which are often a multiple of 8, but not
> 64, 128, or 512 (which are the common USB packet sizes).  This causes a
> problem for the USB host-controller hardware, and the transfer fails.
>
The glibc malloc() function returns memory allocated at 8 byte boundaries
(16 bytes for 64-bit systems).

> Why this doesn't happen on a write is something of a mystery to me, but it
> doesn't seem to happen.
>
The user space buffer alignment depends on the application. Was the write
buffer accidentally or on purpose properly aligned? This is the only
explanation that comes to my mind.

> If the module flag 'try_direct_io' is set to 0 (not the default), then
> st.ko doesn't generate scatter-gather lists at all, and all is well.
>
st can use s/g lists also when try_direct_io. It tries to allocate the
driver buffer using as big chunks as possible and this is why the buffer
is usually contiguous in physical memory for reasonable buffer sizes. The
driver buffer is allocated using get_free_pages() and so each segment size
should be divisible by 512 even if s/g is used.

> It's not immediately clear to me how to fix this.  First, I need to figure
> out why 2.4 kernels don't show this problem, I think.  Help from people who
> understand st.ko would be appreciated.
>
The 2.4 driver does not do direct transfers between user buffer and
device. It was added in 2.5.

The simple solution would be for st to set try_direct_io to zero if the
HBA does not support arbitrary alignment. The problem is that (AFAIK) this
information is not currently available to the high level driver.

-- 
Kai
