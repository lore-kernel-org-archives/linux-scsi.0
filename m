From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v3 04/12] Protect SCSI device state changes with a mutex
Date: Mon, 5 Jun 2017 15:18:49 +0000
Message-ID: <1496675927.2623.1.camel@sandisk.com>
References: <20170602212203.30401-1-bart.vanassche@sandisk.com>
         <20170602212203.30401-5-bart.vanassche@sandisk.com>
         <20170605080937.GB22028@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:45394 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751153AbdFEPU2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2017 11:20:28 -0400
In-Reply-To: <20170605080937.GB22028@lst.de>
Content-Language: en-US
Content-ID: <4B02C86B948AD148AA58E54B2609C027@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "hare@suse.com" <hare@suse.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Mon, 2017-06-05 at 10:09 +0200, Christoph Hellwig wrote:
> On Fri, Jun 02, 2017 at 02:21:55PM -0700, Bart Van Assche wrote:
> > Serializing SCSI device state changes avoids that two state changes
> > can occur concurrently, e.g. the state changes in scsi_target_block()
> > and __scsi_remove_device(). This serialization is essential to make
> > patch "Make __scsi_remove_device go straight from BLOCKED to DEL"
> > work reliably.
> >=20
> > Enable this mechanism for all scsi_target_*block() callers but not
> > for the scsi_internal_device_unblock() calls from the mpt3sas driver
> > because that driver can call scsi_internal_device_unblock() from
> > atomic context.
>=20
> And not taking the lock in that path is safe because of what conditions?

Hello Christoph,

The mpt3sas driver is the only driver that calls scsi_internal_device_block=
()
and scsi_internal_device_unblock() from atomic context. Since it's not an o=
ption
to protect the SCSI device state changes with a spinlock I prefer that the
mpt3sas authors convert the scsi_internal_device_block() calls into
scsi_target_block() calls.

Bart.=
