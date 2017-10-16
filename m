From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] linux/types.h: Restore the ability to disable sparse
 endianness checks
Date: Mon, 16 Oct 2017 22:57:13 +0300
Message-ID: <20171016224241-mutt-send-email-mst@kernel.org>
References: <20171016172633.29290-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171016172633.29290-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 16, 2017 at 10:26:33AM -0700, Bart Van Assche wrote:
> The purpose of patch "linux/types.h: enable endian checks for all
> sparse builds" was to encourage driver authors to annotate
> endianness correctly in their drivers. However, since that patch
> went upstream no endianness annotations in drivers have been fixed.

I doubt that's true. What's the basis for this claim?

> I think that this shows that the followed approach does not work,
> probably because several driver authors do not use sparse. For
> developers who are not the authors of these drivers it would take
> a very significant effort to make these drivers endianness clean.

I'm afraid I still don't see it.  For developers endian-ness is really
easy.  Look at hardware spec make sure code matches.  You can often do
without looking at the spec too, if a given field is always used with
cpu_to_le, mark it __le.  If you don't want to change driver code, you
don't really need to run sparse on it.

> Examples are drivers/scsi/qla2xxx and drivers/infiniband/hw/nes.

These seem to be actively maintained. So post a patch, maintainers
can look at the spec to help make sure annotations are right.

> Hence restore the ability to disable sparse endianness checks such
> that it becomes again easy to review other sparse diagnostics for
> people who want to analyze drivers they are not the author of.

What are these diagnostics that are important to analyze for people
unable to make even trivial driver changes? White-listing these
as opposed to black-listing endian-ness might be a better idea.

> References: commit 05de97003c77 ("linux/types.h: enable endian checks for all sparse builds")
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> ---
> [v2]: Elaborated patch description
> 
>  include/uapi/linux/types.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/uapi/linux/types.h b/include/uapi/linux/types.h
> index 41e5914f0a8e..d3dcb0764c45 100644
> --- a/include/uapi/linux/types.h
> +++ b/include/uapi/linux/types.h
> @@ -23,7 +23,11 @@
>  #else
>  #define __bitwise__
>  #endif
> +#if !defined(__CHECK_ENDIAN__) || __CHECK_ENDIAN__ != 0
>  #define __bitwise __bitwise__
> +#else
> +#define __bitwise
> +#endif
>  
>  typedef __u16 __bitwise __le16;
>  typedef __u16 __bitwise __be16;
> -- 
> 2.14.2
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
