From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/3] Fix USB deadlock caused by SCSI error handling
Date: Thu, 10 Apr 2014 13:37:59 +0200
Message-ID: <53468297.1040909@suse.de>
References: <Pine.LNX.4.44L0.1404091358340.28384-100000@netrider.rowland.org> <53467950.3010403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47842 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935486AbaDJLiA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Apr 2014 07:38:00 -0400
In-Reply-To: <53467950.3010403@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Reis <andreas.reis@gmail.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On 04/10/2014 12:58 PM, Andreas Reis wrote:
> That patch appears to work in preventing the crashes, judged on one
> repeated appearance of the bug.
>=20
> dmesg had the usual
> [  215.229903] usb 4-2: usb_disable_lpm called, do nothing
> [  215.336941] usb 4-2: reset SuperSpeed USB device number 3 using
> xhci_hcd
> [  215.350296] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
> with disabled ep ffff880427b829c0
> [  215.350305] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
> with disabled ep ffff880427b82a08
> [  215.350621] usb 4-2: usb_enable_lpm called, do nothing
>=20
> repeated five times, followed by one
> [  282.795801] sd 8:0:0:0: Device offlined - not ready after error
> recovery
>=20
> and then as often as something tried to read from it:
> [  295.585472] sd 8:0:0:0: rejecting I/O to offline device
>=20
> The stick could then be properly un- and remounted (the latter if it
> had been physically replugged) without issue =97 for the bug to
> reoccur after one to three minutes. I tried this three times, no
> dmesg difference except the ep addresses varied on two of that.
>=20
Was this just that patch you've tested with or the entire patch series?

If the latter, Alan, is this the expected outcome?
I would've thought the error recover should _not_ run into
offlining devices here, but rather the device should be recovered
eventually.

Andreas, can you test with the entire patch series and enable
'scsi_logging_level -s -E 5' prior to running the tests?

THX.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
