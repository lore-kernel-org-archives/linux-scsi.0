From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: ATA PASSTHROUGH command support issue
Date: Thu, 21 Nov 2013 07:37:30 -0800
Message-ID: <1385048250.2172.11.camel@dabdike.int.hansenpartnership.com>
References: <F9AEE99A65F8B04980BD286E8FF728861FAEBE40@chn-hclt-mbs04.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <F9AEE99A65F8B04980BD286E8FF728861FAEBE40@chn-hclt-mbs04.HCLT.CORP.HCL.IN>
Sender: linux-ide-owner@vger.kernel.org
To: Sangeetha Gnanasekaran <sangeetha_g@hcl.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Krishna Bilash Paul - ERS, HCL Tech" <Krishna.Paul@hcl.com>, "Anand Kumar S - ERS, HCL Tech" <sanandkumar@hcl.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-11-21 at 12:37 +0000, Sangeetha Gnanasekaran wrote:
> Hi,
> 
> We are implementing utility for testing ATA compliance of drives.
> We faced issues while sending some commands using ATA PASSTHROUGH supported by libata.
> Below list of protocols are not supported by libata and hence we are not able to send  commands which follow below protocols.
> 
> Protocol field value		Details
> 
> 0					Hard Reset
> 1					SRST
> 7					DMA-Queued
> 8					Device Diagnostic
> 9					Device Reset
> 12					FPDMA
> 15					Return Response Info
> 
> Can anybody give us input as why it is not supported? 

Well, firstly this is the SCSI list not the ATA list (cc'd).  Secondly
those are all protocol messages.  The command pass through is well for
commands.  It's designed to inject commands into a stream in a way that
won't disrupt the device.  You can get at the resets via other means
since they're complete but all the rest are partial messages that are
used as part of command dispatch.

James


