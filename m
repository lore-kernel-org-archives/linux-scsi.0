From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] LLDD dynamic scan aids
Date: Thu, 18 Nov 2004 07:48:14 -0800
Message-ID: <20041118154814.GA8553@us.ibm.com>
References: <60807403EABEB443939A5A7AA8A7458B694682@otce2k01.adaptec.com> <20041118143644.GA23365@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:6561 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262535AbUKRPsW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2004 10:48:22 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.10/8.12.9) with ESMTP id iAIFmKKv584078
	for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2004 10:48:20 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iAIFmKf0279722
	for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2004 10:48:20 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id iAIFmJHR024211
	for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2004 10:48:20 -0500
Content-Disposition: inline
In-Reply-To: <20041118143644.GA23365@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org, Mark Haverkamp <markh@osdl.org>

On Thu, Nov 18, 2004 at 02:36:44PM +0000, Christoph Hellwig wrote:
> On Thu, Nov 18, 2004 at 09:32:09AM -0500, Salyzyn, Mark wrote:
> > But scsi_rescan_device and scsi_scan_host_selected both target specific
> > ids though? As long as we stay away from the wildcards for
> > scsi_scan_host_selected, or am I mistaken?
> 
> scsi_rescan_device should be exported.  For the target scan something
> like the second hunk of James' patch looks good to me.

Why not export scsi_scan_host_selected (and SCAN_WILD_CARD)? If a driver
used it wrong then change the driver.

Suppose a driver wants to scan a given channel. (Would one ever want to
scan for a particular a LUN? I can't think of a reason).

If the driver wants to rescan the host (it knows it it has already
called any scsi scan functions), it would call:

	scsi_scan_host_selected(shost, SCAN_WILD_CARD,
		SCAN_WILD_CARD, SCAN_WILD_CARD, 1);

And new target scan:

	scsi_scan_host_selected(shost, chan, id, SCAN_WILD_CARD, 0);

Target rescan:

	scsi_scan_host_selected(shost, chan, id, SCAN_WILD_CARD, 1);

Instead of any shost->rescan logic.

-- Patrick Mansfield
