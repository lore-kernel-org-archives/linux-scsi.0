From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [PATCH V3 01/16] scsi: support well known logical units
Date: Sat, 13 Sep 2014 11:54:31 -0700
Message-ID: <20140913185431.GB30010@infradead.org>
References: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
 <1410350063-23267-2-git-send-email-draviv@codeaurora.org>
 <20140910185839.GA26364@infradead.org>
 <000f01cfce22$446f79c0$cd4e6d40$@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60430 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaIMSyc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Sep 2014 14:54:32 -0400
Content-Disposition: inline
In-Reply-To: <000f01cfce22$446f79c0$cd4e6d40$@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: 'Christoph Hellwig' <hch@infradead.org>, 'Dolev Raviv' <draviv@codeaurora.org>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, 'Sujit Reddy Thumma' <sthumma@codeaurora.org>, "'Martin K. Petersen'" <martin.petersen@oracle.com>

On Thu, Sep 11, 2014 at 05:41:18PM -0700, Subhash Jadavani wrote:
> 
> UFS device has supports 4 different well known logical units: "REPORT_LUNS"
> (address: 01h), "UFS Device" (address: 50h), "RPMB" (address: 44h) and
> "BOOT" (address: 30h).
> 
> UFS device's power management needs to be controlled by "POWER CONDITION"
> field of SSU (START STOP UNIT) command. But this "power condition"  field
> will take effect only when its sent to "UFS device" well known logical unit
> (address: 50h) hence we require the scsi_device instance to represent this
> logical unit in order for the UFS host driver to send the SSU command for
> power management.
> 
> We also require the scsi_device instance for "RPMB" (Replay Protected Memory
> Block) LU so user space process can control this LU.

If those are the only LUs you specificly need I'd suggest you just
manually call scsi_add_device from your driver for those instead of
listing them in REPORT_LUNS and making them part of the normal LUN
scan.  One advantage of the well known LUNs is that you always know
where in the LUN namespace they are :)

