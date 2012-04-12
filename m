From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] scsi: memory leak with 1MB tape I/O
Date: Thu, 12 Apr 2012 21:08:09 +0300 (EEST)
Message-ID: <alpine.LNX.2.00.1204122102250.4802@kai.makisara.local>
References: <4F85ADE1.30803@gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811327-1725249988-1334254098=:4802"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F85ADE1.30803@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Jeffery <dhjeffery@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811327-1725249988-1334254098=:4802
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Apr 2012, David Jeffery wrote:

> There is a memory leak in the st driver when sending large enough reads=
 or
> writes using st's direct I/O path.  As part of mapping the application'=
s
> memory, a buffer to hold page pointers is allocated and the count of ma=
pped
> pages is stored in field do_dio.  A non-zero do_dio marks that direct I=
/O is
> in use.
>=20
> But do_dio is only 1 byte in size.  Mapping 256 4k pages overflows
> do_dio and causes it to be set to 0, like direct I/O option was not
> used.  When the I/O completes, the buffer to hold the page pointers is
> not freed, and the page counts of the mapped pages are not reduced.
> Every I/O of this size then leaks memory.
>=20
> The size of do_dio needs to be increased to prevent it wrapping around.
>=20
> signed-off-by: David Jeffery <djeffery@redhat.com>
> ---
>=20
> --- a/drivers/scsi/st.h	2012-04-10 13:21:30.000000000 -0400
> +++ b/drivers/scsi/st.h	2012-04-10 14:55:43.000000000 -0400
> @@ -35,8 +35,8 @@
>  /* The tape buffer descriptor. */
>  struct st_buffer {
>  	unsigned char dma;	/* DMA-able buffer */
> -	unsigned char do_dio;   /* direct i/o set up? */
>  	unsigned char cleared;  /* internal buffer cleared after open? */
> +	unsigned short do_dio;  /* direct i/o set up? */
>  	int buffer_size;
>  	int buffer_blocks;
>  	int buffer_bytes;

Acked-by: Kai M=C3=A4kisara <kai.makisara@kolumbus.fi>

Thanks,
Kai
---1463811327-1725249988-1334254098=:4802--
