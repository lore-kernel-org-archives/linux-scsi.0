From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v6] sd: Check for unaligned partial completion
Date: Wed, 1 Mar 2017 16:16:43 +0000
Message-ID: <1488384978.2699.1.camel@sandisk.com>
References: <20170301082700.20413-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:31189 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751963AbdCAQ0R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 11:26:17 -0500
In-Reply-To: <20170301082700.20413-1-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <1FFD70736B1902479BACBC0A7C75ECEB@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "hare@suse.de" <hare@suse.de>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>, "hch@lst.de" <hch@lst.de>

On Wed, 2017-03-01 at 17:27 +0900, Damien Le Moal wrote:
> Commit <f2e767bb5d6e> ("mpt3sas: Force request partial completion
> alignment") was not considering the case of commands not operating on
> logical block size units (e.g. REQ_OP_ZONE_REPORT and its 64B aligned
> partial replies). In this case, forcing alignment of resid to the
> device logical block size can break the command result, e.g. in the
> case of REQ_OP_ZONE_REPORT, the exact number of zone reported by the
> device.
>=20
> Move the partial completion alignement check of mpt3sas to a generic
> implementation in sd_done(). The check is added within the default
> section of the initial req_op() switch case so that the report and
> reset zone commands are ignored. In addition, as sd_done() is not
> called for passthrough requests, resid corrections are not done as
> intended by the initial mpt3sas patch.
>=20
> Fixes: f2e767bb5d6e ("mpt3sas: Force request partial completion alignment=
")
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>

We want this patch to be included in the v4.10.x stable kernels so I think
that a "Cc: <stable@vger.kernel.org>" tag is needed. Otherwise this patch
looks fine to me. Hence:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>=
