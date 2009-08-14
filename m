From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 4/7] mpt2sas: setting SDEV into RUNNING state from
 Interrupt context
Date: Fri, 14 Aug 2009 15:11:09 +0000
Message-ID: <1250262669.4021.11.camel@mulgrave.site>
References: <20090814094458.GF29415@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58384 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932444AbZHNPLL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Aug 2009 11:11:11 -0400
In-Reply-To: <20090814094458.GF29415@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Fri, 2009-08-14 at 15:15 +0530, Kashyap, Desai wrote:
> Changing SDEV Running state from interrupt context. Previously It was 
> handle in work queue thread. With this change It will not wait for work 
> queue thread to execute scsih_ublock_io_device to put SDEV into Running 
> state. This will reduce delay for Device becoming RUNNING. 
> 
> 
> ---
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> Signed-off-by: Eric Moore <Eric.moore@lsi.com>
> ---
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index c0d5d5e..33ba2a4 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -2327,6 +2327,7 @@ _scsih_block_io_to_children_attached_directly(struct MPT2SAS_ADAPTER *ioc,
>  	u16 handle;
>  	u16 reason_code;
>  	u8 phy_number;
> +	u8 link_rate;
>  
>  	for (i = 0; i < event_data->NumEntries; i++) {
>  		handle = le16_to_cpu(event_data->PHY[i].AttachedDevHandle);
> @@ -2337,6 +2338,11 @@ _scsih_block_io_to_children_attached_directly(struct MPT2SAS_ADAPTER *ioc,
>  		    MPI2_EVENT_SAS_TOPO_RC_MASK;
>  		if (reason_code == MPI2_EVENT_SAS_TOPO_RC_DELAY_NOT_RESPONDING)
>  			_scsih_block_io_device(ioc, handle);
> +		if (reason_code == MPI2_EVENT_SAS_TOPO_RC_PHY_CHANGED) {
> +			link_rate = event_data->PHY[i].LinkRate >> 4;
> +			if (link_rate >= MPI2_SAS_NEG_LINK_RATE_1_5)
> +				_scsih_ublock_io_device(ioc, handle);
> +		}
>  	}
>  }
>  
> @@ -3871,10 +3877,6 @@ _scsih_sas_topology_change_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
>  						link_rate_);
>  				}
>  			}
> -			if (reason_code == MPI2_EVENT_SAS_TOPO_RC_PHY_CHANGED) {
> -				if (link_rate_ >= MPI2_SAS_NEG_LINK_RATE_1_5)
> -					_scsih_ublock_io_device(ioc, handle);
> -			}

OK, so explain these functions _scsih_ublock_io_device and
_scsih_block_io_device to me.  You're wrongly tampering with device
state in them ... it should be using the block/unblock functions in
scsi_lib.c if it's a standard usage.  If not, it shouldn't be touching
the device state, especially SDEV_BLOCK, because that has queue running
and plugging implications.

James


