From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] pull scsi_scan_host out of scsi_add_host
Date: Tue, 8 Jul 2003 10:23:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030708082316.GA13384@lst.de>
References: <20030707143056.GA1177@lst.de> <20030708080334.GA2451@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:52406 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265525AbTGHIIt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2003 04:08:49 -0400
Content-Disposition: inline
In-Reply-To: <20030708080334.GA2451@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Tue, Jul 08, 2003 at 01:03:35AM -0700, Mike Anderson wrote:
> Would we want to make a symmetric interface and pull the
> unscan out of scsi_remove_host also?

It would make sense if we something like an unscan.  But the closest
thing to an unscan is scsi_forget_host which just releases the
scsi_device structures.  Given that we can't free a host without
releasing the devices first and scsi_forget_host is a noop if
shost->my_devices is empty I don't this makes gains anything.

