From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/3] Fix USB deadlock caused by SCSI error handling
Date: Thu, 10 Apr 2014 11:31:18 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1404101128020.32351-100000@netrider.rowland.org>
References: <53468297.1040909@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:58467 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753036AbaDJPbT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Apr 2014 11:31:19 -0400
In-Reply-To: <53468297.1040909@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Andreas Reis <andreas.reis@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Thu, 10 Apr 2014, Hannes Reinecke wrote:

> On 04/10/2014 12:58 PM, Andreas Reis wrote:
> > That patch appears to work in preventing the crashes, judged on one
> > repeated appearance of the bug.
> >=20
> > dmesg had the usual
> > [  215.229903] usb 4-2: usb_disable_lpm called, do nothing
> > [  215.336941] usb 4-2: reset SuperSpeed USB device number 3 using
> > xhci_hcd
> > [  215.350296] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint calle=
d
> > with disabled ep ffff880427b829c0
> > [  215.350305] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint calle=
d
> > with disabled ep ffff880427b82a08
> > [  215.350621] usb 4-2: usb_enable_lpm called, do nothing
> >=20
> > repeated five times, followed by one
> > [  282.795801] sd 8:0:0:0: Device offlined - not ready after error
> > recovery
> >=20
> > and then as often as something tried to read from it:
> > [  295.585472] sd 8:0:0:0: rejecting I/O to offline device
> >=20
> > The stick could then be properly un- and remounted (the latter if i=
t
> > had been physically replugged) without issue =97 for the bug to
> > reoccur after one to three minutes. I tried this three times, no
> > dmesg difference except the ep addresses varied on two of that.
> >=20
> Was this just that patch you've tested with or the entire patch serie=
s?
>=20
> If the latter, Alan, is this the expected outcome?

Yes, it is.  The same thing should happen with the entire patch series.

> I would've thought the error recover should _not_ run into
> offlining devices here, but rather the device should be recovered
> eventually.

The command times out, it is aborted, and the command is retried.  The
same thing happens, and we repeat five times.  Eventually the SCSI core
gives up and declares the device to be offline.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
