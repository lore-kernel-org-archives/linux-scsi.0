From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 11/12] xen-scsiback: Convert to percpu_ida tag
 allocation
Date: Tue, 26 Jan 2016 22:28:10 -0800
Message-ID: <1453876090.6746.123.camel@haakon3.risingtidesystems.com>
References: <1453709466-6308-1-git-send-email-nab@daterainc.com>
	 <1453709466-6308-12-git-send-email-nab@daterainc.com>
	 <56A7401E.7070005@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <56A7401E.7070005@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: Juergen Gross <jgross@suse.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, David Vrabel <david.vrabel@citrix.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-01-26 at 10:45 +0100, Juergen Gross wrote:
> On 25/01/16 09:11, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Cc: Juergen Gross <jgross@suse.com>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: David Vrabel <david.vrabel@citrix.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/xen/xen-scsiback.c | 163 ++++++++++++++++++++++++---------------------
> >  1 file changed, 87 insertions(+), 76 deletions(-)
> > 
> > diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
> > index 594f8a7..640fb22 100644
> > --- a/drivers/xen/xen-scsiback.c
> > +++ b/drivers/xen/xen-scsiback.c
> > @@ -190,7 +190,6 @@ module_param_named(max_buffer_pages, scsiback_max_buffer_pages, int, 0644);
> >  MODULE_PARM_DESC(max_buffer_pages,
> >  "Maximum number of free pages to keep in backend buffer");
> >  
> > -static struct kmem_cache *scsiback_cachep;
> >  static DEFINE_SPINLOCK(free_pages_lock);
> >  static int free_pages_num;
> >  static LIST_HEAD(scsiback_free_pages);
> > @@ -322,7 +321,8 @@ static void scsiback_free_translation_entry(struct kref *kref)
> >  }
> >  
> >  static void scsiback_do_resp_with_sense(char *sense_buffer, int32_t result,
> > -			uint32_t resid, struct vscsibk_pend *pending_req)
> > +			uint32_t resid, struct vscsibk_pend *pending_req,
> > +			uint16_t rqid)
> >  {
> >  	struct vscsiif_response *ring_res;
> >  	struct vscsibk_info *info = pending_req->info;
> 
> pending_req might be NULL now, so this will panic the system.
> 

Thanks for the review.

Added the following to propagate up original *info into
scsiback_do_resp_with_sense() to address the early pending_req
failure case.

https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commit/?h=queue-next&id=5873f22a9b7c7aa16ff9a85074a07b739f1d06a5

Will plan to fold into the original for -v3 code.

Thanks Juergen!
