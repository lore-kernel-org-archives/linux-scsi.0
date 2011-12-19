From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [usb-storage] Re: Make UAS work on HS for devices with and
 without command tagging support
Date: Mon, 19 Dec 2011 15:22:18 -0600
Message-ID: <1324329738.5123.20.camel@dabdike.int.hansenpartnership.com>
References: <20111216144724.GC19563@linutronix.de>
	 <20111216201236.GE19563@linutronix.de>
	 <20111216203146.GN14291@linux.intel.com>
	 <20111216204241.GA30915@linutronix.de> <20111216213628.GA5509@xanatos>
	 <1324072059.10429.27.camel@dabdike>
	 <20111219161225.GO14291@linux.intel.com>
	 <1324314850.5123.12.camel@dabdike.int.hansenpartnership.com>
	 <20111219183633.GP14291@linux.intel.com>
	 <1324326458.5123.14.camel@dabdike.int.hansenpartnership.com>
	 <20111219205737.GR14291@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55900 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751695Ab1LSVWZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Dec 2011 16:22:25 -0500
In-Reply-To: <20111219205737.GR14291@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>

On Mon, 2011-12-19 at 15:57 -0500, Matthew Wilcox wrote:
> On Mon, Dec 19, 2011 at 02:27:38PM -0600, James Bottomley wrote:
> > Hm, OK, that was actually something added to SAM-4.  It's not present in
> > SAM-3.  However, it does look like SAS always tried to get away with
> > this, notably by deciding in SAS-1 (which was SAM-3 based) that the
> > Frame tag wasn't the same thing as a SAM-3 Q.
> 
> So ... T10 have put us in a bit of an awkward position here; by solving
> a problem that didn't need to be solved, they've created a new problem.
> We're sending a packet stream that's permitted by SAS-1 standards and not
> by SAS-2 standards (but probably isn't going to be checked by any device).
> To be technically correct, we've got to use shared tag maps (with the
> extra locking overhead) for any device that claims to be SAS-2 compliant.
> That's ... complex.
> 
> So are we just going to pretend that T10 never made this change?  :-)

No it's worse than that ... SAS-1 also had this language:

        9.2.1

        [...]

        For COMMAND frames and TASK frames, the SSP initiator port shall
        set the TAG field to a value that is unique for the I_T nexus
        established by the connection (see 7.12). An SSP initiator port
        shall not reuse the same tag when transmitting COMMAND frames or
        TASK frames to different LUNs in the same SSP target port. An
        SSP initiator port may reuse a tag when transmitting frames to
        different SSP target ports. The TAG field in a COMMAND frame
        contains the task tag defined in SAM-3. The TAG field in a TASK
        frame does not correspond to a SAM-3 task tag, but corresponds
        to an SAM-3 association (see 10.2.1). The tag space used in the
        TAG fields is shared across COMMAND frames and TASK frames
        (e.g., if a tag is used for a COMMAND frame, it is not also used
        for a concurrent TASK frame).

Note the weasel language about the tag not being the SAM-3 tag but
containing it.  I've no idea what a SAM-3 "association" is because a
word search on the SAM-3 spec doesn't find any such thing.  It looks
like SAS always intended this and SAM-4 was modified to allow it.

James


