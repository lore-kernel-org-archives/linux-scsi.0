From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: DEFINE_IDA causing memory leaks? (was  Re: [PATCH 1/2] virtio:
	fix memory leak of virtio ida cache layers)
Date: Thu, 17 Sep 2015 19:06:34 +0300
Message-ID: <20150917190538-mutt-send-email-mst@redhat.com>
References: <1442449758-14594-1-git-send-email-s-anna@ti.com>
	<1442449758-14594-2-git-send-email-s-anna@ti.com>
	<20150917082425-mutt-send-email-mst@redhat.com>
	<1442499344.4073.0.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1442499344.4073.0.camel@HansenPartnership.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Suman Anna <s-anna@ti.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, Tejun Heo <htejun@gmail.com>, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 17, 2015 at 07:15:44AM -0700, James Bottomley wrote:
> On Thu, 2015-09-17 at 08:33 +0300, Michael S. Tsirkin wrote:
> > On Wed, Sep 16, 2015 at 07:29:17PM -0500, Suman Anna wrote:
> > > The virtio core uses a static ida named virtio_index_ida for
> > > assigning index numbers to virtio devices during registration.
> > > The ida core may allocate some internal idr cache layers and
> > > an ida bitmap upon any ida allocation, and all these layers are
> > > truely freed only upon the ida destruction. The virtio_index_ida
> > > is not destroyed at present, leading to a memory leak when using
> > > the virtio core as a module and atleast one virtio device is
> > > registered and unregistered.
> > > 
> > > Fix this by invoking ida_destroy() in the virtio core module
> > > exit.
> > > 
> > > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > > Signed-off-by: Suman Anna <s-anna@ti.com>
> > 
> > Interesting.
> > Will the same apply to e.g. sd_index_ida in drivers/scsi/sd.c
> > or iscsi_sess_ida in drivers/scsi/scsi_transport_iscsi.c?
> > 
> > If no, why not?
> > 
> > One doesn't generally expect to have to free global variables.
> > Maybe we should forbid DEFINE_IDA in modules?
> > 
> > James, could you comment on this please?
> 
> ida is Tejun's baby (cc'd).  However, it does look like without
> ida_destroy() you will leave a cached ida->bitmap dangling because we're
> trying to be a bit clever in ida_remove() so we cache the bitmap to
> relieve ida_pre_get() of the burden if we would otherwise free it.
> 
> I don't understand why you'd want to forbid DEFINE_IDA ... all it does
> is pre-initialise a usually static ida structure.  The initialised
> structure will have a NULL bitmap cache that's allocated in the first
> ida_pre_get() ... that all seems to work as expected and no different
> from a dynamically allocated struct ida.  Or are you thinking because
> ida_destory() doesn't set bitmap to NULL, it damages the reuse?  In
> which case I'm not sure there's much benefit to making it reusable, but
> I suppose we could by adding a memset into ida_destroy().
> 
> James

It's just unusual to have  a descructor without a constructor.
I bet more drivers misuse this AI because of this.

> > > ---
> > >  drivers/virtio/virtio.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> > > index b1877d73fa56..7062bb0975a5 100644
> > > --- a/drivers/virtio/virtio.c
> > > +++ b/drivers/virtio/virtio.c
> > > @@ -412,6 +412,7 @@ static int virtio_init(void)
> > >  static void __exit virtio_exit(void)
> > >  {
> > >  	bus_unregister(&virtio_bus);
> > > +	ida_destroy(&virtio_index_ida);
> > >  }
> > >  core_initcall(virtio_init);
> > >  module_exit(virtio_exit);
> > > -- 
> > > 2.5.0
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 
> 
