From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] USB enclosures seem to require read(16) with >2TB drives
Date: Mon, 12 Nov 2012 16:35:25 +0100
Message-ID: <50A1173D.8090603@redhat.com>
References: <1352477289-8133-1-git-send-email-hernejj@gmail.com>  <1352719990.2449.23.camel@dabdike.int.hansenpartnership.com>  <50A10856.6090009@redhat.com> <1352733055.2449.34.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62999 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab2KLPfc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Nov 2012 10:35:32 -0500
In-Reply-To: <1352733055.2449.34.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@parallels.com>
Cc: "Jason J. Herne" <public-hernejj-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>

Il 12/11/2012 16:10, James Bottomley ha scritto:
>> Actually it only turns it on for large capacity drives, as said in the
>> comment.  sdp->force_read_16 only matters for >2TB drives: 
> 
> If you follow the discussion, we'll need to turn it on for some drives
> regardless of size.

Even if the two reasons to use r/w(16) commands were setting the same
flag, it would be handled in a separate patch; it doesn't really make
sense to complicate the code now when a one-liner does it.

The proposed change is not part of the Oct 31st draft available on
t10.org, for what we know the discussion could end up in nothing.

>> > Any reason not to do this always on >2TB drives, which basically means
>> > changing this:
>> > 
>> > -	} else if (block > 0xffffffff) {
>> > +	} else if (sdkp->capacity > 0xffffffff) {
>> > 
>> > and nothing else?
> Because of the coming T10 mandate in SBC-4 deprecating everything other
> than the 16 byte commands.

And would this change make the upcoming patch for SBC-4 support longer
or harder to review?

Paolo
