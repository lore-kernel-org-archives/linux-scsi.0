From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: kernel 2.6.3 mpt fusion 3.00.03:  WWN part of target assignment?
Date: Thu, 16 Dec 2004 14:15:47 -0800
Message-ID: <20041216221547.GB339475@sgi.com>
References: <1103056823.18363.330.camel@rebel.corp.whenu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:15011 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S262056AbULPWVy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Dec 2004 17:21:54 -0500
Content-Disposition: inline
In-Reply-To: <1103056823.18363.330.camel@rebel.corp.whenu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Richard F. Rebel" <rrebel@whenu.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Dec 14, 2004 at 03:40:23PM -0500, Richard F. Rebel wrote:
> 
> Hello,
> 
> I have a LSI logic quad port fibre channel board in two computers on a
> small SAN.  The SAN consists of a dual controllered nStor raid, as well
> as a dual controller SSD, each port of each device is connected to one
> of two QLogic sanbox 5200's.
> 
> One of my devices, the 6GB SSD, reports the following WWN by port:
> 
> Port 0: 20:00:00:02:34:00:00:9a
> 
> Port 2: 20:02:00:02:34:00:00:9a
> 
> As you can see, the number are nearly identical except for the 2nd
> number which according the the manufacturer equates to the devices
> internal port number.
> 
> Port 0, is attached to our first switch, port 2, is connected to the
> 2nd.
> 
> The kernel, upon probing the bus, reports that the SSD's target ID is 0
> on the first switch, and on the second, it reports target 2.  Why is the
> device not being assigned the same target like my other SAN devices.
> 
> This is the only device we have that elicits this behavior and it's
> bunging up my mappings when I have it connected.  When I disconnect the
> device and reboot everything, all of the fiber channel interfaces report
> the other SAN devices identically across all paths (desired and
> expected).  When I re-connect the SSD to the fabric, in reverse (port 0
> on switch 2, port 2 on switch 1) the target's are reversed, but the SSD
> still shows up as target 2.
> 
> Please forgive my ignorance, but what is responsible for assigning the
> target id?  The SSD vendor claims the switch or the host, and most
> likely the host is responsible for this.  Is there something I can do to
> control this?
> 
> Thanks!
> 
> -- 
> Richard F. Rebel
> 
> cat /dev/null > `tty`

Try using lsiutil to create persistent mappings.  However, relying on
persistent and meaningful target IDs for Fibre SCSI devices is a bad
idea, because they are typically neither.  That's one reason for the
fc_transport API, which you don't have in your old kernel.

jeremy
