From: "'Patrick Mansfield'" <patmans@us.ibm.com>
Subject: Re: suspending I/Os to a device
Date: Mon, 26 Apr 2004 14:26:05 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040426142605.A6383@beaverton.ibm.com>
References: <8D43EFD7CCBDB24980134BE078C227E704E37A88@xcm.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:13507 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263585AbUDZV01 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Apr 2004 17:26:27 -0400
Content-Disposition: inline
In-Reply-To: <8D43EFD7CCBDB24980134BE078C227E704E37A88@xcm.emulex.com>; from Jon.Infante@Emulex.Com on Mon, Apr 26, 2004 at 10:12:18AM -0700
List-Id: linux-scsi@vger.kernel.org
To: "Infante, Jon" <Jon.Infante@Emulex.Com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>

On Mon, Apr 26, 2004 at 10:12:18AM -0700, Infante, Jon wrote:
> 
> So it may be better to make this a hotplug feature since it is not
> necessarily FC specific? When the FC driver gets a LIP or RSCN event, there
> is potential for a device to be removed, or a new device added. In addition
> to add / remove if there was a suspended state the device could put in,
> assuming it would transition to added or removed shortly afterwards, that
> would also meet the requirements for FC.

I didn't mean to imply use of hotplug, just that the feature might be
useful for transports other than FCP.

If it were hotplug based that would be really nice, but currently linux
scsi can't handle moving a device to a different port. Generally, we can't
change the host/chan/id/lun for a given scsi_device, instead you must
remove and add the device (either physically if the hardware notices
the addition and removal, or manually via scsi sysfs interfaces).

Current hotplug could handle the addition of a new target (or LUN), we've
discussed this before. If the adapter generates a hotplug event for a new
target, user code could scan the new target.

-- Patrick Mansfield
