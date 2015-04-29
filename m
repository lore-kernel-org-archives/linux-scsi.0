From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] scsi: proper state checking and module refcount
	handling in scsi_device_get
Date: Wed, 29 Apr 2015 15:27:58 +0200
Message-ID: <20150429132758.GA4048@lst.de>
References: <1422882086-1863-1-git-send-email-hch@lst.de> <1422882086-1863-3-git-send-email-hch@lst.de> <CAC5umyiSEmBOLT2MeztTq8z5-wE3koXpRQkD+tuX8b-PMg-e+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45796 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422884AbbD2N2A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Apr 2015 09:28:00 -0400
Content-Disposition: inline
In-Reply-To: <CAC5umyiSEmBOLT2MeztTq8z5-wE3koXpRQkD+tuX8b-PMg-e+A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>

On Wed, Apr 29, 2015 at 10:17:59AM +0900, Akinobu Mita wrote:
> This change broke ufs driver.

I'd claim the ufs driver, or rather more specifily the ufs spec
had already been broken.  That whole concept of keeping references
to scsi devices to send commands to for host state changes is just
fundamentally broken.  

> The reason for scsi_device_get() in ufshcd_set_dev_pwr_mode() is
> to avoid manual delete of UFS device W-LUN by holding the reference
> to it.  So can we acquire shost->scan_mutex lock instead of
> scsi_device_get()?  I tried attached patch and it seems to be working,
> but I would like to ask your opinion about this change.

It seems like a reasonable workaround.  But then again the concept
of the driver hanging on scsi_devices is and will stay broken.
