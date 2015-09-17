From: Tejun Heo <htejun@gmail.com>
Subject: Re: DEFINE_IDA causing memory leaks? (was  Re: [PATCH 1/2] virtio:
 fix memory leak of virtio ida cache layers)
Date: Thu, 17 Sep 2015 11:10:26 -0400
Message-ID: <20150917151026.GB7205@mtj.duckdns.org>
References: <1442449758-14594-1-git-send-email-s-anna@ti.com>
 <1442449758-14594-2-git-send-email-s-anna@ti.com>
 <20150917082425-mutt-send-email-mst@redhat.com>
 <1442499344.4073.0.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442499344.4073.0.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Suman Anna <s-anna@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

Hello,

On Thu, Sep 17, 2015 at 07:15:44AM -0700, James Bottomley wrote:
> I don't understand why you'd want to forbid DEFINE_IDA ... all it does

I guess to require the use of explicit init / creation so that it's
clear the data structure needs to be destroyed?

> is pre-initialise a usually static ida structure.  The initialised
> structure will have a NULL bitmap cache that's allocated in the first
> ida_pre_get() ... that all seems to work as expected and no different
> from a dynamically allocated struct ida.  Or are you thinking because
> ida_destory() doesn't set bitmap to NULL, it damages the reuse?  In
> which case I'm not sure there's much benefit to making it reusable, but
> I suppose we could by adding a memset into ida_destroy().

I don't know.  Data structures which do lazy anything would likely
need explicit destruction and I'm not sure we'd wanna ban static
initialization for all such cases.  Seems like an unnecessary
restriction.

Thanks.

-- 
tejun
