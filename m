From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH V2 06/24] aacraid: Reworked scsi command submission path
Date: Thu, 26 Jan 2017 18:52:53 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A63C58932@avsrvexchmbx2.microsemi.net>
References: <20170125180111.25401-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170125180111.25401-7-RaghavaAditya.Renukunta@microsemi.com>
 <20170126090530.GH3591@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0082.outbound.protection.outlook.com ([104.47.34.82]:33821
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752559AbdAZSyv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Jan 2017 13:54:51 -0500
In-Reply-To: <20170126090530.GH3591@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dave Carroll <david.carroll@microsemi.com>, Gana Sridaran <gana.sridaran@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>

Hi Johannes,

> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Thursday, January 26, 2017 1:06 AM
> To: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> Cc: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org; Dave Carroll <david.carroll@microsemi.com>; Gana
> Sridaran <gana.sridaran@microsemi.com>; Scott Benesh
> <scott.benesh@microsemi.com>
> Subject: Re: [PATCH V2 06/24] aacraid: Reworked scsi command submission
> path
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Wed, Jan 25, 2017 at 10:00:53AM -0800, Raghava Aditya Renukunta wrote:
> > Moved the READ and WRITE switch cases to the top. Added a  default
> > case to the switch case and replaced duplicate scsi result value with a
> > macro.
>=20
> Can you please explain why you did the changes as well?

The idea is that since most of commands that we care performance wise, are
read and writes, we wanted to process them first and then the others later.

Internally as I understood it , a switch case is either converted into a ju=
mp
Table or a bunch of if else conditions, so placing the often used read,  wr=
ite=20
cases at top was an effort in optimization. =20

Regards,
Raghava Aditya
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
