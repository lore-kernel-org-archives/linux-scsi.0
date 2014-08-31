From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: [RFC 1/2] target: Add documentation on the target userspace
 pass-through driver
Date: Sun, 31 Aug 2014 22:22:58 +0100
Message-ID: <20140831212257.GO1302@redhat.com>
References: <1404241875-29164-1-git-send-email-agrover@redhat.com>
 <1404241875-29164-2-git-send-email-agrover@redhat.com>
 <20140830173510.GA11820@redhat.com>
 <54037C46.1050601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54037C46.1050601@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org, shli@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Aug 31, 2014 at 12:49:26PM -0700, Andy Grover wrote:
> Thanks for the feedback. I am undoubtedly too close to the details,
> because I thought I *was* explaining things :)

Yeah, sorry it came across as a bit harsh.

Benoit did explain it to me so I understood it in the end (I think!)

> This doc is for people like you -- tech-savvy but unfamiliar with
> this specific area. Would you be so kind as to point out exactly the
> terms this document should explain? Should it explain SCSI and SCSI
> commands? What a SCSI target is? Say "target implementations" rather
> than "target solutions"? Do I need some ASCII art?

So I can only speak for myself here, but I'm pretty familiar with
iSCSI, using it, and some of the internals -- in fact I'm using the
Linux kernel target daily.

> TCM Userspace Design
> In addition to modularizing the transport protocol used for carrying
> SCSI commands ("fabrics"), the Linux kernel target, LIO, also
> modularizes the actual data storage as well.  These are referred to
> as "backstores" or "storage engines".

Reading this several times, I now think I get what it's trying to say,
but I think it needs to introduces the terms (as the Economist style
does).  Something like this:

  "TCM is the new name for LIO, an in-kernel iSCSI target (server).
  Existing TCM targets run in the kernel.  TCMU (TCM in Userspace)
  allows userspace programs to be written which act as iSCSI targets.
  This document describes the design.

  The existing kernel provides modules for different SCSI transport
  protocols.  TCM also modularizes the data storage.  There are
  existing modules for file, block device, RAM or using another SCSI
  device as storage.  These are called "backstores" or "storage
  engines".  These built-in modules are implemented entirely as kernel
  code."

And hopefully having defined a bit of background, the rest of the
document just flows nicely:

> These backstores cover the most common use cases, but not all. One new
> use case that other non-kernel target solutions, such as tgt, are able
> to support is using Gluster's GLFS or Ceph's RBD as a backstore. The
> target then serves as a translator, allowing initiators to store data
> in these non-traditional networked storage systems, while still only
> using standard protocols themselves.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://people.redhat.com/~rjones/virt-df/
