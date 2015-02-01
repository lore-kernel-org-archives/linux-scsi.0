From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 4/8] vhost/scsi: Change vhost_scsi_map_to_sgl to accept
 iov ptr + len
Date: Sat, 31 Jan 2015 23:24:32 -0800
Message-ID: <1422775472.30468.13.camel@haakon3.risingtidesystems.com>
References: <1422605552-24797-1-git-send-email-nab@daterainc.com>
	 <1422605552-24797-5-git-send-email-nab@daterainc.com>
	 <20150130105119.GA21531@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150130105119.GA21531@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-01-30 at 12:51 +0200, Michael S. Tsirkin wrote:
> On Fri, Jan 30, 2015 at 08:12:28AM +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch changes vhost_scsi_map_to_sgl() parameters to accept virtio
> > iovec ptr + len when determing pages_nr.
> > 
> > This is currently done with iov_num_pages() -> PAGE_ALIGN, so allow
> > the same parameters as well.
> > 
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/vhost/scsi.c | 37 +++++++++++++++----------------------
> >  1 file changed, 15 insertions(+), 22 deletions(-)
> > 
> > diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> > index 9c5ac23..049e603 100644
> > --- a/drivers/vhost/scsi.c
> > +++ b/drivers/vhost/scsi.c
> > @@ -220,10 +220,10 @@ static struct workqueue_struct *tcm_vhost_workqueue;
> >  static DEFINE_MUTEX(tcm_vhost_mutex);
> >  static LIST_HEAD(tcm_vhost_list);
> >  
> > -static int iov_num_pages(struct iovec *iov)
> > +static int iov_num_pages(void __user *iov_base, size_t iov_len)
> >  {
> > -	return (PAGE_ALIGN((unsigned long)iov->iov_base + iov->iov_len) -
> > -	       ((unsigned long)iov->iov_base & PAGE_MASK)) >> PAGE_SHIFT;
> > +	return (PAGE_ALIGN((unsigned long)iov_base + iov_len) -
> > +	       ((unsigned long)iov_base & PAGE_MASK)) >> PAGE_SHIFT;
> >  }
> >  
> >  static void tcm_vhost_done_inflight(struct kref *kref)
> > @@ -777,25 +777,18 @@ vhost_scsi_get_tag(struct vhost_virtqueue *vq, struct tcm_vhost_tpg *tpg,
> >   * Returns the number of scatterlist entries used or -errno on error.
> >   */
> >  static int
> > -vhost_scsi_map_to_sgl(struct tcm_vhost_cmd *tv_cmd,
> > +vhost_scsi_map_to_sgl(struct tcm_vhost_cmd *cmd,
> > +		      void __user *ptr,
> > +		      size_t len,
> >  		      struct scatterlist *sgl,
> > -		      unsigned int sgl_count,
> > -		      struct iovec *iov,
> > -		      struct page **pages,
> >  		      bool write)
> >  {
> > -	unsigned int npages = 0, pages_nr, offset, nbytes;
> > +	unsigned int npages = 0, offset, nbytes;
> > +	unsigned int pages_nr = iov_num_pages(ptr, len);
> >  	struct scatterlist *sg = sgl;
> > -	void __user *ptr = iov->iov_base;
> > -	size_t len = iov->iov_len;
> > +	struct page **pages = cmd->tvc_upages;
> >  	int ret, i;
> >  
> > -	pages_nr = iov_num_pages(iov);
> > -	if (pages_nr > sgl_count) {
> > -		pr_err("vhost_scsi_map_to_sgl() pages_nr: %u greater than"
> > -		       " sgl_count: %u\n", pages_nr, sgl_count);
> > -		return -ENOBUFS;
> > -	}
> >  	if (pages_nr > TCM_VHOST_PREALLOC_UPAGES) {
> >  		pr_err("vhost_scsi_map_to_sgl() pages_nr: %u greater than"
> >  		       " preallocated TCM_VHOST_PREALLOC_UPAGES: %u\n",
> > @@ -840,7 +833,7 @@ vhost_scsi_map_iov_to_sgl(struct tcm_vhost_cmd *cmd,
> >  	int ret, i;
> >  
> >  	for (i = 0; i < niov; i++)
> > -		sgl_count += iov_num_pages(&iov[i]);
> > +		sgl_count += iov_num_pages(iov[i].iov_base, iov[i].iov_len);
> >  
> 
> A helper function for this loop seems in order as well?
> 

I didn't bother with this, as it's only used by the legacy !ANY_LAYOUT
related code-path.

Also, I don't see a reason at this point to keep the !ANY_LAYOUT bits
around for >= v3.20 code, so for -v2 I'll just drop the legacy code
(including the above) all together.

Thank you,

--nab
