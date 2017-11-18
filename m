From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Seagate External SMR drive USB resets (XHCI transfer error, not
 timeout)
Date: Sat, 18 Nov 2017 11:57:19 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1711181151380.6642-100000@netrider.rowland.org>
References: <20171117171900.6bd47b90@Vantage.cJ>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:41901 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1423298AbdKRQ5V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Nov 2017 11:57:21 -0500
In-Reply-To: <20171117171900.6bd47b90@Vantage.cJ>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Jens <jens-bugzilla.kernel.org@spamfreemail.de>, Andrey Astafyev <1@246060.ru>, Oliver Neukum <oneukum@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 17 Nov 2017, Jérôme Carretero wrote:

> > Here's the error:
> > 
> > b5251480 0.505661 S Bo:6:008:2 -115 196608 = 540a2813 1a33dd99
> > ab76840c bf72fc6b 60f9fcaf 4d61822c c007ff4e ab72d022 b5251480
> > 0.506280 C Bo:6:008:2 -71 86016 >
> 
> Out of curiosity, which tool produced this condensed output?

I wrote a program for myself to translate pcap files into usbmon's text
format.  I find that format a lot easier to read than trying to deal
with wireshark's "one packet at a time" approach.

> > This means the kernel tried to write 196608 bytes to the drive.  After
> > 86016 had been transferred, the drive did not reply correctly to the
> > next output transaction, causing the kernel to perform a reset.  
> > That's what happened, according to the viewpoint of the xhci-hcd 
> > driver.
> > 
> > In theory it's possible that the drive did respond correctly and the
> > information get messed up on the USB cable or on the computer's end.
> 
> Wow, that sucks.
> I had a mental image where the transactions used FEC and it would be
> obviously possible to differentiate between cable/hub/endpoint errors.

I don't see how FEC could help in a situation where a device sends a
properly formatted message and then some component closer to the kernel
improperly rejects it.

Alan Stern
