From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] unable to handle kernel paging request in next-20080516
Date: Fri, 23 May 2008 15:26:42 -0500
Message-ID: <1211574403.11477.39.camel@localhost.localdomain>
References: <g0mkaf$i1r$1@ger.gmane.org>
	 <20080518021423.3dcf0ddd.akpm@linux-foundation.org>
	 <1211456081.3956.39.camel@localhost.localdomain>
	 <g176e5$6fb$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37333 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897AbYEWU0q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2008 16:26:46 -0400
In-Reply-To: <g176e5$6fb$1@ger.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 2008-05-23 at 20:34 +0100, Sitsofe Wheeler wrote:
> <posted & mailed>
> 
> James Bottomley wrote:
> 
> > Actually, I think this is a very subtle bug; what I think is happening
> > is that after Hannes sysfs changes, we now add scsi_bus_type to the
> > target device.  However, scsi_bus_uevent() unconditionally casts from
> > dev to a struct scsi_device and then looks at the type entry.  My theory
> > is that in this particular config going from struct scsi_target to
> > struct device and back to struct scsi_device actually tips us over into
> > unmapped space for the -> type deref.
> > 
> > Hopefully this should fix it by checking the device type before doing
> > the deref.
> 
> This fixed the problem for me (it was horribly intermittant but I've done
> 10+ consecutive reboots without seeing an oopos). I changed the patch to
> printk everytime the condition was hit and it seems to happen twice per
> PATA device - once after each scsi?: pata_via message and then again after
> each scsi 0:0:0:0: Direct-Accesss ATA DISKID etc : 0 ANSI: 5 .
> 
> The thing I don't understand about your explanation is that it sounds like
> the device struct is being round-tripped (but is just being cast to
> different things along the way). If this is the case why would this problem
> ever arise? Surely if it is really a struct scsi_device underneath there
> should be no problem?

The event is called for all generic device objects belonging to the
scsi_bus_type.  That means both struct scsi_device and struct
scsi_target objects.  When it's called for struct scsi_target objects,
casting out to struct scsi_device does the wrong thing.

James


