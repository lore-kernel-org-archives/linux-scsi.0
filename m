From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Is there a grand plan for FC failover?
Date: Wed, 28 Jan 2004 12:47:56 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040128124756.A7232@beaverton.ibm.com>
References: <401521A7.5030808@thekelleys.org.uk> <1075131446.2290.29.camel@mulgrave> <20040128100236.D11527@vienna.EGENERA.COM> <1075309052.2254.6.camel@mulgrave> <20040128130040.E11527@vienna.EGENERA.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:6898 "EHLO e31.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S266083AbUA1Usb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2004 15:48:31 -0500
Content-Disposition: inline
In-Reply-To: <20040128130040.E11527@vienna.EGENERA.COM>; from pauld@egenera.com on Wed, Jan 28, 2004 at 01:00:40PM -0500
List-Id: linux-scsi@vger.kernel.org
To: "Philip R. Auld" <pauld@egenera.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Simon Kelley <simon@thekelleys.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, dm-devel@sistina.com

[cc-ing dm-devel]

My two main issues with dm multipath versus scsi core multipath are:

1) It does not handle character devices.

2) It does not have the information available about the state of the
scsi_device or scsi_host (for path selection), or about the elevator.

If we end up passing all the scsi information up to dm, and it does the
same things that we already do in scsi (or in block), what is the point of
putting the code into a separate layer?

More scsi fastfail like code is still needed - probably for all the cases
where scsi_dev_queue_ready and scsi_host_queue_ready return 0 - and more.
For example, should we somehow make sdev->queue_depth available to dm?

There are still issues with with a per path elevator (i.e. we have an
elevator for each path rather than the entire device) that probably won't
be fixed cleanly in 2.6. AFAIUI this requires moving dm from a bio based
approach to a request based one.

-- Patrick Mansfield
