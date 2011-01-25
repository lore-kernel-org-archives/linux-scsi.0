From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi: Erroneous handling of sense status in SCSI EH
 commands
Date: Tue, 25 Jan 2011 15:38:02 +0000
Message-ID: <1295969882.4955.82.camel@mulgrave.site>
References: <1295597274-5844-1-git-send-email-hare@suse.de>
	 <4D39F16A.5020002@cs.wisc.edu> <4D3D317D.6060403@suse.de>
	 <4D3DDE3F.2030902@cs.wisc.edu> <4D3E5D25.9000604@cs.wisc.edu>
	 <4D3E60F0.80407@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab1AYPiG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2011 10:38:06 -0500
In-Reply-To: <4D3E60F0.80407@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Mon, 2011-01-24 at 23:34 -0600, Mike Christie wrote:
> On 01/24/2011 11:18 PM, Mike Christie wrote:
> > On 01/24/2011 02:17 PM, Mike Christie wrote:
> >> For example, with your patch if for the
> >> scsi_send_eh_cmnd/scsi_eh_completed_normally/scsi_check_sense path we
> >> got 02/04/01 (not ready - becomming ready), scsi_send_eh_cmnd would see
> >> SOFT_ERROR and fail the scsi eh. And, I am saying don't we want retry
> >> this like we would if we were going through the normal IO path, so we do
> >> not offline devices on this type of failure?
> >>
> >
> > Just some corrections/clarifications. The device, target and bus reset
> > handling are ok, but just host reset handling seems like the problem (at
> > least the problem I was hitting I think). We do not call
> > __scsi_report_device_reset for host reset handling, but some LLD
> > eh_host_reset_handler implementations execute operations that can cause
> > us to get something like a UA for the scsi eh TUR. For your patch do you
> > also want to call __scsi_report_device_reset for the host reset handling
> > for these drivers then?
> 
> Ignore that. I see it is getting called for the host reset code. I am 
> not sure what happened when I was testing it.

Just so I'm clear ... that's you withdrawing all objections to this
patch, so I can put it in scsi-misc for testing?

James


