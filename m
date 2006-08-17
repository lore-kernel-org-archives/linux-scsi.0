From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] SCSI and FC Transport: add netlink support for posting of transport events
Date: Thu, 17 Aug 2006 14:24:52 -0700
Message-ID: <20060817212452.GA18890@us.ibm.com>
References: <1155070439.6275.5.camel@localhost.localdomain> <20060811043237.GA29551@us.ibm.com> <44DC92EC.1020609@emulex.com> <20060814161833.GA25026@us.ibm.com> <44E4C9DD.3070304@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33000 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932316AbWHQVZe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Aug 2006 17:25:34 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k7HLPXk4017692
	for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2006 17:25:33 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k7HLPXIa248896
	for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2006 17:25:33 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k7HLPXwk022322
	for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2006 17:25:33 -0400
Content-Disposition: inline
In-Reply-To: <44E4C9DD.3070304@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org

James Smart <James.Smart@Emulex.Com> wrote:
> Mike,
> 
> So I'm converting this over, and I really don't like using attributes.
> 

ok, I replied to most of your comments, but you can skip to the bottom and
ignore them if you want.

> My first major hurdle is that I have to update the netlink library to 
> support a
> new "binary blob" attribute, that may be of arbitrary length, similar to the
> "string" attribute.

You should not need to edit the netlink library as you should be able to
use NLA_PUT_TYPE. Unless I missing the question.

> 
> My second hurdle is dealing with arbitrary-sized messages. Due to their 
> existence
> and their rarity, I punted on creating fixed size mempools. Headache I have 
> now
> is trying to size the skb payload. It has to be large enough for the
> variable-length payload, plus large enough for all the attribute overhead 
> for
> each field element, and any padding. Yech!
> 

This is hard. In dm code I over allocate, but my number of attributes are
bounded. You must have to deal with correct skb payload sizing today
right?

> Coding-wise, the format and understanding of what message has what data is
> more confusing. It pushes for a flat "attribute" space for all message
> elements.  Minimally, it requires a lot more formality of data structures to
> impose "structure" on the elements. Pure overhead and less clarity.
> 

You can use nested attributes to help some here.

> I started using your dm patch as a reference and came away scratching my 
> head.
> It uses both a packed structure (for a header) followed by attribute-based
> data (actual message elements). Seemed real odd that we would use both, and 
> if
> we trust it for one, why not the other ?

I think it is not some much trust as flexibility with what will change.
The header size is expected to be more constant. 

> 
> Also, there was one other "pro" where you dinged the implementation that
> wasn't fully true...
> > Since an attribute is not exposing the data as a fixed structure it leads
> > to more options in the future of reorganizing the data. An old program
> > running on a new kernel would be able to pick up known attributes while
> > ignoring others. One could never reorg the structure and always add to the
> > end of the structure which would address the issue also without using
> > attributes.
> As implemented, we could always add elements, but never reorg or subtract,
> and the app would continue to work fine. This is due to the msglen field
> being in place.

I think that is what I was trying to say at the end that one could
increase the size of the structure without attributes and that should be
ok if alignment is not an issue.

> 
> 
> So, I currently want to update the patch only to optimize allocations on
> the send sequence.  Would you buy into this ?

Yes, I do not want to hold up the overall capability on this point if
others are ok with the data payload.

-andmike
--
Michael Anderson
andmike@us.ibm.com
