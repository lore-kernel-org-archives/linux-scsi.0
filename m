From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [Patch] dont block device on QUEUE_FULL for last command
Date: Mon, 4 Aug 2003 11:48:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030804154844.GB26775@gtf.org>
References: <OF122C5E1B.D9D616EB-ONC1256D78.0050C1BC@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host-64-213-145-173.atlantasolutions.com ([64.213.145.173]:45763
	"EHLO havoc.gtf.org") by vger.kernel.org with ESMTP id S271828AbTHDPsp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Aug 2003 11:48:45 -0400
Content-Disposition: inline
In-Reply-To: <OF122C5E1B.D9D616EB-ONC1256D78.0050C1BC@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <AHERRMAN@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Aug 04, 2003 at 05:42:51PM +0200, Andreas Herrmann wrote:
> Hi,
> 
> I observed the following problem:
> A device was marked as blocked after a QUEUE_FULL status code
> was returned for the last scsi command for a device.
> And there's a snag to it -- because no further commands are pending
> for that device, the device is not set unblocked anymore.
> 
> Solution is:
> Do not block the device/adapter if getting QUEUE_FULL status code
> for the last pending command of that device/adapter, but retry
> the command.

For most cases you _should_ block until another command is completed, at
the very least.  Retrying the command immediately is _exactly_ the
situation one wishes to avoid, when returning a QUEUE_FULL result!

	Jeff



