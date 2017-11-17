From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 2/3] scsi: aacraid: Perform initialization reset only
 once
Date: Fri, 17 Nov 2017 22:11:56 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A9D8FDEB7@avsrvexchmbx2.microsemi.net>
References: <20171117211455.29031-1-gpiccoli@linux.vnet.ibm.com>
 <20171117211455.29031-3-gpiccoli@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0076.outbound.protection.outlook.com ([104.47.38.76]:40232
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S936663AbdKQWMF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Nov 2017 17:12:05 -0500
In-Reply-To: <20171117211455.29031-3-gpiccoli@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dave Carroll <david.carroll@microsemi.com>, "gpiccoli@protonmail.ch" <gpiccoli@protonmail.ch>



> -----Original Message-----
> From: Guilherme G. Piccoli [mailto:gpiccoli@linux.vnet.ibm.com]
> Sent: Friday, November 17, 2017 1:15 PM
> To: dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>; linux-
> scsi@vger.kernel.org
> Cc: gpiccoli@linux.vnet.ibm.com; Dave Carroll
> <david.carroll@microsemi.com>; Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>; gpiccoli@protonmail.ch
> Subject: [PATCH 2/3] scsi: aacraid: Perform initialization reset only onc=
e
>=20
> EXTERNAL EMAIL
>=20
>=20
> Currently the driver accepts two ways of requesting an initialization
> reset on the adapter: by passing aac_reset_devices module parameter,
> or the generic kernel parameter reset_devices.
>=20
> It's working as intended...but if we end up reaching a scsi hang and
> the scsi EH mechanism takes place, aacraid performs resets as part of
> the scsi error recovery procedure. These EH routines might reinitialize
> the device, and if we have provided some of the reset parameters in the
> kernel command-line, we again perform an "initialization" reset.
>=20
> So, to avoid this duplication of resets in case of scsi EH path, this
> patch adds a field to aac_dev struct to keep per-adapter track of the
> init reset request - once it's done, we set it to false and don't
> proactively reset anymore in case of reinitializations.
>=20
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
> ---

Reviewed-by :Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.co=
m>
