From: Christoph Hellwig <hch@lst.de>
Subject: Re: misc scsi midlayer updates
Date: Mon, 31 Mar 2014 08:20:27 +0200
Message-ID: <20140331062027.GA13383@lst.de>
References: <1395936862-6938-1-git-send-email-hch@lst.de> <53383947.3050001@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60699 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbaCaGUb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2014 02:20:31 -0400
Content-Disposition: inline
In-Reply-To: <53383947.3050001@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <openosd@gmail.com>
Cc: James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

Hi Boaz,

> Hi Christoph
> 
> Many years ago I have sent these exact patches but no-one cared Including
> me I guess.

I didn't remember your older patches, sorry.

> I think my:
> 	scsi_lib: Remove that __scsi_release_buffers contraption
> Is more elegant, is layered better and is smaller code. (please
> consider my version)

I very much disagree - the bidi code uses a separate request for it's payload,
uses separate functions to set it up at the low-level so mirroring it with
a separate teardown makes sense.  This also avoids having to do any bidi
check at all in the fast path.

> Also the first patch is some more cleanup you'd like.

Doesn't look bad, but not that importan either.

> The main patch of collapsing  scsi_end_request is basically the same.

I like the goto version better beause it avoids additional duplication from
inside the switch and the bidi path, but it should be functionally equivalent.


> Please note the 4th patch which is a real BUG, titled:
> 	scsi_lib: Can't RETRY scsi_cmnd if some bytes were completed

That fix seems very hard to read due to the arithmetic comparism on the enum
value.  The way I try to understand it is that you never want to retry
if ((an error happened) && (bytes were completed)) but the explanation
should be expanded.

> [Your patches have been tested within my MQ testing right?]

Yes.

