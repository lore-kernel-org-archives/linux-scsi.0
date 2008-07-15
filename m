From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: scsi_host_alloc does not check for used shost->host_no
Date: Tue, 15 Jul 2008 14:25:07 -0600
Message-ID: <20080715202507.GI14894@parisc-linux.org>
References: <48775DCD.5010202@linux.vnet.ibm.com> <487D059C.60400@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56639 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456AbYGOUZI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jul 2008 16:25:08 -0400
Content-Disposition: inline
In-Reply-To: <487D059C.60400@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Daniel Debonzi <debonzi@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

On Tue, Jul 15, 2008 at 03:16:28PM -0500, Brian King wrote:
> > +	/* 
> > +	 * Look if host_no is not been used somewhere else. Is is used to
> > +	 * happen when scsi_host_next_hn overflows and goes back to 0.
> > +	 */
> > + host_no_already_exists:
> >  	shost->host_no = scsi_host_next_hn++; /* XXX(hch): still racy */
> > +        if(!IS_ERR(tmp_shost = scsi_host_lookup(shost->host_no)))
> > +          {
> 
> This needs to follow Documentation/CodingStyle, in this particular case, K&R braces.

and assignments within conditionals are not preferred either:

	tmp_shost = scsi_host_lookup(shost->host_no);
	if (!IS_ERR(tmp_shost)) {
[...]

Oh, and gotos should be reserved for exception handling.  So this should
really be a loop:

	for (;;) {
		shost->host_no = scsi_host_next_hn++;
		tmp_shost = scsi_host_lookup(shost->host_no);
		if (IS_ERR(tmp_shost))
			continue;
		scsi_host_put(tmp_shost);
		break;
	}

> Do we need to worry about a host in the SHOST_DEL state? In that case, it will still
> exist to some degree, but scsi_host_get will fail. For example, what happens if a
> shell is in /sys/class/scsi_host/host5/ and you delete host 5 and try to add another.
> Couldn't you run into the same problem? In that case the scsi_host_get will fail.
> I suppose you could check specifically for -ENXIO getting returned...

Or we could make the host_no a u64 and avoid the problem ever happening
in our lifetimes.  I'm amazed that anyone's had the time to do 4 billion
add/removes, to be honest.  Assuming it takes 1 second per add/remove
cycle, and there's not even time to scan a bus in that time, that's
still 136 years.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
