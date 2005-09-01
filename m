From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [RFC] libata new EH document
Date: Thu, 01 Sep 2005 17:40:44 -0400
Message-ID: <4317755C.5080700@adaptec.com>
References: <20050901043850.15186.qmail@web51611.mail.yahoo.com>	 <43169520.6040008@gmail.com>  <20050901055421.GA23496@havoc.gtf.org> <1125581097.4834.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1125581097.4834.5.camel@mulgrave>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, ltuikov@yahoo.com, Albert Lee <albertcc@tw.ibm.com>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Doug Maxey <dwm@maxeymade.com>
List-Id: linux-scsi@vger.kernel.org

On 09/01/05 09:24, James Bottomley wrote:
> On Thu, 2005-09-01 at 01:54 -0400, Jeff Garzik wrote:
> 
>>The long term direction for the SCSI core seems to be that of
>>requiring auto-sensing.
> 
> 
> No, I don't see the mid-layer error thread handling of this ever going
> away.
> 
>>libata is simply being lazy:  while the SCSI core continues to support
>>kicking the EH thread when sense is missing, it's preferred for libata
>>to reuse that infrastructure.
> 
> 
> That makes the most sense ;-)

For libata it doesn't really matter, since it is _ATA_.

> The current SCSI autosense in drivers doesn't require this because we
> reuse the existing command that got the contingent allegiance condition.

Care to elaborate what "contingent allegiance condition" is,
how SCSI Core got it, how SCSI Core is using it, and how SCSI Core set
it up with the LU?

> This is the piece I'd like to get rid of because the extra fields and
> extra setup to allow the command to be reused are a critical path hit.

If you _do_ get rid of the extra fields, then you _really_ need
LLDD/protocols to support autosense.

> If you look at any driver that does this (53c700.c for instance) you'll
> see that the command is turned around and resubmitted in the irq
> routine).

That's ok.

	Luben
