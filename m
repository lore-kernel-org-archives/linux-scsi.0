From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block
	pc	requests	and simplify hw handlers
Date: Tue, 7 Jun 2005 20:07:20 +0200
Message-ID: <20050607180719.GB8172@suse.de>
References: <1117847972.23638.62.camel@mina> <1117901234.5005.9.camel@mulgrave>
	<1117955727.4961.8.camel@mina> <1117982408.4990.12.camel@mulgrave>
	<1117998665.4990.17.camel@mulgrave> <42A3E275.6030106@torque.net>
	<1118067544.5045.17.camel@mulgrave> <42A59C35.5060207@torque.net>
	<1118159966.4813.8.camel@mulgrave>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1118159966.4813.8.camel@mulgrave>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: LIRANS@il.ibm.com, Mike Christie <michaelc@cs.wisc.edu>, Douglas Gilbert <dougg@torque.net>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 07 2005, James Bottomley wrote:
> On Tue, 2005-06-07 at 23:08 +1000, Douglas Gilbert wrote:
> > I don't think it is important and I'm not aware of any
> > real world applications that are using it. Naturally,
> > I will find out if that is actually true after it
> > gets removed.
> 
> Heh, true.  OK, let's do this: I'll remove it from the sg driver and
> make sg use the do_command (or it's successor) interface.  If an actual
> user for the iovecs does turn up, I'll add it to the block layer (it's a
> fairly well understood multi-bio request setup) and make sg and also the
> block layer SG_IO use it.

Why multi-bio? No one should ever have to build a request with multiple
bio's in one go, that's pointless. The only reason multi-bio requests
exist is because of the file systems not submitting big extents in one
submission. The whole io path would be faster and simpler were it not
for multi-bio requests :-)

A single bio can contain just as much data.

-- 
Jens Axboe
