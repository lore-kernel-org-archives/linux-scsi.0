From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 17/19] scsi_transport_srp: Suppress a W=1 compiler
        warning
Date: Fri, 25 Aug 2017 17:29:32 +0200
Message-ID: <20170825152932.GA18440@lst.de>
References: <20170823214009.15015-1-bart.vanassche@wdc.com> <20170823214009.15015-18-bart.vanassche@wdc.com> <20170824091157.GP19886@lst.de> <1503592026.2702.12.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55684 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933386AbdHYP3d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 11:29:33 -0400
Content-Disposition: inline
In-Reply-To: <1503592026.2702.12.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@lst.de" <hch@lst.de>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Thu, Aug 24, 2017 at 04:27:07PM +0000, Bart Van Assche wrote:
> 
> The purpose of that check is to avoid that dev_loss_tmo * HZ can overflow.
> That check is only needed on 32-bit systems since only on these systems
> sizeof(long) == sizeof(int). How about changing the type of the dev_loss_tmo
> argument from int to long such that no explicit cast is needed?

Yes, switching the timeout to long sounds useful as that's our normal
type for timeouts.  But it will spread through a lot of the SRP code.
