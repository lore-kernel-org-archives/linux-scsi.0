From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 20/28] libfcoe: add implementation to support fcoe transport
Date: Wed, 02 Feb 2011 00:43:58 -0600
Message-ID: <4D48FD2E.1000307@cs.wisc.edu>
References: <20110129000310.1784.58748.stgit@localhost6.localdomain6> <20110129000455.1784.95503.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55109 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab1BBGoN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Feb 2011 01:44:13 -0500
In-Reply-To: <20110129000455.1784.95503.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>, Yi Zou <yi.zou@intel.com>

On 01/28/2011 06:04 PM, Robert Love wrote:
> +static int fcoe_transport_create(const char *buffer, struct kernel_param *kp)
> +{
> +	int rc = -ENODEV;
> +	struct net_device *netdev = NULL;
> +	struct fcoe_transport *ft = NULL;
> +	enum fip_state fip_mode = (enum fip_state)(long)kp->arg;
> +
> +	if (!mutex_trylock(&ft_mutex))
> +		return restart_syscall();

I was just wondering what is the reason for this. I see it in other 
network related sysfs code but no where else. Is there some networky reason?

> +
> +#ifdef CONFIG_LIBFCOE_MODULE
> +	/*
> +	 * Make sure the module has been initialized, and is not about to be
> +	 * removed.  Module parameter sysfs files are writable before the
> +	 * module_init function is called and after module_exit.
> +	 */
> +	if (THIS_MODULE->state != MODULE_STATE_LIVE)
> +		goto out_nodev;
> +#endif

It seems that this would be a problem for every driver that uses module 
params. Should the module code be getting a module refcount or doing 
this test?
