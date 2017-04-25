From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [RFC] scsi: reduce protection of scan_mutex in scsi_remove_device
Date: Tue, 25 Apr 2017 22:17:38 +0000
Message-ID: <1493158657.2628.26.camel@sandisk.com>
References: <20170421211302.2667649-1-songliubraving@fb.com>
         <1493141028.2628.4.camel@sandisk.com>
         <11AE7D30-E24A-4DF3-8237-AF97A342D239@fb.com>
         <1493142729.2628.6.camel@sandisk.com>
         <3B06D0B6-825E-4788-9B87-BE3F35055DB2@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:60703 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1947837AbdDYWRm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2017 18:17:42 -0400
In-Reply-To: <3B06D0B6-825E-4788-9B87-BE3F35055DB2@fb.com>
Content-Language: en-US
Content-ID: <C6CDC892277E5C4480B9EBD81039415A@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "songliubraving@fb.com" <songliubraving@fb.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>

On Tue, 2017-04-25 at 21:17 +0000, Song Liu wrote:
> I am not sure I fully understand the problem here. If I understand the lo=
gic=20
> correctly, when a device is being removed, it will stay in scsi_host->__d=
evices
> until fully the remove routine is finished. And LUN scanning in parallel =
will
> find the device with scsi_device_lookup_by_target(), and thus it would no=
t=20
> rescan the device until the device is fully removed? Did I miss anything =
here?

Hello Song,

The SCSI core is already complicated enough. Please don't complicate it fur=
ther
by making subtle changes to the semantics of scan_mutex. Please also note t=
hat
I have proposed an alternative, namely to make the START STOP UNIT command
asynchronous.

Bart.=
