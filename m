From: Tejun Heo <htejun@gmail.com>
Subject: Re: DEFINE_IDA causing memory leaks? (was  Re: [PATCH 1/2] virtio:
 fix memory leak of virtio ida cache layers)
Date: Thu, 17 Sep 2015 13:15:29 -0400
Message-ID: <20150917171529.GA15447@htj.duckdns.org>
References: <1442449758-14594-1-git-send-email-s-anna@ti.com>
 <1442449758-14594-2-git-send-email-s-anna@ti.com>
 <20150917082425-mutt-send-email-mst@redhat.com>
 <1442499344.4073.0.camel@HansenPartnership.com>
 <20150917190538-mutt-send-email-mst@redhat.com>
 <1442508517.4073.13.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442508517.4073.13.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Suman Anna <s-anna@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

Hello,

On Thu, Sep 17, 2015 at 09:48:37AM -0700, James Bottomley wrote:
> Well, there's an easy fix for that.  We could have ida_remove() actually
> free the bitmap and not cache it if it's the last layer.  That way ida
> would naturally empty and we wouldn't need a destructor.   Tejun, would
> that work?

Yeah, that definitely is one way to go about it.  It kinda muddles the
purpose of ida_destroy() tho.  I suppose we can rename it to
idr_remove_all() and then do the same to idr.  I'm not particularly
objecting to all that but what's wrong with just calling idr_destroy()
on exit paths?  If missing the call in modules is an issue, maybe we
can just annotate idr/ida with debugobj?

Thanks.

-- 
tejun
