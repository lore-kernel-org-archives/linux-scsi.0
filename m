From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC] libata new EH document
Date: Thu, 1 Sep 2005 01:54:21 -0400
Message-ID: <20050901055421.GA23496@havoc.gtf.org>
References: <20050901043850.15186.qmail@web51611.mail.yahoo.com> <43169520.6040008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:42118 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S964966AbVIAFyX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2005 01:54:23 -0400
Content-Disposition: inline
In-Reply-To: <43169520.6040008@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: ltuikov@yahoo.com, Luben Tuikov <luben_tuikov@adaptec.com>, Albert Lee <albertcc@tw.ibm.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Doug Maxey <dwm@maxeymade.com>

On Thu, Sep 01, 2005 at 02:44:00PM +0900, Tejun Heo wrote:
>  Can you please elaborate why getting sense data from EH is bad idea 
> for ATAPI?  For more advanced SCSI transports, I agree with you that 
> autosensing is necessary with queueing and multiple initiator and etc, 
> but I don't really see how requesting sense from EH would be bad for ATAPI.

The long term direction for the SCSI core seems to be that of
requiring auto-sensing.

libata is simply being lazy:  while the SCSI core continues to support
kicking the EH thread when sense is missing, it's preferred for libata
to reuse that infrastructure.

Auto-sensing (and READ LOG EXT for NCQ errors) requires either an
FSM or a kernel thread, to initiate a secondary qc for REQUEST SENSE.
Since the common infrastructure already exists for this, libata reuses
the existing SCSI EH kernel thread.

We should move libata-scsi to auto-sensing, but it's not an urgent priority.

	Jeff



