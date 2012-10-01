From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: [PATCH] [SCSI] virtio-scsi: Initialize scatterlist structure.
Date: Mon, 1 Oct 2012 14:18:59 +0100
Message-ID: <20121001131859.GC24071@rhmail.home.annexia.org>
References: <1345471490-17289-1-git-send-email-rjones@redhat.com>
 <50324439.1000307@redhat.com>
 <506996DD.30300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <506996DD.30300@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 01, 2012 at 03:13:01PM +0200, Paolo Bonzini wrote:
> Il 20/08/2012 16:05, Paolo Bonzini ha scritto:
> > Il 20/08/2012 16:04, Richard W.M. Jones ha scritto:
> >> From: "Richard W.M. Jones" <rjones@redhat.com>
> >>
> >> The sg struct is used without being initialized.
> >>
> >> https://bugzilla.redhat.com/show_bug.cgi?id=847548
> >>
> >> Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
> >> ---
> >>  drivers/scsi/virtio_scsi.c |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> >> index c7030fb..8a66f83 100644
> >> --- a/drivers/scsi/virtio_scsi.c
> >> +++ b/drivers/scsi/virtio_scsi.c
> >> @@ -219,7 +219,7 @@ static int virtscsi_kick_event(struct virtio_scsi *vscsi,
> >>  	struct scatterlist sg;
> >>  	unsigned long flags;
> >>  
> >> -	sg_set_buf(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
> >> +	sg_init_one(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
> >>  
> >>  	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
> >>  
> >>
> > 
> > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > 
> > Paolo
> > 
> 
> Ping, is this patch going into 3.7?

I was a bit surprised to see this wasn't upstream since it's vital for
using virtio-scsi reliably (as well as being a one line fix for a
blatant bug).

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming blog: http://rwmj.wordpress.com
Fedora now supports 80 OCaml packages (the OPEN alternative to F#)
http://cocan.org/getting_started_with_ocaml_on_red_hat_and_fedora
