From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: scsi_host_alloc does not check for used shost->host_no
Date: Tue, 15 Jul 2008 15:34:14 -0500
Message-ID: <1216154055.3312.129.camel@localhost.localdomain>
References: <48775DCD.5010202@linux.vnet.ibm.com>
	 <487D059C.60400@linux.vnet.ibm.com>
	 <20080715202507.GI14894@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44578 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758327AbYGOUeT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2008 16:34:19 -0400
In-Reply-To: <20080715202507.GI14894@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Brian King <brking@linux.vnet.ibm.com>, Daniel Debonzi <debonzi@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

On Tue, 2008-07-15 at 14:25 -0600, Matthew Wilcox wrote:
> > Do we need to worry about a host in the SHOST_DEL state? In that case, it will still
> > exist to some degree, but scsi_host_get will fail. For example, what happens if a
> > shell is in /sys/class/scsi_host/host5/ and you delete host 5 and try to add another.
> > Couldn't you run into the same problem? In that case the scsi_host_get will fail.
> > I suppose you could check specifically for -ENXIO getting returned...
> 
> Or we could make the host_no a u64 and avoid the problem ever happening
> in our lifetimes.  I'm amazed that anyone's had the time to do 4 billion
> add/removes, to be honest.  Assuming it takes 1 second per add/remove
> cycle, and there's not even time to scan a bus in that time, that's
> still 136 years.

Actually, right at the moment, a lot of the udev stuff is conditioned on
a non repeating host number (which is why we don't use idr like we do
for the other things).  I'm really reluctant to go to a u64 host
number ... what was the use case that produced this problem?

James


