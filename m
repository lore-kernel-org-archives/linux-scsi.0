From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: PATCH [1/1]: sd_remove() hangs waiting on async_synchronize of
 unrelated threads
Date: Tue, 01 Dec 2009 17:50:16 -0500
Message-ID: <1259707816.11762.539.camel@mulgrave.site>
References: <4B158E7B.3040708@sgi.com>
	 <1259704166.11762.516.camel@mulgrave.site>  <4B15989C.80108@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:57904 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406AbZLAWuQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2009 17:50:16 -0500
In-Reply-To: <4B15989C.80108@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Jeremy Higdon <jeremy@sgi.com>, James Smart <James.Smart@Emulex.Com>

On Tue, 2009-12-01 at 16:28 -0600, Michael Reed wrote:
> 
> James Bottomley wrote:
> > On Tue, 2009-12-01 at 15:45 -0600, Michael Reed wrote:
> >> Prevent delays and hangs due to sd_remove() waiting for the completion of
> >> async threads executing sd_probe_async of disks on unrelated host adapters.
> >> This patch executes every sd_probe_async in its own async domain allowing
> >> sd_remove() to wait for just the completion of the async thread associated with
> >> the scsi_disk being removed.
> > 
> > This patch was thought of a while ago. Unfortunately, some of the
> > unrelated threads we end up waiting on are libata ones.  you confine sd
> > to only its own probes, we end up unsynchronised with respect to libata
> > probes and we might cause ordering problems amongst the ata devices.
> > 
> 
> Isn't sd_remove() only concerned with the removal of a a single scsi_disk?
> Shouldn't libata use reference counting if it has is an issue with a scsi_disk
> being prematurely removed?  Or is this a concern about "sd" naming?  Or something
> else that I admittedly don't understand (but should)?

Well, no ... the sync on remove is preventing us removing a device whose
async part is still running.  That async part for libata includes pieces
kicked off from the sd probe.

> I would truly like to better understand the issue.  Would someone mind expanding
> upon the concern about ata ordering issues associated with the removal of a
> single scsi_disk?

The problem isn't removal per se ... it's the fact that remove can't
complete until any async pieces remaining from probe have run. 

James


