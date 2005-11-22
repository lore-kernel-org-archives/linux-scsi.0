From: Michael Reed <mdr@sgi.com>
Subject: Re: [RFC] fc transport attributes for mpt fusion driver
Date: Tue, 22 Nov 2005 06:35:13 -0600
Message-ID: <43831081.4070909@sgi.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B60@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:4803 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S964906AbVKVMfV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Nov 2005 07:35:21 -0500
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B60@xbl3.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: gwh@hd29.engr.sgi.com, jeremy@hd29.engr.sgi.com, linux-scsi@vger.kernel.org

Thank you for taking the time to comment.  This is exactly
the type of response if was hoping to receive.  I'll act
upon these comments and update the patch.  Thank you for
your time.

Mike



James.Smart@Emulex.Com wrote:
> Mike,
> 
> comments on your RFC....
> 
> -- james s
> 
> 
> 
>> +static int mptfc_dev_loss_tmo = 60;	/* reasonable default */
>> +module_param(mptfc_dev_loss_tmo, int, 0);
>> +MODULE_PARM_DESC(mptfc_dev_loss_tmo, " Time (in seconds) the 
>> FC transport waits for a target"
>> +				     " to return following a 
>> device loss event.  Default=60.");
>> +
> 
> This looks odd. See next statement
> 
>> +	.get_rport_dev_loss_tmo = NULL,
>> +	.set_rport_dev_loss_tmo = NULL,
>> +	.show_rport_dev_loss_tmo = 0,
> 
> So - what this does is kills the support of the rport's dev_loss_tmo
> in lieu of a load-time-settable-only driver module parameter. This is
> not a good thing from an admin perspective. What we are trying to do 
> here is make a well known transport attribute that admins/multipathing
> software know how to look for and how to change relative to their needs.
> As not all devices are equal (only some devices are multipathed), this
> needs to be settable on a per-target (aka rport) basis.
> 
> Recommend:
> - It's ok to have a module parameter - as long as it's recognized as
>   "the default value for a rport at the time it's created".
> 
> - You should (must) export the show_rport_dev_loss_tmo attribute.
> 
> - You should (must) support the set_rport_dev_loss_tmo function.
>   This at least notifies you when the value changes. Please note that
>   it is expected that users will drop this value to as low as 1 second
>   or 10 seconds when multipath functions are operating.
> 
> 
> 
>> +	rid->node_name = ((u64)pg0->WWNN.High) << 32 | 
>> (u64)pg0->WWNN.Low;
>> +	rid->port_name = ((u64)pg0->WWPN.High) << 32 | 
>> (u64)pg0->WWPN.Low;
> 
> You be using Andrew's wwn_to_u64() function that is part of the
> transport. This is true of every case where you are referencing
> WWPN.High/Low   (only if your hardware returns the data in a
> non-line-format(BE per FC spec) layout would you not use it).
> See: http://marc.theaimsgroup.com/?l=linux-scsi&m=112510860102168&w=2
> 
> 
> 
>> +static void
>> +mptfc_register_dev(MPT_ADAPTER *ioc, int channel, 
>> FCDevicePage0_t *pg0)
>> +{
>> +	struct fc_rport_identifiers rport_ids;
>> +	struct fc_rport		*rport;
>> +	struct mptfc_rport_info	*ri;
>> +	int			match=0;
>> +	u64			port_name;
>> +	unsigned long		flags;
>> +
>> +	if (mptfc_generate_rport_identifiers(pg0,&rport_ids) < 0)
>> +		return;
>> +
>> +	/* scan list looking for a match */
>> +	spin_lock_irqsave(&ioc->fc_rport_lock,flags);
>> +	list_for_each_entry(ri, &ioc->l.fc_rports, list) {
>> +		port_name = (u64)ri->pg0.WWPN.High << 32 | 
>> (u64)ri->pg0.WWPN.Low;
>> +		if (port_name == rport_ids.port_name) {	/* match */
>> +			list_move_tail(&ri->list,&ioc->l.fc_rports);
>> +			match = 1;
>> +			break;
>> +		}
>> +	}
>> +	if (!match) {	/* allocate one */
>> +		spin_unlock_irqrestore(&ioc->fc_rport_lock,flags);
>> +		ri = kmalloc(sizeof(struct mptfc_rport_info), 
>> GFP_KERNEL);
>> +		if (!ri)
>> +			return;
>> +		memset(ri, 0, sizeof(struct mptfc_rport_info));
>> +		spin_lock_irqsave(&ioc->fc_rport_lock,flags);
>> +		list_add_tail(&ri->list,&ioc->l.fc_rports);
>> +	}
>> +
> 
> If your mptfc_rport_info struct has the same lifetime as the
> registration of the port with the transport, you may want to
> consider using the dd_data (and dd_fcrport_size) fields so that
> you can piggy back on the rport data structure allocation.
> 
>> +	ri->pg0 = *pg0;	/* add/update pg0 data */
>> +	ri->flags &= ~MPT_RPORT_INFO_FLAGS_MISSING;
>> +
>> +	if (!(ri->flags & MPT_RPORT_INFO_FLAGS_REGISTERED)) {
>> +		spin_unlock_irqrestore(&ioc->fc_rport_lock,flags);
>> +		rport = fc_remote_port_add(ioc->sh,channel,&rport_ids);
>> +		spin_lock_irqsave(&ioc->fc_rport_lock,flags);
>> +		if (rport) {
>> +			if (ri->rport != rport) {
>> +				ri->flags &= 
>> ~MPT_RPORT_INFO_FLAGS_MAPPED_VDEV;
>> +				ri->vdev = NULL;
>> +				ri->rport = rport;
>> +			}
>> +			rport->dd_data = (void *)ri;
> 
> I really dislike this convention, but realize it's a religion issue.
> It has the driver changing a pointer that is actually owned by the
> transport. Folks are setting the dd_fcrport_size field to 0 (meaning,
> I need no transport data on the rport), but then using the field to
> store a pointer to internal data.  However, the transport, which
> officially owns this field, may have code that simply checks for a
> non-null value before freeing it (vs qualifying it as well with the
> dd_fcrport_size field).  So, it's an argument of - if I only need a
> pointer for driver data, do I get to reuse this field, or do I make
> the transport allocate another pointer's worth of data and use the
> more generic form of dd_data being set only by the transport ?
> 
> As I've leaned toward avoiding mistakes while coding in the transport,
> by the transport explicitly owning the field, I've pinged Q to use
> the more verbose method of asking for anohter pointer's worth.
> Lpfc originally needed more than a pointer's worth, but has since
> scaled down so even it uses only a pointer's worth.  I recommend you
> stay consistent with these (or let Christoph voice the rebuttle to
> this section and we'll get an official behavior ruling).
> 
> 
>> +int
>> +mptfc_slave_alloc(struct scsi_device *sdev)
>> +{
>> +	struct Scsi_Host	*host;
>> +	MPT_SCSI_HOST		*hd;
>> +	VirtTarget		*vtarget;
>> +	VirtDevice		*vdev;
>> +	struct scsi_target	*starget;
>> +	uint			target;
>> +	struct fc_rport		*rport;
>> +	struct mptfc_rport_info *ri;
>> +	unsigned long		flags;
>> +
> 
> At this point - to be consistent with the rport block behavior,
> please call out to fc_remote_port_chkready().  See:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=112965152011520&w=2
> 
> This check also needs to be added to the driver's queuecommand.
> 
>> +	if (!sdev
>> +	 || !(host=sdev->host)
>> +	 || !(hd=(MPT_SCSI_HOST *)host->hostdata)
>> +	 || !(hd->ioc)
>> +	) {
>> +
>> +		return -ENODEV;
>> +	}
> 
> The odds of any of these failing is near-nill, as the kernel
> leaves things built up. hd->ioc is maybe the only exception.
> 
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
