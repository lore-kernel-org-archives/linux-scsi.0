From: Song Liu <songliubraving@fb.com>
Subject: Re: [RFC] scsi: reduce protection of scan_mutex in scsi_remove_device
Date: Fri, 21 Apr 2017 22:31:44 +0000
Message-ID: <4C56F7C6-1A83-4B03-AFAD-E9C92BB2B2F6@fb.com>
References: <20170421211302.2667649-1-songliubraving@fb.com>
 <1492809623.2499.4.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39211 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1042507AbdDUWcc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Apr 2017 18:32:32 -0400
In-Reply-To: <1492809623.2499.4.camel@sandisk.com>
Content-Language: en-US
Content-ID: <9FAEE63A486D41498EC22C246B7BAD9E@namprd15.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>


> On Apr 21, 2017, at 2:20 PM, Bart Van Assche <Bart.VanAssche@sandisk.com>=
 wrote:
>=20
> On Fri, 2017-04-21 at 14:13 -0700, Song Liu wrote:
>> On the other hand, some devices do long latency IO during deletion,
>> for example, sd_shutdown() may do sync cache and/or start_stop.
>> It is not necessary for these commands to run in series.
>=20
> Have you noticed my patch series that makes sd_shutdown() submit the
> SYNCHRONIZE CACHE command asynchronously? Have you tried whether that
> patch series would be a good alternative?
>=20
> Thanks,
>=20
> Bart.

The asynchronous SYNCHRONIZE CACHE will not help our use case, where the=20
latency comes from sd_start_stop_device(). Seems it is not easy to make=20
the START STOP UNIT command async.=20

Thanks,
Song=
