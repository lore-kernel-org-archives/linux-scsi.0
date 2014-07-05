From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [RFC 1/2] target: Add documentation on the target userspace pass-through driver
Date: Sat, 05 Jul 2014 04:29:30 -0700
Message-ID: <lp8niu$ltr$1@ger.gmane.org>
References: <1404241875-29164-1-git-send-email-agrover@redhat.com> <1404241875-29164-2-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Reply inline, with a good bit of snipping done (posting via gmane, so 
quote/content ratio is an issue).

Andy Grover wrote:

> +These backstores cover the most common use cases, but not all. One new
> +use case that other non-kernel target solutions, such as tgt, are able
> +to support is using Gluster's GLFS or Ceph's RBD as a backstore. The
> +target then serves as a translator, allowing initiators to store data
> +in these non-traditional networked storage systems, while still only
> +using standard protocols themselves.

Another use case is in supporting various image formats, like (say) qcow2, 
and then handing those off to vhost_scsi.

> +Benefits:
> +
> +In addition to allowing relatively easy support for RBD and GLFS, TCMU
> +will also allow easier development of new backstores. TCMU combines
> +with the LIO loopback fabric to become something similar to FUSE
> +(Filesystem in Userspace), but at the SCSI layer instead of the
> +filesystem layer. A SUSE, if you will.

As long as people don't start calling it L[UNs in ]USER[space] :P

Between that and ABUSE (A Block device in USErspace), this domain has some 
real naming potential...

> +Device Discovery:
> +
> +Other devices may be using UIO besides TCMU. Unrelated user processes
> +may also be handling different sets of TCMU devices. TCMU userspace
> +processes must find their devices by scanning sysfs
> +class/uio/uio*/name. For TCMU devices, these names will be of the
> +format:
> +
> +tcm-user/<subtype>/<path>
> +
> +where "tcm-user" is common for all TCMU-backed UIO devices. <subtype>
> +will be a userspace-process-unique string to identify the TCMU device
> +as expecting to be backed by a certain handler, and <path> will be an
> +additional handler-specific string for the user process to configure
> +the device, if needed. Neither <subtype> or <path> can contain ':',
> +due to LIO limitations.

It might be good to change this somewhat; in the vast majority of cases it'd 
be saner for userspace programs to figure this information out via udev etc. 
rather than parsing sysfs themselves. This information is still worth 
documenting, but saying things like "must find their devices by scanning 
sysfs" is likely to lead to users of this interface making suboptimal 
choices.

> +Device Events:
> +
> +If a new device is added or removed, user processes will recieve a HUP
> +signal, and should re-scan sysfs. File descriptors for devices no
> +longer in sysfs should be closed, and new devices should be opened and
> +handled.

Is there a cleaner way to do this? In particular, re-scanning sysfs may 
cause race conditions (device removed, one of the same name re-added but a 
different UIO device node; probably more to be found). Perhaps recommend 
netlink uevents, so that remove+add is noticeable? Also, is the SIGHUP 
itself the best option? Could we simply require the user process to listen 
for add/remove uevents to get such change notifications, and thus enforce 
good behavior?

> +Writing a user backstore handler:
> +
> +Variable emulation with pass_level:
> +
> +TCMU supports a "pass_level" option with valid values of 1, 2, or
> +3. This controls how many different SCSI commands are passed up,
> +versus being emulated by LIO. The purpose of this is to give the user
> +handler author a choice of how much of the full SCSI command set they
> +care to support.
> +
> +At level 1, only READ and WRITE commands will be seen. At level 2,
> +additional commands defined in the SBC SCSI specification such as
> +WRITE SAME, SYNCRONIZE CACHE, and UNMAP will be passed up. Finally, at
> +level 3, almost all commands defined in the SPC SCSI specification
> +will also be passed up for processing by the user handler.

One use case I'm actually interested in is having userspace provide 
something other than just SPC - for instance, tgt can provide a virtual tape 
library or an OSD, and CDemu can provide emulated optical discs from various 
image formats.

Currently, CDemu uses its own out-of-tree driver called VHBA (Virtual Host 
Bus Adapter) to do pretty much exactly what TCMU+Loopback would 
accomplish... and in the process misses out on all of the other fabrics, 
unless you're willing to _re-import_ those devices using PSCSI, which has 
its own quirks.

Perhaps there could be a level 0 (or 4, or whatever) which means "explicitly 
enabled list of commands" - maybe as a bitmap that could be passed to the 
kernel somehow? Hopefully, that could also avoid some of the quirks of PSCSI 
regarding ALUA and such - if it's not implemented, leave the relevant bits 
at zero, and LIO handles it.

This does look really nice, thanks for writing it!
