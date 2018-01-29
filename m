From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH 1/3] scsi: aacraid: Implement DropIO sync command
Date: Mon, 29 Jan 2018 16:34:24 +0000
Message-ID: <8b9630272bbb43ce9cc83996472a7ef8@microsemi.com>
References: <20180120010157.22674-1-RaghavaAditya.Renukunta@microsemi.com>
 <20180120010157.22674-2-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0059.outbound.protection.outlook.com ([104.47.37.59]:47712
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751072AbeA2Qez (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 11:34:55 -0500
In-Reply-To: <20180120010157.22674-2-RaghavaAditya.Renukunta@microsemi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Scott Benesh <scott.benesh@microsemi.com>, Tom White <tom.white@microsemi.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

> -----Original Message-----
> From: Raghava Aditya Renukunta
> [mailto:RaghavaAditya.Renukunta@microsemi.com]
> Sent: Friday, January 19, 2018 6:02 PM
> To: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org
> Cc: Scott Benesh <scott.benesh@microsemi.com>; Tom White
> <tom.white@microsemi.com>; dl-esc-Aacraid Linux Driver
> <aacraid@microsemi.com>; Guilherme G . Piccoli
> <gpiccoli@linux.vnet.ibm.com>; Bart Van Assche <Bart.VanAssche@wdc.com>
> Subject: [PATCH 1/3] scsi: aacraid: Implement DropIO sync command
>=20
> IOP_RESET takes longer time to complete, if controller is in a state wher=
e we
> can bring it back with init struct, controller DropIO sync command is
> implemented.
>=20
>  - If controller is faulted perform standard IOP_RESET in aac_srcv_init.
>  - If controller is not faulted get adapter properties and extended
>    properties.
>  - Update the sa_firmware variable and determine if DropIO request is
>    supported.
>  - Issue DropIO request, and get the number of outstanding commands.
>  - If all commands are complete with success (CT_OK), consider IOP_RESET
>    is complete.
>  - If any commands timeout, Perform the IOP_RESET.
>=20
> Signed-off-by: Prasad B Munirathnam <prasad.munirathnam@microsemi.com>
> Signed-off-by: Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@microsemi.com>
> ---
>  drivers/scsi/aacraid/aacraid.h |   4 +
>  drivers/scsi/aacraid/src.c     | 167
> +++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 163 insertions(+), 8 deletions(-)

Reviewed-by: Dave Carroll <david.carroll@microsemi.com>
