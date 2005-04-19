From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH [2/5]  qla2xxx: add remote port codes...
Date: Tue, 19 Apr 2005 22:13:30 +0100
Message-ID: <20050419211330.GA20234@infradead.org>
References: <20050413191548.GI9703@plap.qlogic.org> <20050413191824.GK9703@plap.qlogic.org> <20050413214023.GA18161@infradead.org> <20050419072751.GD5999@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:57222 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261687AbVDSVNk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 17:13:40 -0400
Content-Disposition: inline
In-Reply-To: <20050419072751.GD5999@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: James.Smart@emulex.com, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

On Tue, Apr 19, 2005 at 12:27:51AM -0700, Andrew Vasquez wrote:
> > why do you still need
> > the special case for delaying registration of the targets?
> > 
> 
> Ok, this is actually a concern I have with the current fc_rport
> implementation (and yes, I realize I'm a day late) -- the auto-scan
> logic employed during the creation of the fc_rport (via
> fc_remote_port_add()).

Well, we haven't set the inkernel APIs in stone.  And compared to
say the general scsi or networking APIs there's also only very little
drivers to update in case we still want to change it.

> One possibility (as to not break current functionality) is to add an
> addition role modifier, say FC_RPORT_ROLE_NO_SCAN and | it into
> rport_ids.roles prior to fc_remote_port_add() to indicate no scanning
> should take place during the call.  Then once ready, the driver could
> issue the corresponding fc_remote_port_scan() on the rport.

I'd rather keep that in the transport class as much as possible. What
about defererring the scanning if the host is still in SHOST_ADD state
and add a fc_host_scan call that the driver calls just after scsi_host_add
to scan those?  This would also solve a similar issue about registration
time in lpfc.

> Looking ahead, this may also be useful in the case of port
> authentication (i.e. FC-SP).

Just started reading up about it.  Are there any real-life implementations
of FC-SP available?


