From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] fc_user_scan correction
Date: Tue, 22 Apr 2008 13:10:04 -0500
Message-ID: <480E29FC.3090502@cs.wisc.edu>
References: <1208885319.12659.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54324 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbYDVSKM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2008 14:10:12 -0400
In-Reply-To: <1208885319.12659.7.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
> Way back when, when the fc_user_scan routine was created, it kept some
> of its original logic that walked the rport list and kicked off a scan.
> Unfortunately, it didn't keep any of the locking around the rport list,
> nor did it consider the synchronous nature of the scan invoked. The result,
> there are some scan requests where the rport list changes, thus a subsequent
> scan is called on a bogus rport structure and the system NMI's.
> 
> The fix is to defer to the midlayer scan routine and not deal with locking
> in the user scan function.
> 
> Patch was cut against scsi-misc-2.6
> 
> -- james s
> 
> 
>  Signed-off-by: James Smart <james.smart@emulex.com>
> 
>  ---
> 
>  scsi_scan.c         |    1 +
>  scsi_transport_fc.c |   21 +--------------------
>  2 files changed, 2 insertions(+), 20 deletions(-)
> 
> 
> diff -upNr a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> --- a/drivers/scsi/scsi_scan.c	2008-04-22 13:09:23.000000000 -0400
> +++ b/drivers/scsi/scsi_scan.c	2008-04-22 13:10:02.000000000 -0400
> @@ -1669,6 +1669,7 @@ int scsi_scan_host_selected(struct Scsi_
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL(scsi_scan_host_selected);
>  
>  static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
>  {
> diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> --- a/drivers/scsi/scsi_transport_fc.c	2008-04-22 12:51:22.000000000 -0400
> +++ b/drivers/scsi/scsi_transport_fc.c	2008-04-22 12:53:30.000000000 -0400
> @@ -1929,29 +1929,10 @@ fc_timed_out(struct scsi_cmnd *scmd)
>  	return EH_NOT_HANDLED;
>  }
>  
> -/*
> - * Must be called with shost->host_lock held
> - */
>  static int fc_user_scan(struct Scsi_Host *shost, uint channel,
>  		uint id, uint lun)
>  {
> -	struct fc_rport *rport;
> -
> -	list_for_each_entry(rport, &fc_host_rports(shost), peers) {
> -		if (rport->scsi_target_id == -1)
> -			continue;
> -
> -		if (rport->port_state != FC_PORTSTATE_ONLINE)
> -			continue;
> -
> -		if ((channel == SCAN_WILD_CARD || channel == rport->channel) &&
> -		    (id == SCAN_WILD_CARD || id == rport->scsi_target_id)) {
> -			scsi_scan_target(&rport->dev, rport->channel,
> -					 rport->scsi_target_id, lun, 1);
> -		}
> -	}
> -
> -	return 0;
> + 	return scsi_scan_host_selected(shost, channel, id, lun, 1);
>  }

Is this is the same as if you did not implement the user_scan callout? 
scsi_sysfs.c will call

scsi_scan_host_selected(shost, channel, id, lun, 1);

I thought we added the user_scan callback because the transport classes 
had to pass in the device struct between the host and target so we got

.../host/rport/target/scsi_device

instead of

.../host/target/scsi_device

qla4xxx has the same problem. Do not look at it for help :( It added a 
mutex and does not deadlock because like the FC class it stats the 
removal of the rport/session then device so the cache sync always fails 
(the check ready function always returns DID_NO_CONNECT so the cache 
sync fails). iscsi tcp/iser/bnx2i works because it has userspace helping 
out with the removal and shutdown and does it in two stages.
