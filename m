From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH -mm] DC395x SCSI driver: Shut up uninitialized variable
 build warning
Date: Sun, 02 Sep 2007 16:23:59 -0400
Message-ID: <46DB1BDF.4090100@garzik.org>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i n> <alpine.LFD.0.999.0709030152260.29617@enigma.security.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:40174 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759139AbXIBUYF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Sep 2007 16:24:05 -0400
In-Reply-To: <alpine.LFD.0.999.0709030152260.29617@enigma.security.iitk.ac.in>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satyam Sharma <satyam@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>, Oliver Neukum <oliver@neukum.name>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>

Satyam Sharma wrote:
> drivers/scsi/dc395x.c: In function =91dc395x_init_one=92:
> drivers/scsi/dc395x.c:4272: warning: =91ptr=92 may be used uninitiali=
zed in this function
>=20
> has been verified to be a bogus warning. Let's shut it up.
>=20
> Signed-off-by: Satyam Sharma <satyam@infradead.org>
>=20
> ---
>=20
>  drivers/scsi/dc395x.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> --- linux-2.6.23-rc4-mm1/drivers/scsi/dc395x.c~fix	2007-09-02 20:57:5=
1.000000000 +0530
> +++ linux-2.6.23-rc4-mm1/drivers/scsi/dc395x.c	2007-09-02 21:10:49.00=
0000000 +0530
> @@ -4269,7 +4269,7 @@ static int __devinit adapter_sg_tables_a
>  	const unsigned srbs_per_page =3D PAGE_SIZE/SEGMENTX_LEN;
>  	int srb_idx =3D 0;
>  	unsigned i =3D 0;
> -	struct SGentry *ptr;
> +	struct SGentry * uninitialized_var(ptr);

=46or things like this, we need to see (perhaps a separate email in the=
=20
same thread) your build details:  config, arch, compiler version, etc.

This warning does not appear on x86 or x86-64 here, with the current=20
version of gcc.  And I'm not so sure we want to be adding these markers=
=20
for older versions of the compiler, or for what is ultimately a=20
temporary [situation | configuration] in the grand scheme of things.

I paid careful attention to my recent set of uninitialized_var() marker=
s=20
(now upstream), making sure that they persisted across several compiler=
=20
versions, ensuring the warning was not a temporary optimizer bug quickl=
y=20
remedied.

I hope to encourage similar diligence in others :)  These markers have=20
the very-real potential downside of hiding bugs, so they should be used=
=20
sparingly.

	Jeff


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
