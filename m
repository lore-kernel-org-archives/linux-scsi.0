From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC][PATCH] fix for async scsi scan sysfs problem (resend)
Date: Mon, 23 Apr 2007 14:26:26 -0400
Message-ID: <1177352786.6284.51.camel@mulgrave.il.steeleye.com>
References: <20070419132459.GB1481@korben.rdu.redhat.com>
	 <1176991356.31764.3.camel@mulgrave.il.steeleye.com>
	 <20070419150655.GC1481@korben.rdu.redhat.com>
	 <20070421002345.673d9988.akpm@linux-foundation.org>
	 <20070421135956.GA22873@korben.rdu.redhat.com>
	 <20070423181318.GD22873@korben.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:49706 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161268AbXDWS0n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Apr 2007 14:26:43 -0400
In-Reply-To: <20070423181318.GD22873@korben.rdu.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Josef Bacik <jwhiter@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

On Mon, 2007-04-23 at 14:13 -0400, Josef Bacik wrote:
> Ok I have a new patch that I've built and tested on both my UP and SMP machine
> and it appears to work fine.  I took the async check out of scsi_add_lun, I
> don't really see the point in waiting to do the sysfs registration stuff (if
> theres a reason I haven't been able to find it in the original submission of
> this functionality).  Please let me know if this is incorrect.  Thank you,

Yes, it's incorrect ... if you do this, the devices will come up in a
random order for multiple SCSI cards.  One of the original design goals
was not to require udev, so the final ordering should be the same as for
the sync case.

I think the root cause of the problem is somewhere in the fc transport
rport addition code.

James


