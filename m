From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] Don't retry SG_IO (REQ_BLOCK_PC) commands.
Date: Thu, 20 Nov 2003 13:51:23 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031120135123.A2366@beaverton.ibm.com>
References: <20031120085555.A20609@beaverton.ibm.com> <20031120181543.GA3728@beaverton.ibm.com> <20031120191651.GE1106@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:13052 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262758AbTKTVvd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 16:51:33 -0500
Content-Disposition: inline
In-Reply-To: <20031120191651.GE1106@suse.de>; from axboe@suse.de on Thu, Nov 20, 2003 at 08:16:51PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Pat LaVarre <p.lavarre@ieee.org>, dmitrik@users.sourceforge.net, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Thu, Nov 20, 2003 at 08:16:51PM +0100, Jens Axboe wrote:
> On Thu, Nov 20 2003, Mike Anderson wrote:
> > Patrick Mansfield [patmans@us.ibm.com] wrote:
> > > Don't retry SG_IO (REQ_BLOCK_PC) commands.
> > 
> > Should we also have the REQ_BLOCK_PC requests set REQ_FAILFAST? The
> > patch to sd will imply the same behavior.
> 
> Definitely!

Should the setting of REQ_FAILFAST be expanded to prevent requeueing after
a device or host reports queue full?

There are probably many SG_IO users that would want them retried, others
(multimedia?) might not want a retry. Multi-path would *not* want them
retried (well at least the host queue full).

For IO that cannot be sent to the device (if we have !scsi_dev_queue_ready()
or !scsi_host_queue_ready()), it is unclear if REQ_FAILFAST should
complete the IO without ever having sent it to the device.

If we expand the checks for REQ_FAILFAST, the SG_IO user interface should
allow the conditional setting of it.

-- Patrick Mansfield
