From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH as470] Add a NOREPORTLUN blacklist flag
Date: Mon, 21 Feb 2005 09:52:05 -0800
Message-ID: <20050221175205.GA7495@us.ibm.com>
References: <20050220195927.398c57e4.vsu@altlinux.ru> <Pine.LNX.4.44L0.0502202236350.9805-100000@netrider.rowland.org> <20050221064709.GA30205@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from e33.co.us.ibm.com ([32.97.110.131]:56477 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S262053AbVBURws
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2005 12:52:48 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j1LHqV0D660390
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 12:52:32 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1LHqV8D126480
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 10:52:31 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j1LHqUai010380
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 10:52:31 -0700
Content-Disposition: inline
In-Reply-To: <20050221064709.GA30205@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>, Sergey Vlasov <vsu@altlinux.ru>, Samuel Colin <Samuel.Colin3@wanadoo.fr>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Sun, Feb 20, 2005 at 10:47:09PM -0800, Matthew Dharm wrote:
> On Sun, Feb 20, 2005 at 10:44:21PM -0500, Alan Stern wrote:

> > Matt, it looks like the best way to solve this problem is to go back to
> > the old strategy of always setting the SCSI revision to 2 (no matter what
> > it might actually be), at least for Direct Access devices.  That would
> > suppress the REPORT_LUNS command.  Would we lose anything by doing this?
> 
> Besides the use of REPORT_LUNS on devices which actually support it?  I
> don't think so...

It would only matter if the device had sparse luns (multiple luns/disks
that are not consecutively numbered).

You can always dynamically add it to the black list to force REPORT LUN
usage (for SCSI_2 devices) via BLIST_REPORTLUN2, and if it did not support
REPORT LUNS add it as sparse lun via BLIST_SPARSELUN.

Samuel or other owners of the hardware: did you check for firmware
updates? You should make sure the hardware vendor at least knows about the
problem.

The bridge hardware (USB/firewire to ide) should probably mark it as SCSI
2, and it should be fixed to handle and fail the REPORT LUN in a sane way. 

> I wonder if printing a warning if sdev->scsi_level > SCSI_2 would be
> useful...

Probably not.

-- Patrick Mansfield
