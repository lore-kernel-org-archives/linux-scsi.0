From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: Sample implementation of a scheme to handle missing interrupts
Date: Mon, 28 Jul 2008 15:45:01 -0500
Message-ID: <1217277901.3503.143.camel@localhost.localdomain>
References: <660360F4F2570145BD872F298951B17A3AC7E178@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33560 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760396AbYG1Upb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2008 16:45:31 -0400
In-Reply-To: <660360F4F2570145BD872F298951B17A3AC7E178@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Matthew Wilcox <matthew@wil.cx>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Mon, 2008-07-28 at 13:01 -0600, Moore, Eric wrote:
> On Sunday, July 27, 2008 11:56 PM, Matthew Wilcox wrote:
> 
> > There has been some discussion recently (both on the mailing
> > list and at
> > OLS) of MSI and it reminded me of a perennial problem that I have with
> > sym2.  When interrupts don't work, I often get the bug
> > reports, because
> > the user seems sym2 spewing error messages right before the panic when
> > it fails to mount their root filesystem.
> >
> 
> In my case, the MSI problem will manifest itself well before we bind
> with the scsi midlayer.    Meaning when there is a MSI problem, we
> can't even bring up the card.  Hence adding code in a eh_timed_out
> callback handler would be meaningless in solving our problem. What I
> need to do is find a problematic card, so I can verify some things.

Actually, you don't need this.  I verified the behaviour of the MSI
problem simply by commenting out the request_irq.  It looks like there's
no simple way to simulate MSI misrouting, but perhaps I should look at
that, since it would be useful.

>    My beliefs are that all the doorbell request at driver load time
> work becuase we are polling with interrupts masked.

This is the actual bug report:

http://bugzilla.kernel.org/show_bug.cgi?id=11045

>   The first command sent with interrupts enabled would be
> SendPortEnable.  If we have a timeout after calling
> mpt_handshake_req_reply_wait, we resend the port enable with MSI
> turned off, right?

James


