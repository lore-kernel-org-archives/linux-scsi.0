From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: Debugging scsi abort handling ?
Date: Fri, 29 Aug 2014 04:52:51 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C2BACC@G9W0745.americas.hpqcorp.net>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com>
  <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org>
  <53FB1ACD.1040208@redhat.com> <53FF1AD8.9020800@suse.de>
  <53FF1EB8.9010700@redhat.com> <1409234983.2475.2.camel@jarvis.lan>
 <alpine.LNX.2.00.1408291112440.7204@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:6211 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaH2Eym convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Aug 2014 00:54:42 -0400
In-Reply-To: <alpine.LNX.2.00.1408291112440.7204@nippy.intranet>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Hannes Reinecke <hare@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Finn Thain
> Sent: Thursday, August 28, 2014 11:37 PM
> To: James Bottomley
> Cc: Hans de Goede; Hannes Reinecke; Paolo Bonzini; Bart Van Assche; SCSI
> development list
> Subject: Re: Debugging scsi abort handling ?
> 
> 
> On Thu, 28 Aug 2014, James Bottomley wrote:
...
> Another subtlety is that the abort handler is apparently expected to
> perform autosense for an aborted command (or wait for that to happen
> normally) and only return after this has taken place (rather than
> immediately killing the command).

Sending a REQUEST SENSE and expecting to get sense data for another
command only works in protocols like parallel SCSI that supported
contingent allegiance - a feature that is obsolete in the
SCSI architecture model.  In modern SCSI protocols, that command
just returns "polled sense data" like the status of background tasks,
not sense data related to any particular command.

James posted a patch a while back that bypasses sending that
command and misinterpreting the result.

> > You can get the situation where we try to abort (or do other EH) on a
> > command you think you've already completed, but you just return
> > success for that.
> 
> In general, the LLD cannot distinguish between a command previously
> completed and a command it has never encountered. But it seems that
> eh_abort_handler() should return SUCCESS either way.
> 
> That seems like an unintuitive interpretation of "successfully aborted"
> so it perhaps this needs to be documented too. The drivers I've looked at
> (esp_scsi and ncr5380) don't do this. If asked to abort some command
> which they completed in the past, they would return failure.

That is how the SCSI architecture model defines ABORT TASK,
so shouldn't be too surprising here.

I wouldn't focus too much on those old parallel SCSI drivers; SAS, Fibre
Channel, iSCSI, and SRP drivers are better examples now.

---
Rob Elliott  HP Server Storage



