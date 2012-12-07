From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH] scsi_ram: a RAM-based SCSI driver
Date: Fri, 7 Dec 2012 13:20:14 +0200
Message-ID: <20121207112014.GA4466@otc-wbsnb-06>
References: <1354725918-14713-1-git-send-email-kirill.shutemov@linux.intel.com>
 <50C06EC3.20002@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50C06EC3.20002@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Stephen Cameron <stephenmcameron@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Matthew Wilcox <willy@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 06, 2012 at 11:09:07AM +0100, Paolo Bonzini wrote:
> Il 05/12/2012 17:45, Kirill A. Shutemov ha scritto:
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >=20
> > This driver is intended to run as fast as possible, hence the options to
> > discard writes and reads. It's designed to let us find latency issues
> > elsewhere in the storage stack (eg filesystem, block layer, scsi layer).
> >=20
> > There are a few different options, controlled through module parameters.
> > The sector size and disc capacity are load-time parameters, but the
> > parameters affecting performance are tweakable at runtime.
> >=20
> > By default, it'll allocate half a gigabyte of RAM to use as a ramdisc;
> > you can change this with the `capacity' module parameter.
>=20
> Is this that much faster than scsi-debug?  The discarding options surely
> can be added there.

scsi_ram is about 9% faster (without fake_rw/throw_away_*) on my machine:

fio job file (slightly modified ssd-test):

[global]
bs=3D4k
ioengine=3Dlibaio
iodepth=3D4
size=3D10g
direct=3D1
runtime=3D60
filename=3D/dev/sdb

[seq-read]
rw=3Dread
stonewall

[rand-read]
rw=3Drandread
stonewall

[seq-write]
rw=3Dwrite
stonewall

[rand-write]
rw=3Drandwrite
stonewall

----------------------

scsi_ram capacity=3D41943040:

Run status group 0 (all jobs):
   READ: io=3D6975.2MB, aggrb=3D119040KB/s, minb=3D119040KB/s, maxb=3D11904=
0KB/s, mint=3D60001msec, maxt=3D60001msec

Run status group 1 (all jobs):
   READ: io=3D7006.8MB, aggrb=3D119579KB/s, minb=3D119579KB/s, maxb=3D11957=
9KB/s, mint=3D60001msec, maxt=3D60001msec

Run status group 2 (all jobs):
  WRITE: io=3D7009.9MB, aggrb=3D119632KB/s, minb=3D119632KB/s, maxb=3D11963=
2KB/s, mint=3D60001msec, maxt=3D60001msec

Run status group 3 (all jobs):
  WRITE: io=3D6919.8MB, aggrb=3D118094KB/s, minb=3D118094KB/s, maxb=3D11809=
4KB/s, mint=3D60001msec, maxt=3D60001msec

Disk stats (read/write):
  sdb: ios=3D3579612/3559798, merge=3D0/0, ticks=3D128180/125565, in_queue=
=3D240098, util=3D77.79%

----------------------

scsi_debug dev_size_mb=3D10240 delay=3D0:

Run status group 0 (all jobs):
   READ: io=3D6393.2MB, aggrb=3D109110KB/s, minb=3D109110KB/s, maxb=3D10911=
0KB/s, mint=3D60000msec, maxt=3D60000msec

Run status group 1 (all jobs):
   READ: io=3D6327.6MB, aggrb=3D107988KB/s, minb=3D107988KB/s, maxb=3D10798=
8KB/s, mint=3D60001msec, maxt=3D60001msec

Run status group 2 (all jobs):
  WRITE: io=3D6473.3MB, aggrb=3D110474KB/s, minb=3D110474KB/s, maxb=3D11047=
4KB/s, mint=3D60001msec, maxt=3D60001msec

Run status group 3 (all jobs):
  WRITE: io=3D6330.5MB, aggrb=3D108037KB/s, minb=3D108037KB/s, maxb=3D10803=
7KB/s, mint=3D60001msec, maxt=3D60001msec

Disk stats (read/write):
  sdb: ios=3D3256653/3272376, merge=3D0/0, ticks=3D54502/54150, in_queue=3D=
101165, util=3D42.09%

--=20
 Kirill A. Shutemov

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQwdDuAAoJEAd+omnVudOMmsUP/0QkaIWSavjw48K6qyvmcXsa
tzzI1sz4iqesYFwfemE49CcEQOYPU7RZJj+Vt4MMEbe5YPY5CUYnxb1JFtDUL0Qm
hO+5EVcuMvM96ljXkIw1Zt0tk2M9IDi81OQweByP5R8YFeubgZP3tNWPr8dCtC4B
GMiQJD7WTSwoc4Gj6DnMX84sbjWChnrJJliqjH/YM6be97T34rwEFY44AzVYCF64
4r4tU1oHeUV290R1D3MLONiPHvQQa+4DHZfcJQsK7PXhFuEEBktXbHWj34lJrjo8
Y2N/unV+ZiiFsAB76JKxvpnOR2QGD8JEl37fg5fPxha96uSv9DlUBaF4oDQVgqCQ
CefJJI4yjG236UsbEOdlAl/oyeNe5hvHJCbpvn6cKtz0EQnSD5ZqrRunSAtT1DhT
DPWmuKIKuVA/XigdkbijICWsBAsKQbnTWQ1/il+EuVfwtilOTXsS+dQYKzGM7fVh
EqvoY1iOL3qq0dRPRaF05kiEYnd32e8D5tiRBc1C2YN2kx5hie0hd7OZWw6Lgb2M
qO20lntKXICQuHEGjdNoL6c4lIbHWNxnWLL44VBD+iMzU64UI6sEGFBQRrGQd9Gs
QDZ2UazZeAvnqUh58myrQxwZ3I42o61oQYx6YJx2wi2pajTT/3ftj1PL3s1GOMp6
yzpPoB3SDk/raXZFY3yM
=RR8t
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
