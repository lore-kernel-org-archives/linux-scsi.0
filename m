From: "Smart, James" <James.Smart@Emulex.com>
Subject: RE: Is there a grand plan for FC failover?
Date: Wed, 28 Jan 2004 16:02:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF2802C013B0@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:8673 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S266021AbUA1VE2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2004 16:04:28 -0500
List-Id: linux-scsi@vger.kernel.org
To: 'Patrick Mansfield' <patmans@us.ibm.com>, "Philip R. Auld" <pauld@egenera.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Simon Kelley <simon@thekelleys.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, dm-devel@sistina.com

I'd add one additional issue :

3) SCSI Reservations

I guess this could be considered a part of (2), but given that reservations
bring in a host of additional problems, and potentially brings up multi-host
configs/clusters as well...

-- James S


> -----Original Message-----
> From: Patrick Mansfield [mailto:patmans@us.ibm.com]
> Sent: Wednesday, January 28, 2004 3:48 PM
> To: Philip R. Auld
> Cc: James Bottomley; Simon Kelley; SCSI Mailing List;
> dm-devel@sistina.com
> Subject: Re: Is there a grand plan for FC failover?
> 
> 
> [cc-ing dm-devel]
> 
> My two main issues with dm multipath versus scsi core multipath are:
> 
> 1) It does not handle character devices.
> 
> 2) It does not have the information available about the state of the
> scsi_device or scsi_host (for path selection), or about the elevator.
> 
> If we end up passing all the scsi information up to dm, and 
> it does the
> same things that we already do in scsi (or in block), what is 
> the point of
> putting the code into a separate layer?
> 
> More scsi fastfail like code is still needed - probably for 
> all the cases
> where scsi_dev_queue_ready and scsi_host_queue_ready return 0 
> - and more.
> For example, should we somehow make sdev->queue_depth available to dm?
> 
> There are still issues with with a per path elevator (i.e. we have an
> elevator for each path rather than the entire device) that 
> probably won't
> be fixed cleanly in 2.6. AFAIUI this requires moving dm from 
> a bio based
> approach to a request based one.
> 
> -- Patrick Mansfield
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
