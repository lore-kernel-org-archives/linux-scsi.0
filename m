From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V2 08/15] staging: unisys: visorhba: use sg helper to
 operate sgl
Date: Thu, 13 Jun 2019 08:46:08 -0700
Message-ID: <1560440768.3329.30.camel@HansenPartnership.com>
References: <20190613071335.5679-1-ming.lei@redhat.com>
 <20190613071335.5679-9-ming.lei@redhat.com>
 <20190613095214.GA18796@kroah.com> <20190613100410.GA10829@ming.t460p>
 <20190613101656.GA28256@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20190613101656.GA28256@kroah.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ming Lei <ming.lei@redhat.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, devel@driverdev.osuosl.org, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, "Martin K .
 Petersen" <martin.petersen@oracle.com>, James Smart <james.smart@broadcom.com>, "Ewan D . Milne" <emilne@redhat.com>, Jim Gill <jgill@vmware.com>, Brian King <brking@us.ibm.com>, Finn Thain <fthain@telegraphics.com.au>, "Juergen E . Fischer" <fischer@norbit.de>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2019-06-13 at 12:16 +0200, Greg Kroah-Hartman wrote:
> On Thu, Jun 13, 2019 at 06:04:11PM +0800, Ming Lei wrote:
> > On Thu, Jun 13, 2019 at 11:52:14AM +0200, Greg Kroah-Hartman wrote:
> > > On Thu, Jun 13, 2019 at 03:13:28PM +0800, Ming Lei wrote:
> > > > The current way isn't safe for chained sgl, so use sg helper to
> > > > operate sgl.
> > > 
> > > I can not make any sense out of this changelog.
> > > 
> > > What "isn't safe"?  What is a "sgl"?
> > 
> > sgl is 'scatterlist' in kernel, and several linear sgl can be
> > chained together, so accessing the sgl in linear way may see a
> > chained sg, which is like a link pointer, then may cause trouble
> > for driver.
> 
> What kind of "trouble"?  Is this a bug fix that needs to be
> backported to stable kernels?  How can this be triggered?

OK, stop.  I haven't seen the commit log since the original hasn't
appeared on the list yet, but the changelog needs to say something like
this to prevent questions like the above, as I asked in the last
review.  Please make it something like this:

---
Scsi MQ makes a large static allocation for the first scatter gather
list chunk for the driver to use.  This is a performance headache we'd
like to fix by reducing the size of the allocation to a 2 element
array.  Doing this will break the current guarantee that any driver
using SG_ALL doesn't need to use the scatterlist iterators and can get
away with directly dereferencing the array.  Thus we need to update all
drivers to use the scatterlist iterators and remove direct indexing of
the scatterlist array before reducing the initial scatterlist
allocation size in SCSI.
---

James
