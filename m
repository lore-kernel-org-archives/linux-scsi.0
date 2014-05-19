From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: scsi error handling thread and REQUEST SENSE
Date: Mon, 19 May 2014 12:29:24 +0200
Message-ID: <5379DD04.9020303@acm.org>
References: <94D0CD8314A33A4D9D801C0FE68B402956F17E1F@G4W3202.americas.hpqcorp.net> <1400270713.3813.33.camel@localhost.localdomain> <5379C1B2.2040600@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:56146 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbaESK32 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2014 06:29:28 -0400
In-Reply-To: <5379C1B2.2040600@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, emilne@redhat.com, "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "James Bottomley (jbottomley@parallels.com)" <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 05/19/14 10:32, Hannes Reinecke wrote:
> Well, problem here is that the 'REQUEST SENSE' command has two problems:
> a) Most modern HBA (ie all non-SPI HBAs) use autosense, ie the sense
> code is returned with the command. So issuing 'REQUEST SENSE' here is
> pointless.
> b) The sense code (when retrieved via 'REQUEST SENSE') relates to the
> most recently processed command (from the target perspective).
> Which is a bit hard to make out, as by the time SCSI EH starts
> several other commands might have been processed already, so any
> sense we'd be retrieving most likely does not relate to the failed command.
> 
> I would propose to disable the 'REQUEST_SENSE' step as soon as the HBA
> is capable of autosensing. We requires us to add another flag
> to the scsi_host field.
> 
> What about the attached patch? That should roughly do what's required
> here, right?

This patch does not address the SRP initiator. There might be more SCSI
initiator drivers that support autosense but that are not addressed by
this patch. Has it been considered to set the autosense flag for all
HBA's and clear it in those SCSI initiator drivers that do not support
autosense ?

Bart.

