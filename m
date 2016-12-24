From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [4.10, panic, regression] iscsi: null pointer deref at
	iscsi_tcp_segment_done+0x20d/0x2e0
Date: Sat, 24 Dec 2016 10:49:05 +0100
Message-ID: <20161224094905.GA16518@lst.de>
References: <20161222001303.nvrtm22szn3hgxar@straylight.hirudinean.org> <20161222051322.GF4758@dastard> <CA+55aFza=cv6TGYh+Be1xz2x-G-U=vruhbmfGpHSqY1ocZrBeg@mail.gmail.com> <20161222065012.GI4758@dastard> <20161222185030.so4btkuzzkih3owz@straylight.hirudinean.org> <CACVXFVOGoh+AEGSSMsbxfdAjZQS5k_t+7uR-+qwusm0vfauHEA@mail.gmail.com> <20161223000356.dxwkgsei32w7hc4f@straylight.hirudinean.org> <20161223100014.GA29467@lst.de> <CA+55aFxA1LE+4jdR8YXZyRVJ-MpOCUVob=ESBsMPuW=Qb=px-A@mail.gmail.com> <fadbf3d2-23c1-f822-cf0f-50182227a2dc@fb.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBDUNBGN3R4KRBEUJ7HBAKGQEZ63XILY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <fadbf3d2-23c1-f822-cf0f-50182227a2dc-b10kYP2dOMg@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Linux SCSI List <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 23, 2016 at 07:45:45PM -0700, Jens Axboe wrote:
> It's not that it's technically hard to fix up, it's more that it's a
> pain in the ass to have to do it. For instance, for blk_execute_rq(), we
> either should enforce that the caller allocates it dynamically and then
> free it, or we need nasty hack where the caller needs to know he has to
> free it. Pretty obvious what I would prefer there.
> 
> And yes, there would be a good chunk of other places where this would
> nede to be fixed up...

My planned rework for the BLOCK_PC code (split all fields for them out
of struct request and move them into a separate, driver-allocate structure)
would fix this up as a side-effect.  I really wanted to get it into 4.10,
but I didn't manage to fix it up.  I'll try to get it into 4.11 early.

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
