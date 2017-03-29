From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2] Fix sysfs recursive removal splats in isci
Date: Wed, 29 Mar 2017 07:37:42 -0400
Message-ID: <1490787462.2657.3.camel@linux.vnet.ibm.com>
References: <cover.1490775958.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1490775958.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, Dan Williams <dan.j.williams@intel.com>, John Garry <john.garry@huawei.com>, Jack Wang <jinpu.wang@profitbricks.com>, Hannes Reinecke <hare@suse.de>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-03-29 at 11:41 +0200, Johannes Thumshirn wrote:
> This series fixes a sysfs warning caused by isci not being able to 
> cope with recursive sysfs path removals which are in place since 
> commit bcdde7e ("sysfs: make __sysfs_remove_dir() recursive").
> 
> The mvsas, aic94xx and pm8001 and hisi_sas patches have been compile 
> tested only hence they have no callstack of the affected path in 
> their changelogs.
> 
> I'm not sure whether to mark this patches as stable or not. I tend to 
> say no here, although we've seen complaints/bug reports on lkml and 
> the scsi list.

What happens to the SYNC CACHE for devices with write back caches?  It
looks like you've already torn down most of the sas objects by the time
they're sent, so do they actually reach the device (or worse, do they
hang the system by not making progress)?

Assuming the above is OK, what about putting the state change inside
sas_remove_ha()?  It's better than making every driver do it.

James
