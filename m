From: Andreas Reis <andreas.reis@gmail.com>
Subject: Re: [PATCH 0/3] Fix USB deadlock caused by SCSI error handling
Date: Thu, 10 Apr 2014 12:58:24 +0200
Message-ID: <53467950.3010403@gmail.com>
References: <Pine.LNX.4.44L0.1404091358340.28384-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:60393 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965609AbaDJK62 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Apr 2014 06:58:28 -0400
In-Reply-To: <Pine.LNX.4.44L0.1404091358340.28384-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

That patch appears to work in preventing the crashes, judged on one=20
repeated appearance of the bug.

dmesg had the usual
[  215.229903] usb 4-2: usb_disable_lpm called, do nothing
[  215.336941] usb 4-2: reset SuperSpeed USB device number 3 using xhci=
_hcd
[  215.350296] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called=20
with disabled ep ffff880427b829c0
[  215.350305] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called=20
with disabled ep ffff880427b82a08
[  215.350621] usb 4-2: usb_enable_lpm called, do nothing

repeated five times, followed by one
[  282.795801] sd 8:0:0:0: Device offlined - not ready after error reco=
very

and then as often as something tried to read from it:
[  295.585472] sd 8:0:0:0: rejecting I/O to offline device

The stick could then be properly un- and remounted (the latter if it ha=
d=20
been physically replugged) without issue =97 for the bug to reoccur aft=
er=20
one to three minutes. I tried this three times, no dmesg difference=20
except the ep addresses varied on two of that.

Andreas Reis

On 09.04.2014 20:02, Alan Stern wrote:
> On Wed, 9 Apr 2014, Hannes Reinecke wrote:
>
>>> I finally got a chance to try it out.  It does seem to do what we w=
ant.
>>> I didn't track the flow of control in complete detail, but the comm=
and
>>> definitely got aborted both times it was issued.
>>>
>> Good, so it is as I thought. James, can we include this patch instea=
d of
>> your prior solution?
>
> First, we should have the original bug reporter try it out.
>
> Andreas, the patch in question can be found here:
>
> 	http://marc.info/?l=3Dlinux-usb&m=3D139627666606597&w=3D2
>
> Can you try this in place of the 1/3 patch posted by James?  It shoul=
d
> have the same effect, of preventing your system from crashing when th=
e
> READ command fails.
>
> Alan Stern
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
