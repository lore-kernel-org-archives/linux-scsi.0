From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi-misc-2.5 user per-device spare command
Date: Fri, 25 Apr 2003 17:50:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030425175035.A4689@infradead.org>
References: <20030424100229.A32098@beaverton.ibm.com> <20030424100317.A32134@beaverton.ibm.com> <20030425111227.B28577@infradead.org> <20030425093718.A8776@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.mvhi.com ([195.224.96.167]:22796 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263201AbTDYQi3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2003 12:38:29 -0400
Content-Disposition: inline
In-Reply-To: <20030425093718.A8776@beaverton.ibm.com>; from patmans@us.ibm.com on Fri, Apr 25, 2003 at 09:37:18AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Fri, Apr 25, 2003 at 09:37:18AM -0700, Patrick Mansfield wrote:
> So we are guaranteed to be able to have at least one IO in flight for all
> devices. With a per-host spare, some device(s) might have to wait
> (generally polling based on an interval dependent on whatever blk_plug_device
> gives us) for a command to become available, and it is not clear what the
> IO behaviour - especially for swap - will be in such cases.

Ok.

> The sdev->sdev_lock (i.e. queue_lock) protects access to sdev->spare_cmd.

Then you'll sleep with the lock help for !GFP_ATOMIC allocations.  That's
bad.

