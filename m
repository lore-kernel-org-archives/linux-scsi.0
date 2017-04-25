From: Song Liu <songliubraving@fb.com>
Subject: Re: [RFC] scsi: reduce protection of scan_mutex in scsi_remove_device
Date: Tue, 25 Apr 2017 17:42:21 +0000
Message-ID: <11AE7D30-E24A-4DF3-8237-AF97A342D239@fb.com>
References: <20170421211302.2667649-1-songliubraving@fb.com>
 <1493141028.2628.4.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59385 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S971186AbdDYRnT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 13:43:19 -0400
In-Reply-To: <1493141028.2628.4.camel@sandisk.com>
Content-Language: en-US
Content-ID: <A52F3CB18F0AB94BB8F90062BFED5D9B@namprd15.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>


> On Apr 25, 2017, at 10:23 AM, Bart Van Assche <Bart.VanAssche@sandisk.com=
> wrote:
>=20
> On Fri, 2017-04-21 at 14:13 -0700, Song Liu wrote:
>> When a device is deleted through sysfs handle "delete", the code
>> locks shost->scan_mutex. If multiple devices are deleted at the
>> same time, these deletes will be handled in series.
>>=20
>> On the other hand, some devices do long latency IO during deletion,
>> for example, sd_shutdown() may do sync cache and/or start_stop.
>> It is not necessary for these commands to run in series.
>>=20
>> To reduce latency of parallel "delete" requests, this patch reduces
>> the protection of scan_mutex. The only function with Scsi_Host
>> called in __scsi_remove_device() is the optional slave_destroy().
>> Therefore, the protection of scan_mutex is only necessary for this
>> function.
>=20
> Hello Song,
>=20
> What you wrote above is wrong. It is necessary to serialize SCSI
> scanning against SCSI device removal. That is why scan_mutex is held
> around the __scsi_remove_device() call. When adding a LUN the following
> (and several other) actions are performed:
> * Allocation of memory for struct scsi_device.
> * Allocation of a block layer request queue.
> * Initialization of the .sdev_gendev and .sdev_dev device structures.
> * Association of the transport layer driver with the SCSI device.
> * Association of a device handler with the SCSI device (e.g. ALUA).
> * Making the .sdev_gendev and .sdev_dev devices visible in sysfs.
> * Making the transport layer attributes visible in sysfs.
> * Creating a bsg device node in sysfs.
> * Association of an upper layer driver
> (e.g. sd or sr) with the SCSI LUN.
>=20
> Removal of a LUN means undoing all of the above. If adding and removing
> a LUN would not be not serialized then there would be a risk that removal
> and immediate reregistration of a LUN will fail due to the reregistration
> process trying to add sysfs attributes that were not yet removed by the
> removal step.
>=20
> Bart.

Hello Bart,=20

Thanks a lot for looking into this.=20

I have been studying the code recently. I am wondering whether the followin=
g=20
would work:

1. Introduce a new mutex for scsi_device to protect most operations in the=
=20
   list you gathered above;

2. For operations like host->slave_destroy(), ensure they access scsi_host=
=20
   data with host_lock (or another spin lock).=20

   I looked into all instances of slave_destroy, only 2 of them:=20
   dc395x_slave_destroy() and visorhba_slave_destroy() access scsi_host dat=
a=20
   without protection of spin lock.=20

3. Once 1 and 2 is ready, __scsi_remove_device() only need to hold the mute=
x
   for the scsi_device. scan_mutex is no longer required.=20

Is this a valid path?

Thanks again,
Song
