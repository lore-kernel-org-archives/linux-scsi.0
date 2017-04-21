From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 0/5] Re-order scsi_remove_host and sas_remove_host
        in SAS HBA LLDDs
Date: Fri, 21 Apr 2017 13:19:41 +0200
Message-ID: <20170421111941.GA17971@lst.de>
References: <cover.1492760075.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45292 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161101AbdDULTs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Apr 2017 07:19:48 -0400
Content-Disposition: inline
In-Reply-To: <cover.1492760075.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Jinpu Wang <jinpu.wang@profitbricks.com>, John Garry <john.garry@huawei.com>, tj@kernel.org

On Fri, Apr 21, 2017 at 10:04:45AM +0200, Johannes Thumshirn wrote:
> This series re-orders the calls to scsi_remove_host() and sas_remove_host() in
> all SAS HBA drivers (apart from mpt3sas which is doing it correctly). This is
> for two reasons:
> 	1) After the change to recursive removal of sysfs entries, we're
> 	   trying to remove already removed kobjects when doing a
> 	   sas_remove_host() _after_ a scsi_remove_host()
> 	2) the documentation mandates it even (becuase of 1)
> 
> Unfortunately this does not completely solve issues with recursive sysfs
> removals in SAS, as libsas has asynchronous behaviour where strong ordering
> would be needed. But I am working on it and I do know other do as well. So if
> anyone else (James, Christoph, Bart, I'm looking at you) has an idea, I do
> have test setups and I'm willing to take input in form of ideas and patches.
> 
> I also dropped the SDEV_CANCEL state change for now. We re-evaluate it once we
> have an idea how to tackle the ordering issues and place it into
> sas_unregister_ha() as per James' comment.

Any reason to not just make sas_remove_host call scsi_remove_host
to ensure we get the ordering right?
