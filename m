From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] sgbind
Date: Wed, 14 May 2003 14:02:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030514140235.A20579@infradead.org>
References: <3EC2379C.4010709@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([195.224.96.167]:41489 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262038AbTENMtt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2003 08:49:49 -0400
Content-Disposition: inline
In-Reply-To: <3EC2379C.4010709@torque.net>; from dougg@torque.net on Wed, May 14, 2003 at 10:33:32PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Wed, May 14, 2003 at 10:33:32PM +1000, Douglas Gilbert wrote:
> The sgbind code is in the sg driver which allows it
> to share existing code. sgbind avoids using the sg
> driver's upper level sysfs code (i.e. sg_driverfs_dev).

I'd prefer to have it in the scsi midlayer as it's not really
a traditional scsi upper driver but rather a special way to access
scsi devices.

> struct sgbind_nexus {
>          int descriptor_id;      /* set to 0 for now */

Why is this signed?

>          unsigned int host_no;
>          unsigned int channel;
>          unsigned int scsi_id;
>          unsigned int lun;

Please use __u32/__s32 instead.  Any new interface should
use those explicit versions.

> The SGBIND_ADD_LU and SGBIND_REMOVE_LU ioctls are simply
> programmatic interfaces to the code behind "scsi add-single-device"
> and "scsi remove-single-device". [Code was moved from scsi_proc.c
> to scsi_scan.c so that these ioctls don't require procfs to be
> configured.]

I don't think adding more ioctls is a good thing.

> Multiple file descriptors may be open on /dev/sgbind, each
> file descriptor has its own state (like normal sg device nodes).
> The SGBIND_ATTACH ioctl will either bind:
>    - to an existing logical unit (device) which matches the
>      given nexus
>    - create a new scsi_device instance (using scsi_alloc_dev())
>      with the given nexus
> The host number must match an existing host.
>=20
> The SGBIND_DETACH ioctl unbinds the file descriptor from an
> existing nexus (assuming a nexus was established by a prior
> SGBIND_ATTACH). Thereafter an new nexus can be formed with
> SGBIND_ATTACH. Closing the file descriptor also has the effect
> of unbinding the nexus.

I don't like this ioctl horror.  Can't you add a sgfs that just contain=
=DF
nodes for all scsi devices?

> To test this further I believe there should be a new
> field in the Scsi_Host and Scsi_Host_Template structures
> called something like 'no_scan'. Default is 0 for
> existing mid level scanning. A value of 1 instructs
> the scsi_scan.c to ignore this host.

Good idea.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
