From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] scsi_aen: fix event locking problems
Date: Sun, 28 Oct 2007 16:52:52 -0400
Message-ID: <4724F6A4.6050200@garzik.org>
References: <1193600318.3333.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:45266 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbXJ1Uwz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Oct 2007 16:52:55 -0400
In-Reply-To: <1193600318.3333.26.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> There was a fundamental flaw in the initial code, in that it had no
> locking around scsi_device_event_notify().  This is a problem because
> execute_in_process_context() also has no locking (it expects the caller
> to do the work).  This means that two events firing simultaneously could
> potentially corrupt each other.  This might be unlikely for media change
> events, but it will become more likely as we use this call as the engine
> for other SCSI AENs.
> 
> The best fix looks to be simply not to use sdev->ew for the source of
> the execute_work queue.  Further, since kzalloc() always has to give us
> at least 32 bytes and we're doing an allocation anyway, it's free to
> shove the execute_work structure into scsi_device_event_info and
> eliminate all of the other locking and the work queue list.
> 
> I also separated the aen headers out into scsi_aen.h and cleaned up the
> uevent processing (there's no real need to define the strings anywhere
> other than in scsi_aen_uevent_notifier() ... especially as I envisage
> there will be more complex strings for some SCSI events.
> 
> Finally, I exported and made available scsi_aen_chain for the things
> that will attach to it.

You missed an updated version (which was CC'd to you).

	Jeff



