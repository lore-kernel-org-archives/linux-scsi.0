From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 8122] New: Scsi_Host's n_io_port forgot to be
 initialized?
Date: Mon, 5 Mar 2007 19:17:30 -0800
Message-ID: <20070305191730.8f695adf.akpm@linux-foundation.org>
References: <200703040919.l249JWSs008220@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48658 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933890AbXCFDRm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Mar 2007 22:17:42 -0500
In-Reply-To: <200703040919.l249JWSs008220@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, shanlu@cs.uiuc.edu

On Sun, 4 Mar 2007 01:19:32 -0800 bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8122
> 
>            Summary: Scsi_Host's n_io_port forgot to be initialized?
>     Kernel Version: Linux 2.6.20
>             Status: NEW
>           Severity: normal
>              Owner: scsi_drivers-other@kernel-bugs.osdl.org
>          Submitter: shanlu@cs.uiuc.edu
> 
> 
> Most recent kernel where this bug did *NOT* occur: No
> Distribution: Linux-2.6.20
> Problem Description:
> It seems that usually structure Scsi_Host's io_port field and n_io_port field
> needs to be set together.
> However, in file drivers/scsi/dmx3191d.c,
> function dmx3191d_probe_one
> 71  static int __devinit dmx3191d_probe_one(struct pci_dev *pdev,
> 72              const struct pci_device_id *id)
> ...
> 88      shost = scsi_host_alloc(&dmx3191d_driver_template,
> 89                      sizeof(struct NCR5380_hostdata));
> 90      if (!shost)
> 91              goto out_release_region;
> 92      shost->io_port = io;
> 93      shost->irq = pdev->irq;
> ...
> 109     error = scsi_add_host(shost, &pdev->dev);
> 
> only io_port is set and n_io_port is uninitialized. Won't this cause some
> problem? I fear when some code tries to calculate the io_port region (from
> io_port to io_port+n_io_port-1 is regarded as the port region), there would be
> problem.
> 
> It seems that in all other similar scsi device's similar functions, like
> dc390_probe_one and inia100_probe_one, io_port and n_io_port are both set. This
> makes me think above dmx3191d.c's missing n_io_port at least a potential danger.
> 
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug, or are watching someone who is.
