From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [PATCH] make the SCSI mid-layer obey the device online flag
Date: Fri, 06 Jun 2003 11:52:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EE0B8D8.4020909@rogers.com>
References: <1054742495.1674.18.camel@mulgrave>	<20030604165146.GA1426@beaverton.ibm.com>	<1054754103.2360.8.camel@mulgrave> <20030606073603.A13259@infradead.org> 	<3EE0B316.4060207@rogers.com> <1054913984.1778.31.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep03-mail.bloor.is.net.cable.rogers.com ([66.185.86.73]:33245
	"EHLO fep03-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S261801AbTFFPjX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 11:39:23 -0400
In-Reply-To: <1054913984.1778.31.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

James Bottomley wrote:
> On Fri, 2003-06-06 at 11:28, Luben Tuikov wrote:
> 
>>James was talking about ``device server not ready'' aliased to
>>online -- i.e. if online is 0 then only INQUIRY or TUR should
>>be sent from SCSI Core (unless SCSI Core decides to _know_ about
>>the different ULP).  The semantics on this are somewhat touched
>>in the INQUIRY description in SPC-3.
> 
> 
> Actually, not just TUR and INQUIRY.  Think about errors on removable
> media: we offline the device because of them and now the user needs to
> unlock the door and eject the cartridge...
> 
> Thus, we allow any special command because we assume it's part of error
> handling (or post error clean up).

So SCSI Core _has_ decided to know about ULP (block, tape, optical).

Unless we (SCSI Core) generate those, it's a pickle to decide
which are ``special'' enough commands.  I think that we'll see
more user space drivers controlling devices via sg sending
commands to the device for exactly those kinds of problems...
Else the burden on SCSI Core will/might be too great.

-- 
Luben



