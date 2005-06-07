From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Re: [PATCH RFC 0/4] use scatter lists for all block
	pc requests and simplify hw handlers
Date: Tue, 07 Jun 2005 15:23:49 -0400
Message-ID: <1118172230.4791.5.camel@mulgrave>
References: <1117847972.23638.62.camel@mina> <1117901234.5005.9.camel@mulgrave>
	<20050607121020.GA6458@infradead.org>
	<1118146802.4998.3.camel@mulgrave>
	<1118158614.42a5bf160d317@webmail.cs.wisc.edu>
	<1118159134.42a5c11eb8965@webmail.cs.wisc.edu>
	<Pine.LNX.4.61.0506071914360.3034@kai.makisara.local>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.61.0506071914360.3034@kai.makisara.local>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Christoph Hellwig <hch@infradead.org>, Michael Christie <michaelc@cs.wisc.edu>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2005-06-07 at 19:26 +0300, Kai Makisara wrote:
> No, it can't do that. If the user submits one SCSI command, it must result 
> in one SCSI command to the device. Otherwise the effect is not what the 
> user wants. (You can split a multiple block read/write but this does not 
> apply to all commands.)

Yes, I agree ... we have to have a single request.

> Michael's question is important. The number of sg segments a HBA supports 
> determines the maximum SCSI data size. In some cases (e.g., tape 
> reads and writes with multimegabyte blocks) using page size (e.g., 4 kB) 
> segments does not allow large enough data size. One solution has been to 
> have a kernel space buffer that consists of segments spanning several 
> pages. As far as I know, the current bio code requires page size segments. 
> It is possible to use chained bios with multimegabyte buffers but the 
> user should be sure that the split segments will be merged before the 
> request reaches the HBA so that the request fits the HBA sg segment limit.

Well, this isn't actually necessarily the problem.  *Provided* the
underlying driver enables clustering, the block layer will merge
physically contiguous pages in a single bio (so a large buffer will come
out the other side of blk_rq_map_sg as a single scatter/gather entry)

James
