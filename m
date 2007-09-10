From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH ver2 2/5] scsi_error: Refactoring scsi_error to facilitate in synchronous REQUEST_SENSE
Date: Mon, 10 Sep 2007 14:15:49 -0700
Message-ID: <20070910211549.GA14439@one-eyed-alien.net>
References: <46E59760.9020705@panasas.com> <46E59C7D.4040701@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:47300
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752208AbXIJVY1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Sep 2007 17:24:27 -0400
Content-Disposition: inline
In-Reply-To: <46E59C7D.4040701@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@suse.de>, Russell King <rmk@arm.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 10, 2007 at 10:35:25PM +0300, Boaz Harrosh wrote:
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 20a72aa..a02400c 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -590,42 +590,23 @@ static void scsi_abort_eh_cmnd(struct scsi_cmnd *sc=
md)
>  }
> =20
>  /**
> - * scsi_send_eh_cmnd  - submit a scsi command as part of error recory
> + * scsi_eh_prep_cmnd  - Save a scsi command info as part of error recory
>   * @scmd:       SCSI command structure to hijack
> - * @cmnd:       CDB to send
> + * @ses:        structure to save restore information
> + * @cmnd:       CDB to send. Can be NULL if no new cmnd is needed
>   * @cmnd_size:  size in bytes of @cmnd
> - * @timeout:    timeout for this request
> - * @copy_sense: request sense data if set to 1
> + * @copy_sense: size of sense data to copy. or 0
>   *
> - * This function is used to send a scsi command down to a target device
> - * as part of the error recovery process.  If @copy_sense is 0 the comma=
nd
> - * sent must be one that does not transfer any data.  If @copy_sense is 1
> - * the command must be REQUEST_SENSE and this functions copies out the
> - * sense buffer it got into @scmd->sense_buffer.
> - *
> - * Return value:
> - *    SUCCESS or FAILED or NEEDS_RETRY
> + * This function is used to save a scsi command information before re-ex=
ecution
> + * as part of an error recovery process.  If @copy_sense is 0 the command
> + * given must be one that does not transfer any data.  If @copy_sense !=
=3D 0
> + * the command should be NULL and this functions sets up the cmnd and
> + * command buffers to be read into @scmd->sense_buffer.
>   **/
> -static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
> -			     int cmnd_size, int timeout, unsigned copy_sense)
> +void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
> +			unsigned char *cmnd, int cmnd_size, unsigned copy_sense)

I'm not terribly keen on the naming of copy_sense, tho I see what you're
trying to do.  A better name and better comments about what it means when
!=3D 0 would fix this.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

My mother not mind to die for stoppink Windows NT!  She is rememberink=20
Stalin!
					-- Pitr
User Friendly, 9/6/1998

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFG5bQFHL9iwnUZqnkRAuiVAJwMl1KEkT8LDJymr5sp5EtBil7O+ACfUrQb
qQdoAfQd0c1a3IDq1aXh0MY=
=QC49
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
