From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] update sd to use kref and fix open/release race
Date: 21 Apr 2004 15:10:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082568881.1728.22.camel@mulgrave>
References: <1081518779.2203.29.camel@mulgrave>
	<20040413171208.GA2550@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:20141 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263646AbUDUTL2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 15:11:28 -0400
In-Reply-To: <20040413171208.GA2550@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, greg@kroah.com

On Tue, 2004-04-13 at 12:12, Mike Anderson wrote:
> Did we decide through the thread on this issue that we will not allow a
> rmmod to happen anymore unless you manually delete the children devices
> off the host? In using scsi_debug I am not able to rmmod until I delete
> all the children (i.e. sd's).

Well, I don't think anything was decided.  However, it's a consequence
of the compound reference strategy because now we hold a scsi_device for
the life of the ULD object.

> The parent child hierarchy should be held in place through kobject_add /
> kobject_get of the parent so I would believe that the extra
> scsi_device_get should not be needed.

In the ULD?  It's just simpler to do it that way.

The slight problem in all this is that the module refcounting model is
different from the device one (in modules, you can't send a deletion
(rmmod) unless your "ref" count is zero).

The best fix would be to move the module model over to the device model.
So you can rmmod at any point, removal triggers the appropriate
scsi_remove_device etc calls and the rmmod command hangs around until
it's safe to remove the module ... for SCSI we could do this before the
device references are dropped because there's a point where we can
guarantee no more commands will be sent to the host adapter.

To conform to the existing model, we can simply move the scsi_device_get
and scsi_device_put under the semaphore in the ULD get and put
routines.  This adds some assymmetry because now the put in sd_remove()
can't be the uld wrappered put, it would have to be a direct kref put
(with the semaphore), but it's doable.

James


