From: Adrian Bunk <bunk@fs.tum.de>
Subject: Re: [patch] 2.4.23-pre8: link error with both megaraid drivers
Date: Thu, 23 Oct 2003 21:52:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031023195223.GI11807@fs.tum.de>
References: <3F97F35D.30101@wanadoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:14045 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S261746AbTJWTwb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Oct 2003 15:52:31 -0400
Content-Disposition: inline
In-Reply-To: <3F97F35D.30101@wanadoo.es>
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose@wanadoo.es>
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Oct 23, 2003 at 05:27:25PM +0200, Xose Vazquez Perez wrote:
> Adrian Bunk wrote:
> 
> > The patch below fixes this issue by disalllowing the static inclusion of
> > both drivers at the same time.
> 
> IMO this patch makes a better job. It only allows one in kernel,
> and it allows two modules at same time.
>...

My patch allows this, too, or what did I miss?

> -thanks-
> 
> --- linux/drivers/scsi/Config.in	2003-10-23 16:56:13.000000000 +0200
> +++ new/drivers/scsi/Config.in	2003-10-23 17:00:51.000000000 +0200
> @@ -66,8 +66,14 @@
>  dep_tristate 'AdvanSys SCSI support' CONFIG_SCSI_ADVANSYS $CONFIG_SCSI
>  dep_tristate 'Always IN2000 SCSI support' CONFIG_SCSI_IN2000 $CONFIG_SCSI
>  dep_tristate 'AM53/79C974 PCI SCSI support' CONFIG_SCSI_AM53C974 $CONFIG_SCSI $CONFIG_PCI
> -dep_tristate 'AMI MegaRAID support' CONFIG_SCSI_MEGARAID $CONFIG_SCSI
> -dep_tristate 'AMI MegaRAID2 support' CONFIG_SCSI_MEGARAID2 $CONFIG_SCSI
> +
> +if [ "$CONFIG_SCSI_MEGARAID2" != "y" ]; then
> +	dep_tristate 'AMI MegaRAID support' CONFIG_SCSI_MEGARAID $CONFIG_SCSI
> +fi
> +
> +if [ "$CONFIG_SCSI_MEGARAID" != "y" ]; then
> +	dep_tristate 'AMI MegaRAID2 support' CONFIG_SCSI_MEGARAID2 $CONFIG_SCSI
> +fi
>  
>  dep_tristate 'BusLogic SCSI support' CONFIG_SCSI_BUSLOGIC $CONFIG_SCSI
>  if [ "$CONFIG_SCSI_BUSLOGIC" != "n" ]; then

The difference between your and my patch is that your patch doesn't 
allow one in kernel plus the other one modular.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

