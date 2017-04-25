From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [RFC] scsi: reduce protection of scan_mutex in scsi_remove_device
Date: Tue, 25 Apr 2017 17:52:09 +0000
Message-ID: <1493142729.2628.6.camel@sandisk.com>
References: <20170421211302.2667649-1-songliubraving@fb.com>
         <1493141028.2628.4.camel@sandisk.com>
         <11AE7D30-E24A-4DF3-8237-AF97A342D239@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:6175 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946490AbdDYRwN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2017 13:52:13 -0400
In-Reply-To: <11AE7D30-E24A-4DF3-8237-AF97A342D239@fb.com>
Content-Language: en-US
Content-ID: <E61FC8B2D173A3488ABEEB26549A8A77@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "songliubraving@fb.com" <songliubraving@fb.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>

On Tue, 2017-04-25 at 17:42 +0000, Song Liu wrote:
> I have been studying the code recently. I am wondering whether the follow=
ing=20
> would work:
>=20
> 1. Introduce a new mutex for scsi_device to protect most operations in th=
e=20
>    list you gathered above;
>=20
> 2. For operations like host->slave_destroy(), ensure they access scsi_hos=
t=20
>    data with host_lock (or another spin lock).=20
>=20
>    I looked into all instances of slave_destroy, only 2 of them:=20
>    dc395x_slave_destroy() and visorhba_slave_destroy() access scsi_host d=
ata=20
>    without protection of spin lock.=20
>=20
> 3. Once 1 and 2 is ready, __scsi_remove_device() only need to hold the mu=
tex
>    for the scsi_device. scan_mutex is no longer required.=20
>=20
> Is this a valid path?

Sorry but I don't think so. Unlocking and reacquiring scan_mutex would crea=
te
the potential that LUN scanning occurs in the meantime and hence that it fa=
ils
because LUN removal is incomplete.

Bart.=
