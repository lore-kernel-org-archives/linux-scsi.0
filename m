From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2 0/4] ata port runtime power management support
Date: Thu, 10 Nov 2011 10:30:53 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1111101028250.2338-100000@iolanthe.rowland.org>
References: <1320906166-15459-1-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1320906166-15459-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 10 Nov 2011, Lin Ming wrote:

> Hi, all
> 
> These 4 patches add ata port runtime pm support.
> 
> v1:
> https://lkml.org/lkml/2011/11/2/23
> 
> v2 is totally different than v1.
> 
> v1 performed ata port runtime pm through scsi layer.
> Added hook to scsi host runtime suspend/resume code.
> 
> I realized that this is not the natural way to do ata port runtime pm.
> It does not deal with the races with ata port system suspend/resume.
> 
> With v2, ata port is made to be parent device of scsi host.
> 
> Currently, the device tree of ata port and scsi host looks as below,
> 
>         /sys/devices/pci0000:00/0000:00:1f.2    (ahci controller)
>         |-- ata1                                (ata port)
>         |-- host0                               (scsi host)
>            |-- target0:0:0                      (scsi target)
>                |-- 0:0:0:0                      (disk)
> 
> v2 changes it to:
> 
>         /sys/devices/pci0000:00/0000:00:1f.2    (ahci controller)
>         |-- ata1                                (ata port)
>             |-- host0                           (scsi host)
>                 |-- target0:0:0                 (scsi target)
>                     |-- 0:0:0:0                 (disk)
> 
> So ata port runtime PM will happen as:
> 
> disk suspend --> scsi target suspend --> scsi host suspend --> ata port
> suspend.
> 
> This is much cleaner and natural.

Have you observed any real benefit from this feature?

Currently, disks will not be runtime-suspended unless (1) the user 
requests it by setting the appropriate power/control attribute, and (2) 
the device file is closed (in particular, the disk has no mounted 
filesystems or swap partitions).  I don't imagine this combination of 
events is very common for disks using libata.

Alan Stern
