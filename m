From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH -mm] IPS SCSI driver: Check return of scsi_add_host()
Date: Sun, 02 Sep 2007 16:32:10 -0400
Message-ID: <46DB1DCA.3050509@garzik.org>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i n> <alpine.LFD.0.999.0709030142490.29617@enigma.security.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:39349 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbXIBUcM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Sep 2007 16:32:12 -0400
In-Reply-To: <alpine.LFD.0.999.0709030142490.29617@enigma.security.iitk.ac.in>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satyam Sharma <satyam@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>, aacraid@adaptec.com, linux-scsi@vger.kernel.org

Satyam Sharma wrote:
> drivers/scsi/ips.c: In function =91ips_register_scsi=92:
> drivers/scsi/ips.c:6869:
> warning: ignoring return value of =91scsi_add_host=92, declared with =
attribute warn_unused_result
>=20
> scsi_add_host() is __must_check, so let's check it's return and clean=
up
> appropriately on errors.
>=20
> Signed-off-by: Satyam Sharma <satyam@infradead.org>
>=20
> ---
>=20
>  drivers/scsi/ips.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> --- linux-2.6.23-rc4-mm1/drivers/scsi/ips.c~fix	2007-09-02 20:21:27.0=
00000000 +0530
> +++ linux-2.6.23-rc4-mm1/drivers/scsi/ips.c	2007-09-02 20:25:58.00000=
0000 +0530
> @@ -6866,7 +6866,12 @@ ips_register_scsi(int index)
>  	sh->max_channel =3D ha->nbus - 1;
>  	sh->can_queue =3D ha->max_cmds - 1;
> =20
> -	scsi_add_host(sh, NULL);
> +	if (scsi_add_host(sh, NULL)) {
> +		IPS_PRINTK(KERN_WARNING, ha->pcidev, "Unable to add SCSI host\n");
> +		free_irq(ha->irq, ha);
> +		scsi_host_put(sh);
> +		return -1;

ACK, as long as you add a comment to this code and the request_irq()=20
failure code:  the oldha/old irq is not restored upon failure, in this=20
function.

That is a pre-existing bug, and not your fault, but your patch=20
"continues in the same buggy tradition" :)  We should at least note the=
=20
=46IXME at each error handling code branch.

Ideally you or somebody should do a detailed analysis to
a) (preferably) get rid of the silly oldha/ double-irq-request weirdnes=
s=20
and make it look like other drivers,
	or,
b) analyze the code and see what it takes to _really_ unwind the error.

Also, I would recommend moving the error handling code to the end of th=
e=20
function and using the standard 'goto' approach for function error=20
handling.  This eliminates the duplicate scsi_host_put() calls upon err=
or.

	Jeff





-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
