From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] use one-element sg list in scsi_send_eh_cmnd
Date: Fri, 3 Nov 2006 18:13:16 +0100
Message-ID: <200611031813.21938.eike-kernel@sf-tec.de>
References: <20061104190421.GA23477@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1821029.6s1dYsVbgy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:35275 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S932763AbWKFHNl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Nov 2006 02:13:41 -0500
In-Reply-To: <20061104190421.GA23477@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

--nextPart1821029.6s1dYsVbgy
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Christoph Hellwig wrote:
> scsi_send_eh_cmnd is the last user of non-sg commands currently.
> This patch switches it to a one-element SG list.  Also updates the
> kerneldoc comment for scsi_send_eh_cmnd to reflect reality while we're
> at it.
>
> Test on my mptsas card, but this should get testing with as many
> drivers as possible.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: scsi-misc-2.6/drivers/scsi/scsi_error.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/scsi_error.c	2006-10-30
> 17:00:23.000000000 +0100 +++
> scsi-misc-2.6/drivers/scsi/scsi_error.c	2006-11-04 17:30:33.000000000 +0100
> @@ -453,9 +453,18 @@
>  }
>
>  /**
> - * scsi_send_eh_cmnd  - send a cmd to a device as part of error recovery.
> - * @scmd:	SCSI Cmd to send.
> - * @timeout:	Timeout for cmd.
> + * scsi_send_eh_cmnd  - submit a scsi command as part of error recory
> + * @scmd:       SCSI command structure to hijack
> + * @cmnd:       CDB to send
> + * @cmnd_size:  size if bytes of @cmnd
                         ^
"in"?
> + * @timeout:    timeout for this request
> + * @copy_sense: request sense data if set to 1
> + *
> + * This function is used to send a scsi command down to a target device
> + * as part of the error recovery process.  If @copy_sense is 0 the command
> + * sent must be one that does not transfer any data.  If @copy_sense is 1
> + * the command must be REQUEST_SENSE and this functions copies out the
> + * sense buffer it got into @scmd->sense_buffer.
>   *
>   * Return value:
>   *    SUCCESS or FAILED or NEEDS_RETRY

Eike

--nextPart1821029.6s1dYsVbgy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBFS3ixXKSJPmm5/E4RAlcNAKCL2XWQptrBMuDHJKmsQ5wg07DFlwCfZC9f
UdWtyexrasgW4pXGZ32u4XU=
=LlNI
-----END PGP SIGNATURE-----

--nextPart1821029.6s1dYsVbgy--
