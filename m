From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v5] sd: Check for unaligned partial completion
Date: Tue, 21 Feb 2017 04:21:47 +0000
Message-ID: <1D08B61A9CF0974AA09887BE32D889DA0AB16B@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
References: <20170217000130.22471-1-damien.lemoal@wdc.com>
 <yq11sus5l0j.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:33561 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750960AbdBUEWC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2017 23:22:02 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>

On 02/20/2017 06:35 PM, Martin K. Petersen wrote:=0A=
> I'm still not keen on having two orthogonal sanity checks wrt. figuring=
=0A=
> out how much of a request has been completed.=0A=
> =0A=
> Also, I find your approach hard to follow in the case where=0A=
> sd_completed_bytes() is called after the resid has been adjusted. It=0A=
> works, but it's not immediately obvious that that's the case. Which to=0A=
> me is an indication that this entire thing needs a thorough cleanup.=0A=
=0A=
Hello Martin and Damien,=0A=
=0A=
How about the following:=0A=
* Add a function to the block layer that reports whether or not the=0A=
  request is a medium access request. The number of transferred bytes=0A=
  for a medium access request is a multiple of the logical block size.=0A=
  (The terminology "medium access command" comes from the SCSI specs.)=0A=
* Use that function instead of "scmd->request->cmd_type =3D=3D REQ_TYPE_FS"=
=0A=
  in the mpt3sas driver.=0A=
* Do not modify sd_done().=0A=
=0A=
This approach has the advantage that the mpt3sas firmware bug workaround=0A=
does not slow down the hot path of the sd driver when another LLD than=0A=
mpt3sas is used.=0A=
=0A=
Bart.=0A=
=0A=
