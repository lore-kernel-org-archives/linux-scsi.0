From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi_mid_low_api doesn't mention scsi_scan_host
Date: Mon, 21 Mar 2005 15:59:22 +0000
Message-ID: <20050321155922.GU21986@parcelfarce.linux.theplanet.co.uk>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AB43@xbl3.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:63135 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261840AbVCUP7X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2005 10:59:23 -0500
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AB43@xbl3.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: matthew@wil.cx, dgilbert@interlog.com, linux-scsi@vger.kernel.org

On Mon, Mar 21, 2005 at 09:50:07AM -0500, James.Smart@Emulex.Com wrote:
> > + *      successful call to scsi_host_alloc().  The LLD must call
> > + *	scsi_scan_host() in order to scan the bus.  The LLD must set up
> > + *	the transport template before calling this function and may only
> > + *	access the transport class data after this function has 
> > been called.
> 
> It is not mandatory that the LLD call scsi_scan_host(). Although this used
> to be the case, a few changes have been made in the midlayer recently as we
> attempted to have the transports perform scanning on behalf of the LLD's.
> The scsi_scan_target() function can now be used instead of scsi_scan_host().
> (note: the symbol scsi_scan_single_target() was added briefly, then removed
> as scsi_scan_target was exported).  In the case of the LLD's using the FC
> transport, the need not call any scan function. The FC transport calls
> scsi_scan_target() for them.

Thanks for the correction.  How does this look?

 *      Notes: Only required in "hotplug initialization model" after a
 *      successful call to scsi_host_alloc().  This function does not
 *      scan the bus; this can be done by calling scsi_scan_host() or
 *      in some other transport-specific way.  The LLD must set up
 *      the transport template before calling this function and may only
 *      access the transport class data after this function has been called.


-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
