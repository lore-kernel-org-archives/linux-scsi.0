From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: DEFINE_IDA causing memory leaks? (was  Re: [PATCH 1/2] virtio:
 fix memory leak of virtio ida cache layers)
Date: Thu, 17 Sep 2015 10:58:29 -0700
Message-ID: <1442512709.4073.24.camel@HansenPartnership.com>
References: <1442449758-14594-1-git-send-email-s-anna@ti.com>
	 <1442449758-14594-2-git-send-email-s-anna@ti.com>
	 <20150917082425-mutt-send-email-mst@redhat.com>
	 <1442499344.4073.0.camel@HansenPartnership.com>
	 <20150917190538-mutt-send-email-mst@redhat.com>
	 <1442508517.4073.13.camel@HansenPartnership.com>
	 <20150917171529.GA15447@htj.duckdns.org>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBDMOV25X7AMRBSH65OXQKGQE464HEAI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <20150917171529.GA15447-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Suman Anna <s-anna-l0cyMroinI0@public.gmane.org>, Ohad Ben-Cohen <ohad-Ix1uc/W3ht7QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-09-17 at 13:15 -0400, Tejun Heo wrote:
> Hello,
> 
> On Thu, Sep 17, 2015 at 09:48:37AM -0700, James Bottomley wrote:
> > Well, there's an easy fix for that.  We could have ida_remove() actually
> > free the bitmap and not cache it if it's the last layer.  That way ida
> > would naturally empty and we wouldn't need a destructor.   Tejun, would
> > that work?
> 
> Yeah, that definitely is one way to go about it.  It kinda muddles the
> purpose of ida_destroy() tho.  I suppose we can rename it to
> idr_remove_all() and then do the same to idr.  I'm not particularly
> objecting to all that but what's wrong with just calling idr_destroy()
> on exit paths?  If missing the call in modules is an issue, maybe we
> can just annotate idr/ida with debugobj?

The argument is that we shouldn't have to explicitly destroy a
statically initialized object, so 

DEFINE_IDA(someida);

Should just work without having to explicitly do

ida_destory(someida);

somewhere in the exit code.  It's about usage patterns.  Michael's
argument is that if we can't follow the no destructor pattern for
DEFINE_IDA() then we shouldn't have it at all, because it's confusing
kernel design patterns.  The pattern we would have would be

struct ida someida:

ida_init(&someida);

...

ida_destroy(&someida);

so the object explicitly has a constructor matched to a destructor.

James


-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
