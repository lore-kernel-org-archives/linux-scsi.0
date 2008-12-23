From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 12207] block reads/writes > 122880 bytes to USB tape
	drive gives EBUSY
Date: Tue, 23 Dec 2008 10:42:29 -0600
Message-ID: <1230050549.3461.19.camel@localhost.localdomain>
References: <20081223161822.9BE36108042@picon.linux-foundation.org>
	 <alpine.LNX.2.00.0812231826370.31316@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60188 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750782AbYLWQmd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Dec 2008 11:42:33 -0500
In-Reply-To: <alpine.LNX.2.00.0812231826370.31316@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Tue, 2008-12-23 at 18:30 +0200, Kai Makisara wrote:
> On Tue, 23 Dec 2008, bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=12207
> > 
> > 
> > 
> > 
> > 
> > ------- Comment #13 from alan@lxorguk.ukuu.org.uk  2008-12-23 08:18 -------
> > What may have happened is something else changed to trigger the enforcement of
> > that limit on not block paths ?
> > 
> Something like this ;-) From 2.6.16 st.c has used scsi_execute_async() 
> that sends the request to the block layer.

That's probably it!  Realistically, though, allowing st to override the
block limits was wrong.  Most drivers (except USB) don't set these
arbitrarily, they usually represent fundamental hardware limits.  If you
force down a transaction that's larger than they declared themselves
capable of, they'll do strange things like wrap descriptors or truncate
the transaction, which will cause silent data corruption.

Hopefully we can figure out how to get USB working.

James


