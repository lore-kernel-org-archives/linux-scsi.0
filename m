From: Christoph Hellwig <hch@lst.de>
Subject: Re: [REGRESSION v4.3] scsi_dh: use-after-free when removing scsi
	device
Date: Wed, 30 Sep 2015 17:18:57 +0200
Message-ID: <20150930151857.GA26594@lst.de>
References: <20150930003549.GA4857@xzibit.linux.bs1.fc.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35654 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbbI3PTA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Sep 2015 11:19:00 -0400
Content-Disposition: inline
In-Reply-To: <20150930003549.GA4857@xzibit.linux.bs1.fc.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>

On Wed, Sep 30, 2015 at 12:35:50AM +0000, Junichi Nomura wrote:
> With v4.3-rc3, stress testing of SCSI device addition/removal quickly
> trigger random crash in memory allocator (e.g. __kmalloc).  I found that
> a commit 086b91d052eb ("scsi_dh: integrate into the core SCSI code")
> moved the call of scsi_dh->detach() to very early part of sdev tear down
> process (scsi_remove_device()). As a result, related data structure such
> as alua_dh_data can be freed while rtpg/stpg are still in-flight.

Hi Junichi,

the code should have been called from that early in the process before,
as it was called from the bus notifier that was called first in device_del.

While something in this series obviously caused the regression are you
sure it's exactly this patch?
