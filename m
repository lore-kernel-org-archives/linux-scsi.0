From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] make fc transport removal of target configurable
Date: Tue, 13 Jun 2006 10:42:35 -0500
Message-ID: <448EDCEB.50702@sgi.com>
References: <448DF5DA.3070800@sgi.com> <20060613070714.GA16358@infradead.org> <448E9C34.6070707@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:11458 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S932147AbWFMPmq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jun 2006 11:42:46 -0400
In-Reply-To: <448E9C34.6070707@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jim Nead <jnead@sgi.com>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>



James Smart wrote:
> We are seriously in trouble if the subsystems above us don't know how
> to deal with dead targets. We are encountering scenarios in which the
> data structures are staying around due to references, but for all other
> intents they're gone.  I know that DM has yet to fully account for this.
> md - it's dead. Applications... they have no clue.

Mounted file systems have no clue either.  Even with no activity on the
fs, if the target stays missing beyond the device loss timeout and then
returns, the file system cannot be accessed without intervention.

When the target does return, the file system has to be unmounted and
remounted on a new "sd" device.  This is even if there was no activity
on the file system while its target was absent, i.e., it wouldn't otherwise
require an unmount/remount.

> 
> I think we should seriously reconsider this position. FC is the only major
> storage transport that does this (USB doesn't count). Parallel SCSI
> doesn't, iSCSI doesn't, SAS doesn't.  If the device was truly gone, ok.
> But, if we expect the device to come alive again sometime in the future,
> why not keep the tree in place ?

Treating fibre channel like removable storage is wrong.  Fibre targets aren't
generally supposed to go away.  If they do, there's a significant chance
that they'll be repaired and returned to service.  It makes sense to keep
the infrastructure in place just like scsi, sas, iscsi, ata.

The kind of disruption the current code can cause to systems with multi-terabytes
or petabytes of storage will be considered unacceptable in a production environment.

So, I also wish to encourage a reconsideration of the position that dead targets
should be removed.  Removing removable storage targets like firewire and usb
makes sense.  I just don't believe that the same applies to fibre channel
or other generally non-removable targets.

Mike

> 
> -- james s
> 
> 
> 
> Christoph Hellwig wrote:
>> On Mon, Jun 12, 2006 at 06:16:42PM -0500, Michael Reed wrote:
>>> If the fc transport removes the scsi infrastructure for a
>>> disconnected target and that target subsequently returns,
>>> those subsystems layered upon scsi which don't understand
>>> the implications of this disconnection / reconnection may
>>> be unable to access the reconnected scsi target.  This patch
>>> makes the target removal configurable.
>>
>> NACK, we don't want to keep dead targets around.
>>
>>
> 


