From: Song Liu <songliubraving@fb.com>
Subject: Re: [RFC] scsi: reduce protection of scan_mutex in scsi_remove_device
Date: Tue, 25 Apr 2017 21:17:13 +0000
Message-ID: <3B06D0B6-825E-4788-9B87-BE3F35055DB2@fb.com>
References: <20170421211302.2667649-1-songliubraving@fb.com>
 <1493141028.2628.4.camel@sandisk.com>
 <11AE7D30-E24A-4DF3-8237-AF97A342D239@fb.com>
 <1493142729.2628.6.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46379 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1948907AbdDYVSk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 17:18:40 -0400
In-Reply-To: <1493142729.2628.6.camel@sandisk.com>
Content-Language: en-US
Content-ID: <3C9BA132C2ED1D4E8102522DE209F368@namprd15.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>


> On Apr 25, 2017, at 10:52 AM, Bart Van Assche <Bart.VanAssche@sandisk.com=
> wrote:
>=20
> On Tue, 2017-04-25 at 17:42 +0000, Song Liu wrote:
>> I have been studying the code recently. I am wondering whether the follo=
wing=20
>> would work:
>>=20
>> 1. Introduce a new mutex for scsi_device to protect most operations in t=
he=20
>>   list you gathered above;
>>=20
>> 2. For operations like host->slave_destroy(), ensure they access scsi_ho=
st=20
>>   data with host_lock (or another spin lock).=20
>>=20
>>   I looked into all instances of slave_destroy, only 2 of them:=20
>>   dc395x_slave_destroy() and visorhba_slave_destroy() access scsi_host d=
ata=20
>>   without protection of spin lock.=20
>>=20
>> 3. Once 1 and 2 is ready, __scsi_remove_device() only need to hold the m=
utex
>>   for the scsi_device. scan_mutex is no longer required.=20
>>=20
>> Is this a valid path?
>=20
> Sorry but I don't think so. Unlocking and reacquiring scan_mutex would cr=
eate
> the potential that LUN scanning occurs in the meantime and hence that it =
fails
> because LUN removal is incomplete.
>=20


Hello Bart,=20

I am not sure I fully understand the problem here. If I understand the logi=
c=20
correctly, when a device is being removed, it will stay in scsi_host->__dev=
ices
until fully the remove routine is finished. And LUN scanning in parallel wi=
ll
find the device with scsi_device_lookup_by_target(), and thus it would not=
=20
rescan the device until the device is fully removed? Did I miss anything he=
re?

Thanks,
Song
