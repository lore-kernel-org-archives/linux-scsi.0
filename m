From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [patch 0/5] scsi/bnx2*: Plug hotplug race, correct locking and
 simplify hotplug code
Date: Tue, 25 Jul 2017 09:27:55 -0400 (EDT)
Message-ID: <alpine.OSX.2.00.1707250927040.880@administrators-MacBook-Pro.local>
References: <20170724105255.715647116@linutronix.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170724105255.715647116@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, QLogic-Storage-Upstream@qlogic.com, martin.petersen@oracle.com, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
List-Id: linux-scsi@vger.kernel.org


On Mon, 24 Jul 2017, 6:52am, Thomas Gleixner wrote:

> The conversion of the cpu hotplug locking to a percpu rwsem does not longer
> allow recursive locking of the hotplug lock.
> 
> The BNX2I and BNX2FC drivers install/remove hotplug states with the hotplug
> lock held. The install/removal code acquired the hotplug lock as well.
> 
> While looking into this, I noticed an interesting hotplug race in the
> BNX2FC driver, which could result in dereferencing a NULL pointer or freed
> and potentially reused memory.
> 
> The following series addresses these problems and as a final step on top it
> simplifies the hotplug code in both drivers.
> 
> Thanks,
> 
> 	tglx
> 
> ----
>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   68 ++++++++------------------------------
>  drivers/scsi/bnx2fc/bnx2fc_hwi.c  |   45 ++++++++++++-------------
>  drivers/scsi/bnx2i/bnx2i_init.c   |   64 ++++++++---------------------------
>  include/linux/cpuhotplug.h        |    2 -
>  4 files changed, 53 insertions(+), 126 deletions(-)
> 

We tested the series and everything was fine.  Ack to the series.

Acked-by: Chad Dupuis <chad.dupuis@cavium.com>
