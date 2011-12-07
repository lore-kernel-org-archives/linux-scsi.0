From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH v5 1/6] ata: make ata port as parent device of scsi host
Date: Wed, 07 Dec 2011 15:04:38 -0500
Message-ID: <4EDFC6D6.3050601@pobox.com>
References: <1323048028-10421-1-git-send-email-ming.m.lin@intel.com> <1323048028-10421-2-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1323048028-10421-2-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: James Bottomley <JBottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On 12/04/2011 08:20 PM, Lin Ming wrote:
> Currently, the device tree of ata port and scsi host looks as below,
>
>          /sys/devices/pci0000:00/0000:00:1f.2    (ahci controller)
>          |-- ata1                                (ata port)
>          |-- host0                               (scsi host)
>             |-- target0:0:0                      (scsi target)
>                 |-- 0:0:0:0                      (disk)
>
> This patch makes ata port as parent device of scsi host, then it becomes
>
>          /sys/devices/pci0000:00/0000:00:1f.2    (ahci controller)
>          |-- ata1                                (ata port)
>              |-- host0                           (scsi host)
>                  |-- target0:0:0                 (scsi target)
>                      |-- 0:0:0:0                 (disk)
>
> With this change, the ata port runtime PM is easier.
> For example, the ata port runtime suspend will happen as,
>
> disk suspend -->  scsi target suspend -->  scsi host suspend -->  ata port
> suspend.
>
> Acked-by: Tejun Heo<tj@kernel.org>
> Signed-off-by: Lin Ming<ming.m.lin@intel.com>
> ---
>   drivers/ata/libata-scsi.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)

applied 1-6, thanks
