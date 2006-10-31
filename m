From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: modalias for scsi devices?
Date: Tue, 31 Oct 2006 09:29:03 +0100
Message-ID: <4547094F.30105@s5r6.in-berlin.de>
References: <4541F55D.8040900@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:35781 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751714AbWJaI3c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Oct 2006 03:29:32 -0500
In-Reply-To: <4541F55D.8040900@tls.msk.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-scsi@vger.kernel.org

Michael Tokarev wrote on 2006-10-27:
...
> But at that time, someone replied telling me he's implementing
> this functionality in a more general way.

Could you point to an archive of this discussion?

...
> The modalias format is like this:
> 
>  scsi:type-0x04
...
> o osst.c driver handles tapes too, like st.c, but only SOME tapes.
>   With this setup, hotplug scripts (or whatever is used by the
>   user) will try to load both st and osst modules for all SCSI
>   tapes found, because both modules have scsi:type-0x01 alias).
>   It is not harmful, but one extra module is no good either.
>   It is possible to solve this, by exporting more info in
>   modalias attribute, including vendor and device identification
>   strings, so that modalias becomes something like
>     scsi:type-0x12:vendor-Adaptec LTD:device-OnStream Tape Drive
>   and having that, match for all 3 attributes, not only device
>   type.  But oh well, vendor and device strings may be large,

8 and 16 characters may be somewhat large for modalias strings but I
think this is still OK.

>   and they do contain spaces and whatnot.
...

What about the string format that scsi_scan.c::scsi_add_lun() prints in
Linux 2.6.19?

	sdev_printk(KERN_NOTICE, sdev, "%s %.8s %.16s %.4s PQ: %d "
			"ANSI: %d%s\n", scsi_device_type(sdev->type),
			sdev->vendor, sdev->model, sdev->rev,
			sdev->inq_periph_qual, inq_result[2] & 0x07,
			(inq_result[3] & 0x0f) == 1 ? " CCS" : "");

Of course you could use hexadecimal for the type again and use other
delimiters. But I think the only sane way to parse vendor and model is
to rely on their fixed length, not on some nifty delimiters. I don't
know though if existing userspace helpers are prepared for fixed-length
string elements.

I can't comment on the general idea to switch to modaliases.
-- 
Stefan Richter
-=====-=-==- =-=- =====
http://arcgraph.de/sr/
