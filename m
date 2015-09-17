From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: DEFINE_IDA causing memory leaks? (was  Re: [PATCH 1/2] virtio:
 fix memory leak of virtio ida cache layers)
Date: Thu, 17 Sep 2015 07:15:44 -0700
Message-ID: <1442499344.4073.0.camel@HansenPartnership.com>
References: <1442449758-14594-1-git-send-email-s-anna@ti.com>
	 <1442449758-14594-2-git-send-email-s-anna@ti.com>
	 <20150917082425-mutt-send-email-mst@redhat.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBDMOV25X7AMRBE4W5OXQKGQEV276QRY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <20150917082425-mutt-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Suman Anna <s-anna-l0cyMroinI0@public.gmane.org>, Ohad Ben-Cohen <ohad-Ix1uc/W3ht7QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-09-17 at 08:33 +0300, Michael S. Tsirkin wrote:
> On Wed, Sep 16, 2015 at 07:29:17PM -0500, Suman Anna wrote:
> > The virtio core uses a static ida named virtio_index_ida for
> > assigning index numbers to virtio devices during registration.
> > The ida core may allocate some internal idr cache layers and
> > an ida bitmap upon any ida allocation, and all these layers are
> > truely freed only upon the ida destruction. The virtio_index_ida
> > is not destroyed at present, leading to a memory leak when using
> > the virtio core as a module and atleast one virtio device is
> > registered and unregistered.
> > 
> > Fix this by invoking ida_destroy() in the virtio core module
> > exit.
> > 
> > Cc: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Suman Anna <s-anna-l0cyMroinI0@public.gmane.org>
> 
> Interesting.
> Will the same apply to e.g. sd_index_ida in drivers/scsi/sd.c
> or iscsi_sess_ida in drivers/scsi/scsi_transport_iscsi.c?
> 
> If no, why not?
> 
> One doesn't generally expect to have to free global variables.
> Maybe we should forbid DEFINE_IDA in modules?
> 
> James, could you comment on this please?

ida is Tejun's baby (cc'd).  However, it does look like without
ida_destroy() you will leave a cached ida->bitmap dangling because we're
trying to be a bit clever in ida_remove() so we cache the bitmap to
relieve ida_pre_get() of the burden if we would otherwise free it.

I don't understand why you'd want to forbid DEFINE_IDA ... all it does
is pre-initialise a usually static ida structure.  The initialised
structure will have a NULL bitmap cache that's allocated in the first
ida_pre_get() ... that all seems to work as expected and no different
from a dynamically allocated struct ida.  Or are you thinking because
ida_destory() doesn't set bitmap to NULL, it damages the reuse?  In
which case I'm not sure there's much benefit to making it reusable, but
I suppose we could by adding a memset into ida_destroy().

James

> > ---
> >  drivers/virtio/virtio.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> > index b1877d73fa56..7062bb0975a5 100644
> > --- a/drivers/virtio/virtio.c
> > +++ b/drivers/virtio/virtio.c
> > @@ -412,6 +412,7 @@ static int virtio_init(void)
> >  static void __exit virtio_exit(void)
> >  {
> >  	bus_unregister(&virtio_bus);
> > +	ida_destroy(&virtio_index_ida);
> >  }
> >  core_initcall(virtio_init);
> >  module_exit(virtio_exit);
> > -- 
> > 2.5.0
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 




-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
