From: "Eddie Wai" <waie@broadcom.com>
Subject: RE: [PATCH 2/5] BNX2I: Added support for other TMFs besides
 ABORT_TASK
Date: Wed, 11 Aug 2010 12:26:47 -0700
Message-ID: <F856AC0DBD5E8A48948C6FDDFF2ECA9F94F7F3FAFF@IRVEXCHCCR02.corp.ad.broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
 <1281467374-6182-3-git-send-email-eddie.wai@broadcom.com>
 <4C62F4DB.8070006@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1842 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab0HKT05 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Aug 2010 15:26:57 -0400
In-Reply-To: <4C62F4DB.8070006@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Mike Christie' <michaelc@cs.wisc.edu>
Cc: 'James Bottomley' <JBottomley@novell.com>, 'open-iscsi' <open-iscsi@googlegroups.com>, 'linux-scsi' <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Benjamin Li <benli@broadcom.com>

Hello Mike,

Thanks for reviewing.  Since both scsi_device->lun and the local scsi_lun array variable are defined as u32 so we're using a direct u32 manipulation.  It's also consistent to the old code.  

We chose to use memcpy for the default case as both tmfabort_wqe->lun and tmfabort_hdr->lun are defined to be u8.  This u8 copying is also consistent to the other code paths in the existing bnx2i like nopout_wqe, etc.

Thanks,
Eddie

-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Wednesday, August 11, 2010 12:07 PM
To: Eddie Wai
Cc: James Bottomley; open-iscsi; linux-scsi; Michael Chan; Anil Veerabhadrappa; Benjamin Li
Subject: Re: [PATCH 2/5] BNX2I: Added support for other TMFs besides ABORT_TASK

On 08/10/2010 02:09 PM, Eddie Wai wrote:
> +		/* Retrieve LUN directly from the ref_sc */
> +		int_to_scsilun(ref_sc->device->lun,
> +			       (struct scsi_lun *) scsi_lun);
> +		tmfabort_wqe->lun[0] = be32_to_cpu(scsi_lun[0]);
> +		tmfabort_wqe->lun[1] = be32_to_cpu(scsi_lun[1]);
> +



> +	default:
> +		memcpy(tmfabort_wqe->lun, tmfabort_hdr->lun, 8);

Why do you copy the lun differently?


