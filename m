From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] fix our current target reap infrastructure.
Date: Sun, 15 Dec 2013 19:33:29 -0800
Message-ID: <1387164809.2284.66.camel@dabdike.int.hansenpartnership.com>
References: <Pine.LNX.4.44L0.1312152146040.3175-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59854 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751998Ab3LPDdb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Dec 2013 22:33:31 -0500
In-Reply-To: <Pine.LNX.4.44L0.1312152146040.3175-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <tj@kernel.org>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Sun, 2013-12-15 at 21:49 -0500, Alan Stern wrote:
> On Sun, 15 Dec 2013, James Bottomley wrote:
> 
> > No, I was thinking of the two thread scan bug (i.e. two scan threads)
> > not one scan and one remove, which is a bug in the old code.
> 
> By the way, the existing code doesn't allow two threads to scan a
> target at the same time.  They would both have to hold the host's
> scan_mutex.

I thought of that, but it's dropped too early.  That makes the race
almost untriggerable because the racing thread starts way behind, but
it's not theoretically impossible.

> On the other hand, as far as I can see there's nothing to prevent two
> threads from removing a device at the same time.  But that wouldn't 
> cause any problems.

Right.

Thanks,

James



