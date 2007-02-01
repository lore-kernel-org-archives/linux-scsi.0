From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] RESEND: SCSI, libata: add support for ATA_16 commands
 to libata ATAPI devices
Date: Thu, 01 Feb 2007 09:48:40 +0900
Message-ID: <45C138E8.1040706@gmail.com>
References: <200701021935.07840.liml@rtr.ca> <200701311346.26644.liml@rtr.ca> <45C1356B.6000907@gmail.com> <45C1377F.6070001@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45C1377F.6070001@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Linux IDE <linux-ide@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Mark Lord wrote:
> Tejun Heo wrote:
>> Mark Lord wrote:
>> ..
>>> So, to achieve ATA passthru capability for libata ATAPI,
>>> we have to instead use the ATA_16 opcode: a 16-byte command.
>>>
>>> SCSI normally disallows issuing 16-byte commands to 12-byte devices,
>>> so special support has to be added for this.
> 
>> I might have missed the discussion but can't we just set
>> host->max_cmd_len to 16 unconditionally?
> 
> Sure thing, if you and Jeff are happy with that, then lets do it.
> 
> I just kind of assumed that the complexity in ata_set_port_max_cmd_len()
> was there for some kind of reason.
> 
> For example, I think all existing ATAPI drives only speak 12-byte packet
> protocols, and so if we tell SCSI we're good for 16-byte, then won't the
> SCSI layer suddenly start sending us READ_16 and the like?

SCSI always uses the smallest command it can use, so we're safe.  Most
other commands are issued directly from the userland and it's their
responsibility not to feed disallowed commands to a device (or we need
more advanced filter).  Anyways, this has never been guaranteed because
the limit is host wide.

So, I'm for setting it to 16.  Jeff, what do you think?

-- 
tejun
