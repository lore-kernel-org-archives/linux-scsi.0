From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [patch 1/7] mptbase: reset ioc initiator during PCI resume
Date: Tue, 4 Mar 2008 16:30:24 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D70D555F3@NAMAIL4.ad.lsil.com>
References: <200803042324.m24NOLWG003081@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:41655 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934465AbYCDXaw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 18:30:52 -0500
Content-class: urn:content-classes:message
In-Reply-To: <200803042324.m24NOLWG003081@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, djwong@us.ibm.com, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Tuesday, March 04, 2008 4:24 PM, Andrew Morton  wrote: 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> Cc: "Moore, Eric" <Eric.Moore@lsi.com>
> Cc: <Sathya.Prakash@lsi.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/message/fusion/mptbase.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff -puN 
> drivers/message/fusion/mptbase.c~mptbase-reset-ioc-initiator-d
> uring-pci-resume drivers/message/fusion/mptbase.c
> --- 
> a/drivers/message/fusion/mptbase.c~mptbase-reset-ioc-initiator
> -during-pci-resume
> +++ a/drivers/message/fusion/mptbase.c
> @@ -1852,6 +1852,12 @@ mpt_resume(struct pci_dev *pdev)
>  		(mpt_GetIocState(ioc, 1) >> MPI_IOC_STATE_SHIFT),
>  		CHIPREG_READ32(&ioc->chip->Doorbell));
>  
> +	/* put ioc into READY_STATE */
> +	if(SendIocReset(ioc, 
> MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, CAN_SLEEP)) {
> +		printk(MYIOC_s_ERR_FMT
> +		"pci-resume:  IOC msg unit reset failed!\n", ioc->name);
> +	}
> +
>  	/* bring ioc to operational state */
>  	if ((recovery_state = mpt_do_ioc_recovery(ioc,
>  	    MPT_HOSTEVENT_IOC_RECOVER, CAN_SLEEP)) != 0) {
> _
>

Actually we have a different patch for this, which Sathya been working
on.

Eric 
