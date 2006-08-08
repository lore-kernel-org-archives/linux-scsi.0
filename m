From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] Don't add scsi_device for devices that return PQ=1, PDT=0x1f
Date: Tue, 8 Aug 2006 17:34:17 +0200
Message-ID: <20060808153417.GA1542@lst.de>
References: <44C9226C.6030309@netapp.com> <20060805120103.GA22356@lst.de> <44D6D79E.3020304@netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:29414 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964959AbWHHPeu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2006 11:34:50 -0400
Content-Disposition: inline
In-Reply-To: <44D6D79E.3020304@netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Wysochanski <davidw@netapp.com>
Cc: Christoph Hellwig <hch@lst.de>, usb-storage@lists.one-eyed-alien.net, stern@rowland.harvard.edu, James.Bottomley@steeleye.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, hare@suse.de, "Kraft, Claire" <Claire.Kraft@netapp.com>, "Shenoy, Raghavendra" <Raghavendra.Shenoy@netapp.com>, "George, Martin" <marting@netapp.com>, "Nair, Vinod K" <nvinod@netapp.com>

On Mon, Aug 07, 2006 at 02:03:10AM -0400, Dave Wysochanski wrote:
> I'm not sure Alan's pdt_1f_for_no_lun flag should be used in my case,
> since I would want to set it based on vid/pid

I don't think we should set any flag for the netapp behaviour.  It might
be stretching the standard a little, but it's not completely odd and I
can't think of anything bad that could hapen if we do it unconditonally.

Something like:

	if ((result[0] >> 5) == 1 || starget->some_flag) &&
	    (result[0] & 0x1f) == 0x1f) {
	    	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
			"scsi scan: peripheral device type"
			" of 31, no device added\n"));
		res = SCSI_SCAN_TARGET_PRESENT;
		goto out_free_result;
	}

