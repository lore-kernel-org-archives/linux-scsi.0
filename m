From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/5] BNX2I: Added support for other TMFs besides ABORT_TASK
Date: Wed, 11 Aug 2010 14:38:54 -0500
Message-ID: <4C62FC4E.5030605@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1281467374-6182-3-git-send-email-eddie.wai@broadcom.com> <4C62F4DB.8070006@cs.wisc.edu> <F856AC0DBD5E8A48948C6FDDFF2ECA9F94F7F3FAFF@IRVEXCHCCR02.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34880 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070Ab0HKTei (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Aug 2010 15:34:38 -0400
In-Reply-To: <F856AC0DBD5E8A48948C6FDDFF2ECA9F94F7F3FAFF@IRVEXCHCCR02.corp.ad.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <waie@broadcom.com>
Cc: 'James Bottomley' <JBottomley@novell.com>, 'open-iscsi' <open-iscsi@googlegroups.com>, 'linux-scsi' <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Benjamin Li <benli@broadcom.com>

On 08/11/2010 02:26 PM, Eddie Wai wrote:
> Hello Mike,
>
> Thanks for reviewing.  Since both scsi_device->lun and the local scsi_lun array variable are defined as u32 so we're using a direct u32 manipulation.  It's also consistent to the old code.
>
> We chose to use memcpy for the default case as both tmfabort_wqe->lun and tmfabort_hdr->lun are defined to be u8.  This u8 copying is also consistent to the other code paths in the existing bnx2i like nopout_wqe, etc.
>

You can do the same for the abort case. For aborts the tmfabort_hdr->lun 
has already been converted from a int to a scsi_lun for you so you 
should be able to copy it too.


> Thanks,
> Eddie
>
> -----Original Message-----
> From: Mike Christie [mailto:michaelc@cs.wisc.edu]
> Sent: Wednesday, August 11, 2010 12:07 PM
> To: Eddie Wai
> Cc: James Bottomley; open-iscsi; linux-scsi; Michael Chan; Anil Veerabhadrappa; Benjamin Li
> Subject: Re: [PATCH 2/5] BNX2I: Added support for other TMFs besides ABORT_TASK
>
> On 08/10/2010 02:09 PM, Eddie Wai wrote:
>> +		/* Retrieve LUN directly from the ref_sc */
>> +		int_to_scsilun(ref_sc->device->lun,
>> +			       (struct scsi_lun *) scsi_lun);
>> +		tmfabort_wqe->lun[0] = be32_to_cpu(scsi_lun[0]);
>> +		tmfabort_wqe->lun[1] = be32_to_cpu(scsi_lun[1]);
>> +
>
>
>
>> +	default:
>> +		memcpy(tmfabort_wqe->lun, tmfabort_hdr->lun, 8);
>
> Why do you copy the lun differently?
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

