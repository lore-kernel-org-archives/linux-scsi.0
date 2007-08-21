From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] FC transport: Disable LUN scanning from low level driver
Date: Mon, 20 Aug 2007 21:07:23 -0400
Message-ID: <46CA3ACB.7070708@emulex.com>
References: <20070820112121.GA1487@schmichrtp.de.ibm.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:40553 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbXHUBH2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Aug 2007 21:07:28 -0400
In-Reply-To: <20070820112121.GA1487@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

I'd prefer a flag/bit in the fc template to indicate no scanning by the
transport. Thus, it's up to the driver to call __scsi_add_device, or
perform the appropriate scans...

Note: this doesn't stop the problem in absolute. as long as there's scan
interfaces via sysfs, any tool/admin could request a scan and hit your
issues. To truly solve it, you need, within the LLDD, to munge what the
midlayer sees for LUN lists.

-- james s


Christof Schmitt wrote:
> The FC transport class calls scsi_scan_target with the SCAN_WILD_CARD
> flag to automatically scan for logical units. zfcp, on the other hand,
> only uses the units that are configured via the zfcp sysfs interface.
> The main reason for this, is that the adapter behind zfcp supports
> adapter sharing without NPIV: The adapter is logged into the SAN once,
> and each unit can be used by one Linux system. If one Linux would grab
> all LUNs, no other one can use them.
> 
> If a unit has the LUN 0, then the SCSI midlayer issue a REPORT LUNS,
> checks the found LUN against the max_lun of the hostadapter. zfcp sets
> this to 1 to only use its own managed units. If there is a LUN 0 that
> is used by zfcp, then the SCSI midlayer produces lots of messages like
> "scsi: host 0 channel 0 id 1 lun2 has a LUN larger than allowed by the
> host adapter" to indicate the mismatch between the actual LUN and the
> max_lun setting. These messages only confuse a user in the case of
> zfcp, since there is no error.
> 
> To fix this problem, the LLD (zfcp) has to be able to prevent the
> automatic scanning from the FC transport class. Attached is a patch
> that adds a parameter to fc_remote_port_add(), another approach would
> be an additional flag in the FC transport template.
> 
> What do others think? If there is an agreement, i will followup with a
> new patch.
> 
> This can go away, as soon as zfcp does not have to support the
> non-NPIV adapter sharing anymore, but this won't happen in the
> foreseeable future.
> 
> Christof Schmitt
> 
> --- linux-2.6.orig/drivers/s390/scsi/zfcp_erp.c	2007-08-14 17:00:07.000000000 +0200
> +++ linux-2.6/drivers/s390/scsi/zfcp_erp.c	2007-08-20 12:54:03.000000000 +0200
> @@ -3175,7 +3175,7 @@ zfcp_erp_action_cleanup(int action, stru
>  			ids.port_id = port->d_id;
>  			ids.roles = FC_RPORT_ROLE_FCP_TARGET;
>  			port->rport =
> -				fc_remote_port_add(adapter->scsi_host, 0, &ids);
> +				fc_remote_port_add(adapter->scsi_host, 0, &ids, 0);
>  			if (!port->rport)
>  				ZFCP_LOG_NORMAL("failed registration of rport"
>  						"(adapter %s, wwpn=0x%016Lx)\n",
> --- linux-2.6.orig/drivers/scsi/scsi_transport_fc.c	2007-08-14 17:00:07.000000000 +0200
> +++ linux-2.6/drivers/scsi/scsi_transport_fc.c	2007-08-20 12:56:15.000000000 +0200
> @@ -2360,7 +2360,7 @@ fc_rport_final_delete(struct work_struct
>   **/
>  static struct fc_rport *
>  fc_rport_create(struct Scsi_Host *shost, int channel,
> -	struct fc_rport_identifiers  *ids)
> +	struct fc_rport_identifiers  *ids, int scan_target)
>  {
>  	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
>  	struct fc_internal *fci = to_fc_internal(shost->transportt);
> @@ -2424,6 +2424,9 @@ fc_rport_create(struct Scsi_Host *shost,
>  	transport_add_device(dev);
>  	transport_configure_device(dev);
>  
> +	if (scan_target)
> +		rport->flags |= FC_RPORT_SCAN_TARGET;
> +
>  	if (rport->roles & FC_PORT_ROLE_FCP_TARGET) {
>  		/* initiate a scan of the target */
>  		rport->flags |= FC_RPORT_SCAN_PENDING;
> @@ -2484,7 +2487,7 @@ delete_rport:
>   **/
>  struct fc_rport *
>  fc_remote_port_add(struct Scsi_Host *shost, int channel,
> -	struct fc_rport_identifiers  *ids)
> +	struct fc_rport_identifiers  *ids, int scan_target)
>  {
>  	struct fc_internal *fci = to_fc_internal(shost->transportt);
>  	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
> @@ -2574,6 +2577,10 @@ fc_remote_port_add(struct Scsi_Host *sho
>  				spin_lock_irqsave(shost->host_lock, flags);
>  
>  				rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
> +				if (scan_target)
> +					rport->flags |= FC_RPORT_SCAN_TARGET;
> +				else
> +					rport->flags &= ~FC_RPORT_SCAN_TARGET;
>  
>  				/* if target, initiate a scan */
>  				if (rport->scsi_target_id != -1) {
> @@ -2657,7 +2664,7 @@ fc_remote_port_add(struct Scsi_Host *sho
>  	spin_unlock_irqrestore(shost->host_lock, flags);
>  
>  	/* No consistent binding found - create new remote port entry */
> -	rport = fc_rport_create(shost, channel, ids);
> +	rport = fc_rport_create(shost, channel, ids, scan_target);
>  
>  	return rport;
>  }
> @@ -2991,7 +2998,8 @@ fc_scsi_scan_rport(struct work_struct *w
>  	unsigned long flags;
>  
>  	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
> -	    (rport->roles & FC_PORT_ROLE_FCP_TARGET)) {
> +	    (rport->roles & FC_PORT_ROLE_FCP_TARGET) &&
> +	    (rport->flags & FC_RPORT_SCAN_TARGET)) {
>  		scsi_scan_target(&rport->dev, rport->channel,
>  			rport->scsi_target_id, SCAN_WILD_CARD, 1);
>  	}
> --- linux-2.6.orig/include/scsi/scsi_transport_fc.h	2007-08-14 17:00:09.000000000 +0200
> +++ linux-2.6/include/scsi/scsi_transport_fc.h	2007-08-20 12:54:03.000000000 +0200
> @@ -338,6 +338,7 @@ struct fc_rport {	/* aka fc_starget_attr
>  /* bit field values for struct fc_rport "flags" field: */
>  #define FC_RPORT_DEVLOSS_PENDING	0x01
>  #define FC_RPORT_SCAN_PENDING		0x02
> +#define FC_RPORT_SCAN_TARGET		0x04
>  
>  #define	dev_to_rport(d)				\
>  	container_of(d, struct fc_rport, dev)
> @@ -713,7 +714,8 @@ struct scsi_transport_template *fc_attac
>  void fc_release_transport(struct scsi_transport_template *);
>  void fc_remove_host(struct Scsi_Host *);
>  struct fc_rport *fc_remote_port_add(struct Scsi_Host *shost,
> -			int channel, struct fc_rport_identifiers  *ids);
> +			int channel, struct fc_rport_identifiers  *ids,
> +			int scan_target);
>  void fc_remote_port_delete(struct fc_rport  *rport);
>  void fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles);
>  int scsi_is_fc_rport(const struct device *);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
