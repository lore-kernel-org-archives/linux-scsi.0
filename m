From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] libata new EH document
Date: Tue, 30 Aug 2005 09:27:02 -0500
Message-ID: <1125412023.5037.15.camel@mulgrave>
References: <20050829061124.GA2725@htj.dyndns.org>
	 <43142279.3070004@tw.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <43142279.3070004@tw.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Albert Lee <albertcc@tw.ibm.com>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Doug Maxey <dwm@maxeymade.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2005-08-30 at 17:10 +0800, Albert Lee wrote:
> Could we get the sense data before calling qc->scsidone()?  (Using the 
> proposed separate
> EH qc can keep the original qc intact.)

Well, the way most SCSI drivers do it today is to turn around the
command returning Check Condition from irq context.  This is sort of
like ACA simulation.  The reason it's done is because while a drive
holds a contingent allegiance condition it cannot accept other commands.
This effectively holds everything in abeyance until the sense is taken,
so for fast operation, SCSI drivers take the sense as soon as possible.

Ideally, though this mechanism should be deprecated because it causes us
to keep a complete copy of the old command and parameters around which
is a hit in the command allocation and set up fast path.

> The issue:
> When a DVD drive returns MEDIUM_ERROR in the sense data, libata doesn't 
> retry the command.
> 
> For libata, when scsi_softirq() calls scsi_decide_disposition() and 
> scsi_check_sense() to determine
> how to handle the result, scsi_check_sense() always returns "fail" since 
> the sense data is not there
> yet. The sense data is requested later in the libata error handler. But 
> the command has already been
> considered as an "error".
> 
> By having the sense data ready before calling qc->scsidone(), we can 
> make the
> NEEDS_RETRY work in scsi_softirq().  So, for things like MEDIUM_ERROR, 
> the device has
> a chance to retry/recover the error. This seems to be important for 
> devices with built-in
> defect management system.

It sounds like the ATA error handler is missing the sense interpretation
part.  If you look at the scsi error handler, we will request sense and
then redecide the disposition based on the return.

James


