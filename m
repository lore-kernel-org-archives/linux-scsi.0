From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Tue, 26 Jun 2007 15:29:23 -0600
Message-ID: <20070626212923.GT22063@parisc-linux.org>
References: <46801010.3050604@s5r6.in-berlin.de> <877013.89456.qm@web31802.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58564 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758205AbXFZV3Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jun 2007 17:29:25 -0400
Content-Disposition: inline
In-Reply-To: <877013.89456.qm@web31802.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Hannes Reinecke <hare@suse.de>, Swen Schillig <swen@vnet.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

On Mon, Jun 25, 2007 at 02:27:01PM -0700, Luben Tuikov wrote:
> Ideally SCSI Core is presented with an opaque token (void *, unsigned long (long),
> etc) which represents a target port, which it uses to send SPC commands
> to the target to find out how many if any LUs the target has, INQUIRY them,
> and then create struct scsi_dev for each LU.
> 
> When presented with this opaque token*, SCSI Core allocates and
> initializes a struct scsi_target, whose children are LUs, later
> to be discovered by SCSI Core.  SCSI Core then uses that opaque token
> to ask the transport protocol layer to send commands to the I_T_L
> nexus (WLUN or LUN if it knows it from previous discovery attempt).
> 
> * Note this means that there is no "active" scanning on part
> of the SCSI Core.  This belongs to the transport layer.
> (And thus the "concept" of "async-scanning" recently introduced
> to SCSI Core, becomes moot.)

Not really.  The async scanning code is there to ensure that scsi
devices get the same name as they would if the devices were scanned
one after another.  We can make all this code moot if we determine that
we're willing to accept a world where 'sda' may refer to any random scsi
disc.

I'd be quite happy to move the code that does the "active scanning" to
scsi_transport_spi.c, but right now that would be quite a bit of extra
code for drivers which haven't been converted to use scsi_transport_spi
yet.  My nefarious plan is to convert drivers to use it, then move that
code there.  I do agreee with you that SPI-free systems shouldn't have
to carry that legacy code around (but actually, it's very little code,
so this is more of a purity thing than a real concern).
