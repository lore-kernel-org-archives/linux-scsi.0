From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [linux-usb-devel] 2.6.11-rc3-bk5, oops in scsi_try_bus_reset
Date: Mon, 14 Feb 2005 21:41:24 -0800
Message-ID: <20050215054124.GB24534@us.ibm.com>
References: <20050210105650.GA1070@suse.de> <Pine.LNX.4.44L0.0502101002120.887-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from e1.ny.us.ibm.com ([32.97.182.141]:30604 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261642AbVBOHJY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2005 02:09:24 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j1F79NPR021400
	for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2005 02:09:23 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1F79Na5183918
	for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2005 02:09:23 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j1F782TA016661
	for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2005 02:09:23 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0502101002120.887-100000@ida.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Olaf Hering <olh@suse.de>, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Michael Christie <mikenc@us.ibm.com>

Alan Stern [stern@rowland.harvard.edu] wrote:
> And Mike Anderson's response was
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=110538854224319&w=2
> 
> His explanation was "Currently scsi_host_cancel being called from
> scsi_remove_host appears to not do anything as scsi_forget_host removes
> the devices from the list it iterates over."  I don't know whether this 
> problem has been fixed yet.
> 


No, this has not been fixed yet, but needs to be. 

In discussing this with Mike C today he had a patch that would drain the
devices queues prior to scsi_forget_host returning which may help in this
case. 

Along with Mike C's change we could remove the scsi_host_cancel code
(since it does not do anything and when it did it was racey), and shutdown
the error handler thread in scsi_remove_host (reduce possible callers into
the LLDD post scsi_remove_host).

Mike C or I will have something out soon on this.

-andmike
--
Michael Anderson
andmike@us.ibm.com

