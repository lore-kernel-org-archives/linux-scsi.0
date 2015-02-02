From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH-v2 01/11] lib/iovec: Add memcpy_fromiovec_out library
 function
Date: Mon, 2 Feb 2015 04:47:26 +0000
Message-ID: <20150202044725.GT29656@ZenIV.linux.org.uk>
References: <1422849994-3419-1-git-send-email-nab@daterainc.com>
 <1422849994-3419-2-git-send-email-nab@daterainc.com>
 <20150202044412.GS29656@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150202044412.GS29656@ZenIV.linux.org.uk>
Sender: kvm-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 02, 2015 at 04:44:12AM +0000, Al Viro wrote:
> On Mon, Feb 02, 2015 at 04:06:24AM +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch adds a new memcpy_fromiovec_out() library function which modifies
> > the passed *iov following memcpy_fromiovec(), but also returns the next current
> > iovec pointer via **iov_out.
> > 
> > This is useful for vhost ANY_LAYOUT support when guests are allowed to generate
> > incoming virtio request headers combined with subsequent SGL payloads into a
> > single iovec.
> 
> Please, don't.  Just use copy_from_iter(); you are open-coding an uglier
> variant of such.

PS: see vfs.git#for-davem (or postings on netdev with the same stuff).
I really hope to bury memcpy_...iovec...() crap for good; please, don't
reintroduce more of it.
