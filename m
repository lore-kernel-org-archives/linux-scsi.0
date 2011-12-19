From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: copy offload support in Linux - new system call needed?
Date: Mon, 19 Dec 2011 15:29:50 -0800
Message-ID: <4EEFC8EE.70001@zytor.com>
References: <4EE8F75F.6070800@gmail.com> <20111214195931.GC10664@samba2> <4EEFB87F.9000104@zytor.com> <20111219225722.GS23662@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111219225722.GS23662@dastard>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ric Wheeler <ricwheeler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 12/19/2011 02:57 PM, Dave Chinner wrote:
> 
> That was my immediate thought, but sendfile has plumbing that is
> page cache based and we require completely different infrastructure
> and semantics for an array offload.
> 

The plumbing is internal to the kernel and doesn't mean we have to use
the same VFS methods.

> e.g. for an array offload, we have to flush the source file page
> cache first so that the data being copied is known to be on disk,
> then invalidate the destination page cache if overwriting or extend
> and pre-allocate blocks if not. Then we have to map both files and
> hand that off to the array.
> 
> Then there's a whole bunch of tricky questions about what the state
> of the destination file should look like while the copy is in
> progress, whether the source file should be allowed to change (e.g.
> it can't be truncated and have blocks freed and then reused by other
> files half way through the copy offload operation), and so on.
> 
> sendfile() has well known, fixed semantics that we can't change to
> suit what is needed for an offload operation that could potentially
> take hours to complete. Hence I think an new syscall is the way to
> go....

Perhaps what we need first in an explicit enumeration of the semantics
you're looking for.

	-hpa

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
