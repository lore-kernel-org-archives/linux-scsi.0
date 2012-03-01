From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH v2 8/8] [SCSI] sr: check and enable Zero-power ODD
 support
Date: Thu, 1 Mar 2012 11:02:20 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1203011059230.9392-100000@netrider.rowland.org>
References: <1330592577-16546-9-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1330592577-16546-9-git-send-email-ming.m.lin@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lu@amd.com>, Kernel development list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@vger.kernel.org>, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 1 Mar 2012, Lin Ming wrote:

> ZPODD(Zero Power Optical Disk Drive) is a new feature in
> SATA 3.1 specification. It provides a way to power off unused ODD.
> 
> ZPODD support is checked in in sr_probe().
> can_power_off flag is set during suspend if ZPODD is supported.
> 
> ATA port's runtime suspend callback will actually power off the ODD
> and its runtime resume callback will actually power on the ODD.
> 
> When ODD is powered off(D3Cold state), inserting disk will trigger a
> wakeup event(GPE). GPE AML handler notifies the associated device. Then
> ODD is resumed in the notify handler.

I have one stylistic comment on this patch...

> diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
> index 37c8f6b..39b3d8c 100644
> --- a/drivers/scsi/sr.h
> +++ b/drivers/scsi/sr.h
> @@ -42,6 +42,9 @@ typedef struct scsi_cd {
>  	unsigned readcd_cdda:1;	/* reading audio data using READ_CD */
>  	unsigned media_present:1;	/* media is present */
>  
> +	unsigned zpodd:1;	/* is ZPODD supported */
> +	unsigned zpodd_event:1;
> +

You should not expect your readers to understand what "ZPODD" means.  
drivers/scsi/sr.h is used by lots of different people, many of whom 
will have no idea what it refers to, especially since it is part of 
the SATA spec and not the SCSI spec.  You should provide a brief 
explanation.

Alan Stern

