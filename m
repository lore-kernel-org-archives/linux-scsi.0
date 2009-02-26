From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: RFC: Transport identifier
Date: Thu, 26 Feb 2009 15:54:30 +1100
Message-ID: <646765f40902252054t3def25e4j73ccd0192e0be51e@mail.gmail.com>
References: <yq1iqmxg6o4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:53055 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbZBZEyc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Feb 2009 23:54:32 -0500
Received: by rv-out-0506.google.com with SMTP id g37so356168rvb.1
        for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2009 20:54:30 -0800 (PST)
In-Reply-To: <yq1iqmxg6o4.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Feb 26, 2009 at 15:31, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> There are a few cases where it would be useful to know which transpor=
t
> is associated with a scsi_device. =A0For instance when determining wh=
ether
> to send a READ CAPACITY(16) to a device or not:
>
> =A0 =A0static int sd_try_rc16_first(struct scsi_device *sdp)
> =A0 =A0{
> =A0 =A0 =A0 =A0if (scsi_device_transport(sdp) =3D=3D SCSI_TRANSPORT_U=
SB)
> =A0 =A0 =A0 =A0 =A0 return 0; /* Run screaming for the hills */
> =A0 =A0[...]
>
> This patch implements support for a transport identifier in the
> scsi_host. =A0The id defaults to SPI and it is explicitly overridden =
in
> the host templates for FC, SAS, USB, etc. drivers.
>
> It also looks like the availability of this transport id could improv=
e
> the sysfs parsing in lsscsi.
>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

[snip]

> +/* These strings must match the scsi_transport_id enum in scsi.h */
> +static const char * const transport_names[] =3D {
> + =A0 =A0 =A0 "spi", "fc", "sas", "iscsi", "sbp", "usb", "ata",
> +};

=46irstly, this should probably mark which name is for which value. (I
know it's obvious, but it could get confusing if there are ever user
friendly names here.)

[snip]

> +enum scsi_transport_id {
> + =A0 =A0 =A0 SCSI_TRANSPORT_SPI,
> + =A0 =A0 =A0 SCSI_TRANSPORT_FC,
> + =A0 =A0 =A0 SCSI_TRANSPORT_SAS,
> + =A0 =A0 =A0 SCSI_TRANSPORT_ISCSI,
> + =A0 =A0 =A0 SCSI_TRANSPORT_SBP,
> + =A0 =A0 =A0 SCSI_TRANSPORT_USB,
> + =A0 =A0 =A0 SCSI_TRANSPORT_ATA,
> +};

Should there be a comment here pointing out that the names must also
be updated if new items are added?

Thanks,

--=20

Julian Calaby

Email: julian.calaby@gmail.com
=2EPlan: http://sites.google.com/site/juliancalaby/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
