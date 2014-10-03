From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V6 10/18] scsi: ufs: manually add well known logical units
Date: Fri, 3 Oct 2014 09:35:34 -0700
Message-ID: <20141003163534.GA25051@infradead.org>
References: <1411648356-3883-1-git-send-email-draviv@codeaurora.org>
 <1411648356-3883-11-git-send-email-draviv@codeaurora.org>
 <CAC5umyhYko5woZhkroi3zm4ow8qp=DeCX62hcr0n3oxw4w8fjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34178 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaJCQfh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Oct 2014 12:35:37 -0400
Content-Disposition: inline
In-Reply-To: <CAC5umyhYko5woZhkroi3zm4ow8qp=DeCX62hcr0n3oxw4w8fjw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dolev Raviv <draviv@codeaurora.org>, Jej B <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>

On Sat, Oct 04, 2014 at 01:16:16AM +0900, Akinobu Mita wrote:
> These __scsi_add_device() calls for W-LUs increase the module reference
> count of ufshcd.ko by three.  But no one calls scsi_device_put() for
> these W-LUs, so it is impossible to unload ufshcd.ko.
> 
> There are scsi_remove_device() calls for W-LUs in ufshcd_scsi_remove_wlus(),
> But these calls do nothing (please see a comment below).
> 
> I could fix this issue by putting scsi_device_put() just after each
> __scsi_add_device() call.  I'll prepare a patch if I haven't missed
> something.


> When ufshcd_scsi_remove_wlus() is called in ufshcd_remove(), these
> three W-LU devices have already been deleted by scsi_remove_host() which
> is called just before ufshcd_scsi_remove_wlus().  The scsi
> device state of these W-LU devices is SDEV_DEL at this time, and
> scsi_remove_device() does nothing.


No, we need to keep a reference to avoid them going away due to a manual
delete.  We need a scsi_device_put where we currently call
scsi_remove_device I guess.
