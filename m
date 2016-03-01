From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] scsi_transport_fc: implement 'disable_target_scan'
	module parameter
Date: Tue, 1 Mar 2016 14:12:52 +0100
Message-ID: <20160301131252.GA7786@lst.de>
References: <1456127462-2817-1-git-send-email-hare@suse.de> <1456127462-2817-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40462 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbcCANMy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2016 08:12:54 -0500
Content-Disposition: inline
In-Reply-To: <1456127462-2817-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jthumshirn@suse.com>, linux-scsi@vger.kernel.org

On Mon, Feb 22, 2016 at 08:51:01AM +0100, Hannes Reinecke wrote:
>  /*
> + * disable_target_scan: Disable target scan per default
> + *   useful on larger installations where only a small
> + *   number of LUNs are required for booting.
> + */
> +static bool fc_disable_target_scan;
> +
> +module_param_named(disable_target_scan, fc_disable_target_scan,
> +		   bool, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(disable_target_scan,
> +		 "Disable target scan on remote ports (default=0)");
> +
> +/*
>   * Redefine so that we can have same named attributes in the
>   * sdev/starget/host objects.
>   */
> @@ -3272,10 +3284,14 @@ fc_scsi_scan_rport(struct work_struct *work)
>  	struct Scsi_Host *shost = rport_to_shost(rport);
>  	struct fc_internal *i = to_fc_internal(shost->transportt);
>  	unsigned long flags;
> +	bool disable_target_scan;
> +
> +	disable_target_scan = fc_disable_target_scan ?
> +		fc_disable_target_scan : i->f->disable_target_scan;
>  
>  	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
>  	    (rport->roles & FC_PORT_ROLE_FCP_TARGET) &&
> -	    !(i->f->disable_target_scan)) {
> +	    !disable_target_scan) {

Wouldn't this be simpler by just writing:

if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
    (rport->roles & FC_PORT_ROLE_FCP_TARGET) &&
    !i->f->disable_target_scan && !disable_target_scan) {

that being said I don't understand why we need this in the FC transport
class.  What is so special about FC that we do it here and not globally?
