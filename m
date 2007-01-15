From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] ieee1394: sbp2: lower block queue alignment requirement
Date: Mon, 15 Jan 2007 15:24:59 -0600
Message-ID: <1168896299.7708.15.camel@mulgrave.il.steeleye.com>
References: <tkrat.37326df2d568d12d@s5r6.in-berlin.de>
	<1168802387.2780.1.camel@mulgrave.il.steeleye.com>
	<tkrat.cad61efa52eb6e56@s5r6.in-berlin.de>
	<59ad55d30701151139w6176e785g53404d7b3a42ce6e@mail.gmail.com>
	<tkrat.8dad811bf4dbb360@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.8dad811bf4dbb360@s5r6.in-berlin.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@bitplanet.net>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2007-01-15 at 21:02 +0100, Stefan Richter wrote:
> > By the way, is there a way to ask the SCSI stack to limit the size of
> > the entries in the scatterlist to 64k?  This would greatly simplify
> > the conversion to SBP-2 page tables, since this is the maximum size
> > these can hold.
> 
> Douglas has a very informative text on this:
> http://sg.torque.net/sg/sg_io.html#mozTocId154063
> 
> | [...] since lk 2.6.16 another limit comes into play: the
> | MAX_SEGMENT_SIZE define which is set to 64 KB. MAX_SEGMENT_SIZE is a
> | default and can be overridden by the LLD calling
> | blk_queue_max_segment_size().
> 
> Looks like we can yank out some cruft off sbp2.

Actually, there's one unfortunate case where Linux won't respect this:
an IOMMU that can do virtual merging.  This parameter is a block queue
parameter, so block will happily make sure the request segments obey it.
However, when you get to dma_map_rq() it doesn't see the segment limits,
so, if the iommu merges, you can end up with SG elements the other side
that violate this.  I've been meaning to do something about this for
ages (IDE is the other subsystem that has an absolute requirement for a
fixed maximum segment size) but never found an excuse to fix it.

James



-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
