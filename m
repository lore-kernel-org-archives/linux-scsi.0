From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [gregoire.favre@gmail.com: What breaks aic7xxx in post
	2.6.12-rc2 ?]
Date: Mon, 16 May 2005 11:33:32 -0500
Message-ID: <1116261212.5040.23.camel@mulgrave>
References: <20050516152607.GA27989@infradead.org>
	 <1116258401.5040.14.camel@mulgrave>  <20050516155409.GE9558@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:16302 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261735AbVEPQdg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 12:33:36 -0400
In-Reply-To: <20050516155409.GE9558@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Gr=E9goire?= Favre <gregoire.favre@gmail.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-05-16 at 17:54 +0200, Gr=E9goire Favre wrote:
> What's DV ?

Domain Validation ... it's a way of probing the SCSI bus to check that
the transport parameters for the device are correct (and that nothing o=
n
the bus is interfering with the transmissions).

> Host: scsi1 Channel: 00 Id: 01 Lun: 00
>   Vendor: TOSHIBA  Model: DVD-ROM SD-M1201 Rev: 1R08
>   Type:   CD-ROM                           ANSI SCSI revision: 02

Aha, this wouldn't be the first DVD to screw up in domain validation.
The first such problem was because the device lied about having an echo
buffer ... I suspect that may be the case here too.

The initial fix was just to disbelieve the device if it didn't support
ppr.  Could you try the attached?  It expands the check to disbelieve
the return for all CD type devices.

Thanks,

James

--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -799,7 +799,7 @@ spi_dv_device_internal(struct scsi_reque
 	 * do the SPI pattern write tests */
=20
 	len =3D 0;
-	if (sdev->ppr)
+	if (sdev->ppr && sdev->type !=3D TYPE_ROM)
 		len =3D spi_dv_device_get_echo_buffer(sreq, buffer);
=20
  retry:


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
