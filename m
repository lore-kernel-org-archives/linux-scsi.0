From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 0/4] ata port runtime power management support
Date: Thu, 10 Nov 2011 07:30:36 -0800
Message-ID: <20111110153036.GC27258@google.com>
References: <1320906166-15459-1-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1320906166-15459-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

(cc'ing Kay for the sysfs tree hierarchy change)

On Thu, Nov 10, 2011 at 02:22:42PM +0800, Lin Ming wrote:
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

Yeah, I really like this approach.  Nicely done.  I *think* the
hierarchy change should be okay but cc'ing Kay just in case.

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
