From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi_devinfo: fixup string compare
Date: Fri, 4 Aug 2017 16:38:05 +0000
Message-ID: <1501864684.2757.16.camel@wdc.com>
References: <1501839625-93492-1-git-send-email-hare@suse.de>
         <1501860744.2757.3.camel@wdc.com>
         <c656a810-dbcc-4f1a-5d59-128496af531f@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:58181 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752669AbdHDQix (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 12:38:53 -0400
In-Reply-To: <c656a810-dbcc-4f1a-5d59-128496af531f@suse.de>
Content-Language: en-US
Content-ID: <B116CFEE2D0DB74D8E31382B7D412DE8@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

On Fri, 2017-08-04 at 18:28 +0200, Hannes Reinecke wrote:
> Well, maybe; however, the current logic fails to match the entry
>=20
> 	{"HITACHI", "OPEN-", "*", BLIST_REPORTLUN2},
>=20
> against the 'real' name, which is "HITACHI" "OPEN-V".
> And for some reason we have far more customer using Hitachi arrays than
> using scanner of dubious provenance with no Vendor (which is the real
> bug if you ask me...)

Hello Hannes,

So for some entries in the table a prefix match should be performed (e.g. t=
he
model string for the Hitachi entry) but for other entries (e.g. the scanner
entry) an exact match should be performed on the vendor name? If so, how ab=
out
one of the following two approaches:
* Adding ".*" at the end of the entries in the table for which a prefix mat=
ch
  is sufficient and to change scsi_dev_info_list_find() such that it perfor=
ms
  a regex match instead of an exact match or a prefix match.
* Performing an exact match on the vendor name and a prefix match on the mo=
del
  name.

Thanks,

Bart.=
