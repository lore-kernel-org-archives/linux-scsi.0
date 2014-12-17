From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/1] [SCSI] mpt2sas: Convert non-returned local variable
 to boolean when relevant
Date: Wed, 17 Dec 2014 10:52:40 -0800
Message-ID: <1418842360.14140.29.camel@perches.com>
References: <20141217145618.GA2812@sloth>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay0092.hostedemail.com ([216.40.44.92]:46429 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751323AbaLQSwp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Dec 2014 13:52:45 -0500
In-Reply-To: <20141217145618.GA2812@sloth>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Quentin Lambert <lambert.quentin@gmail.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2014-12-17 at 15:56 +0100, Quentin Lambert wrote:
> This patch was produced using Coccinelle. A simplified version of the
> semantic patch is:

[...]

Interesting.

Some of these conversions show what I think is
relatively poor logic.  For instance:

> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
[]
> @@ -1414,10 +1414,10 @@ _base_enable_msix(struct MPT2SAS_ADAPTER *ioc)
>  	struct msix_entry *entries, *a;
>  	int r;
>  	int i;
> -	u8 try_msix = 0;
> +	bool try_msix = false;
>  
>  	if (msix_disable == -1 || msix_disable == 0)
> -		try_msix = 1;
> +		try_msix = true;
>  
>  	if (!try_msix)
>  		goto try_ioapic;

This might as well remove the try_msix variable
and become:

	if (msix_disable != -1 && msix_disable != 0)
		goto try_ioapic;

> @@ -3236,7 +3236,7 @@ mpt2sas_base_sas_iounit_control(struct MPT2SAS_ADAPTER *ioc,
>  	u16 smid;
>  	u32 ioc_state;
>  	unsigned long timeleft;
> -	u8 issue_reset;
> +	bool issue_reset;
>  	int rc;
>  	void *request;
>  	u16 wait_state_count;
> @@ -3300,7 +3300,7 @@ mpt2sas_base_sas_iounit_control(struct MPT2SAS_ADAPTER *ioc,
>  		_debug_dump_mf(mpi_request,
>  		    sizeof(Mpi2SasIoUnitControlRequest_t)/4);
>  		if (!(ioc->base_cmds.status & MPT2_CMD_RESET))
> -			issue_reset = 1;
> +			issue_reset = true;
>  		goto issue_host_reset;
>  	}
>  	if (ioc->base_cmds.status & MPT2_CMD_REPLY_VALID)

It seems like issue_reset should be initialized to false.
issue_reset can be an arbitrary value before the goto issue_host_reset
which is:

 issue_host_reset:
	if (issue_reset)
		mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
		    FORCE_BIG_HAMMER);

> @@ -3341,7 +3341,7 @@ mpt2sas_base_scsi_enclosure_processor(struct MPT2SAS_ADAPTER *ioc,
>  	u16 smid;
>  	u32 ioc_state;p
>  	unsigned long timeleft;
> -	u8 issue_reset;
> +	bool issue_reset;
>  	int rc;
>  	void *request;
>  	u16 wait_state_count;
> @@ -3398,7 +3398,7 @@ mpt2sas_base_scsi_enclosure_processor(struct MPT2SAS_ADAPTER *ioc,
>  		_debug_dump_mf(mpi_request,
>  		    sizeof(Mpi2SepRequest_t)/4);
>  		if (!(ioc->base_cmds.status & MPT2_CMD_RESET))
> -			issue_reset = 1;
> +			issue_reset = true;
>  		goto issue_host_reset;
>  	}

same

I stopped looking here.


