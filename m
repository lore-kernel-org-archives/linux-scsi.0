From: Andries.Brouwer@cwi.nl
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Tue, 23 Sep 2003 16:37:08 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200309231437.h8NEb8N23975.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:63929 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S261293AbTIWOlD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2003 10:41:03 -0400
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl, James.Bottomley@steeleye.com
Cc: david-b@pacbell.net, greg@kroah.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-usb@one-eyed-alien.net, patmans@us.ibm.com, stern@rowland.harvard.edu, torvalds@osdl.org

    From James.Bottomley@SteelEye.com  Tue Sep 23 16:05:21 2003

    > Also "conservative mode" sounds like a flag that describes some
    > way of being broken.
    > 
    > On the other hand "hot-pluggable" describes a positive asset,
    > and if we can conclude from that that it is unnecessary to ask
    > for mode page 8 then we achieve the same effect in a positive way.

    I disagree on this one.  hot-pluggable sounds like it should be set for
    ever hotplug device (currently that would include firewire, which may be
    iffy, and Fibre Channel, which has our highest level of SCSI compliance
    and would definitely be wrong).

Why would it be wrong?

    The design goal is that this flag makes sd assume as little SCSI
    standards compliance as it can get away with while still operating the
    device.

No, the design goal of "hot-pluggable" is that it indicates that
the device can disappear any moment. Nothing at all about SCSI
compliance.

Pulling out a device while it is actively reading or writing
will probably break something. But if a device is hot-pluggable
it should be OK to pull it out when it has been inactive for
a second or so.

But if that is really true, then it should not be necessary
to send the device any "synchronise cache" commands when we
shut down.

And if no such commands will be sent anyway, then we need not ask
the device about its type of cache.

And if we do not ask, then we need not worry whether the device
is sufficiently compliant to answer such a question.

Andries
