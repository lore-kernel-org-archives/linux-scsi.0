From: <Shyam_Iyer@Dell.com>
Subject: RE: [PATCH 2/5] bnx2fc: Release the reference to hba only after the
 interface is destroyed
Date: Tue, 26 Apr 2011 09:39:20 +0530
Message-ID: <DBFB1B45AF80394ABD1C807E9F28D157032A5620F7@BLRX7MCDC203.AMER.DELL.COM>
References: <1303759810-22570-1-git-send-email-bprakash@broadcom.com>
 <1303759810-22570-2-git-send-email-bprakash@broadcom.com>
 <DBFB1B45AF80394ABD1C807E9F28D157032A5620C4@BLRX7MCDC203.AMER.DELL.COM>
 <4DB60094.3030205@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausxippc101.us.dell.com ([143.166.85.207]:55163 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab1DZEKc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Apr 2011 00:10:32 -0400
In-Reply-To: <4DB60094.3030205@broadcom.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bprakash@broadcom.com
Cc: linux-scsi@vger.kernel.org, devel@open-fcoe.org, nsujir@broadcom.com, robert.w.love@linux.intel.com



> -----Original Message-----
> From: Bhanu Prakash Gollapudi [mailto:bprakash@broadcom.com]
> Sent: Monday, April 25, 2011 7:16 PM
> To: Iyer, Shyam
> Cc: linux-scsi@vger.kernel.org; devel@open-fcoe.org; Nithin Sujir
> Subject: Re: [PATCH 2/5] bnx2fc: Release the reference to hba only
> after the interface is destroyed
> 
> On 4/25/2011 3:49 PM, Shyam_Iyer@Dell.com wrote:
> >
> >
> >> -----Original Message-----
> >> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> >> owner@vger.kernel.org] On Behalf Of Bhanu Prakash Gollapudi
> >> Sent: Monday, April 25, 2011 3:30 PM
> >> To: linux-scsi@vger.kernel.org; devel@open-fcoe.org
> >> Cc: Nithin Nayak Sujir; Bhanu Prakash Gollapudi
> >> Subject: [PATCH 2/5] bnx2fc: Release the reference to hba only after
> >> the interface is destroyed
> >>
> >> From: Nithin Nayak Sujir<nsujir@broadcom.com>
> >>
> >> Prematurely decrementing the reference may lead to cmd_mgr becoming
> >> NULL with
> >> the cmds are still active.
> >>
> >> Signed-off-by: Nithin Nayak Sujir<nsujir@broadcom.com>
> >> Signed-off-by: Bhanu Prakash Gollapudi<bprakash@broadcom.com>
> >> ---
> >>   drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    4 ++--
> >>   1 files changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> >> b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> >> index 8fb9b6e..734d8c1 100644
> >> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> >> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> >> @@ -1370,8 +1370,6 @@ static void bnx2fc_if_destroy(struct fc_lport
> >> *lport)
> >>   	/* Free existing transmit skbs */
> >>   	fcoe_clean_pending_queue(lport);
> >>
> >> -	bnx2fc_interface_put(hba);
> >> -
> >>   	/* Free queued packets for the receive thread */
> >>   	bnx2fc_clean_rx_queue(lport);
> >>
> >> @@ -1399,6 +1397,8 @@ static void bnx2fc_if_destroy(struct fc_lport
> >> *lport)
> >>
> >>   	/* Release Scsi_Host */
> >>   	scsi_host_put(lport->host);
> >> +
> >> +	bnx2fc_interface_put(hba);
> >>   }
> >>
> >
> >
> > Shouldn't we decrease refcount for interface before the scsi host
> refcount is decreased..?
> > It doesn't probably make a difference here since we are having a 1:1
> between an interface and a host but it saves bugs later when things
> change..
> 
> Shyam, Thanks for the review.
> 
> Actually, it doesn't matter either way. When the hba refcount goes to
> 0,
> FIP controller and driver's command manager are destroyed which have no
> dependency on scsi_host. There is a 1-1 mapping between lport and the
> scsi_host, where as hba can have multiple scsi hosts, one per NPIV
> lport.

Yep... But I was thinking of a bonding scenario when ethX's are bonded together.

I guess the design will not take care of an FIP controller being common to more than one netdev interface.

Sorry.. for picking on this thread.. Agree with the fix.  I realize what I am suggesting requires that the API provided by libfc incorporate changes.
 
> 
> >
> > Also it probably makes sense to call scsi_host_put in bnx2fc_destroy
> rather than in bnx2fc_if_destroy..
> scsi_host is not only for the physical ports, but also for NPIV ports.
> scsi_host_put should also be called for NPIV ports, and hence
> bnx2fc_if_destroy is the right place to call scsi_host_put.

True.. and I see why you say that..

I think I am viewing a scsi_host as a controller at a higher layer than the netdev interface and hence imagining FCoE with features that netdev devices can offer and not really just be legacy FC running on another transport i.e. Ethernet.

It is possible to achieve NPIV and not be tied to one netdev interface as I guess NPIV is just an abstraction on what you see as a single physical port. 
For instance NPIV over a bond0 would be interesting.. as conceptually you are running your FC instance on a single physical port.

If that could happen it would be grand :-)

Copying Robert love(Intel) as I think folks that implement fcoe on netdev interfaces can take advantage of linux's software stack to achive this easily.

> 
> >
> > Maybe we could have more interfaces for a scsi host..
> >
> > Shout if this doesn't make any sense.
> >
> > -Shyam Iyer
> >
> >
> 

