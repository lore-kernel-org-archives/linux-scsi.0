From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] SCSI and FC Transport: add netlink support for posting of transport events
Date: Mon, 14 Aug 2006 09:18:33 -0700
Message-ID: <20060814161833.GA25026@us.ibm.com>
References: <1155070439.6275.5.camel@localhost.localdomain> <20060811043237.GA29551@us.ibm.com> <44DC92EC.1020609@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:2527 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751134AbWHNQRY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Aug 2006 12:17:24 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e2.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k7EGHOsv011387
	for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2006 12:17:24 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k7EGH2Th296788
	for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2006 10:17:02 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k7EGH21w015112
	for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2006 10:17:02 -0600
Content-Disposition: inline
In-Reply-To: <44DC92EC.1020609@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org

James Smart <James.Smart@Emulex.Com> wrote:
> Mike Anderson wrote:
> >What about using netlink attributes? The attributes do have more overhead,
> >but it would seem that using attributes instead of sending out a
> >whole structure would make it easier on the user space side to support
> >different kernel versions without syncing the tools with the kernel.
> 
> Yeah, I guessed you were going to raise this.
> 
> I just didn't see any advantage to it. The macros really didn't help with
> anything really interesting, such as endianness. I guess they do help with
> some potential structure packing issues. I saw them as just ensuring that
> you walked on the path right - which for most intents and purposes, you
> will as you really are not self-discovering data. As long as you use
> well-defined types and watch the structure alignments, it should be fine.
> The overhead didn't seem worthit. Enlighten me if I'm taking them too 
> lightly.

Packing issue avoidance was a feature of attributes that got me to start
using them.

It also allows better organization of the data through nested attributes or
even just straight attributes. Allowing for a single large allocation and
then multiple users can add to the payload prior to the send.

While attributes are not the only solution it appears right now in the
patch that we could optimize the send sequence. Currently for an event we
allocate an event only to allocate a skb shortly after to copy the event
data into and then free the previous allocated event.

> 
> I'm assuming your "syncing the tools with the kernel" statement infers the
> use of a version element in place of the attributes above. I don't see how
> you lose the version. It's the key for the later structure decode regardless
> of whether it's attribute-ized or not. Am I missing something ? I'm also
> (obviously) a proponent of the version so that a tool can provide backward
> compatibility, or spot new un-recognized data.

Since an attribute is not exposing the data as a fixed structure it leads
to more options in the future of reorganizing the data. An old program
running on a new kernel would be able to pick up known attributes while
ignoring others. One could never reorg the structure and always add to the
end of the structure which would address the issue also without using
attributes.



-andmike
--
Michael Anderson
andmike@us.ibm.com
