From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: [dm-devel] [multipath] SCSI device capacity mess
Date: Wed, 27 Oct 2004 21:02:39 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098903759.12464.32.camel@zezette>
References: <1098833278.4914.24.camel@zezette>
	 <20041027081713.GC32712@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp5.wanadoo.fr ([193.252.22.26]:60845 "EHLO
	mwinf0512.wanadoo.fr") by vger.kernel.org with ESMTP
	id S262640AbUJ0TCl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2004 15:02:41 -0400
In-Reply-To: <20041027081713.GC32712@marowsky-bree.de>
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> > Some SAN hardware present for a same LUN a bunch of valid paths and  a
> > bunch ghost paths. In my case, the ghosts responds to standard INQUIRY
> > (EVPD 0x83, 0x80, ...) but the READ_CAPACITY fails :
> 
> As a note, this is one mode the EMC CLARiiON arrays can also operate in.
> Even worse, they won't present the block device at all, just the SCSI
> generic mode. However, for the CLARiiONs, they can be configured to
> behave sanely and reply to a READ_CAPACITY too (just all I/O will be
> errored), if setting the failovermode to 1.
> 
> I wonder whether your system can also be configured as such?
> 
Yes it could, but it's a controler wide setting.

Compatibility with other OS sharing the same controlers might impose
this mode though. So I'd like to straight this situation up.

> > 
> > 1) make the /sys/block/*/size attribute writable
> > 2) resurrect a BLKSETSIZE ioctl
> > 3) make device-mapper less strict, and hope we can fix the size by a
> > device rescan when it get activated
> > 4) sell the culprit hardware
> 
> Personally I would opt for 4), but 3) is the likely path to solve this.
> 
> Using the new priority group initialization code (where we sent magic
> commands down to activate the newly switched-to PG) which Alasdair and I
> are currently doing for the CLARiiON pampering and which provides a
> plugin-architecture to the dm-mpath system, you should be able to plug
> in a hardware-specific handler for your system too.
> 
> However, "relaxing" this check should likely also be a property of the
> hardware plugin loaded; I'd not wish to have it relaxed in all
> scenarios.
> 
I wonder if it's not simpler just to remove the NOSTARTONADD flag on
this devices in scsi_devinfo.c. I tested that and all the READ CAPACITY
succeed as expected (DEC HSG80 / COMPAQ HSV*).

Wasn't this flag in part motivated by the lack of multipath support
anyway ?

Even in a cluster context, I don't really buy the annoyance of
occasional LUN ping-pong.

regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>

