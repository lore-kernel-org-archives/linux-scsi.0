From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [Scst-devel] [ANNOUNCE]: Comparison of features sets between
	different SCSI targets (SCST, STGT, IET, LIO)
Date: Mon, 6 Apr 2009 21:01:47 +0200
Message-ID: <e2e108260904061201y1e73d1chca088e6f20b1ddf6@mail.gmail.com>
References: <49D7AD54.4060408@vlnb.net> <49D7B122.50103@wpkg.org>
	 <e2e108260904050429lcd1870ag6656f36a170ccab3@mail.gmail.com>
	 <49D9D9A0.40106@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757923AbZDFTCO@vger.kernel.org>
In-Reply-To: <49D9D9A0.40106@wpkg.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@hansenpartnership.com>, scst-devel <scst-devel@lists.sourceforge.net>, stgt@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 6, 2009 at 12:29 PM, Tomasz Chmielewski <mangoo@wpkg.org> w=
rote:
> The target is running Debian Lenny 64bit userspace on an Intel Celero=
n
> 2.93GHz CPU, 2 GB RAM.
>
> Initiator is running Debian Etch 64 bit userspace, open-iscsi 2.0-869=
, Intel
> Xeon 3050/2.13GHz, 8 GB RAM.
>
>
> Each test was repeated 6 times, "sync" was made and caches were dropp=
ed on
> both sides before each test was started.
>
> dd parameters were like below, so 6.6 GB of data was read each time:
>
> dd if=3D/dev/sdag of=3D/dev/null bs=3D64k count=3D100000
>
>
> Data was read from two block devices:
> - /dev/md0, which is RAID-1 on two ST31500341AS 1.5 TB drives
> - encrypted dm-crypt device which is on top of /dev/md0
>
> Encrypted device was created with the following additional options pa=
ssed to
> cryptsetup
> (it provides the most performance on systems where CPU is a bottlenec=
k, but
> with decreased
> security when compared to default options):
>
> -c aes-ecb-plain -s 128
>
>
> Generally, CPU on the target was a bottleneck, so I also tested the l=
oad on
> target.
>
>
> md0, crypt columns - averages from dd
> us, sy, id, wa - averages from vmstat
>
>
> 1. Disk speeds on the target
>
> Raw performance: 102.17 MB/s
> Raw performance (encrypted): =A050.21 MB/s
>
>
> 2. Read-ahead on the initiator: 256 (default); md0, crypt - MB/s
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0md0 =A0 us =A0sy =A0=
id =A0wa =A0| crypt =A0 us =A0sy =A0id =A0wa
> =A0STGT =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A050.63 =A0 4% 45% 1=
8% 33% | 32.52 =A0 =A03% 62% 16% 19%
> SCST (debug + no patches) 43.75 =A0 0% 26% 30% 44% | 42.05 =A0 =A00% =
84% =A01% 15%
> SCST (fullperf + patches) 45.18 =A0 0% 25% 33% 42% | 44.12 =A0 =A00% =
81% =A02% 17%

Hello Tomasz,

How is it possible that for this test the read performance through
STGT (50.63 MB/s) was higher than the read performance on the target
(50.21 MB/s) ? Are you sure that all read buffers were flushed before
this test was started ?

Bart.
