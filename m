From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH 09/28] blk_end_request: changing ps3disk
	(take 3)
Date: Sun, 2 Dec 2007 10:34:56 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712021032490.29349@anakin>
References: <20071130.182810.98558485.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463808512-250639608-1196588096=:29349"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071130.182810.98558485.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: linux-scsi@vger.kernel.org, Linux/PPC Development <linuxppc-dev@ozlabs.org>, jens.axboe@oracle.com, Linux Kernel Development <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, dm-devel@redhat.com, bharrosh@panasas.com
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808512-250639608-1196588096=:29349
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Nov 2007, Kiyoshi Ueda wrote:
> This patch converts ps3disk to use blk_end_request().
                                     ^^^^^^^^^^^^^^^
Patch subject and description are inconsistent with actual change.

> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> ---
>  drivers/block/ps3disk.c |    6 +-----
>  1 files changed, 1 insertion(+), 5 deletions(-)
>=20
> Index: 2.6.24-rc3-mm2/drivers/block/ps3disk.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- 2.6.24-rc3-mm2.orig/drivers/block/ps3disk.c
> +++ 2.6.24-rc3-mm2/drivers/block/ps3disk.c
> @@ -280,11 +280,7 @@ static irqreturn_t ps3disk_interrupt(int
>  	}
> =20
>  	spin_lock(&priv->lock);
> -	if (!end_that_request_first(req, uptodate, num_sectors)) {
> -		add_disk_randomness(req->rq_disk);
> -		blkdev_dequeue_request(req);
> -		end_that_request_last(req, uptodate);
> -	}
> +	__blk_end_request(req, uptodate, num_sectors << 9);
        ^^^^^^^^^^^^^^^^^

With kind regards,
=20
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem =C2=
=B7 Belgium
=20
Phone:    +32 (0)2 700 8453=09
Fax:      +32 (0)2 700 8622=09
E-mail:   Geert.Uytterhoeven@sonycom.com=09
Internet: http://www.sony-europe.com/
 =09
Sony Network and Software Technology Center Europe=09
A division of Sony Service Centre (Europe) N.V.=09
Registered office: Technologielaan 7 =C2=B7 B-1840 Londerzeel =C2=B7 Belg=
ium=09
VAT BE 0413.825.160 =C2=B7 RPR Brussels=09
Fortis Bank Zaventem =C2=B7 Swift GEBABEBB08A =C2=B7 IBAN BE3900138235861=
9
---1463808512-250639608-1196588096=:29349
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


---1463808512-250639608-1196588096=:29349--
