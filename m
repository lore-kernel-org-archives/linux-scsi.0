From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [RFC] adding per scsi-host workqueues for defered processing
Date: Mon, 7 Mar 2005 23:10:22 -0800
Message-ID: <20050308071022.GF5141@plap.qlogic.org>
References: <0B1E13B586976742A7599D71A6AC733C12ECD6@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from avexch01.qlogic.com ([198.70.193.200]:21691 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261842AbVCHHJv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Mar 2005 02:09:51 -0500
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12ECD6@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Sat, 05 Mar 2005, James.Smart@Emulex.Com wrote:

> I've attached a revised patch.
> 
> One other note:
> >		scsi_scan_target(&rport->dev, rport->channel,
> >			rport->scsi_target_id, SCAN_WILD_CARD, 0);
> 
> The rescan flag should be 1, not 0. If 0, all kinds of bad things can
> happen as of the 2nd scan request.
> 

Unless I'm reading the code incorrectly, we should be safe (only by
possessing some internal knowledge of the mid-layer) passing 0 in
these contexts:

* role change to target -- no previous devices (let alone
  scsi-targets) should be hanging off the rport.
* during creation, an rport is newly created with fc_rport_create().
* during creation, an rport was found in the fc_host_rport_bindings'
  list.  Again, any attached scsi-devices would have been torn-down
  prior to the rport being originally placed in the list.
* during an unblock call, where the rport's scsi-devices have already
  been torn down since the link-down-tmo had already expired.

But, I suppose in general it's best to play it safe.

--
AV
