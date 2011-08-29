From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: Broken pci_block_user_cfg_access interface
Date: Mon, 29 Aug 2011 19:23:05 +0300
Message-ID: <20110829162303.GD7480@redhat.com>
References: <20110829150552.GA6851@redhat.com>
 <4E5BB358.3060705@siemens.com>
 <20110829155835.GB7480@redhat.com>
 <4E5BBAEF.8020808@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658Ab1H2QWb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2011 12:22:31 -0400
Content-Disposition: inline
In-Reply-To: <4E5BBAEF.8020808@siemens.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>

On Mon, Aug 29, 2011 at 06:14:39PM +0200, Jan Kiszka wrote:
> On 2011-08-29 17:58, Michael S. Tsirkin wrote:
> > On Mon, Aug 29, 2011 at 05:42:16PM +0200, Jan Kiszka wrote:
> >> I still don't get what prevents converting ipr to allow plain mutex
> >> synchronization. My vision is:
> >>  - push reset-on-error of ipr into workqueue (or threaded IRQ?)
> >>  - require mutex synchronization for common config space access
> > 
> > Meaning pci_user_ read/write config?
> 
> And pci_dev_reset, yes.
> 
> > 
> >>     and the
> >>    full reset cycle
> >>  - only exception: INTx status/masking access
> >>     => use pci_lock + test for reset_in_progress, skip operation if
> >>        that is the case
> >>
> >> That would allow to drop the whole block_user_cfg infrastructure.
> >>
> >> Jan
> > 
> > We still need to block userspace access while INTx does
> > the status/masking access, right?
> 
> Yes, pci_lock would do that for us.

Well this means block_user_cfg is not going away,
this is what it really is: pci_lock + a bit to lock out userspace.

> We should consider making the related bits for INTx test & mask/unmask
> generic PCI services so that no user (uio_pci_generic, kvm, vfio) needs
> to worry about the locking details.
> 
> Jan
> 
> -- 
> Siemens AG, Corporate Technology, CT T DE IT 1
> Corporate Competence Center Embedded Linux
