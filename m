From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] make fc transport removal of target configurable
Date: Tue, 13 Jun 2006 07:06:28 -0400
Message-ID: <448E9C34.6070707@emulex.com>
References: <448DF5DA.3070800@sgi.com> <20060613070714.GA16358@infradead.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:35814 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750936AbWFMLGu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jun 2006 07:06:50 -0400
In-Reply-To: <20060613070714.GA16358@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Michael Reed <mdr@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jim Nead <jnead@sgi.com>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>

We are seriously in trouble if the subsystems above us don't know how
to deal with dead targets. We are encountering scenarios in which the
data structures are staying around due to references, but for all other
intents they're gone.  I know that DM has yet to fully account for this.
md - it's dead. Applications... they have no clue.

I think we should seriously reconsider this position. FC is the only major
storage transport that does this (USB doesn't count). Parallel SCSI
doesn't, iSCSI doesn't, SAS doesn't.  If the device was truly gone, ok.
But, if we expect the device to come alive again sometime in the future,
why not keep the tree in place ?

-- james s



Christoph Hellwig wrote:
> On Mon, Jun 12, 2006 at 06:16:42PM -0500, Michael Reed wrote:
>> If the fc transport removes the scsi infrastructure for a
>> disconnected target and that target subsequently returns,
>> those subsystems layered upon scsi which don't understand
>> the implications of this disconnection / reconnection may
>> be unable to access the reconnected scsi target.  This patch
>> makes the target removal configurable.
> 
> NACK, we don't want to keep dead targets around.
> 
> 
