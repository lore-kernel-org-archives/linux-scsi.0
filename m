From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Mid-layer handling of NOT_READY conditions...
Date: Sat, 29 Jan 2005 16:16:05 +0000
Message-ID: <20050129161605.GK28246@parcelfarce.linux.theplanet.co.uk>
References: <1106954650.9862.61.camel@plap> <1106977566.9862.102.camel@plap>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:4000 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262934AbVA2QQG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2005 11:16:06 -0500
Content-Disposition: inline
In-Reply-To: <1106977566.9862.102.camel@plap>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Jan 28, 2005 at 09:46:06PM -0800, Andrew Vasquez wrote:
> On Fri, 2005-01-28 at 15:24 -0800, Andrew Vasquez wrote:
> > When the qla2xxx driver managed command queuing internally, a NOT_READY
> > status would cause the lun-queue to be frozen for some period time while
> > the storage settled-down.
> 
> Returning back DID_IMM_RETRY for these 'transport' related conditions
> would of course help in this issue -- but at the same time bring with it
> several side-effects which may not be desirable.
> 
> So, beyond this particular circumstance, what would be considered a
> 'proper' return status for this type of event? 

I suspect the 'proper' return status for this kind of event would be
to get the cmd back to the block layer asap so it can be retried down
a different path if we have multiple paths to the device.  Not that I'm
an expert ...

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
