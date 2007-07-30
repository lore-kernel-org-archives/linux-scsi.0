From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
Date: Mon, 30 Jul 2007 12:32:54 -0400
Message-ID: <46AE12B6.6090408@garzik.org>
References: <20070705194909.337398431@intel.com> <20070705130518.135e4e3c.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070705130518.135e4e3c.kristen.c.accardi@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, edwintorok@gmail.com, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

Kristen Carlson Accardi wrote:
> @@ -42,6 +42,16 @@ enum scsi_eh_timer_return {
>  	EH_RESET_TIMER,
>  };
>  
> +/*
> + * shost pm policy: If you alter this, you also need to alter scsi_sysfs.c
> + * (for the ascii descriptions)
> + */
> +enum scsi_host_link_pm {
> +	SHOST_NOT_AVAILABLE,
> +	SHOST_MIN_POWER,
> +	SHOST_MAX_PERFORMANCE,
> +	SHOST_MEDIUM_POWER,
> +};
>  
>  struct scsi_host_template {
>  	struct module *module;
> @@ -345,6 +355,12 @@ struct scsi_host_template {
>  	int (*suspend)(struct scsi_device *, pm_message_t state);
>  
>  	/*
> + 	 * link power management support
> + 	 */
> +	int (*set_link_pm_policy)(struct Scsi_Host *, enum scsi_host_link_pm);
> +	enum scsi_host_link_pm default_link_pm_policy;
> +
> +	/*
>  	 * Name of proc directory
>  	 */
>  	char *proc_name;
> @@ -642,6 +658,7 @@ struct Scsi_Host {
>  	
>  
>  	enum scsi_host_state shost_state;
> +	enum scsi_host_link_pm shost_link_pm_policy;
>  
>  	/* ldm bits */
>  	struct device		shost_gendev;


Any chance the SCSI peeps could ACK this, and then let me include it in 
the ALPM patchset in the libata tree?

	Jeff


