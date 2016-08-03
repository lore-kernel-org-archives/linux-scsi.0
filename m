From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb: storage: fix runtime pm issue in usb_stor_probe2
Date: Wed, 3 Aug 2016 17:25:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1608031656060.2040-100000@iolanthe.rowland.org>
References: <0c83d917-678d-d4fc-3225-f2e8355f6280@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56404 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758478AbcHCVbp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2016 17:31:45 -0400
In-Reply-To: <0c83d917-678d-d4fc-3225-f2e8355f6280@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux USB Mailing List <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Wed, 3 Aug 2016, Heiner Kallweit wrote:

> Since commit 71723f95463d "PM / runtime: print error when activating a
> child to unactive parent" I see the following error message:
> 
> scsi host2: usb-storage 1-3:1.0
> scsi host2: runtime PM trying to activate child device host2 but parent
> 	    (1-3:1.0) is not active
> 
> Digging into it it seems to be related to the problem described in the
> commit message for cd998ded5c12 "i2c: designware: Prevent runtime
> suspend during adapter registration" as scsi_add_host also calls
> device_add and after the call to device_add the parent device is
> suspended.
> 
> Fix this by using the approach from the mentioned commit and getting
> the runtime pm reference before calling scsi_add_host.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

There's nothing wrong with this patch; it's a worthwhile thing to do 
because it can prevent an unnecessary runtime-suspend/resume cycle.

Still, it looks like the real problem here may lie in
drivers/scsi/hosts.c.  Commit bc4f24014de5 ("[SCSI] implement runtime
Power Management") added a call to pm_runtime_set_active() in
scsi_add_host_with_dma() _after_ device_add() instead of _before_.

If that were changed, this problem would not have occurred.

Alan Stern

