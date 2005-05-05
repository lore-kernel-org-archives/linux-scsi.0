From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fix command retries in spi_transport class
Date: Thu, 05 May 2005 09:57:27 -0500
Message-ID: <1115305048.5060.2.camel@mulgrave>
References: <1114991896.4788.44.camel@mulgrave>
	 <4276DC27.9030403@cybsft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:53962 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262123AbVEEO5b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 May 2005 10:57:31 -0400
In-Reply-To: <4276DC27.9030403@cybsft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K.R. Foley" <kr@cybsft.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-05-02 at 21:04 -0500, K.R. Foley wrote: 
>   Vendor: SEAGATE   Model: SX118273LC        Rev: 6679
>   Type:   Direct-Access                      ANSI SCSI revision: 02
> scsi1:A:0:0: Tagged Queuing enabled.  Depth 32
>  target1:0:0: Beginning Domain Validation
> (scsi1:A:0): 6.600MB/s transfers (16bit)
> (scsi1:A:0:0): parity error detected in Data-in phase. SEQADDR(0x6a) SCSIRATE(0x80)
> (scsi1:A:0:0): parity error detected in Data-in phase. SEQADDR(0x83) SCSIRATE(0x80)
> (scsi1:A:0:0): parity error detected in Data-in phase. SEQADDR(0x83) SCSIRATE(0x80)
> (scsi1:A:0:0): parity error detected in Data-in phase. SEQADDR(0x1a6) SCSIRATE(0x80)
> (scsi1:A:0:0): parity error detected in Command phase. SEQADDR(0x1a6) SCSIRATE(0x80)
>  target1:0:0: Wide Transfers Fail

This means that the driver is now correctly returning an error.

> (scsi1:A:0): 3.300MB/s transfers

Here we set the correct transfer parameters (narrow), which means all
the parity errors should go away.

I'm at a loss to either duplicate this or figure out from the code what
might be going on, so I really need a trace to help out.

If you can't set the kernel boot line options, you can just edit scsi.c
to set the variable scsi_logging_level to 0xffff (and remove the
module_param lines for it, just in case).  Remember that
CONFIG_SCSI_LOGGING must be set as well.

Thanks,

James


