From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/4] scsi: Allow hosts to be flagged as hotpluggable
Date: Thu, 16 Jul 2009 16:30:13 +0200
Message-ID: <4A5F3975.70503@s5r6.in-berlin.de>
References: <1247701438-18266-1-git-send-email-mjg@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1247701438-18266-1-git-send-email-mjg@redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Matthew Garrett wrote:
> Userspace may wish to make policy decisions based on whether a host
> supports device hotplug or not - for example, AHCI link power management
> disables hotplug, so may only be desirable on hotplug ports. Add
> support for marking hosts as hotpluggable in order to allow userspace to
> treat them appropriately.
[...]
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -421,6 +421,7 @@ struct scsi_host_template {
>  	 */
>  	unsigned unchecked_isa_dma:1;
>  
> +
>  	/*
>  	 * True if this host adapter can make good use of clustering.
>  	 * I originally thought that if the tablesize was large that it
> @@ -447,6 +448,11 @@ struct scsi_host_template {
>  	unsigned ordered_tag:1;
>  
>  	/*
> +	 * True if host supports hotplugging
> +	 */
> +	unsigned hotpluggable:1;
> +

The comment should specify what the actual effects of the flag are.

(Provides the default for Scsi_Host.hotpluggable?)

> +	/*
>  	 * Countdown for host blocking with no commands outstanding.
>  	 */
>  	unsigned int max_host_blocked;
> @@ -622,6 +628,9 @@ struct Scsi_Host {
>  	/* Asynchronous scan in progress */
>  	unsigned async_scan:1;
>  
> +	/* 1 if hotpluggable, 0 if not */
> +	unsigned hotpluggable:1;
> +

Ditto here.

(Is used by power management infrastructure to decide over runtime PM
policy?  I.e. don't enter power states which would prevent the port from
detecting/ reporting hotplug events?)

>  	/*
>  	 * Optional work queue to be utilized by the transport
>  	 */


-- 
Stefan Richter
-=====-==--= -=== =----
http://arcgraph.de/sr/
