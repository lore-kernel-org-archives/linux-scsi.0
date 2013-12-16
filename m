From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 13/32] target: Move spinlock inside core_release_port
Date: Mon, 16 Dec 2013 13:21:36 -0800
Message-ID: <1387228896.20247.227.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-14-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1386979160-6928-14-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:59 -0800, Andy Grover wrote:
> Keep locks closer to things they need to lock.
> 
> sparse annotation no longer needed.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_device.c |   10 +++-------
>  1 files changed, 3 insertions(+), 7 deletions(-)
> 

I'll take this one, but it needs to be re-posted without the other
patches.

--nab

> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index 295b5e4..7b5697a 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -546,16 +546,14 @@ static void core_export_port(
>  	port->sep_index = port->sep_rtpi; /* RELATIVE TARGET PORT IDENTIFIER */
>  }
>  
> -/*
> - *	Called with struct se_device->se_port_lock spinlock held.
> - */
>  static void core_release_port(struct se_device *dev, struct se_port *port)
> -	__releases(&dev->se_port_lock) __acquires(&dev->se_port_lock)
>  {
> +	spin_lock(&dev->se_port_lock);
>  	core_alua_free_tg_pt_gp_mem(port);
> -
>  	list_del(&port->sep_node);
>  	dev->dev_port_count--;
> +	spin_unlock(&dev->se_port_lock);
> +
>  	put_port(port);
>  }
>  
> @@ -596,9 +594,7 @@ void core_dev_unexport(
>  	}
>  	spin_unlock(&lun->lun_sep_lock);
>  
> -	spin_lock(&dev->se_port_lock);
>  	core_release_port(dev, port);
> -	spin_unlock(&dev->se_port_lock);
>  
>  	spin_lock(&hba->device_lock);
>  	dev->export_count--;
