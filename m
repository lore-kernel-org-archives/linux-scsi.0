From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [RFC] scsi: reduce protection of scan_mutex in scsi_remove_device
Date: Tue, 25 Apr 2017 20:59:54 +0000
Message-ID: <1493153988.2628.22.camel@sandisk.com>
References: <20170421211302.2667649-1-songliubraving@fb.com>
         <1492809623.2499.4.camel@sandisk.com>
         <4C56F7C6-1A83-4B03-AFAD-E9C92BB2B2F6@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:57365 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033861AbdDYU74 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2017 16:59:56 -0400
In-Reply-To: <4C56F7C6-1A83-4B03-AFAD-E9C92BB2B2F6@fb.com>
Content-Language: en-US
Content-ID: <EFDE07C470188D4DA58654D2C11A6406@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "songliubraving@fb.com" <songliubraving@fb.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>

On Fri, 2017-04-21 at 22:31 +0000, Song Liu wrote:
> On Apr 21, 2017, at 2:20 PM, Bart Van Assche <Bart.VanAssche@sandisk.com>=
 wrote:
> > On Fri, 2017-04-21 at 14:13 -0700, Song Liu wrote:
> > > On the other hand, some devices do long latency IO during deletion,
> > > for example, sd_shutdown() may do sync cache and/or start_stop.
> > > It is not necessary for these commands to run in series.
> >=20
> > Have you noticed my patch series that makes sd_shutdown() submit the
> > SYNCHRONIZE CACHE command asynchronously? Have you tried whether that
> > patch series would be a good alternative?
>=20
> The asynchronous SYNCHRONIZE CACHE will not help our use case, where the=
=20
> latency comes from sd_start_stop_device(). Seems it is not easy to make=20
> the START STOP UNIT command async.=20

Hello Song,

It should be possible to make the START STOP UNIT command asynchronous too
by issuing it asynchronously from inside sd_sync_cache_done(). To avoid
dereferencing a stale struct scsi_disk pointer you will either have to hold
an additional reference as long as the SYNCHRONIZE CACHE command is in
progress or copy the data needed from struct scsi_disk into the SCSI reques=
t.

Bart.=
