From: "Subhash Jadavani" <subhashj@codeaurora.org>
Subject: RE: [PATCH V3 01/16] scsi: support well known logical units
Date: Thu, 11 Sep 2014 17:41:18 -0700
Message-ID: <000f01cfce22$446f79c0$cd4e6d40$@codeaurora.org>
References: <1410350063-23267-1-git-send-email-draviv@codeaurora.org> <1410350063-23267-2-git-send-email-draviv@codeaurora.org> <20140910185839.GA26364@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:53416 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbaILAlT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Sep 2014 20:41:19 -0400
In-Reply-To: <20140910185839.GA26364@infradead.org>
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>, 'Dolev Raviv' <draviv@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, 'Sujit Reddy Thumma' <sthumma@codeaurora.org>, "'Martin K. Petersen'" <martin.petersen@oracle.com>

> This is the defintion of the field in SPC (does the UFS spec duplicate all
of SPC?), 
Yes, UFS device specification (both 1.1 and 2.0) supports
[SAM], INCITS T10 draft standard: SCSI Architecture Model - 5 (SAM-5),
Revision 05, 19 May 2010  
[SPC], INCITS T10 draft standard: SCSI Primary Commands - 4 (SPC-4),
Revision 27, 11 October 2010 
[SBC], INCITS T10 draft standard: SCSI Block Commands - 3 (SBC-3), Revision
24, 05 August 2010  

In addition, this is what specification says explicitly " SCSI SBC and SPC
commands are the baseline for UFS. UFS will not modify the SBC and SPC
Compliant commands.  The goal is to maximize re-use and leverage of the
software codebase available on platforms (PC, netbook, MID) that are already
supporting SCSI."

> but still doesn't explain why you want it.

UFS device has supports 4 different well known logical units: "REPORT_LUNS"
(address: 01h), "UFS Device" (address: 50h), "RPMB" (address: 44h) and
"BOOT" (address: 30h).

UFS device's power management needs to be controlled by "POWER CONDITION"
field of SSU (START STOP UNIT) command. But this "power condition"  field
will take effect only when its sent to "UFS device" well known logical unit
(address: 50h) hence we require the scsi_device instance to represent this
logical unit in order for the UFS host driver to send the SSU command for
power management.

We also require the scsi_device instance for "RPMB" (Replay Protected Memory
Block) LU so user space process can control this LU.

> Also the SELECT REPORT field only appeared in SPC-3, so we should not set
it for devices that report older standards compliance.

Thanks for pointing this out, was not aware of this. We will add appropriate
check (if (sdev->scsi_level >= SCSI_SPC_3))  before setting the SELECT
REPORT field.

Regards,
Subhash

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Christoph Hellwig
Sent: Wednesday, September 10, 2014 11:59 AM
To: Dolev Raviv
Cc: James.Bottomley@HansenPartnership.com; hch@infradead.org;
linux-scsi@vger.kernel.org; linux-scsi-owner@vger.kernel.org;
linux-arm-msm@vger.kernel.org; santoshsy@gmail.com; Subhash Jadavani; Sujit
Reddy Thumma; Martin K. Petersen
Subject: Re: [PATCH V3 01/16] scsi: support well known logical units

On Wed, Sep 10, 2014 at 02:54:08PM +0300, Dolev Raviv wrote:
> From: Subhash Jadavani <subhashj@codeaurora.org>
> 
> REPORT LUNS command has "SELECT REPORT" field which controls what type 
> of logical units to be reported by device server. According to UFS 
> device standard, if this field is set to 0, REPORT LUNS would report 
> only report standard logical units. If it's set to 1 then it would 
> report only well known logical unit and if it's set to 2 then device 
> would report both standard and well known logical units.

This is the defintion of the field in SPC (does the UFS spec duplicate all
of SPC?), but still doesn't explain why you want it.

Also the SELECT REPORT field only appeared in SPC-3, so we should not set it
for devices that report older standards compliance.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

