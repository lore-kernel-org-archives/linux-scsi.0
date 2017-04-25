From: Song Liu <songliubraving@fb.com>
Subject: Re: [RFC] scsi: reduce protection of scan_mutex in scsi_remove_device
Date: Tue, 25 Apr 2017 21:29:45 +0000
Message-ID: <184B9E31-DD19-4DF8-AB5A-BC09F1D27AA5@fb.com>
References: <20170421211302.2667649-1-songliubraving@fb.com>
 <1492809623.2499.4.camel@sandisk.com>
 <4C56F7C6-1A83-4B03-AFAD-E9C92BB2B2F6@fb.com>
 <1493153988.2628.22.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60064 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2993728AbdDYVaU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 17:30:20 -0400
In-Reply-To: <1493153988.2628.22.camel@sandisk.com>
Content-Language: en-US
Content-ID: <FE4EEC1506CD4642BAD7FA0B320769B1@namprd15.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>


> On Apr 25, 2017, at 1:59 PM, Bart Van Assche <Bart.VanAssche@sandisk.com>=
 wrote:
>=20
> On Fri, 2017-04-21 at 22:31 +0000, Song Liu wrote:
>> On Apr 21, 2017, at 2:20 PM, Bart Van Assche <Bart.VanAssche@sandisk.com=
> wrote:
>>> On Fri, 2017-04-21 at 14:13 -0700, Song Liu wrote:
>>>> On the other hand, some devices do long latency IO during deletion,
>>>> for example, sd_shutdown() may do sync cache and/or start_stop.
>>>> It is not necessary for these commands to run in series.
>>>=20
>>> Have you noticed my patch series that makes sd_shutdown() submit the
>>> SYNCHRONIZE CACHE command asynchronously? Have you tried whether that
>>> patch series would be a good alternative?
>>=20
>> The asynchronous SYNCHRONIZE CACHE will not help our use case, where the=
=20
>> latency comes from sd_start_stop_device(). Seems it is not easy to make=
=20
>> the START STOP UNIT command async.=20
>=20
> Hello Song,
>=20
> It should be possible to make the START STOP UNIT command asynchronous to=
o
> by issuing it asynchronously from inside sd_sync_cache_done(). To avoid
> dereferencing a stale struct scsi_disk pointer you will either have to ho=
ld
> an additional reference as long as the SYNCHRONIZE CACHE command is in
> progress or copy the data needed from struct scsi_disk into the SCSI requ=
est.
>=20

Hello Bart,=20

As you stated in the patch: blk_cleanup_queue() in __scsi_remove_device()=20
will wait for async SYNCHRONIZE CACHE and START STOP UNIT command to comple=
te.=20
Since __scsi_remove_device() is called with scan_mutex held, simultaneous=20
START STOP UNIT requires are still serialized by the scan_mutex.=20

Song
