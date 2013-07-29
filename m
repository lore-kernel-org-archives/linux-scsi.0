From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Kernel 3.10.3 "reset SuperSpeed USB device number 2 using
 xhci_hcd"
Date: Mon, 29 Jul 2013 11:23:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1307291108460.1479-100000@iolanthe.rowland.org>
References: <yq1ob9ljtht.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:37274 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755835Ab3G2PXD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jul 2013 11:23:03 -0400
In-Reply-To: <yq1ob9ljtht.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Stuart Foster <smf.linux@ntlworld.com>, Ed Tomlinson <edt@aei.ca>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, stable@vger.kernel.org

On Mon, 29 Jul 2013, Martin K. Petersen wrote:

> >>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:
> 
> Alan,
> 
> Alan> It was introduced by commit 98dcc2946adb (SCSI: sd: Update WRITE
> Alan> SAME heuristics).  This commit adds a call to scsi_get_vpd_page()
> Alan> in sd_read_write_same() without first checking
> Alan> sd_try_extended_inquiry().  As noted in the latter routine, VPD
> Alan> inquiries will crash some devices.
> 
> Is REPORT SUPPORTED OPERATION CODES generally safe on USB devices?

Broadly speaking, practically nothing is safe on USB devices.  :-)  The 
general rule is: If Windows XP doesn't use the command then it will 
crash something.

In the case of these bug reports, the scsi_report_opcode() call returns 
-EINVAL.

> The reason I didn't wrap the WRITE SAME heuristics in
> sd_try_extended_inquiry() like I have done with most of the other VPDs
> is that there are a ton of older SPI/SAS/FC devices that support WRITE
> SAME just fine.
> 
> 
> Alan> As far as the stable kernels are concerned, the best thing for now
> Alan> may simply be to revert it.
> 
> No go. The above commit fixes issues for somebody else.
> 
> I could add an explicit check to the sd_read_write_same() function. But
> how about we do the following instead?

Stuart and Ed, does Martin's patch fix your problem?

Alan Stern

