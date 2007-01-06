From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2/5] fusion: vmware bug fix prevent inifinite retries
Date: Sat, 06 Jan 2007 09:30:45 -0600
Message-ID: <1168097445.2792.53.camel@mulgrave.il.steeleye.com>
References: <20070105034613.GA14118@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:47247 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751355AbXAFPav (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Jan 2007 10:30:51 -0500
In-Reply-To: <20070105034613.GA14118@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2007-01-04 at 20:46 -0700, Eric Moore wrote:
> -			if (scsi_status == MPI_SCSI_STATUS_BUSY)
> +			if (ioc->bus_type != SPI && scsi_status == MPI_SCSI_STATUS_BUSY)
>  				sc->result = (DID_BUS_BUSY << 16) | scsi_status;
>  			else
>  				sc->result = (DID_OK << 16) | scsi_status;

DID_BUS_BUSY causes an immediate retry, but it does debit the retry
count, so it shouldn't cause "infinite retries" ... if it does, there's
something else wrong here.

I should also point out that the MPI_SCSI_STATUS_BUSY is
SAM_STAT_BUSY ... this return will cause a queue stop and a requeue, but
it doesn't actually debit the retries, so it *may* cause an infinite
loop if the system is permanently busy.

Finally, whatever's causing this, it should probably be treated the same
for all fusion bus types ...

James


