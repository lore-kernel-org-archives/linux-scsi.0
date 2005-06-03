From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fix slab corruption during ipr probe
Date: Fri, 03 Jun 2005 09:14:04 -0500
Message-ID: <1117808044.5030.11.camel@mulgrave>
References: <20050602221509.GA11355@otto>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:44718 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261279AbVFCOOT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jun 2005 10:14:19 -0400
In-Reply-To: <20050602221509.GA11355@otto>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nathan Lynch <ntl@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, brking@us.ibm.com, linuxppc64-dev@ozlabs.org

On Thu, 2005-06-02 at 17:15 -0500, Nathan Lynch wrote:
> This patch works for me (tm); is it correct?
> 
> Signed-off-by: Nathan Lynch <ntl@pobox.com>

Yes, it is.

Apparently every other caller except IPR uses the standard
scsi_scan_target() interface, which does have this extra get_device(), I
can't think how it got left off the __scsi_add_device path ... well,
except that it wouldn't show up during testing.

I suppose someone should look at converting ipr to scsi_scan_target()
and we can eliminate this API (the only difference is that
scsi_add_device returns the actual device, but ipr never uses this...)

In the meantime, I'll put this in rc fixes.

Thanks,

James


