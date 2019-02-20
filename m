From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [RESEND PATCH 0/7] Add FOLL_LONGTERM to GUP fast and use it
Date: Wed, 20 Feb 2019 10:02:56 -0800
Message-ID: <20190220180255.GA12020@iweiny-DESK2.sc.intel.com>
References: <20190220053040.10831-1-ira.weiny@intel.com>
 <20190220151930.GB11695@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20190220151930.GB11695@infradead.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fbdev@vger.kernel.org, Michal Hocko <mhocko@suse.com>, kvm@vger.kernel.org, linux-sh@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, James Hogan <jhogan@kernel.org>, linux-fpga@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>, dri-devel@lists.freedesktop.org, linux-mips@vger.kernel.org, linux-mm@kvack.org, Rich Felker <dalias@libc.org>, Paul Mackerras <paulus@samba.org>, sparclinux@vger.kernel.org, ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org, linux-s390@vger.kernel.org, rds-devel@oss.oracle.com, Yoshinori Sato <ysato@users.sourceforge.jp>, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, Ingo Molnar <mingo@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, xen-devel@lists.xenproject.org, devel@lists.orangefs.org, linux-media@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, kvm-ppc@vger.kernel.org, Borislav
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 20, 2019 at 07:19:30AM -0800, Christoph Hellwig wrote:
> On Tue, Feb 19, 2019 at 09:30:33PM -0800, ira.weiny@intel.com wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> > 
> > Resending these as I had only 1 minor comment which I believe we have covered
> > in this series.  I was anticipating these going through the mm tree as they
> > depend on a cleanup patch there and the IB changes are very minor.  But they
> > could just as well go through the IB tree.
> > 
> > NOTE: This series depends on my clean up patch to remove the write parameter
> > from gup_fast_permitted()[1]
> > 
> > HFI1, qib, and mthca, use get_user_pages_fast() due to it performance
> > advantages.  These pages can be held for a significant time.  But
> > get_user_pages_fast() does not protect against mapping of FS DAX pages.
> 
> This I don't get - if you do lock down long term mappings performance
> of the actual get_user_pages call shouldn't matter to start with.
> 
> What do I miss?

A couple of points.

First "longterm" is a relative thing and at this point is probably a misnomer.
This is really flagging a pin which is going to be given to hardware and can't
move.  I've thought of a couple of alternative names but I think we have to
settle on if we are going to use FL_LAYOUT or something else to solve the
"longterm" problem.  Then I think we can change the flag to a better name.

Second, It depends on how often you are registering memory.  I have spoken with
some RDMA users who consider MR in the performance path...  For the overall
application performance.  I don't have the numbers as the tests for HFI1 were
done a long time ago.  But there was a significant advantage.  Some of which is
probably due to the fact that you don't have to hold mmap_sem.

Finally, architecturally I think it would be good for everyone to use *_fast.
There are patches submitted to the RDMA list which would allow the use of
*_fast (they reworking the use of mmap_sem) and as soon as they are accepted
I'll submit a patch to convert the RDMA core as well.  Also to this point
others are looking to use *_fast.[2]

As an asside, Jasons pointed out in my previous submission that *_fast and
*_unlocked look very much the same.  I agree and I think further cleanup will
be coming.  But I'm focused on getting the final solution for DAX at the
moment.

Ira
