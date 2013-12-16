From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] fix our current target reap infrastructure.
Date: Sun, 15 Dec 2013 19:32:29 -0800
Message-ID: <1387164749.2284.65.camel@dabdike.int.hansenpartnership.com>
References: <Pine.LNX.4.44L0.1312152134580.3175-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59839 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751998Ab3LPDcc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Dec 2013 22:32:32 -0500
In-Reply-To: <Pine.LNX.4.44L0.1312152134580.3175-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <tj@kernel.org>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Sun, 2013-12-15 at 21:44 -0500, Alan Stern wrote:
> On Sun, 15 Dec 2013, James Bottomley wrote:
> 
> > No, I was thinking of the two thread scan bug (i.e. two scan threads)
> > not one scan and one remove, which is a bug in the old code.  This is a
> > race between put and get when the kref is incremented from zero (an
> > illegal operation which triggers a warn on).
> > 
> > The way to mediate this is to check for the kref already being zero
> > condition, like below.
> 
> Yes, that seems reasonable.  Consider now: Having done this, to what
> extent do starget->reap_ref and starget->state really need to be
> protected by the host_lock?  Maybe only the linked lists require
> protection.  (I haven't checked.)

Yes, I think so, but that can be done as an enhancement patch after the
fact.

> Can you post a single, combined patch incorporating all your proposed
> changes?  It's little hard to review them in pieces...

Sure, I'll repost what I have.

> Alan Stern
> 
> P.S.: Would you agree that the phrase "pretty astonishing cockup" did
> indeed turn out to be appropriate?  :-)

Objection, m'lud, my learned friend is leading the witness ...

James



