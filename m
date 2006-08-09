From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] [Last Rites] fc transport: extensions for fast fail and dev loss
Date: Wed, 9 Aug 2006 18:36:43 +0100
Message-ID: <20060809173643.GA22969@infradead.org>
References: <1150829123.16981.1.camel@localhost.localdomain> <44D8CFD3.9050408@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:35781 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751278AbWHIRgp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Aug 2006 13:36:45 -0400
Content-Disposition: inline
In-Reply-To: <44D8CFD3.9050408@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org

On Tue, Aug 08, 2006 at 01:54:27PM -0400, James Smart wrote:
> >Here's what is contained:
> >
> >- dev_loss_tmo LLDD callback :
> >  Currently, there is no notification to the LLDD of when the transport
> >  gives up on the device returning and starts to return DID_NO_CONNECT
> >  in the queuecommand helper function. This callback notifies the LLDD
> >  that the transport has now given up on the rport, thereby acknowledging
> >  the prior fc_remote_port_delete() call. The callback also expects the
> >  LLDD to initiate the termination of any outstanding i/o on the rport.
> 
> I believe there is no dissention on this change.
> Please note: this is essentially a confirmation from the transport to the
>   LLD that the rport is fully deleted. Thus, the LLD must expect to see
>   these callbacks as a normal part of the rport being terminated (even if
>   it is not blocked).
> 
> I'll move forward with this.

ACK.

> >- fast_io_fail_tmo and LLD callback:
> >  There are some cases where it may take a long while to truly determine
> >  device loss, but the system is in a multipathing configuration that if
> >  the i/o was failed quickly (faster than dev_loss_tmo), it could be
> >  redirected to a different path and completed sooner (assuming the 
> >  multipath thing knew that the sdev was blocked).
> >  
> >  iSCSI is one of the transports that may vary dev_loss_tmo values
> >  per session, and you would like fast io failure.
> 
> 
> The current transport implementation did not specify what happened to
>   active i/o (given to the driver, in the adapter, but not yet completed
>   back to the midlayer) when a device was blocked, nor during the
>   block-to->dev_loss transition period. It was up to the driver.  Many
>   assumed active i/o was immediately terminated, which is semi-consistent
>   with the behavior of most drivers for most "connectivity loss" scenarios.
> 
> The conversations then started to jump around, considering what i/o's you
>   may want to have fail quickly, etc.
> 
> Here's my opinion:
>   We have the following points in time to look at:
>    (a) the device is blocked by the transport
>    (b) there is a time T, usually in a multipathing environment, where it
>        would be useful to error the i/o early rather than wait for dev_loss
>        It is assumed that any such i/o request would be marked REQ_FASTFAIL
>    (c) the dev_loss_tmo fires - we're to assume the device is gone
>   and at any time post (a), the device may return, unblock and never
>   encounter points (b) and (c).
> 
>   As for what happens to active i/o :
> 
>   always: the driver can fail an i/o at any point in time if it deems
>           it appropriate.
> 
>   at (a): There are scenarios where a short link perturbation may occur,
>           which may not disrupt the i/o. Therefore, we should not force
>           io to be terminated.

Ok..

> 
>   at (b): Minimally, we should terminate all active i/o requests marked
>           as type REQ_FASTFAIL. From an api perspective, driver support
>           for this is optional. And we must also assume that there will
>           be implementations which have to abort all i/o in order to
>           terminate those marked REQ_FASTFAIL. Is this acceptable ?
>           (it meets the "always" condition above)
> 
>           Q: so far we've limited the io to those w/ REQ_FASTFAIL.
>             Would we ever want to allow a user to fast fail all i/o
>             regardless of the request flags ? (in case they flags
>             weren't getting set on all the i/o the user wanted to
>             see fail ?)

I think we should fail all.  It's not like an unprivilegued process could
request FASTFAIL.  The administrator should know what she/he is doing.

>           There's a desire to address pending i/o (those on the block
>           request queue or new requests going there) so that if we've
>           crossed point (b) that we also fail them.  The proposal is
>           to add a new state (device ? or queue ?), which would occur
>           as of point (b). All REQ_FASTFAIL io on the queue, as well
>           as on a new io, will be failed with a new i/o status if in
>           this state. Non-REQ_FASTFAIL i/o would continue to enter/sit
>           on the request queue until dev_loss_tmo fires.

We have a queue per device, so adding another scsi_device state sound
like the right way to go aheade.

>   at (c): per the dev_loss_tmo callback, all i/o should be terminated.
>           Their completions do not have to be synchronous to the return
>           from the callback - they can occur afterward.

ACK.



> >- fast_loss_time recommendation:
> >  In discussing how a admin should set dev_loss_tmo in a multipathing
> >  environment, it became apparent that we expected the admin to know
> >  a lot. They had to know the transport type, what the minimum setting
> >  can be that still survives normal link bouncing, and they may even
> >  have to know about device specifics.  For iSCSI, the proper loss time
> >  may vary widely from session to session.
> >
> >  This attribute is an exported "recommendation" by the LLDD and transport
> >  on what the lowest setting for dev_loss_tmo should be for a multipathing
> >  environment. Thus, the admin only needs to cat this attribute to obtain
> >  the value to echo into dev_loss_tmo.
> 
> The only objection was from Christoph - wanting a utility to get/set this
> stuff. However, the counter was this attribute was still meaningful, as it
> was the conduit to obtain a recommendation from the transport/LLD.
> 
> So - I assume this proceeds as is - with a change in it's description.

I must say I'm still not happy with this.  It's really policy that we
try to keep out of the kernel.
