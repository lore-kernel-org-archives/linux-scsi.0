From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Patches for SCSI scanning
Date: Tue, 20 Apr 2004 10:44:08 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040420104408.B8602@beaverton.ibm.com>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420092650.A7749@beaverton.ibm.com> <20040420164238.GT4356@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:24514 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263348AbUDTRoz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2004 13:44:55 -0400
Content-Disposition: inline
In-Reply-To: <20040420164238.GT4356@tpkurt.garloff.de>; from garloff@suse.de on Tue, Apr 20, 2004 at 06:42:38PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Tue, Apr 20, 2004 at 06:42:38PM +0200, Kurt Garloff wrote:
> Hi Patrick,
> 
> On Tue, Apr 20, 2004 at 09:26:51AM -0700, Patrick Mansfield wrote:
> > On Tue, Apr 20, 2004 at 09:38:00AM -0500, James Bottomley wrote:
> > > Yes, sounds reasonable.  We can do it all with the boot flags now.
> > 
> > max_scsi_luns should default to zero to avoid devices that should be black
> > listed as single lun.
> 
> I strongly disagree.

There were some posts in the past by either Alan or Doug L on this, I
can't find them. Redhat ships with CONFIG_SCSI_MULTI_LUN not set.

> The target should be to blacklist broken devices not working ones. 

I agree that is where we would like to be, but that can break current usage.

> Devices that have multiple LUNs are not, devices that have only one but
> report severals are.
> 
> With max_scsi_luns=1, we would need to "black"list every single multi lun
> device. I very much dislike that idea.

Not individually, just boot with max_scsi_luns=128 or whatever as is done
today for redhat, or boot with default_dev_flags=0x040 (BLIST_SPARSELUN).

> Fortunately, distributors don't do this.

Suse doesn't, Redhat does, I don't know about others.

> > So how can you remove those and maintain compatibilty? The removal should
> > wait for 2.7.
> 
> Expecting your multi lun devices to work with max_scsi_luns=1 is just
> wrong. max_scsi_luns should not default to 1.
> Anyways, BLIST_SPARSELUN will have the side-effect of also working
> around that misconfiguration.

Again that is not compatible with the current 2.6.x code, users with
non-black listed single lun devices will get failures if we default to
max_scsi_luns > 1.

-- Patrick Mansfield
