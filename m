From: Song Liu <songliubraving@fb.com>
Subject: Re: [RFC] scsi: reduce protection of scan_mutex in scsi_remove_device
Date: Wed, 26 Apr 2017 00:41:48 +0000
Message-ID: <7EED4CA5-AD83-4C49-810C-D796CEC2358A@fb.com>
References: <20170421211302.2667649-1-songliubraving@fb.com>
 <1493141028.2628.4.camel@sandisk.com>
 <11AE7D30-E24A-4DF3-8237-AF97A342D239@fb.com>
 <1493142729.2628.6.camel@sandisk.com>
 <3B06D0B6-825E-4788-9B87-BE3F35055DB2@fb.com>
 <1493158657.2628.26.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [67.231.145.42] ([67.231.145.42]:48643 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1433746AbdDZAof (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 20:44:35 -0400
In-Reply-To: <1493158657.2628.26.camel@sandisk.com>
Content-Language: en-US
Content-ID: <35453D334EBB414EB994D45D149D6F4D@namprd15.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>


> On Apr 25, 2017, at 3:17 PM, Bart Van Assche <Bart.VanAssche@sandisk.com>=
 wrote:
>=20
> On Tue, 2017-04-25 at 21:17 +0000, Song Liu wrote:
>> I am not sure I fully understand the problem here. If I understand the l=
ogic=20
>> correctly, when a device is being removed, it will stay in scsi_host->__=
devices
>> until fully the remove routine is finished. And LUN scanning in parallel=
 will
>> find the device with scsi_device_lookup_by_target(), and thus it would n=
ot=20
>> rescan the device until the device is fully removed? Did I miss anything=
 here?
>=20
> Hello Song,
>=20
> The SCSI core is already complicated enough. Please don't complicate it f=
urther
> by making subtle changes to the semantics of scan_mutex. Please also note=
 that
> I have proposed an alternative, namely to make the START STOP UNIT comman=
d
> asynchronous.
>=20

Hello Bart,=20

I total agree with your concern in making SCSI core more complicated. Howev=
er, I am
not sure whether how asynchronous START STOP UNIT command makes multiple de=
letes run
in parallel. If I understand correctly, each device delete has the followin=
g steps:
  1. lock scan_mutex
  2. issue async START STOP UNIT=20
  3. wait START STOP UNIT to complete
  4. unlock scan_mutex

scan_mutex will prevent multiple device deletes to run in parallel.=20

On the other hand, maybe the problem is simpler than I thought? Once we ens=
ure all
slave_destroy() holds proper lock to access host level data, something as f=
ollows
might just work. In this way, echoing into delete handle is not protected b=
y=20
scan_mutex. However, when the sysfs entry exists, the device should be full=
y added=20
to the system. And before delete operation finishes, future scan should not=
 re-add=20
the device (as the device can be found by scsi_device_lookup_by_target).=20

Am I too optimistic here?

Thanks,
Song


diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 82dfe07..d1c3338 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -710,7 +710,7 @@ sdev_store_delete(struct device *dev, struct device_att=
ribute *attr,
                  const char *buf, size_t count)
 {
        if (device_remove_file_self(dev, attr))
-               scsi_remove_device(to_scsi_device(dev));
+               __scsi_remove_device(to_scsi_device(dev));
        return count;
 };=20
