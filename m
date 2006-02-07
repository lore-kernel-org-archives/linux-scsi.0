From: Hannes Reinecke <hare@suse.de>
Subject: spi_dv_device_compare_inquiry() oddity
Date: Tue, 07 Feb 2006 12:45:27 +0100
Message-ID: <43E88857.60605@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55728 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S965030AbWBGLp2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2006 06:45:28 -0500
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 19E4F1D5CA
	for <linux-scsi@vger.kernel.org>; Tue,  7 Feb 2006 12:45:27 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi all,

trying to get my CD-ROM to behave I stumbled across the following:

drivers/scsi/scsi_transport_spi.c:spi_dv_device_compare_inquiry()

spi_dv_device_compare_inquiry(struct scsi_device *sdev, u8 *buffer,
			      u8 *ptr, const int retries)
{
	int r, result;
	const int len =3D sdev->inquiry_len;
	const char spi_inquiry[] =3D {
		INQUIRY, 0, 0, 0, len, 0
	};

	for (r =3D 0; r < retries; r++) {
		memset(ptr, 0, len);

		result =3D spi_execute(sdev, spi_inquiry, DMA_FROM_DEVICE,
				     ptr, len, NULL);
	=09
		if(result || !scsi_device_online(sdev)) {
			scsi_device_set_state(sdev, SDEV_QUIESCE);
			return SPI_COMPARE_FAILURE;
		}

		/* If we don't have the inquiry data already, the
		 * first read gets it */
		if (ptr =3D=3D buffer) {
			ptr +=3D len;
			--r;
			continue;
		}

		if (memcmp(buffer, ptr, len) !=3D 0)
			/* failure */
			return SPI_COMPARE_FAILURE;
	}
	return SPI_COMPARE_SUCCESS;
}

So if the inquiry succeeds we have to retry to check that the inquiry
_really_ succeded? Am I missing some subleties here?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
