From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fixes and cleanups for the new command allocation code
Date: Tue, 4 Feb 2003 19:03:31 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030204190331.A32115@lst.de>
References: <20030204162326.A30755@lst.de> <20030204081616.A24105@beaverton.ibm.com> <20030204175146.A31515@lst.de> <20030204091955.A24785@beaverton.ibm.com> <3E3FFEEF.3040506@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E3FFEEF.3040506@splentec.com>; from luben@splentec.com on Tue, Feb 04, 2003 at 12:57:03PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Tue, Feb 04, 2003 at 12:57:03PM -0500, Luben Tuikov wrote:
> The sole functionality of scsi_get/put_command() is/was(?) to
> just give/take back a command structure.  This was my intention,
> to abstract it away, with a well defined functionality.
> 
> Queue depths, limits and such checks should be provided elsewhere,
> i.e. in the enqueuing piece of code of a scsi_cmnd into a LLDD.  Again,
> this should be abstracted away with a well defined/sole functionality.

scsi_get_command/scsi_put_command is only called from the scsi midlayer.
There are a few stale references in LLDDs, but it's either stubbed out
(cpqfc) or the driver is far away from beeing useable on 2.5 (gdth).
Both of them need updating to the scsi_request based APIs anyway.

> BTW, is it the trend to have ether-pointers (as I call them) in SCSI Core
> all over the place or to put SCSI Core data in a structure (i.e. to
> reflect that it *is* SCSI Core), aka struct scsi_core_data?  I see this is
> now gone.

The trend is to have as much variables as possible static to one source
file and if that is not possible have it global in C language scope but
not exported to modules.

