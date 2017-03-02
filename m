From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [bug report] scsi: aacraid: Reorder Adapter status check
Date: Thu, 2 Mar 2017 19:39:38 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A4EF519CC@avsrvexchmbx1.microsemi.net>
References: <20170227153131.GA24809@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0071.outbound.protection.outlook.com ([104.47.37.71]:46080
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751553AbdCBXRM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Mar 2017 18:17:12 -0500
In-Reply-To: <20170227153131.GA24809@mwanda>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Dan Carpenter
> Sent: Monday, February 27, 2017 8:32 AM
> To: Raghava Aditya Renukunta
> Cc: linux-scsi@vger.kernel.org
> Subject: [bug report] scsi: aacraid: Reorder Adapter status check
>=20
>=20
> The patch c421530bf848: "scsi: aacraid: Reorder Adapter status check"
> from Feb 16, 2017, leads to the following static checker warning:
>=20
>         drivers/scsi/aacraid/src.c:471 aac_src_check_health()
>         warn: was shift intended here '(status > 16)'
>=20
> drivers/scsi/aacraid/src.c
>    464           */
>    465          return 0;
>    466
>    467  err_out:
>    468          return -1;
>    469
>    470  err_blink:
>    471          return (status > 16) & 0xFF;
>                         ^^^^^^^^^^^^^^^^^^^ Issue #1:  This is obviously =
a typo.

Agreed, will submit a correction ... should be >>
>=20
>    472  }
>=20
> Issue #2:  The caller checks for if the return is greater than 2.  It
>            never is.  We can remove this dead code.

That would be the blink led returned from the controller which would be gre=
ater than 2

>=20
> Issue #3:  The caller passes "bled" to aac_send_iop_reset() which
>            ignores it.  What's up with that?  Either it's a bug or we
>            should delete that dead code.

When we have gotten all caught up, we will be printing the blink led as par=
t of the iop_reset

Thanks, -Dave
>=20
> regards,
> dan carpenter
