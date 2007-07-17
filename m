From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: block/bsg.c
Date: Mon, 16 Jul 2007 20:03:57 -0700
Message-ID: <20070716200357.15dd8c64.akpm@linux-foundation.org>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>
	<469C11B1.8000302@garzik.org>
	<20070716175347.bea345dd.akpm@linux-foundation.org>
	<469C1423.3090908@garzik.org>
	<20070716180908.e15325bd.akpm@linux-foundation.org>
	<469C1FA9.3090809@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37585 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753820AbXGQDEV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 23:04:21 -0400
In-Reply-To: <469C1FA9.3090809@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 16 Jul 2007 21:47:21 -0400 Jeff Garzik <jeff@garzik.org> wrote:

> hrm.  uninitialized_var(x) does not silence the warning, on my compil=
er:
>=20
> [jgarzik@pretzel misc-2.6]$ rpm -q gcc
> gcc-4.1.2-13.fc6
>=20
> @@ -1358,6 +1358,8 @@ udf_load_partition(struct super_block *sb, kern=
el_lb_addr
>             	{
>             		kernel_lb_addr ino;
> + 			uninitialized_var(ino.partitionReferenceNum);
> +
>                	if (!UDF_SB_LASTBLOCK(sb))

[erk, wordwrapping!]

> still yields
>=20
> fs/udf/super.c: In function =E2=80=98udf_fill_super=E2=80=99:
> fs/udf/super.c:1359: warning: =E2=80=98ino.partitionReferenceNum=E2=80=
=99 may be used=20
> uninitialized in this function
>=20

We use it as

-	int foo;
+	int uninitialized_var(foo);

so what you have is effectively


		kernel_lb_addr ino;

		ino.partitionReferenceNum =3D ino.partitionReferenceNum;


so it still warns.



Hopefully this will work:

		kernel_lb_addr uninitialized_var(ino);

=09
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
