From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 18:12:56 -0500
Message-ID: <1147821176.3505.101.camel@mulgrave.il.steeleye.com>
References: <20060516230233.39830.qmail@web31813.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:19875 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932274AbWEPXOI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 19:14:08 -0400
In-Reply-To: <20060516230233.39830.qmail@web31813.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Jeff Garzik <jeff@garzik.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2006-05-16 at 16:02 -0700, Luben Tuikov wrote:
> The nexus between the driver and SCSI Core is terminated only when
> done() is called.  done() is the antagonist of queuecommand().
> 
> Until done() is called, if the LLDD/IC/SCSI Core want to request that
> a command be aborted for whatever reason, it calls
> scsi_req_abort_cmd().
> 
> That is, until the nexus created by calling queuecommand(), is
> returned
> to SCSI Core (by the driver calling done()), if either the driver or
> SCSI Core want to request the command be aborted, they call
> scsi_req_abort_cmd().

Erm, no, actually, I think if you look at SAM-3 (section 4.12) you'll
find that a nexus can only be maintained with the consent of both the
initiator and the target.  The (transport dependent) signal of
completion is an indicator of nexus termination (except in the linked
command case).

James


