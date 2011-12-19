From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [usb-storage] Re: Make UAS work on HS for devices with and
 without command tagging support
Date: Mon, 19 Dec 2011 15:57:37 -0500
Message-ID: <20111219205737.GR14291@linux.intel.com>
References: <20111216144724.GC19563@linutronix.de>
 <20111216201236.GE19563@linutronix.de>
 <20111216203146.GN14291@linux.intel.com>
 <20111216204241.GA30915@linutronix.de>
 <20111216213628.GA5509@xanatos>
 <1324072059.10429.27.camel@dabdike>
 <20111219161225.GO14291@linux.intel.com>
 <1324314850.5123.12.camel@dabdike.int.hansenpartnership.com>
 <20111219183633.GP14291@linux.intel.com>
 <1324326458.5123.14.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27107 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab1LSU5q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Dec 2011 15:57:46 -0500
Content-Disposition: inline
In-Reply-To: <1324326458.5123.14.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>

On Mon, Dec 19, 2011 at 02:27:38PM -0600, James Bottomley wrote:
> Hm, OK, that was actually something added to SAM-4.  It's not present in
> SAM-3.  However, it does look like SAS always tried to get away with
> this, notably by deciding in SAS-1 (which was SAM-3 based) that the
> Frame tag wasn't the same thing as a SAM-3 Q.

So ... T10 have put us in a bit of an awkward position here; by solving
a problem that didn't need to be solved, they've created a new problem.
We're sending a packet stream that's permitted by SAS-1 standards and not
by SAS-2 standards (but probably isn't going to be checked by any device).
To be technically correct, we've got to use shared tag maps (with the
extra locking overhead) for any device that claims to be SAS-2 compliant.
That's ... complex.

So are we just going to pretend that T10 never made this change?  :-)
