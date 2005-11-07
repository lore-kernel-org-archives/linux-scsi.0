From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security
 in usb-storage driver
Date: Mon, 7 Nov 2005 12:46:37 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0511071244100.5078-100000@iolanthe.rowland.org>
References: <20051107172421.GA15710@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:14225 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S964937AbVKGRqk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Nov 2005 12:46:40 -0500
In-Reply-To: <20051107172421.GA15710@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: thomas schorpp <t.schorpp@gmx.de>, James Bottomley <James.Bottomley@SteelEye.com>, Timothy Thelin <Timothy.Thelin@wdc.com>, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>

On Mon, 7 Nov 2005, Patrick Mansfield wrote:

> On Mon, Nov 07, 2005 at 09:05:25AM -0800, Matthew Dharm wrote:
> 
> > Okay, what am I missing?
> > 
> > Looking at that patch, it looks to me like if sg.c set a flag in the SCSI
> > command block then scsi_core.c could use that flag in the test to determine
> > if the LUN should be masked-in.
> > 
> > HOWEVER, I keep hearing that the changes will be extensive.  What am I
> > missing?
> 
> Not extensive AFAICT ... 
> 
> The scmd/cdb is not available until we call scsi_get_command() in the
> request function. So you would have to add a field into scsi_request, set
> it in sg (in both sg.c block/scsi_ioctl.c, test via sd and sg when you are
> done), and add the field in scsi_cmnd, and set scmd one in
> scsi_init_cmd_from_req().

Isn't it true that scsi_request is going away?  Everything will have to 
use generic request structures.

> But as far as black listing, it does seem like a better solution in that
> user apps do not need special code.

I don't think blacklisting is a good way to do this.  In principle any USB 
mass storage device -- any SCSI device, in fact -- might have a 
vendor-specific pass-thru needing special handling.  It doesn't have to be 
correlated with the vendor, the product, the SCSI level, the transport, or 
anything else.

Alan Stern

