From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block pc
	requests and simplify hw handlers
Date: Mon, 6 Jun 2005 12:02:05 -0700
Message-ID: <20050606190205.GA6817@us.ibm.com>
References: <1117847972.23638.62.camel@mina> <1117901234.5005.9.camel@mulgrave>
	<1117955727.4961.8.camel@mina>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1117955727.4961.8.camel@mina>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jun 05, 2005 at 12:15:27AM -0700, Mike Christie wrote:
> On Sat, 2005-06-04 at 09:07, James Bottomley wrote:

> > Here's the proof of concept for this one.  It converts scsi_wait_req to
> > do correct REQ_BLOCK_PC submission (and works nicely in my setup).

That is nice ... I didn't realize Mike's change allowed that.

> > There's some loss of functionality to this: retries are no longer
> > controllable (except by setting REQ_FASTFAIL) and the wait_req API needs
> > to be altered, but it looks very nice.

Mike your patch did not replace the retries.

Why can't the retries be passed down via a new blk req->retries?

Or just have scsi_wait_req() do the retries for us (it can sleep). 

It is hard to look at the scsi IO completion paths and see exactly what we
do and don't (well should and should not) retry. That is we call
scsi_retry_command() conditionally based on "retries" but can repeatedly
call scsi_requeue_command() in scsi_io_completion().

-- Patrick Mansfield
