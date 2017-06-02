From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 06/12] Make __scsi_remove_device go straight from
 BLOCKED to DEL
Date: Fri, 2 Jun 2017 20:58:06 +0000
Message-ID: <1496437084.1214.17.camel@sandisk.com>
References: <20170601232711.29062-1-bart.vanassche@sandisk.com>
         <20170601232711.29062-7-bart.vanassche@sandisk.com>
         <20170602071820.GF560@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:65419 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750966AbdFBU7L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 16:59:11 -0400
In-Reply-To: <20170602071820.GF560@lst.de>
Content-Language: en-US
Content-ID: <8FF6D0DE585E7140899CD052DF973A69@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "israelr@mellanox.com" <israelr@mellanox.com>, "bblock@linux.vnet.ibm.com" <bblock@linux.vnet.ibm.com>, "maxg@mellanox.com" <maxg@mellanox.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Fri, 2017-06-02 at 09:18 +0200, Christoph Hellwig wrote:
> On Thu, Jun 01, 2017 at 04:27:05PM -0700, Bart Van Assche wrote:
> > If a device is blocked, make __scsi_remove_device() cause it to
> > transition to the DEL state. This means that all the commands
> > issued in .shutdown() will error in the mid-layer, thus making
> > the removal proceed without being stopped.
> >=20
> > This patch is a slightly modified version of a patch from James
> > Bottomley. This patch avoids that the following lockup occurs:
>=20
> Do we really need the printk for this case?  And if we do we should
> probably rate limit it.

Hello Christoph,

The printk statement was useful during debugging to confirm that the
code path with the printk was hit. I will remove the printk.

Bart.=
