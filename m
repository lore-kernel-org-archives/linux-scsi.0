From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [RFC] sgbind
Date: Thu, 15 May 2003 00:02:09 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC24C61.4070203@torque.net>
References: <3EC2379C.4010709@torque.net> <20030514140235.A20579@infradead.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:8974 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262206AbTENNsv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2003 09:48:51 -0400
In-Reply-To: <20030514140235.A20579@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, May 14, 2003 at 10:33:32PM +1000, Douglas Gilbert wrote:
>=20
>>The sgbind code is in the sg driver which allows it
>>to share existing code. sgbind avoids using the sg
>>driver's upper level sysfs code (i.e. sg_driverfs_dev).
>=20
>=20
> I'd prefer to have it in the scsi midlayer as it's not really
> a traditional scsi upper driver but rather a special way to access
> scsi devices.

The sg driver is nothing if not "a special way to
access scsi devices". Sg is a pass through to the
mid level. Note that I originally suggested this
could be an addition to the mid level and Patrick
Mansfield suggested I put it in the sg driver.
To date it is about 180 extra lines of code in
sg.

Also the SCSI_IOCTL_SEND_COMMAND and SG_IO implementations
in the block layer are sub-standard. I'd prefer not to
see that hack repeated.

>>struct sgbind_nexus {
>>         int descriptor_id;      /* set to 0 for now */
>=20
>=20
> Why is this signed?

It is simply a guard, allowing a different toplogical
representation (perhaps with a 64 bit, multi-level
lun).

>>         unsigned int host_no;
>>         unsigned int channel;
>>         unsigned int scsi_id;
>>         unsigned int lun;
>=20
>=20
> Please use __u32/__s32 instead.  Any new interface should
> use those explicit versions.

Why not int32_t and uint32_t?
Using identifiers that start with a double underscore is
a contravention of both C89 and C99.

>>The SGBIND_ADD_LU and SGBIND_REMOVE_LU ioctls are simply
>>programmatic interfaces to the code behind "scsi add-single-device"
>>and "scsi remove-single-device". [Code was moved from scsi_proc.c
>>to scsi_scan.c so that these ioctls don't require procfs to be
>>configured.]
>=20
>=20
> I don't think adding more ioctls is a good thing.
>=20
>=20
>>Multiple file descriptors may be open on /dev/sgbind, each
>>file descriptor has its own state (like normal sg device nodes).
>>The SGBIND_ATTACH ioctl will either bind:
>>   - to an existing logical unit (device) which matches the
>>     given nexus
>>   - create a new scsi_device instance (using scsi_alloc_dev())
>>     with the given nexus
>>The host number must match an existing host.
>>
>>The SGBIND_DETACH ioctl unbinds the file descriptor from an
>>existing nexus (assuming a nexus was established by a prior
>>SGBIND_ATTACH). Thereafter an new nexus can be formed with
>>SGBIND_ATTACH. Closing the file descriptor also has the effect
>>of unbinding the nexus.
>=20
>=20
> I don't like this ioctl horror.  Can't you add a sgfs that just conta=
in=DF
> nodes for all scsi devices?

That is exactly what I'm trying to avoid. The whole idea is
to not scan all SCSI devices in the kernel and
not generate some kernel mapping of them. Rather, give
the scanning job to a user application and it can pick its
way around and only make those devices that are relevant
visible.

Doug Gilbert



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
