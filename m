From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: 2.6.12-rc3 won't boot from aic7899
Date: Sun, 01 May 2005 15:29:58 -0500
Message-ID: <1114979399.4788.31.camel@mulgrave>
References: <4269C60C.3070700@cybsft.com> <1114716611.5022.6.camel@mulgrave>
	 <4271413F.70809@cybsft.com> <1114719624.5022.14.camel@mulgrave>
	 <42721252.2070902@cybsft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:30088 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262663AbVEAUaF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 May 2005 16:30:05 -0400
In-Reply-To: <42721252.2070902@cybsft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K.R. Foley" <kr@cybsft.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-04-29 at 05:54 -0500, K.R. Foley wrote:
> I tried the patch that you sent. It looks like its blowing up now in 
> ahc_send_async. At least now we have an oops to look at. I started 
> trying to trace through this, but ran out of time. I am sending it on to 
> you in hopes that you'll be able to figure this out much quicker than I can.

Well ... there's odd news from this.  I can simulate this pretty well
just by cutting the upper 8 bits from a wide cable (Which I got right on
the second attempt; silly me for assuming that the strands in a ribbon
cable would be numbered 1,2,3 etc. 1,35,2,36 is much more logical ...)

However, when I do this, I get:

  Vendor: HP 36.4G  Model: ST336607LW        Rev: HPC3
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi11:A:1:0: Tagged Queuing enabled.  Depth 32
 target11:0:1: Beginning Domain Validation
(scsi11:A:1): 6.600MB/s transfers (16bit)
(scsi11:A:1:0): parity error detected in Data-in phase. SEQADDR(0x84) SCSIRATE(0x80)
 target11:0:1: Wide Transfers Fail
(scsi11:A:1): 3.300MB/s transfers
(scsi11:A:1): 40.000MB/s transfers (40.000MHz, offset 63)
 target11:0:1: Ending Domain Validation

Which is what I expected, and also shows that it's not as simple as I
was thinking: the aic7xxx not propagating the errors and trying to fix
up on its own.

However, it could be the command is getting lost in error recovery.
Could you enable logging and boot with the parameter 

scsi_logging_level=0xffff

to give me a better trace of what's going on?

Thanks,

James


James


