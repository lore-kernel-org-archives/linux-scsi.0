From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V5 02/17] scsi: sysfs: don't add scsi_device if its
 already added
Date: Wed, 24 Sep 2014 09:08:25 -0700
Message-ID: <20140924160825.GB13541@infradead.org>
References: <1411571653-22729-1-git-send-email-draviv@codeaurora.org>
 <1411571653-22729-3-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56762 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaIXQI0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Sep 2014 12:08:26 -0400
Content-Disposition: inline
In-Reply-To: <1411571653-22729-3-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>

On Wed, Sep 24, 2014 at 06:13:58PM +0300, Dolev Raviv wrote:
> From: Subhash Jadavani <subhashj@codeaurora.org>
> 
> If LLD has added scsi device (by calling scsi_add_device) before scheduling
> async scsi_scan_host then scsi_finish_async_scan() will end up calling
> scsi_sysfs_add_sdev for scsi device which was already added by LLD.
> This patch fixes this issue by adding a check at the start of
> scsi_sysfs_add_sdev() to skip the device add if it's already visible to
> rest of the kernel.

This looks wrong to me.   I guess this happens for the case where you
added the well known lun explicitly, and then have one of the devices
that also report it from REPORT LUNS?  I guess the right answer is
to explicitly ignore wluns in scsi_report_lun_scan.

