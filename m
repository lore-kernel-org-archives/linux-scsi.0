From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: dpt_i2o driver
Date: Tue, 2 Sep 2003 18:14:57 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030902181457.A13499@infradead.org>
References: <0998F43EAD645A47B3F6507196DD70EA256915@OTCEXC01>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:33549 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261284AbTIBRPG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2003 13:15:06 -0400
Content-Disposition: inline
In-Reply-To: <0998F43EAD645A47B3F6507196DD70EA256915@OTCEXC01>; from mark_salyzyn@adaptec.com on Tue, Sep 02, 2003 at 01:10:04PM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Mark Haverkamp <markh@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Sep 02, 2003 at 01:10:04PM -0400, Salyzyn, Mark wrote:
> When the device is mounted, should we not have a usage count in the kernel,
> or are the hotplug events clearing this? Sorry for showing my ignorance of
> the hotplug needs ...

Wach scsi_device has a reference count (actually two currently, but one
will go away).  this is not a traditional usage count because everytime
we do something with the device without holding the protecting lock
we should have one of this references, often temporary.  (We don't do
yet but we will before 2.6.0 is finished).  If the device is marked for
unregistration and the last reference vanishes the device is freed.
So you only have a chance to see a zero refcount if the device isn't
unregistered yet - which is completly useless for monitoring when
it's deleted.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
On Tue, Sep 02, 2003 at 01:10:04PM -0400, Salyzyn, Mark wrote:
> When the device is mounted, should we not have a usage count in the kernel,
> or are the hotplug events clearing this? Sorry for showing my ignorance of
> the hotplug needs ...

Wach scsi_device has a reference count (actually two currently, but one
will go away).  this is not a traditional usage count because everytime
we do something with the device without holding the protecting lock
we should have one of this references, often temporary.  (We don't do
yet but we will before 2.6.0 is finished).  If the device is marked for
unregistration and the last reference vanishes the device is freed.
So you only have a chance to see a zero refcount if the device isn't
unregistered yet - which is completly useless for monitoring when
it's deleted.

