From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: sort out the ->eh_timed_out mess
Date: Mon, 30 Jan 2017 16:46:00 +0000
Message-ID: <1485794746.2712.5.camel@sandisk.com>
References: <1485778739-29036-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0043.outbound.protection.outlook.com ([104.47.36.43]:62270
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753794AbdA3Qq0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 11:46:26 -0500
In-Reply-To: <1485778739-29036-1-git-send-email-hch@lst.de>
Content-Language: en-US
Content-ID: <B58E87B5545EC041956AA32BDA80BD86@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "hare@suse.de" <hare@suse.de>

On Mon, 2017-01-30 at 13:18 +0100, Christoph Hellwig wrote:
> We originally only supported the methods in the transport_template,
> which led to problems with drivers needing it and having to fake
> up a template.  Then we added it to the host to avoid that issue,
> but because the transport template takes precedence we still have
> various placed that need to hack around it.
>=20
> This series removes the transport_template instance and switches
> everyone to use the host method, similar to how we supply generic
> helpers elsewhere.
>=20
> In addition it removes a bit of cruft in the same area.

Hello Christoph,

Patches 1, 2 and 4 of this series are a real improvement in my opinion.
However, I'm not sure whether patch 3 is the best way to avoid that drivers
have to re-override the transport template timeout handler. Have you
considered to modify the SCSI EH such that the host timeout handler has
priority over the transport timeout handler? I think that would result in
a much smaller patch 3/4.

Thanks,

Bart.=
