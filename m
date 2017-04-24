From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: sas: move scsi_remove_host call into
 sas_remove_host
Date: Mon, 24 Apr 2017 15:52:45 +0200
Message-ID: <20170424134642.GD29543@linux-x5ow.site>
References: <20170421121141.20701-1-jthumshirn@suse.de>
 <c3ddfbfd-1b4f-d53b-d9b3-9d475985ce9e@huawei.com>
 <e90738ea-185a-2c29-3542-c40057d46b6f@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53995 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1763690AbdDXNwt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Apr 2017 09:52:49 -0400
Content-Disposition: inline
In-Reply-To: <e90738ea-185a-2c29-3542-c40057d46b6f@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>, Hannes Reinecke <hare@suse.de>, Jinpu Wang <jinpu.wang@profitbricks.com>, Christoph Hellwig <hch@lst.de>

On Mon, Apr 24, 2017 at 02:38:40PM +0100, John Garry wrote:
> On 24/04/2017 11:09, John Garry wrote:
> >On 21/04/2017 13:11, Johannes Thumshirn wrote:
> >>Move scsi_remove_host call into sas_remove_host and remove it from SAS
> >>HBA
> >>drivers, so we don't mess up the ordering. This solves an issue with
> >>double
> >>deleting sysfs entries that was introduced by the change of sysfs
> >>behaviour
> >>from commit bcdde7e ("sysfs: make __sysfs_remove_dir() recursive").
> >>
> >>Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> >>Suggested-by: Christoph Hellwig <hch@lst.de>
> >>Cc: Hannes Reinecke <hare@suse.de>
> >>Cc: James Bottomley <jejb@linux.vnet.ibm.com>
> >>Cc: Jinpu Wang <jinpu.wang@profitbricks.com>
> >>Cc: John Garry <john.garry@huawei.com>
> >
> >For what it's worth:
> >
> >Tested-by: John Garry <john.garry@huawei.com> # On hisi_sas
> >
> 
> I have actually tested this a little further and now I see an issue. Maybe
> it is related to the internal development kernel I am using or a
> pre-existing issue with our driver, but I doubt it.
> This time I removed the WARN in sysfs_remove_group() [so the console is not
> bombarded] and ran repeated insmod/rmmod, and I see this sometimes:

[...]


> Ring any bells? I don't see this new WARN without the change.

No haven't seen the WARN in my tests but I didn't do a insmod/rmmod stress
test anyways.

I'll have a look.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
