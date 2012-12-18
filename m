From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH v2 0/5] Multiqueue virtio-scsi, and API for piecewise buffer submission
Date: Tue, 18 Dec 2012 23:18:22 +0100
Message-ID: <96853954.7ghLePd55F@donald.sf-tec.de>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1568222.CrAWlCispQ"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gaowanlong@cn.fujitsu.com, hutao@cn.fujitsu.com, linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org, mst@redhat.com, rusty@rustcorp.com.au, asias@redhat.com, stefanha@redhat.com, nab@linux-iscsi.org
List-Id: linux-scsi@vger.kernel.org


--nextPart1568222.CrAWlCispQ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

Paolo Bonzini wrote:
> Hi all,
> 
> this series adds multiqueue support to the virtio-scsi driver, based
> on Jason Wang's work on virtio-net.  It uses a simple queue steering
> algorithm that expects one queue per CPU.  LUNs in the same target always
> use the same queue (so that commands are not reordered); queue switching
> occurs when the request being queued is the only one for the target.
> Also based on Jason's patches, the virtqueue affinity is set so that
> each CPU is associated to one virtqueue.
> 
> I tested the patches with fio, using up to 32 virtio-scsi disks backed
> by tmpfs on the host.  These numbers are with 1 LUN per target.
> 
> FIO configuration
> -----------------
> [global]
> rw=read
> bsrange=4k-64k
> ioengine=libaio
> direct=1
> iodepth=4
> loops=20
> 
> overall bandwidth (MB/s)
> ------------------------
> 
> # of targets    single-queue    multi-queue, 4 VCPUs    multi-queue, 8 VCPUs
> 1                  540               626                     599
> 2                  795               965                     925
> 4                  997              1376                    1500
> 8                 1136              2130                    2060
> 16                1440              2269                    2474
> 24                1408              2179                    2436
> 32                1515              1978                    2319
> 
> (These numbers for single-queue are with 4 VCPUs, but the impact of adding
> more VCPUs is very limited).
> 
> avg bandwidth per LUN (MB/s)
> ----------------------------
> 
> # of targets    single-queue    multi-queue, 4 VCPUs    multi-queue, 8 VCPUs
> 1                  540               626                     599
> 2                  397               482                     462
> 4                  249               344                     375
> 8                  142               266                     257
> 16                  90               141                     154
> 24                  58                90                     101
> 32                  47                61                      72

Is there an explanation why 8x8 is slower then 4x8 in both cases? 8x1 and 8x2 
being slower than 4x1 and 4x2 is more or less expected, but 8x8 loses against 
4x8 while 8x4 wins against 4x4 and 8x16 against 4x16.

Eike
--nextPart1568222.CrAWlCispQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAlDQ67kACgkQXKSJPmm5/E5p4gCfaexpM+J/d7NZp3C7uEbaYEut
B4AAnAxvPx0S7vRP7+uQKiH8HeAQLMQH
=H3A1
-----END PGP SIGNATURE-----

--nextPart1568222.CrAWlCispQ--
