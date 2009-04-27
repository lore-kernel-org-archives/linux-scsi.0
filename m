From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC][PATCH] limit state change to SDEV_BLOCK devices in
	scsi_internal_device_unblock
Date: Mon, 27 Apr 2009 20:08:09 +0000
Message-ID: <1240862889.3387.37.camel@mulgrave.int.hansenpartnership.com>
References: <49F5E6E5.20904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36096 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757455AbZD0UIP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Apr 2009 16:08:15 -0400
In-Reply-To: <49F5E6E5.20904@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Takahiro Yasui <tyasui@redhat.com>
Cc: linux-scsi@vger.kernel.org, mchristi@redhat.com, mbarrow@redhat.com

On Mon, 2009-04-27 at 13:09 -0400, Takahiro Yasui wrote:
> Hi,
> 
> This is a patch to fix SCSI timeout error recovery issue which
> I posted about one week ago.
> 
>   [RFC] SCSI timeout error recovery issue
>   http://marc.info/?l=linux-scsi&m=124042136915970&w=2
> 
> scsi timeout on two or more devices may cause extremely long execution
> time for user applications because SDEV_OFFLINE state is changed to
> SDEV_RUNNING state during scsi error recovery procedures triggered by
> a bus reset or a host reset of LLD, and scsi timeout can happens on
> the same devices many times.
> 
> This happens because scsi_internal_device_unblock() changes device's state
> to SDEV_RUNNING even if a device in other states than SDEV_BLOCK, but
> scsi_internal_device_block() is a pair with scsi_internal_device_unblock()
> and only devices in SDEV_BLOCK state are needed to be changed. This patch
> adds a check of the current device state so that state change and queue
> activation is not executed for devices in SDEV_BLOCK state.
> 
> This patch is based on the idea that devices in SDEV_OFFLINE state need to
> stay in SDEV_OFFLINE because SDEV_OFFLINE state is done by:
> 
>  - All recovery procedures, bus reset and host reset, has already failed
>    for devices in SDEV_OFFLINE state.
>    (There is no (or rare?) chance to be recovered.)
> 
>  - A user has changed the device's state to SDEV_OFFLINE intentionally
>    by an interface such as sysfs.
>    (A user needs to enable devices in SDEV_OFFLINE state before using
>     them again.)
> 
> I appreciate any comments and suggestions on this patch.

The analysis seems good, and the idea of putting state guards to make
sure we only transition from a correct state is fine.

The actual state transitions only check that going from in state to out
is permitted by the state model ... rather than actually being correct
for what the function is trying to do.

> Regards,
> ---
> Takahiro Yasui
> Hitachi Computer Products (America), Inc.
> 
> 
> Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
> ---
>  drivers/scsi/scsi_lib.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.29/drivers/scsi/scsi_lib.c
> ===================================================================
> --- linux-2.6.29.orig/drivers/scsi/scsi_lib.c
> +++ linux-2.6.29/drivers/scsi/scsi_lib.c
> @@ -2633,9 +2633,12 @@ scsi_internal_device_unblock(struct scsi
>  	unsigned long flags;
>  	
>  	/* 
> -	 * Try to transition the scsi device to SDEV_RUNNING
> -	 * and goose the device queue if successful.  
> +	 * Try to transition the scsi device to SDEV_RUNNING if it is
> +	 * SDEV_BLOCK and goose the device queue if successful.
>  	 */
> +	if (sdev->sdev_state != SDEV_BLOCK)

This isn't quite correct.  There are two blocked states in the model
currently:  SDEV_BLOCK and SDEV_CREATED_BLOCK ... you'd need to check
for both of them

> +		return 0;

Traditionally the return for an attempted invalid state transition is
-EINVAL.

I suppose for lower down, if you check the state, now we know we go 

SDEV_CREATED_BLOCK -> SDEV_CREATED

or

SDEV_BLOCK -> SDEV_RUNNING

so there's no need for the dual scsi_device_set_state.

James


