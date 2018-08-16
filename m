From: Jeffrey Lien <Jeff.Lien@wdc.com>
Subject: RE: [PATCH] Performance Improvement in CRC16 Calculations.
Date: Thu, 16 Aug 2018 14:02:41 +0000
Message-ID: <SN1PR04MB1824A5944E0428AC84B62886EA3E0@SN1PR04MB1824.namprd04.prod.outlook.com>
References: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com>
 <20180810201601.GA80850@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180810201601.GA80850@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, David Darrington <david.darrington@wdc.com>, Jeff Furlong <jeff.furlong@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Eric,
We did not test the slice by 4 or 8 tables.  I'm not sure of  the value of =
doing that since the slice by 16 will provide the best performance gain.   =
If I'm missing anything here, please let me know.  =20

I'm working on a new version of the patch based on the feedback from others=
 and will also change the pointer variables to start with p and fix the ind=
enting you mentioned below in the new version of the patch. =20

Thanks

Jeff Lien

-----Original Message-----
From: Eric Biggers [mailto:ebiggers@kernel.org]=20
Sent: Friday, August 10, 2018 3:16 PM
To: Jeffrey Lien <Jeff.Lien@wdc.com>
Cc: linux-kernel@vger.kernel.org; linux-crypto@vger.kernel.org; linux-block=
@vger.kernel.org; linux-scsi@vger.kernel.org; herbert@gondor.apana.org.au; =
tim.c.chen@linux.intel.com; martin.petersen@oracle.com; David Darrington <d=
avid.darrington@wdc.com>; Jeff Furlong <jeff.furlong@wdc.com>
Subject: Re: [PATCH] Performance Improvement in CRC16 Calculations.

On Fri, Aug 10, 2018 at 02:12:11PM -0500, Jeff Lien wrote:
> This patch provides a performance improvement for the CRC16=20
> calculations done in read/write workloads using the T10 Type 1/2/3=20
> guard field.  For example, today with sequential write workloads (one=20
> thread/CPU of IO) we consume 100% of the CPU because of the CRC16=20
> computation bottleneck.  Today's block devices are considerably=20
> faster, but the CRC16 calculation prevents folks from utilizing the=20
> throughput of such devices.  To speed up this calculation and expose=20
> the block device throughput, we slice the old single byte for loop into a=
 16 byte for loop, with a larger CRC table to match.  The result has shown =
5x performance improvements on various big endian and little endian systems=
 running the 4.18.0 kernel version.
>=20
> FIO Sequential Write, 64K Block Size, Queue Depth 64
> BE Base Kernel:        bw=3D201.5 MiB/s
> BE Modified CRC Calc:  bw=3D968.1 MiB/s
> 4.80x performance improvement
>=20
> LE Base Kernel:        bw=3D357 MiB/s
> LE Modified CRC Calc:  bw=3D1964 MiB/s
> 5.51x performance improvement
>=20
> FIO Sequential Read, 64K Block Size, Queue Depth 64
> BE Base Kernel:        bw=3D611.2 MiB/s
> BE Modified CRC calc:  bw=3D684.9 MiB/s
> 1.12x performance improvement
>=20
> LE Base Kernel:        bw=3D797 MiB/s
> LE Modified CRC Calc:  bw=3D2730 MiB/s
> 3.42x performance improvement

Did you also test the slice-by-4 (requires 2048-byte table) and slice-by-8 =
(requires 4096-byte table) methods?  Your proposal is slice-by-16 (requires=
 8192-byte table); the original was slice-by-1 (requires 512-byte table).

>  __u16 crc_t10dif_generic(__u16 crc, const unsigned char *buffer,=20
> size_t len)  {
> -	unsigned int i;
> +	const __u8 *i =3D (const __u8 *)buffer;
> +	const __u8 *i_end =3D i + len;
> +	const __u8 *i_last16 =3D i + (len / 16 * 16);

'i' is normally a loop counter, not a pointer.
Use 'p', 'p_end', and 'p_last16'.

> =20
> -	for (i =3D 0 ; i < len ; i++)
> -		crc =3D (crc << 8) ^ t10_dif_crc_table[((crc >> 8) ^ buffer[i]) & 0xff=
];
> +	for (; i < i_last16; i +=3D 16) {
> +		crc =3D t10_dif_crc_table[15][i[0] ^ (__u8)(crc >>  8)] ^
> +		t10_dif_crc_table[14][i[1] ^ (__u8)(crc >>  0)] ^
> +		t10_dif_crc_table[13][i[2]] ^
> +		t10_dif_crc_table[12][i[3]] ^
> +		t10_dif_crc_table[11][i[4]] ^
> +		t10_dif_crc_table[10][i[5]] ^
> +		t10_dif_crc_table[9][i[6]] ^
> +		t10_dif_crc_table[8][i[7]] ^
> +		t10_dif_crc_table[7][i[8]] ^
> +		t10_dif_crc_table[6][i[9]] ^
> +		t10_dif_crc_table[5][i[10]] ^
> +		t10_dif_crc_table[4][i[11]] ^
> +		t10_dif_crc_table[3][i[12]] ^
> +		t10_dif_crc_table[2][i[13]] ^
> +		t10_dif_crc_table[1][i[14]] ^
> +		t10_dif_crc_table[0][i[15]];
> +	}

Please indent this properly.

		crc =3D t10_dif_crc_table[15][i[0] ^ (__u8)(crc >>  8)] ^
		      t10_dif_crc_table[14][i[1] ^ (__u8)(crc >>  0)] ^
		      t10_dif_crc_table[13][i[2]] ^
		      t10_dif_crc_table[12][i[3]] ^
		      t10_dif_crc_table[11][i[4]] ^
		      ...

- Eric
