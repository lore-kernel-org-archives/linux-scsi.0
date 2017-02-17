From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: hch's native NVMe multipathing [was: Re: [PATCH 1/2]
 Don't blacklist nvme]
Date: Fri, 17 Feb 2017 09:43:47 -0500
Message-ID: <20170217144347.GC19043@redhat.com>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
	<20170215145617.GA4241@infradead.org>
	<20170216025357.GA9241@redhat.com>
	<20170216142621.GA21972@infradead.org>
	<20170216151337.GA12678@redhat.com>
	<20170216173856.GB17828@localhost.localdomain>
	<1487266648.2612.3.camel@sandisk.com>
	<20170216180742.GC17828@localhost.localdomain>
	<20170216182129.GC12678@redhat.com>
	<20170217090420.GA29629@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170217090420.GA29629@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "hch@infradead.org" <hch@infradead.org>
Cc: Keith Busch <keith.busch@intel.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 17 2017 at  4:04am -0500,
hch@infradead.org <hch@infradead.org> wrote:

> On Thu, Feb 16, 2017 at 01:21:29PM -0500, Mike Snitzer wrote:
> > multipath-tools has tables that specify all the defaults for a given
> > target backend.  NVMe will just be yet another.
> 
> No, if we get things right it won't.  ALUA already got rid of most
> of the parameter people would have to set under normal conditions,
> and I plan to make sure the NVMe equivalent will do it for all
> parameters.  I am active in the NVMe working group and will do my
> best to get there.  There's a few others folks here that are more or
> less active there as well (Keith, Martin, Jens for example), so I
> think we have a chance.
> 
> That beeing said Keith is right that we'll always have odd setups
> where we need to overrid things, and we will have to provide tunables
> for that.  It's no different from any other kernel subsystem in that.

Before ALUA fixed all that vendor specific fragmentation there was the
even worse fragmentation where different vendors pushed multipathing
into their FC drivers.  James correctly pushed them toward a generic
solution (and DM multipath was born).  If every transport implements its
own multipathing then it'll be a more generic, yet very similar,
fragmentation problem.

But if your native NVMe multipathing really is factored such that the
actual IO fast path is implemented in block core, and transport specific
hooks are called out to as needed, then you've simply reimplement DM
multipath in block core.

Pretty weird place to invest _so_ much energy before you've fully
explored how unworkable DM multipath support for NVMe is.  But I
digress.
