From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] switch scsi upper driver probing to the driver model
Date: Sat, 17 May 2003 09:13:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030517091352.A13403@lst.de>
References: <20030516182039.A7369@lst.de> <3EC5B3B8.9020308@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:59915 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S261262AbTEQHBH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 May 2003 03:01:07 -0400
Content-Disposition: inline
In-Reply-To: <3EC5B3B8.9020308@torque.net>; from dougg@torque.net on Sat, May 17, 2003 at 01:59:52PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James.Bottomley@steeleye.com, greg@kroah.com, linux-scsi@vger.kernel.org

On Sat, May 17, 2003 at 01:59:52PM +1000, Douglas Gilbert wrote:
> Is that "_and_" symmetric? That is, can one have the sg
> device in preference to the sd device? If so, how is
> that selected?

You can. In fact there's nothing in this patch that preferes sd over sg
except the existing link order.  A better way to control the driver
matching would be nice but that nothing that should be done in the
scsi code but rather a generic driver model thing.

> Christoph,
> This patch would have some interesting side effects:
>    - no generic interface (apart from SCSI_IOCTL_SEND_COMMAND)
>      for tape devices (st and osst). While the maintainers of
>      st and osst might like this, not all the user apps would :-)

I have some WIP code to make parts of drivers/block/scsi_ioctl.c
working for scsi char drivers.

>    - the extra ioctls that sg defines are either fudged
>      or missing. This might upset programs other than
>      cdrecord; cdparanoia comes to mind

Hmm, what does cdparanoia complain about?  And yes, I think we
need to kill all those return 0 ioctls from the block layer -
they might have helped to bring up the SG_IO code with cdrecord
but they are a really stupid idea long term.

> It was my understanding that the device model has been
> recently modified by Greg KH to cope with the dual nature
> of the interface that sg causes. Evidently similar situations
> occur elsewhere in the kernel.

Greg, any comments on this?  I haven't found any code like that
in drivers/base/ and I can't understand how this is supposed to work..`

