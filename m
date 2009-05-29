From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 17/24] mpt fusion: [2.6.30-rc6] Rescan SAS topology	added
Date: Fri, 29 May 2009 18:30:21 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C141A260D80@inbmail01.lsi.com>
References: <20090522110733.GK16331@lsi.com>
 <1243446013.6067.37.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og112.obsmtp.com ([64.18.2.177]:44125 "EHLO
	exprod7og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758392AbZE2NA2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2009 09:00:28 -0400
In-Reply-To: <1243446013.6067.37.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

James,

Yes, both the place mutex required. Why we did not consider mutex in those places just because of FW events will be off while doing rescan. But by design your suggestion makes more sense. 

I have modified patch and resent along with other comments for different patches.

Thanks,
Kashyap

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Wednesday, May 27, 2009 11:10 PM
To: Desai, Kashyap
Cc: linux-scsi@vger.kernel.org; Moore, Eric; Prakash, Sathya
Subject: Re: [PATCH 17/24] mpt fusion: [2.6.30-rc6] Rescan SAS topology added

On Fri, 2009-05-22 at 16:37 +0530, Kashyap, Desai wrote:
> @@ -3176,6 +3220,116 @@ mptsas_send_link_status_event(struct fw_event_work *fw_event)
>  	mptsas_free_fw_event(ioc, fw_event);
>  }
>  
> +static void
> +mptsas_not_responding_devices(MPT_ADAPTER *ioc)
> +{
> +	struct mptsas_portinfo buffer, *port_info;
> +	struct sas_device_info	*sas_info;
> +	struct mptsas_devinfo sas_device;
> +	u32	handle;
> +	VirtTarget *vtarget = NULL;
> +	struct mptsas_phyinfo *phy_info;
> +	u8 found_expander;
> +	int retval, retry_count;
> +	unsigned long flags;
> +
> +	mpt_findImVolumes(ioc);
> +
> +	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
> +	if (ioc->ioc_reset_in_progress) {
> +		dfailprintk(ioc, printk(MYIOC_s_DEBUG_FMT
> +		   "%s: exiting due to a parallel reset \n", ioc->name,
> +		    __func__));
> +		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
> +		return;
> +	}
> +	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
> +
> +	/* devices, logical volumes */
> + redo_device_scan:
> +	list_for_each_entry(sas_info, &ioc->sas_device_info_list, list) {

This list is supposed to be protected by the sas_device_info_mutex,
isn't it ... where is that taken to protect the traversal?

> +		sas_device.handle = 0;
> +		retry_count = 0;
> +retry_page:
> +		retval = mptsas_sas_device_pg0(ioc, &sas_device,
> +				(MPI_SAS_DEVICE_PGAD_FORM_BUS_TARGET_ID
> +				<< MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
> +				(sas_info->fw.channel << 8) +
> +				sas_info->fw.id);
> +
> +		if (sas_device.handle)
> +			continue;
> +		if (retval == -EBUSY) {
> +			spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
> +			if (ioc->ioc_reset_in_progress) {
> +				dfailprintk(ioc,
> +				    printk(MYIOC_s_DEBUG_FMT
> +				    "%s: exiting due to reset\n",
> +				    ioc->name, __func__));
> +				spin_unlock_irqrestore
> +				    (&ioc->taskmgmt_lock, flags);
> +				return;
> +			}
> +			spin_unlock_irqrestore(&ioc->taskmgmt_lock,
> +			flags);
> +		}
> +
> +		if (retval && (retval != -ENODEV)) {
> +			if (retry_count < 10) {
> +				retry_count++;
> +				goto retry_page;
> +			} else {
> +				devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
> +				"%s: Config page retry exceeded retry "
> +				"count deleting device 0x%llx\n",
> +				ioc->name, __func__,
> +				sas_info->sas_address));
> +			}
> +		}
> +
> +		/* delete device */
> +		vtarget = mptsas_find_vtarget(ioc,
> +				sas_info->fw.channel, sas_info->fw.id);
> +		if (vtarget)
> +			vtarget->deleted = 1;
> +		phy_info = mptsas_find_phyinfo_by_sas_address(ioc,
> +		    sas_info->sas_address);
> +		if (phy_info) {
> +			mptsas_del_end_device(ioc, phy_info);
> +			goto redo_device_scan;
> +		}
> +	}
> +
> +	/* expanders */
> + redo_expander_scan:
> +	list_for_each_entry(port_info, &ioc->sas_topology, list) {

And this one is supposed to be protected by the sas_topology_mutex,
where is that taken?

James


