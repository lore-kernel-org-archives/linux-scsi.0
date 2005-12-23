From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [SCSI] Add support for braindead Cypress USB ATA
	passthrough	CDBs
Date: Fri, 23 Dec 2005 14:34:30 -0600
Message-ID: <1135370071.3728.43.camel@mulgrave>
References: <20051221122442.GA16571@porkrind.org>
	 <1135353160.3728.10.camel@mulgrave>
	 <FEB7BF7CC02839AFCC0CF35D@dev.porkrind.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:22720 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161041AbVLWUei (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 15:34:38 -0500
In-Reply-To: <FEB7BF7CC02839AFCC0CF35D@dev.porkrind.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Caldwell <david@porkrind.org>
Cc: linux-scsi@vger.kernel.org

On Fri, 2005-12-23 at 11:12 -0800, David Caldwell wrote:
> > I think this approach is too invasive to the stack.  When this was
> > discussed in november, there wasn't much enthusiasm for resurrecting the
> > long dead LUN_INHIBIT flag.  The two suggested mechanisms are
> 
> Invasive because of the extra flag in the request structure?

Yes. But also having users determine this is wrong when it's a device
feature.

> > 2) If 1) doesn't work, then use a blacklist entry which the subsystems
> > would also have access to.
> 
> I think this might not be optimal. The problem is that it's impossible to 
> tell that it's a Cypress part from the USB side of things (or the SCSI side 
> for that matter), so there would have to be an entry for each of the 50,000 
> vendors of USB bridges.

I meant use it in the way usb uses other blacklist flags: set them from
slave_configure.

> What about the patch's cdb length additions in sg and scsi_lib.c? It seems 
> like half the code guesses CDB length and the other half passes it around. 
> Clearly, given devices like this, guessing isn't going to work 100% of the 
> time. So either eveyone needs to pass around lengths, or there needs to be 
> another flag somewhere. The code should at least be consistent though.

I don't think they're necessary, are they?  Zero in cmnd_len means
mid-layer determines size.  What it prevents is the issuing of vendor
specific commands via the API, which is arguably a good thing.

James


