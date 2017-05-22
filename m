From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 15/18] scsi: storvsc: Initialize driver-private command
 before using it
Date: Mon, 22 May 2017 17:15:37 +0000
Message-ID: <1495473336.1017.1.camel@sandisk.com>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com>
         <20170519183016.12646-16-bart.vanassche@sandisk.com>
         <20170521065134.GF12891@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:14874 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752121AbdEVRQW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2017 13:16:22 -0400
In-Reply-To: <20170521065134.GF12891@lst.de>
Content-Language: en-US
Content-ID: <773043AFC495B1438B6F0747780F5778@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "hare@suse.com" <hare@suse.com>, "kys@microsoft.com" <kys@microsoft.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "longli@microsoft.com" <longli@microsoft.com>

On Sun, 2017-05-21 at 08:51 +0200, Christoph Hellwig wrote:
> On Fri, May 19, 2017 at 11:30:13AM -0700, Bart Van Assche wrote:
> > The storvsc driver is the only SCSI LLD that uses driver-private
> > command data and that does not zero-initialize that data before
> > reading it. Make this driver consistent with the other SCSI LLDs
> > that use driver-private command data.
>=20
> Well.  Either we add zeroing to storvsc and remove it from common
> code, or we remove the zeroing from the drivers.
>=20
> We shouldn't do both.  Given that we already zero the remaining
> command it seems to me like keeping the zeroing in common code
> would be preferred, but I'm open to discussion.

Hello Christoph,

I will remove the code that zeroes driver-private command data from the oth=
er
SCSI LLDs and add it to the scsi-sq request preparation code path.

Bart.=
