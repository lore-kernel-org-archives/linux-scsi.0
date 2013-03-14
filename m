From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi_transport_fc: Make 'port_state' writeable
Date: Thu, 14 Mar 2013 19:09:54 +0100
Message-ID: <51421272.2000706@linux.vnet.ibm.com>
References: <1358262138-13378-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:41380 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab3CNSKB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Mar 2013 14:10:01 -0400
Received: from /spool/local
	by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Thu, 14 Mar 2013 18:07:55 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 85BA02190056
	for <linux-scsi@vger.kernel.org>; Thu, 14 Mar 2013 18:11:33 +0000 (GMT)
Received: from d06av07.portsmouth.uk.ibm.com (d06av07.portsmouth.uk.ibm.com [9.149.37.248])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r2EI9l3b54657082
	for <linux-scsi@vger.kernel.org>; Thu, 14 Mar 2013 18:09:47 GMT
Received: from d06av07.portsmouth.uk.ibm.com (d06av07.portsmouth.uk.ibm.com [127.0.0.1])
	by d06av07.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r2EH21nE007326
	for <linux-scsi@vger.kernel.org>; Thu, 14 Mar 2013 13:02:02 -0400
In-Reply-To: <1358262138-13378-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>

Just for my understanding:
So this is a bit like writing 0 into the failed attribute of a zfcp_por=
t=20
in sysfs (zfcp_sysfs_port_failed_store()) which forces a port reopen=20
recovery including a sequence of fc_remote_port_delete and=20
fc_remote_port_add?
If so, it sounds good to have this functionality for any FC LLD in=20
common code.
(And I can think about deprecating parts of zfcp code, next we could=20
consider the same for zfcp's forced LUN and adapter recovery or maybe=20
this already exists as sdev's writable state attribute and the adapter=20
recovery can be performed manually by walking all fc_rports writing=20
their port_state.)

On 01/15/2013 04:02 PM, Hannes Reinecke wrote:
> Multipath might detect a path down even though the LLDD
> hasn't registered a link down event.
> This patch makes the 'port_state' FC attribute writeable
> to enforce a link down scenario in these cases, allowing
> for a fast failover to the remaining ports.
>
> Cc: Chad Dupuis <chad.dupuis@qlogic.com>
> Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Cc: James Smart <james.smart@emulex.com>
> Cc: James Bottomley <jbottomley@parallels.com>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
>
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_tra=
nsport_fc.c
> index 5e1c6dd..4d28ee5 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -42,6 +42,8 @@
>   #include "scsi_priv.h"
>   #include "scsi_transport_fc_internal.h"
>
> +static void fc_flush_devloss(struct Scsi_Host *shost);
> +static void fc_flush_work(struct Scsi_Host *shost);
>   static int fc_queue_work(struct Scsi_Host *, struct work_struct *);
>   static void fc_vport_sched_delete(struct work_struct *work);
>   static int fc_vport_setup(struct Scsi_Host *shost, int channel,
> @@ -949,7 +951,76 @@ show_fc_rport_roles (struct device *dev, struct =
device_attribute *attr,
>   static FC_DEVICE_ATTR(rport, roles, S_IRUGO,
>   		show_fc_rport_roles, NULL);
>
> -fc_private_rport_rd_enum_attr(port_state, FC_PORTSTATE_MAX_NAMELEN);
> +static ssize_t
> +store_fc_rport_port_state(struct device *dev,
> +			  struct device_attribute *attr,
> +			  const char *buf, size_t count)
> +{
> +	unsigned long flags;
> +	struct fc_rport *rport =3D transport_class_to_rport(dev);
> +	struct Scsi_Host *shost =3D rport_to_shost(rport);
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	if (!strncmp(buf, "Blocked", 7)) {
> +		if (rport->port_state !=3D FC_PORTSTATE_ONLINE) {
> +			spin_unlock_irqrestore(shost->host_lock, flags);
> +			return -EBUSY;
> +		}
> +		spin_unlock_irqrestore(shost->host_lock, flags);
> +		fc_remote_port_delete(rport);
> +	} else if (!strncmp(buf, "Online", 6)) {
> +		if (rport->port_state !=3D FC_PORTSTATE_BLOCKED) {
> +			spin_unlock_irqrestore(shost->host_lock, flags);
> +			return -EBUSY;
> +		}
> +		/* Reset back to online for rescan */
> +		rport->port_state =3D FC_PORTSTATE_ONLINE;
> +		spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +		if (!cancel_delayed_work(&rport->fail_io_work))
> +			fc_flush_devloss(shost);
> +		if (!cancel_delayed_work(&rport->dev_loss_work))
> +			fc_flush_devloss(shost);
> +
> +		spin_lock_irqsave(shost->host_lock, flags);
> +		rport->flags &=3D ~(FC_RPORT_FAST_FAIL_TIMEDOUT |
> +				  FC_RPORT_DEVLOSS_PENDING |
> +				  FC_RPORT_DEVLOSS_CALLBK_DONE);
> +		spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +		/* ensure any stgt delete functions are done */
> +		fc_flush_work(shost);
> +
> +		if (rport->roles & FC_PORT_ROLE_FCP_TARGET) {
> +			scsi_target_unblock(&rport->dev, SDEV_RUNNING);
> +			/* initiate a scan of the target */
> +			spin_lock_irqsave(shost->host_lock, flags);
> +			rport->flags |=3D FC_RPORT_SCAN_PENDING;
> +			scsi_queue_work(shost, &rport->scan_work);
> +			spin_unlock_irqrestore(shost->host_lock, flags);
> +		}
> +	} else
> +		return -EINVAL;
> +
> +	return count;
> +}
> +
> +static ssize_t
> +show_fc_rport_port_state (struct device *dev,
> +			  struct device_attribute *attr, char *buf)
> +{
> +	struct fc_rport *rport =3D transport_class_to_rport(dev);
> +	const char *name;
> +
> +	name =3D get_fc_port_state_name(rport->port_state);
> +	if (!name)
> +		return -EINVAL;
> +	return snprintf(buf, FC_PORTSTATE_MAX_NAMELEN, "%s\n", name);
> +}
> +
> +static FC_DEVICE_ATTR(rport, port_state, S_IRUGO | S_IWUSR,
> +		show_fc_rport_port_state, store_fc_rport_port_state);
> +
>   fc_private_rport_rd_attr(scsi_target_id, "%d\n", 20);
>
>   /*
> @@ -2289,7 +2360,7 @@ fc_attach_transport(struct fc_function_template=
 *ft)
>   	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_name);
>   	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_id);
>   	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(roles);
> -	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_state);
> +	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(port_state);
>   	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(scsi_target_id);
>   	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(fast_io_fail_tmo);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--=20
Mit freundlichen Gr=FC=DFen / Kind regards
Steffen Maier

Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Gesch=E4ftsf=FChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=F6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
