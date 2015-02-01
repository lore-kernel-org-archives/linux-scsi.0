From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/8] lib/iovec: Add memcpy_fromiovec_out library function
Date: Sat, 31 Jan 2015 23:15:11 -0800
Message-ID: <1422774911.30468.5.camel@haakon3.risingtidesystems.com>
References: <1422605552-24797-1-git-send-email-nab@daterainc.com>
	 <1422605552-24797-2-git-send-email-nab@daterainc.com>
	 <54CB4FEC.7080908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <54CB4FEC.7080908@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-01-30 at 10:33 +0100, Paolo Bonzini wrote:
> 
> On 30/01/2015 09:12, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch adds a new memcpy_fromiovec_out() library function which modifies
> > the passed *iov following memcpy_fromiovec(), but also returns the next current
> > iovec pointer via **iov_out.
> > 
> > This is useful for vhost ANY_LAYOUT support when guests are allowed to generate
> > incoming virtio request headers combined with subsequent SGL payloads into a
> > single iovec.
> > 
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >  include/linux/uio.h |  2 ++
> >  lib/iovec.c         | 27 +++++++++++++++++++++++++++
> >  2 files changed, 29 insertions(+)
> > 

<SNIP>

> > --- a/lib/iovec.c
> > +++ b/lib/iovec.c
> > @@ -28,6 +28,33 @@ int memcpy_fromiovec(unsigned char *kdata, struct iovec *iov, int len)
> >  EXPORT_SYMBOL(memcpy_fromiovec);
> >  
> >  /*
> > + *	Copy iovec to kernel, saving the current iov to *iov_out.
> > + *	Returns -EFAULT on error.
> 
> Perhaps document that iov is modified, zeroing everything in [iov,
> *iov_out) and possibly removing the front of *iov_out?
> 

Sure, updated the read the following:

 *      Copy iovec to kernel, modifying the passed *iov entries.
 *
 *      Save **iov_out for the caller to use upon return, that may either
 *      contain the current entry with a re-calculated iov_base + iov_len
 *      or next unmodified entry.
 *
 *      Also note that any iovec entries preceding the final *iov_out are
 *      zeroed by copy_from_user().

Thank you,

--nab
