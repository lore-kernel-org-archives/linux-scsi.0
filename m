From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [RFC] scsi: reduce protection of scan_mutex in scsi_remove_device
Date: Tue, 25 Apr 2017 17:23:49 +0000
Message-ID: <1493141028.2628.4.camel@sandisk.com>
References: <20170421211302.2667649-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:59937 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1952034AbdDYRXy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2017 13:23:54 -0400
In-Reply-To: <20170421211302.2667649-1-songliubraving@fb.com>
Content-Language: en-US
Content-ID: <5DEB6C4C588F6546B97F7174D0F54774@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "songliubraving@fb.com" <songliubraving@fb.com>
Cc: "hch@infradead.org" <hch@infradead.org>

On Fri, 2017-04-21 at 14:13 -0700, Song Liu wrote:
> When a device is deleted through sysfs handle "delete", the code
> locks shost->scan_mutex. If multiple devices are deleted at the
> same time, these deletes will be handled in series.
>=20
> On the other hand, some devices do long latency IO during deletion,
> for example, sd_shutdown() may do sync cache and/or start_stop.
> It is not necessary for these commands to run in series.
>=20
> To reduce latency of parallel "delete" requests, this patch reduces
> the protection of scan_mutex. The only function with Scsi_Host
> called in __scsi_remove_device() is the optional slave_destroy().
> Therefore, the protection of scan_mutex is only necessary for this
> function.

Hello Song,

What you wrote above is wrong. It is necessary to serialize SCSI
scanning against SCSI device removal. That is why scan_mutex is held
around the __scsi_remove_device() call. When adding a LUN the following
(and several other) actions are performed:
* Allocation of memory for struct scsi_device.
* Allocation of a block layer request queue.
* Initialization of the .sdev_gendev and .sdev_dev device structures.
* Association of the transport layer driver with the SCSI device.
* Association of a device handler with the SCSI device (e.g. ALUA).
* Making the .sdev_gendev and .sdev_dev devices visible in sysfs.
* Making the transport layer attributes visible in sysfs.
* Creating a bsg device node in sysfs.
* Association of an upper layer driver
(e.g. sd or sr) with the SCSI LUN.

Removal of a LUN means undoing all of the above. If adding and removing
a LUN would not be not serialized then there would be a risk that removal
and immediate reregistration of a LUN will fail due to the reregistration
process trying to add sysfs attributes that were not yet removed by the
removal step.

Bart.=
