From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block pc
	requests and simplify hw handlers
Date: Tue, 7 Jun 2005 11:23:17 -0700
Message-ID: <20050607182317.GA12959@us.ibm.com>
References: <1117847972.23638.62.camel@mina> <1117901234.5005.9.camel@mulgrave>
	<1117955727.4961.8.camel@mina> <20050606190205.GA6817@us.ibm.com>
	<1118157976.42a5bc98d6f75@webmail.cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1118157976.42a5bc98d6f75@webmail.cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Michael Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 07, 2005 at 10:26:16AM -0500, Michael Christie wrote:
> Quoting Patrick Mansfield <patmans@us.ibm.com>:

> > Why can't the retries be passed down via a new blk req->retries?
> > 
> 
> Is that all that is needed for dm-multipath? I thought this would be a good time
> to add some code to allow the finer grained control of retries that could also
> be used by dm and md. For example do you only want to retry certain failures X
> numbeer of times?

I was looking/thinking about the scsi_scan retries not multipath.

Setting retries might help dm-multipath, but I thought multipath was going
to use fast fail.

The "certain failures" is in question, it is not clear if fastfail (or
setting retries to zero) give the right behaviour for use by dm-multipath,
and it is not easy to analyze.

Examples: 

MEDIUM_ERROR gets NEEDS_RETRY but is also handled in sd.c:sd_rw_intr(), it
looks like we retry (if not fast fail), and then sd_rw_intr will do a
partial retry of the error after that. So with fast fail, we never retry
the entire IO.

DID_BUSY_BUSY: should this not be retried for fast fail? It is HBA
driver/hardware specific.

The unconditional retries in scsi_io_completion() all look OK for multipath.

-- Patrick Mansfield
