From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI
 controllers.
Date: Fri, 22 Jun 2007 10:15:09 -0700
Message-ID: <20070622101509.16d0e93d.kristen.c.accardi@intel.com>
References: <20070611184146.448266229@intel.com>
	<20070620142342.404856fe.kristen.c.accardi@intel.com>
	<20070621130831.GN18863@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27095 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbXFVRSj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jun 2007 13:18:39 -0400
In-Reply-To: <20070621130831.GN18863@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com, arjan@linux.intel.com

On Thu, 21 Jun 2007 15:08:32 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Jun 20 2007, Kristen Carlson Accardi wrote:
> > Enable Aggressive Link Power management for AHCI controllers.
> > 
> > This patch will set the correct bits to turn on Aggressive
> > Link Power Management (ALPM) for the ahci driver.  This
> > will cause the controller and disk to negotiate a lower
> > power state for the link when there is no activity (see
> > the AHCI 1.x spec for details).  This feature is mutually
> > exclusive with Hot Plug, so when ALPM is enabled, Hot Plug
> > is disabled.  ALPM will be enabled by default, but it is
> > settable via the scsi host syfs interface.  Possible 
> > settings for this feature are:
> > 
> > Setting		Effect
> > ----------------------------------------------------------
> > min_power	ALPM is enabled, and link set to enter 
> > 		lowest power state (SLUMBER) when idle
> > 		Hot plug not allowed.
> > 
> > max_performance	ALPM is disabled, Hot Plug is allowed
> > 
> > medium_power	ALPM is enabled, and link set to enter
> > 		second lowest power state (PARTIAL) when
> > 		idle.  Hot plug not allowed.
> > 
> > Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> 
> A suggestion (it comes with a patch!) - default to max_power/almp off,
> not min_power. For two reasons:
> 
> - There's such a big performance difference between the two, you really
>   want max_power when booting.
> 
> - It's a lot better to default to no change, than default to enabling
>   something new.

Sounds reasonable to me.  Distros/users can decide if they want to have
scripts that enable this after boot to run at min_power. 

Acked-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>


> 
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 841cf0a..e7a2072 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -786,8 +786,7 @@ static int ahci_disable_alpm(struct ata_port *ap)
>  	return 0;
>  }
>  
> -static int ahci_enable_alpm(struct ata_port *ap,
> -	enum scsi_host_link_pm policy)
> +static int ahci_enable_alpm(struct ata_port *ap, enum scsi_host_link_pm policy)
>  {
>  	struct ahci_host_priv *hpriv = ap->host->private_data;
>  	void __iomem *port_mmio = ahci_port_base(ap);
> @@ -808,19 +807,19 @@ static int ahci_enable_alpm(struct ata_port *ap,
>  		return -EINVAL;
>  	}
>  
> -	switch(policy) {
> +	switch (policy) {
>  	case SHOST_MAX_PERFORMANCE:
> -		ahci_disable_alpm(ap);
> -		ap->pm_policy = policy;
> -		return 0;
>  	case SHOST_NOT_AVAILABLE:
> -	case SHOST_MIN_POWER:
>  		/*
>   		 * if we came here with SHOST_NOT_AVAILABLE,
>   		 * it just means this is the first time we
> - 		 * have tried to enable - so try to do
> - 		 * min_power
> + 		 * have tried to enable - default to max performance,
> +		 * and let the user go to lower power modes on request.
>   		 */
> +		ahci_disable_alpm(ap);
> +		ap->pm_policy = SHOST_MAX_PERFORMANCE;
> +		return 0;
> +	case SHOST_MIN_POWER:
>  		ap->pm_policy = SHOST_MIN_POWER;
>  
>  		/* configure HBA to enter SLUMBER */
> 
> -- 
> Jens Axboe
> 
