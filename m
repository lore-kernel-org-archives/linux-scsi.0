From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi_proto.h: ATA_32 added for ata pass-thru(32).
Date: Fri, 16 Jun 2017 15:27:24 +0000
Message-ID: <1497626842.2621.7.camel@wdc.com>
References: <1497526164-7432-1-git-send-email-dn3108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:65353 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752552AbdFPP12 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jun 2017 11:27:28 -0400
In-Reply-To: <1497526164-7432-1-git-send-email-dn3108@gmail.com>
Content-Language: en-US
Content-ID: <3925A24E10119944B799E416CC86BF7B@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "dn3108@gmail.com" <dn3108@gmail.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2017-06-15 at 20:29 +0900, Minwoo Im wrote:
> SAT-4(SCSI/ATA Translation Standard) supports a ATA PASS-THROUGH(32)
> SCSI command. It uses 7Fh as a operation code which means
> variable-length CDB.
> It would be great if kernel supports an ata pass-thru(32) command.
> Prior to development of ata pass-through in libata level,
> the definition of it should be added first.
>=20
> Signed-off-by: Minwoo Im <dn3108@gmail.com>
> ---
>  include/scsi/scsi_proto.h |    1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
> index ce78ec8..1eb4efd 100644
> --- a/include/scsi/scsi_proto.h
> +++ b/include/scsi/scsi_proto.h
> @@ -164,6 +164,7 @@
>  #define WRITE_SAME_32	      0x0d
> =20
>  /* Values for T10/04-262r7 */
> +#define	ATA_32		      0x7F	/* 32-byte pass-thru */
>  #define	ATA_16		      0x85	/* 16-byte pass-thru */
>  #define	ATA_12		      0xa1	/* 12-byte pass-thru */

Hello Minwoo,

In the Linux kernel we do not add such definitions separately but we
only add such definitions together with the code that uses the newly
introduced symbolic name.

Regarding the above patch, to keep the definitions consistent, please
use VARIABLE_LENGTH_CMD as a symbolic name for 0x7F and also add the
following definition below "/* values for variable length command */":

#define ATA_32 0x1ff0

Thanks,

Bart.=20
