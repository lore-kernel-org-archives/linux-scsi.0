From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] libata new EH document
Date: Thu, 01 Sep 2005 09:24:57 -0400
Message-ID: <1125581097.4834.5.camel@mulgrave>
References: <20050901043850.15186.qmail@web51611.mail.yahoo.com>
	 <43169520.6040008@gmail.com>  <20050901055421.GA23496@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20050901055421.GA23496@havoc.gtf.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Tejun Heo <htejun@gmail.com>, ltuikov@yahoo.com, Luben Tuikov <luben_tuikov@adaptec.com>, Albert Lee <albertcc@tw.ibm.com>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Doug Maxey <dwm@maxeymade.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2005-09-01 at 01:54 -0400, Jeff Garzik wrote:
> The long term direction for the SCSI core seems to be that of
> requiring auto-sensing.

No, I don't see the mid-layer error thread handling of this ever going
away.

> libata is simply being lazy:  while the SCSI core continues to support
> kicking the EH thread when sense is missing, it's preferred for libata
> to reuse that infrastructure.

That makes the most sense ;-)

> Auto-sensing (and READ LOG EXT for NCQ errors) requires either an
> FSM or a kernel thread, to initiate a secondary qc for REQUEST SENSE.
> Since the common infrastructure already exists for this, libata reuses
> the existing SCSI EH kernel thread.

The current SCSI autosense in drivers doesn't require this because we
reuse the existing command that got the contingent allegiance condition.
This is the piece I'd like to get rid of because the extra fields and
extra setup to allow the command to be reused are a critical path hit.
If you look at any driver that does this (53c700.c for instance) you'll
see that the command is turned around and resubmitted in the irq
routine).

James


