From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] SCSI and FC Transport: add netlink support for posting
 of transport events
Date: Thu, 17 Aug 2006 15:56:13 -0400
Message-ID: <44E4C9DD.3070304@emulex.com>
References: <1155070439.6275.5.camel@localhost.localdomain> <20060811043237.GA29551@us.ibm.com> <44DC92EC.1020609@emulex.com> <20060814161833.GA25026@us.ibm.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:7646 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1030234AbWHQT4Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Aug 2006 15:56:16 -0400
In-Reply-To: <20060814161833.GA25026@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Mike,

So I'm converting this over, and I really don't like using attributes.

My first major hurdle is that I have to update the netlink library to support a
new "binary blob" attribute, that may be of arbitrary length, similar to the
"string" attribute.

My second hurdle is dealing with arbitrary-sized messages. Due to their existence
and their rarity, I punted on creating fixed size mempools. Headache I have now
is trying to size the skb payload. It has to be large enough for the
variable-length payload, plus large enough for all the attribute overhead for
each field element, and any padding. Yech!

Coding-wise, the format and understanding of what message has what data is
more confusing. It pushes for a flat "attribute" space for all message
elements.  Minimally, it requires a lot more formality of data structures to
impose "structure" on the elements. Pure overhead and less clarity.

I started using your dm patch as a reference and came away scratching my head.
It uses both a packed structure (for a header) followed by attribute-based
data (actual message elements). Seemed real odd that we would use both, and if
we trust it for one, why not the other ?

Also, there was one other "pro" where you dinged the implementation that
wasn't fully true...
 > Since an attribute is not exposing the data as a fixed structure it leads
 > to more options in the future of reorganizing the data. An old program
 > running on a new kernel would be able to pick up known attributes while
 > ignoring others. One could never reorg the structure and always add to the
 > end of the structure which would address the issue also without using
 > attributes.
As implemented, we could always add elements, but never reorg or subtract,
and the app would continue to work fine. This is due to the msglen field
being in place.


So, I currently want to update the patch only to optimize allocations on
the send sequence.  Would you buy into this ?

-- james


