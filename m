From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 0/3] Unblock SCSI devices even if the LLD is being
 unloaded
Date: Thu, 16 Mar 2017 23:19:52 +0000
Message-ID: <1489706379.2574.24.camel@sandisk.com>
References: <20170316205650.3322-1-bart.vanassche@sandisk.com>
         <1489704797.4650.8.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:52650 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753465AbdCPXZb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2017 19:25:31 -0400
In-Reply-To: <1489704797.4650.8.camel@HansenPartnership.com>
Content-Language: en-US
Content-ID: <8AB17B94D67ACB4C9F047893321BE62A@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "maxg@mellanox.com" <maxg@mellanox.com>, "israelr@mellanox.com" <israelr@mellanox.com>, "hare@suse.de" <hare@suse.de>

On Thu, 2017-03-16 at 15:53 -0700, James Bottomley wrote:
> On Thu, 2017-03-16 at 13:56 -0700, Bart Van Assche wrote:
> > scsi_target_unblock() must unblock SCSI devices even if this function
> > is called after unloading of the LLD that created these devices has
> > started. This is necessary to prevent that __scsi_remove_device()=20
> > hangs on the SYNCHRONIZE CACHE command issued by the sd driver during
> > shutdown.
>=20
> Your special get function misses the try_module_get().  But this is all
> really a bit ugly. Since the only problem is the SYNC CACHE triggered
> by device_del, isn't a better solution a new state: SDEV_CANCEL_BLOCK.=20
>  This will make the device visible to scsi_get_device() and we can take
> it back from CANCEL_BLOCKED->CANCEL when the queue is unblocked.  I
> suspect we could also simply throw away the sync cache command when the
> device is blocked (the cache should destage naturally in the time it
> takes for the device to be unblocked).

Hello James,

The purpose of this patch series is to make sure that unblock also occurs
after module unloading has started. My understanding of try_module_get() is
that it fails once module unloading has started.=A0In other words, it is on
purpose that try_module_get() is not called. From the kernel module code:

bool try_module_get(struct module *module)
{
	bool ret =3D true;

	if (module) {
		preempt_disable();
		/* Note: here, we can fail to get a reference */
		if (likely(module_is_live(module) &&
			   atomic_inc_not_zero(&module->refcnt) !=3D 0))
			trace_module_get(module, _RET_IP_);
		else
			ret =3D false;
		preempt_enable();
	}
	return ret;
}

static inline int module_is_live(struct module *mod)
{
	return mod->state !=3D MODULE_STATE_GOING;
}

Regarding introducing a new device state: this is something I would like to
avoid. Any code that manipulates the SCSI device state is unnecessarily har=
d
to modify because multiple types of state information have been mixed up in
a single state variable (blocked / not blocked; created / running / cancel =
/
offline). Additionally, the SCSI device state is visible to user space.
Adding a new SCSI device state could break existing user space applications=
.

There is another problem with the introduction of the SDEV_CANCEL_BLOCKED
state: we do not want open() calls to succeed for devices that are in the
SDEV_DEL, SDEV_CANCEL nor for devices that are in the SDEV_CANCEL_BLOCKED
state. scsi_disk_get() in the sd driver relies on scsi_device_get() to chec=
k
the SCSI device state. If scsi_device_get() would succeed for devices in th=
e
SDEV_CANCEL_BLOCKED state then an explicit check for that state would have
to be added in several users of scsi_device_get(). In other words, I think
adding the SDEV_CANCEL_BLOCKED state would result in a much more complex an=
d
also harder to test patch.

Thanks,

Bart.=
