From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 3/3] 2.6.0 aacraid driver update
Date: Mon, 06 Oct 2003 18:06:34 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3F81E76A.10805@pobox.com>
References: <1065475285.17021.79.camel@markh1.pdx.osdl.net> <3F81E34A.1040201@pobox.com> <20031006215936.GF24824@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20031006215936.GF24824@parcelfarce.linux.theplanet.co.uk>
To: Matthew Wilcox <willy@debian.org>
Cc: Mark Haverkamp <markh@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Mon, Oct 06, 2003 at 05:48:58PM -0400, Jeff Garzik wrote:
> 
>>>+		/*
>>>+		 *	Yield the processor in case we are slow 
>>>+		 */
>>>+		set_current_state(TASK_UNINTERRUPTIBLE);
>>>+		schedule_timeout(1);
>>
>>hmmm... why not simply call yield() here instead?  I think yield() is 
>>closer to the intent you wish to achieve...
> 
> 
> Gods, no.  I believe it is always a bug for drivers to call yield()
> in 2.6.  What is probably meant here is cond_resched().  I'd support
> deleting the EXPORT_SYMBOL(yield) line and fixing the breakage afterwards
> as it causes lots of very subtle breakage ("Under certain circumstances,
> Linux just stops doing anything for 5 seconds").


Yes, you're right, and thank you for the correction.  I was thinking

	if (need_resched)
		schedule();

which I incorrectly translated to yield() when searching my brain for 
the 2.6 equivalent.

	Jeff
