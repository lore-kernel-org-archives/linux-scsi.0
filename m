From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH v3 04/12] Protect SCSI device state changes with a mutex
Date: Thu, 8 Jun 2017 17:53:07 +0200
Message-ID: <20170608155307.GB14771@lst.de>
References: <20170602212203.30401-1-bart.vanassche@sandisk.com> <20170602212203.30401-5-bart.vanassche@sandisk.com> <20170605080937.GB22028@lst.de> <1496675927.2623.1.camel@sandisk.com> <1496687778.2623.17.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60165 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751798AbdFHPxJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Jun 2017 11:53:09 -0400
Content-Disposition: inline
In-Reply-To: <1496687778.2623.17.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "hare@suse.com" <hare@suse.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Mon, Jun 05, 2017 at 06:36:19PM +0000, Bart Van Assche wrote:
> > The mpt3sas driver is the only driver that calls scsi_internal_device_block()
> > and scsi_internal_device_unblock() from atomic context. Since it's not an option
> > to protect the SCSI device state changes with a spinlock I prefer that the
> > mpt3sas authors convert the scsi_internal_device_block() calls into
> > scsi_target_block() calls.
> 
> Please also note that although this patch series doesn't improve the mpt3sas
> driver, it doesn't change its behavior.

Yes.  And normally we try to get things right.  I guess this series is
useful enough without fixing everyone up, but adding a FIXME or getting
the broadcom folks involved would be even better.
