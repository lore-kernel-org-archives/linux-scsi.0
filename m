From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: [RFC 1/2] target: Add documentation on the target userspace
 pass-through driver
Date: Sat, 30 Aug 2014 18:35:10 +0100
Message-ID: <20140830173510.GA11820@redhat.com>
References: <1404241875-29164-1-git-send-email-agrover@redhat.com>
 <1404241875-29164-2-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1404241875-29164-2-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org, shli@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 01, 2014 at 12:11:14PM -0700, Andy Grover wrote:
> Describes the driver and its interface to make it possible for user
> programs to back a LIO-exported LUN.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  Documentation/target/tcmu-design.txt | 210 +++++++++++++++++++++++++++++++++++
>  1 file changed, 210 insertions(+)
>  create mode 100644 Documentation/target/tcmu-design.txt
> 
> diff --git a/Documentation/target/tcmu-design.txt b/Documentation/target/tcmu-design.txt
> new file mode 100644
> index 0000000..200ff3e
> --- /dev/null
> +++ b/Documentation/target/tcmu-design.txt
> @@ -0,0 +1,210 @@
> +TCM Userspace Design
> +--------------------
> +
> +
> +Background:
> +
> +In addition to modularizing the transport protocol used for carrying
> +SCSI commands ("fabrics"), the Linux kernel target, LIO, also modularizes
> +the actual data storage as well. These are referred to as "backstores"
> +or "storage engines". The target comes with backstores that allow a
> +file, a block device, RAM, or another SCSI device to be used for the
> +local storage needed for the exported SCSI LUN. Like the rest of LIO,
> +these are implemented entirely as kernel code.
> +
> +These backstores cover the most common use cases, but not all. One new
> +use case that other non-kernel target solutions, such as tgt, are able
> +to support is using Gluster's GLFS or Ceph's RBD as a backstore. The
> +target then serves as a translator, allowing initiators to store data
> +in these non-traditional networked storage systems, while still only
> +using standard protocols themselves.
> +
> +If the target is a userspace process, supporting these is easy. tgt,
> +for example, needs only a small adapter module for each, because the
> +modules just use the available userspace libraries for RBD and GLFS.
> +
> +Adding support for these backstores in LIO is considerably more
> +difficult, because LIO is entirely kernel code. Instead of undertaking
> +the significant work to port the GLFS or RBD APIs and protocols to the
> +kernel, another approach is to create a userspace pass-through
> +backstore for LIO, "TCMU".

It has to be said that this documentation is terrible.

Jumping "in medias res"[1] is great for fiction, awful for technical
documentation.

I would recommend the Economist Style Guide[2].  They always say
"Barak Obama, President of the United States" the first time he is
mentioned in an article, even though almost everyone knows who Barak
Obama is.

In this case you're leaping into something .. fabrics, LIO,
backstores, target solutions, ... aargh.  Explain what you mean by
each term and how it all fits together.

Thanks,
Rich.

[1] https://en.wikipedia.org/wiki/In_medias_res

[2] http://www.economist.com/styleguide/introduction

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-builder quickly builds VMs from scratch
http://libguestfs.org/virt-builder.1.html
